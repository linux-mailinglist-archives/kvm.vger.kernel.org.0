Return-Path: <kvm+bounces-44926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21E30AA4F46
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:59:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 903F41C01EFF
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 14:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34DFE25F7B1;
	Wed, 30 Apr 2025 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L5/n0Kz8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37261AF0C8
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025137; cv=none; b=K3owAesHk7A1gJJDJcGBg4xVfvRSLt/9D2LDoSrVC/g0kUeDfuCxu601QIKvU/VcKUqFeF4FD4eUs+WHA/3F9NVy5c/oZzHFFGJcomYrWBDsNmozt7HAU94GM1CgnB2HugRcsxChMDSiTu216RPFGtgcJEuHND+WvlwGdZv0aik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025137; c=relaxed/simple;
	bh=FYzX2OTAjpgnWQe7m7vHph4lXZfoFxoEPaQc9tr+uog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqGp/LGGHyvWrDkQS4PZvFvfBrTy+W6rM6e4tFuSNQkxBKv9MAEn/IIYu7YfhAjXlElm4ZofdXVoEneyVYlQMVdCm3TIf2P7jHna41h9WmUTQryl2q4d0REmzxrRtIZq42Y67a7JsHw+vfth+UIOkoXOyf1cj+M0oB3WVbDbzXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L5/n0Kz8; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b1f7357b5b6so1372372a12.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746025135; x=1746629935; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bo98cnrbBzZhIVM6McCtIYbYMjUhtLO9PiS/H/WvU/o=;
        b=L5/n0Kz88YFqZANze7dLLx8k14IPAchEHcpu4IrZSiAxsvlc/Xsta+gPRKtyBQ3zhd
         G2IOhWmlolioFIpeFgpN/HGj7jabSy4Eq7uswzStr7g1IIBPCl3DLWTkhQJYlVH1XJO+
         Ac0uxflReIkuGRNJ4DxTZF5Th0geXLjHMWwfvoZ6di+Pskx5/1s4iFTd/YHjvH5tfgeQ
         N26Owi/Ma4q10mrWNWY7cGXmAlaiLQEjBpwAWHoHobTW0puci3g8Rvr6mGLPzEUAijfi
         akzZaKD1LWxK3GKdXH2iwxHP97W1Wrd6sRnYtRFMCFNVOwdZ6Lv631cLUg46P1W2+4B8
         TpBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746025135; x=1746629935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bo98cnrbBzZhIVM6McCtIYbYMjUhtLO9PiS/H/WvU/o=;
        b=qX9MXtldvhPLffG/HeLm06qhIJ0sOrbVUNy0Up79+5of96Enc3yjkAZRpEhnR1E7n0
         3IvkrKb8Smz4b0BRMDMtcMF095CkHkX/TGFp9TUdaE9hRQzSnHyrn6GXUrJS65VTn+G1
         rKxL+3SaHI63IZ1z50SN7B0CQzFgVFCo0lOgbHogiF6LRs9prTxJ0A37yuGpmP3GaeMf
         VYhFuI+D5YqsGVF0y0ydd1eEou1iztTftxzE0yVVBu1CvAQhqQ/ndLUFFP4+yArfWQUl
         jKHffEiAG853lpUiCNGH3R/b/7zYfBUGiA3QoZqMLjP+7QCYfxVbNkHQMKN6tpD2LG5/
         UNjA==
X-Forwarded-Encrypted: i=1; AJvYcCUdK7FwKTzdsgaEyRMe2cxEUXOPH9x9/5xCQuA762vsWYbG6Dxb2kx5xKCjv0x7nGljzs8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL2vnZr4SDRt7AtbNL0bIM0KjysXWjTfdM5kT6L33uJph152tN
	D23IAC1WZgD5nbjyGykzd6eIpkqdAnSJ/ozkL5eLgkVBVGNYgVD1XDPFWjO+1Wg=
X-Gm-Gg: ASbGncuqVHTxpeieVMNQYc8Bppntx5fnENz9ZeTRPKmqV6nahFbizXE2wRUgOohbvEr
	3CgBQuwAQLqoPQ5HODJ2bORWF00fMokXC4nOX6NEKl/KjbJgIuD96iwDubY3AIKLTBv2lElOmXg
	0IzW6AaeMjtuScgrR11zFzOFO+m9zKj5YSXzkAEmzWojAkQaNHf/hPYPUQLCUK6ywkGqRlRtFB+
	JLcUv7xbcU/UXupSZUow+EjzRjLlzYM3Q1zqNKHaPNLXtFL2oqv1zXjmeZdniGHUuPWSjoiw6/h
	adlAuArG/1cbGuB3SNThIZ+pQAxQ+HjazIfq5dXV78le+VRfLvg=
X-Google-Smtp-Source: AGHT+IGh+xI14t/EUkO03K5gb8Q/Zyfxn6CDYU6KjQw8SYsR7H4FRtVnj3pTQL/XPPn0r27PGqn4OQ==
X-Received: by 2002:a17:90b:2dd1:b0:2ff:692b:b15 with SMTP id 98e67ed59e1d1-30a3336fa2dmr5823412a91.33.1746025135001;
        Wed, 30 Apr 2025 07:58:55 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a5bd78sm1705652a91.42.2025.04.30.07.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 07:58:54 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	richard.henderson@linaro.org,
	anjo@rev.ng,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 05/12] target/arm/kvm-stub: add kvm_arm_reset_vcpu stub
Date: Wed, 30 Apr 2025 07:58:30 -0700
Message-ID: <20250430145838.1790471-6-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Needed in target/arm/cpu.c once kvm is possible.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm-stub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 2b73d0598c1..e34d3f5e6b4 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -99,3 +99,8 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp)
 {
     g_assert_not_reached();
 }
+
+void kvm_arm_reset_vcpu(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
-- 
2.47.2


