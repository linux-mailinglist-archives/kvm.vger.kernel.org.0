Return-Path: <kvm+bounces-48477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C405ACE9EF
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:16:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1FE17A2B5D
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5B98207DF3;
	Thu,  5 Jun 2025 06:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Kh1ikOn/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843E92063F0
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 06:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104127; cv=none; b=LGUJ0smlN/TQlFVOx06ftkKLfQ91A2hLgEbo7nU0nSRLMuEykJdG/PSyFdRgpCsnPzCAF7XKlA9Ah7wbUitXmX0EGS1y2bzO3ZfifSyL4siS2K5wBX0z2ADrb9MrUWuQsgrPx+27b/15TY+Qaxor+QKYb0DgLWvUYyqiUExp3Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104127; c=relaxed/simple;
	bh=3XxQ3kIy1hzCopjlDYHh4FepN2dVMrVYgeQ9xSMlP70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1XS0TJ5IfrOyShhoS8U8lg/28/ThG+BYY3Olt/iJ5CQDRn98qkOmnOJcQ4HTPSfeOI2aGl+g2YHkuLT5bCmcrnkTUTz9rVpUzOjvUt5SUzNw2HC51ovqUUNzWEwUTb4qtPdjV+gbdTB70FwHycLECuK0Fa4l1pQVs0TWaLGiuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Kh1ikOn/; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-879d2e419b9so504841a12.2
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 23:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749104125; x=1749708925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g9lKrNhC1LriCt2AmMWJPIsLGEeoSE3sCtMNzfw5vMI=;
        b=Kh1ikOn/hW8L9YIHiJvRtjdhjSQh9lMYpDWcwXhmeG/VXq3rxx9ZVOItyxXXvioH+1
         CDQI9YX4aSmB/qQGIK+9avmSnNbuJst5515VrS7UjLZpvUteC+uUXvC9Cp5svza5nA3s
         LCJq1yjW7H9deisWs0faIdWhaZMB/CSTtLixrLOdnsCPoHpkU/aa/ieTpI1HH102+6gJ
         /mw6Ot7N8Ym6B3d5NHbkJP68buk98YRCHFQbYc9TUulDQlNbIJFFPAFFQUG8NZOJlQUf
         Na7zng/e5mndlq+RPUDpj19m7JhCd6VCooD1vsENo+js0cDe4WD0pZChImVFQMCWeQTd
         +HDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749104125; x=1749708925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g9lKrNhC1LriCt2AmMWJPIsLGEeoSE3sCtMNzfw5vMI=;
        b=hb2caiifYRS1ZG+syxB7ShJqmSlRSR6ia8x53LXB3BKW3WSGyGSM1Dt+Ixyrm4P1a0
         /1mF3F8imNpUHlnknZW2kMaPK4DfMVENmaBdNqctN21RqW59iM/xUXGgrTB6+gZ17rN6
         7y5CwtfyMTI1XdGOtj9uJjhB9+vk670M3DQPdI0ZIRh8DQTbQWd4uJcd+lPZcAEwWGDR
         qwlY+JHpCt6ASD9M4EBCn+7sEo0zVCFf5fCIuB6qlX9F2XShtd8TJmMA6Y20RwmVPg3n
         Twzv5LSsVqp4LBBd9AXzJ6wEwLHTMi2HNHTXC+ccfObkFjrU9GK3iauNsSeJNeXRgDX4
         UfKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxzffa2Oab4IdZw90HkJRfCFkcjJ8+7Rww2jn6O4vQ+eMPIGACMEaEejGtP5CtPM+5xpk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuAZZm7/m4WAilq/H/eQLmc3O+SO9thuwhs83SN5bGHFlZysTt
	3JGXc6DWue5cg3PCjh3Uh8od2WgAOSTi1XZwtbwNIkorGTZwHYgJdbhfOQdUr+UgFE4=
X-Gm-Gg: ASbGnctOHHJzQJ550RTW053ZoiAdrjV4flYEpys3GHtOAzWXpfh/LPiEZ6Zqk/5dvtd
	a7jhsN5rgVQzf+YRwDKcsUf2nrzJwD1JKNk2DQtDDU//7VCzF0d8EuPmQVjHlbIyt/HX+Nvh8NU
	DBiXZcAym0FpCrroOdJ5ixx/mIpS1PusyHjBt0RmY10Cukuzi/zNUcDuHYjQ4ESFpXL+nzauFAa
	Qt9BvwryLGr8TZ27z/h1NtZ479m8sIKVTzmD1rOO3HZVQSdY3D2ZSKFjj1ibvaDjkulJ+hM6rUX
	cm9xjgjzZl97flKhXEq7d13YqHhWUzX938FOEwP2rgXW4oRupqkdSHTBAxqpOkO8dLe+kG9bsTV
	NoJA8MTGIjkjmjP87
X-Google-Smtp-Source: AGHT+IE/5a5zgQx+kk8SDVCqYIhLKXbR1w/+yPtxXvmHoTXBZp+TCtx5+O8hPK0X2ObUlWcFQP661w==
X-Received: by 2002:a17:90b:1d84:b0:312:1508:fb4d with SMTP id 98e67ed59e1d1-3130ce9fecfmr9750546a91.33.1749104124548;
        Wed, 04 Jun 2025 23:15:24 -0700 (PDT)
Received: from localhost.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3132c0bedc7sm716026a91.49.2025.06.04.23.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 23:15:23 -0700 (PDT)
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
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 05/13] RISC-V: KVM: Rename and move kvm_riscv_local_tlb_sanitize()
Date: Thu,  5 Jun 2025 11:44:50 +0530
Message-ID: <20250605061458.196003-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250605061458.196003-1-apatel@ventanamicro.com>
References: <20250605061458.196003-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kvm_riscv_local_tlb_sanitize() deals with sanitizing current
VMID related TLB mappings when a VCPU is moved from one host CPU
to another.

Let's move kvm_riscv_local_tlb_sanitize() to VMID management
sources and rename it to kvm_riscv_gstage_vmid_sanitize().

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h |  3 +--
 arch/riscv/kvm/tlb.c              | 23 -----------------------
 arch/riscv/kvm/vcpu.c             |  4 ++--
 arch/riscv/kvm/vmid.c             | 23 +++++++++++++++++++++++
 4 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 85cfebc32e4c..134adc30af52 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -327,8 +327,6 @@ void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
 				     unsigned long order);
 void kvm_riscv_local_hfence_vvma_all(unsigned long vmid);
 
-void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu);
-
 void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu);
 void kvm_riscv_hfence_gvma_vmid_all_process(struct kvm_vcpu *vcpu);
 void kvm_riscv_hfence_vvma_all_process(struct kvm_vcpu *vcpu);
@@ -376,6 +374,7 @@ unsigned long kvm_riscv_gstage_vmid_bits(void);
 int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
 bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
 void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu);
+void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu);
 
 int kvm_riscv_setup_default_irq_routing(struct kvm *kvm, u32 lines);
 
diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
index 2f91ea5f8493..b3461bfd9756 100644
--- a/arch/riscv/kvm/tlb.c
+++ b/arch/riscv/kvm/tlb.c
@@ -156,29 +156,6 @@ void kvm_riscv_local_hfence_vvma_all(unsigned long vmid)
 	csr_write(CSR_HGATP, hgatp);
 }
 
-void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
-{
-	unsigned long vmid;
-
-	if (!kvm_riscv_gstage_vmid_bits() ||
-	    vcpu->arch.last_exit_cpu == vcpu->cpu)
-		return;
-
-	/*
-	 * On RISC-V platforms with hardware VMID support, we share same
-	 * VMID for all VCPUs of a particular Guest/VM. This means we might
-	 * have stale G-stage TLB entries on the current Host CPU due to
-	 * some other VCPU of the same Guest which ran previously on the
-	 * current Host CPU.
-	 *
-	 * To cleanup stale TLB entries, we simply flush all G-stage TLB
-	 * entries by VMID whenever underlying Host CPU changes for a VCPU.
-	 */
-
-	vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
-	kvm_riscv_local_hfence_gvma_vmid_all(vmid);
-}
-
 void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu)
 {
 	kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_RCVD);
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index f98a1894d55b..cc7d00bcf345 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -961,12 +961,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		}
 
 		/*
-		 * Cleanup stale TLB enteries
+		 * Sanitize VMID mappings cached (TLB) on current CPU
 		 *
 		 * Note: This should be done after G-stage VMID has been
 		 * updated using kvm_riscv_gstage_vmid_ver_changed()
 		 */
-		kvm_riscv_local_tlb_sanitize(vcpu);
+		kvm_riscv_gstage_vmid_sanitize(vcpu);
 
 		trace_kvm_entry(vcpu);
 
diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index ddc98714ce8e..92c01255f86f 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -122,3 +122,26 @@ void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu)
 	kvm_for_each_vcpu(i, v, vcpu->kvm)
 		kvm_make_request(KVM_REQ_UPDATE_HGATP, v);
 }
+
+void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
+{
+	unsigned long vmid;
+
+	if (!kvm_riscv_gstage_vmid_bits() ||
+	    vcpu->arch.last_exit_cpu == vcpu->cpu)
+		return;
+
+	/*
+	 * On RISC-V platforms with hardware VMID support, we share same
+	 * VMID for all VCPUs of a particular Guest/VM. This means we might
+	 * have stale G-stage TLB entries on the current Host CPU due to
+	 * some other VCPU of the same Guest which ran previously on the
+	 * current Host CPU.
+	 *
+	 * To cleanup stale TLB entries, we simply flush all G-stage TLB
+	 * entries by VMID whenever underlying Host CPU changes for a VCPU.
+	 */
+
+	vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
+	kvm_riscv_local_hfence_gvma_vmid_all(vmid);
+}
-- 
2.43.0


