Return-Path: <kvm+bounces-42563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F469A7A1F3
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 13:33:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F41813A7CD1
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 11:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A019424CED7;
	Thu,  3 Apr 2025 11:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="QkYw8+K8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB7B24BBF5
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 11:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743679936; cv=none; b=Z61jyQhkFby3d+eiJmyjhsHXDVdQhgH41aKS3bfDmmR6lkC3/6uHI6JrVhFDHDrCarAXzil/EpISs66u4klI+IlwasYIKrkUfqsE9aR5QPe3kPffSTpZlG6sRHEhjpTPntC4drHe2Xz70Obh9+BNITIq4dCIhURsC+BxOHQPHig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743679936; c=relaxed/simple;
	bh=jffCTzK2ifUcsRuyU60Vh5EyDsYilh1FFdL2XDp/iQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NaKULicDTqSIWJ6Ggakra7PhNZ/3mY3Pv1Tfp641f7Op1RDQa9V3dIPCaEnQdQB7NETxSXW8n2EKRm5jys22g/nmfaI2GF4om3WeNvCA94ciebQB4hrepCdiJN5EDHJxkC3E1Duz/W4hLcLSdzQX6QdvWJCenxaOWtrmVE2tseE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=QkYw8+K8; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43d64e6c83eso608555e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 04:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1743679932; x=1744284732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M+bBWXikjKTcV8ccgilNOkXVbdx4GamWUb2bvML3ssQ=;
        b=QkYw8+K8Y1aOHkQhVnDONrAN5/+jtuBP/vOoVOcOluUnlXSx2nXcK+dr0u9Q0YWrvW
         67sdppl95BJWLI6Tw4gVIyx6EDhRyIgN4TKqCvRBlNcabHVpsjhZ5+Tk6NZUHTPTViiY
         fy92jQwedB2hJ1e292umhzjbdRWI5pM1MGaUfN2Zr55Isrs1BewFInpv69FId6Q9Y/GL
         L/rLTS7HCiUX5w3c5yvpM4FUEMOOwkIU4paO+QZDPh5q1XwTZiWSR5z6VM5ThxCY1UsD
         +LEKzvC/RYKFQPRm/JOUP8IWoNEdOq+yyMtubegsxExpxmXoTi4z3JgA/dahzbUV/KEv
         ehXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743679932; x=1744284732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M+bBWXikjKTcV8ccgilNOkXVbdx4GamWUb2bvML3ssQ=;
        b=EJfF8nxbI4//tS9FvKqOnQaA2c6JLyYHFYdEPchlterfjXCub/iXBcPd6oPr+wQh8B
         7sSE8Q3Be5I3MY5i7ldpqLNAkCCtVOpa4D2rEgXVy8Qc+zuya0e+ODyjOiMNcLxW7O5l
         MDoUb3cliwGAoTHp+tPVGBQ9i26ChqzUrHtHsJMh4LUWJTFj0ach9Wgy1gY8hTWeabWD
         diebqP8Z5iJ/5a5wO9hQy7VjYkN0SjnGAahPZ7jNw2klarIMQI0y1iqrbDIyLtR81h1f
         7GZPzlXZKEkP2MZ5hlRzdhiM8gws6Vg9vAE44bSD+oS0gK94vqLc1S33xQ3egy/DbZ8I
         CIAQ==
X-Gm-Message-State: AOJu0Yz3F7mBvPSMcwvB5gu3Ti5ku/fs1CKeRVbW8UHq+0q6nxSp1L7R
	ZBrkPfqOEZIQ9P3dTvx2GEAmhiqRVYWjax03EHVoPQ2kRmAtNt0x2TJUixWmDolAg+BX7AWSV4y
	N
X-Gm-Gg: ASbGncvQxK1aZCdO4bwi0zTf9OsIZj3LdmN7GBJIFyOSl7KMxPotIG/SB3GcLw+Vbva
	D05DFt+pK+BEBMXVRYHdWrqMy6UGZJQs+WbJ+BedfJ6tkzKrman2aZP2FOsYL+XX0Aja8EfqJ7z
	Bmc/2yNuRZjv7DIsQ77uXfVRLSQME3MKle98Xva3yqWBzwQq8OdTSKecpYdIdLyQKVEY35sSieO
	mJ/7kIEe/hmt2xjnQK3J3P8yXNoVznzSG09I5H6FIPTD6f5RWB8stbklhOrLIepTaEdbXrdKhKE
	zBuu4xV3JCIDeG2aiXksTSxDMZbGj2K8sei6EBMjJaiB4LJILpbnZIT1Rk44j19+6ws7LI5WpQW
	EpQ==
X-Google-Smtp-Source: AGHT+IFKuI/VQYzBaPbrBORZ5Fz1t5HIbnJ+TER1Sbfneisom4goMlCFQ2arAW6gwbRupN7/O0Rx8w==
X-Received: by 2002:a05:6000:144a:b0:391:29ab:c9df with SMTP id ffacd0b85a97d-39c2470802cmr3357803f8f.4.1743679932289;
        Thu, 03 Apr 2025 04:32:12 -0700 (PDT)
Received: from localhost (cst2-173-141.cust.vodafone.cz. [31.30.173.141])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec366a699sm15541695e9.38.2025.04.03.04.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 04:32:11 -0700 (PDT)
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
To: kvm-riscv@lists.infradead.org
Cc: kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>
Subject: [PATCH 1/5] KVM: RISC-V: refactor vector state reset
Date: Thu,  3 Apr 2025 13:25:20 +0200
Message-ID: <20250403112522.1566629-4-rkrcmar@ventanamicro.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Do not depend on the reset structures.

vector.datap is a kernel memory pointer that needs to be preserved as it
is not a part of the guest vector data.

Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_vcpu_vector.h |  6 ++----
 arch/riscv/kvm/vcpu.c                    |  5 ++++-
 arch/riscv/kvm/vcpu_vector.c             | 13 +++++++------
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_vector.h b/arch/riscv/include/asm/kvm_vcpu_vector.h
index 27f5bccdd8b0..57a798a4cb0d 100644
--- a/arch/riscv/include/asm/kvm_vcpu_vector.h
+++ b/arch/riscv/include/asm/kvm_vcpu_vector.h
@@ -33,8 +33,7 @@ void kvm_riscv_vcpu_guest_vector_restore(struct kvm_cpu_context *cntx,
 					 unsigned long *isa);
 void kvm_riscv_vcpu_host_vector_save(struct kvm_cpu_context *cntx);
 void kvm_riscv_vcpu_host_vector_restore(struct kvm_cpu_context *cntx);
-int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
-					struct kvm_cpu_context *cntx);
+int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_free_vector_context(struct kvm_vcpu *vcpu);
 #else
 
@@ -62,8 +61,7 @@ static inline void kvm_riscv_vcpu_host_vector_restore(struct kvm_cpu_context *cn
 {
 }
 
-static inline int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
-						      struct kvm_cpu_context *cntx)
+static inline int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 60d684c76c58..2fb75288ecfe 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -57,6 +57,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
 	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
 	struct kvm_cpu_context *reset_cntx = &vcpu->arch.guest_reset_context;
+	void *vector_datap = cntx->vector.datap;
 	bool loaded;
 
 	/**
@@ -79,6 +80,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	kvm_riscv_vcpu_fp_reset(vcpu);
 
+	/* Restore datap as it's not a part of the guest context. */
+	cntx->vector.datap = vector_datap;
 	kvm_riscv_vcpu_vector_reset(vcpu);
 
 	kvm_riscv_vcpu_timer_reset(vcpu);
@@ -143,7 +146,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	cntx->hstatus |= HSTATUS_SPV;
 	spin_unlock(&vcpu->arch.reset_cntx_lock);
 
-	if (kvm_riscv_vcpu_alloc_vector_context(vcpu, cntx))
+	if (kvm_riscv_vcpu_alloc_vector_context(vcpu))
 		return -ENOMEM;
 
 	/* By default, make CY, TM, and IR counters accessible in VU mode */
diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
index d92d1348045c..a5f88cb717f3 100644
--- a/arch/riscv/kvm/vcpu_vector.c
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -22,6 +22,9 @@ void kvm_riscv_vcpu_vector_reset(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
 
 	cntx->sstatus &= ~SR_VS;
+
+	cntx->vector.vlenb = riscv_v_vsize / 32;
+
 	if (riscv_isa_extension_available(isa, v)) {
 		cntx->sstatus |= SR_VS_INITIAL;
 		WARN_ON(!cntx->vector.datap);
@@ -70,13 +73,11 @@ void kvm_riscv_vcpu_host_vector_restore(struct kvm_cpu_context *cntx)
 		__kvm_riscv_vector_restore(cntx);
 }
 
-int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
-					struct kvm_cpu_context *cntx)
+int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu)
 {
-	cntx->vector.datap = kmalloc(riscv_v_vsize, GFP_KERNEL);
-	if (!cntx->vector.datap)
+	vcpu->arch.guest_context.vector.datap = kzalloc(riscv_v_vsize, GFP_KERNEL);
+	if (!vcpu->arch.guest_context.vector.datap)
 		return -ENOMEM;
-	cntx->vector.vlenb = riscv_v_vsize / 32;
 
 	vcpu->arch.host_context.vector.datap = kzalloc(riscv_v_vsize, GFP_KERNEL);
 	if (!vcpu->arch.host_context.vector.datap)
@@ -87,7 +88,7 @@ int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
 
 void kvm_riscv_vcpu_free_vector_context(struct kvm_vcpu *vcpu)
 {
-	kfree(vcpu->arch.guest_reset_context.vector.datap);
+	kfree(vcpu->arch.guest_context.vector.datap);
 	kfree(vcpu->arch.host_context.vector.datap);
 }
 #endif
-- 
2.48.1


