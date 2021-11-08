Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD59447F9F
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbhKHMrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239601AbhKHMrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:47:10 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F72C061714;
        Mon,  8 Nov 2021 04:44:25 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so8723256pjb.4;
        Mon, 08 Nov 2021 04:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XGkAh2kPauX2NV9OTG6gnpHhdpc8cmhMr1z1fLSTluI=;
        b=C64QvIVVeIVHJ1BqQ5tmKNgFBhfQ6o1SaYKTErmZEfms5zQZVbcRv7dfy3puE9UdUf
         2/OS5Ke9+IfunQb9omi9HxnkL6GVKcBXqmtpnD9X3M5iqNt3NVkV5v/c6vAmxkSuDVM9
         QaItnHkFTnLlVDAqH6A5STHFf1azokcEdBH7DTVnzyL7ifjk+Riz1bQQKtDnom11MS9T
         n8NarqpKIe9r2Cr5DVyODDJIDHAb7WlRAi/9sZfEhmE0eurmsEdvIj1Vhtc5f0OaqjgI
         W1cbIwOBhg/Y8STgbPL3ZxZA12GxM4Cf58lTFei7cidIqzB9AP1bk+yj9RFtzjBRtXu2
         iwSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XGkAh2kPauX2NV9OTG6gnpHhdpc8cmhMr1z1fLSTluI=;
        b=uVEeSZQP+essxY40A3Vab8mG5mojHB+7BjpADbDVEQoHVkZbWBhSuxbpYWkqMGQd39
         Zk2AntEVaYWZGmEGvHcsBAyinV4nYQ8iYtfe8xiYgJfElAsE2JqyIJ06O8nv+RnBr3o/
         Unz6bGsIU6sIo1JMCcC3kd2Np7zIOX8xQRhSXszGhSNlJ5fAG79+qQOO7Y6aMqxwFypA
         gZT/Ra+aE3xXbUg5huRjK4zbQSxhSyTIGMBrD5GSSmDPPINIgh93RI02Pd2lPTusbZMx
         Yh7z2+R/lMWG2q3ZiHcgLcQfSWnu5bKTA2Y+pYVka5hI91U2XrHqAZ03O1J5z7vD9ebY
         xTLw==
X-Gm-Message-State: AOAM532YuuN3k09kHQg4Hl4lNX2bWEsivwtIOxRwizVCCwGJZ/7oRoEn
        AU8dDCmhzYCLibjuQO1ArcDeOIrev4E=
X-Google-Smtp-Source: ABdhPJwCt5dIDMSBbFz2LdiyHbg9sJVzpKI+qrobDbHWbyRg77cDNe4+BeWJGiMDs24z9wnh8QtqLQ==
X-Received: by 2002:a17:902:b08a:b0:142:51be:57e2 with SMTP id p10-20020a170902b08a00b0014251be57e2mr20076724plr.53.1636375465226;
        Mon, 08 Nov 2021 04:44:25 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id p14sm13201801pjb.9.2021.11.08.04.44.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:44:24 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 03/15] KVM: SVM: Always clear available of VCPU_EXREG_PDPTR in svm_vcpu_run()
Date:   Mon,  8 Nov 2021 20:43:55 +0800
Message-Id: <20211108124407.12187-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Make it the same logic to handle the availability of VCPU_EXREG_PDPTR
as VMX and also remove a branch in svm_vcpu_run().

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/svm/svm.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 88a730ad47a1..3e7043173668 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1583,10 +1583,16 @@ static void svm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 
 static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 {
+	kvm_register_mark_available(vcpu, reg);
+
 	switch (reg) {
 	case VCPU_EXREG_PDPTR:
-		BUG_ON(!npt_enabled);
-		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
+		/*
+		 * When !npt_enabled, mmu->pdptrs[] is already available since
+		 * it is always updated per SDM when moving to CRs.
+		 */
+		if (npt_enabled)
+			load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
 		break;
 	default:
 		KVM_BUG_ON(1, vcpu->kvm);
@@ -3964,8 +3970,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
 	vmcb_mark_all_clean(svm->vmcb);
 
-	if (npt_enabled)
-		kvm_register_clear_available(vcpu, VCPU_EXREG_PDPTR);
+	kvm_register_clear_available(vcpu, VCPU_EXREG_PDPTR);
 
 	/*
 	 * We need to handle MC intercepts here before the vcpu has a chance to
-- 
2.19.1.6.gb485710b

