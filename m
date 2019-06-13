Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 516074483E
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393413AbfFMRGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:06:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41114 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404556AbfFMREE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so21577670wrm.8;
        Thu, 13 Jun 2019 10:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ClGgmNmwy3eykmm+eAPjSx1kkWxkJ2g10pmYt0zENDg=;
        b=pi7dRulyK+DDMK4JeZmmvYRlaQNoCcwOAc2w5rIyuOKSgFVmKZBU+vN0X7kNVUxpUj
         OUAElhQUcMDd+tXyu3DTFRQ65CtJV1zvSRsaHVik+2wkfNb4IlJCfQRon8KV8E9Ou8Ft
         8X0I6+ut/dQyprIj2ABQHe1lqeGR+MG1qZlSQcGBS7qjzZpIu4IiBEEfwJERVjdhGmc1
         5Ch63u4Zb+xyMFDK0k784O8+DDWdEhcYWaayFgUbKk806KCidFeWYLc3MI79j1bv3HxZ
         uT8BttrduFbFxn97VQngkpifRM04k/Nz20yvXNTwEK8UR3PJEa6MtGbh8z6Grh+J/6Lv
         eRtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=ClGgmNmwy3eykmm+eAPjSx1kkWxkJ2g10pmYt0zENDg=;
        b=mFDn3kgvuddtQttNLEJWVU3iqnRWMbDwgf3CN2is/Wff2SiQys9vujo12LUdcQXZ+y
         m0+kYMCGbiUajBNnO5O7gjtrf6VgTsGNlVb5WIWZlF/IfkLeGw9K23x5QgOATuCq57PN
         XeB6cyK6Ix2+5m3bFzUcAd45Tos9t8nQG2EtD/mmAfsNh69JghSMGrQxg9UTyd7xc9dB
         5rRi4CgOw8+xvUULpaNrV0+570r5g/ui4+ahchp0Jzsjf5YEUeKp4wFE+Yk9Q8sea0lw
         pCPaDdkrM+sSKeIKilzsqhWSpZJJ87Ex1aZCqS0EFxgkP25zUXnsOcejcJBqfgILmU1d
         bYRg==
X-Gm-Message-State: APjAAAWbXWdg4kjaP70t2fubjKp5UWBbDEc1/OGvAW21WO9HE1G3j/T6
        rNwAbXor/0KlUvhjlBcp5T255Anw
X-Google-Smtp-Source: APXvYqynPuLmCv7eCmUz0XX7DFlC1YDrX3A1Tz3qUxrpuVyShhn6GIIvVRAAcMhfpHxnfviq05p8Gg==
X-Received: by 2002:a5d:4a8d:: with SMTP id o13mr26843390wrq.350.1560445442100;
        Thu, 13 Jun 2019 10:04:02 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:01 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 29/43] KVM: x86: introduce is_pae_paging
Date:   Thu, 13 Jun 2019 19:03:15 +0200
Message-Id: <1560445409-17363-30-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Checking for 32-bit PAE is quite common around code that fiddles with
the PDPTRs.  Add a function to compress all checks into a single
invocation.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 3 +--
 arch/x86/kvm/vmx/vmx.c    | 4 ++--
 arch/x86/kvm/x86.c        | 8 ++++----
 arch/x86/kvm/x86.h        | 5 +++++
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d5bfe0cbc4fb..0948071905a4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -961,8 +961,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 		 * If PAE paging and EPT are both on, CR3 is not used by the CPU and
 		 * must not be dereferenced.
 		 */
-		if (!is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu) &&
-		    !nested_ept) {
+		if (is_pae_paging(vcpu) && !nested_ept) {
 			if (!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)) {
 				*entry_failure_code = ENTRY_FAIL_PDPTE;
 				return -EINVAL;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 975b2705c5b2..ede565bec19e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2767,7 +2767,7 @@ static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
 		      (unsigned long *)&vcpu->arch.regs_dirty))
 		return;
 
-	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
+	if (is_pae_paging(vcpu)) {
 		vmcs_write64(GUEST_PDPTR0, mmu->pdptrs[0]);
 		vmcs_write64(GUEST_PDPTR1, mmu->pdptrs[1]);
 		vmcs_write64(GUEST_PDPTR2, mmu->pdptrs[2]);
@@ -2779,7 +2779,7 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 
-	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
+	if (is_pae_paging(vcpu)) {
 		mmu->pdptrs[0] = vmcs_read64(GUEST_PDPTR0);
 		mmu->pdptrs[1] = vmcs_read64(GUEST_PDPTR1);
 		mmu->pdptrs[2] = vmcs_read64(GUEST_PDPTR2);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 432f9f8c3d42..5eff26307e60 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -719,7 +719,7 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
 	gfn_t gfn;
 	int r;
 
-	if (is_long_mode(vcpu) || !is_pae(vcpu) || !is_paging(vcpu))
+	if (!is_pae_paging(vcpu))
 		return false;
 
 	if (!test_bit(VCPU_EXREG_PDPTR,
@@ -962,8 +962,8 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (is_long_mode(vcpu) &&
 	    (cr3 & rsvd_bits(cpuid_maxphyaddr(vcpu), 63)))
 		return 1;
-	else if (is_pae(vcpu) && is_paging(vcpu) &&
-		   !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
+	else if (is_pae_paging(vcpu) &&
+		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
 
 	kvm_mmu_new_cr3(vcpu, cr3, skip_tlb_flush);
@@ -8596,7 +8596,7 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 		kvm_update_cpuid(vcpu);
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	if (!is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu)) {
+	if (is_pae_paging(vcpu)) {
 		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
 		mmu_reset_needed = 1;
 	}
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 275b3b646023..e08a12892e8b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -139,6 +139,11 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
 	return likely(kvm_read_cr0_bits(vcpu, X86_CR0_PG));
 }
 
+static inline bool is_pae_paging(struct kvm_vcpu *vcpu)
+{
+	return !is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu);
+}
+
 static inline u32 bit(int bitno)
 {
 	return 1 << (bitno & 31);
-- 
1.8.3.1


