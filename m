Return-Path: <kvm+bounces-41253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E316A6593F
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:57:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3257919A3A39
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77AEE1F892E;
	Mon, 17 Mar 2025 16:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="f3wZy+RL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50951F8ADB
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742230187; cv=none; b=EWolrLeYb/ZfnuDyWfcDM+J6C5rdJywffXL2gBOc44ycvhPTIhwBQy+ZMZQBsb4NCAhCnlF08DN7Mf3ahuPmCw3rc9E2S3Xmv6wBy4h+hLMfDT8N91JkIoqcwErGWTNKlqdYhkkiwJAXyJ9Lr+nOuWdr0xHNr6rZTZXpyAXoK6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742230187; c=relaxed/simple;
	bh=mZunGUZ3vmiSl35Pw3HIZffhQNVV9f2M5DuFP8bkcX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HwoBi+pLvfykIuYUmbte0OqG8d0cPG62aW96Zrw81GKbXylbReV4gpTVzmlxUvheuKpQHblTE/5hdPJGpxv6Gf/Y0CTbtuLZv3FetDp3/KxxgCUTlxPVbhP7Upp4bCeyAPATZG/dDXpgABFGDYe+L77PMHkfV4OtLhZssm9dbwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=f3wZy+RL; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-39149bccb69so4632670f8f.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742230183; x=1742834983; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S6/bbJvgHdC6VrK3B/Gm9Q6mjQ3TSLFZ8q3dtucvWEA=;
        b=f3wZy+RLi/d+9Wfih+/8KbU9i6BmfE+IpPgGv1a2oCS8WEIUdSwwt09jVb80vaOt77
         x36tM5INgz2FRSrK/uaMzbl7dQ8OF3RQPME9Yx1UfhMxv8bGk2BC0hgX0D0AkUtii97L
         Pd0KoAOsgJTD7lOgyPzrJM+ACwccyZpdDbgqiGwOWn4ZJZv0JYC9vdKyJerl3iMgvwuZ
         67bHxSpj5qs2OEPJIH2NhysqAyT92aK7wO78FYCM8eEOK/6qht2OM//RVV8iHRNeC/10
         QLHz85EobnruT9HqtAxlRRbplzUUP4ewxYFBEFFgGeclMwKv5CQflJWmUEvqG7i7d/5A
         hTUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742230183; x=1742834983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S6/bbJvgHdC6VrK3B/Gm9Q6mjQ3TSLFZ8q3dtucvWEA=;
        b=jgZ/qLa3RgiipG/U/tnLZufrZ5ySmOqwJDMhXUe6q/m58vUgmw9PNxIJ8Lt16DD3XK
         xjuvr79VADjL5sqOqLLQf9tjJoy0CJuUP2gXjKrzehZ/rcbm4G7B2Xl9i/fCoa01drjO
         YSKVVXasoTDdJSU0Vxt1fN1UbfasHXDf/4VpLpSV8Wz6SkzbpggecdfRuFtr6ida3HmM
         FBVeBX7eZGAdJHgA7UeC3CUvQ65Djr+vh19bWLg1bBd6Y2ZHlkRH3NMNJIyrfuE8+XRG
         blBpjAi2IBI0rG5R58axqapOP2cNtwHOCdXeVAxxZwUvWFrC62TiHfYuLpYdE/UWQSb3
         Nvpg==
X-Gm-Message-State: AOJu0Ywl/IFp9v3ihVDanp/a3khNnNZCvx39vVzDcLck1smXNi2tnUfr
	7IToZetMcusgvgJUTwrA/mzMXr8zf0cadAvUuX5TQLkvAo0jh8W4IIJPK3xe3+/Sqrn/M4F9UQ3
	g68s=
X-Gm-Gg: ASbGncuzSw1rsTDRDblknCoeFbinATAYcaQqE/Algf0qsZypr5ZgyJweXQoyIso1afr
	dKR6tyi3rtPKBHh3+b6v/vVWM68zsCRSaaqWo65Np3rbnzKKGGKHZdOa/6mchQ0xyWWp2G7IsI4
	djipOHM/JPSP7OUxS7x5xE7nsAgtFnV3LbwLBtxewvvwt4pF+cFIJaxytLqrT3uGbif2kot14XB
	JwWYQbciFayxkJ6SGtZ/96t2HK4bAO0Z/+andxYDzOPcqv92c5wWbGFihTLAYn9GDNZAG802pac
	P6tJ79Cf4H0IZ/Z03bswuoIsqB2T0dhB4HkTh/nzxtM3/Q==
X-Google-Smtp-Source: AGHT+IGlCkYjXJcY2NgqJ0dcTWubjUYgz/P8T6DyLcNDsDAF5fXtTBlLicX7RXrtkWB/h6r8kb4HEQ==
X-Received: by 2002:a5d:6d0f:0:b0:391:30b9:556c with SMTP id ffacd0b85a97d-3996b45ed95mr383147f8f.21.1742230182730;
        Mon, 17 Mar 2025 09:49:42 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb318a80sm15785845f8f.61.2025.03.17.09.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 09:49:42 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v11 4/8] lib: riscv: Add functions for version checking
Date: Mon, 17 Mar 2025 17:46:49 +0100
Message-ID: <20250317164655.1120015-5-cleger@rivosinc.com>
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

Version checking was done using some custom hardcoded values, backport a
few SBI function and defines from Linux to do that cleanly.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 lib/riscv/asm/sbi.h | 15 +++++++++++++++
 lib/riscv/sbi.c     |  9 +++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 2f4d91ef..ee9d6e50 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -18,6 +18,13 @@
 #define SBI_ERR_IO			-13
 #define SBI_ERR_DENIED_LOCKED		-14
 
+/* SBI spec version fields */
+#define SBI_SPEC_VERSION_MAJOR_SHIFT	24
+#define SBI_SPEC_VERSION_MAJOR_MASK	0x7f
+#define SBI_SPEC_VERSION_MINOR_MASK	0xffffff
+#define SBI_SPEC_VERSION_MASK		((SBI_SPEC_VERSION_MAJOR_MASK << SBI_SPEC_VERSION_MAJOR_SHIFT) | \
+					SBI_SPEC_VERSION_MINOR_MASK)
+
 #ifndef __ASSEMBLER__
 #include <cpumask.h>
 
@@ -110,6 +117,13 @@ struct sbiret {
 	long value;
 };
 
+/* Make SBI version */
+static inline unsigned long sbi_mk_version(unsigned long major, unsigned long minor)
+{
+	return ((major & SBI_SPEC_VERSION_MAJOR_MASK) << SBI_SPEC_VERSION_MAJOR_SHIFT)
+		| (minor & SBI_SPEC_VERSION_MINOR_MASK);
+}
+
 struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 			unsigned long arg1, unsigned long arg2,
 			unsigned long arg3, unsigned long arg4,
@@ -124,6 +138,7 @@ struct sbiret sbi_send_ipi_cpu(int cpu);
 struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
 struct sbiret sbi_send_ipi_broadcast(void);
 struct sbiret sbi_set_timer(unsigned long stime_value);
+struct sbiret sbi_get_spec_version(void);
 long sbi_probe(int ext);
 
 #endif /* !__ASSEMBLER__ */
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index 02dd338c..9d4eb541 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -107,12 +107,17 @@ struct sbiret sbi_set_timer(unsigned long stime_value)
 	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
 }
 
+struct sbiret sbi_get_spec_version(void)
+{
+	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
+}
+
 long sbi_probe(int ext)
 {
 	struct sbiret ret;
 
-	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
-	assert(!ret.error && (ret.value & 0x7ffffffful) >= 2);
+	ret = sbi_get_spec_version();
+	assert(!ret.error && (ret.value & SBI_SPEC_VERSION_MASK) >= sbi_mk_version(0, 2));
 
 	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, ext, 0, 0, 0, 0, 0);
 	assert(!ret.error);
-- 
2.47.2


