Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F329A6FB424
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbjEHPqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbjEHPq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:46:29 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B68A26A
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:46:14 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-50bc2feb320so7461095a12.3
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560772; x=1686152772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dS6pqwdpAx5s3Yx/zIn8Es63Zd7b+ctpDmvjcaDbCR8=;
        b=wj8z7t37nC42CBhBWUBzPbtNwtAzDMwbZ4Ntc3hd1zPoI5YWiTE99QcSlKprmYkSIv
         UXG9f+5SGRt5mdqSmK4k1p/TTl5W9kvzsHq+gNsTQuoAuhhM8a3yVXk0miq3wkszlY2k
         SsrSzR9wbJ0dDDftD1aiCBfNJJlFl+BTfrs8kQpbZQZhTJZ7SLPpp5ZAnR30e33oEnqX
         2mmCEBcd73dT5afBaV2zqdaGhx5yE2+WGaRZA9o2r2lgQdAEHsdQvvXRvXaiGAtowjl5
         X+7s7aUefr1xfCKoQ1942txyJ5AY92vlUkY7kQNOvz6w3T7uuiMKizbEpb9u8VktYUIt
         en3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560772; x=1686152772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dS6pqwdpAx5s3Yx/zIn8Es63Zd7b+ctpDmvjcaDbCR8=;
        b=AlwGpTISr5y5nL6lTYqLIpB59HOzii8kMddLktkZbQVnXO19ep3PxECOd2FKL31tI/
         K0WG/4eHdXIKIHtGh/8joKpi+SZeN2B1hummQhwaDfmnQoTlJYi3BIb9efHnOTzWDn2s
         HCxLsBTDTcvL7Ii8iLszzRmY49M7gXeWASAGI3B3gAb/itsuWlzcI9/VMagOigr8igMt
         EDuo9jDx3OJrVPf53qvoOPj271PaDnD0lNaz/FwhGIu68/mwJ2khcclNcs6n04l3GDuP
         JL/vGuCouZR6t5OnbeHvbCsg2LIykDH93aVHhbBNI7YlHB/UQX90aP3zwFLJYnlH1TvX
         r5Hg==
X-Gm-Message-State: AC+VfDz6aqUtuHbaCtniGBfsjNdgZUlxK+oJn3PWi53X1kO8J0UUZpON
        yHeLS53YnRJEedhe4bAGow/rPw==
X-Google-Smtp-Source: ACHHUZ5X/O3hd46AMx0roRxFQWpQaweDR2zZfD7RQsEaDXJN1y0K7oNFJQWEi/ceclKFTvhHNriw9Q==
X-Received: by 2002:a05:6402:14e:b0:50b:ff3c:d497 with SMTP id s14-20020a056402014e00b0050bff3cd497mr8316762edu.23.1683560772751;
        Mon, 08 May 2023 08:46:12 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id j19-20020aa7ca53000000b0050bc27a4967sm6213551edt.21.2023.05.08.08.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:46:12 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 6.1 3/5] KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
Date:   Mon,  8 May 2023 17:46:00 +0200
Message-Id: <20230508154602.30008-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154602.30008-1-minipli@grsecurity.net>
References: <20230508154602.30008-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[ Upstream commit 74cdc836919bf34684ef66f995273f35e2189daf ]

Make use of the kvm_read_cr{0,4}_bits() helper functions when we only
want to know the state of certain bits instead of the whole register.

This not only makes the intent cleaner, it also avoids a potential
VMREAD in case the tested bits aren't guest owned.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Link: https://lore.kernel.org/r/20230322013731.102955-5-minipli@grsecurity.net
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/pmu.c     | 4 ++--
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index de1fd7369736..20cd746cf467 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -418,9 +418,9 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
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
index bc868958e91f..a5009b66df9a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5417,7 +5417,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		break;
 	case 3: /* lmsw */
 		val = (exit_qualification >> LMSW_SOURCE_DATA_SHIFT) & 0x0f;
-		trace_kvm_cr_write(0, (kvm_read_cr0(vcpu) & ~0xful) | val);
+		trace_kvm_cr_write(0, (kvm_read_cr0_bits(vcpu, ~0xful) | val));
 		kvm_lmsw(vcpu, val);
 
 		return kvm_skip_emulated_instruction(vcpu);
@@ -7496,7 +7496,7 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
-	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
+	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
 			cache = MTRR_TYPE_WRBACK;
 		else
-- 
2.39.2

