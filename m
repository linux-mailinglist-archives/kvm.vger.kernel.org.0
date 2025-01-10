Return-Path: <kvm+bounces-35034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9482CA08EEE
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 12:13:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DDF5166235
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC7120C01C;
	Fri, 10 Jan 2025 11:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Pe7+FyNB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A6420ADCE
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 11:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736507587; cv=none; b=rHe00+MkmZVmnL4uJMwu9+1NQyEuXz0RexdCrfr/bTXQdbUENOpf4824xrCh8FBdr9A7y4uiA5OncK2rV5pEC8URJqAz/z59ZZaq916AsaQH9vHrT79c8zn5ufPYlihaqH1tiRZl5tbLAu0ETT8i7Y4HOEWlh7e7Oqb/PTZ4JIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736507587; c=relaxed/simple;
	bh=v1XsW1WnggH149v6+WTn2vwZdiiPZjkex0NQNrd2nqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=geTePJ5lso5rYLc4Rq2D7DNiCfu1enkjX/7h1NclpFKTs6QhbIvIy8tuPKpb+IlC11jal48JlbRexueFNofc6QTR3VO2fvRu0uh661FTHsyZsfLO+wOxst/qAksJMeQzLHpDQywg2B6pDrEuxAN9prWOXmotIDybqPFCrWntnNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Pe7+FyNB; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-38633b5dbcfso1911113f8f.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 03:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736507583; x=1737112383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cYths4OMC2TtlQTz0sJIMvagsGZNGflHSOzs+WkBihc=;
        b=Pe7+FyNB8MDRtlEXR/cjZWoTLQ46vsd7u9t01wNkE9WfbuFhkmmal8yZBvo/c1XXLL
         wMy3pvP7eL6bdwheusVsAJ8ZpZDW6GCcgXxcrQrmC3iE0LqdslledDtmMMYO3xeNZLXn
         jQjccg0RGCOYqKVqqf3ank5MuEC9nWBrFDPy/rrzxBeuSw/IlXJ3VmlvnQgM5pjhyVcs
         s3PSrdrZGgtLBAsjDwK6eBeNudiBCNaB20ArccdTz7xOrE3q806AeQhycaItcGer7+PO
         2nfmyUEW1xwgpdj2xUMbSJaov93isd5YP0gW4zVszEU5iRb34MNAaP3Q1N4a5ig4iWQ9
         aoYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736507583; x=1737112383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cYths4OMC2TtlQTz0sJIMvagsGZNGflHSOzs+WkBihc=;
        b=gGtnQfkMNH4j2XME7PzNRbcqibWfFu8OF4iTIAYkNU3BwvuFOBs6utMPyqNlXwsfgZ
         97RmzJAa61d81RW8VhplxLyopPOWyA+72VbwP005GjMQy3jeXzHuEPwvvX3/0+JyKFfO
         tonATwpJSmlzwlR65ZEe27kYEy6tN5s+ntiOMqSXOn3qyjLbUbYYK+xuLpDx/DOSh8n/
         h5dH/49O5UruHtu2bLZSHAEi0j3rDvLgwR9dv/B0P3oj/SQflg5RK/4vmZOgUZiV09eM
         IoGIhLsQ5WSAyUB7rd2PymlK3dFeNA0ZGhBTMpokjdRAFcPtjm0/qEVAl8mniBiPO+bP
         q0ug==
X-Gm-Message-State: AOJu0YwK6/++jpZhJMa0Zi3JJquGpznFFZ7GT88mHJASo5yqlY9lAPBO
	ESOmUVXBAzu/rzfJQYrxSTkeYdBUGzMX94+Pk1rQ11TLn00Y8HO1OAhKswZmuf7C3plegYRMwbR
	U
X-Gm-Gg: ASbGncu1SY7AujprzzE+LMVbkz4KkR/l6g8R+nPFAVZ6vV7gR1Yunaw9oiAJiwrIhhP
	nfS1INnvne2ikRfe0ldOmoTEDcaIqWp3CXdfFIfDVonqvuJNwAuqNGCrpocMHmvICu+Wxyt2lRa
	+pRXbY26zJIdGs6+HBOny5MA0YEMi4Ytm4led5jOZZKJkI4JO6Hgwn4unAKjZNCpBlN77N+vXkb
	37BKeBJHEQX+ZEAPaBhBSnhe34UBkPeJ/Eob6yQJR3OlbnCxjCBRV2Gxw==
X-Google-Smtp-Source: AGHT+IE8PSg4B0FfT66+L9M+Avs2G9SYpaFgBpFiRBxY5P4MSLDac75HUhlsHFeQx/UFuRIsOIvmmQ==
X-Received: by 2002:a05:6000:18a3:b0:38a:1ba4:d066 with SMTP id ffacd0b85a97d-38a8730de90mr9767873f8f.27.1736507583569;
        Fri, 10 Jan 2025 03:13:03 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38c1d6sm4344459f8f.50.2025.01.10.03.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 03:13:03 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v6 4/5] riscv: lib: Add SBI SSE extension definitions
Date: Fri, 10 Jan 2025 12:12:43 +0100
Message-ID: <20250110111247.2963146-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250110111247.2963146-1-cleger@rivosinc.com>
References: <20250110111247.2963146-1-cleger@rivosinc.com>
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
 lib/riscv/asm/sbi.h | 89 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 98a9b097..83bdfb82 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -11,6 +11,11 @@
 #define SBI_ERR_ALREADY_AVAILABLE	-6
 #define SBI_ERR_ALREADY_STARTED		-7
 #define SBI_ERR_ALREADY_STOPPED		-8
+#define SBI_ERR_NO_SHMEM		-9
+#define SBI_ERR_INVALID_STATE		-10
+#define SBI_ERR_BAD_RANGE		-11
+#define SBI_ERR_TIMEOUT			-12
+#define SBI_ERR_IO			-13
 
 #ifndef __ASSEMBLY__
 #include <cpumask.h>
@@ -23,6 +28,7 @@ enum sbi_ext_id {
 	SBI_EXT_SRST = 0x53525354,
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_SUSP = 0x53555350,
+	SBI_EXT_SSE = 0x535345,
 };
 
 enum sbi_ext_base_fid {
@@ -71,6 +77,89 @@ enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
 };
 
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
+#define SBI_SSE_EVENT_LOCAL_PLAT_0_START	0x00004000
+#define SBI_SSE_EVENT_LOCAL_PLAT_0_END		0x00007fff
+
+#define SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS	0x00008000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_0_START	0x0000c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_0_END		0x0000ffff
+
+/* Range 0x00010000 - 0x0001ffff */
+#define SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW	0x00010000
+#define SBI_SSE_EVENT_LOCAL_PLAT_1_START	0x00014000
+#define SBI_SSE_EVENT_LOCAL_PLAT_1_END		0x00017fff
+#define SBI_SSE_EVENT_GLOBAL_PLAT_1_START	0x0001c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_1_END		0x0001ffff
+
+/* Range 0x00100000 - 0x0010ffff */
+#define SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS	0x00100000
+#define SBI_SSE_EVENT_LOCAL_PLAT_2_START	0x00104000
+#define SBI_SSE_EVENT_LOCAL_PLAT_2_END		0x00107fff
+#define SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS	0x00108000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_2_START	0x0010c000
+#define SBI_SSE_EVENT_GLOBAL_PLAT_2_END		0x0010ffff
+
+/* Range 0xffff0000 - 0xffffffff */
+#define SBI_SSE_EVENT_LOCAL_SOFTWARE		0xffff0000
+#define SBI_SSE_EVENT_LOCAL_PLAT_3_START	0xffff4000
+#define SBI_SSE_EVENT_LOCAL_PLAT_3_END		0xffff7fff
+#define SBI_SSE_EVENT_GLOBAL_SOFTWARE		0xffff8000
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
2.47.1


