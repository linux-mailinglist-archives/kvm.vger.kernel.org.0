Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B61E700912
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 15:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241209AbjELNUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 09:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241136AbjELNUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 09:20:44 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A0F2688
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 06:20:42 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-96ab81aa68dso76931866b.3
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 06:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683897641; x=1686489641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h/YBcFb+HEFX3gUhNTd2HIQMqv6srk/p3ypH72XDPVY=;
        b=TTaFDQvE6IP/SNx7SbFy4UfUD5zFQ5hM80OiHz/uAkx0MpodgOT1cyPEwuGZwODLwN
         q9PieYbGV8GaKbmSq3Lz7bCzwgyIgEHdwWIYH9ebyiG+7PCm16o7szMX2bdXFGLOVVuS
         /YF2m4Fn4bRau5UBguTFzoF5wIgec54ICe6TyDFAqrfekNCr1xJxCWyRqC+4+h3fE1zW
         Z+NUPIHJugv5EyzkrX0mObxE06lsLRPXdzAXYym0O9p4Tm4QscPHWXfvwtUmzCBgjFoY
         YCs93AnMQ6Ei9HuxIlz6eiddqK2Q8vXi/Kp8XHpD3nY1JzmCQk9rs4JjESCwiJ9yudum
         R8Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683897641; x=1686489641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h/YBcFb+HEFX3gUhNTd2HIQMqv6srk/p3ypH72XDPVY=;
        b=Ph/WARqXH2Rw/DDHFII00j4dYn7cHwHobq0tFqgkGAn5sJW0lFboJZWEqAZcbwqxsv
         2NjqERfzdUQbFZk/J+6tG8WS2TyyH39UIQY6MjykVjuNB3ILZl/jwzdqiOun4IfwSZJg
         qFSIwPN6yN5v/WOa0/dQy0OtWMnpW0D9BnzJoYaTXZLFvGqYXrW2AbX1XYJk8sJtwko0
         cqdXx7+6pw070k/WpMp6UM/om+xHhO0q2x/Rg7GVudK3HJS+05W8YAWgFTilvE7b/57f
         nxOQ183JB5LK5EYg5mv6+dNdcDtmMgjn7gKOm1WzUQj2tWaSdn+aCwg41GpwaHgcvo/h
         fzMQ==
X-Gm-Message-State: AC+VfDwJzfdv996JtpZWEFT1D9TdEdOpQxC6mFw7RMY6YSMYsZaJheni
        RLniN1vPAXL8CUpc7eOM+TFh6/tHajQvvSJRoIw=
X-Google-Smtp-Source: ACHHUZ4vwgdN5BHzsHuPe0ttCXPWQ+6kaNHYiuz85o8K9kEmDVQCguagzO0uOE8FTIlBoBe53kctnw==
X-Received: by 2002:a17:906:ee87:b0:965:6c67:11a1 with SMTP id wt7-20020a170906ee8700b009656c6711a1mr21252578ejb.21.1683897641439;
        Fri, 12 May 2023 06:20:41 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af43a100a78da3f586d44204.dip0.t-ipconnect.de. [2003:f6:af43:a100:a78d:a3f5:86d4:4204])
        by smtp.gmail.com with ESMTPSA id w21-20020a170907271500b00969dfd160aesm5077981ejk.109.2023.05.12.06.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 06:20:41 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 6.3 3/5] KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
Date:   Fri, 12 May 2023 15:20:22 +0200
Message-Id: <20230512132024.4029-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230512132024.4029-1-minipli@grsecurity.net>
References: <20230512132024.4029-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
index 612e6c70ce2e..f4aa170b5b97 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -540,9 +540,9 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
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
index dd92361f41b3..64b35223dc3d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5500,7 +5500,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		break;
 	case 3: /* lmsw */
 		val = (exit_qualification >> LMSW_SOURCE_DATA_SHIFT) & 0x0f;
-		trace_kvm_cr_write(0, (kvm_read_cr0(vcpu) & ~0xful) | val);
+		trace_kvm_cr_write(0, (kvm_read_cr0_bits(vcpu, ~0xful) | val));
 		kvm_lmsw(vcpu, val);
 
 		return kvm_skip_emulated_instruction(vcpu);
@@ -7558,7 +7558,7 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
-	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
+	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
 			cache = MTRR_TYPE_WRBACK;
 		else
-- 
2.39.2

