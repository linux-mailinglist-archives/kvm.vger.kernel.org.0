Return-Path: <kvm+bounces-21952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88C0D937A82
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F6EA2853CA
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F9D514A0B6;
	Fri, 19 Jul 2024 16:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="PnYQIHlL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F385914A09C
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721405412; cv=none; b=qeWByTFvz+9qPK7DczCcSvZcjy4zOP/E+d5t41DlQjZzpDykvoRFqIbMIQW564iSS7Zc+uM1JQwTAMS42plDYqVa+QsWsOOj5yEERj9eEUJYk3v/nhBEvQm5s9wfpuiniBD7jIiePznzhYEYE6i9IU7Elpg/b3zvxWn0yNk1IGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721405412; c=relaxed/simple;
	bh=B+1xZ9fR6tSoT6mL74KtYbAEPB8W5QhktsEz3iQNGNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lKNypDEywW4hKp0OIQf93wwrIv6X2X8OQYA7tyXEUP/CcRuFxW+zDnbstAVG3JBsYwttUhHe5xEtES+QgPcZtUP4c7bzb8Bw/qrgg4tVTMIKE7WaTVMne6+Xp/4rPS8VxV9+G25eJYqoqB4iO8hSYkXbuSQlGl8R4kqSDxXOZtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=PnYQIHlL; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1fc5296e214so17589345ad.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 09:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1721405410; x=1722010210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qyi9hrGfVRmOD1WpD5vxj3JpORinviXBA5VC8Qc3Jso=;
        b=PnYQIHlLcEXdgivrQevf6GbVBv4/LmkgKzC+4tOQ0qO8qQ4XdhJZ32iQSmBvrmwpLq
         5v0q8yu30aS6nGXRFutEQnQKHExmsl7E6fBrhWw5ctrRFdGq/hY2JOlw3KxL6U63Hy8W
         URi4vc4tA8oEfzfq5PXzBtobGUv4SBrD0FYqZrKw6gCuNsorOwELfyt7KFZHs9do7eS4
         /qobMZ8Lkl/kvnteYPugdpeVQTLutalfRZRyM+/+VNkGF8EL2MXQriYKaq9szk4pHSBp
         p07aPww3Nx92eGHm8s85RtF9OGiZ4u/bznWGJbw4k8J8WtBDJMYSR9okhbzfUgJ6fh6H
         /tMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721405410; x=1722010210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qyi9hrGfVRmOD1WpD5vxj3JpORinviXBA5VC8Qc3Jso=;
        b=CryPdr4iV5s749Ziqoswge6fz0dTgCvDn2D0d9Tyco9a602frDZglVaf3Kn4Jifr65
         OyDk1k/POs0wXymdtAyPKqHMbDVtUQsB7nC16FT8s+El6YZu4dJjOozoiS/P+mMniZAI
         ftHbxyRWaKH+FpQXmG0wnpMfIW+hJqBdnmUghmolgcqelkmLUJ2KIRIKBEe/8q7nJh5/
         lTziu+ifV/35EOMuCPbyLu+9zl0BCWAyRiqnnzxXyLadAtPaTp8lk2yXBGzhEB0d1v8f
         KJSTx/kEhmWWCadt/B7djaM3F1LXKslMBdMKybLjLUyeyi4q1PDRu73A7xiHpsvosq0g
         g9TQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvxHm0VhkILmd590TuuSW+hCrdAeGeD8aG+mEMXUK+xqUb0Wi7MnoK4RtuVvhQHT31FyqLb3FuBkG2nAZzjGoUYZmQ
X-Gm-Message-State: AOJu0YzxFgP9l80OMuZqiz2CsgpvcuWznJsNXqh2tXuuoPmYlvYC1nI4
	XQkLrqo+YK8Akhc18R3XeGK65qL3jtidJf1uWkhBIm6pR8KRArwg9fbgzVH6Q3nKOVTd6b81v0v
	5
X-Google-Smtp-Source: AGHT+IFxxJQJMT1yPV9iBgyfcleth8inhyBwlA3lhunIDQ81CpWWGH98IspVcY6bKB19yLGgqpEUJg==
X-Received: by 2002:a17:902:ecc5:b0:1fb:7978:6b1 with SMTP id d9443c01a7336-1fd74578fb2mr4074945ad.31.1721405410214;
        Fri, 19 Jul 2024 09:10:10 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f28f518sm6632615ad.69.2024.07.19.09.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 09:10:09 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>
Cc: Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 13/13] RISC-V: KVM: Use NACL HFENCEs for KVM request based HFENCEs
Date: Fri, 19 Jul 2024 21:39:13 +0530
Message-Id: <20240719160913.342027-14-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240719160913.342027-1-apatel@ventanamicro.com>
References: <20240719160913.342027-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running under some other hypervisor, use SBI NACL based HFENCEs
for TLB shoot-down via KVM requests. This makes HFENCEs faster whenever
SBI nested acceleration is available.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/tlb.c | 57 +++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 17 deletions(-)

diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
index 23c0e82b5103..2f91ea5f8493 100644
--- a/arch/riscv/kvm/tlb.c
+++ b/arch/riscv/kvm/tlb.c
@@ -14,6 +14,7 @@
 #include <asm/csr.h>
 #include <asm/cpufeature.h>
 #include <asm/insn-def.h>
+#include <asm/kvm_nacl.h>
 
 #define has_svinval()	riscv_has_extension_unlikely(RISCV_ISA_EXT_SVINVAL)
 
@@ -186,18 +187,24 @@ void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu)
 
 void kvm_riscv_hfence_gvma_vmid_all_process(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vmid *vmid;
+	struct kvm_vmid *v = &vcpu->kvm->arch.vmid;
+	unsigned long vmid = READ_ONCE(v->vmid);
 
-	vmid = &vcpu->kvm->arch.vmid;
-	kvm_riscv_local_hfence_gvma_vmid_all(READ_ONCE(vmid->vmid));
+	if (kvm_riscv_nacl_available())
+		nacl_hfence_gvma_vmid_all(nacl_shmem(), vmid);
+	else
+		kvm_riscv_local_hfence_gvma_vmid_all(vmid);
 }
 
 void kvm_riscv_hfence_vvma_all_process(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vmid *vmid;
+	struct kvm_vmid *v = &vcpu->kvm->arch.vmid;
+	unsigned long vmid = READ_ONCE(v->vmid);
 
-	vmid = &vcpu->kvm->arch.vmid;
-	kvm_riscv_local_hfence_vvma_all(READ_ONCE(vmid->vmid));
+	if (kvm_riscv_nacl_available())
+		nacl_hfence_vvma_all(nacl_shmem(), vmid);
+	else
+		kvm_riscv_local_hfence_vvma_all(vmid);
 }
 
 static bool vcpu_hfence_dequeue(struct kvm_vcpu *vcpu,
@@ -251,6 +258,7 @@ static bool vcpu_hfence_enqueue(struct kvm_vcpu *vcpu,
 
 void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu)
 {
+	unsigned long vmid;
 	struct kvm_riscv_hfence d = { 0 };
 	struct kvm_vmid *v = &vcpu->kvm->arch.vmid;
 
@@ -259,26 +267,41 @@ void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu)
 		case KVM_RISCV_HFENCE_UNKNOWN:
 			break;
 		case KVM_RISCV_HFENCE_GVMA_VMID_GPA:
-			kvm_riscv_local_hfence_gvma_vmid_gpa(
-						READ_ONCE(v->vmid),
-						d.addr, d.size, d.order);
+			vmid = READ_ONCE(v->vmid);
+			if (kvm_riscv_nacl_available())
+				nacl_hfence_gvma_vmid(nacl_shmem(), vmid,
+						      d.addr, d.size, d.order);
+			else
+				kvm_riscv_local_hfence_gvma_vmid_gpa(vmid, d.addr,
+								     d.size, d.order);
 			break;
 		case KVM_RISCV_HFENCE_VVMA_ASID_GVA:
 			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
-			kvm_riscv_local_hfence_vvma_asid_gva(
-						READ_ONCE(v->vmid), d.asid,
-						d.addr, d.size, d.order);
+			vmid = READ_ONCE(v->vmid);
+			if (kvm_riscv_nacl_available())
+				nacl_hfence_vvma_asid(nacl_shmem(), vmid, d.asid,
+						      d.addr, d.size, d.order);
+			else
+				kvm_riscv_local_hfence_vvma_asid_gva(vmid, d.asid, d.addr,
+								     d.size, d.order);
 			break;
 		case KVM_RISCV_HFENCE_VVMA_ASID_ALL:
 			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
-			kvm_riscv_local_hfence_vvma_asid_all(
-						READ_ONCE(v->vmid), d.asid);
+			vmid = READ_ONCE(v->vmid);
+			if (kvm_riscv_nacl_available())
+				nacl_hfence_vvma_asid_all(nacl_shmem(), vmid, d.asid);
+			else
+				kvm_riscv_local_hfence_vvma_asid_all(vmid, d.asid);
 			break;
 		case KVM_RISCV_HFENCE_VVMA_GVA:
 			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_RCVD);
-			kvm_riscv_local_hfence_vvma_gva(
-						READ_ONCE(v->vmid),
-						d.addr, d.size, d.order);
+			vmid = READ_ONCE(v->vmid);
+			if (kvm_riscv_nacl_available())
+				nacl_hfence_vvma(nacl_shmem(), vmid,
+						 d.addr, d.size, d.order);
+			else
+				kvm_riscv_local_hfence_vvma_gva(vmid, d.addr,
+								d.size, d.order);
 			break;
 		default:
 			break;
-- 
2.34.1


