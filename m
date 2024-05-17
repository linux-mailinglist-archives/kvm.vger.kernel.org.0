Return-Path: <kvm+bounces-17603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 264EE8C875B
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 15:40:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94D961F22F56
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 13:40:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0015655E49;
	Fri, 17 May 2024 13:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="REYaHfgO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246143BBE6
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 13:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715953217; cv=none; b=qHw9jcWqh53wMCC6bfLNLm+qBjUX2GBUA2BiTBJgmIxDteCP8J/a6j1FY9c2mGnwBB85yUJzmXIAI4UPfm/BDyPpnSDq7VKrblQhOkx9O8w8TxDNGiPeyGmvNjnygyBYZgevWfmDiLx4FoyaA6dI4xhPXh+xU97KKXwryxanFzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715953217; c=relaxed/simple;
	bh=G/lziIDTjMF7ephjP7Ta81ESZ3q9Kdn+yqUcvUJiRa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZfN0bVrGzHKWHjFPiFDnb2n49EqAeW3oemKRlpOSVpD9GcO0AfhSfHIFV29A7RxxSWVL48Cj0sGcpIRVFoljJJ50CNGS1Qk9XPc31Aj41Lnv+Uuy9KiQdrPFef8VlPWCZDst7IrF8KJcLOSmNjCmVl+lsfoKKBbZaA/Tgq4tp5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=REYaHfgO; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2e1e7d9d87bso100321fa.3
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 06:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1715953213; x=1716558013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1HFLuNx37V7QBaBUb75eO70bRW+tMn62Y1Htb9ZgKbc=;
        b=REYaHfgOdggamJukw87Hm0B1TzztV68p5Wln8cJA5QhII83utAxSyw/5f5i4eurX4n
         F9Bijn05Z/KurhzzeSn8lVZIO4j1aYHCrDc6tZGKU0TMMCNYc9ULmxIAdxlt1vnkH1Yt
         ZNo70n5Oi7WKs6zjFoX6v01NoKanex5kIWT0fn804Y0ap1uyMpRHlIpBztBTZjwMLg9n
         Zy+emQbyWPyJUCH7Wqe0J7/OoK0+Vkk2STx0LS00n8C1N1eEz8JKqQMI98KMRBfcFZcz
         +crLaNwqIOAEYj+1044iqTSAVidrutDv4PxBZCMN5VqE1yQoeITYTjcajcBMPr1R5C/W
         Xbrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715953213; x=1716558013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1HFLuNx37V7QBaBUb75eO70bRW+tMn62Y1Htb9ZgKbc=;
        b=KNQppIE1hFs/iVz5SqnobYmXwD6P80fsBBSEyYwbXr0KtPch9bUI0MJEiUuefW00kb
         2/lG9eoH84fZcb/Ry4OCNuu/Z80a/R3/+Wnox1s0S31JUR/bFkUFdNLsfEm+BsI9zLGG
         RaY/ZOxzZND4HNOS4TMOAGUyBMOYObZS7CCaqDGkYa6eiq9z+VryNzRiaBY525BajJvO
         214q6IP1li8vR3iP9/Wc9z0prnzHRoXdpeXOMClt0Gv3w5tdDAkxvJf1yc3q/1MtpUZx
         EIx/QYFoixob7GyEYtwzxXYErFkZKK1gkt5iCT3YEay+Ug88KEdNNboJtqhM/sGTZ5KU
         zhSQ==
X-Gm-Message-State: AOJu0YzLJYEBPOAM2xfBXAQPoGTtnsffvvAeY83+lISKejr9mNzTJdec
	jA9G/TEPqURDGClA60GYi5ARm3MouWhsRIU3ZLVRXgpwIBMjRGIyPNe+xxKXMjRfuYN3EEt07Uc
	1Xek=
X-Google-Smtp-Source: AGHT+IHO/7qAot5DZKPHbiJRymeoucahtN5Hacl/TMAXLhaiKTtGPymEDoD8nrUwXKJvMpVxUSWJxA==
X-Received: by 2002:a2e:b041:0:b0:2e6:f1bf:9897 with SMTP id 38308e7fff4ca-2e6f1bf991emr54486281fa.4.1715953212885;
        Fri, 17 May 2024 06:40:12 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:46f0:3724:aa77:c1f8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4200e518984sm240669275e9.23.2024.05.17.06.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 May 2024 06:40:12 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v1 2/4] riscv: add SBI SSE extension definitions
Date: Fri, 17 May 2024 15:40:03 +0200
Message-ID: <20240517134007.928539-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240517134007.928539-1-cleger@rivosinc.com>
References: <20240517134007.928539-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add SBI SSE extension definitions in sbi.h

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 lib/riscv/asm/sbi.h | 76 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index d82a384d..c7443ae4 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -11,6 +11,9 @@
 #define SBI_ERR_ALREADY_AVAILABLE	-6
 #define SBI_ERR_ALREADY_STARTED		-7
 #define SBI_ERR_ALREADY_STOPPED		-8
+#define SBI_ERR_NO_SHMEM		-9
+#define SBI_ERR_INVALID_STATE		-10
+#define SBI_ERR_BAD_RANGE		-11
 
 #ifndef __ASSEMBLY__
 
@@ -18,6 +21,7 @@ enum sbi_ext_id {
 	SBI_EXT_BASE = 0x10,
 	SBI_EXT_HSM = 0x48534d,
 	SBI_EXT_SRST = 0x53525354,
+	SBI_EXT_SSE = 0x535345,
 };
 
 enum sbi_ext_base_fid {
@@ -37,6 +41,78 @@ enum sbi_ext_hsm_fid {
 	SBI_EXT_HSM_HART_SUSPEND,
 };
 
+/* SBI Function IDs for SSE extension */
+#define SBI_EXT_SSE_READ_ATTR		0x00000000
+#define SBI_EXT_SSE_WRITE_ATTR		0x00000001
+#define SBI_EXT_SSE_REGISTER		0x00000002
+#define SBI_EXT_SSE_UNREGISTER		0x00000003
+#define SBI_EXT_SSE_ENABLE		0x00000004
+#define SBI_EXT_SSE_DISABLE		0x00000005
+#define SBI_EXT_SSE_COMPLETE		0x00000006
+#define SBI_EXT_SSE_INJECT		0x00000007
+
+/* SBI SSE Event Attributes. */
+enum sbi_sse_attr_id {
+	SBI_SSE_ATTR_STATUS		= 0x00000000,
+	SBI_SSE_ATTR_PRIO		= 0x00000001,
+	SBI_SSE_ATTR_CONFIG		= 0x00000002,
+	SBI_SSE_ATTR_PREFERRED_HART	= 0x00000003,
+	SBI_SSE_ATTR_ENTRY_PC		= 0x00000004,
+	SBI_SSE_ATTR_ENTRY_ARG		= 0x00000005,
+	SBI_SSE_ATTR_INTERRUPTED_SEPC	= 0x00000006,
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS	= 0x00000007,
+	SBI_SSE_ATTR_INTERRUPTED_A6	= 0x00000008,
+	SBI_SSE_ATTR_INTERRUPTED_A7	= 0x00000009,
+};
+
+#define SBI_SSE_ATTR_STATUS_STATE_OFFSET	0
+#define SBI_SSE_ATTR_STATUS_STATE_MASK		0x3
+#define SBI_SSE_ATTR_STATUS_PENDING_OFFSET	2
+#define SBI_SSE_ATTR_STATUS_INJECT_OFFSET	3
+
+#define SBI_SSE_ATTR_CONFIG_ONESHOT	(1 << 0)
+
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_STATUS_SPP	BIT(0)
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_STATUS_SPIE	BIT(1)
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPV	BIT(2)
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPVP	BIT(3)
+
+enum sbi_sse_state {
+	SBI_SSE_STATE_UNUSED     = 0,
+	SBI_SSE_STATE_REGISTERED = 1,
+	SBI_SSE_STATE_ENABLED    = 2,
+	SBI_SSE_STATE_RUNNING    = 3,
+};
+
+/* SBI SSE Event IDs. */
+#define SBI_SSE_EVENT_LOCAL_RAS			0x00000000
+#define	SBI_SSE_EVENT_LOCAL_PLAT_0_START	0x00004000
+#define SBI_SSE_EVENT_LOCAL_PLAT_0_END		0x00007fff
+#define SBI_SSE_EVENT_GLOBAL_RAS		0x00008000
+#define	SBI_SSE_EVENT_GLOBAL_PLAT_0_START	0x00004000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_0_END		0x00007fff
+
+#define SBI_SSE_EVENT_LOCAL_PMU			0x00010000
+#define	SBI_SSE_EVENT_LOCAL_PLAT_1_START	0x00014000
+#define SBI_SSE_EVENT_LOCAL_PLAT_1_END		0x00017fff
+#define	SBI_SSE_EVENT_GLOBAL_PLAT_1_START	0x0001c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_1_END		0x0001ffff
+
+#define	SBI_SSE_EVENT_LOCAL_PLAT_2_START	0x00024000
+#define SBI_SSE_EVENT_LOCAL_PLAT_2_END		0x00027fff
+#define	SBI_SSE_EVENT_GLOBAL_PLAT_2_START	0x0002c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_2_END		0x0002ffff
+
+#define SBI_SSE_EVENT_LOCAL_SOFTWARE		0xffff0000
+#define	SBI_SSE_EVENT_LOCAL_PLAT_3_START	0xffff4000
+#define SBI_SSE_EVENT_LOCAL_PLAT_3_END		0xffff7fff
+#define SBI_SSE_EVENT_GLOBAL_SOFTWARE		0xffff8000
+#define	SBI_SSE_EVENT_GLOBAL_PLAT_3_START	0xffffc000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_3_END		0xffffffff
+
+#define SBI_SSE_EVENT_GLOBAL_BIT		(1 << 15)
+#define SBI_SSE_EVENT_PLATFORM_BIT		(1 << 14)
+
 struct sbiret {
 	long error;
 	long value;
-- 
2.43.0


