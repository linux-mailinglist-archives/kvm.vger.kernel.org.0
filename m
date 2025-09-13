Return-Path: <kvm+bounces-57488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4109DB55D97
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 03:25:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B3483BF3B5
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A5491A83FB;
	Sat, 13 Sep 2025 01:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gatrplh7"
X-Original-To: kvm@vger.kernel.org
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2B227470;
	Sat, 13 Sep 2025 01:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757726710; cv=none; b=fBf/kfBitKnOSa9uzlboM7/Dvp9cbeKIU3vwMrX11lIU2oFfK/YGjc+UF7LfwBYfzYdTpvY6ai6c17dhKNIq+e+IhCvz3WEzkTPjugZxKWYid/a4N6cX4+fkk8oagHFJV8EC23umflsAwHnyBTQM9BYACXiIuItFNFaZyiW6EyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757726710; c=relaxed/simple;
	bh=agQt5ainiSQaSSr29rjPNCJ03YQQhjZJznYusqfo160=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WFaDD7LoRJEVchEOK3wTNR66dRzq5pyfME4TthvNHGhmC3EhzCF1wYCn1AC1B2A/PDgHEx9fwXBO7BZLewUcCDHbPX6IxXzQCyetKte1XwIgc/y46Ggv0SyNOqv78HLLctfo2YN6KTmYRID5zo8v+lbdHw9n2yjlprui4LMTmP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gatrplh7; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757726699; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=9I5RI3u2DR62/QoMG7oALiPeUv+mWBlAeBBb+VygSaI=;
	b=gatrplh7xClNZSZp8U23XzQnwJn6Fadfy2HTDEOp6uKmyyQ80dpjAjqqrFWBXKawO0we0Ya6YYDOwiu8NJmhAMKcmZJO+JPBTlrkClOwKvERaUPYwuA/yhQ5TaiPfgbNxH9UT1O4dTphnEae3KcsMfh5lxAtGb8Pb5+f/PvT02g=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WnsD6mQ_1757726696 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 13 Sep 2025 09:24:58 +0800
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
Subject: Re: [PATCH] RISC-V: KVM: Fix guest page fault within HLV* instructions
Date: Sat, 13 Sep 2025 09:24:51 +0800
Message-Id: <20250913012451.33829-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250912140142.25147-1-fangyu.yu@linux.alibaba.com>
References: <20250912140142.25147-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>>From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>>
>>When executing HLV* instructions at the HS mode, a guest page fault
>>may occur when a g-stage page table migration between triggering the
>>virtual instruction exception and executing the HLV* instruction.
>>
>>This may be a corner case, and one simpler way to handle this is to
>>re-execute the instruction where the virtual  instruction exception
>>occurred, and the guest page fault will be automatically handled.
>>
>>Fixes: 9f7013265112 ("RISC-V: KVM: Handle MMIO exits for VCPU")
>>Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>>---
>> arch/riscv/kvm/vcpu_insn.c | 21 ++++++++++++++++++---
>> 1 file changed, 18 insertions(+), 3 deletions(-)
>>
>>diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
>>index 97dec18e6989..a8b93aa4d8ec 100644
>>--- a/arch/riscv/kvm/vcpu_insn.c
>>+++ b/arch/riscv/kvm/vcpu_insn.c
>>@@ -448,7 +448,12 @@ int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
>> 			insn = kvm_riscv_vcpu_unpriv_read(vcpu, true,
>> 							  ct->sepc,
>> 							  &utrap);
>>-			if (utrap.scause) {
>>+			switch (utrap.scause) {
>>+			case 0:
>>+				break;
>>+			case EXC_LOAD_GUEST_PAGE_FAULT:
>>+				return KVM_INSN_CONTINUE_SAME_SEPC;
>>+			default:
>> 				utrap.sepc = ct->sepc;
>> 				kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>> 				return 1;
>>@@ -503,7 +508,12 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
>> 		 */
>> 		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
>> 						  &utrap);
>>-		if (utrap.scause) {
>>+		switch (utrap.scause) {
>>+		case 0:
>>+			break;
>>+		case EXC_LOAD_GUEST_PAGE_FAULT:
>>+			return KVM_INSN_CONTINUE_SAME_SEPC;
>>+		default:
>> 			/* Redirect trap if we failed to read instruction */
>> 			utrap.sepc = ct->sepc;
>> 			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>>@@ -629,7 +639,12 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
>> 		 */
>> 		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
>> 						  &utrap);
>>-		if (utrap.scause) {
>>+		switch (utrap.scause) {
>>+		case 0:
>>+			break;
>>+		case EXC_LOAD_GUEST_PAGE_FAULT:
>
>Here should be EXC_STORE_GUEST_PAGE_FAULT, I will fix it next version.

Please ignore this comment, EXC_LOAD_GUEST_PAGE_FAULT is correct.

>
>>+			return KVM_INSN_CONTINUE_SAME_SEPC;
>>+		default:
>> 			/* Redirect trap if we failed to read instruction */
>> 			utrap.sepc = ct->sepc;
>> 			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>>--
>>2.49.0
>

