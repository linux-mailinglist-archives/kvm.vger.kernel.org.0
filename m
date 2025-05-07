Return-Path: <kvm+bounces-45812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F3F3AAEF93
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:47:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDFE1503579
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E4E2918DB;
	Wed,  7 May 2025 23:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hiGfV85S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88191291894
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661619; cv=none; b=Rlyh4tzPlXt3shB6zUKsm95a4NlizPgbKaSlRIephdzaDsb+40gamMCLFYoqIomrDiS/MvFAALk1pphZIZXoRaiOSIBhx2IsakrUrx/CcvBLjcu7riBq81vqgE0YWye7WUnhJbS5AFN8TLnvz/9rLwn6ADKX03sFYHg49ntu04s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661619; c=relaxed/simple;
	bh=3sGyP86UENDY/fMxA/0FMzQKDribcClfmi7HIU8oX1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ci9yQWIFexfu72K+YkMueRzP6toJtbh93QWLLFqnmIYtx4XflHK9L7GJNhWjcgIU6IjYEdwh+rNuOMoVUgDlh1P0KDNoIgmNdX5rxa+lWM2u4CUggUm42elCQafgq8iPO8cgc6nOoZQ5M2URNuL4nbU73C1f4G8pozscqg8JOLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hiGfV85S; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22c336fcdaaso5182285ad.3
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661617; x=1747266417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iy4NKdbqFEoI1LwuiWAT6ispFyw4zHMXwGZpZSKm4tQ=;
        b=hiGfV85SpLdCBS64BuF9neGVY6R103VbxNtnSJHYuDwjlcPPlDa5F3l1htqEE1pWxW
         ZR0qB6S/0EK0wk8RNUeQmPinxFRcORbsR7x4RGjFK6K/gMGUoREH+kmLEKviM/OY8m47
         8D4h92cSIlwQDxw2uyTiS6EXjUCqR+fsQqalkr98sKzUByLQHh091rxerFAMRDA6tCkE
         kJbR+vZuUB1M7Ho2+ZGRt5y6GFVvfQFKn0IyigSUmQW5jR2Ul8EdAYmaW28iIL8Mx7xl
         MuoO09Qd0/LEvOb61/wfh2yucCaqLvuf3cppUiGzRKSjx4Eiht5cLP1byM+eGE+yYOmw
         E/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661617; x=1747266417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iy4NKdbqFEoI1LwuiWAT6ispFyw4zHMXwGZpZSKm4tQ=;
        b=xG4McLJpYgvfg26P3gIsS+cMOmHHdVtxageXQeFJ9xKDeiVY5mA7OUNJrgVICtPBbl
         QI4hYcWdmHa9FLX6r5zAuZ7JfOKT1/8CL8uAt9qDChJ1HZvifP+EwhTY7oM7RTvdQ77Y
         co9Y3/ErTxNWqQ61QBq4sF2shG+n6+e6HcsgEOqBdm5Xw1/mcOjO7i+BH9GoPWwgiYJX
         dfrbQhSjJ+cRx73f/F+E9uUCpTY++uk416npBCRhcAEF4/DtlcmcPiWdQ8CCPXfLPvUr
         iYPk/2r67NiCObhUM3TIdMeQollvYTyh7zuftqgaXLEZWG63wJzXuON3/RnGKtdgWSqf
         YrWg==
X-Forwarded-Encrypted: i=1; AJvYcCW1uKt4+aMXJwMcmzhI6JaOnVPVyiPWcH64LAUGAdntChmZZRWRMDhmH4A/bV/7pM7Ue54=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdvzYlD292vd8FPLOk46Y8x2iIbbJJRGSvs4FgyRlVHRg9TlDX
	tHV6ql3oQFscM+HL6UzDMwgSQJsCuzDorPbjXr1yWq5XPH9diU7hv6LNil6zAsg=
X-Gm-Gg: ASbGncskQh1WRSHBLXgyAJj+4QZRwc9R3DAr15ngY3zO7qsCzD6346nClq55qk4gIvh
	wpwJNmJHvPNcw+cSUT1gLLmPova/uik2xf2o9RWJo6vkoTPAaWlIY1SD1CFcd3b8QLWB9vYxnm/
	/BkAA6lzUjbMeP7XdOcHsNrn2LlSLrVrdLCjueTkEE4G9htE+8Avqrg2WEtiuYhvwOXon+gibdG
	zHwqoW2vsMwhEibumQ32TGmaLEa6Lf8ZS2RLb3zHTiGCNoE6LIHEFSQwdwoUDAJF4t8rekCiD2c
	Wrjk2LQQEHGS613V4ydpotx8li2C4wdoQExNbSr8
X-Google-Smtp-Source: AGHT+IHof0yGRKomWjIKigklmtvQ5jmLC5TJCNDejIRDGpUvjaUrG8dHyZvJSvt3A8FELVtsKi1m3Q==
X-Received: by 2002:a17:902:f607:b0:224:10a2:cad9 with SMTP id d9443c01a7336-22e865f74aamr20930515ad.41.1746661616957;
        Wed, 07 May 2025 16:46:56 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151e97absm100792435ad.62.2025.05.07.16.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:46:56 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 46/49] target/arm/helper: restrict define_tlb_insn_regs to system target
Date: Wed,  7 May 2025 16:42:37 -0700
Message-ID: <20250507234241.957746-47-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allows to include target/arm/tcg/tlb-insns.c only for system targets.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index e3ca4f5187d..0f3d11b0e12 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -7764,7 +7764,9 @@ void register_cp_regs_for_features(ARMCPU *cpu)
         define_arm_cp_regs(cpu, not_v8_cp_reginfo);
     }
 
+#ifndef CONFIG_USER_ONLY
     define_tlb_insn_regs(cpu);
+#endif
 
     if (arm_feature(env, ARM_FEATURE_V6)) {
         /* The ID registers all have impdef reset values */
-- 
2.47.2


