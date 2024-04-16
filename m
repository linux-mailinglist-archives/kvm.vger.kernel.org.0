Return-Path: <kvm+bounces-14839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81E5E8A73AC
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:50:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39F482818A6
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB6BD13C9A3;
	Tue, 16 Apr 2024 18:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="h+XacNlf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A220C13C9AD
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 18:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293106; cv=none; b=g1A4AYMowh1DQKreIqm3TmMuCBX3zCTA79WF28yNY0E3orrW3N2cHcXDSkLlq8pJtaqwHqf+UqTCfuQk2QWLTqv1nzKKQCupKHl/roOYcILVlbHmDTZS6IbD+8T2LCzilZAZkZ0yx71ZSPpkVgRUkxluhJ8jKwJvQa7p1q8B8GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293106; c=relaxed/simple;
	bh=iSleVGmYPORH0YJ6M9GKkX0luLVW1L/lHmqsDNV+cHA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ogv3IdsJVPYuxIWvfIObe8NIuPZJfTs7j+oiSbnMj2k2Rql0CrnK8tcyXi1zL/WsCF3pbjiELnAR+Sbu19zvFSSGaELr3+S2mJO5u1gcXKS1R+OHAwAopadjBechXjxNxhXLwbOjB837kWJbbhkul6e3v78rFXdbMyjJSovvK3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=h+XacNlf; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6ed32341906so4242130b3a.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 11:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713293104; x=1713897904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qvJukw934GuSrXeFuup9ak7dnmqxN0Lb+FQnvb7sFPo=;
        b=h+XacNlfbK5JGXFKKTe77kKNvOlW2y/Vpbuwxe78qoMbYEiZrwxCcqFe1Oykjpnz3p
         KwNhWTzg6FgSok/WC3RR+gRF0FI+wsIMqPC4YhcJPoBXnWLetg+p0q7ls43caxj42JT+
         zGmIhalf1fXVkfmarpH6KiLR/BegJXEj7k0LSSPiS6eydRUOT4UXI2hzROiFuuwWHHq+
         mvaXyQHfUC4QlK69cxnk66guZdWhPf7KToKuY18rm1oz8cSXggkkb8s7RB8qWsGH71H5
         JC9FzUCK42tBv/1SE1aHpnABh1SLC26Cl1tYf2LxMOX4s+S/0AmViiais+lj6In7aNCT
         mctw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713293104; x=1713897904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qvJukw934GuSrXeFuup9ak7dnmqxN0Lb+FQnvb7sFPo=;
        b=xNAnu+Iuy4RFE8VCiM2xWHGx/5PeggcH3mPrXOZitSsAtiI1cEg9wVV9LIbZcjdZIr
         az/6Umm0YpWZGiICrEAFF0+PIOAxXvTWiKoSrCxfr2hLKM3YqjHzwPt3em87IRHLi0TB
         daHXxbrkTXrcWTLwVYDy7UH/srrTHx3s10yoBKrfDM3IgJ7VsHsU6SHLw/Qppv+85NiU
         IBrG5+JbyPgKocmYo/eTXVzbdgpHR65YtlR4gTqR5okxiahVBP+LSimDOWL7TdnvdELR
         GCdC8C021YYqZb21AFg4VHbKTWGYL8c8M6DKSEx8DwQjYLSoaSE4WcaRC52bEqb6/x0y
         n3OQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtWxAbOaUfWSXGcPXC8BeL3Uo0/mKC+9J9TPZSwfHkR+tZHxN+Fuw/hBzxRHYLYzDebYlom4cVpo8zhqyoFEtDv4Dd
X-Gm-Message-State: AOJu0Yx8brHHFdCPf+GYDBMd2siWsvc154g9MvsFsc6zdisfHgE3av2g
	rYOZr4hs3COTpMKm87bP9mPkOExPD4uhNCpyChIz9GBAOHF4/d7HAAXTDTmt4SM=
X-Google-Smtp-Source: AGHT+IEzkuVs13Wd8oWq41fr6Cm4Cf2ZRXqAps1equR8HRaWNn24PI2u5SFf2jAeIUGzEw8b8iUdrw==
X-Received: by 2002:a05:6a21:2d8e:b0:1a9:dd82:a42a with SMTP id ty14-20020a056a212d8e00b001a9dd82a42amr9766403pzb.31.1713293104126;
        Tue, 16 Apr 2024 11:45:04 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id o19-20020a17090aac1300b002a269828bb8sm8883645pjq.40.2024.04.16.11.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 11:45:03 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Juergen Gross <jgross@suse.com>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	x86@kernel.org
Subject: [PATCH v7 16/24] RISC-V: KVM: Improve firmware counter read function
Date: Tue, 16 Apr 2024 11:44:13 -0700
Message-Id: <20240416184421.3693802-17-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240416184421.3693802-1-atishp@rivosinc.com>
References: <20240416184421.3693802-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename the function to indicate that it is meant for firmware
counter read. While at it, add a range sanity check for it as
well.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_pmu.h | 2 +-
 arch/riscv/kvm/vcpu_pmu.c             | 7 ++++++-
 arch/riscv/kvm/vcpu_sbi_pmu.c         | 2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index 55861b5d3382..fa0f535bbbf0 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -89,7 +89,7 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 				     unsigned long ctr_mask, unsigned long flags,
 				     unsigned long eidx, u64 evtdata,
 				     struct kvm_vcpu_sbi_return *retdata);
-int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
+int kvm_riscv_vcpu_pmu_fw_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 				struct kvm_vcpu_sbi_return *retdata);
 int kvm_riscv_vcpu_pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
 				      struct kvm_vcpu_sbi_return *retdata);
diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index e1409ec9afc0..04db1f993c47 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -235,6 +235,11 @@ static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 	u64 enabled, running;
 	int fevent_code;
 
+	if (cidx >= kvm_pmu_num_counters(kvpmu) || cidx == 1) {
+		pr_warn("Invalid counter id [%ld] during read\n", cidx);
+		return -EINVAL;
+	}
+
 	pmc = &kvpmu->pmc[cidx];
 
 	if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
@@ -747,7 +752,7 @@ int kvm_riscv_vcpu_pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
 	return 0;
 }
 
-int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
+int kvm_riscv_vcpu_pmu_fw_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 				struct kvm_vcpu_sbi_return *retdata)
 {
 	int ret;
diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
index cf111de51bdb..e4be34e03e83 100644
--- a/arch/riscv/kvm/vcpu_sbi_pmu.c
+++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
@@ -62,7 +62,7 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		ret = kvm_riscv_vcpu_pmu_ctr_stop(vcpu, cp->a0, cp->a1, cp->a2, retdata);
 		break;
 	case SBI_EXT_PMU_COUNTER_FW_READ:
-		ret = kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retdata);
+		ret = kvm_riscv_vcpu_pmu_fw_ctr_read(vcpu, cp->a0, retdata);
 		break;
 	case SBI_EXT_PMU_COUNTER_FW_READ_HI:
 		if (IS_ENABLED(CONFIG_32BIT))
-- 
2.34.1


