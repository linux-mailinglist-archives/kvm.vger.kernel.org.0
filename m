Return-Path: <kvm+bounces-52137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E132B0198E
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:17:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0BF3F7BB3CD
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4E727FB06;
	Fri, 11 Jul 2025 10:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="heICupAI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AEE27E7FC
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228950; cv=none; b=MJJ4GDnBrxhqXixEXTJ4IOJKkxwm0hohtDD8/NqbYwFZe3QQLUOxrpFfrlLRv0yd8d0dOm0Rc3KjeaTM2zQ070NYlnFaDnOYjZ56YqkRsQQEvHXWiPcVaqtErKhg6kmHAHRO+0BYPCZ8irACF5ukrFU89d9Yq56dsuar4ujuNcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228950; c=relaxed/simple;
	bh=FlSlIBO0balsP11mEF//2MH7vBlUT9o8miavVHAqWIo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mamfpCQB8kAXIEqA5kxegc+2Xpg9w111l3NV7KI5hnIIVZ3tOwJYYQdi9TjqUSSr5uC8nmZrV33sSxVXzZG5n/XO8Gc2VkXco1TrUP5bQ31sUAezLaRp3ICKTy1i4qxzXzDjnLEY/Z9HiunGCLEAb7LFOZdGwkrozX1rlK/oUuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=heICupAI; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-748f5a4a423so1257151b3a.1
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 03:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1752228947; x=1752833747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EooS1f2JEaJ0MSXv8Pftab8ZGwzW6brdtxNMV0U2ebo=;
        b=heICupAIDsUJlrRd+EywEGg41nn69Zj+Iy517tqMwj3HZt0D8OIaAyANyMzXjeO4O+
         bDdt6J0SdoxEef2OH79jc9gqPGdd9CP2Wd+BwK71QLxr/W75etD4cgo38vegdDJKSNS8
         kAf4Z5n+yWVaHSU5ZXvqXOd2qo71y/6o+1ITHt22J2ucFmiWU7ZW/WpJLLrpyd5dFrls
         ITbwFggJ8u2mIZ02GdHBX9iatUCPGbHWBUGne88YFdQtzcT8qaZECPbvjlvPp7+2vseG
         O5C5fQxB5I1idN4+RB+8AEJu4u7teJL+76Syp8U5YHblLP4GXs3HfjSpjGgsJ1qCih+D
         xD6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752228947; x=1752833747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EooS1f2JEaJ0MSXv8Pftab8ZGwzW6brdtxNMV0U2ebo=;
        b=DH1VfbH2cKrrvpm7HB9875cn+LLFvT5QDSB+Rx+9ObYZgN29onSk9aphY+Gu52yHRz
         A+0AmmePlzqrtSeY0FhvpKahP7xCarqxxN7Z7tD3oPdfaxF8C3xTXw0oraHYeSOPXKUu
         k2+XqDxJh9+lYPY4oe53tOaqmOyHyxMGa951QxZ2Np0HuEFwEl3e8YybeIjktRZjh1MI
         8GRNT8Rtd9CdmkjgDFzEP+4RNvJbTm2/XveOgK8LHj1YFVx2Z4a8cSvIlxcB4eL/1DDi
         s96MNk8Sr5MgSKN7nVS+G2GAmoijukOcbM2CdHw8q7lqQQHGDdavcrroAGC0nAZOxRbO
         BhGA==
X-Gm-Message-State: AOJu0YzHqEutzsKq3sG5eHtgNicCFiy0ha/PLsKTnVgwk00WRUp23/5T
	3SEqWDXyFIHducQzZISXBEmitziqq02zcEC9fe8CvaZqdCksL3d8h/1ajIPXiTuWrm8=
X-Gm-Gg: ASbGncu1adIz3UirR+Ot6e/Mg73TJRwB/FDE7Imscfz04NrAcHb/918f1YBpuQGXQf6
	8BGBIb3HCuDPvKTxhKIF2YwZjoNwAYNP1cffO3q5bM5cXArxuej7KbhLxZdsY+1iH9AtVS/IVMx
	B+pavaqjSb4H5o+s5n188RSFxzCmBZiJTbxllHk1VurkcsP2frv3BVU7Wl5WiMizBWl32TYjp4d
	V5wF/2JQeOoc9dghHo0ryTqKE327Fo/Fm/1gf3YGegzoF+Gz6YXHRf8xd3V4SDOzy/+cYTqtS7h
	iqxdlT5u/xBjAKXMj4YZgLEtIUkfECg1RAPNOaGtx8oG9TNlQGasPeZ51ftFBqrjBXk6gwjBppE
	4f9r+H+PSa9s9bXr/z7Lz+9bLOjI9ncJuN+71VTJsJMtv8e+xA89qCJ7hRzHrjxPogRLQ1LgpO9
	UHwToWmz7Xrw==
X-Google-Smtp-Source: AGHT+IGpj33BleFxzAPRm55+ECQhrqvsjdgnGSCUQSi44RJyUsIBajs+sZylsyU6wVkfs3hyvw0WQw==
X-Received: by 2002:a05:6a00:2789:b0:748:ffaf:9b53 with SMTP id d2e1a72fcca58-74ee274ca0emr3090929b3a.16.1752228946640;
        Fri, 11 Jul 2025 03:15:46 -0700 (PDT)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.55])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74eb9dd73d1sm4974855b3a.10.2025.07.11.03.15.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 11 Jul 2025 03:15:46 -0700 (PDT)
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
Subject: [PATCH v3] RISC-V: KVM: Delegate illegal instruction fault to VS mode
Date: Fri, 11 Jul 2025 18:15:37 +0800
Message-Id: <20250711101537.16308-1-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Delegate illegal instruction fault to VS mode in default to avoid such
exceptions being trapped to HS and redirected back to VS.

The delegation of illegal instruction fault is particularly important
to guest applications that use vector instructions frequently. In such
cases, an illegal instruction fault will be raised when guest user thread
uses vector instruction the first time and then guest kernel will enable
user thread to execute following vector instructions.

The fw pmu event counter remains undeleted so that guest can still query
illegal instruction events via sbi call. Guest will only see zero count
on illegal instruction faults and know 'firmware' has delegated it.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/include/asm/kvm_host.h | 1 +
 arch/riscv/kvm/vcpu_exit.c        | 5 -----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 85cfebc32e4cf..3f6b9270f366a 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -44,6 +44,7 @@
 #define KVM_REQ_STEAL_UPDATE		KVM_ARCH_REQ(6)
 
 #define KVM_HEDELEG_DEFAULT		(BIT(EXC_INST_MISALIGNED) | \
+					 BIT(EXC_INST_ILLEGAL)     | \
 					 BIT(EXC_BREAKPOINT)      | \
 					 BIT(EXC_SYSCALL)         | \
 					 BIT(EXC_INST_PAGE_FAULT) | \
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 6e0c184127956..cd8fa68f3642c 100644
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
-- 
2.20.1


