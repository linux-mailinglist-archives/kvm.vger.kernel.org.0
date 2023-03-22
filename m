Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD1A6C3FD0
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 02:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjCVBei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 21:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjCVBed (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 21:34:33 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA7B2E820
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:34:32 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id cn12so21304470edb.4
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1679448870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+bcoTADskNJyZKsi62570ynPgg29dBb9TzGC3hyekEs=;
        b=MLpGqNNZmG7DyxQDvtV7eW5+R8C/FkHLGWDGr9njxiRu2yKpbwwwo7ilFiycWVwk6k
         Vc6qq/eVscXPdP2SwvCKrMwOjCd1T+ipt7HWzpEdrPZa/lfYT+GC44+jMGUVSBew9zF7
         LcGsS1hIuaDN5Xg2prs5+HV7rn/pciGPD1aa1+T6d6dbnIcwg7+0C0mJthqnvrZqCQoa
         NBkLfft4nEz2sq0jfByEF40NYtBVoVUBDzCtitnEsyTxRtJ1sMRAMdCLDf4xL+ofinyR
         FYUaHnZO0ZE+8R9KLf/S4R3IC6NWZHF82AwwFih2fn5ue3scB8o236eub8PJWX0/Keu4
         b1vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679448870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+bcoTADskNJyZKsi62570ynPgg29dBb9TzGC3hyekEs=;
        b=7UnrXQdKzn23xNFsKkzUcK7lympu41lqDRbppl4JtnPI9CckQPXupLG2vTrQ4UQ2rc
         dyQroarrkYEdvHjsBn6NAACVIRByYvdaAzaaQlccOQgw9UwkZTydEdVGKDB9UAW/CE6K
         Ef3u845JDP5b8jPDyGvoH+hUZjiZxAPypW1/y00+wJcYL6iSP+fhbMrI8prJ9NMWldaE
         MoYbRKT8ZgvCRlH/mOUyCQhNg98xAorwdNsk0LgnOnTCnv7jp3pTucY4IjdgXeazRcW6
         QG8Fkz+LigUF7FIznokW2Vwq4zbr5s3r72P361shjg3rzW7nfE7lgyarrV1ic2CVBi7X
         F+vw==
X-Gm-Message-State: AO0yUKWI5LOu1gKUjpYSqrC+oatYKO47z/dO3+IjUbfx6hh2OI/lK5bS
        53o50wg+UGuyyQdQOiLQ1fxCfbi5kfqbZnPsH+o=
X-Google-Smtp-Source: AK7set+7P7kfhQIf8H6NYtsYAeq8bpUEGtxWhSFjtGgbKdd25uEBAjLIb0prRt65smuru+dZHQ4SbQ==
X-Received: by 2002:a17:907:2da0:b0:939:ad91:adf5 with SMTP id gt32-20020a1709072da000b00939ad91adf5mr6663206ejc.25.1679448870699;
        Tue, 21 Mar 2023 18:34:30 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af344e007f5e5982a136b54e.dip0.t-ipconnect.de. [2003:f6:af34:4e00:7f5e:5982:a136:b54e])
        by smtp.gmail.com with ESMTPSA id w11-20020a1709067c8b00b009231714b3d4sm6356260ejo.151.2023.03.21.18.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 18:34:30 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v4 4/6] KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
Date:   Wed, 22 Mar 2023 02:37:29 +0100
Message-Id: <20230322013731.102955-5-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322013731.102955-1-minipli@grsecurity.net>
References: <20230322013731.102955-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make use of the kvm_read_cr{0,4}_bits() helper functions when we only
want to know the state of certain bits instead of the whole register.

This not only makes the intent cleaner, it also avoids a potential
VMREAD in case the tested bits aren't guest owned.

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
index d7bf14abdba1..8fc1a0c7856f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5517,7 +5517,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		break;
 	case 3: /* lmsw */
 		val = (exit_qualification >> LMSW_SOURCE_DATA_SHIFT) & 0x0f;
-		trace_kvm_cr_write(0, (kvm_read_cr0(vcpu) & ~0xful) | val);
+		trace_kvm_cr_write(0, (kvm_read_cr0_bits(vcpu, ~0xful) | val));
 		kvm_lmsw(vcpu, val);
 
 		return kvm_skip_emulated_instruction(vcpu);
@@ -7575,7 +7575,7 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
-	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
+	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
 			cache = MTRR_TYPE_WRBACK;
 		else
-- 
2.39.2

