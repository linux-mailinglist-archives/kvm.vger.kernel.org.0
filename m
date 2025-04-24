Return-Path: <kvm+bounces-44203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6267FA9B541
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 19:34:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5AD05A6B01
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F64F28EA5C;
	Thu, 24 Apr 2025 17:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="WJwCQifU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085812D052
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 17:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745516027; cv=none; b=R0uIUt7Wy9Kb13ZPu2IPELhiQAo+NBGg48nid3IbsweCYrXifjbpyg3btawQwixAPt2vlf+FekwWAFV1g0eNoIsOituYa1eGuN8j6gklvf8c8b/OCm/IgT6iMePe3pOnqsjFIJhLS+FDHBFnR00s/Ju4k+FsdP67c2YcgGaOTlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745516027; c=relaxed/simple;
	bh=aFqX3fLDtG8cy76aRcSSCxbszjtqQl817f+Kcc6ZMK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OKYvH7P6MsNAF/YTru4hd1huhfQ7gSqep+vAGlTD5kg9IGhcWHonmMi8u4k53FlKXxRAoE26oMqzGIsKIt5wCFRCkCSmI2a6AyH3YftjoCSIUGlJOmJYgbdz4zcoB2LlhRR2OC1FH6TzGIW4uowxTfAvFrGt7yWifUIPW5x8n+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=WJwCQifU; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-227a8cdd241so18090205ad.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 10:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745516025; x=1746120825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MqV/L1fucoXh0zEq3ZbEkv0iZBTOf63rS7eOzOMDARE=;
        b=WJwCQifUIjEIFJgV0n05o7j7lWn9dcycnDP2Pyyrz7rerqfFUHvaYfGjn5GAoMnJo7
         2zRQRzRBACmMJ+eSOPqkgYRZ+wughP9TcJHqjhf0Zanmhq1XpnFwldRUmlcmCw/KkN/g
         ySIihldhHHDzcVWgaLuMNSxZRrEgeFJK/YDCFXjQdTyx5nJ8F2opt3YduaiIxaTl+MBU
         dn5fxv9OjXJe3ryU444b0heqdljT2FCo0fmAVG6yLt5tt75SpZTvS00jm9Bwgz0uQrTe
         8IfFxPqD1GLYzHVQKJyxbGcAIzdCIDkqGj1NgWPyji5tYs7aIJPFPHf5KrQdJ+Axb9kt
         ekwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745516025; x=1746120825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MqV/L1fucoXh0zEq3ZbEkv0iZBTOf63rS7eOzOMDARE=;
        b=cqStFYN3vhBPIUXMs0vGCsgjdz39TTOC3lGHkYiUQf5KgilqVARLrt+lUsEwiCHpF0
         wl2+iTGMBcvQI9NqqSZaK6fCDGca3oj2mZCpiXXZ0dSD7/JJwlH3IUEpHDt7ndL0C0Ht
         hgG2homDATM7mi6VFAJkS//LKU9pbWivQN4fOUgkb9gvj6XQrnqpDzaaMb2qWt6d/yP3
         ojGgMA4r4QVbdsz8Yei4a9RlKrs213DY4Ha3jNlTz3fBuSFyyG/BIWrFu/zC6AU6MGwQ
         S9/HZV0wbMX55uc59liMnmtHsHYtEFP3xGki5qQZ3gSlb6TZJ4EbgNrMltCBWDfv5kJM
         Ak2A==
X-Forwarded-Encrypted: i=1; AJvYcCW7B+qK+TxsMn7OdexgBdG//zvHVQe/oQ2ZFH7r/ACfPxbde5cWAhzz3pZ5L8JQm8SEFKU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyis2aqPYVKFXZPV7IRPwNesBu4G++qnqZfmvviXeafRO8bDw8s
	SK3EHy81ON9FtyZF3hMGUfMjncEtthglJwS2UL0McoJkgHpkByZKVkgeNOPMDK4=
X-Gm-Gg: ASbGnctGIOH0AqbwQoCWAqRL+bqFpl+7kQu8Q7588Afa5dYrlM8qGm9Z1nt+7siA6O0
	Lyv5oKeJi6/vNkJDv+VECZIFRpVXCBs2/Kib2Ywu1clb9+wbGAxZZt0CpALPg5NFGsFnguNtALt
	kuf0bgKCUxq6OITKSxhvRYNuRd/IVxrw4KxE55iNhaMp7GIkpjg56wSFg0yqMBNobp062cqFUl2
	FlCIcnbX4uT83CCl8XXvSTstA+a/fh3HaBjJRMpkOo+EcKyNrn8Tom+oigVcwPU/8qmcjTQ1KeD
	nV4u2/QkI5UEdzkI5JeQ9v7Sofw9cW8iRRT/LvvIKg==
X-Google-Smtp-Source: AGHT+IGoXel2WMkjiTK/q7g1/yBkqNZ84Lmsw32W4+SLXcM2BGBaWrGqIbaWGI5EV1R0ZMMR1eKW3w==
X-Received: by 2002:a17:903:2445:b0:220:d078:eb33 with SMTP id d9443c01a7336-22db3d71d34mr56439695ad.36.1745516025550;
        Thu, 24 Apr 2025 10:33:45 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5100c4esm16270255ad.173.2025.04.24.10.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 10:33:44 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Deepak Gupta <debug@rivosinc.com>
Subject: [PATCH v6 01/14] riscv: sbi: add Firmware Feature (FWFT) SBI extensions definitions
Date: Thu, 24 Apr 2025 19:31:48 +0200
Message-ID: <20250424173204.1948385-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250424173204.1948385-1-cleger@rivosinc.com>
References: <20250424173204.1948385-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The Firmware Features extension (FWFT) was added as part of the SBI 3.0
specification. Add SBI definitions to use this extension.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Tested-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/sbi.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 3d250824178b..bb077d0c912f 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -35,6 +35,7 @@ enum sbi_ext_id {
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_STA = 0x535441,
 	SBI_EXT_NACL = 0x4E41434C,
+	SBI_EXT_FWFT = 0x46574654,
 
 	/* Experimentals extensions must lie within this range */
 	SBI_EXT_EXPERIMENTAL_START = 0x08000000,
@@ -402,6 +403,33 @@ enum sbi_ext_nacl_feature {
 #define SBI_NACL_SHMEM_SRET_X(__i)		((__riscv_xlen / 8) * (__i))
 #define SBI_NACL_SHMEM_SRET_X_LAST		31
 
+/* SBI function IDs for FW feature extension */
+#define SBI_EXT_FWFT_SET		0x0
+#define SBI_EXT_FWFT_GET		0x1
+
+enum sbi_fwft_feature_t {
+	SBI_FWFT_MISALIGNED_EXC_DELEG		= 0x0,
+	SBI_FWFT_LANDING_PAD			= 0x1,
+	SBI_FWFT_SHADOW_STACK			= 0x2,
+	SBI_FWFT_DOUBLE_TRAP			= 0x3,
+	SBI_FWFT_PTE_AD_HW_UPDATING		= 0x4,
+	SBI_FWFT_POINTER_MASKING_PMLEN		= 0x5,
+	SBI_FWFT_LOCAL_RESERVED_START		= 0x6,
+	SBI_FWFT_LOCAL_RESERVED_END		= 0x3fffffff,
+	SBI_FWFT_LOCAL_PLATFORM_START		= 0x40000000,
+	SBI_FWFT_LOCAL_PLATFORM_END		= 0x7fffffff,
+
+	SBI_FWFT_GLOBAL_RESERVED_START		= 0x80000000,
+	SBI_FWFT_GLOBAL_RESERVED_END		= 0xbfffffff,
+	SBI_FWFT_GLOBAL_PLATFORM_START		= 0xc0000000,
+	SBI_FWFT_GLOBAL_PLATFORM_END		= 0xffffffff,
+};
+
+#define SBI_FWFT_PLATFORM_FEATURE_BIT		BIT(30)
+#define SBI_FWFT_GLOBAL_FEATURE_BIT		BIT(31)
+
+#define SBI_FWFT_SET_FLAG_LOCK			BIT(0)
+
 /* SBI spec version fields */
 #define SBI_SPEC_VERSION_DEFAULT	0x1
 #define SBI_SPEC_VERSION_MAJOR_SHIFT	24
@@ -419,6 +447,11 @@ enum sbi_ext_nacl_feature {
 #define SBI_ERR_ALREADY_STARTED -7
 #define SBI_ERR_ALREADY_STOPPED -8
 #define SBI_ERR_NO_SHMEM	-9
+#define SBI_ERR_INVALID_STATE	-10
+#define SBI_ERR_BAD_RANGE	-11
+#define SBI_ERR_TIMEOUT		-12
+#define SBI_ERR_IO		-13
+#define SBI_ERR_DENIED_LOCKED	-14
 
 extern unsigned long sbi_spec_version;
 struct sbiret {
-- 
2.49.0


