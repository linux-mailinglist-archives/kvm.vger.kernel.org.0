Return-Path: <kvm+bounces-52038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9238CB0035D
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 15:30:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D06D1C46D59
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 13:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C76B25A33E;
	Thu, 10 Jul 2025 13:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="YXS1MaOk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D9A258CF6
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 13:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752154245; cv=none; b=TqKdl8ef88Dyuc/Pot6/ExFo0pEDPZ9F8ry1IMqwieattPOcP4HX0xRLvwUeTtL+a84k0MaeYuHXNCNEvVhAfZRnlPJq3K2IXXhogQpReKdfXApW4GkYrS1Zqlm7rN3cPetTteh6bLTVo9ii6UX01rbhFyH4hS5fPWKzya4MKUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752154245; c=relaxed/simple;
	bh=6cJe+9YLwNrTwWDQYUOtkNfP4N7/9YXpdhwaVt+OH4o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VXe4SuHXYS3vq/YeorSCJjJOUhRTS3tHPDs5D1T4NV5dwIao3tWrKwVjTf96eIo/yHnXWNobZcQB+o5kzlEBgM+g15OskteDz4x9PWIPeSQhDlIrEV+JjzKV18DDOwIfRIQOdRpQ3K7CvRQ3IcmMXR6FGRPORVSwNAnh49gIwFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=YXS1MaOk; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-74b54cead6cso706976b3a.1
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 06:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1752154242; x=1752759042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gSBRru92EdCdQV6HwNa+ZCQ/jNa0Vw05HCx0FcTUBpY=;
        b=YXS1MaOk5QDe7t3fFDXsU0qT6IuOTEF1vqOPcnL/XL5XO1EEntwCGz6SqUyeMoPQhl
         /5qvHXY6XTRgh+WiXIXPNR/PQcqJdwfc6pj7w+1/cMlkujBlHXmXEsxTTvo+Pf116AR6
         kujTydwQFVsn1sMW6m6rDjas4RWUJSuilEWzJPEH3iJcGayuSgIw4rOBjRyPZ223Zj1f
         5GRYryE/I4hqQXfDU2Yzu7yaFBGZ3U2D5jHzL2IDk7DK+p71NoDAV3Re5YBEVpl6GV5H
         +CHUxtKaYBC67q5UOJiq+bi5sqWgUUtXIDeinvV9qwcQnc4ja5VmCo8dsMb/m265DpCv
         8n8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752154242; x=1752759042;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gSBRru92EdCdQV6HwNa+ZCQ/jNa0Vw05HCx0FcTUBpY=;
        b=kLrcqPaMmlEv3WsZPWsngWEo16JHvgJZVf4a9HYfOKdeOOkKBU9DSOqrEKBtMiGrSP
         /t3zIEaoNmdVYE1cTLeT7LptIe4vqVU/n0Dym5cwjmOKcU6XoMfyryIpQl/eWTHj/ORR
         tLXjKUxZU2ULs2Q0T7DO5wCUzc6ck5/Vj7N6G1TrkjxoDlKW3U+OHO4rVE0IVrLM8zKE
         wILLTHoVEdNsxzvfTRm4qPcBmD6+3mB6hQ35rXMAk2E0jMT9+mk5x0RVrVlnmM+UCQH+
         /9WzoO3O8OHbCWcSckI9TnkSGYysodu0EUMd8rWLOLoC/ZHr8xWRJmyxqPDeDO/BEkiv
         fINA==
X-Gm-Message-State: AOJu0YwYE+jlDgJhee+tPhgD0wsnvtQSWLgQWcKaBs1sPUq4NKRfgMI7
	DC4vnP5zeK0G43RO8LNGEAWD3M/MGjKR/EKuLb2v4Dhxtw8fFTi8p8vBZzwWnjWNvJI=
X-Gm-Gg: ASbGncvitKvsMbQHKT+RcTv4rP7N/dr920D7fXfbI3W/T8qU6Vbv2TcvKJmwkMfaLfN
	s4R6ZjzkxneDEsgW248gwofezJ7D8lMS/ZTWKYYhgSmAOpYU6/7qt+xVCf6lpydwol3PqMhOnCZ
	/B+dPax9nqbhrgtgJNmGgdV7WIWg0TQ/GdMNoz/i8z2nD7yzQKIrD//CVPuRpwi/OJ/Hc2Zzwj5
	pDKMcw5du8SHxvgJFy/2yHDFnKxTivYxR0WhzM1rvJie8gElaUD1KquX3X/HbBrM9Y1ypzTLmn4
	aEF5sQPnfzX8X0OrxyxakSu5rg2M3+zHUQuqw48ONDhw0g0pEPMsic9wbx7NJ3YNiw4eK8XmD3Y
	GxKRQQU3kIjG8oLrtWaKwGnDHe98izEWMWIycy40sB49S566aFA==
X-Google-Smtp-Source: AGHT+IHzdljx762BgYLfxVy1uhiO6LuhOaahxzDQYVaWG7z0trKJ290Cb4AzI3z+szgHVgerISzuBA==
X-Received: by 2002:a05:6a00:4f8e:b0:749:b9c:1ea7 with SMTP id d2e1a72fcca58-74eb55f4f43mr4292361b3a.17.1752154242363;
        Thu, 10 Jul 2025 06:30:42 -0700 (PDT)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74eb9f4c9c4sm2334373b3a.126.2025.07.10.06.30.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Jul 2025 06:30:41 -0700 (PDT)
From: Xu Lu <luxu.kernel@bytedance.com>
To: rkrcmar@ventanamicro.com,
	cleger@rivosinc.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [PATCH v2] RISC-V: KVM: Delegate kvm unhandled faults to VS mode
Date: Thu, 10 Jul 2025 21:30:30 +0800
Message-Id: <20250710133030.88940-1-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Delegate faults which are not handled by kvm to VS mode to avoid
unnecessary traps to HS mode. These faults include illegal instruction
fault, instruction access fault, load access fault and store access
fault.

The delegation of illegal instruction fault is particularly important
to guest applications that use vector instructions frequently. In such
cases, an illegal instruction fault will be raised when guest user thread
uses vector instruction the first time and then guest kernel will enable
user thread to execute following vector instructions.

The fw pmu event counters remain undeleted so that guest can still get
these events via sbi call. Guest will only see zero count on these
events and know 'firmware' has delegated these faults.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/include/asm/kvm_host.h |  4 ++++
 arch/riscv/kvm/vcpu_exit.c        | 18 ------------------
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 85cfebc32e4cf..e04851cf0115c 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -44,7 +44,11 @@
 #define KVM_REQ_STEAL_UPDATE		KVM_ARCH_REQ(6)
 
 #define KVM_HEDELEG_DEFAULT		(BIT(EXC_INST_MISALIGNED) | \
+					 BIT(EXC_INST_ACCESS)     | \
+					 BIT(EXC_INST_ILLEGAL)    | \
 					 BIT(EXC_BREAKPOINT)      | \
+					 BIT(EXC_LOAD_ACCESS)     | \
+					 BIT(EXC_STORE_ACCESS)    | \
 					 BIT(EXC_SYSCALL)         | \
 					 BIT(EXC_INST_PAGE_FAULT) | \
 					 BIT(EXC_LOAD_PAGE_FAULT) | \
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 6e0c184127956..6e2302c65e193 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -193,11 +193,6 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	ret = -EFAULT;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	switch (trap->scause) {
-	case EXC_INST_ILLEGAL:
-		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ILLEGAL_INSN);
-		vcpu->stat.instr_illegal_exits++;
-		ret = vcpu_redirect(vcpu, trap);
-		break;
 	case EXC_LOAD_MISALIGNED:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_LOAD);
 		vcpu->stat.load_misaligned_exits++;
@@ -208,19 +203,6 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		vcpu->stat.store_misaligned_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
-	case EXC_LOAD_ACCESS:
-		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_LOAD);
-		vcpu->stat.load_access_exits++;
-		ret = vcpu_redirect(vcpu, trap);
-		break;
-	case EXC_STORE_ACCESS:
-		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_STORE);
-		vcpu->stat.store_access_exits++;
-		ret = vcpu_redirect(vcpu, trap);
-		break;
-	case EXC_INST_ACCESS:
-		ret = vcpu_redirect(vcpu, trap);
-		break;
 	case EXC_VIRTUAL_INST_FAULT:
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
 			ret = kvm_riscv_vcpu_virtual_insn(vcpu, run, trap);
-- 
2.20.1


