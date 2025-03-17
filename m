Return-Path: <kvm+bounces-41266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D64FDA659C4
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:10:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D0E116851C
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 779A61C8635;
	Mon, 17 Mar 2025 17:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="fEi1VGZ3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5601ACED5
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 17:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742231294; cv=none; b=Ci80m30kxlKK0Wsdkb5sUdjvUQlKRmiyQL0jPXTYnN6aGs3XGf84wEbNaO6MlXUcbwinIDIxk8eh9bcM8xIz6bIobDN0P2l2ccP0E7c6ke7agpKEbswJ/imjRJmJrryziNmuTTQZfw3XQtrsIHfonXuNU2LT2+upL3cuYrg9rlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742231294; c=relaxed/simple;
	bh=dwkX4ghtuFTs9nXX7YkIDxi1Nt/XeE3g8BNL/2zgIi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tJyYDOvyUtKh7hon+aKl003OpFwRpiL9Odx773/p7tUBIU0r2tFXvin6/FdBQv8mmMbscN3rcTbaXtuxUm8hn7GJxoySNXGClL0ascj865/Ebmpn58zC+Hopg9i8RotW38j3n+zrZyHInWEJwxzynq+mhY59i4ZOhlGWQnLs2xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=fEi1VGZ3; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cfba466b2so24606155e9.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742231290; x=1742836090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WzyfmLdoy3J2d7N3ElT+BcY4glWrhhZZ3MI8rtjNdBk=;
        b=fEi1VGZ3P0tiEv4sJLBlTbDthxK+GiJPfJ16u1P1Xo7dzAV+vvmpKuQUZe+oKPFwRF
         E5YdiuHL26ArbQMkF0pDHTN4XCq3TR6bA9R8L8viIUoZUgp/kuBMOaqTyQ7PUjcM5t7D
         zkCyUkCBcdd2Vg0svT5IscrK23XEgW5fkRGvMpJNdJmSeDCEmS/e2AkIWcRDZv0kVl4p
         St/BL6BFMGxzlkdiU/9xlVSTWH4p23a0tRbHR41dX59df3uFFzffDIqwd0kvvDnXTHjg
         FzRByGhdWdwZTg1tOTH3yK4JgT8G/X3cv5y3xBjaNAk1OX6yar/p9/RnXKBl7JJXOnzL
         ELvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742231290; x=1742836090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WzyfmLdoy3J2d7N3ElT+BcY4glWrhhZZ3MI8rtjNdBk=;
        b=Y0IcwT/yrfMvTzCa0jjR+mGrUY3I/Qcjex+jkH4pYZIPdmbrdirPNOpST3BOHDGcgH
         ys+AfJMjNnE23nL9CZDIe6Cd+duR9XEjgIosY3F4Z+hoeouP34Xygp9Vaq6IFcXieTFx
         hlDie7H7Zo0AS+PZ0gLP4DxlXhJ5ovMtEKIa9RhQXTjuDTbBO9Qo1d4JIXHRNvxXYLXz
         rD262JrW0Q5lpB9Z0wJo6dCKP/1GPDjwgPlq21CNE2kNkqbi6Z0Y+USIzOzOkO6ZWi2n
         WuVcRmAE9cfomzQQNawaC3kn+eHWBDpREBX8j3lLyWyPrgJ+4PphXK9zqovAbFEXFS5C
         nXOg==
X-Forwarded-Encrypted: i=1; AJvYcCVPsGxoE6RnZIubj83mjOewZPI24BNEOIx4VXJLHQ0DzWmxqqfzm/+lahtUyOnnrh8d5yI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiXZ20OGO7ldC0ikgzVNnW3pKJUgY0QsNCT2CkJK8iNSUFLLXe
	LxqpCFJ7YtbvvpLnH788RrrgKopa1RDsifrhhOTswZHAHB7hKSJv+FGm5RTdIWs=
X-Gm-Gg: ASbGncus1N7xUfhLaMR64PkUWd5swVl8eGl4Rg30Y1Ly4U9sahyR1fYdyq7edNBCoTC
	3/bVobPV5OCYFcceX3+nqi8XhVKmauDRFf1WBv+PUVxJ1HdjHe8U0DzIoP+FV05jZma/swJLIhA
	uZ0oCZUSh06pNj2xTcwk2i6KNP+QmFC8Jbx8EUtrPxSkCHNgL/pNNMqwiJ0lFYe+FnYas/oTzvm
	2JkN/+S1FAs58Pr5VGwh73je8bxbxvrZ+XhSnKUxmUse5QadkdQdhmbXRy6ndy0haCVtb7tRmIX
	NQn+g8muvv4qC0/D79qdnGIsp+10jot31azeShKAFg8Z6Q==
X-Google-Smtp-Source: AGHT+IEXtMD53rpT5+I6qBlek794Ca+55Nd9V0KPjs7YD1xcg1pmEqFLjYcNNVWjDAHYDrYaGY3dSQ==
X-Received: by 2002:a05:600c:3c89:b0:43c:f87c:24ce with SMTP id 5b1f17b1804b1-43d1ecd7adfmr118223885e9.21.1742231290211;
        Mon, 17 Mar 2025 10:08:10 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d23cddb2asm96014505e9.39.2025.03.17.10.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 10:08:09 -0700 (PDT)
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
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v4 03/18] riscv: sbi: add FWFT extension interface
Date: Mon, 17 Mar 2025 18:06:09 +0100
Message-ID: <20250317170625.1142870-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317170625.1142870-1-cleger@rivosinc.com>
References: <20250317170625.1142870-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This SBI extensions enables supervisor mode to control feature that are
under M-mode control (For instance, Svadu menvcfg ADUE bit, Ssdbltrp
DTE, etc). Add an interface to set local features for a specific cpu
mask as well as for the online cpu mask.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 20 +++++++++++
 arch/riscv/kernel/sbi.c      | 69 ++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index d11d22717b49..1cecfa82c2e5 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -503,6 +503,26 @@ int sbi_remote_hfence_vvma_asid(const struct cpumask *cpu_mask,
 				unsigned long asid);
 long sbi_probe_extension(int ext);
 
+int sbi_fwft_local_set_cpumask(const cpumask_t *mask, u32 feature,
+			       unsigned long value, unsigned long flags);
+/**
+ * sbi_fwft_local_set() - Set a feature on all online cpus
+ * @feature: The feature to be set
+ * @value: The feature value to be set
+ * @flags: FWFT feature set flags
+ *
+ * Return: 0 on success, appropriate linux error code otherwise.
+ */
+ static inline int sbi_fwft_local_set(u32 feature, unsigned long value,
+				      unsigned long flags)
+ {
+	 return sbi_fwft_local_set_cpumask(cpu_online_mask, feature, value,
+					   flags);
+ }
+
+int sbi_fwft_get(u32 feature, unsigned long *value);
+int sbi_fwft_set(u32 feature, unsigned long value, unsigned long flags);
+
 /* Check if current SBI specification version is 0.1 or not */
 static inline int sbi_spec_is_0_1(void)
 {
diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index 1989b8cade1b..d41a5642be24 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -299,6 +299,75 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
 	return 0;
 }
 
+/**
+ * sbi_fwft_get() - Get a feature for the local hart
+ * @feature: The feature ID to be set
+ * @value: Will contain the feature value on success
+ *
+ * Return: 0 on success, appropriate linux error code otherwise.
+ */
+int sbi_fwft_get(u32 feature, unsigned long *value)
+{
+	return -EOPNOTSUPP;
+}
+
+/**
+ * sbi_fwft_set() - Set a feature on the local hart
+ * @feature: The feature ID to be set
+ * @value: The feature value to be set
+ * @flags: FWFT feature set flags
+ *
+ * Return: 0 on success, appropriate linux error code otherwise.
+ */
+int sbi_fwft_set(u32 feature, unsigned long value, unsigned long flags)
+{
+	return -EOPNOTSUPP;
+}
+
+struct fwft_set_req {
+	u32 feature;
+	unsigned long value;
+	unsigned long flags;
+	atomic_t error;
+};
+
+static void cpu_sbi_fwft_set(void *arg)
+{
+	struct fwft_set_req *req = arg;
+	int ret;
+
+	ret = sbi_fwft_set(req->feature, req->value, req->flags);
+	if (ret)
+		atomic_set(&req->error, ret);
+}
+
+/**
+ * sbi_fwft_local_set() - Set a feature for the specified cpumask
+ * @mask: CPU mask of cpus that need the feature to be set
+ * @feature: The feature ID to be set
+ * @value: The feature value to be set
+ * @flags: FWFT feature set flags
+ *
+ * Return: 0 on success, appropriate linux error code otherwise.
+ */
+int sbi_fwft_local_set_cpumask(const cpumask_t *mask, u32 feature,
+			       unsigned long value, unsigned long flags)
+{
+	struct fwft_set_req req = {
+		.feature = feature,
+		.value = value,
+		.flags = flags,
+		.error = ATOMIC_INIT(0),
+	};
+
+	if (feature & SBI_FWFT_GLOBAL_FEATURE_BIT)
+		return -EINVAL;
+
+	on_each_cpu_mask(mask, cpu_sbi_fwft_set, &req, 1);
+
+	return atomic_read(&req.error);
+}
+
 /**
  * sbi_set_timer() - Program the timer for next timer event.
  * @stime_value: The value after which next timer event should fire.
-- 
2.47.2


