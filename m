Return-Path: <kvm+bounces-41279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F5A2A65A47
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:18:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C964F885B71
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4284205E08;
	Mon, 17 Mar 2025 17:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="lDAhLQyY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D9A20485F
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 17:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742231310; cv=none; b=da91VLuzzwmhPPL4cajIQFbUPuXnRZNGbJs91IxpFi8ZxDZctdoxazPVfMUnx9wlpSB6ptf9HWkJQCHiIVkOASU0Mpo6SPQsx1R0xmRA20Ym2F+Z3CFaxqhyKvZtVv5unS4o4Ri79nO+y4/WbKkHegiGWaphL2BiFJBWB2TuzRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742231310; c=relaxed/simple;
	bh=A4sN/k9udFYHC8rKOJ7GPL1gc/l4wJ5pXjUE1OCS49A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=phOwFt9E+eb6ESL/e/URDQD5gDK9UxpFSgCE2JqZqXaWTNv45dpsIPQGV1lcBwp5NYT5pALZpx3w+T4qXGa4BJIicL+8AMo7VCV2rAn4BTq2fjbV/Oin7aidJ7VpNjxI9EiUAQ3jNfd3lCNYH0iP138TGgZhUgvqiSzWLdwFpo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=lDAhLQyY; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43d0c18e84eso11015295e9.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742231305; x=1742836105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nBnjzkDoAHCYES1tTH1RlHgMSmamC+5QlhVYnXgdQEI=;
        b=lDAhLQyYSYSJcmGW+xNXKfAcqyeKyhel8pIznadDrnGv4Rk+7wz31QHjTiGb577KI+
         0ZwdOzQL7V34YMw8sr6RmrsdNOGf1A6T4OhWr7ywBCHHrT2nvP5F/oLOB5S1X8MHOFe/
         VF6owPEEmSlZHYJMcaJR0WwSDnHjpiof3i6KjvmzvqFm0muYRjHWk/t8N603i5Kj/EA2
         FJ1IS7I670otwVLyRMsGxRSmo/M68hStnqYd37jjHB9bImrdRB26qSI4INyzTC94a/4/
         JMEUDByvF7U8lZVnG1cgYsyWTAkO89Arw5CRc2cvhJ0AUZcEMajormoxTKa2tPJTpFip
         VViQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742231305; x=1742836105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nBnjzkDoAHCYES1tTH1RlHgMSmamC+5QlhVYnXgdQEI=;
        b=FebAGpA9on8VQMGMEA1hJW/nYk/zA54DiDAuMg2Ztz3nB4FfSNKrbByrvwG5kX2Vld
         KuVANcyssXso919hDxQgp5iVErbaD9eUAyENJQuYEtS/RAsXDvSR2DMp2nXU38Z1CL9H
         nbv9Jq960MvfwVEVXjMTRd8Zo0ttdscKDa+nH+kmg/dkQkWyRA1UvP8erlXdY1LzHSmy
         3vnNsCrKA/N4Ro7dQmtDSs4cvSAEB5J5aFOe6IKqVC9hggDhB5zGnBoOMVYrVAduE2pb
         e/RI3SV7RGT8QgC0KShaKRq5Ra768tWKtgLnM050OQVbA+oNZpKbrYKLNq/FdviSHhzN
         FNAA==
X-Forwarded-Encrypted: i=1; AJvYcCU5JO9AG7ZjxWTr/mHMIYnhqLjVhffZIK3vPQZK5tLGmoPA3DvJJjZEPc8TsU10H+Kb54I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBkOTz7Yzo2BbTghfUFr6bx9yb+XnIikOxH6rji9aQTQL/anw8
	UaiU0aHKaqinbUwCMBNXCRH2Za9R1C6T/8BcSjb//TxRz0noETHyZ9HUOUxjY1I=
X-Gm-Gg: ASbGncupd+jcPsuU3rVUkcLPw65E1IioVU4uLAt19x/ONZKVI+YbHYALPvJMN3l49cX
	kMdrJi4waXq70cDLJ39nClBSoLSOPXr9J59QrsN8A1LQpoyZy3t1NA9kbjpzt4VvMP+bf1qYGEJ
	vOkaN4eZ6ATyz0Bl//OSzeHiaiXZpAfL7XLivcA1z96l9fFL/1ycEE3aSjiWymqnZeeJbIbd9jr
	VjkshAYx6o8BE9Zy8vlTr2HmaYRYviXvQ1nZwmtmmgpr/2TbYxAKmHJOCL0Dfz+F4x88vDe1xxz
	Sy7cXyxBoulH2CmbZS0T+MecTPKb3mAVWXJNLaH0T1rtQmPvqndQALjm
X-Google-Smtp-Source: AGHT+IEqhdp5dcBzbvbBuH3dLSPFcvLdqKUwlLK3z0GBcZnv77CKTJXWVzz2XGRU3Xp4MOn6/tiCWA==
X-Received: by 2002:a05:600c:4ed0:b0:43d:ed:acd5 with SMTP id 5b1f17b1804b1-43d2a2eca5bmr70294645e9.10.1742231305531;
        Mon, 17 Mar 2025 10:08:25 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d23cddb2asm96014505e9.39.2025.03.17.10.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 10:08:24 -0700 (PDT)
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
Subject: [PATCH v4 16/18] RISC-V: KVM: add SBI extension reset callback
Date: Mon, 17 Mar 2025 18:06:22 +0100
Message-ID: <20250317170625.1142870-17-cleger@rivosinc.com>
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

Currently, only the STA extension needed a reset function but that's
going to be the case for FWFT as well. Add a reset callback that can be
implemented by SBI extensions.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h     |  1 -
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  2 ++
 arch/riscv/kvm/vcpu.c                 |  2 +-
 arch/riscv/kvm/vcpu_sbi.c             | 24 ++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_sbi_sta.c         |  3 ++-
 5 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index cc33e35cd628..bb93d2995ea2 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -409,7 +409,6 @@ void __kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 bool kvm_riscv_vcpu_stopped(struct kvm_vcpu *vcpu);
 
-void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu);
 
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index bcb90757b149..cb68b3a57c8f 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -57,6 +57,7 @@ struct kvm_vcpu_sbi_extension {
 	 */
 	int (*init)(struct kvm_vcpu *vcpu);
 	void (*deinit)(struct kvm_vcpu *vcpu);
+	void (*reset)(struct kvm_vcpu *vcpu);
 };
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
@@ -78,6 +79,7 @@ bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx);
 int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_sbi_reset(struct kvm_vcpu *vcpu);
 
 int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned long reg_num,
 				   unsigned long *reg_val);
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 877bcc85c067..542747e2c7f5 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -94,7 +94,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	vcpu->arch.hfence_tail = 0;
 	memset(vcpu->arch.hfence_queue, 0, sizeof(vcpu->arch.hfence_queue));
 
-	kvm_riscv_vcpu_sbi_sta_reset(vcpu);
+	kvm_riscv_vcpu_sbi_reset(vcpu);
 
 	/* Reset the guest CSRs for hotplug usecase */
 	if (loaded)
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 3139f171c20f..50be079b5528 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -536,3 +536,27 @@ void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu)
 		ext->deinit(vcpu);
 	}
 }
+
+void kvm_riscv_vcpu_sbi_reset(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
+	const struct kvm_riscv_sbi_extension_entry *entry;
+	const struct kvm_vcpu_sbi_extension *ext;
+	int idx, i;
+
+	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
+		entry = &sbi_ext[i];
+		ext = entry->ext_ptr;
+		idx = entry->ext_idx;
+
+		if (idx < 0 || idx >= ARRAY_SIZE(scontext->ext_status))
+			continue;
+
+		if (scontext->ext_status[idx] != KVM_RISCV_SBI_EXT_STATUS_ENABLED ||
+		    !ext->reset)
+			continue;
+
+		ext->reset(vcpu);
+	}
+}
+
diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
index 5f35427114c1..cc6cb7c8f0e4 100644
--- a/arch/riscv/kvm/vcpu_sbi_sta.c
+++ b/arch/riscv/kvm/vcpu_sbi_sta.c
@@ -16,7 +16,7 @@
 #include <asm/sbi.h>
 #include <asm/uaccess.h>
 
-void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu)
+static void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.sta.shmem = INVALID_GPA;
 	vcpu->arch.sta.last_steal = 0;
@@ -156,6 +156,7 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_sta = {
 	.extid_end = SBI_EXT_STA,
 	.handler = kvm_sbi_ext_sta_handler,
 	.probe = kvm_sbi_ext_sta_probe,
+	.reset = kvm_riscv_vcpu_sbi_sta_reset,
 };
 
 int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu,
-- 
2.47.2


