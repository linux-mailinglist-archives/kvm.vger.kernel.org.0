Return-Path: <kvm+bounces-49859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB9DEADEA76
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:41:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CA073BF9E4
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0852E9EAD;
	Wed, 18 Jun 2025 11:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="IzM/ZEo5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986B52DA764
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246598; cv=none; b=renPw5nSx5gURQ//yh5dp1Ek+wtEcRCborcwDnLIywvbXq1Cj22++DkVQERmGWBbJ2ueGynTGSX/9XZdsqfInXbJnVQ16LjITWR4A6qvLiT+Y0R1CyWfUms5XguKyn5Vl4H5ixUx6C2oqj4G3q+6Tz9FR2qboG99t9usQ0YYsmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246598; c=relaxed/simple;
	bh=9DkH1MnmKplYHcxUKPSWXUR9/q6pa0raZeD0CabKAcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYe5LisCvNVYILBwpQNVAlIbhClAJnYu4ZdqNcQSoXpI6cb2XB66DI+3BgsldqydSD1bo0mRBjXzRp5R1g5UELVXLeXHGRVoBFqE7lve2c49sP9JlQLbS9NYZlFYIXRbhPncCtIxJpHoe2LGxtk/GaQhp/Rv+5Lud2Z2j3x0bOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=IzM/ZEo5; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-23636167b30so61018235ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750246595; x=1750851395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wv2Dv1D3mRBWch3U2QfEIQG6aPxPGFrtjz75yYPWcVQ=;
        b=IzM/ZEo5d4+FVrnCR3TYOO3BBK0QT93GQpbSlRA5liM5icaOONCS9KR/ZuVeN4SgJ9
         uTasFjgwgrMFydL10qhxK3KreE66el+N+yKfJxO6DM5lFy/JRFMjlQPn3fQKBTYRyMRI
         DIeQmE/fY/ZvNBJR8d0Wd5RIciMAn0VkGWMXcIReNhCykitdNFhz87zJwv6zurdwbFYP
         ZVh/kB680G5uFgg1TAL/6UjCYq2vd2QCtu28IaLgQgS0iroaE3mHUL1Wmx0Bs8V3X1ec
         H3EcKcTWYXAV/wfcOOVCp8OBrnLVhx9Iq5xxjfuhlnhvvQL+6v7YBbE9MOc62IBquMNQ
         xFVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750246595; x=1750851395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wv2Dv1D3mRBWch3U2QfEIQG6aPxPGFrtjz75yYPWcVQ=;
        b=q5PZkLCgb1zuAmdeO7WmRp2wEs9TSi3lRhtrhKGmlIrfPL8Wk0gjnwAQaLz4FEuW0e
         /7FCZm5jwbTXfWFpSuJY5Xhyx/oEGwHId12c359jtZ7BgjKThj1yFXJGJAp+Lxjsg6r4
         MpAGIlVsiVzmxB6+qwPRQFtyX6ml29zSgT0l9K4/PTZNWQa2CIitzj3PR7skBfLvYD0H
         mkhKlDpkJD2m810CNu1ow10erWlXdHzs6q1Kqf6N94ZH84tG4NcsfVqkDSaMiB4Gzb/G
         nGhmWsgRjGLFjuou5OS2SRKpUnYwznfgV5WKOpxZnkTNRhnbhvVxYNebbKyK7eOnLPMV
         3OYw==
X-Forwarded-Encrypted: i=1; AJvYcCXJOMCWUvBOmwKoQe/EcWRrZFkuwyEGYknTagPempX2NHoo1/8Knm85jPxqiOMCLO4Rdis=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNpgqnLvEgR7qVlrnsVDu1GanCq9Tu9cw6XHt9Ccs69FdBbzJD
	iOO3FWzhN1alvrnv+q47W/ySk9/4/7zXUkaC4ULR7eqJl+qnay/rrOVw2B3sWukJtYY=
X-Gm-Gg: ASbGncsuXW1oecKGWTrhAr1+N9Qy/yq90p+v+oMFjElz2WBZENodBb7SOukaxxlxhWg
	qbccFgWYrOEEpx92wmgERB7YVTIm0OBpXVoEd2+FygPEJ51gIXrZBJMmXnqaduKQ64FlaBC4OdL
	EkwrNJMcx+iLdf/wDQozUmMKwbQv5itWgmeo/xm1t94ffPDLjMGhE2iS+ZjdaAPh5yzj33A244+
	Fet8QsXtDy97PJgZlPrgfI9OJ6R8zzn5rs+DtB/pe43E3QpJZ9MFq5ol+VfjLA4qkw8LDaQ9fa0
	SQ5uA+pwSzHIm+BOK/vDbM+ljFbgilVA+hpwcyKG5jzo36zQXLm6liGtx+r8P5GZZw2PW7r4V29
	MzM5f7R6QnEU7E+HnGg==
X-Google-Smtp-Source: AGHT+IHj3Fmtrtd3/iR0RBFJ3K5R+ndUPF941cuYVZNiiA3rRlmLdRt/HqLMxHP7frHFlTuPO9nuwA==
X-Received: by 2002:a17:903:41c8:b0:234:f580:a11 with SMTP id d9443c01a7336-2366b344b39mr298672495ad.19.1750246594829;
        Wed, 18 Jun 2025 04:36:34 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237c57c63efsm9112475ad.172.2025.06.18.04.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 04:36:34 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v3 10/12] RISC-V: KVM: Add vmid field to struct kvm_riscv_hfence
Date: Wed, 18 Jun 2025 17:05:30 +0530
Message-ID: <20250618113532.471448-11-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250618113532.471448-1-apatel@ventanamicro.com>
References: <20250618113532.471448-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, the struct kvm_riscv_hfence does not have vmid field
and various hfence processing functions always pick vmid assigned
to the guest/VM. This prevents us from doing hfence operation on
arbitrary vmid hence add vmid field to struct kvm_riscv_hfence
and use it wherever applicable.

Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_tlb.h |  1 +
 arch/riscv/kvm/tlb.c             | 30 ++++++++++++++++--------------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_tlb.h b/arch/riscv/include/asm/kvm_tlb.h
index cd00c9a46cb1..f67e03edeaec 100644
--- a/arch/riscv/include/asm/kvm_tlb.h
+++ b/arch/riscv/include/asm/kvm_tlb.h
@@ -19,6 +19,7 @@ enum kvm_riscv_hfence_type {
 struct kvm_riscv_hfence {
 	enum kvm_riscv_hfence_type type;
 	unsigned long asid;
+	unsigned long vmid;
 	unsigned long order;
 	gpa_t addr;
 	gpa_t size;
diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
index 6fc4361c3d75..349fcfc93f54 100644
--- a/arch/riscv/kvm/tlb.c
+++ b/arch/riscv/kvm/tlb.c
@@ -237,49 +237,43 @@ static bool vcpu_hfence_enqueue(struct kvm_vcpu *vcpu,
 
 void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu)
 {
-	unsigned long vmid;
 	struct kvm_riscv_hfence d = { 0 };
-	struct kvm_vmid *v = &vcpu->kvm->arch.vmid;
 
 	while (vcpu_hfence_dequeue(vcpu, &d)) {
 		switch (d.type) {
 		case KVM_RISCV_HFENCE_UNKNOWN:
 			break;
 		case KVM_RISCV_HFENCE_GVMA_VMID_GPA:
-			vmid = READ_ONCE(v->vmid);
 			if (kvm_riscv_nacl_available())
-				nacl_hfence_gvma_vmid(nacl_shmem(), vmid,
+				nacl_hfence_gvma_vmid(nacl_shmem(), d.vmid,
 						      d.addr, d.size, d.order);
 			else
-				kvm_riscv_local_hfence_gvma_vmid_gpa(vmid, d.addr,
+				kvm_riscv_local_hfence_gvma_vmid_gpa(d.vmid, d.addr,
 								     d.size, d.order);
 			break;
 		case KVM_RISCV_HFENCE_VVMA_ASID_GVA:
 			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
-			vmid = READ_ONCE(v->vmid);
 			if (kvm_riscv_nacl_available())
-				nacl_hfence_vvma_asid(nacl_shmem(), vmid, d.asid,
+				nacl_hfence_vvma_asid(nacl_shmem(), d.vmid, d.asid,
 						      d.addr, d.size, d.order);
 			else
-				kvm_riscv_local_hfence_vvma_asid_gva(vmid, d.asid, d.addr,
+				kvm_riscv_local_hfence_vvma_asid_gva(d.vmid, d.asid, d.addr,
 								     d.size, d.order);
 			break;
 		case KVM_RISCV_HFENCE_VVMA_ASID_ALL:
 			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
-			vmid = READ_ONCE(v->vmid);
 			if (kvm_riscv_nacl_available())
-				nacl_hfence_vvma_asid_all(nacl_shmem(), vmid, d.asid);
+				nacl_hfence_vvma_asid_all(nacl_shmem(), d.vmid, d.asid);
 			else
-				kvm_riscv_local_hfence_vvma_asid_all(vmid, d.asid);
+				kvm_riscv_local_hfence_vvma_asid_all(d.vmid, d.asid);
 			break;
 		case KVM_RISCV_HFENCE_VVMA_GVA:
 			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_RCVD);
-			vmid = READ_ONCE(v->vmid);
 			if (kvm_riscv_nacl_available())
-				nacl_hfence_vvma(nacl_shmem(), vmid,
+				nacl_hfence_vvma(nacl_shmem(), d.vmid,
 						 d.addr, d.size, d.order);
 			else
-				kvm_riscv_local_hfence_vvma_gva(vmid, d.addr,
+				kvm_riscv_local_hfence_vvma_gva(d.vmid, d.addr,
 								d.size, d.order);
 			break;
 		default:
@@ -336,10 +330,12 @@ void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
 				    gpa_t gpa, gpa_t gpsz,
 				    unsigned long order)
 {
+	struct kvm_vmid *v = &kvm->arch.vmid;
 	struct kvm_riscv_hfence data;
 
 	data.type = KVM_RISCV_HFENCE_GVMA_VMID_GPA;
 	data.asid = 0;
+	data.vmid = READ_ONCE(v->vmid);
 	data.addr = gpa;
 	data.size = gpsz;
 	data.order = order;
@@ -359,10 +355,12 @@ void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
 				    unsigned long gva, unsigned long gvsz,
 				    unsigned long order, unsigned long asid)
 {
+	struct kvm_vmid *v = &kvm->arch.vmid;
 	struct kvm_riscv_hfence data;
 
 	data.type = KVM_RISCV_HFENCE_VVMA_ASID_GVA;
 	data.asid = asid;
+	data.vmid = READ_ONCE(v->vmid);
 	data.addr = gva;
 	data.size = gvsz;
 	data.order = order;
@@ -374,10 +372,12 @@ void kvm_riscv_hfence_vvma_asid_all(struct kvm *kvm,
 				    unsigned long hbase, unsigned long hmask,
 				    unsigned long asid)
 {
+	struct kvm_vmid *v = &kvm->arch.vmid;
 	struct kvm_riscv_hfence data;
 
 	data.type = KVM_RISCV_HFENCE_VVMA_ASID_ALL;
 	data.asid = asid;
+	data.vmid = READ_ONCE(v->vmid);
 	data.addr = data.size = data.order = 0;
 	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
 			    KVM_REQ_HFENCE_VVMA_ALL, &data);
@@ -388,10 +388,12 @@ void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
 			       unsigned long gva, unsigned long gvsz,
 			       unsigned long order)
 {
+	struct kvm_vmid *v = &kvm->arch.vmid;
 	struct kvm_riscv_hfence data;
 
 	data.type = KVM_RISCV_HFENCE_VVMA_GVA;
 	data.asid = 0;
+	data.vmid = READ_ONCE(v->vmid);
 	data.addr = gva;
 	data.size = gvsz;
 	data.order = order;
-- 
2.43.0


