Return-Path: <kvm+bounces-15083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D264B8A9A3C
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:47:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7F891C21E0E
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 12:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB92416C695;
	Thu, 18 Apr 2024 12:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="wrdZg5k7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD44168B04
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 12:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713444249; cv=none; b=cuDDDOowR0F/GkyCNbsFAZnTOv4Od7zhVxg2qFMGehtAlD0IhGH5rPYHcIGAfokgGS0P/wZXxsVKcmkKjuLnqyq2v9M6iDtqX4g0+N8uTFm1PRDwEOhjzWkCB6KmUkwkZDd1oBzVHKVrihX4naF085IuJmk9hKgt8HBCDrbRL8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713444249; c=relaxed/simple;
	bh=VBYIkTZIleyOsUo3Vs7GTW09WzwtONhQK0/AstEMTYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aGstXjvPJttF5aav4MWv/6LmWhMOGrmJBSuu7ErJeHvh48U+vJxsJxNwu7tD4yTHoyAtvUUGxSRC05rSRWMc+ENdQo21GpyruFABm5Qm902PuzXPMLmbhwwEqn0iZmtB3v3vYdosfKVIAtiGrwrmoogGd96v0/55S45WoaV6qUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=wrdZg5k7; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-346407b8c9aso222974f8f.0
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 05:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713444246; x=1714049046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rdCfPjm06PN8DLWdVlWU7iGB8QhHqS8f5T3HQCXkkpY=;
        b=wrdZg5k7YDT5lFIY1gLMfU0QxbdSnmnXom/WAvGceN+EsWONrwyT1cXaYixHB/VKW/
         kz7Bc2dr9lYtyTu93/yKIc5eGINGRACZ9x1SaqvtK5C9AGVpOHeZc+Jsv71V1lFqk0Yw
         dhyrBLfTtdHfZbXTjrkLBScl48FClZ35r0xCig976i7WPtQdWiNfwc9OroY78j+nGib2
         k0vKQddbSnnpdzRSBBJY/pzH9p7v4iTB602iXCakdt+Ooo71otlduoG7C7Acv6UKyrnF
         qxoXc7rWKtSmHGcaRv5XlTVQSxJlt3vzPVALlMPMXKPpAPwBcE+krRUKuqhkZwiYVkZa
         2Mlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713444246; x=1714049046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rdCfPjm06PN8DLWdVlWU7iGB8QhHqS8f5T3HQCXkkpY=;
        b=pSu+Aj1Qc21C4P/nbdCkSS6BhhspwkTeT5MslvGqpPFR3xrgXqSn1Kf/TLn0IxtU5c
         siTwhLikqeeS1gaEVfJsbra3GCn1dMotKck2qC9c5c2Da2Kb9eM2CouK7Rm1HmdriL12
         ZpCjyLm/Em04pmtDZ4oc5+cHGozFYZM7sPGprBUj4/iUaiCXchRHAWd1cIlqe23GLV1Q
         4oOb3TN5Dst1Qi6kVT5Fd+3qoyPiFZ2t3Ge9qtjLHEKxbq/e6DASQ2jQq5Q56xFT6L5C
         8GuhdlJbwtq1CY1RhxYfrfYgv/KRskZgpDpmujtGET40COi9579hXG7K5oeYR3I4Ajup
         cx9g==
X-Forwarded-Encrypted: i=1; AJvYcCVk4GZsyGzbQSd4+9Kt5ZRHXjtqJ8AQSAignWV/ND95GOJmNXf1qe6rsB1oV1snrjT9hwcVwGLt8ZdHQgpl6Snly63Y
X-Gm-Message-State: AOJu0YySm/1lA6gUMCfxvyp9fc+YZRm4Y5FK8mRePPcj91tGYPeDwOhg
	iyjiYA/A1eqgTCDss+m4LWCAvjiy3H6yUz/TEJhz6HqPvxfD/uymn6lx2tbqXvk=
X-Google-Smtp-Source: AGHT+IGMuL1VEcAVu36oqMeDfSFjQ3yk2Wj7i500rFn3wK2To4nptMyU7omA9B2isyVdkpsEUDxcgg==
X-Received: by 2002:a05:600c:1ca2:b0:418:2a57:3806 with SMTP id k34-20020a05600c1ca200b004182a573806mr1932349wms.0.1713444246501;
        Thu, 18 Apr 2024 05:44:06 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:7b64:4d1d:16d8:e38b])
        by smtp.gmail.com with ESMTPSA id bi18-20020a05600c3d9200b00418d5b16fa2sm3373412wmb.30.2024.04.18.05.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 05:44:05 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>,
	Shuah Khan <shuah@kernel.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Atish Patra <atishp@atishpatra.org>,
	linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 10/12] riscv: hwprobe: export Zcmop ISA extension
Date: Thu, 18 Apr 2024 14:42:33 +0200
Message-ID: <20240418124300.1387978-11-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240418124300.1387978-1-cleger@rivosinc.com>
References: <20240418124300.1387978-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Export Zcmop ISA extension through hwprobe.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 Documentation/arch/riscv/hwprobe.rst  | 4 ++++
 arch/riscv/include/uapi/asm/hwprobe.h | 1 +
 arch/riscv/kernel/sys_hwprobe.c       | 1 +
 3 files changed, 6 insertions(+)

diff --git a/Documentation/arch/riscv/hwprobe.rst b/Documentation/arch/riscv/hwprobe.rst
index bf96b4e8ba3b..e3187659a077 100644
--- a/Documentation/arch/riscv/hwprobe.rst
+++ b/Documentation/arch/riscv/hwprobe.rst
@@ -212,6 +212,10 @@ The following keys are defined:
        ("Zcf doesn't exist on RV64 as it contains no instructions") of
        riscv-code-size-reduction.
 
+  * :c:macro:`RISCV_HWPROBE_EXT_ZCMOP`: The Zcmop May-Be-Operations extension is
+       supported as defined in the RISC-V ISA manual starting from commit
+       c732a4f39a4 ("Zcmop is ratified/1.0").
+
 * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
   information about the selected set of processors.
 
diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index dd4ad77faf49..d97ac5436447 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -64,6 +64,7 @@ struct riscv_hwprobe {
 #define		RISCV_HWPROBE_EXT_ZCB		(1ULL << 38)
 #define		RISCV_HWPROBE_EXT_ZCD		(1ULL << 39)
 #define		RISCV_HWPROBE_EXT_ZCF		(1ULL << 40)
+#define		RISCV_HWPROBE_EXT_ZCMOP		(1ULL << 41)
 #define RISCV_HWPROBE_KEY_CPUPERF_0	5
 #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index 2ffa0fe5101e..9457231bd1c0 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -114,6 +114,7 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 		EXT_KEY(ZIMOP);
 		EXT_KEY(ZCA);
 		EXT_KEY(ZCB);
+		EXT_KEY(ZCMOP);
 
 		if (has_vector()) {
 			EXT_KEY(ZVBB);
-- 
2.43.0


