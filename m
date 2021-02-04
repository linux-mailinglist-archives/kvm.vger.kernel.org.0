Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC14A30E847
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbhBDAGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbhBDACu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:02:50 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CD2C0617A9
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 16:01:38 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id s4so1032829qkj.18
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 16:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=d2iRbGdfp/Ifr4yknHGjT6yfFI/3odhmNBJQhqstDno=;
        b=rjKpyX/qgfzTGAfG2oRnIAwsnHCzo2UL0l25qtM7TIDodrAopJ1I09Ndwpjl3Hz1jT
         f3SKbUXLKvBCcGpmk4G+3VaOvKAHbovX8NS0+KXUFPL4K0flu2Io6+8zKNFPrHqTkWPc
         DnkP3diUY3mrvKcNK7Yl9QuDcRtdZ/thWwji1PB4XhFrPZxKxq+Xld5KZ1eIznwwU/ns
         fey/cFpHieKuQfJExJWxLas7RgkYXRXJL69125YFmlkSh/p+OitYH2zCbQ+GBw2REj2j
         dq+eOI+VfUSuDRsPod77kz9haZOtj7WEHwbvK3jxAVKoM1bxykIygsjO3QHyld/BOLei
         m3lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=d2iRbGdfp/Ifr4yknHGjT6yfFI/3odhmNBJQhqstDno=;
        b=eXcP7MkFC79DlUmDNbJ9emj/iI6fTO+l5s+jgiIa6I/frKvdf5oUG9/zdECaVvBzqt
         FUljkuuufGMCvBUC/LFzIp6xTUM3+bj6/JZBORkHgyt1Zh/dMNyZ0WwjGG3YkN5y5Auh
         /N2tV3XYAtKUcuH5+hUb3hsPue2gmHFO7PWOUF72X6JYyq4UHgrSY+rNDuORfMXX8aF7
         WVO+0dwrRVkP6qWh/6+o2Ds5Gt/qJ1BL14oujpbtPnj0Bd0aNp4C8v+txBVxdjR3bdGO
         GKU9BUxFBmeMxR1LnXJ0POFPoj6udc0aWpG6IefFnyNiih+imzDsCvIWBpsudYk2Vy2h
         NaIg==
X-Gm-Message-State: AOAM530HeIG/u8vIqT5d564CWcK8+tQ5f1NxJkBgRhI78Bnb6LmX//cB
        j71D0plTsW7Xd3z8MSFfcU5vq3FLJEI=
X-Google-Smtp-Source: ABdhPJx8RyG5PcUvngLKMHbmBv437Ki4ZOemCkox27BEbIjqqqvH0ZYWyyPPQlZpVj1jDMur4uDso78oJqs=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
 (user=seanjc job=sendgmr) by 2002:ad4:5bc8:: with SMTP id t8mr5454160qvt.36.1612396897679;
 Wed, 03 Feb 2021 16:01:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Feb 2021 16:01:10 -0800
In-Reply-To: <20210204000117.3303214-1-seanjc@google.com>
Message-Id: <20210204000117.3303214-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210204000117.3303214-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 05/12] KVM: VMX: Use GPA legality helpers to replace open
 coded equivalents
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace a variety of open coded GPA checks with the recently introduced
common helpers.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 26 +++++++-------------------
 arch/x86/kvm/vmx/vmx.c    |  2 +-
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b14fc19ceb36..b25ce704a2aa 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -775,8 +775,7 @@ static int nested_vmx_check_apicv_controls(struct kvm_vcpu *vcpu,
 	   (CC(!nested_cpu_has_vid(vmcs12)) ||
 	    CC(!nested_exit_intr_ack_set(vcpu)) ||
 	    CC((vmcs12->posted_intr_nv & 0xff00)) ||
-	    CC((vmcs12->posted_intr_desc_addr & 0x3f)) ||
-	    CC((vmcs12->posted_intr_desc_addr >> cpuid_maxphyaddr(vcpu)))))
+	    CC(!kvm_vcpu_is_legal_aligned_gpa(vcpu, vmcs12->posted_intr_desc_addr, 64))))
 		return -EINVAL;
 
 	/* tpr shadow is needed by all apicv features. */
@@ -789,13 +788,11 @@ static int nested_vmx_check_apicv_controls(struct kvm_vcpu *vcpu,
 static int nested_vmx_check_msr_switch(struct kvm_vcpu *vcpu,
 				       u32 count, u64 addr)
 {
-	int maxphyaddr;
-
 	if (count == 0)
 		return 0;
-	maxphyaddr = cpuid_maxphyaddr(vcpu);
-	if (!IS_ALIGNED(addr, 16) || addr >> maxphyaddr ||
-	    (addr + count * sizeof(struct vmx_msr_entry) - 1) >> maxphyaddr)
+
+	if (!kvm_vcpu_is_legal_aligned_gpa(vcpu, addr, 16) ||
+	    !kvm_vcpu_is_legal_gpa(vcpu, (addr + count * sizeof(struct vmx_msr_entry) - 1)))
 		return -EINVAL;
 
 	return 0;
@@ -1093,14 +1090,6 @@ static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
 	}
 }
 
-static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
-{
-	unsigned long invalid_mask;
-
-	invalid_mask = (~0ULL) << cpuid_maxphyaddr(vcpu);
-	return (val & invalid_mask) == 0;
-}
-
 /*
  * Returns true if the MMU needs to be sync'd on nested VM-Enter/VM-Exit.
  * tl;dr: the MMU needs a sync if L0 is using shadow paging and L1 didn't
@@ -1152,7 +1141,7 @@ static bool nested_vmx_transition_mmu_sync(struct kvm_vcpu *vcpu)
 static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool nested_ept,
 			       enum vm_entry_failure_code *entry_failure_code)
 {
-	if (CC(!nested_cr3_valid(vcpu, cr3))) {
+	if (CC(kvm_vcpu_is_illegal_gpa(vcpu, cr3))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
 		return -EINVAL;
 	}
@@ -2666,7 +2655,6 @@ static int nested_vmx_check_nmi_controls(struct vmcs12 *vmcs12)
 static bool nested_vmx_check_eptp(struct kvm_vcpu *vcpu, u64 new_eptp)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	int maxphyaddr = cpuid_maxphyaddr(vcpu);
 
 	/* Check for memory type validity */
 	switch (new_eptp & VMX_EPTP_MT_MASK) {
@@ -2697,7 +2685,7 @@ static bool nested_vmx_check_eptp(struct kvm_vcpu *vcpu, u64 new_eptp)
 	}
 
 	/* Reserved bits should not be set */
-	if (CC(new_eptp >> maxphyaddr || ((new_eptp >> 7) & 0x1f)))
+	if (CC(kvm_vcpu_is_illegal_gpa(vcpu, new_eptp) || ((new_eptp >> 7) & 0x1f)))
 		return false;
 
 	/* AD, if set, should be supported */
@@ -2881,7 +2869,7 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 
 	if (CC(!nested_host_cr0_valid(vcpu, vmcs12->host_cr0)) ||
 	    CC(!nested_host_cr4_valid(vcpu, vmcs12->host_cr4)) ||
-	    CC(!nested_cr3_valid(vcpu, vmcs12->host_cr3)))
+	    CC(kvm_vcpu_is_illegal_gpa(vcpu, vmcs12->host_cr3)))
 		return -EINVAL;
 
 	if (CC(is_noncanonical_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index beb5a912014d..cbeb0748f25f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1114,7 +1114,7 @@ static inline bool pt_can_write_msr(struct vcpu_vmx *vmx)
 static inline bool pt_output_base_valid(struct kvm_vcpu *vcpu, u64 base)
 {
 	/* The base must be 128-byte aligned and a legal physical address. */
-	return !kvm_vcpu_is_illegal_gpa(vcpu, base) && !(base & 0x7f);
+	return kvm_vcpu_is_legal_aligned_gpa(vcpu, base, 128);
 }
 
 static inline void pt_load_msr(struct pt_ctx *ctx, u32 addr_range)
-- 
2.30.0.365.g02bc693789-goog

