Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A794A98A1
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbiBDL50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22775 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358513AbiBDL5Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=I2DzmizRxymlu2fjBogBbGDUB/Xq+NvGxXpe5knoTEY=;
        b=ECOOvSYFgHtYnRCCV8RP5O4FUY1afWjDojb7ELKINO5U1cIHPEkiy9SXYP0XaDvAUSwSLD
        nPph75E4vQjxqt71p960bv6q9nZ0c+s0Bsk1GuXFIX/vSfwSeDycHFTtOGJV5BrK8x3hyA
        jRlQY7J8WRVC6enmHYw/HgGOyx3vmUQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-uEoj1HErOwe7HQR6wLIpxA-1; Fri, 04 Feb 2022 06:57:20 -0500
X-MC-Unique: uEoj1HErOwe7HQR6wLIpxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71B34190B2A0;
        Fri,  4 Feb 2022 11:57:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E77641081172;
        Fri,  4 Feb 2022 11:57:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 00/23] KVM: MMU: MMU role refactoring
Date:   Fri,  4 Feb 2022 06:56:55 -0500
Message-Id: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TDP MMU has a performance regression compared to the legacy
MMU when CR0 changes often.  This was reported for the grsecurity
kernel, which uses CR0.WP to implement kernel W^X.  In that case,
each change to CR0.WP unloads the MMU and causes a lot of unnecessary
work.  When running nested, this can even cause the L1 to hardly
make progress, as the L0 hypervisor it is overwhelmed by the amount
of MMU work that is needed.

The root cause of the issue is that the "MMU role" in KVM is a mess
that mixes the CPU setup (CR0/CR4/EFER, SMM, guest mode, etc.)
and the shadow page table format.  Whenever something is different
between the MMU and the CPU, it is stored as an extra field in struct
kvm_mmu---and for extra bonus complication, sometimes the same thing
is stored in both the role and an extra field.

So, this is the "no functional change intended" part of the changes
required to fix the performance regression.  It separates neatly
the shadow page table format ("MMU role") from the guest page table
format ("CPU role"), and removes the duplicate fields.  The next
step then is to avoid unloading the MMU as long as the MMU role
stays the same.

Please review!

Paolo

Paolo Bonzini (23):
  KVM: MMU: pass uses_nx directly to reset_shadow_zero_bits_mask
  KVM: MMU: nested EPT cannot be used in SMM
  KVM: MMU: remove valid from extended role
  KVM: MMU: constify uses of struct kvm_mmu_role_regs
  KVM: MMU: pull computation of kvm_mmu_role_regs to kvm_init_mmu
  KVM: MMU: load new PGD once nested two-dimensional paging is
    initialized
  KVM: MMU: remove kvm_mmu_calc_root_page_role
  KVM: MMU: rephrase unclear comment
  KVM: MMU: remove "bool base_only" arguments
  KVM: MMU: split cpu_role from mmu_role
  KVM: MMU: do not recompute root level from kvm_mmu_role_regs
  KVM: MMU: remove ept_ad field
  KVM: MMU: remove kvm_calc_shadow_root_page_role_common
  KVM: MMU: cleanup computation of MMU roles for two-dimensional paging
  KVM: MMU: cleanup computation of MMU roles for shadow paging
  KVM: MMU: remove extended bits from mmu_role
  KVM: MMU: remove redundant bits from extended role
  KVM: MMU: fetch shadow EFER.NX from MMU role
  KVM: MMU: simplify and/or inline computation of shadow MMU roles
  KVM: MMU: pull CPU role computation to kvm_init_mmu
  KVM: MMU: store shadow_root_level into mmu_role
  KVM: MMU: use cpu_role for root_level
  KVM: MMU: replace direct_map with mmu_role.direct

 arch/x86/include/asm/kvm_host.h |  13 +-
 arch/x86/kvm/mmu.h              |   2 +-
 arch/x86/kvm/mmu/mmu.c          | 408 ++++++++++++--------------------
 arch/x86/kvm/mmu/mmu_audit.c    |   6 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  12 +-
 arch/86/kvm/mmu/tdp_mmu.c      |   4 +-
 arch/x86/kvm/svm/svm.c          |   2 +-
 arch/x86/kvm/vmx/vmx.c          |   2 +-
 arch/x86/kvm/x86.c              |  12 +-
 10 files changed, 178 insertions(+), 284 deletions(-)

-- 
2.31.1

