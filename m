Return-Path: <kvm+bounces-21488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF8ED92F717
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 10:39:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90FC72827BF
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 08:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F9914290C;
	Fri, 12 Jul 2024 08:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="KGAy22/C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC7D1448E7
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720773558; cv=none; b=Rp94UyN9HbBmXalNoyB3uvA/nfAbmPCMjuyluCvxxt2YUaEDgcgDwwXUSSY35syXsJjS2HOesgswdrnsfRWd5hq7S8b0rozz+bsJZCn0aMOgoHkdHWyLzedz5QVrHJwwmi8T2EFvpgtPb3H5FY07jaNqlJ6Y/EFg1B3n2Wz8gRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720773558; c=relaxed/simple;
	bh=pqlexpUvH8SdD7gCfl41+7ECvKrO2BeW1xpubtVDq1Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=OX/XGn1ri/4Z3cNdkPA70ftngrAvWP8rHaKRvD05nu79ApJH3H6SYoCuxqsAgJD5Ync8r11Ucd7izbQKU5JJNb5huBwHaLcmhZDcTnIwjFX+aigC37Q/Kn5gbkwqpxARnra2dKIFob/c5syiPgD+lXvB+4rGGzr5id+WIDk2VdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=KGAy22/C; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-70af0684c2bso1382892b3a.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 01:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1720773556; x=1721378356; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qOZOdNqYBv8WGomeUEUfCET+0Nz9/2nmPAIIjSAFF/o=;
        b=KGAy22/Crd5sYNFh+Pak/0vDr6WvZOkn6b+2t1pykq/tSW52UHcCkoL8L49uTZH6xx
         gdcErVeTz55p6k/0RgoBNLQJjByR1s0x6UOR3TpHt1Uyz5u5hilg4yef2oPxqMoWbZYy
         squFwoSE9PHHdhcP5w6hBHkeSenv/4BNn9ClNFUrllGzngWMr43BkerA5aOnJ2pwU9DC
         FMvQCPV5SSxMFRIc2kZRSabHqkRG5dvsoLc2Rf4s8zOj9DDmAw113wf0kPeqKZaiwIuD
         nSvP79q8UosBMQPY1qLzF4GldGChQZk3GG0/NOjJHTJtlF/dHoyzjTzrc2WpZk6FX808
         NYlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720773556; x=1721378356;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qOZOdNqYBv8WGomeUEUfCET+0Nz9/2nmPAIIjSAFF/o=;
        b=ob7s9yyBOINvvo0yZD01M1Pr3JPlZoc1YZBe3vCOfD27C93zNOkDlucag0Y5gyCLYS
         nDVw2pOaL2uio9vEWSSCtsikyjiCK4EW6xHSRVUQtDfDLWYe/NtqxEDjqTkmPILLXC/J
         3G/8Y/UNr3MHMhuN2zmBOBDAAnExkSnn87WQv95XMJ1ZJ3Syav3cgpdW+9wH5vsbLOb6
         It7QYN2yaK2P4AkOB9QkW8vWj5PEBW0M/7yrsTFjh10WGnjaJriDudYRtjwDvQmdGMAI
         pXL0Ls4tkhUY2ttZf/pd8EOvZObr8k3r8HvlksLfhour0hAIcTUx+ipZGAvOiyyS8TL9
         7U2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWkojsy4GwLe3Vz8Z0UK4PzKDOUQ1kbQ2D69K7l/EoD+6iPjxK7cgZKdm5ymq0qgFlyM63BlXWpwb/YXzO1Cxmx2UW/
X-Gm-Message-State: AOJu0Yz4Rx0ZB6YbCUauUyod3Hj07EJJxJ8D9X1cb0DFaLMVAm4jub/P
	SdJ7nmMStsfqgSQ3j6LKBoLUml/8RePB5mmthExs2b0lWkcxIShYBvFOtag6DuI=
X-Google-Smtp-Source: AGHT+IFUgJGXqGz1rR6VQacB/sQPEJI/kBTqgZjcalyfvrrbdgNBckvS4WIfC6u8yM9C/ItjyrZEtw==
X-Received: by 2002:a05:6a00:3392:b0:706:348a:528a with SMTP id d2e1a72fcca58-70b4355854fmr11327085b3a.10.1720773556295;
        Fri, 12 Jul 2024 01:39:16 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b438c7099sm6894194b3a.84.2024.07.12.01.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 01:39:16 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH v7 3/4] RISC-V: KVM: Add Svade and Svadu Extensions Support for Guest/VM
Date: Fri, 12 Jul 2024 16:38:47 +0800
Message-Id: <20240712083850.4242-4-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240712083850.4242-1-yongxuan.wang@sifive.com>
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

We extend the KVM ISA extension ONE_REG interface to allow VMM tools to
detect and enable Svade and Svadu extensions for Guest/VM. Since the
henvcfg.ADUE is read-only zero if the menvcfg.ADUE is zero, the Svadu
extension is available for Guest/VM and the Svade extension is allowed
to disabledonly when arch_has_hw_pte_young() is true.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h |  2 ++
 arch/riscv/kvm/vcpu.c             |  3 +++
 arch/riscv/kvm/vcpu_onereg.c      | 15 +++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index e878e7cc3978..a5e0c35d7e9a 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -168,6 +168,8 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZTSO,
 	KVM_RISCV_ISA_EXT_ZACAS,
 	KVM_RISCV_ISA_EXT_SSCOFPMF,
+	KVM_RISCV_ISA_EXT_SVADE,
+	KVM_RISCV_ISA_EXT_SVADU,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 17e21df36cc1..64a15af459e0 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -540,6 +540,9 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
 	if (riscv_isa_extension_available(isa, ZICBOZ))
 		cfg->henvcfg |= ENVCFG_CBZE;
 
+	if (riscv_isa_extension_available(isa, SVADU))
+		cfg->henvcfg |= ENVCFG_ADUE;
+
 	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN)) {
 		cfg->hstateen0 |= SMSTATEEN0_HSENVCFG;
 		if (riscv_isa_extension_available(isa, SSAIA))
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 62874fbca29f..474fdeafe9fe 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -15,6 +15,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
 #include <asm/kvm_vcpu_vector.h>
+#include <asm/pgtable.h>
 #include <asm/vector.h>
 
 #define KVM_RISCV_BASE_ISA_MASK		GENMASK(25, 0)
@@ -38,6 +39,8 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(SSAIA),
 	KVM_ISA_EXT_ARR(SSCOFPMF),
 	KVM_ISA_EXT_ARR(SSTC),
+	KVM_ISA_EXT_ARR(SVADE),
+	KVM_ISA_EXT_ARR(SVADU),
 	KVM_ISA_EXT_ARR(SVINVAL),
 	KVM_ISA_EXT_ARR(SVNAPOT),
 	KVM_ISA_EXT_ARR(SVPBMT),
@@ -105,6 +108,12 @@ static bool kvm_riscv_vcpu_isa_enable_allowed(unsigned long ext)
 		return __riscv_isa_extension_available(NULL, RISCV_ISA_EXT_SSAIA);
 	case KVM_RISCV_ISA_EXT_V:
 		return riscv_v_vstate_ctrl_user_allowed();
+	case KVM_RISCV_ISA_EXT_SVADU:
+		/*
+		 * The henvcfg.ADUE is read-only zero if menvcfg.ADUE is zero.
+		 * Guest OS can use Svadu only when host os enable Svadu.
+		 */
+		return arch_has_hw_pte_young();
 	default:
 		break;
 	}
@@ -167,6 +176,12 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	/* Extensions which can be disabled using Smstateen */
 	case KVM_RISCV_ISA_EXT_SSAIA:
 		return riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN);
+	case KVM_RISCV_ISA_EXT_SVADE:
+		/*
+		 * The henvcfg.ADUE is read-only zero if menvcfg.ADUE is zero.
+		 * Svade is not allowed to disable when the platform use Svade.
+		 */
+		return arch_has_hw_pte_young();
 	default:
 		break;
 	}
-- 
2.17.1


