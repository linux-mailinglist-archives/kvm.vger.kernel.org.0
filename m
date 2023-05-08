Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1526FB412
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbjEHPpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234507AbjEHPpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:45:25 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC128A5F
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:45:15 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-50bc4ba28cbso8627638a12.0
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560713; x=1686152713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iIQ38VIBomOmPMFDfU246n+UXWZXtFCIJ3nqLHB0xN8=;
        b=opFM1F0U+82YiOgADHMMYd6XAExYsCFLGOr2rF949to2lqJZe4oj64DaZFpQZLpiB6
         jVoiWGxllJjHIDtmmlVVIMNEvrfciSkSGcpnKr9DnuNcbfrDH9AX1/eRpjG09SxqYqtR
         D7K1WGCYemVk+2RGHg0YIMKkc3y7TTPK6jbbf1cRgX48bXBFyf7PLUnILuHDd4tsfZQh
         D7Emmt/hgQx9cpWmKLKNZNrUrzmvDjqy0a/+7/P+3ZVjSU/LQwvMc0yV9TqYWcHZsFDJ
         6MV9RjVUhRd/HnSyF5hRogB1dxTv3gfCHu08lAb0kkzspwq9a2MypQ/Yx3MU7tW9Nwr/
         uhhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560713; x=1686152713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iIQ38VIBomOmPMFDfU246n+UXWZXtFCIJ3nqLHB0xN8=;
        b=RwGsZTVPOgkzW9Vkku0Sp+Pp7/T/tJb/11URQ9PEXyTZwrtLtlBSNAzgd5cIp44BeA
         UD9qUcXJGVB+/kOO8kQfUs1Zk7VVcvGq6fkFVi67rhp55FRRswdL5iTHqMFUpzOCsOGn
         jMbyt07ttLuHHa/HUJcmcjCzhEbdiUWMyfmgLfHVcIOw0bQxMjI92pOKMhC7Y0EjNtuV
         gCknUgSUHqKat58c5iBP1VBQWxnGG9IhE+AD6+u7UiZVXBg7Z2KfgcHczXRfiW8lwYxi
         lQEC/uLFqR3A1N7bO+pFQw0P6uiTkTIewQa48O7TIaWiGLWUiEbsCfrt3TSZi2cBVrq4
         zeiA==
X-Gm-Message-State: AC+VfDzDuV66IWiqSbIzspq0aJSiVlxKu0WStQ9DxRfoBG8M/B2M9/gT
        vHHrpzDqSoKI6VfWBV2f5IQqTlgY1qsPtlIflVmhIg==
X-Google-Smtp-Source: ACHHUZ44Y4oyPIY194PX0TsceDmfVHSM/iko+sA16CUZzNKbrRyzqS0mV33G0Lpwa1p5TJKfznsG4g==
X-Received: by 2002:a17:906:9b8a:b0:961:272d:bdbe with SMTP id dd10-20020a1709069b8a00b00961272dbdbemr9798273ejc.35.1683560713436;
        Mon, 08 May 2023 08:45:13 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id kw3-20020a170907770300b0096621c999c6sm121758ejc.79.2023.05.08.08.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:45:13 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 6.2 3/5] KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
Date:   Mon,  8 May 2023 17:44:55 +0200
Message-Id: <20230508154457.29956-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154457.29956-1-minipli@grsecurity.net>
References: <20230508154457.29956-1-minipli@grsecurity.net>
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
index eb594620dd75..8be583a05de7 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -438,9 +438,9 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
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
index cb547a083381..e42903aecf7c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5450,7 +5450,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		break;
 	case 3: /* lmsw */
 		val = (exit_qualification >> LMSW_SOURCE_DATA_SHIFT) & 0x0f;
-		trace_kvm_cr_write(0, (kvm_read_cr0(vcpu) & ~0xful) | val);
+		trace_kvm_cr_write(0, (kvm_read_cr0_bits(vcpu, ~0xful) | val));
 		kvm_lmsw(vcpu, val);
 
 		return kvm_skip_emulated_instruction(vcpu);
@@ -7531,7 +7531,7 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
-	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
+	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
 			cache = MTRR_TYPE_WRBACK;
 		else
-- 
2.39.2

