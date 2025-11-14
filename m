Return-Path: <kvm+bounces-63157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DA508C5ACEE
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:41:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 068F94E9A73
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F8A625CC79;
	Fri, 14 Nov 2025 00:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="juMQMHg4"
X-Original-To: kvm@vger.kernel.org
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03396246BBA;
	Fri, 14 Nov 2025 00:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080718; cv=none; b=YUtYyW7dqNI2d6+i9NeFynerIt63+0lnbHE4kgPGr9QFBWzQsVX9NpijzoUl3pRmTSYVbkBHnuJnSf2RD0JqLfJse7u9xgfF2Tzz+tfNYvWjrcufwAS5S6DSDkI2ZzS6tx+tw6WdE09jHlv2QHL8kTvprN6TYJqAMxglygpptQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080718; c=relaxed/simple;
	bh=XFdFHaqZQMfw6cwDIR/MW0cXtBesFeo1Pyg8hME7JEQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aMCQq+NMbnF29kwatO1cbi1nRzhB2UIrxLqcQ7gKUOWE8H2FUqSPV9g2tFMc9CDmgJ1ElmnuIAG24ZB0lpA8z40mzyzIIpOm2OOJfey9Qi36MYfMTg655oumY8BD7bByBxRY5IgBAnGGxOTpLKeZynddBRNstsWpgZ2IqQtulEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=juMQMHg4; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763080706; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=K9zzNpoDVrl55TirCdSU+HRj83fU0wQW4y8Ugf7Cnc4=;
	b=juMQMHg4hYgg5F/dbIH3ZFKr9rSSuFA5CO+V4+Nl6SoCqkVro0RvKcpGtlqMWxj8rQ3S/rtCh18er12uvn8vO5WsJa9WkQmLyf+V4y3ndPIsmNKI2QxAUQUOpBdtJ7FqBL/WhID46aCQLVt7i5O/OYNcqCqwIRjpWK7ntwqRadQ=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WsKydO7_1763080704 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 14 Nov 2025 08:38:26 +0800
From: fangyu.yu@linux.alibaba.com
To: ajones@ventanamicro.com
Cc: alex@ghiti.fr,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	fangyu.yu@linux.alibaba.com,
	guoren@kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	pjw@kernel.org
Subject: Re: Re: [PATCH v2] RISC-V: KVM: Fix guest page fault within HLV* instructions
Date: Fri, 14 Nov 2025 08:38:19 +0800
Message-Id: <20251114003819.42547-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20251112-ae882e7fd8d1fcbb73d87c6c@orel>
References: <20251112-ae882e7fd8d1fcbb73d87c6c@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> 
>> When executing HLV* instructions at the HS mode, a guest page fault
>> may occur when a g-stage page table migration between triggering the
>> virtual instruction exception and executing the HLV* instruction.
>> 
>> This may be a corner case, and one simpler way to handle this is to
>> re-execute the instruction where the virtual  instruction exception
>> occurred, and the guest page fault will be automatically handled.
>> 
>> Fixes: b91f0e4cb8a3 ("RISC-V: KVM: Factor-out instruction emulation into separate sources")
>> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> 
>> ---
>> Changes in v2:
>> - Remove unnecessary modifications and add comments(suggested by Anup)
>> - Update Fixes tag
>> - Link to v1: https://lore.kernel.org/linux-riscv/20250912134332.22053-1-fangyu.yu@linux.alibaba.com/
>> ---
>>  arch/riscv/kvm/vcpu_insn.c | 39 ++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 39 insertions(+)
>> 
>> diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
>> index de1f96ea6225..a8d796ef2822 100644
>> --- a/arch/riscv/kvm/vcpu_insn.c
>> +++ b/arch/riscv/kvm/vcpu_insn.c
>> @@ -323,6 +323,19 @@ int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
>>  							  ct->sepc,
>>  							  &utrap);
>>  			if (utrap.scause) {
>> +				/**
>> +				 * If a g-stage page fault occurs, the direct approach
>> +				 * is to let the g-stage page fault handler handle it
>> +				 * naturally, however, calling the g-stage page fault
>> +				 * handler here seems rather strange.
>> +				 * Considering this is an corner case, we can directly
>> +				 * return to the guest and re-execute the same PC, this
>> +				 * will trigger a g-stage page fault again and then the
>> +				 * regular g-stage page fault handler will populate
>> +				 * g-stage page table.
>> +				 */
>> +				if (utrap.scause == EXC_LOAD_GUEST_PAGE_FAULT)
>> +					return 1;
>>  				utrap.sepc = ct->sepc;
>>  				kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>>  				return 1;
>> @@ -378,6 +391,19 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
>>  		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
>>  						  &utrap);
>>  		if (utrap.scause) {
>> +			/**
>> +			 * If a g-stage page fault occurs, the direct approach
>> +			 * is to let the g-stage page fault handler handle it
>> +			 * naturally, however, calling the g-stage page fault
>> +			 * handler here seems rather strange.
>> +			 * Considering this is an corner case, we can directly
>> +			 * return to the guest and re-execute the same PC, this
>> +			 * will trigger a g-stage page fault again and then the
>> +			 * regular g-stage page fault handler will populate
>> +			 * g-stage page table.
>> +			 */
>> +			if (utrap.scause == EXC_LOAD_GUEST_PAGE_FAULT)
>> +				return 1;
>>  			/* Redirect trap if we failed to read instruction */
>>  			utrap.sepc = ct->sepc;
>>  			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>> @@ -504,6 +530,19 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
>>  		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
>>  						  &utrap);
>>  		if (utrap.scause) {
>> +			/**
>> +			 * If a g-stage page fault occurs, the direct approach
>> +			 * is to let the g-stage page fault handler handle it
>> +			 * naturally, however, calling the g-stage page fault
>> +			 * handler here seems rather strange.
>> +			 * Considering this is an corner case, we can directly
>> +			 * return to the guest and re-execute the same PC, this
>> +			 * will trigger a g-stage page fault again and then the
>> +			 * regular g-stage page fault handler will populate
>> +			 * g-stage page table.
>> +			 */
>> +			if (utrap.scause == EXC_LOAD_GUEST_PAGE_FAULT)
>> +				return 1;
>>  			/* Redirect trap if we failed to read instruction */
>>  			utrap.sepc = ct->sepc;
>>  			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>> -- 
>> 2.50.1
>>
>
>To avoid repeating the same paragraph three times I would create a
>helper function, kvm_riscv_check_load_guest_page_fault(), with the
>paragraph placed in that function along with the utrap.scause
>exception type check.
>
>Thanks,
>drew

Thanks for the suggestion! I'll incorporate this change in the next version.

Thanks,
Fangyu


