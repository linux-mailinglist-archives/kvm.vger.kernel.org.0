Return-Path: <kvm+bounces-33665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC3C29EFDB9
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 21:57:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD533164CD1
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 20:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6528D1DA314;
	Thu, 12 Dec 2024 20:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="FuWLkwKM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F2E1BD9EB
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 20:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734037023; cv=none; b=Fa62J7ka9iuoW+lZcfaXOenMCEzVOmmpQ8t3QVqyvacaAhmZB3tLCkeJKHKePNTNW/Sg4R7w1UeRzou4RZpikS+07TOjIviSEoX4UldfAA8QMBJWzhupO+biztp6Tc6rszTct3BvARtVKQ7bzeSRXV52QVbKYsdd369rM0wWmkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734037023; c=relaxed/simple;
	bh=FCqQrI1H1EUUmtYhOFAa3PCJetDrIooxo67JfXKS4QQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Su48b4HtQekngiKifUulTLexjYkLBGwuRpJoApkmpVjxSJwwuUtUzMmWyHRs9MzBBrTEiWJtn6x+1gavjLwtEKBEneVVO9pkHimNaoeJql519PBP2QO8E2VWpSrhToRVqzrSOjCQ5wnPcwQsG+yx67uwGUelk3eUQzfxp8xTwII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=FuWLkwKM; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-216395e151bso7216285ad.0
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 12:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1734037021; x=1734641821; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=avDzzP0/VkNzm+n9LZOGcxgwhkTK2s0/hK10f7P3aeQ=;
        b=FuWLkwKMWRa8lYhhr2Vlkk6HI2Jr1W25hqxqYoX7pym8A5plCjOAtLDnmGvGM/e5j4
         JQGoOSjWg4zIeBw6GkvoNSxf3feA2YjclyFX9GSBFULEOXM/tlgfM7GRzg/ciUyi5YpD
         K/fja2yQp+BLAQs4Gc7gK3+5HYC0N9BvTFRA53uvibnDMCsFZ4M3zM1deuI4b5VLNMfa
         3/j0Aq1cA2b4r4ThHNe2TeARa224t56irRj1du2O1gw9DPixiCMNC9IedJ3JId3rgWq1
         90gN/8u/hbN05BMPp9stihix9Jp4NRmmxzjsFEEXIHpf0PqH6x35hvYHxuM2RTzXf662
         Qihg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734037021; x=1734641821;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=avDzzP0/VkNzm+n9LZOGcxgwhkTK2s0/hK10f7P3aeQ=;
        b=vbwWxpUe0TN/xuZ5A8NlS3OKWc/35HBniQ8DhnhIkFMTueOCyxai6kSHSZA/8FmX2w
         8J7t2Bljpmy+EAPi8nucT6zXJb6eWpfzdnScHnhC9DlsSG973n4Xm3gnVTMt3I+I6eMb
         eWrNtk035mPoCwiHklme1ny7CSqMRCB98u2eNJg/6gHzDhIAIpJ2Yu9LHbs2wjVxKy01
         6ZzU0kmBvSWUrMkH8m2JFLA+dP06BhFWXQRzNMoNAAIKC0QugyyM6SE8S/wwSKC089gE
         ZTdFjQin2ozll9cMa6fmMOVsNep1bikBDxt4VdvB4OYcHDQ8CpqpbUvkfPx/sC3QVQAF
         tqKg==
X-Gm-Message-State: AOJu0Yw+vz94r5oY0MPe/KuMESAZ+DyyINPVHUj7H/YpOxmEt+dV9aa5
	gCZ1raC8EKj6/i4sWp0/AjwiRRYSZVDHM4Ts354wtvQG0suc+q+yCPvm1ycnJB8VWUlAbEneQgp
	C
X-Gm-Gg: ASbGnctWLQNNJWhS9hJtQzk3FBSo0q3p/8Id/5r3ughnw1+8ag6+4lpqDTJxngxr8tD
	IEBrQkForJqX/K/zZb0B5KMIfKA11zjvS3ELLnFbkOrfQrIjKFC1ArbibviahRobrEfn7QViGza
	sqAAKg7Q+YIijIN0oIUIHOUhuXBzLjKDQfqxBWgoI2RhnWwI5N29ZjHXQEzDCeCsaKYkRAi+965
	31d8QDiTn2phERUJZUWOltOZfg5uEPfisAsaJvLf5gPHeLTQThptqiy0Io1z2pWdVS+zQ==
X-Google-Smtp-Source: AGHT+IH/wT2q7FeXEvOXyiLAeM+qgkw89AmTDwfUlGcclhBbzmkDVZQZXv4TvB7hgFblbmwcDG7kHg==
X-Received: by 2002:a17:902:cf10:b0:216:5cc8:44e7 with SMTP id d9443c01a7336-2178c872406mr71955495ad.25.1734037021033;
        Thu, 12 Dec 2024 12:57:01 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2162e53798asm94019785ad.60.2024.12.12.12.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 12:57:00 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 12 Dec 2024 12:56:56 -0800
Subject: [PATCH 3/3] RISC-V: KVM: Add new exit statstics for redirected
 traps
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241212-kvm_guest_stat-v1-3-d1a6d0c862d5@rivosinc.com>
References: <20241212-kvm_guest_stat-v1-0-d1a6d0c862d5@rivosinc.com>
In-Reply-To: <20241212-kvm_guest_stat-v1-0-d1a6d0c862d5@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

Currently, kvm doesn't delegate the few traps such as misaligned
load/store, illegal instruction and load/store access faults because it
is not expected to occur in the guest very frequent. Thus, kvm gets a
chance to act upon it or collect statstics about it before redirecting
the traps to the guest.

We can collect both guest and host visible statistics during the traps.
Enable them so that both guest and host can collect the stats about
them if required.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_host.h | 5 +++++
 arch/riscv/kvm/vcpu.c             | 7 ++++++-
 arch/riscv/kvm/vcpu_exit.c        | 5 +++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 35eab6e0f4ae..cc33e35cd628 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -87,6 +87,11 @@ struct kvm_vcpu_stat {
 	u64 csr_exit_kernel;
 	u64 signal_exits;
 	u64 exits;
+	u64 instr_illegal_exits;
+	u64 load_misaligned_exits;
+	u64 store_misaligned_exits;
+	u64 load_access_exits;
+	u64 store_access_exits;
 };
 
 struct kvm_arch_memory_slot {
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index e048dcc6e65e..60d684c76c58 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -34,7 +34,12 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, csr_exit_user),
 	STATS_DESC_COUNTER(VCPU, csr_exit_kernel),
 	STATS_DESC_COUNTER(VCPU, signal_exits),
-	STATS_DESC_COUNTER(VCPU, exits)
+	STATS_DESC_COUNTER(VCPU, exits),
+	STATS_DESC_COUNTER(VCPU, instr_illegal_exits),
+	STATS_DESC_COUNTER(VCPU, load_misaligned_exits),
+	STATS_DESC_COUNTER(VCPU, store_misaligned_exits),
+	STATS_DESC_COUNTER(VCPU, load_access_exits),
+	STATS_DESC_COUNTER(VCPU, store_access_exits),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index acdcd619797e..6e0c18412795 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -195,22 +195,27 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	switch (trap->scause) {
 	case EXC_INST_ILLEGAL:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ILLEGAL_INSN);
+		vcpu->stat.instr_illegal_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_LOAD_MISALIGNED:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_LOAD);
+		vcpu->stat.load_misaligned_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_STORE_MISALIGNED:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_STORE);
+		vcpu->stat.store_misaligned_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_LOAD_ACCESS:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_LOAD);
+		vcpu->stat.load_access_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_STORE_ACCESS:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_STORE);
+		vcpu->stat.store_access_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_INST_ACCESS:

-- 
2.34.1


