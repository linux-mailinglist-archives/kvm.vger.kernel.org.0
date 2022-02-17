Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F24E4BAB6E
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 22:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244186AbiBQVEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 16:04:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243845AbiBQVEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 16:04:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3575285643
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 13:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645131825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xXgQjIfXpyWvcEjzixUIUBSlT5+pRuKEZCot42LqH+I=;
        b=NEOJZ7AmMhk9eWqoPYSFGygHnST36kMgionxTIwiHSYWrmVVnokDfdoVa+PG//zb2bf0Xq
        oZdwXHZsuWgTKCIVi5CdAFQ8vivlCnKGKtvoHP+rM4db/bJfbQy356BxG9tqfaj1nYf9XX
        lRlNDYRumCtrz/h6aEpzhkA5ZX8WJNA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-OERk3T6eNzeVGIN784UC8A-1; Thu, 17 Feb 2022 16:03:42 -0500
X-MC-Unique: OERk3T6eNzeVGIN784UC8A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 877151800D50;
        Thu, 17 Feb 2022 21:03:41 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3905D610A5;
        Thu, 17 Feb 2022 21:03:41 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 00/18] KVM: MMU: do not unload MMU roots on all role changes
Date:   Thu, 17 Feb 2022 16:03:22 -0500
Message-Id: <20220217210340.312449-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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

The root reason why kvm_mmu_reset_context calls kvm_mmu_unload is a
subtlety of the implementation of fast PGD switching, which requires a
call to kvm_mmu_new_pgd (and therefore knowing the new MMU role) *before*
kvm_init_mmu.  kvm_mmu_reset_context chickens out and does not do fast
PGD switching at all, instead dropping all the roots.

Therefore, the most important part of this series is a reorganization
of fast PGD switching; it makes it possible to call kvm_mmu_new_pgd
*after* the MMU has been set up, just using the MMU role instead of
kvm_mmu_calc_root_page_role.

Patches 1 and 2 are bugfixes found while working on the series.

Patches 3 to 4 add more sanity checks that triggered a lot during
development.

Patches 5 to 7 are related cleanups.  In particular patch 5 makes the
cache lookup code a bit more pleasant.

Patches 8 to 9 rework the fast PGD switching.  Patches 10 and 11 are
cleanups enabled by the rework, and the only survivors of the CPU role
patchset.

Patches 13 to 16 tidy up callers of kvm_mmu_reset_context and
kvm_mmu_new_pgd.  kvm_mmu_new_pgd is changed to use the ->get_guest_pgd
callback, avoiding the possibility of confusion between the root_mmu
and the guest_mmu, and a new request is created for it (this will also
be put to use once the role patchset will allow automatic detection of
changed MMU role).

Finally, patch 17 changes callers that expect kvm_mmu_reset_context to
perform a guest TLB flush, and patch 18 optimizes kvm_mmu_reset_context.

Paolo

Lai Jiangshan (1):
  KVM: x86/mmu: Do not use guest root level in audit

Paolo Bonzini (17):
  KVM: x86: host-initiated EFER.LME write affects the MMU
  KVM: x86: do not deliver asynchronous page faults if CR0.PG=0
  KVM: x86/mmu: WARN if PAE roots linger after kvm_mmu_unload
  KVM: x86/mmu: avoid NULL-pointer dereference on page freeing bugs
  KVM: x86/mmu: use struct kvm_mmu_root_info for mmu->root
  KVM: x86/mmu: do not consult levels when freeing roots
  KVM: x86/mmu: do not pass vcpu to root freeing functions
  KVM: x86/mmu: look for a cached PGD when going from 32-bit to 64-bit
  KVM: x86/mmu: load new PGD after the shadow MMU is initialized
  KVM: x86/mmu: Always use current mmu's role when loading new PGD
  KVM: x86/mmu: clear MMIO cache when unloading the MMU
  KVM: x86: reset and reinitialize the MMU in __set_sregs_common
  KVM: x86/mmu: avoid indirect call for get_cr3
  KVM: x86/mmu: rename kvm_mmu_new_pgd, introduce variant that calls
    get_guest_pgd
  KVM: x86: introduce KVM_REQ_MMU_UPDATE_ROOT
  KVM: x86: flush TLB separately from MMU reset
  KVM: x86: do not unload MMU roots on all role changes

 arch/x86/include/asm/kvm_host.h |  10 +-
 arch/x86/kvm/mmu.h              |  18 ++-
 arch/x86/kvm/mmu/mmu.c          | 273 +++++++++++++++++---------------
 arch/x86/kvm/mmu/mmu_audit.c    |  16 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |   4 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.h      |   2 +-
 arch/x86/kvm/svm/nested.c       |   6 +-
 arch/x86/kvm/vmx/nested.c       |  16 +-
 arch/x86/kvm/vmx/vmx.c          |   2 +-
 arch/x86/kvm/x86.c              | 135 ++++++++++------
 11 files changed, 279 insertions(+), 205 deletions(-)

-- 
2.31.1

