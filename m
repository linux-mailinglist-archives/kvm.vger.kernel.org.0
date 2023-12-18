Return-Path: <kvm+bounces-4712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C9FB816B5F
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 11:44:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0B421F230B4
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 10:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B531CA89;
	Mon, 18 Dec 2023 10:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="nCa27SLn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE911C283
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 10:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5913922ab10so1848481eaf.1
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 02:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702896088; x=1703500888; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h9sAaI5x/m4qa/IsblGkrHPvGq73TiWdoovLssK6KVs=;
        b=nCa27SLn2DNBvk+Chcy2MP96Ube2n3Wt2sQ5kgdW2KARzmN+sj3lq0cEaxUpdre86M
         h7+wU4Thtb4YF/9jMtlBXt3SdOKT1CghRlbwLv5p2/5nC6TyxjL2zH6neFsSIT/Bhjwg
         hc3I8SLkggHIK+ja53kfQlmxg7hzJkaqw98Zc0cv7E0zme+3H5Q4U3UeX5dYar+aFmkN
         DWC/U3Z6NW6OuXqxoTIL3gYo86mdWf4s0NUsl72JcBebrsaUCA9yxzsLKy4vGztQ5N2z
         O6IBQXdG+8gy6g9iYyRMT3Zb+gtjXOTAl6D1XV8IGx5BpY4BOs8afxJzG+gzlfoepxtW
         59OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702896088; x=1703500888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h9sAaI5x/m4qa/IsblGkrHPvGq73TiWdoovLssK6KVs=;
        b=VySk/MYV7qhsiQtteKM87DpoIHERrvem0HdmYXiKGQ4lEq5vFT21L4lCw5EKAm4DjO
         JABOEdr24H1aNi2q99wfJm+GwI3kC211UVO0uK5A6PNMrKYjdbD9JpZhGGnFhOyYIbQ0
         HGZ4us1Z4CIVHYM7rlgVkFMeYw57rWEb1lZQ7ikD3PbeY5+vdUWHGSbdRrBPCzwjetgo
         wvrEmZPYZgtSvanmTC+VKv3dDraYA8EgODRLZgCkuSjISblJE4zUXwBu6b+HPOclPz85
         ftjaeVYB/kPS6725FaR2XFnKQsEaSxxy001X95gFVhbZZBl2Vnr8BTkUZ+JZILvDlJ1E
         5O/g==
X-Gm-Message-State: AOJu0YzkdKHsEqEh2KVpIp+YpnM1ocoDpk0km+FSBGna9CwyH7Zsz8P+
	3NhRUpCBbwZH30TWjYKsbwjXTg==
X-Google-Smtp-Source: AGHT+IE8rqcGYbpX5zfzh086GD+kPOXZmg7tTADIINBhCIkcHBriRp6Yc5OpCWAefeUGFA0vrx+W3g==
X-Received: by 2002:a05:6820:168b:b0:58e:1c47:6321 with SMTP id bc11-20020a056820168b00b0058e1c476321mr10764799oob.15.1702896088517;
        Mon, 18 Dec 2023 02:41:28 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 185-20020a4a1ac2000000b005907ad9f302sm574970oof.37.2023.12.18.02.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 02:41:28 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Guo Ren <guoren@kernel.org>,
	Icenowy Zheng <uwu@icenowy.me>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>
Subject: [v1 07/10] RISC-V: KVM: No need to exit to the user space if perf event failed
Date: Mon, 18 Dec 2023 02:41:04 -0800
Message-Id: <20231218104107.2976925-8-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231218104107.2976925-1-atishp@rivosinc.com>
References: <20231218104107.2976925-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, we return a linux error code if creating a perf event failed
in kvm. That shouldn't be necessary as guest can continue to operate
without perf profiling or profiling with firmware counters.

Return appropriate SBI error code to indicate that PMU configuration
failed. An error message in kvm already describes the reason for failure.

Fixes: 0cb74b65d2e5 ("RISC-V: KVM: Implement perf support without sampling")
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c     | 14 +++++++++-----
 arch/riscv/kvm/vcpu_sbi_pmu.c |  6 +++---
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 8c44f26e754d..08f561998611 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -229,8 +229,9 @@ static int kvm_pmu_validate_counter_mask(struct kvm_pmu *kvpmu, unsigned long ct
 	return 0;
 }
 
-static int kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_event_attr *attr,
-				     unsigned long flags, unsigned long eidx, unsigned long evtdata)
+static long kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_event_attr *attr,
+				      unsigned long flags, unsigned long eidx,
+				      unsigned long evtdata)
 {
 	struct perf_event *event;
 
@@ -455,7 +456,8 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 				     unsigned long eidx, u64 evtdata,
 				     struct kvm_vcpu_sbi_return *retdata)
 {
-	int ctr_idx, ret, sbiret = 0;
+	int ctr_idx, sbiret = 0;
+	long ret;
 	bool is_fevent;
 	unsigned long event_code;
 	u32 etype = kvm_pmu_get_perf_event_type(eidx);
@@ -514,8 +516,10 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 			kvpmu->fw_event[event_code].started = true;
 	} else {
 		ret = kvm_pmu_create_perf_event(pmc, &attr, flags, eidx, evtdata);
-		if (ret)
-			return ret;
+		if (ret) {
+			sbiret = SBI_ERR_NOT_SUPPORTED;
+			goto out;
+		}
 	}
 
 	set_bit(ctr_idx, kvpmu->pmc_in_use);
diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
index 7eca72df2cbd..b70179e9e875 100644
--- a/arch/riscv/kvm/vcpu_sbi_pmu.c
+++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
@@ -42,9 +42,9 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 #endif
 		/*
 		 * This can fail if perf core framework fails to create an event.
-		 * Forward the error to userspace because it's an error which
-		 * happened within the host kernel. The other option would be
-		 * to convert to an SBI error and forward to the guest.
+		 * No need to forward the error to userspace and exit the guest
+		 * operation can continue without profiling. Forward the
+		 * appropriate SBI error to the guest.
 		 */
 		ret = kvm_riscv_vcpu_pmu_ctr_cfg_match(vcpu, cp->a0, cp->a1,
 						       cp->a2, cp->a3, temp, retdata);
-- 
2.34.1


