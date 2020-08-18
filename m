Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB23247B91
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 02:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgHRAnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 20:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgHRAnX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 20:43:23 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7B5C061389
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 17:43:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w11so20281480ybi.23
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 17:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xsihmYEi0cy/CSZ0Xb7y6TGtb2M86BbKpaGP6G3YVvk=;
        b=KrEYMFT2I3BsS/bTX6pLvk96k4+26Ne8DE+PP41/zz9iQ76VNIm9JCRCxJRWwYb+m3
         fHOcM+LhjLyCKSCL4FTlaXp8/La60CCzB/N3s8DzDRuAwqicwBwCUCS3Rf4Oj0eR4rkJ
         J1IUZ/dzPuXtMAvROOVI0lNS6jxA7zK9b+lLbmfGhUgYxsbZpVOZOjOvNMZ6/fBVGvlT
         ZOFkE3l7EH2CU1vffY7LrBOW7IroqPn8QoV7ep/KVseTTNLcmJR4vJpDfoNW4m5jWYca
         FbE9166SG1TSc2pzIjDuhVlWyXhQQqQjO2ttWAwpJoOdwr5WeAgas/GbK8lzEy5BSFhS
         gpEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xsihmYEi0cy/CSZ0Xb7y6TGtb2M86BbKpaGP6G3YVvk=;
        b=H9ipraccE8joL/nrKzrLegU9msLJkxI0Jg/akjeTtFwgsoFoTpl4G7e8dCPqEiDi4w
         VWHl4FhFChdnsynp37NVblQUfc8VbXu0Pg/AZXqo55yym0b/lgwUZqMrtXzLi/sjCPj4
         MsCZCRKjsuOF6UJCYv7F/sCyxrzRq/x+INerdc1X/HqdZ9F4VI48p5KW0x05g4QefMPX
         DuS+sJ1XgzfsO2BD0NUduDBeeTkKez1tgmYWGv1yB084pNK/CO0Jg5QrU9sldJJ90c36
         oRWx+/Gu4oTUiICFnMK8nhOJK5BCA/v4o/l5Ytwb64M6Rv+oPZGXKWgmdEeUPgtjAakT
         zYOA==
X-Gm-Message-State: AOAM5322iiEwFTJ6mt5jfiz3SulAayrygzuV74JPRMB/R/9WSoqL1W0C
        Wl1dZ62VM436afs/+6MK2hSry/4D4w61pwQl2cscIWERNxy5WUjtDCc0gXaAR0Vv+e1GbGdwv1m
        uRAT4mgVa+thETUx4xfD5DW4qCY8qSghbtbWVN2u/E7Am9j2dQ8MAfcW0gw==
X-Google-Smtp-Source: ABdhPJxQXfMFUJRbY8Jbi5/vqsjKYj1kpLhnXPTHgUHOBp9BKHX/nqK8ihL1Ar95JokdcirYmlG18OcliT8=
X-Received: by 2002:a25:e015:: with SMTP id x21mr23229287ybg.1.1597711401685;
 Mon, 17 Aug 2020 17:43:21 -0700 (PDT)
Date:   Mon, 17 Aug 2020 17:43:14 -0700
Message-Id: <20200818004314.216856-1-pshier@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH] KVM: nVMX: Update VMCS02 when L2 PAE PDPTE updates detected
From:   Peter Shier <pshier@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When L2 uses PAE, L0 intercepts of L2 writes to CR0/CR3/CR4 call
load_pdptrs to read the possibly updated PDPTEs from the guest
physical address referenced by CR3.  It loads them into
vcpu->arch.walk_mmu->pdptrs[] and sets VCPU_EXREG_PDPTR in
vcpu->arch.regs_dirty.

At the subsequent assumed reentry into L2, the mmu will call
vmx_load_mmu_pgd which calls ept_load_pdptrs. ept_load_pdptrs sees
VCPU_EXREG_PDPTR set in vcpu->arch.regs_dirty and loads
VMCS02.GUEST_PDPTRn from vcpu->arch.walk_mmu->pdptrs[]. This all works
if the L2 CRn write intercept always resumes L2.

The resume path calls vmx_check_nested_events which checks for
exceptions, MTF, and expired VMX preemption timers. If
vmx_check_nested_events finds any of these conditions pending it will
reflect the corresponding exit into L1. Live migration at this point
would also cause a missed immediate reentry into L2.

After L1 exits, vmx_vcpu_run calls vmx_register_cache_reset which
clears VCPU_EXREG_PDPTR in vcpu->arch.regs_dirty.  When L2 next
resumes, ept_load_pdptrs finds VCPU_EXREG_PDPTR clear in
vcpu->arch.regs_dirty and does not load VMCS02.GUEST_PDPTRn from
vcpu->arch.walk_mmu->pdptrs[]. prepare_vmcs02 will then load
VMCS02.GUEST_PDPTRn from vmcs12->pdptr0/1/2/3 which contain the stale
values stored at last L2 exit. A repro of this bug showed L2 entering
triple fault immediately due to the bad VMCS02.GUEST_PDPTRn values.

Add a new x86 op to enable vendor-specific code to process the PDPTE
updates. For Intel, when in guest mode using PAE, update
VMCS02.GUEST_PDPTRn from the newly loaded values.

Tested:
kvm-unit-tests with new directed test: vmx_mtf_pdpte_test.
Verified that test fails without the fix.

Also ran Google internal VMM with an Ubuntu 16.04 4.4.0-83 guest
running a custom hypervisor with a 32-bit Windows XP L2 guest using
PAE. Prior to fix would repro readily. Ran with fix for 13 hours
booting 14 simultaneous L2s with no failures.

Signed-off-by: Peter Shier <pshier@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 11 +++++++++++
 arch/x86/kvm/x86.c              |  2 ++
 3 files changed, 14 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5ab3af7275d8..c9971c5d316f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1227,6 +1227,7 @@ struct kvm_x86_ops {
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
+	void (*load_pdptrs)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 46ba2e03a892..b8e36ea077dc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2971,6 +2971,16 @@ static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	vpid_sync_context(to_vmx(vcpu)->vpid);
 }
 
+static void vmx_load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
+{
+	if (enable_ept && is_guest_mode(vcpu)) {
+		vmcs_write64(GUEST_PDPTR0, mmu->pdptrs[0]);
+		vmcs_write64(GUEST_PDPTR1, mmu->pdptrs[1]);
+		vmcs_write64(GUEST_PDPTR2, mmu->pdptrs[2]);
+		vmcs_write64(GUEST_PDPTR3, mmu->pdptrs[3]);
+	}
+}
+
 static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
@@ -8005,6 +8015,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
+	.load_pdptrs = vmx_load_pdptrs,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 599d73206299..e52c2d67ba0a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -769,7 +769,8 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
 
+	if (kvm_x86_ops.load_pdptrs)
+		kvm_x86_ops.load_pdptrs(vcpu, mmu);
 out:
 
 	return ret;
-- 

