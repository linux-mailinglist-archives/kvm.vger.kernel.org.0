Return-Path: <kvm+bounces-41198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10AD6A649C7
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:28:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E93AD3A76E8
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E924238140;
	Mon, 17 Mar 2025 10:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="xOp35fv1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4259223770A
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742206819; cv=none; b=qYgYCJojKb06Q0iYFO2eoytpUfmFO8SnzOpFdpo6Q6zyXezhU+zWTRHQG1v43jAa5FkX30KhXa/b+NJLeKI+Vk4zaU3/akwKaNAbtko/H1f9abOe/LfeQj11m9p8o55Lpy1KHmJSFl8PaQYIdirMB37DLdVs36pPBOEsW4A6Zjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742206819; c=relaxed/simple;
	bh=F8bXU1DnfIIYEKMoGL8u3GiGtFnUr3clBUu51PLVGmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZNldKoDUCmZjDMTVrWcyFh4DTyJmjlTLyVANBemAm2t7Er+Ngb+uaszDqXefe2d/V1YrJenvHfoSjJQBh3lONJEGSWJVUJc9xJZVrudrZEblIog37qAEW0pbIdGHpFRMeyUs7eXNCS/Nf3hDNVkUarm5fK/zXEzpgl32WZG6joI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=xOp35fv1; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43bb6b0b898so19289655e9.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 03:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742206815; x=1742811615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g5zfkwLSGrpxE33J8pMgS8nCoHTvNFE9xqtzOWIjS2s=;
        b=xOp35fv18IdQcvV2YQCYKDpFCaQS7Y4+BKwDDKzVkOwTfcmkPoB+h+DYw3oCEW4BLf
         nE0L/YGscBcr+0c4T+aoxlDG+3tv0iaMO7jUDc76OJ2W2PsBD8mjYkGQKUHvMcGCYJ4U
         wViSZlar/M7aYHk1z8Yk3JEiQ/wgfjVFR70hu3WrpQRcVxzCK8qxh+e/3TYP53knJfi9
         4MHO4Eivv1limMFKQV+Nk0XBE1DuBOVW6aespscXlLCAq+yO7POrlxGGRGsSO9H7/Hhf
         +8JoF+bc4VGp7+Ft5HMhjTojFsfAxWyAVZ8BnQ+NlZKrFU4Hz+E0SU6Mr716QQa1anF0
         9Lgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742206815; x=1742811615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g5zfkwLSGrpxE33J8pMgS8nCoHTvNFE9xqtzOWIjS2s=;
        b=Cs7xKvUXBRBxGDiwEKbh+lFtEk3Vaanpjzfbaz958n0mRhNxjkdqduWwbiBqYRQQ4H
         uq/g0w5+MAuh16VPAZo8Jpm0vpIKI+CGa8k/8y+BlecFQ+vFKz6F3CeN7VjCtpqBDoEW
         mqoLVNbAbi47GtbQvmFN34iVIWqsUc6J/AQEfEHNnBb1NHWWBh+DqPbcXNcR1NXEXXfW
         scY8hDqXbr/gby1NW1hhDmpv/+C5+Q30CN30djPMb3yv2maeTRLBewS36he6lhbvnVer
         SOkXd5RzN/HPSSb14BzFlB8XdeC/bgvvXxOE6hTfTbwlnQHUgorMJTggCZu42uHtTSBo
         qZZg==
X-Gm-Message-State: AOJu0YzYlQQHNkaVe1FVSrk+8pbAWeBWNVDv8c+JN7Rnjnla9LwblMQm
	uRfNIE6ESjfEPK6KNcn5TU9fJ555BvbIP9PYd447+wlMLdn89/tAfczaWyK+nZJCv2Lx3CUPWiZ
	5Irk=
X-Gm-Gg: ASbGncvD8j12GnGa9dAWtFnIdl5qcFBdtzflaSzpXw2gc00CwT1dYyy92ZEWaRb60jy
	eYQBZccKYQewAl1XZUZllhb/va42YYmkGSXSLYACXdHz1ElpbWjg2EsjhBpFaSjain8uO6A32vJ
	jU1VvaURRHhnz5Z7V+1Nu+Yy1HHDNpr/Ei9ffQ7GpzvrAKNBk2BdoX28AN6EN4aS4h4GoR0zOOI
	h5uKC5JhzDNS6QRwxp1y5Rk2LVEdjsQMCiSn5jTAzrG0Y2rbvIO9QrS8pB//3Zm/dhxfUmj2cEf
	LnFuK0qajNz5JfR/t4tfv2IxN++/N1h6Xwx5zbUy9N+Eiw==
X-Google-Smtp-Source: AGHT+IE/3pudvRe901IgYSjA4Zgfu+J1gBRSKMp7RbIRqeeOMIpJ1NO5YRxvbzX5T/vTZ1d+tuPAcA==
X-Received: by 2002:a5d:59ab:0:b0:385:fd07:8616 with SMTP id ffacd0b85a97d-3971a3975dcmr13059628f8f.0.1742206815279;
        Mon, 17 Mar 2025 03:20:15 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7ebe3csm14749824f8f.99.2025.03.17.03.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 03:20:14 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v10 6/8] riscv: lib: Add SBI SSE extension definitions
Date: Mon, 17 Mar 2025 11:19:52 +0100
Message-ID: <20250317101956.526834-7-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317101956.526834-1-cleger@rivosinc.com>
References: <20250317101956.526834-1-cleger@rivosinc.com>
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
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/sbi.h | 106 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 105 insertions(+), 1 deletion(-)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 06bcec16..b8688e47 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -49,6 +49,7 @@ enum sbi_ext_id {
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_SUSP = 0x53555350,
 	SBI_EXT_FWFT = 0x46574654,
+	SBI_EXT_SSE = 0x535345,
 };
 
 enum sbi_ext_base_fid {
@@ -97,7 +98,6 @@ enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
 };
 
-
 enum sbi_ext_fwft_fid {
 	SBI_EXT_FWFT_SET = 0,
 	SBI_EXT_FWFT_GET,
@@ -124,6 +124,110 @@ enum sbi_ext_fwft_fid {
 
 #define SBI_FWFT_SET_FLAG_LOCK			BIT(0)
 
+enum sbi_ext_sse_fid {
+	SBI_EXT_SSE_READ_ATTRS = 0,
+	SBI_EXT_SSE_WRITE_ATTRS,
+	SBI_EXT_SSE_REGISTER,
+	SBI_EXT_SSE_UNREGISTER,
+	SBI_EXT_SSE_ENABLE,
+	SBI_EXT_SSE_DISABLE,
+	SBI_EXT_SSE_COMPLETE,
+	SBI_EXT_SSE_INJECT,
+	SBI_EXT_SSE_HART_UNMASK,
+	SBI_EXT_SSE_HART_MASK,
+};
+
+/* SBI SSE Event Attributes. */
+enum sbi_sse_attr_id {
+	SBI_SSE_ATTR_STATUS		= 0x00000000,
+	SBI_SSE_ATTR_PRIORITY		= 0x00000001,
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
+#define SBI_SSE_ATTR_CONFIG_ONESHOT		BIT(0)
+
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPP	BIT(0)
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPIE	BIT(1)
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPV	BIT(2)
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPVP	BIT(3)
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPELP	BIT(4)
+#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT	BIT(5)
+
+enum sbi_sse_state {
+	SBI_SSE_STATE_UNUSED		= 0,
+	SBI_SSE_STATE_REGISTERED	= 1,
+	SBI_SSE_STATE_ENABLED		= 2,
+	SBI_SSE_STATE_RUNNING		= 3,
+};
+
+/* SBI SSE Event IDs. */
+/* Range 0x00000000 - 0x0000ffff */
+#define SBI_SSE_EVENT_LOCAL_HIGH_PRIO_RAS	0x00000000
+#define SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP		0x00000001
+#define SBI_SSE_EVENT_LOCAL_RESERVED_0_START	0x00000002
+#define SBI_SSE_EVENT_LOCAL_RESERVED_0_END	0x00003fff
+#define SBI_SSE_EVENT_LOCAL_PLAT_0_START	0x00004000
+#define SBI_SSE_EVENT_LOCAL_PLAT_0_END		0x00007fff
+
+#define SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS	0x00008000
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_0_START	0x00008001
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_0_END	0x0000bfff
+#define SBI_SSE_EVENT_GLOBAL_PLAT_0_START	0x0000c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_0_END		0x0000ffff
+
+/* Range 0x00010000 - 0x0001ffff */
+#define SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW	0x00010000
+#define SBI_SSE_EVENT_LOCAL_RESERVED_1_START	0x00010001
+#define SBI_SSE_EVENT_LOCAL_RESERVED_1_END	0x00013fff
+#define SBI_SSE_EVENT_LOCAL_PLAT_1_START	0x00014000
+#define SBI_SSE_EVENT_LOCAL_PLAT_1_END		0x00017fff
+
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_1_START	0x00018000
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_1_END	0x0001bfff
+#define SBI_SSE_EVENT_GLOBAL_PLAT_1_START	0x0001c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_1_END		0x0001ffff
+
+/* Range 0x00100000 - 0x0010ffff */
+#define SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS	0x00100000
+#define SBI_SSE_EVENT_LOCAL_RESERVED_2_START	0x00100001
+#define SBI_SSE_EVENT_LOCAL_RESERVED_2_END	0x00103fff
+#define SBI_SSE_EVENT_LOCAL_PLAT_2_START	0x00104000
+#define SBI_SSE_EVENT_LOCAL_PLAT_2_END		0x00107fff
+
+#define SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS	0x00108000
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_2_START	0x00108001
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_2_END	0x0010bfff
+#define SBI_SSE_EVENT_GLOBAL_PLAT_2_START	0x0010c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_2_END		0x0010ffff
+
+/* Range 0xffff0000 - 0xffffffff */
+#define SBI_SSE_EVENT_LOCAL_SOFTWARE		0xffff0000
+#define SBI_SSE_EVENT_LOCAL_RESERVED_3_START	0xffff0001
+#define SBI_SSE_EVENT_LOCAL_RESERVED_3_END	0xffff3fff
+#define SBI_SSE_EVENT_LOCAL_PLAT_3_START	0xffff4000
+#define SBI_SSE_EVENT_LOCAL_PLAT_3_END		0xffff7fff
+
+#define SBI_SSE_EVENT_GLOBAL_SOFTWARE		0xffff8000
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_3_START	0xffff8001
+#define SBI_SSE_EVENT_GLOBAL_RESERVED_3_END	0xffffbfff
+#define SBI_SSE_EVENT_GLOBAL_PLAT_3_START	0xffffc000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_3_END		0xffffffff
+
+#define SBI_SSE_EVENT_PLATFORM_BIT		BIT(14)
+#define SBI_SSE_EVENT_GLOBAL_BIT		BIT(15)
+
 struct sbiret {
 	long error;
 	long value;
-- 
2.47.2


