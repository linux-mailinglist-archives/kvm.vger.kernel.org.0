Return-Path: <kvm+bounces-62173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3412FC3B48A
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 14:39:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 425B64275B5
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 13:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E77C332B99E;
	Thu,  6 Nov 2025 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Z7jQs5Mc"
X-Original-To: kvm@vger.kernel.org
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048522550CA;
	Thu,  6 Nov 2025 13:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762435800; cv=none; b=VyknptV5vn1x9/VO6Xr0/ckOTpLbxLxG5nU6aNC2bz4LQBuzbQA8pdbEXxyvFoA/RTKSM60YDN2H/9rR2Lk26E5J0vDH807JW/Z3kzxt8rpyqnGVDsCXcaGkr6b3J1OB2/ey7+9gbOxD9zRWJt/HuFTHGJlRRkzj+DXUejrxJAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762435800; c=relaxed/simple;
	bh=yscLidwPb/TfU6vuuKFD9lrGYUswI5iL1Fu4J6VabZo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e4GuPE6Lug0En1LF++UfXzYnxthErQ0m6pfpR00+kzLlMwQMuaD8gQWsRd+oZn2MJymeB7K6qTkKkNAX8kIx9MgXgwor51dGjbFiqrUNQwKLBr8m+HLBZtFWTPcHjNfOIt8fEDV02BEKEogdwahx8yJHevvi2eM4kAdqSYkLjjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Z7jQs5Mc; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762435793; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=1kXLXXv2N3VYJNPmf0poJF0RIiMv5kZuy7eqQXCw1X4=;
	b=Z7jQs5McRR/RUUvFRE7otomvLWt0boJZ1+Pkv1Zam6Qu0BPlEdHaDUEz5VT2wQbz+Pa9GSPt6hWBdiOkvzHtxM1ANuxCAiIOWweja/nFkaqnkjELynDtdUdmpZGWLi+W0dEqDcud7D295t/QKWleRKSZmK6D/mlkA0DJg183jYk=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WrptGql_1762435791 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Nov 2025 21:29:52 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org
Cc: alex@ghiti.fr,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	fangyu.yu@linux.alibaba.com,
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
Subject: Re: Re: [PATCH] RISC-V: KVM: Fix guest page fault within HLV* instructions 
Date: Thu,  6 Nov 2025 21:29:50 +0800
Message-Id: <20251106132950.80534-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <CAAhSdy0azfC-L3buko7-mN1PDWxi08HN=3NQ+0VeyMR8gVJNoQ@mail.gmail.com>
References: <CAAhSdy0azfC-L3buko7-mN1PDWxi08HN=3NQ+0VeyMR8gVJNoQ@mail.gmail.com>
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
>> Fixes: 9f7013265112 ("RISC-V: KVM: Handle MMIO exits for VCPU")
>> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> ---
>>  arch/riscv/kvm/vcpu_insn.c | 21 ++++++++++++++++++---
>>  1 file changed, 18 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
>> index 97dec18e6989..a8b93aa4d8ec 100644
>> --- a/arch/riscv/kvm/vcpu_insn.c
>> +++ b/arch/riscv/kvm/vcpu_insn.c
>> @@ -448,7 +448,12 @@ int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
>>                         insn = kvm_riscv_vcpu_unpriv_read(vcpu, true,
>>                                                           ct->sepc,
>>                                                           &utrap);
>> -                       if (utrap.scause) {
>> +                       switch (utrap.scause) {
>> +                       case 0:
>> +                               break;
>
>This looks like an unrelated change so drop it or send a separate patch
>with proper explanation.
>
>> +                       case EXC_LOAD_GUEST_PAGE_FAULT:
>> +                               return KVM_INSN_CONTINUE_SAME_SEPC;
>
>The KVM_INSN_xyz enum values are only for functions called via
>system_opcode_insn() so return 1 over here just like the below
>default case.
>
>Also, add some comments over here about why we are simply
>continuing the guest.
>
>> +                       default:
>>                                 utrap.sepc = ct->sepc;
>>                                 kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>>                                 return 1;
>> @@ -503,7 +508,12 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
>>                  */
>>                 insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
>>                                                   &utrap);
>> -               if (utrap.scause) {
>> +               switch (utrap.scause) {
>> +               case 0:
>> +                       break;
>
>This looks like an unrelated change so drop it or send a separate patch
>with proper explanation.
>
>> +               case EXC_LOAD_GUEST_PAGE_FAULT:
>> +                       return KVM_INSN_CONTINUE_SAME_SEPC;
>
>Same comment as kvm_riscv_vcpu_virtual_insn().
>
>> +               default:
>>                         /* Redirect trap if we failed to read instruction */
>>                         utrap.sepc = ct->sepc;
>>                         kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>> @@ -629,7 +639,12 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
>>                  */
>>                 insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
>>                                                   &utrap);
>> -               if (utrap.scause) {
>> +               switch (utrap.scause) {
>> +               case 0:
>> +                       break;
>
>This looks like an unrelated change so drop it or send a separate patch
>with proper explanation.
>
>> +               case EXC_LOAD_GUEST_PAGE_FAULT:
>> +                       return KVM_INSN_CONTINUE_SAME_SEPC;
>
>Same comment as kvm_riscv_vcpu_virtual_insn().
>
>> +               default:
>>                         /* Redirect trap if we failed to read instruction */
>>                         utrap.sepc = ct->sepc;
>>                         kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>> --
>> 2.49.0
>>
>>
>
>Regards,
>Anup

Hi Anup:

Thanks for the review.
I will follow your suggestions in the next version.

Thanks,
Fangyu

