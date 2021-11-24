Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE3745C3E1
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 14:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348630AbhKXNo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 08:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350975AbhKXNmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 08:42:55 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B984C0698CD;
        Wed, 24 Nov 2021 04:21:43 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id m15so1961654pgu.11;
        Wed, 24 Nov 2021 04:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lYEOAK74S7RKzE6p9TGoUnrSZ59dGlU6PiDgEqVSldA=;
        b=IUee1jipE77HMbvfvG0aZvIqkBRfR/vDG2myTlV43W049ZAHi5ev12tFvM4WCqypi9
         E4rDo1+zLIcVO53hkBGdhUx77Nv3gDaQh/ASREMyCVD9Oc1zGATEGAVAo007aiuVlWOe
         5MMg3KHyZXeOu9kE2oHGRpQhyLMQUCNNZP87q7aCSmrSDWwCN/IBko9TuXrFdlr5vcUL
         mm0M+uFgV5RPjhIDUWlCxhpG7O1LQ94t+ZWS7rACjMW18i6MgjJICbsFSyFH/0Kso5Ho
         LtEFBGyR+b3pcEZJST+IIxbjY1m6xF9HyDJvJ8nYqthnyld1SfgGTHDfe+CeseRxV5Uz
         k7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lYEOAK74S7RKzE6p9TGoUnrSZ59dGlU6PiDgEqVSldA=;
        b=kYExbz50YBSSq22nLt5iUj+Li1yDQTI/O+d6Gj4Xou6EcOudsUMl/7Duv9psq3NKq4
         1+R3/dx0kZZLXDSc2tB7QBIpqr0akxbuHCj+WWZe81o0cTcRvpq86DufPhxz3HudR6Hu
         Rahf/muEpAwO+IVU02yyh4QWhnKZNR5PGMa6+QrC4j/O+qqS+NxweKW//fY4dGmfT67l
         jTS+fRS1mBjyi5nuQs+kFvx5w3cAd211GNJkf0VkPFH4ujFFqJxLMBOagMyKxSmS3lMP
         +9fo4lagaVmpXVF8OUPblDtX0HLd8H8nKS0uqhUrmwerdvfFWNem9pnP0WDSyx4/prO0
         9CiQ==
X-Gm-Message-State: AOAM5307xsY2Eq9Sp9dzUjQg/ba0jAv8AQbU90OA/jQ2p1LXOtrigr3i
        uwmbp7FcfnEw1967/AvuzqIwmnX+Q74=
X-Google-Smtp-Source: ABdhPJwYsjpjOmTOs4+qciEH+Gw7h2MHoJyPtrqgb/4eI9u10SZi2D3fxvD0fTDZABSiZzrD5NSbGg==
X-Received: by 2002:a63:48:: with SMTP id 69mr9730751pga.479.1637756502782;
        Wed, 24 Nov 2021 04:21:42 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id z3sm16904691pfh.79.2021.11.24.04.21.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 04:21:42 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 07/12] KVM: X86: Add parameter huge_page_level to kvm_init_shadow_ept_mmu()
Date:   Wed, 24 Nov 2021 20:20:49 +0800
Message-Id: <20211124122055.64424-8-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211124122055.64424-1-jiangshanlai@gmail.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The level of supported large page on nEPT affects the rsvds_bits_mask.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu.h              | 3 ++-
 arch/x86/kvm/mmu/mmu.c          | 5 +++--
 arch/x86/kvm/vmx/capabilities.h | 9 +++++++++
 arch/x86/kvm/vmx/nested.c       | 8 +++++---
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 97e13c2988b3..e9fbb2c8bbe2 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -71,7 +71,8 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu);
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 			     unsigned long cr4, u64 efer, gpa_t nested_cr3);
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
-			     bool accessed_dirty, gpa_t new_eptp);
+			     int huge_page_level, bool accessed_dirty,
+			     gpa_t new_eptp);
 bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8a371d6c2291..f5a1da112daf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4886,7 +4886,8 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 }
 
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
-			     bool accessed_dirty, gpa_t new_eptp)
+			     int huge_page_level, bool accessed_dirty,
+			     gpa_t new_eptp)
 {
 	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	u8 level = vmx_eptp_page_walk_level(new_eptp);
@@ -4913,7 +4914,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 
 	update_permission_bitmask(context, true);
 	update_pkru_bitmask(context);
-	reset_rsvds_bits_mask_ept(vcpu, context, execonly, max_huge_page_level);
+	reset_rsvds_bits_mask_ept(vcpu, context, execonly, huge_page_level);
 	reset_ept_shadow_zero_bits_mask(vcpu, context, execonly);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4705ad55abb5..c8029b7845b6 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -312,6 +312,15 @@ static inline bool cpu_has_vmx_ept_1g_page(void)
 	return vmx_capability.ept & VMX_EPT_1GB_PAGE_BIT;
 }
 
+static inline int ept_caps_to_lpage_level(u32 ept_caps)
+{
+	if (ept_caps & VMX_EPT_1GB_PAGE_BIT)
+		return PG_LEVEL_1G;
+	if (ept_caps & VMX_EPT_2MB_PAGE_BIT)
+		return PG_LEVEL_2M;
+	return PG_LEVEL_4K;
+}
+
 static inline bool cpu_has_vmx_ept_ad_bits(void)
 {
 	return vmx_capability.ept & VMX_EPT_AD_BIT;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d8d0dbc4fc18..20e126de1c96 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -391,9 +391,11 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 
 static void nested_ept_new_eptp(struct kvm_vcpu *vcpu)
 {
-	kvm_init_shadow_ept_mmu(vcpu,
-				to_vmx(vcpu)->nested.msrs.ept_caps &
-				VMX_EPT_EXECUTE_ONLY_BIT,
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	bool execonly = vmx->nested.msrs.ept_caps & VMX_EPT_EXECUTE_ONLY_BIT;
+	int ept_lpage_level = ept_caps_to_lpage_level(vmx->nested.msrs.ept_caps);
+
+	kvm_init_shadow_ept_mmu(vcpu, execonly, ept_lpage_level,
 				nested_ept_ad_enabled(vcpu),
 				nested_ept_get_eptp(vcpu));
 }
-- 
2.19.1.6.gb485710b

