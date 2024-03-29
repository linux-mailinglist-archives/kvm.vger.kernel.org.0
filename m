Return-Path: <kvm+bounces-13061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8824C8915D9
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 10:29:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B89A41C22DBD
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 09:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 427AE548E8;
	Fri, 29 Mar 2024 09:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="Y+kogVx+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE25C537E7
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 09:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711704474; cv=none; b=UzeoZFZY5mLndbwqpmK5fBlrjPn+nKToZ5S4g6163acvl0SJUbwA7vcri8lBLzFkc8OXLh7OBor2gbWha/Y2TaOS6pArPgUVU2z0Zmzbx5AfYdLSLdgvupbDq9j/tFCK1QJeaoiGW2uyzhvR5+iD6rQ/drNx1K85QgcDfIxuhmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711704474; c=relaxed/simple;
	bh=JA7UBPKQETRrngwLOp+J6IF6ItB1gKtf7ZWFX11pOa4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HROyKkkMrY1uguRDPrulVTLT+c+52NTcNyw58c9CCUix6JI5gUyW/aNpK4DRfqhg3nJ+Tw/fc42vcM1EI4PzM20uF2vVJ31gjLiaQVFuG73kErzAja9Kw91Njj3ahP+K3xo6OlgKMwrcEdTpRu322L35FrJCKSLwkmSIxgNFggc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=Y+kogVx+; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5dbcfa0eb5dso1374165a12.3
        for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 02:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1711704471; x=1712309271; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9zZjndsCXBnAhUzEP7RXDQ1mWPnsHyYv9gf2B2OXJhU=;
        b=Y+kogVx+aPSJb+/4M886ExbMfFekUnh15FdP7WFiHUXrpSqYmngEX+cR6VQgj3EN4+
         08NFjwmxuWSUZxNAKi78pmDG7fk/HXZVaS05csCUkREqDpXDqgkMH5ueWQoUXeOq0sLt
         1LKEexOzlFo15dcbz3nWq6Ei2cn8M4pcVWLD+fZbJcgGiuDoIIfQS9Td3Jf+Z3ZWvTZ0
         Z/idaBOYgq8fQDev0TmMJ6+pFwcPmycqdXoBLtXxUrTafFTFkZQQUvrFtbsctsNIWJXX
         RddcdrLfx2uz5svmgDU+KLFkE6mrDwnvmjiWFsbDNm9d9jAC7W/4p4Ha8WxG9LXdE/GQ
         79Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711704471; x=1712309271;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9zZjndsCXBnAhUzEP7RXDQ1mWPnsHyYv9gf2B2OXJhU=;
        b=MfCUh2D8pSxY8CjblzlRusLag6hKDK1tgiRDpmT2pT4oMGa9e1XDUpV0CDXCzGkn3J
         8Ha81da1n9ZuZBrjYhiFkTIMsxDwmVq0wcDqolszw31nClTt6DzUKZ/KsPMv18gknwof
         EwmqyxzhKanyh+fwZNpbL8zmtRL8igOoevqCkqr/zeCvyoNFX0xUC6fxwdryIpZ+NmI7
         oq6yohVjJR8MikrC6x3cX5Zvnu2pDh1aPnG650qbEpgOyjq4u/DOJmrkCBGWUqxu4qV9
         Np/mENEQpu4e9A4FO8R34Wg3BXYaUljgpuGGEL/MaJ4YOjjlrHDteDPv6pldufq8+Ggb
         tkFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuuHfCKmRtcfcbgi6k2ZLjNGolcKth4KLpzpk1/t07+POA4FtByKY1pJp05g6CRIuTEeQic8KjzBI+85kJ+dm1om81
X-Gm-Message-State: AOJu0YyL/iIR3GlGlpKqeEi6cMZg4zdkRRHNjpJ73YE3h6OQ9DyNBc0b
	Xfg4kLfVFua/ro8KIpcGkq/rwAqWKngH7nlNYw5M84OD3RlkFYI8ksPc/mAbvXY=
X-Google-Smtp-Source: AGHT+IFa9F+COKZa8ISch08bbNdcv43TGvP8EG5xj5dJ6X521KU5ZdxA9e79JCDBwefI9u7FZNld2Q==
X-Received: by 2002:a17:90a:ba88:b0:2a1:f3a0:181a with SMTP id t8-20020a17090aba8800b002a1f3a0181amr1796435pjr.31.1711704471054;
        Fri, 29 Mar 2024 02:27:51 -0700 (PDT)
Received: from [127.0.1.1] (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id cv17-20020a17090afd1100b002a02f8d350fsm2628830pjb.53.2024.03.29.02.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 02:27:50 -0700 (PDT)
From: Max Hsu <max.hsu@sifive.com>
Date: Fri, 29 Mar 2024 17:26:19 +0800
Subject: [PATCH RFC 03/11] riscv: Add ISA extension parsing for Sdtrig
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240329-dev-maxh-lin-452-6-9-v1-3-1534f93b94a7@sifive.com>
References: <20240329-dev-maxh-lin-452-6-9-v1-0-1534f93b94a7@sifive.com>
In-Reply-To: <20240329-dev-maxh-lin-452-6-9-v1-0-1534f93b94a7@sifive.com>
To: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, 
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
 Max Hsu <max.hsu@sifive.com>
X-Mailer: b4 0.13.0

Add ISA extension parsing for Sdtrig as introduced
in riscv-debug-spec [1] Chapter 5

Link: https://github.com/riscv/riscv-debug-spec/releases/download/ar20231208/riscv-debug-stable.pdf [1]
Signed-off-by: Max Hsu <max.hsu@sifive.com>
---
 arch/riscv/include/asm/hwcap.h | 1 +
 arch/riscv/kernel/cpufeature.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index e17d0078a651..9f8d780fce35 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -81,6 +81,7 @@
 #define RISCV_ISA_EXT_ZTSO		72
 #define RISCV_ISA_EXT_ZACAS		73
 #define RISCV_ISA_EXT_XANDESPMU		74
+#define RISCV_ISA_EXT_SDTRIG		75
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 3ed2359eae35..080c06b76f53 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -296,6 +296,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(zvksh, RISCV_ISA_EXT_ZVKSH),
 	__RISCV_ISA_EXT_BUNDLE(zvksg, riscv_zvksg_bundled_exts),
 	__RISCV_ISA_EXT_DATA(zvkt, RISCV_ISA_EXT_ZVKT),
+	__RISCV_ISA_EXT_DATA(sdtrig, RISCV_ISA_EXT_SDTRIG),
 	__RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
 	__RISCV_ISA_EXT_DATA(smstateen, RISCV_ISA_EXT_SMSTATEEN),
 	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),

-- 
2.43.2


