Return-Path: <kvm+bounces-47568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13907AC20FF
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 12:25:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 277633AF76F
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 10:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E36323E32D;
	Fri, 23 May 2025 10:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Td/jiRBi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A5723D29D
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 10:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747995756; cv=none; b=S2QIc1SVHQ78NzWfn0uTNXipKKF6atLmGI+M3AwLpZs5+36FXwH5I8MQ9FMMPmNZln2S88yyRg+0Poybi4kflVrAdhSVz3b3DcCQXpJ+3fTZ9AnOKllzsVJz8i+qUTps/4uyV31Xb6vcIIYA0xEGy50in19NnaI/f/HIGakKhI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747995756; c=relaxed/simple;
	bh=3+zyVKqir6lmor6lBqgW/Ph3RSN0Yf9mQOjdau7kAZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C+FCUox1euFPgMICT4Jdj3hASHFsZglu4YqoZIAsF78XcARJmMfN6g6/VkrKljXKNSeHARVo5Wmb/LHPIoiNRL3dpl32jZV7ilJKJch+msJC6kzGnPVD0BCpKTnvkXZ5zEiuim/0GTDUL/VpLSzJtDrQsZ7B0+5Y3hCOcUYhAj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Td/jiRBi; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7426c44e014so8616731b3a.3
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 03:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747995754; x=1748600554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Pxqge87zPhTrwo0PySrFAhV25ryh/dqXEpJhdjy2V4=;
        b=Td/jiRBi2OKn6jSkX8mpPpGuYYxfI0jGr5EU10qdTYkfBgWRlCnzzZVeD8XrTeOMXC
         f4Iki56cTa3fRqV0Dalzud6c2NM7UZE8fMN7fEw7LSWVlkWwfnrXfU/yp7KtA60ETQRn
         0o1n5wU8Dn/5F5aP720ZZAS6kGAE008iPf5gb0MIawbFltLBAgFYneXd2bFfNWuP7CdJ
         ajTgRJYX93ml4w0bVBjGvsceuZIGH538MEwW+Zj3v3zVmozuSlglo6caXIwPqM01+Xna
         5HoRJLL3IR+ojqXEdEdioaePBm0WJleQNKTXYUDcD96irR5gcN6Q3KU7DGIZ1M0bEAqQ
         Q/BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747995754; x=1748600554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Pxqge87zPhTrwo0PySrFAhV25ryh/dqXEpJhdjy2V4=;
        b=tQF0u4uY+KCtAuSeeg3WbTO5sgKnmlRZgGYEJ8BZF7z5zgn0m1EsCBgOXwxSEEsAbI
         XhG4SfvTSVPbyseVxcA8G/xvaJ752fjOcXwiGbrYhLIb7vCTn3Vr0l+nvKYbRoF8vJzS
         3EYhObL8N+WcccGZ/xAdgVm2aMZ1axbc7EaPUaySA9ESCxLsqiVgMmkW8nrxDUJkG2WL
         ITP6+34jZQE7B6dnnfa4AUHjnUMIN5NllHrAUgtdnpclIiS0vZwrrFIhnmf48yuZB1jI
         fvSmKoy3vgEu8Y009wSXVQ8qqu7LMCGZ1xO1pgdC50zT1IyW/G9HZuy8NXHyg8rYZbYG
         c/Eg==
X-Forwarded-Encrypted: i=1; AJvYcCV6czKkd+Q6BC9/4VS70ASieYeVu8kUC/kbA1XYQ+Bis6Okmo5lMq98plnqYZbErWjj5lM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEaheCvgZd7wZhE7jABdxaAMJa75i24Y14HctVoDMj6cJZ/bh6
	qqlsaSBr3ypb48N4ZADZa0OmZSA23GUmKaqaNG469jRBU72JFdg+nZdPaUhIxCIbjAY=
X-Gm-Gg: ASbGncvNKfeG5cElaaYApouKt4IZwrSZJOT+XM+oHoYH3RgKp+Kl/OuM/cNJ4yq4qbR
	QJ+MUAbXDCcB2M+0FdrNqyiDGPB6XiK1R0/PgiyEe33NqA5nc81Lqe5unQ6yeJWloCg5CjgRXXD
	ld/bEBHcEiAKO8x9d75dkMc6MCn+UlTt0bAZciL/IgexsHMjpTEhVMttsOmpZUOiq4DJHu4k0y6
	qvzb7dVNlSlRAv/FIYJcUKM7UjK2moY0y1eUFzo3CWsthZtggQG7m/udDWHwVbVdVNWsYce+veN
	walMRz/AD2htMjibFYZ/IIWao53jZIgvYYKE0NBFFViKkIYdB3Bf
X-Google-Smtp-Source: AGHT+IE1gzTYiMm9OIAjWx1ABZw0Jx+guEhp6+UHAyUqExFCs1x+5gRpocDwFkted+eu2d1RJUlKew==
X-Received: by 2002:a05:6a20:7f9b:b0:1ee:dcd3:80d7 with SMTP id adf61e73a8af0-21621663910mr40638738637.0.1747995754383;
        Fri, 23 May 2025 03:22:34 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a9829ce8sm12466688b3a.118.2025.05.23.03.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 03:22:33 -0700 (PDT)
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
	Deepak Gupta <debug@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v8 11/14] RISC-V: KVM: add SBI extension init()/deinit() functions
Date: Fri, 23 May 2025 12:19:28 +0200
Message-ID: <20250523101932.1594077-12-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523101932.1594077-1-cleger@rivosinc.com>
References: <20250523101932.1594077-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The FWFT SBI extension will need to dynamically allocate memory and do
init time specific initialization. Add an init/deinit callbacks that
allows to do so.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  9 +++++++++
 arch/riscv/kvm/vcpu.c                 |  2 ++
 arch/riscv/kvm/vcpu_sbi.c             | 26 ++++++++++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 4ed6203cdd30..bcb90757b149 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -49,6 +49,14 @@ struct kvm_vcpu_sbi_extension {
 
 	/* Extension specific probe function */
 	unsigned long (*probe)(struct kvm_vcpu *vcpu);
+
+	/*
+	 * Init/deinit function called once during VCPU init/destroy. These
+	 * might be use if the SBI extensions need to allocate or do specific
+	 * init time only configuration.
+	 */
+	int (*init)(struct kvm_vcpu *vcpu);
+	void (*deinit)(struct kvm_vcpu *vcpu);
 };
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
@@ -69,6 +77,7 @@ const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
 bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx);
 int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu);
 
 int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned long reg_num,
 				   unsigned long *reg_val);
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 02635bac91f1..2259717e3b89 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -187,6 +187,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	kvm_riscv_vcpu_sbi_deinit(vcpu);
+
 	/* Cleanup VCPU AIA context */
 	kvm_riscv_vcpu_aia_deinit(vcpu);
 
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index d1c83a77735e..3139f171c20f 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -508,5 +508,31 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
 		scontext->ext_status[idx] = ext->default_disabled ?
 					KVM_RISCV_SBI_EXT_STATUS_DISABLED :
 					KVM_RISCV_SBI_EXT_STATUS_ENABLED;
+
+		if (ext->init && ext->init(vcpu) != 0)
+			scontext->ext_status[idx] = KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;
+	}
+}
+
+void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu)
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
+		if (scontext->ext_status[idx] == KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE ||
+		    !ext->deinit)
+			continue;
+
+		ext->deinit(vcpu);
 	}
 }
-- 
2.49.0


