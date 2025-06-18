Return-Path: <kvm+bounces-49851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5435BADEA54
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:37:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9B1E1750B1
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5BAC2E3AF2;
	Wed, 18 Jun 2025 11:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="TWtx+WH1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816A22DE1FE
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246562; cv=none; b=BTABw093XdfgN2875HFnDlWoC1eyMSvtrWAiSET2/BtL7uDYDrXyJ7Xovnexu6OYTiiZ0YsHgG6QRMNYK1uZFN4YW4zF0OBhmH8e5ram6JrAKvzU9t6Hkc8oEdvvZm7uZOHO+GYPM4rkqDOO17/p/9k/H5WWWlatt5I/4Sm3u2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246562; c=relaxed/simple;
	bh=U71gyvnkFRTjwDI8pxtkBdAEgTm+G+VjYBDnQo+6/v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGYjHgVpJ5D2KgiZEshU2koSfP8Mc0AOPjG76bhhws1QNPrO7yplmo/ePCr4oeL7ubfAgCWUw9HqbG0iTX67515gsYBJDj69jsN0RKtFSuDRAZiCbSRKcYMF/aBad5FutO/tI5lO+38OuPPza9SoeTxKfx7QHGFkVxjYY9BbRAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=TWtx+WH1; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2363e973db1so4871265ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750246560; x=1750851360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3W7Bv8eoCvTNzkNO4nvyVAxgoupNAJKpC3g9nF1nD78=;
        b=TWtx+WH14juYstivK53he26LbWHVaqVb6KWwe2s88xmx+0MJtXdd/61fGIlIvS6d2d
         wSrKoEqfHlc6Mmy3S3badVu1NtUlCyCvNiOrcQ179MXpHI+oWDKBf196p5dGnv8iYuJx
         SbZ3pd+TSeAygYWd6lHZ7LN86cFwulUzGyzUvaRXZcaiaGy2E8z4+8aw3qr/rLQN9w5w
         uxVEi8pW6f2UlQojzcrBV/xc4sv7cgIGTQr1fXVCQlwLr1KZNYdmUz1JyoOgGN792OC6
         z2ePngoPrDLZgo8M/+qgM4QisL09RKRL132Y5jnUW4ReKCo2RIzOcfNr6VHVlY3/ZKrl
         SuvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750246560; x=1750851360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3W7Bv8eoCvTNzkNO4nvyVAxgoupNAJKpC3g9nF1nD78=;
        b=WTYwF/I5e6ysst10YYoH/bJmuj5uexucStNdGhZRrbBAaTuBUyXlCFs9iNT2Z2kKZT
         7bCaYKZXGFF17qTLc+TF+B3tLCIDLZCee8iKHPe9anHOxn5Bu2mN9ie7I8wlprFVCDqr
         mUmNxc/bDrxSFbi4M+stVXELuTZBVthNX8NLpf+CeUYVyyD3dCLyHKCwE9P1n0dGwlkb
         3gDh1EVEFYFkHiz3Mt02b8LTFYtDm3hnIa48cSWqaEFpUrPamahNkn96P+2eXDw1G2G4
         G0DrJMTeL34xKWB0txn1CVYdlyqTTv6XAACp63ul3OnFLAmbqgy1Vv5/GR4b+fD/Axfs
         2xJA==
X-Forwarded-Encrypted: i=1; AJvYcCWdaJ2RqsBxfpzWvYc0ECM5zfNhDpLZWREDcp6WssID+amQ5pywlld7gGUWx57YTxG0f/Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb2N9Wn3cuLnw/MQXbCgQyMD3yv5prmnknRD+H4vAX/aco+ujz
	5WEv6yC9V4fIliONizPQDCXBJ4Sa8+mNxEj2G4SIhrfr88kIowTXB9/7WYnjfYoTWpQ=
X-Gm-Gg: ASbGncuzfj9aVmun27CQ5IdMuNWHZ7/oCK3vlDWh0ZVQlqG5s7GqjwGF01r9jXqDnC3
	TdAo2DTa+tTLe7CRe2qLuNLTqeshtj5MyLm5EasfgNrJw3OZTtFbxDbET0x81AQPElp0vKUABpZ
	xj5j5DLn82zSNprdKgpTepTh3jIRSK+KatwDuBcFQzOcY2Gx+h6tn4GGzWFNsoGMyKVXeugSM8Z
	ITfd9OWFt0emWWCNvUH14SsJSWLS5MYwQ17cw6cYItxyZ0cJuT3FOuazk7HKZdLikZGL70yMPlj
	WGgN8AK2FHceskjqL5oU7bhAeYKg/mhqIKet2sCJs+Qcy/26dqa26o3T95+HQG3h3QyvPkGINvu
	cr5UwolF4ygQ0EuTp8Q==
X-Google-Smtp-Source: AGHT+IG6YfMEu9lcXrd2qiAepReJXbM/lA1ChWg4x51TipxipgSLPLblK8ZINKPH1NwWxJ/vO5o07w==
X-Received: by 2002:a17:902:c94e:b0:231:9817:6ec1 with SMTP id d9443c01a7336-237c20e022cmr32723525ad.17.1750246559668;
        Wed, 18 Jun 2025 04:35:59 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237c57c63efsm9112475ad.172.2025.06.18.04.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 04:35:59 -0700 (PDT)
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
	Atish Patra <atishp@rivosinc.com>,
	Nutty Liu <liujingqi@lanxincomputing.com>
Subject: [PATCH v3 03/12] RISC-V: KVM: Rename and move kvm_riscv_local_tlb_sanitize()
Date: Wed, 18 Jun 2025 17:05:23 +0530
Message-ID: <20250618113532.471448-4-apatel@ventanamicro.com>
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

The kvm_riscv_local_tlb_sanitize() deals with sanitizing current
VMID related TLB mappings when a VCPU is moved from one host CPU
to another.

Let's move kvm_riscv_local_tlb_sanitize() to VMID management
sources and rename it to kvm_riscv_gstage_vmid_sanitize().

Reviewed-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Nutty Liu<liujingqi@lanxincomputing.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h |  3 +--
 arch/riscv/kvm/tlb.c              | 23 -----------------------
 arch/riscv/kvm/vcpu.c             |  4 ++--
 arch/riscv/kvm/vmid.c             | 23 +++++++++++++++++++++++
 4 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 9a617bf5363d..8aa705ac75a5 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -331,8 +331,6 @@ void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
 				     unsigned long order);
 void kvm_riscv_local_hfence_vvma_all(unsigned long vmid);
 
-void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu);
-
 void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu);
 void kvm_riscv_hfence_gvma_vmid_all_process(struct kvm_vcpu *vcpu);
 void kvm_riscv_hfence_vvma_all_process(struct kvm_vcpu *vcpu);
@@ -380,6 +378,7 @@ unsigned long kvm_riscv_gstage_vmid_bits(void);
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
index f9fb3dbbe0c3..a2dd4161e5a4 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -962,12 +962,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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


