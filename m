Return-Path: <kvm+bounces-56319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB423B3BE38
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 16:44:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77AB616A4AC
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 14:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 131E232C32D;
	Fri, 29 Aug 2025 14:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="EZKfemrC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CEB322DB4
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 14:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756478481; cv=none; b=m0WM8MqIuGkrpAW2gPTPWFOLQX6gfRw9dfX0N+WHVBmqOSQmr5Zn9hVSElNbgVa/rpjp1yWGVnp8gFandcQHyI5/tuN5ixxlh79xDOzoRYjewdyexXxWvmRndHoPLRfyD4MpzfJZOQNDS28ErLhoFLRkbSWZL2XzbnRBWNsMejM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756478481; c=relaxed/simple;
	bh=N6+h+tsIWnMjf3ceMOGaeiYo79VIo7jfDe4CcDtFJJU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ty8a+/iKkyaql/ShQep6/zYAe9hQ/BGbzr9aWTNCtdcXxZU0PteVp4eoWJ9lHwswSpmi4mQ2XOv1noii1IX4hNO2P5n+al424Xqg83kWOm+LJulWSHMLxPYXd1ursNok785+66UK0tsugrMDl5gjVBUpCNeOgn+gBf1Xcq6AYsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=EZKfemrC; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-771ff6f117aso1952780b3a.2
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 07:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1756478479; x=1757083279; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8n6toQkVFfP8na+ISaaEJDAIrFZoZwC9O7ud2sWM9B0=;
        b=EZKfemrCg3JJx0ABXxSUVRtXcQexwlRUrR0R7WCwYFk14RK5lwdIPAsgC8UrArssgf
         CD25+kmX/w39dCz+FrWRSb8veQYAxL4XGV3xjWhGhJzH9qg8h7aVL6kdwVyYkBc5tpyW
         ByqTWo1Xp3f3AiKQrvUVDyLm03cqWan70iQq1M1wrJF/Fekt5QxivRAQQdYYrOWcPME2
         uClb36TjVfG0e1hoZcZ8XAsOO1fMgP8HaBs6L6FguwbgPA38TdJsjPto6iYZQ4flT5KG
         z9VNtcuOgB+Z/okC21BpgbjP43+3Dc9tBKl1n0qppVyPhIGWLQEVsttOgbAp6I5qb5ve
         /oug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478479; x=1757083279;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8n6toQkVFfP8na+ISaaEJDAIrFZoZwC9O7ud2sWM9B0=;
        b=eERKk9KB7DU3fwhUez4YY/s2oLGnrhb5/iJTgNV/BoOPHRV3hSD9QV9TQ5vLA+cQ4A
         FuEN+TiuPEp2ZWOyDH200XMxxfMpE4lGLaPbA/iPcBDA0DxyQ7cQDxyU2N/t0T9Vajoo
         kQX5XSQoqXeIb6j+xL/xgF8CrSnZXN/MWxCgF/oaT+jfVR4ir8tUkMrX7O7YalmhEsSI
         K3gN4mLOIoIhFT499ikAzZv3iPjvL0FGt0TDfyrqJR3eC8jJgoFrPKYDuQh2gUQQIPRo
         th/kQVwX/DH57/N7hexrShuov846mvhYymvmRZeP3yIcRLM1iizjVoOceRYm6PYnmqMn
         ty5w==
X-Forwarded-Encrypted: i=1; AJvYcCVkxb87rjCDIy9HfJhYG70VD5dfhFCnEu6M0lMgrsgNGUZh3HQkKY9MDpHObGrOCJYUacE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhoJs1OGnI+UBAC4W+C6HYUtYv4TxpOWMApK6a5GDoQWXK8oo6
	HMf+hz0kAlRKLmFfkO0C3LnNarQBE+tjE+x7RTwegy9Gl4QXss0kj9O7ooHxSpz2X95FQKSfBmt
	/hepZ
X-Gm-Gg: ASbGnctHBZz1aoaqsswzMF0YkrpOAY+NKFMJQYOe0sqvyJPQhLXBnRCvjA1D1rXIV6G
	b2ZX7dzSjxNqURrBp20eGFUM1puX8bXnNEPj7ySzhB0CebdVZDS2/GiTINYKlV4yQnrrUN6It4r
	gw24VUhTmnpqfGSZJzzZ4Z4OwUJe06GRmQykIV5/BbsZjXKCglzcQJbLmDtwipOBVI2pY0hLJ3G
	K6IR1H+prsDlR2vgAQkr5Oqk6lux+6RYzbfpIxG5SrMprSy27Y/y+v+MOf+u06cEvluedLPAeHM
	hT+zJdtWW5ekCXZ6GQMDUd+dW/rQFCdPL0imgG9Y/nddRp7yGqaDvx6Fa6LnrH2mLAmfXzecdoF
	EfFtmDH67X3QxrfsxhqcfKMgR//ddPTBIa50=
X-Google-Smtp-Source: AGHT+IFbwzsbSElYu8KYbXCV/+je/6mE2S0/2liCEwQBNCHEuRYMQctOBLGbIAGZhqVBmpmbFujhhA==
X-Received: by 2002:a05:6a00:929f:b0:772:306d:a1ed with SMTP id d2e1a72fcca58-772306dac16mr3197588b3a.32.1756478478747;
        Fri, 29 Aug 2025 07:41:18 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4e1f86sm2560999b3a.72.2025.08.29.07.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 07:41:16 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Fri, 29 Aug 2025 07:41:09 -0700
Subject: [PATCH v5 8/9] RISC-V: KVM: Implement get event info function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250829-pmu_event_info-v5-8-9dca26139a33@rivosinc.com>
References: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
In-Reply-To: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-50721

The new get_event_info funciton allows the guest to query the presence
of multiple events with single SBI call. Currently, the perf driver
in linux guest invokes it for all the standard SBI PMU events. Support
the SBI function implementation in KVM as well.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_pmu.h |  3 ++
 arch/riscv/kvm/vcpu_pmu.c             | 68 +++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_sbi_pmu.c         |  3 ++
 3 files changed, 74 insertions(+)

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
index 851caa86cde2..bd93b0f2ed26 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -453,6 +453,74 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long s
 	return 0;
 }
 
+int kvm_riscv_vcpu_pmu_event_info(struct kvm_vcpu *vcpu, unsigned long saddr_low,
+				  unsigned long saddr_high, unsigned long num_events,
+				  unsigned long flags, struct kvm_vcpu_sbi_return *retdata)
+{
+	struct riscv_pmu_event_info *einfo = NULL;
+	int shmem_size = num_events * sizeof(*einfo);
+	gpa_t shmem, gpa, end_shmem;
+	u32 eidx, etype;
+	u64 econfig;
+	int ret;
+
+	if (flags != 0 || (saddr_low & (SZ_16 - 1) || num_events == 0)) {
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
+	end_shmem = (shmem + shmem_size + PAGE_SIZE - 1) & PAGE_MASK;
+
+	for (gpa = shmem; gpa < end_shmem; gpa += PAGE_SIZE) {
+		if (!kvm_is_gpa_in_writable_memslot(vcpu->kvm, gpa)) {
+			ret = SBI_ERR_INVALID_ADDRESS;
+			goto out;
+		}
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
+		einfo[i].output = (ret > 0) ? 1 : 0;
+	}
+
+	ret = kvm_vcpu_write_guest(vcpu, shmem, einfo, shmem_size);
+	if (ret) {
+		ret = SBI_ERR_FAILURE;
+		goto free_mem;
+	}
+
+	ret = 0;
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


