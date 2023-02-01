Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E870F686F1E
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 20:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbjBATog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 14:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbjBAToa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 14:44:30 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9393A7BBFD
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 11:44:29 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id hx15so35096128ejc.11
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 11:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KunpYARU3Z8opuHOQvkXAppY0penEFLU7lOORGdMuTM=;
        b=AI1HafiS7yvl+3Vfl6WZGwTbF4dqFNC7qE0AlRRxIcILQypAR3O1OWlF8mQVoGQ/aN
         mPFTcy+IcLwRC9EpggiAmx2I7s2RFGMAWK3OWFi8Qo36/dHwJnxDx4Z7q3dTJP35uKan
         EjiialoxgW7rIayXBv3gpS2QYrrVFaOnZZPeXZpVs3xdSEPsXpz91JLi40vUF26p5HK6
         RImt/CnMpqcbH88FaixMQAmxzE6C57B+3hSyFkaCI3IvkQyGK2lqHBhFCWzhkNcK5FMJ
         sl68khinMx9LmNefwLC8hP5uKyf64IkbT9FRHCvBQB9EEDkQBfaB66dsVn88wIQwazFW
         GApw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KunpYARU3Z8opuHOQvkXAppY0penEFLU7lOORGdMuTM=;
        b=6tAR0zkDX1cShaE45fUYIZgMRWbgnS2HqUjgrMB6WXwKOoJksCmLOi41r8b/k2Yk3K
         EnRcHaDTU/FQVYtB3bALaWCVCuQcrPjEoa1F0gVKkivJhcx1PxXfk33cjFM8EqCwtjdY
         V1bRrEINuxbWPk4t5mY7w5hkRaUqsJ6oOzv0EcazmaHV6mCXEcf2kcPD3l7hydYtnU2p
         fD9JD0fh6PLoKT+Ag2VawX+OJkvhBN2EE5jy+LK28U1iS+C6isLyvMAtyCtVu1qLPzIO
         Vi1zu9nFADVEGp2W+mYDWQJezbNIB/NkmQ9aKtmzB5gGkyFB+UwByjAac1WvUEqTNbSl
         ZHmQ==
X-Gm-Message-State: AO0yUKWuy0YaidB80KXSp5zfWWNaUFsBFg7cp7gs4ow2hV1AIUuBFX0+
        mSL8yyOp8E6xcIzi+uU92FANSzfGwDPFZIny+gE=
X-Google-Smtp-Source: AK7set/JFfkn/b5GsffBgc4e8Fy+BrGURO7rdpefg0PJWlsJ1HiIwkSDMzFQxUbFqL/TkWiGPU1ktw==
X-Received: by 2002:a17:906:dd4:b0:877:667b:f1e2 with SMTP id p20-20020a1709060dd400b00877667bf1e2mr3330879eji.11.1675280667922;
        Wed, 01 Feb 2023 11:44:27 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af111a00277482c051eca183.dip0.t-ipconnect.de. [2003:f6:af11:1a00:2774:82c0:51ec:a183])
        by smtp.gmail.com with ESMTPSA id c23-20020a170906155700b00869f2ca6a87sm10397579ejd.135.2023.02.01.11.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 11:44:27 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v3 4/6] KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
Date:   Wed,  1 Feb 2023 20:46:02 +0100
Message-Id: <20230201194604.11135-5-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230201194604.11135-1-minipli@grsecurity.net>
References: <20230201194604.11135-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make use of the kvm_read_cr{0,4}_bits() helper functions when we only
want to know the state of certain bits instead of the whole register.

This not only makes the intend cleaner, it also avoids a VMREAD in case
the tested bits aren't guest owned.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/pmu.c     | 4 ++--
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d939d3b84e6f..d9922277df67 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -439,9 +439,9 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (!pmc)
 		return 1;
 
-	if (!(kvm_read_cr4(vcpu) & X86_CR4_PCE) &&
+	if (!(kvm_read_cr4_bits(vcpu, X86_CR4_PCE)) &&
 	    (static_call(kvm_x86_get_cpl)(vcpu) != 0) &&
-	    (kvm_read_cr0(vcpu) & X86_CR0_PE))
+	    (kvm_read_cr0_bits(vcpu, X86_CR0_PE)))
 		return 1;
 
 	*data = pmc_read_counter(pmc) & mask;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c8198c8a9b55..d3b49e0b6c32 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5487,7 +5487,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		break;
 	case 3: /* lmsw */
 		val = (exit_qualification >> LMSW_SOURCE_DATA_SHIFT) & 0x0f;
-		trace_kvm_cr_write(0, (kvm_read_cr0(vcpu) & ~0xful) | val);
+		trace_kvm_cr_write(0, (kvm_read_cr0_bits(vcpu, ~0xful) | val));
 		kvm_lmsw(vcpu, val);
 
 		return kvm_skip_emulated_instruction(vcpu);
@@ -7547,7 +7547,7 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
-	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
+	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
 			cache = MTRR_TYPE_WRBACK;
 		else
-- 
2.39.1

