Return-Path: <kvm+bounces-18114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F158CE447
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 12:34:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A4251F21B54
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 10:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B42126F0A;
	Fri, 24 May 2024 10:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="PSBg/bvq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6998086AFC
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 10:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716546817; cv=none; b=M9m/fvm0iEEvmUgzgQfHDAQjOCQc17VJ7wm8L3il0Zvmr36T9x0hZqIseFqFdX1g2V0hZJPOVyjBRm9cFZ/4hus7IMcLqffiU4tGbGQ26f/Lx3ezw0XCJ0kUXLKHXi4btVvTa+CK0M9hHl5Slzy1uxw2K0ZGdn4AQyFvqAxZbBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716546817; c=relaxed/simple;
	bh=8o+/jM3VuqOdvK334SVVAiO8sfT3FG+iNmrY1VGDMO8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=RATZwNSv4oTqrja0/r9VJeDRQwNGv8K/ufjPAmnqWxo8WYPLhr8WIlFcLY56WJQa3DYPxo1hs46kbR2Q+c13/Eo2PSu/OawrjrN8m3jd+QoRP3OMqe7S7aJIGzPBZv5+MUhkaI9pOCl/+9/Zvb7roZVRXV0dr9on94KkIn+fyJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=PSBg/bvq; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-681ad26f277so567410a12.3
        for <kvm@vger.kernel.org>; Fri, 24 May 2024 03:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1716546816; x=1717151616; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WZ6BYwn5mOMy3jrtkhWqLvXB1lQ/8oP4LPFGWsTQioU=;
        b=PSBg/bvqruGiCClL8p5vUf2yjQWC7mCCG4Bdt2IK6I3EBBlKN2o96374zmbJFIfAja
         K0HMw26C+2thxDaD6QAIckuOoyzVvGD3Rw8i6jtQ8Q057NXorOVYhJ66Wv83c3+6n2vP
         YKmIJJif0Ud6I8C5/UpLdrZVJgGlLg1au/S0HQz01h1P4rkrIM6IBBeuu21DIksBHjCz
         WDzvXrQc9SzbDPQ3A5RqCd4CQExu/B+/cX2yMxVob0eUIptzPrIXEaF/j3EoxKyuHTGC
         I9CfVVnyh53FVzXWlg0A2fL9dGbA3g0uOuePFPJtvpiJ/VE6ick/tjmPlaeDDZ+K1inF
         7wCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716546816; x=1717151616;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WZ6BYwn5mOMy3jrtkhWqLvXB1lQ/8oP4LPFGWsTQioU=;
        b=vMYG8PChWH1nEgHlWo1HZqe0n+NsysAfePRb56SmV+OGDeNHqYXOyEvgAdz57clorJ
         SWrTbHb+iZuvPHM05xdGBcRKXTDAabaupEJNUgqNdekqn6uR8tGscK+VR6Mb07FppOTN
         X8LvkI7MuANvA6SqHi7nslH709+uwaJIBGUMYe81eAXKXNBKIZIPN3iAgaxHlzfQ9B+m
         bEXpsUiiLEkzMCb2lYn0up9/kzC9kKRBXJYSws62TH22rJedHw1BHRM1yl9gZFANV3J/
         TGuwuka1JPH/NnbeYDP0CzWB27ELu2TELuhkRSRpSjK27tOQeSNIPYe17SrL/hsDIhtK
         7u2g==
X-Forwarded-Encrypted: i=1; AJvYcCVBH7dauNA2OcfIWEt46JLPKqziM9II5G0vR313wbQPNUjrRzvg8xVQ7YFb9+UxQJKhwqOQrlhRpk9me45GcyCeNNKu
X-Gm-Message-State: AOJu0YzitXakYWb5zlt9epUHYBjL8EmtY2hS2J+ZjjxvNf5MMAeYrLwF
	HTuVwLoQrzAjoIKNXq4emfnktNOuWm112SqpyxO2sUcb++311ggp7Lcwy3p3MsQ=
X-Google-Smtp-Source: AGHT+IHwYRl01Pr85mA3t2HEOvg+sKlaLLf3SKTeqlscw+r+oqPR6B2j0Lab23cBYZRY16JbGWy4mw==
X-Received: by 2002:a05:6a20:6a2c:b0:1af:f23c:804a with SMTP id adf61e73a8af0-1b212e20716mr2197510637.38.1716546815854;
        Fri, 24 May 2024 03:33:35 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c756996sm10936625ad.8.2024.05.24.03.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 03:33:35 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	cleger@rivosinc.com,
	alex@ghiti.fr,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 4/5] RISC-V: KVM: add support for SBI_FWFT_PTE_AD_HW_UPDATING
Date: Fri, 24 May 2024 18:33:04 +0800
Message-Id: <20240524103307.2684-5-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240524103307.2684-1-yongxuan.wang@sifive.com>
References: <20240524103307.2684-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add support for SBI_FWFT_PTE_AD_HW_UPDATING to set the PTE A/D bits
updating behavior for Guest/VM.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  2 +-
 arch/riscv/kvm/vcpu_sbi_fwft.c             | 38 +++++++++++++++++++++-
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
index 7b7bcc5c8fee..3614a44e0a4a 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
@@ -11,7 +11,7 @@
 
 #include <asm/sbi.h>
 
-#define KVM_SBI_FWFT_FEATURE_COUNT	1
+#define KVM_SBI_FWFT_FEATURE_COUNT	2
 
 struct kvm_sbi_fwft_config;
 struct kvm_vcpu;
diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
index 89ec263c250d..14ef74023340 100644
--- a/arch/riscv/kvm/vcpu_sbi_fwft.c
+++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
@@ -71,6 +71,36 @@ static int kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
 	return SBI_SUCCESS;
 }
 
+static int kvm_sbi_fwft_adue_supported(struct kvm_vcpu *vcpu)
+{
+	if (!riscv_isa_extension_available(vcpu->arch.isa, SVADU))
+		return SBI_ERR_NOT_SUPPORTED;
+
+	return 0;
+}
+
+static int kvm_sbi_fwft_set_adue(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf,
+				 unsigned long value)
+{
+	if (value)
+		vcpu->arch.cfg.henvcfg |= ENVCFG_ADUE;
+	else
+		vcpu->arch.cfg.henvcfg &= ~ENVCFG_ADUE;
+
+	return SBI_SUCCESS;
+}
+
+static int kvm_sbi_fwft_get_adue(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf,
+				 unsigned long *value)
+{
+	if (!riscv_isa_extension_available(vcpu->arch.isa, SVADU))
+		return SBI_ERR_NOT_SUPPORTED;
+
+	*value = !!(vcpu->arch.cfg.henvcfg & ENVCFG_ADUE);
+
+	return SBI_SUCCESS;
+}
+
 static struct kvm_sbi_fwft_config *
 kvm_sbi_fwft_get_config(struct kvm_vcpu *vcpu, enum sbi_fwft_feature_t feature)
 {
@@ -177,7 +207,13 @@ static const struct kvm_sbi_fwft_feature features[] = {
 		.supported = kvm_sbi_fwft_misaligned_delegation_supported,
 		.set = kvm_sbi_fwft_set_misaligned_delegation,
 		.get = kvm_sbi_fwft_get_misaligned_delegation,
-	}
+	},
+	{
+		.id = SBI_FWFT_PTE_AD_HW_UPDATING,
+		.supported = kvm_sbi_fwft_adue_supported,
+		.set = kvm_sbi_fwft_set_adue,
+		.get = kvm_sbi_fwft_get_adue,
+	},
 };
 
 static_assert(ARRAY_SIZE(features) == KVM_SBI_FWFT_FEATURE_COUNT);
-- 
2.17.1


