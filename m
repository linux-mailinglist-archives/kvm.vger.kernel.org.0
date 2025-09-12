Return-Path: <kvm+bounces-57402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 63DD2B5503A
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 16:02:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB546189B791
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 14:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2953115B8;
	Fri, 12 Sep 2025 14:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="PfRqB0Sy"
X-Original-To: kvm@vger.kernel.org
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797BA3101BF;
	Fri, 12 Sep 2025 14:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757685720; cv=none; b=h/Huc4koxgm1hXMFeXQ9+IhZikr0m1OyCvMArL4P3G4MOBKdD38EVUlV9O8cHrYZqAw4OhdiJYd/UrYD+w1BAtKfxLD3W303k6yDbrIg9XLl2hkuu8MfQnt4CWHWy8QddzLRmvE6XwiHLAY4zWqm00Mu4FGH7NPZ9wi+3llSXnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757685720; c=relaxed/simple;
	bh=3PKdLEyRBbHnGuuRww7QgCfDhER4C/ylstL8HNIBc/I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Te5imFhps0NDetK69Gahy650YkT6SSbCjinLiVw/mWuMb8bmt+WTGKsyEMzqFDgBcN6t8eneNy4hZ6DIS1I+PdPfowB8vcmfu8cFUUA5g2RptURnlmY28CZJt2QsRWkaTijz3tNojaHVJmYlwuztL8KNnpD4mjEZuzLAwpIQpUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=PfRqB0Sy; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757685709; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=7vxMUaEoC1xxpeH68Y+6uXbvZfNDx8aZMXB0ICKHPVA=;
	b=PfRqB0Sy1LO9+mPNAMX5xMxSIfnYxfwiCtYTpLPotKcYDwVFp3n4qXLGI72zvGOvALF8DNAsofm4OxtvUM9ujGLsy5BtY+f6VoNCxEExadY6jOYniPbRiVNiynf2YztSGbTewnZ6h4XHLVHUYNmBjGFqb2emew0XZvgxcQ/ytqY=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WnrFnIQ_1757685706 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Sep 2025 22:01:47 +0800
From: fangyu.yu@linux.alibaba.com
To: fangyu.yu@linux.alibaba.com
Cc: alex@ghiti.fr,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	graf@amazon.com,
	guoren@kernel.org,
	jiangyifei@huawei.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com,
	pbonzini@redhat.com
Subject: [PATCH] RISC-V: KVM: Fix guest page fault within HLV* instructions
Date: Fri, 12 Sep 2025 22:01:42 +0800
Message-Id: <20250912140142.25147-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250912134332.22053-1-fangyu.yu@linux.alibaba.com>
References: <20250912134332.22053-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
>When executing HLV* instructions at the HS mode, a guest page fault
>may occur when a g-stage page table migration between triggering the
>virtual instruction exception and executing the HLV* instruction.
>
>This may be a corner case, and one simpler way to handle this is to
>re-execute the instruction where the virtual  instruction exception
>occurred, and the guest page fault will be automatically handled.
>
>Fixes: 9f7013265112 ("RISC-V: KVM: Handle MMIO exits for VCPU")
>Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>---
> arch/riscv/kvm/vcpu_insn.c | 21 ++++++++++++++++++---
> 1 file changed, 18 insertions(+), 3 deletions(-)
>
>diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
>index 97dec18e6989..a8b93aa4d8ec 100644
>--- a/arch/riscv/kvm/vcpu_insn.c
>+++ b/arch/riscv/kvm/vcpu_insn.c
>@@ -448,7 +448,12 @@ int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
> 			insn = kvm_riscv_vcpu_unpriv_read(vcpu, true,
> 							  ct->sepc,
> 							  &utrap);
>-			if (utrap.scause) {
>+			switch (utrap.scause) {
>+			case 0:
>+				break;
>+			case EXC_LOAD_GUEST_PAGE_FAULT:
>+				return KVM_INSN_CONTINUE_SAME_SEPC;
>+			default:
> 				utrap.sepc = ct->sepc;
> 				kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> 				return 1;
>@@ -503,7 +508,12 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
> 		 */
> 		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
> 						  &utrap);
>-		if (utrap.scause) {
>+		switch (utrap.scause) {
>+		case 0:
>+			break;
>+		case EXC_LOAD_GUEST_PAGE_FAULT:
>+			return KVM_INSN_CONTINUE_SAME_SEPC;
>+		default:
> 			/* Redirect trap if we failed to read instruction */
> 			utrap.sepc = ct->sepc;
> 			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>@@ -629,7 +639,12 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
> 		 */
> 		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
> 						  &utrap);
>-		if (utrap.scause) {
>+		switch (utrap.scause) {
>+		case 0:
>+			break;
>+		case EXC_LOAD_GUEST_PAGE_FAULT:

Here should be EXC_STORE_GUEST_PAGE_FAULT, I will fix it next version.

>+			return KVM_INSN_CONTINUE_SAME_SEPC;
>+		default:
> 			/* Redirect trap if we failed to read instruction */
> 			utrap.sepc = ct->sepc;
> 			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>-- 
>2.49.0

