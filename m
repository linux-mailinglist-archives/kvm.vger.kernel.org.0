Return-Path: <kvm+bounces-53063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D2B7B0D02B
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:17:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29AEB1AA5DDA
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 03:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9982629B8C6;
	Tue, 22 Jul 2025 03:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="d4XR+Knt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5A528FAAE
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 03:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753154135; cv=none; b=M1FZva84rFfn8b/UcduZGaW+ioONwly6Kc9E0oNsct5d8klodeQewqm7jxkhpcoA6k9an99VZafKKra0Yo6srlCzV8hvqyliiG7yxzn6Ao2msHxKLIiFo7tT1YHzMz7l1wwa/sjVdA2Kn5jSvSXZxyYYgi/kQF/rwJiVYzUw0/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753154135; c=relaxed/simple;
	bh=v6S2VfqVeBS/FwUN3sX2qA4Qo7NlLhImwGJEW5/a4E0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fDVCg2i7v8zhY1cWHYHx1/EjAgS8sKIOr1g5krpRMnZFZHLwG081XUPI9ZbD3fp3aHuqd0a4rCFyWbGqCgpJIkVnDRcYdvQbY63Ln+3Uz8WRGbcpEuUfWcR7nZWgQ5/D+ffCSlvgUrGNfncS05Rd+RCyjMwn/jxK+7Hi2OnufGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=d4XR+Knt; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b3aa2a0022cso5090322a12.1
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 20:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753154133; x=1753758933; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LNWjjR5K8ESMPCBOjPDxpC1mFayqfXlLuYgjg0J+sww=;
        b=d4XR+KntSRpcYufPzmPlupfpv3Z+VpHNkfjScMcXIqgxFSIgbGTW3zqnn5IcCYBIm1
         viXyr+5f3neVFNgKmDCEN3ZEInHbeeSHQD2eCyqT9zmPIx16f9pPLfmK5BvWmqm5vq1J
         ifT9dKI1WdR2UZrW+Y9X9TLM/EUghDocnzx2o9bl9+s9/VwPb4jJKZajsUSwwvhxOXmy
         64SX7KXTESBTa0QtkoYk2q/OBSJ/5kK22srHi56COTiyEpgqQg3CvXPjGyDDmcD+sYlW
         2N2abu7P3a+T1sC39F3iTWuryHXDEzr4gGofJ0tr6THbQ2ppxeB2rtci0W46+F7qIrAn
         U48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753154133; x=1753758933;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LNWjjR5K8ESMPCBOjPDxpC1mFayqfXlLuYgjg0J+sww=;
        b=qohGhoaY7m6fvvhvsKx0t53jExcqLXHgP9Qc4UqdmbW298SSRmnzKL+OMI+rPx9A0B
         hMwh5dYLPz1gLXTJfXynGby7NCXhn4DxhJOV6ojehufnFHmofdGBmczHeIW6cclef7Q0
         N2ARqK6Er/yTUbda3BeNgFie7aIbYW01G3hFYQJ8rFVMo+8MiniyZ47ofIq9o+wHsSOl
         bt2P372Pz3ZFfER5H/txwUbH1OGvc7C17K7Nj1UsYcGGxFHAi/uZJpWZxkz5OU20Oy9Y
         kNVdKe4tyHNpu8a6r352RygsXgdJFOmH/94WPGfAeAYLx0bL4tEVlzisLZrOEBzdnH84
         +8Rw==
X-Forwarded-Encrypted: i=1; AJvYcCV41rC/Y9C91K3y2wtVuD1+Ykdpk0KO6LnUJwj14UpcJbaUFWJ71+QjOrBjooJ99HjovIs=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywzj9kzGJGNMOQJWT9BFoaDjhJoa8PJGGkVRf7jhpVjQBmr76bj
	zdy7zHVFhy+k3UWXLCs4jmfYoVAsxe155fQXKWwOlg28LN3nDG+nPmSTD4kQs1Ss+O0=
X-Gm-Gg: ASbGnctd0fdIuQxWZY5nEACuTD3c4btKh9iaaG2tOHa9K3IdhjZWbxOSs2ddRG+iJtO
	derKs0Ss6SntLTeTKdeResf1lQiPK1UG3RyW9egU+4pPoPymB8h2gyDK3l35BkdH6VK4Y5PpTG+
	98CVHRg/2JBol/AbRr5w64EFQNv0JlJUoCGHyyFp8aVEGU+3PGyZXcka4vS8z3z7ERvYIGHA7Q4
	/nX+5Ax6T/mC6rmLYzjb5PFaxXfhjJxOCLLQ3FRUd330rmT9i8SLkOhrN/OADUjPyTyXXLeYF7d
	0vGJwrzBPiChfVZasmYuEfWFD/lSkO75l4ReO8gfkQyvOaA3JJav9Vkw4vf1vILUrIld+jmzF50
	8RkFUlyLx2B+VOLDbzXj0jFPOKghGcietG4A=
X-Google-Smtp-Source: AGHT+IFlRcqyUqzUESij9IbKtqtTK+LGpo7DYk//VPdyGweTn0oqQsSsmoM0vc3xGcaHFEJntaSgwQ==
X-Received: by 2002:a17:90b:2650:b0:311:baa0:89ce with SMTP id 98e67ed59e1d1-31c9f3fc33bmr32891641a91.12.1753154133418;
        Mon, 21 Jul 2025 20:15:33 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2feac065sm6027612a12.33.2025.07.21.20.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 20:15:33 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 21 Jul 2025 20:15:24 -0700
Subject: [PATCH v4 8/9] RISC-V: KVM: Implement get event info function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-pmu_event_info-v4-8-ac76758a4269@rivosinc.com>
References: <20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com>
In-Reply-To: <20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

The new get_event_info funciton allows the guest to query the presence
of multiple events with single SBI call. Currently, the perf driver
in linux guest invokes it for all the standard SBI PMU events. Support
the SBI function implementation in KVM as well.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_pmu.h |  3 ++
 arch/riscv/kvm/vcpu_pmu.c             | 66 +++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_sbi_pmu.c         |  3 ++
 3 files changed, 72 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index 1d85b6617508..9a930afc8f57 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -98,6 +98,9 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
 int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long saddr_low,
 				      unsigned long saddr_high, unsigned long flags,
 				      struct kvm_vcpu_sbi_return *retdata);
+int kvm_riscv_vcpu_pmu_event_info(struct kvm_vcpu *vcpu, unsigned long saddr_low,
+				  unsigned long saddr_high, unsigned long num_events,
+				  unsigned long flags, struct kvm_vcpu_sbi_return *retdata);
 void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
 
diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 163bd4403fd0..70a6bdfc42f5 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -453,6 +453,72 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long s
 	return 0;
 }
 
+int kvm_riscv_vcpu_pmu_event_info(struct kvm_vcpu *vcpu, unsigned long saddr_low,
+				  unsigned long saddr_high, unsigned long num_events,
+				  unsigned long flags, struct kvm_vcpu_sbi_return *retdata)
+{
+	struct riscv_pmu_event_info *einfo;
+	int shmem_size = num_events * sizeof(*einfo);
+	gpa_t shmem;
+	u32 eidx, etype;
+	u64 econfig;
+	int ret;
+
+	if (flags != 0 || (saddr_low & (SZ_16 - 1))) {
+		ret = SBI_ERR_INVALID_PARAM;
+		goto out;
+	}
+
+	shmem = saddr_low;
+	if (saddr_high != 0) {
+		if (IS_ENABLED(CONFIG_32BIT)) {
+			shmem |= ((gpa_t)saddr_high << 32);
+		} else {
+			ret = SBI_ERR_INVALID_ADDRESS;
+			goto out;
+		}
+	}
+
+	if (kvm_vcpu_validate_gpa_range(vcpu, shmem, shmem_size, true)) {
+		ret = SBI_ERR_INVALID_ADDRESS;
+		goto out;
+	}
+
+	einfo = kzalloc(shmem_size, GFP_KERNEL);
+	if (!einfo)
+		return -ENOMEM;
+
+	ret = kvm_vcpu_read_guest(vcpu, shmem, einfo, shmem_size);
+	if (ret) {
+		ret = SBI_ERR_FAILURE;
+		goto free_mem;
+	}
+
+	for (int i = 0; i < num_events; i++) {
+		eidx = einfo[i].event_idx;
+		etype = kvm_pmu_get_perf_event_type(eidx);
+		econfig = kvm_pmu_get_perf_event_config(eidx, einfo[i].event_data);
+		ret = riscv_pmu_get_event_info(etype, econfig, NULL);
+		if (ret > 0)
+			einfo[i].output = 1;
+		else
+			einfo[i].output = 0;
+	}
+
+	kvm_vcpu_write_guest(vcpu, shmem, einfo, shmem_size);
+	if (ret) {
+		ret = SBI_ERR_FAILURE;
+		goto free_mem;
+	}
+
+free_mem:
+	kfree(einfo);
+out:
+	retdata->err_val = ret;
+
+	return 0;
+}
+
 int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu,
 				struct kvm_vcpu_sbi_return *retdata)
 {
diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
index e4be34e03e83..a020d979d179 100644
--- a/arch/riscv/kvm/vcpu_sbi_pmu.c
+++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
@@ -73,6 +73,9 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case SBI_EXT_PMU_SNAPSHOT_SET_SHMEM:
 		ret = kvm_riscv_vcpu_pmu_snapshot_set_shmem(vcpu, cp->a0, cp->a1, cp->a2, retdata);
 		break;
+	case SBI_EXT_PMU_EVENT_GET_INFO:
+		ret = kvm_riscv_vcpu_pmu_event_info(vcpu, cp->a0, cp->a1, cp->a2, cp->a3, retdata);
+		break;
 	default:
 		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
 	}

-- 
2.43.0


