Return-Path: <kvm+bounces-47407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69F38AC1447
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 21:07:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92DCBA4205A
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 19:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2762BD5A7;
	Thu, 22 May 2025 19:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="gJgCx5uw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B1E19CC1C
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 19:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747940637; cv=none; b=bHlF8CUlVj/VLe5eFmD5yUMO9ibNgdeJgcgRQMr2CJXCfOeBC3A/vwldkWi8f+Ezm/xKDdOfFgXPFM+4bKTeqXPJk9tRvDHAFLaC1WfaXa6nqmlM1gLBNakBi4WQ/xZSanf4qqEGy3Mc6JHHAPSudrNph7pexTKWDQgn/to12ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747940637; c=relaxed/simple;
	bh=UtTdmWX6U4vkBHMHrjueL7kq6ik9nHTWYO5el8M7IAE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=otoOytZR4MlC5hLqbQLUPmN7SpK9yl5/CiAMSekVIN4N6sGQKsoZ91G3DM/eUxl4wsRwv7Pm4KTyZ0nYaxwZemss7H2ovR2gVC1swnLLFMYbjq2NWQvAs1lCNGYbBgc4onRScnXqLls0lCsHrC1yT+HM/6zn5UlNrkI4DUKSWDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=gJgCx5uw; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b200047a6a5so198402a12.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 12:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747940633; x=1748545433; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DF8qwdvQiSR8ZsqVN4u28RN14jUMJY3Pi0vpFa2D75A=;
        b=gJgCx5uwiIEOFpuFRJaDH8ctpfF6q2d3WdGgGIct8A+LC4q2W8P/qj4qUQex3YjOPm
         cygfnlZpERJpy0UY3v9wsnB/dY5iZczltJw3exry2nvzAnHEzawwciPRhwwOJ4OmRi4w
         z0Pw6BpdeeqbrgZtlroWYbXvsz/d+2qsz/8XQP1EFNFkOhtopfm1k8SFIBJL+QFGIiTz
         kmLRF1nwwZ5pE0uL6Rz/R0Ogi4Dw7yn8ByL/81jyyru2Cnq2W9FeHGRGLhGyAIpdFqGK
         bx82k4SG9+ivx6jzm/SJmewZbUOjL+HLE7j1hEvsB8j5P8KWa1rYV6GjD8ZXngsr0rIW
         04GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747940633; x=1748545433;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DF8qwdvQiSR8ZsqVN4u28RN14jUMJY3Pi0vpFa2D75A=;
        b=gBBY5y6Dqa1soNg0209qsxvvcAOK/CeH0oqVjE6Kaffvs/TlXw/2qsCn46WAApWNYY
         T6MTZ9Z3tuKxq82yYPynSIvV53RBXhylJa3jZ/VM6xOzaDEG4iNUBxwJ//cz3qBr2tDW
         OaR83UozWcBFOBv8zGuHftq8r3lWpgvzboFQQQuDudoFL0WgawHHlOLUj6Wg/+80jePq
         3VocXXUg7MSo+QGmIWkpzUWnEvELnEA3ypSoOWXmuqQslXpVzKNjnscdUN+VXLjVyqpE
         qyiC8iBBEN3vQm9GeQwyiM26Nb1dZ0B5OH/1wx+DPj+Ap6b+4vnAgR2EAKO8GO9+Atow
         A3oA==
X-Forwarded-Encrypted: i=1; AJvYcCVf/Vps95DWR8FrSHqN9XqH+8AAPeBb/T2rrfRaF1Ka1OscY0N1P30Z3U09RQqEXAFrrg4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCOVHFR5NL12Q1/bQJ5iuYjq6rg0mcl2T6ymU+SKk7P+OVtWsI
	+bGaLZmwca27DvghfxlWon9raqoumfkmYsGn9lRS0/044KZjnDcWy+ST5C+Uo0i7LhA=
X-Gm-Gg: ASbGncvniyuXNdhGzkj5XH0/7rVPusGEsi5sQEkd6M88IcWllh/bYfUJZZKnISQXYtp
	dHCig6nMi/js27utKtvKgu9cg8RnjNE4uMWNxp7JO+U9tt0BNy4ajfEHJMoepUmsiqX3UF/mlUq
	i+tITWMfK2yptmmut4I9jSEwllZHQV3xkYIZI+C7Q5dNTy3Pj2rw8DYyqxgYLoaj/muXTJqCWMT
	cjcxBwP9aQlPSlbT0LcuP9IJeYtyQy+0WMNChNl/FgW6M9KpxxV15bENMaA/T89OUXQr3SvNhHf
	wjN+MTMljpgvdl2uHAm4fF12AFyRwbvwaALqY98Ko5sVkFHSiEHIDFVqpt+z96RO
X-Google-Smtp-Source: AGHT+IFOp5NbQAetfcmDIrzFN/H7GeRjVktpIXFM9JpmrYmqufWq4+kFSWRLQINNJ6B0dpiY8ak3gg==
X-Received: by 2002:a17:902:e78b:b0:231:7fbc:19f3 with SMTP id d9443c01a7336-233f0680998mr8028135ad.12.1747940633282;
        Thu, 22 May 2025 12:03:53 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e9736esm111879155ad.149.2025.05.22.12.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 12:03:53 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 22 May 2025 12:03:42 -0700
Subject: [PATCH v3 8/9] RISC-V: KVM: Implement get event info function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-pmu_event_info-v3-8-f7bba7fd9cfe@rivosinc.com>
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
In-Reply-To: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

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


