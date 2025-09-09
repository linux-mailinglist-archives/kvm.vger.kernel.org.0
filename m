Return-Path: <kvm+bounces-57061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57ADBB4A2EA
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:05:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDF854E061E
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 07:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB32130B50C;
	Tue,  9 Sep 2025 07:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="ToUPNSGs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256543043AE
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 07:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757401414; cv=none; b=Og2nj0ZOOQCCCLAn5Vr7x/+mOJbYNRMqrg8kNq07vistZMYChLb24q4DFDuqtVEe3gnhLY+RUsvbuDwa5LmpBWyo6grKYF/H+3l2QexnAScqbuxBfgFZHfk5JYP1qCPIq4L+XiwnzggL6BMoVm0YxEwUXedjCISWcCB4JwcP0/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757401414; c=relaxed/simple;
	bh=ooi3OGf1oecfma3ZZjoqxpvaZ+wyxfduuHE3R1xZ6to=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mZJBi0OkB2YXl/M8A8mL6BJUxc64H6vo7iMr9ONda04PbeWRolLP31fEzSIg91crQqXfOGNv5MFe6vty0tXrOYrBvHK7TCMZrwrfL8J1qmW/pnYn2wlqMo5ByevszXpB1Ou5ge2CUCOoldZLjq4mKUH2AjvErCwFRJjTWG6Iv68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=ToUPNSGs; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-32bae4bcd63so2814377a91.2
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 00:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1757401411; x=1758006211; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1acfgimCOFblXvFIi2ykb4JvdpnCtTT9WTI2WJXrlYg=;
        b=ToUPNSGs5GEfZwVxVNh8uEdwXFZjZgMgXFxR9xwSlZWLZb5xOZxT5sfOJEn5hSraVQ
         /SL2eO8Q9NXpwm7naD6Y2BG8eMCOfIoCc0JH+mTcVljLW2Kk84lmZx6ZF10mLOMDk7LH
         8Sq4KtxPWzSgGnIBDHaTnJUKtkXVG6efqOO9pgE6CrawRcxSrL7kUwP9eLLWIo78bu0c
         n/NEu/oMre1H9pQVV3VOEPXLSxTIEdjDFFEqB0VWelgOITK9RCVnp/KWEcpkcn/syD3a
         ANicO0INdeHwXeax/zfxJZYnERYrqNcHNByGc0R9/HW6uBkMVjwNSqM6pp4yXNoNAvN+
         9Z0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757401411; x=1758006211;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1acfgimCOFblXvFIi2ykb4JvdpnCtTT9WTI2WJXrlYg=;
        b=mnrbgwLzilyGA1O6S50agrTdIU3gb3XJAGPLuvj2nb209Yv5H0huMzUqML5NzRUXYN
         bpQWaVghzzfBjhKC62CQOrd6zcvmdiqDH4FbsbEyRb/jZ8/QSjRwuhZPjV9uLAu3UgfK
         hjHSF/Lx9rRgyoPdipxHKhuHV+a59Z/kx2e6c6IGXhrEcG2JSBxeO9UL4v9PFFE358lR
         qe9ftGOx9HUfBAsE5DEYUkByEco59Zht5DFQyBqbL/aAB+S8a7NJmjB1Am7l4tdulcMG
         OVE/NYrVkYUf1OOJmPhRU/Lu9hvpJvkn578sb8L0cxovDpxFFU8TqYIDLKkk1BPipEBf
         bEaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcQ+xYvuhfkiDXfKn5u0YiwqC6eoO9+mXmWymJ+bPHA1nvyt6qi/SymZ9k2Zpy8eEOmlI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywsgg6SC6ybHBwoXEMjHVcZXajQCr5tW8GQgHpkzVyi+5IBi6I/
	bZjLpSch7NqTU/qmiDhE04XgAmbhvt7cHvY1pnKIyPktHFsVn9OBUOIHgTKT8k/UqSA=
X-Gm-Gg: ASbGnct0eEtQjpvcXCqYYKOxqp4OIj0fo3qg/MOreYv/0ow0VWsbQLcBdhuccEwldjc
	/AZeDpRrcpGCJ80iaYQOM8EUEjAKUZSxxTYCjTHNEfeu2YUQd/LCtgxVKgBGXe+isC1KKYf+Nwn
	oFC6zsURwWMaFMKMR3hm6TJOtx+TbWRpXAs5lkwxxTZPkLfPH9l7D6YXL2mRSBOBbJOChwHvBb5
	uu7xHnM/Ddu7tNVuGxWeXKuImdJte1R7VZv8F7koqQpF07fJGAyCcFDoaMWNqu4LHAh4Z34n4qv
	iD0g4z1yXgXeMHA1dJpgOUgHSpIsgdYMwtrH/DVAwjYS8oqgfMUBDmzCZqXV53Dub8pAb/WUXua
	NTvZFBikdQvdDhZ3uVSOuo8IK2qNHXpLqWRM=
X-Google-Smtp-Source: AGHT+IHkDiF/6YwaQUzgE/xNLZqLa3zDoLihcHBPhzjoYmHrHw+d+76R53kpaEg8N/1vJrkgHwEwEw==
X-Received: by 2002:a17:90b:35c6:b0:32c:2c5:e21 with SMTP id 98e67ed59e1d1-32d43f85d9emr12290210a91.32.1757401411327;
        Tue, 09 Sep 2025 00:03:31 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-774662c7158sm1025535b3a.72.2025.09.09.00.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 00:03:30 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 09 Sep 2025 00:03:26 -0700
Subject: [PATCH v6 7/8] RISC-V: KVM: Implement get event info function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-pmu_event_info-v6-7-d8f80cacb884@rivosinc.com>
References: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
In-Reply-To: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
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
 arch/riscv/kvm/vcpu_pmu.c             | 59 +++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_sbi_pmu.c         |  3 ++
 3 files changed, 65 insertions(+)

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
index f8514086bd6b..a2fae70ee174 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -449,6 +449,65 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long s
 	return 0;
 }
 
+int kvm_riscv_vcpu_pmu_event_info(struct kvm_vcpu *vcpu, unsigned long saddr_low,
+				  unsigned long saddr_high, unsigned long num_events,
+				  unsigned long flags, struct kvm_vcpu_sbi_return *retdata)
+{
+	struct riscv_pmu_event_info *einfo = NULL;
+	int shmem_size = num_events * sizeof(*einfo);
+	gpa_t shmem;
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
+		ret = SBI_ERR_INVALID_ADDRESS;
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


