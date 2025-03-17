Return-Path: <kvm+bounces-41254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AFC8A65926
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:55:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96F5616E52D
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D1B1FF5E3;
	Mon, 17 Mar 2025 16:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="lfzpOzrY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D701F9A9C
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742230187; cv=none; b=UwELwMwJx6vUZWJFW5shKewQmRZOH6mZr97hE5b+HXbtq2ZHR+nIMmsJ5qg58bkammKu/qw9MMzIVMMijNIHPzqO91kx+sXm7qgoaF66xhd+fFyO3ls/e+1wz21G5bbClY9bn13Y8amS+r/QYtXjROJK3DOMFJfkBpyU81Oje3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742230187; c=relaxed/simple;
	bh=UGS0eRsNUNyPg2v9ufSfSrkZOe5n+wVqHbXztz6yf24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NmJapYmyUDDXUi0AolArfU71ERIuBH5de0Rbfnsh7xoqhMRZgTG/IpJi5zFTuxUOWD/O84YpSv6GFKnx4emOTuCrhxD9bLJXz9R9npkELCtKQ4kPoiFM6iiXrR7KgtVfXR8zVY9LF/JkTG/9cifWm0OrhBbcppv2mSBzFe0eUSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=lfzpOzrY; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3912baafc58so4054615f8f.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742230183; x=1742834983; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GfmWlxkCqA/TGxSraCRrSpkfyPy1M1BQ3u35DJOeMtk=;
        b=lfzpOzrYBTwyQrJ+myKTssZwnwFxdTmU+u87QbEOe46JmWJ+WT6JPE2MDWrxCPdGkF
         v7Qx+PvalP5uIGp3il/aAI6qtOawkYI8TSfrqy33HrNuX6lwyQdKFF1uQIFx3sKeppvF
         KDmkSEuwWUpYV1/uToVoU6zncH4DfXxYKvjXJOQrCdqeUBMM/1xV88zfX74nOv5zBsLS
         FME155MqDgHAdATeEsaTKY4ddndl+qqGYKWX7t4Xwgs+MXfK6GmgOHFVV92WpOVAWcmh
         IDw7Z4ZfaLJHQgWhD41RhkkmRotX47xfs4iglBd58WKqTJpxmUv4q68HBBL6BBf/6M7t
         JvKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742230183; x=1742834983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GfmWlxkCqA/TGxSraCRrSpkfyPy1M1BQ3u35DJOeMtk=;
        b=OQUajzfDIHgrk0O2N9hv71ztYMOgmKQD1+dRgFcB2DJ04mZeFGyCQ4bz010hmVOVV8
         kwyszjg5lzYaVW08aqrVnXaCb9QwL9HCPb313f/d6nzoq1tHpwFnXjJQYBfUf7KP633C
         I34f4Uf+1dx/KVjeqR1ivXpAQSJM4XpednWCmhaNaeT3lzwSOswK7k30zXC/pyJF+/P3
         qrmnNsAzE238E2qa+RWhbI7yBFctTUzxv0afV2JQTcCE8kI/dls7LlCAiXfk8xUNrZGC
         /R1Mrx9RTRn9iUzCFzmUupxYa+DrP5mYxtO0V0DlIde1OeAFgpBk1Nn41EF0vwKbJ7HF
         EvTg==
X-Gm-Message-State: AOJu0Yy5UNgZVO+AtTyAnUg+Q21EzuxZRho86iSmJCYxmgzDZN8UruFJ
	Wwj7oiMnOWESkm+UC/xV5zxAt/NdAdtbBW57arouP3vnFLhpB7Acvz/dAcAhCkJkBjh3eKFTOWO
	1dVk=
X-Gm-Gg: ASbGnctBAGsGjg5qWeCEHoW4mCP4eucLldGNn8GxkF+x0h0sTS6Y/iIeWgmkSoCM4oG
	HwfOdDjbtN0gw7ZDisWunZdg625LzDOrac3gt/1Ofz5lveN0fw8VRhb22J0M4E1Ioxh/HJD+tqm
	7MhLWSslwhM4RJPBOdZ4GDJdWTZznfAu2KFdNHKGZ5XSQNKUxE+voa7qiTp2sk9QHNKQznnI5PG
	myG3Nj0DAQ4gvyOc1ba6a0+gm95TZKBTODrPWN1wSUCS8eWw3RtazWNAwL8QK3CN7S/QN14hmOd
	nSUerI3Tro/qOkAZlnlKu+tdFbD88RQUtTUD+A0h6IgDoA==
X-Google-Smtp-Source: AGHT+IF5e60EIooJ6SAI+LPIypiIi6vs4+A+3ui5JNTqeRWZqwGkmhdB30foCmneaGDf8Boyvvzr7Q==
X-Received: by 2002:a5d:47ac:0:b0:391:13d6:c9f0 with SMTP id ffacd0b85a97d-3971f9e7813mr13298142f8f.47.1742230183615;
        Mon, 17 Mar 2025 09:49:43 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb318a80sm15785845f8f.61.2025.03.17.09.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 09:49:43 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v11 5/8] lib: riscv: Add functions to get implementer ID and version
Date: Mon, 17 Mar 2025 17:46:50 +0100
Message-ID: <20250317164655.1120015-6-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317164655.1120015-1-cleger@rivosinc.com>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These functions will be used by SSE tests to check for a specific OpenSBI
version.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 lib/riscv/asm/sbi.h | 20 ++++++++++++++++++++
 lib/riscv/sbi.c     | 20 ++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index ee9d6e50..90111628 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -18,6 +18,19 @@
 #define SBI_ERR_IO			-13
 #define SBI_ERR_DENIED_LOCKED		-14
 
+#define SBI_IMPL_BBL		0
+#define SBI_IMPL_OPENSBI	1
+#define SBI_IMPL_XVISOR		2
+#define SBI_IMPL_KVM		3
+#define SBI_IMPL_RUSTSBI	4
+#define SBI_IMPL_DIOSIX		5
+#define SBI_IMPL_COFFER		6
+#define SBI_IMPL_XEN		7
+#define SBI_IMPL_POLARFIRE_HSS	8
+#define SBI_IMPL_COREBOOT	9
+#define SBI_IMPL_OREBOOT	10
+#define SBI_IMPL_BHYVE		11
+
 /* SBI spec version fields */
 #define SBI_SPEC_VERSION_MAJOR_SHIFT	24
 #define SBI_SPEC_VERSION_MAJOR_MASK	0x7f
@@ -124,6 +137,11 @@ static inline unsigned long sbi_mk_version(unsigned long major, unsigned long mi
 		| (minor & SBI_SPEC_VERSION_MINOR_MASK);
 }
 
+static inline unsigned long sbi_impl_opensbi_mk_version(unsigned long major, unsigned long minor)
+{
+	return (((major & 0xffff) << 16) | (minor & 0xffff));
+}
+
 struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 			unsigned long arg1, unsigned long arg2,
 			unsigned long arg3, unsigned long arg4,
@@ -139,6 +157,8 @@ struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
 struct sbiret sbi_send_ipi_broadcast(void);
 struct sbiret sbi_set_timer(unsigned long stime_value);
 struct sbiret sbi_get_spec_version(void);
+unsigned long sbi_get_imp_version(void);
+unsigned long sbi_get_imp_id(void);
 long sbi_probe(int ext);
 
 #endif /* !__ASSEMBLER__ */
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index 9d4eb541..ab032e3e 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -107,6 +107,26 @@ struct sbiret sbi_set_timer(unsigned long stime_value)
 	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
 }
 
+unsigned long sbi_get_imp_version(void)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_VERSION, 0, 0, 0, 0, 0, 0);
+	assert(!ret.error);
+
+	return ret.value;
+}
+
+unsigned long sbi_get_imp_id(void)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_ID, 0, 0, 0, 0, 0, 0);
+	assert(!ret.error);
+
+	return ret.value;
+}
+
 struct sbiret sbi_get_spec_version(void)
 {
 	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
-- 
2.47.2


