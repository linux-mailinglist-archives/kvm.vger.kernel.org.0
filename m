Return-Path: <kvm+bounces-43577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D688BA91C07
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 14:27:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82D8F7AF64A
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 12:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530E524E001;
	Thu, 17 Apr 2025 12:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ebL7KfEo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C5024DFF3
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 12:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744892730; cv=none; b=LuDpssXsIlgiXN9vnUXYFoxOx5i/J3Nd+hTsa+CupxaYke4VBfruQU30xIfwwfjUMiN9hU8ugJbvHWx3Lpwe0Gfx9tYUR9MBzc9cWQIwT729Px9EBREOfBeQXRjQZMuCrigKh6EK8HSYbjNSN4g63lXOLeUGQxPxTntP10DmTMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744892730; c=relaxed/simple;
	bh=NXa9HEO5RKY1D2k9IbxsxMtK9lSmU2PJg0VdH4XU874=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g+r2OvUr3s7JFj/FjFytBW8PjLP9PNkQtDhGKgGQMecxC5E7d5lVzjEkAJePQ/3YasURzT3dGYPPfNgeRIrm090UwgF7ZZ5gTW1ngWomxlwmXU/donaLv1PclPvZGgwLIwqc5qggLIZ0pqV0JHLmIPUcp9c86GmFvL0fDtqxxp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ebL7KfEo; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2255003f4c6so7782325ad.0
        for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 05:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1744892727; x=1745497527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/KHThPTp9HBECdAqxs4JY6wN99GqOifsmOPr7rqjaok=;
        b=ebL7KfEoLNqPqmyiWZAsOd3YNnrAxLi5iPwk0vZzO1HAU3PqZEJryOBOFQUSEVCx5D
         6KkPS6/omiyR0cw0DrR0w6vrXo0ovV9xKUmPfHP5vjiMavkamcppOyMq7bswF6h8VZtg
         pxV/CglZ5tAXiNA16etMPHVOp4m3cL2smOraRDIxnAhAKz1ynOIm3uQ6RgE/FFFMxMIV
         zob7P1LzvABzUMIukDwahFh5UbXLPsZDjV9jmuE4UB6A3438EiK8S3aTsYIT+9tapbf+
         6gyLejP7c5HNtVFUvD+uBUmKS8FpY3//gbPpgZ2JOVDg8f/zsC1MkvFmxoz4vqjny5sn
         gR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744892727; x=1745497527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/KHThPTp9HBECdAqxs4JY6wN99GqOifsmOPr7rqjaok=;
        b=FLn4JyZn4BrYfLi+VYs1d6rO4vjFfwSqVVlDUcARMAltuqLADO1YEqHBwdeKuUPr8r
         e6Bz2WVnr5a6QT3q3Yf5APJzP4hOuq5PMHRLl7g6Q3rI4UFhyi8CDOq62w/2uyIk+jN8
         rYA+sP0qheOv444XxXCLFCW13H7aWSdj+h53FG6BCbghWLsNDXZ04yB/SqOiqA4DNPB3
         gyfspdgbWUunljqGAwvoajBUa/IODUmK33oivUAc78KVC0HY1TQXhh2cJB8LoCCpZy1a
         nTi2GtoE2YyVE9pNOBIa0oB5QHMPNlxwo13XNrkP1L0vi0h3CBYy3EBOSrMbRfRju7qd
         tnmg==
X-Forwarded-Encrypted: i=1; AJvYcCUwMkmtI201YRhefXyI1KbvMq/nGdiSEw6oxqEQJX7PahrVhXtiEFLH/jit8RjNyvBvGYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxenGOmylVS2lrQo9Hb0nd4qJxgf0H5qs9LIHqBHDMZe4NIGMlG
	SKhrQ/+kw818bgsyHJADc6uUcJeJNyGKb7WA0+S8/Ir3AUwU/BrcstXM/NXYOvw=
X-Gm-Gg: ASbGncvEzEYMu46Hyw5cuQdHQ9skytB/sCZzLin2mK/XdtFCroVKhY1gYsQHV+eLlT8
	T44n7gA/T/GnLpZRdcE0Xdz9QqTbK0e9iz2vmOBA7I1xWTJu/QLroSNiRr8N/UmCWflPbEpo66I
	g/wW72Wbwadj7VcVYFOy1SyGYwPR3DcL50oEvtRk8B2Jfk25DhsmJRokVa7j93ZOtKbBXNREMJF
	AsHQ/bctEWUgmNQlN5Fhm7DKSVhFh0On2oTA3MkVAJjTvZ2TjbZxk7lO+QFiq8/muH8cyZNEBBX
	+A/SMZQIQtuARoFMWgPdopqZM23ejIAXpB52lZweng==
X-Google-Smtp-Source: AGHT+IEoqy/kqoORsS0UV+1ioB/JireEK12cMki3F6JIxzmrV6R0qu0Yn7V200b2nJAkaxmJUugsbg==
X-Received: by 2002:a17:903:1b26:b0:224:13a4:d62e with SMTP id d9443c01a7336-22c3597ec4bmr109539965ad.35.1744892727277;
        Thu, 17 Apr 2025 05:25:27 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c3ee1a78dsm18489415ad.253.2025.04.17.05.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 05:25:26 -0700 (PDT)
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
Subject: [PATCH v5 10/13] RISC-V: KVM: add SBI extension init()/deinit() functions
Date: Thu, 17 Apr 2025 14:19:57 +0200
Message-ID: <20250417122337.547969-11-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417122337.547969-1-cleger@rivosinc.com>
References: <20250417122337.547969-1-cleger@rivosinc.com>
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
index 60d684c76c58..877bcc85c067 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -185,6 +185,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
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


