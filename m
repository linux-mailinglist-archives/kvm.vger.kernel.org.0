Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39B94AF765
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbiBIRAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbiBIRAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:00:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53D98C0613C9
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5pN9Ao8qux5sDas/M+PXtuDF/FNADkM/NosE28cGRmQ=;
        b=Yz+pUOdNkGEthp6fWGzp+nyXsXigny8Q8AalMSBKoAvubbd+CHTw7GQXzcpi3FWvJEXgVN
        Wr++tAPY4+eVRwUCVdnbI7MdY8NaVhn1oORxzJ4tLmL3sI+A6HMTj1w4wF5ngRfSBmEULr
        7q4NOej05I2F+9Hz9DLhCOb3tulOl+4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-1lHF9GKiPH--L8ThemyFVA-1; Wed, 09 Feb 2022 12:00:30 -0500
X-MC-Unique: 1lHF9GKiPH--L8ThemyFVA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74C0F1091DA1;
        Wed,  9 Feb 2022 17:00:29 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BAA27CD66;
        Wed,  9 Feb 2022 17:00:21 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com,
        seanjc@google.com
Subject: [PATCH 00/12] KVM: MMU: do not unload MMU roots on all role changes
Date:   Wed,  9 Feb 2022 12:00:08 -0500
Message-Id: <20220209170020.1775368-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TDP MMU has a performance regression compared to the legacy MMU
when CR0 changes often.  This was reported for the grsecurity kernel,
which uses CR0.WP to implement kernel W^X.  In that case, each change to
CR0.WP unloads the MMU and causes a lot of unnecessary work.  When running
nested, this can even cause the L1 to hardly make progress, as the L0
hypervisor it is overwhelmed by the amount of MMU work that is needed.

Initially, my plan for this was to pull kvm_mmu_unload from
kvm_mmu_reset_context into kvm_init_mmu.  Therefore I started by separating
the CPU setup (CR0/CR4/EFER, SMM, guest mode, etc.) from the shadow
page table format.  Right now the "MMU role" is a messy mix of the two
and, whenever something is different between the MMU and the CPU, it is
stored as an extra field in struct kvm_mmu; for extra bonus complication,
sometimes the same thing is stored in both the role and an extra field.
The aim was to keep kvm_mmu_unload only if the MMU role changed, and
drop it if the CPU role changed.

I even posted that cleanup, but it occurred to me later that even
a conditional kvm_mmu_unload in kvm_init_mmu would be overkill.
kvm_mmu_unload is only needed in the rare cases where a TLB flush is
needed (e.g. CR0.PG changing from 1 to 0) or where the guest page table
interpretation changes in way not captured by the role (that is, CPUID
changes).  But the implementation of fast PGD switching is subtle
and requires a call to kvm_mmu_new_pgd (and therefore knowing the
new MMU role) before kvm_init_mmu, therefore kvm_mmu_reset_context
chickens and drops all the roots.

Therefore, the meat of this series is a reorganization of fast PGD
switching; it makes it possible to call kvm_mmu_new_pgd *after*
the MMU has been set up, just using the MMU role instead of
kvm_mmu_calc_root_page_role.

Patches 1 to 3 are bugfixes found while working on the series.

Patches 4 to 5 add more sanity checks that triggered a lot during
development.

Patches 6 and 7 are related cleanups.  In particular patch 7 makes
the cache lookup code a bit more pleasant.

Patches 8 to 9 rework the fast PGD switching.  Patches 10 and
11 are cleanups enabled by the rework, and the only survivors
of the CPU role patchset.

Finally, patch 12 optimizes kvm_mmu_reset_context.

Paolo


Paolo Bonzini (12):
  KVM: x86: host-initiated EFER.LME write affects the MMU
  KVM: MMU: move MMU role accessors to header
  KVM: x86: do not deliver asynchronous page faults if CR0.PG=0
  KVM: MMU: WARN if PAE roots linger after kvm_mmu_unload
  KVM: MMU: avoid NULL-pointer dereference on page freeing bugs
  KVM: MMU: rename kvm_mmu_reload
  KVM: x86: use struct kvm_mmu_root_info for mmu->root
  KVM: MMU: do not consult levels when freeing roots
  KVM: MMU: look for a cached PGD when going from 32-bit to 64-bit
  KVM: MMU: load new PGD after the shadow MMU is initialized
  KVM: MMU: remove kvm_mmu_calc_root_page_role
  KVM: x86: do not unload MMU roots on all role changes

 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/mmu.h              |  28 +++-
 arch/x86/kvm/mmu/mmu.c          | 253 ++++++++++++++++----------------
 arch/x86/kvm/mmu/mmu_audit.c    |   4 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.h      |   2 +-
 arch/x86/kvm/svm/nested.c       |   6 +-
 arch/x86/kvm/vmx/nested.c       |   8 +-
 arch/x86/kvm/vmx/vmx.c          |   2 +-
 arch/x86/kvm/x86.c              |  39 +++--
 11 files changed, 190 insertions(+), 159 deletions(-)

-- 
2.31.1

