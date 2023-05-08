Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06FF86FB434
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbjEHPrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbjEHPrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:47:42 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51ADA6A6E
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:47:22 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-965ddb2093bso582750266b.2
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560840; x=1686152840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HHmXGDybyVXf4mNmP07Oe+6ZNUXie//tYnOgK70dlKg=;
        b=UTZmsSXGep1QE4N9XDRzcd6Ry3MOrvaoJuZVF5S7z5CvAOF7aZGKRVvaKetzVDoW26
         CgNaXecyd8vO+Gt5ky2a3gCg90TcMAf95SUMDybyXTGx5SM5LMsV6OAH/FaPT0eLvNUT
         LKHOQPANpOoSvYChe8ag/4s7bN5ydbEKiVbz1SopRqzZR4bTZvafPnVtOhgj+5JQ07Ia
         JBk3PJNZBKW8tsEPx49Aw2G46x83RV23l4XYUZTdLTE5GGHDwb96YnUGtXikck0+hmhg
         ryMUfH3waPF2rmXx6ZG2wADQjNDHFY0+lOsxLCeOXcM/DdOG2VVEpB7b7Wgy9Y5kTZKd
         jdsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560840; x=1686152840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HHmXGDybyVXf4mNmP07Oe+6ZNUXie//tYnOgK70dlKg=;
        b=hsCjeC8SkGsp7k6MZniSHVR5Bg6tnTvuc3Nf0wxh+bJFvtEQ8sl0yx5mi3mLx8kFKN
         3k2yNXxzLtc+h83T2CJqS+asnfPDU36M3s8nFGZEiinFG5bLGsHrarNLADbt1Rs9qRmT
         JDPJYrh9jb5cX7NzqYXUqqBLHkdkFVTsUiItarCmEx5ETZTCciVwfj3z9GgM1kuUeEfR
         ofBZbr2mygod4tOzUs3c/Uw+nY6kVeuofK7j5jlWwcC8ix7Z3zug4JVqWLl60jLzCYoq
         DaYGcKxL6dsI6kfJS6gIYOM40OH2NolIa/rfqI2vFwb1VrgtM9syLoEZ3GF8JiklfmAJ
         5ZTg==
X-Gm-Message-State: AC+VfDzyXUn8rSHcxUN1wX7jfdo+uVsKESa3osBQCu1pG5xiekbWs2zp
        vxv1j7nsVPLh+kBWR/dAIr3+BA==
X-Google-Smtp-Source: ACHHUZ7T/bLCeIH5G/5peVnVqvHaz7wkUnmjLE/SSKcC90BfNoETEPcDcPEPVzIgPdQgX0CxLnMwKQ==
X-Received: by 2002:a17:906:dac5:b0:94a:4fc5:4c2e with SMTP id xi5-20020a170906dac500b0094a4fc54c2emr8739273ejb.49.1683560840518;
        Mon, 08 May 2023 08:47:20 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id md1-20020a170906ae8100b0094b5ce9d43dsm121822ejb.85.2023.05.08.08.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:47:20 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 5.15 3/8] KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
Date:   Mon,  8 May 2023 17:47:04 +0200
Message-Id: <20230508154709.30043-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154709.30043-1-minipli@grsecurity.net>
References: <20230508154709.30043-1-minipli@grsecurity.net>
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
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v5.15.x
---
 arch/x86/kvm/pmu.c     | 4 ++--
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 62333f9756a3..5c2b9ff8e014 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -366,9 +366,9 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
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
index c95c3675e8d5..566367409598 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5128,7 +5128,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		break;
 	case 3: /* lmsw */
 		val = (exit_qualification >> LMSW_SOURCE_DATA_SHIFT) & 0x0f;
-		trace_kvm_cr_write(0, (kvm_read_cr0(vcpu) & ~0xful) | val);
+		trace_kvm_cr_write(0, (kvm_read_cr0_bits(vcpu, ~0xful) | val));
 		kvm_lmsw(vcpu, val);
 
 		return kvm_skip_emulated_instruction(vcpu);
@@ -7149,7 +7149,7 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 		goto exit;
 	}
 
-	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
+	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
 		ipat = VMX_EPT_IPAT_BIT;
 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
 			cache = MTRR_TYPE_WRBACK;
-- 
2.39.2

