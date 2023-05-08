Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E940A6FB449
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbjEHPtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbjEHPtH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:49:07 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9377DA5D4
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:48:37 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-50bc37e1525so9163879a12.1
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560899; x=1686152899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1M2QwCPvuhfE1NKXT05PI8v/YEjTDoq9lyCyoiIhl/M=;
        b=J1OMGN1vl2on8cDTL9lfgRL6QzT8uiR96+CvxbPWK3h2A03eY/Q6Yn40NDedyf77bh
         2PAWZurZRTQ0kLJ5tvCqNLn12o5RaOUduKJCOp/qI8tFyTxPtVkgxNfzNxnExa+C9TS3
         ZyxHRNv1ESmB0AoHvrp7Ag6v6IiyyY1PutlM/PTAgWbgdQKXQfexr+dKjWy3mwkT7gi2
         Z6vYR8Fs1HCBsh+LKkTp0VUt8/Dy6+u9iEBPKujqpy2azrSYB6iy0M/gtCYhm89lMP80
         eg4ducXtyL6JDqELOMXm/r8C5l4Bt5kPupEMHXmQtHtjPkMSdIZ2eulANLth1JTBqYIj
         AI+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560899; x=1686152899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1M2QwCPvuhfE1NKXT05PI8v/YEjTDoq9lyCyoiIhl/M=;
        b=ax3U9tZSUUKFaLKl0ek3udOYvU+Nobf6pDVCTf3xkfhtTHoJb66UOJJNmps9pTa/9i
         oJbWI1l++OOMDdTP/P8aqtAqGAiBG8OumUh6XavCF1KB0vxM6IJHg4a6oKQyIG5Xt202
         BBZ7i2MzAQWsMHejgLZOnhvo6YcVMimv1GB5urgk6cJlHJMb2rxb58PrXwEYbGBj3Fuw
         QynM79gd1pjMhyd9SckGtR8c8ow73Afo1qhqBMYpwumeR01ym0UOj2rV7ME/SZMDj6QK
         zieah7NEMcO7/aalXtL0Gvq9U/jak4ccBVjSSD6bxdeSd9Dqxkm2lQbwHkQmsk9qqnp/
         gI+g==
X-Gm-Message-State: AC+VfDyVlyH/PwoOR0TtCwxb73A7NA3q48ic+teIdJno64hc6FCFYM9/
        9+sUyC6LGE6xjlQI2lzlA1tZo8P7M6JT1qayJ21aTw==
X-Google-Smtp-Source: ACHHUZ5TY2ijNlqQ+P690y3IyhkwKgfmYeWE/+r04wSrGgiGHKT87MYC9f+wAk+/oEBJ86klwz1lyA==
X-Received: by 2002:a17:906:974b:b0:957:943e:7416 with SMTP id o11-20020a170906974b00b00957943e7416mr10354487ejy.15.1683560899765;
        Mon, 08 May 2023 08:48:19 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id k21-20020a170906055500b009584c5bcbc7sm126316eja.49.2023.05.08.08.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:48:19 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 5.10 03/10] KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
Date:   Mon,  8 May 2023 17:47:57 +0200
Message-Id: <20230508154804.30078-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154804.30078-1-minipli@grsecurity.net>
References: <20230508154804.30078-1-minipli@grsecurity.net>
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
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v5.10.x
---
 arch/x86/kvm/pmu.c     | 4 ++--
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e5322a0dc5bb..5b494564faa2 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -374,9 +374,9 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (!pmc)
 		return 1;
 
-	if (!(kvm_read_cr4(vcpu) & X86_CR4_PCE) &&
+	if (!kvm_read_cr4_bits(vcpu, X86_CR4_PCE) &&
 	    (kvm_x86_ops.get_cpl(vcpu) != 0) &&
-	    (kvm_read_cr0(vcpu) & X86_CR0_PE))
+	    kvm_read_cr0_bits(vcpu, X86_CR0_PE))
 		return 1;
 
 	*data = pmc_read_counter(pmc) & mask;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2c5d8b9f9873..db769fc68378 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5180,7 +5180,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		break;
 	case 3: /* lmsw */
 		val = (exit_qualification >> LMSW_SOURCE_DATA_SHIFT) & 0x0f;
-		trace_kvm_cr_write(0, (kvm_read_cr0(vcpu) & ~0xful) | val);
+		trace_kvm_cr_write(0, (kvm_read_cr0_bits(vcpu, ~0xful) | val));
 		kvm_lmsw(vcpu, val);
 
 		return kvm_skip_emulated_instruction(vcpu);
@@ -7212,7 +7212,7 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 		goto exit;
 	}
 
-	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
+	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
 		ipat = VMX_EPT_IPAT_BIT;
 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
 			cache = MTRR_TYPE_WRBACK;
-- 
2.39.2

