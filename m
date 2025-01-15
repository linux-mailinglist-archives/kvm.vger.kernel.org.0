Return-Path: <kvm+bounces-35593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55DFDA12AF2
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 19:33:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E461160FB5
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 18:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C321DB55D;
	Wed, 15 Jan 2025 18:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="2V5KCYPN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D171D9337
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 18:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736965867; cv=none; b=C29ZF2ROlpaafwbOfwoAxmlFOI/tY2wduBUVMgUxcLs1cU0sHM5PGX5BI4gLt8o2isaosTgb0rinqPSiXjKYHYUbUwUESVGP9ri8vEkwLOh9b7kYDXZW/ViepnPjV+apZRxVxUj8M3S+oayUTOCwHqI2T3yTzkuqOQK2IXDya28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736965867; c=relaxed/simple;
	bh=sczug/d3NLCUmVYBCwmtejNxbBiOhgpwE4/Zl4Ffiz4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=R7r7t8sPlyymFDtGXmNNbRhS2ylHzGBJxQq/uVCyKcXF2Rb1MbvzrfTa8D3KwoY9YMuBF4JpXy3jka1WDQGYej2hhVH0D2jQKhUBPQnQX5IpviaMW6P6b/EhhfYsBJsbQ1m7EYRENGYX/8Zu7Sc72LvIRchybHGhUY7J0Yqc4tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=2V5KCYPN; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-21680814d42so107278145ad.2
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 10:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736965864; x=1737570664; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BvcM8pFAUo8mVZOX2xDK8xE/vCf4z0GzB3iMLovGRHA=;
        b=2V5KCYPNp0U76KG2PIoShHSbNJPU9mEHsu81zC9a0t8P2xOrdUTFmWnZbyimrji4i9
         I6BYXR0nwb/xN9BfQ/SVQyMICn1SHWn3+/Pj5o0Q5Zmc0XOv5V6fnsmkSRqV/TciErPl
         ghrwHKm7RNFJVcEEYMfWGKiypIawwl5EhfprDN2NsExbghPh2o+/6rtNLkWLJBKLzNn6
         n0b4ruDqzuapGpAuhEcwas6a7Ue4XqDD/p2nhB5jUmJ8ej0ck25GD+PIvdCZddU2zysi
         blwZsDqKSH/OZMtWCW4h/IsGmpiGFvaEV5UzckN5WkSEFV7jQD2tajjZYlOrhdRpq8ub
         wJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736965864; x=1737570664;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BvcM8pFAUo8mVZOX2xDK8xE/vCf4z0GzB3iMLovGRHA=;
        b=Jue9guJt4oI1NptKY+ltdRpGvRXt5Ac7WhJOVS+vQSB5NCF/TucrxYP/kVlZCQRN7z
         nWpxLFSX0EyIAUDVciJxNlDRxWZJe1TX/RRVL9cQL0U4bMSQE4sx/+COqyF0VE8Etvb0
         cudgb202ENgD3HBWYPnSQJ4U2TxDYe928Amcd1ccg2SFpe6j93q+SJmD9KBVmGXX3Gq6
         81YFFOjC79qwbieY++ODGrMXANoFRgEXTs7MDOmA+lF+Tc1N3zzfG9k/etiYLtlcSi2c
         OG/3CVmFQRyD5NglkuY5LrH2OBzQVbw5hPErD31keC8KSXpivfqe84ZQMoczxFXJmWe3
         Oj1A==
X-Forwarded-Encrypted: i=1; AJvYcCXHxDVQvxyFF/9bHPREYuo4yIImLy8SEh/C3pBUTupDEJMLXdRm/etM8FqhEF8TbLQCb4k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBqk93ZJ56TCvuNsRnMDFj/2ouypHc3uuj6LBCm05yVZN0LuqR
	Tf0b0lPgYlPDMwwZuNObc2TraLW4f/JzQwe3HCc2rwge3kAY3xEk0fSglqgQHuQ=
X-Gm-Gg: ASbGncv6/GRmMwIzgaL2DjBumFzzO4oXc/0JIl7Oq+M2BlVmzeh8jwSmUnBLqVs03XL
	pL3AMkI7FFmsgQn0dHxClSHrKLh+u0sQZZ8Hy7M42uGkw84ywofnJAoiHZxHsdG0JzJIuXkP230
	O2jIogcRfDsdfiRKp3z8O7sxMiMoVPzmAWdQpvU0c7a/AqfT7jWs8FhbT01q5wBXk5YpaAmLvE6
	cLMt5bhbFDPnCIWxB4vfzie1NzXLwMklxKOzNlOVIlmbrr0enEnAeUz/lOXUkR5oDC4BA==
X-Google-Smtp-Source: AGHT+IGGezhqE5JLeDYHWhClhyZY1cGsFLOXrLsdEJgU2ElrVE/deMFlurFTVr/XKSOcI7Wz9ZYvgg==
X-Received: by 2002:a17:902:e5ce:b0:216:386e:dd8 with SMTP id d9443c01a7336-21a83f54a51mr373139315ad.17.1736965864561;
        Wed, 15 Jan 2025 10:31:04 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f219f0dsm85333195ad.139.2025.01.15.10.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 10:31:04 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 15 Jan 2025 10:30:48 -0800
Subject: [PATCH v2 8/9] RISC-V: KVM: Implement get event info function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250115-pmu_event_info-v2-8-84815b70383b@rivosinc.com>
References: <20250115-pmu_event_info-v2-0-84815b70383b@rivosinc.com>
In-Reply-To: <20250115-pmu_event_info-v2-0-84815b70383b@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

The new get_event_info funciton allows the guest to query the presence
of multiple events with single SBI call. Currently, the perf driver
in linux guest invokes it for all the standard SBI PMU events. Support
the SBI function implementation in KVM as well.

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
index ca23427edfaa..23dedf4c9313 100644
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
2.34.1


