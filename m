Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE00345C421
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 14:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348799AbhKXNpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 08:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350962AbhKXNmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 08:42:55 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15370C0698CC;
        Wed, 24 Nov 2021 04:21:37 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so2495848pjb.5;
        Wed, 24 Nov 2021 04:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jluOHmy1K0iC3PvtHhC0yZeCwQHIXzU2oKrxosl4sEk=;
        b=Ehuer+VNbQANfH9GJKYaaMMp62cPMhRGtFZbaodua0jWEUSn5bTLwDCOxCDa6oYWDL
         JGimXWSFReaOHrQBD+IMVDDfovxHV2Y74YrH5GA9QS1I1kRZmkkvqI+cWPQjRgvWv5MA
         SDL1PLgNPoyR4JDIIVA01G3T2I4SNrMndgVxo8mgBMaQzX+8yIhFzuIjJLtwluS1CI5b
         58XCa1Ji6cI8atOvSfZtwxxvgL1t0ui5g6mqNZAJkAyeRscDBTfk44yL1mP4qDBS450B
         +kAosxhlIL+F4g6NoN7P+jFxPMstjC2TJffLvQxXzOoCPfw5ssfOmgmYvs1wy3woLDce
         yhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jluOHmy1K0iC3PvtHhC0yZeCwQHIXzU2oKrxosl4sEk=;
        b=ekQbxZQPbfNx2E6+4lNfzcU/fXatJynPlHr0sN826za4CYNA7BEFeB2HVuxETjaolG
         pwQg3ufnb/8mmhOtPA2Gspo3QU6JgPsvv2FIPcKuBhsjFgtiwErscGqZ0HDzuczjwFpb
         hPFvWNHcvUvjfjD6sGn2CQvNtiZyQ+S/4eks4lz+e9l6nQI0IurTMJkf5BTja1HdX3Gy
         VaA8jibtaKVhGasXaHFKd4sdBPCiU6qQcrzaP/RHgI3v5+C6LrxmWETiCyRKQjDt2lMK
         247mmiLzJxvahdkljZOs2tKc5MTjvrgpGxt67rBfPPy7BpAXy4FbRg3XQ/0mhRNjEhhL
         88Fw==
X-Gm-Message-State: AOAM533TR1JOc20h31zrm/iGsAc2w5qWY+fW10yi80fh39tuBDPQlhSH
        9fL3WpOY5OAlw0LsFbE3SmlIf2DggMw=
X-Google-Smtp-Source: ABdhPJz2FfrwYzAspbTT1YylpV6PD/eHW4/ujUarERkVUiOJGZr3VnP+m12gwawz7gnUjusEjq+w9A==
X-Received: by 2002:a17:902:e890:b0:142:f3:7bf7 with SMTP id w16-20020a170902e89000b0014200f37bf7mr17733269plg.87.1637756496457;
        Wed, 24 Nov 2021 04:21:36 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id e13sm11906461pgb.8.2021.11.24.04.21.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 04:21:36 -0800 (PST)
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
Subject: [PATCH 06/12] KVM: X86: Add huge_page_level to __reset_rsvds_bits_mask_ept()
Date:   Wed, 24 Nov 2021 20:20:48 +0800
Message-Id: <20211124122055.64424-7-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211124122055.64424-1-jiangshanlai@gmail.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Bit 7 on pte depends on the level of supported large page.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d3bad4ae72fb..8a371d6c2291 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4339,22 +4339,28 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 
 static void
 __reset_rsvds_bits_mask_ept(struct rsvd_bits_validate *rsvd_check,
-			    u64 pa_bits_rsvd, bool execonly)
+			    u64 pa_bits_rsvd, bool execonly, int huge_page_level)
 {
 	u64 high_bits_rsvd = pa_bits_rsvd & rsvd_bits(0, 51);
+	u64 large_1g_rsvd = 0, large_2m_rsvd = 0;
 	u64 bad_mt_xwr;
 
+	if (huge_page_level < PG_LEVEL_1G)
+		large_1g_rsvd = rsvd_bits(7, 7);
+	if (huge_page_level < PG_LEVEL_2M)
+		large_2m_rsvd = rsvd_bits(7, 7);
+
 	rsvd_check->rsvd_bits_mask[0][4] = high_bits_rsvd | rsvd_bits(3, 7);
 	rsvd_check->rsvd_bits_mask[0][3] = high_bits_rsvd | rsvd_bits(3, 7);
-	rsvd_check->rsvd_bits_mask[0][2] = high_bits_rsvd | rsvd_bits(3, 6);
-	rsvd_check->rsvd_bits_mask[0][1] = high_bits_rsvd | rsvd_bits(3, 6);
+	rsvd_check->rsvd_bits_mask[0][2] = high_bits_rsvd | rsvd_bits(3, 6) | large_1g_rsvd;
+	rsvd_check->rsvd_bits_mask[0][1] = high_bits_rsvd | rsvd_bits(3, 6) | large_2m_rsvd;
 	rsvd_check->rsvd_bits_mask[0][0] = high_bits_rsvd;
 
 	/* large page */
 	rsvd_check->rsvd_bits_mask[1][4] = rsvd_check->rsvd_bits_mask[0][4];
 	rsvd_check->rsvd_bits_mask[1][3] = rsvd_check->rsvd_bits_mask[0][3];
-	rsvd_check->rsvd_bits_mask[1][2] = high_bits_rsvd | rsvd_bits(12, 29);
-	rsvd_check->rsvd_bits_mask[1][1] = high_bits_rsvd | rsvd_bits(12, 20);
+	rsvd_check->rsvd_bits_mask[1][2] = high_bits_rsvd | rsvd_bits(12, 29) | large_1g_rsvd;
+	rsvd_check->rsvd_bits_mask[1][1] = high_bits_rsvd | rsvd_bits(12, 20) | large_2m_rsvd;
 	rsvd_check->rsvd_bits_mask[1][0] = rsvd_check->rsvd_bits_mask[0][0];
 
 	bad_mt_xwr = 0xFFull << (2 * 8);	/* bits 3..5 must not be 2 */
@@ -4370,10 +4376,11 @@ __reset_rsvds_bits_mask_ept(struct rsvd_bits_validate *rsvd_check,
 }
 
 static void reset_rsvds_bits_mask_ept(struct kvm_vcpu *vcpu,
-		struct kvm_mmu *context, bool execonly)
+		struct kvm_mmu *context, bool execonly, int huge_page_level)
 {
 	__reset_rsvds_bits_mask_ept(&context->guest_rsvd_check,
-				    vcpu->arch.reserved_gpa_bits, execonly);
+				    vcpu->arch.reserved_gpa_bits, execonly,
+				    huge_page_level);
 }
 
 static inline u64 reserved_hpa_bits(void)
@@ -4449,7 +4456,8 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 					false, true);
 	else
 		__reset_rsvds_bits_mask_ept(shadow_zero_check,
-					    reserved_hpa_bits(), false);
+					    reserved_hpa_bits(), false,
+					    max_huge_page_level);
 
 	if (!shadow_me_mask)
 		return;
@@ -4469,7 +4477,8 @@ reset_ept_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 				struct kvm_mmu *context, bool execonly)
 {
 	__reset_rsvds_bits_mask_ept(&context->shadow_zero_check,
-				    reserved_hpa_bits(), execonly);
+				    reserved_hpa_bits(), execonly,
+				    max_huge_page_level);
 }
 
 #define BYTE_MASK(access) \
@@ -4904,7 +4913,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 
 	update_permission_bitmask(context, true);
 	update_pkru_bitmask(context);
-	reset_rsvds_bits_mask_ept(vcpu, context, execonly);
+	reset_rsvds_bits_mask_ept(vcpu, context, execonly, max_huge_page_level);
 	reset_ept_shadow_zero_bits_mask(vcpu, context, execonly);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
-- 
2.19.1.6.gb485710b

