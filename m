Return-Path: <kvm+bounces-50382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF422AE49D6
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:09:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 339F01886EE1
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A9C28ECD1;
	Mon, 23 Jun 2025 16:04:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D394746BF;
	Mon, 23 Jun 2025 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750694659; cv=none; b=V9xA0dhfeb1AHM1wFMtf2loqWfwekgubABRQptVlU35Kmf6KjmcCT9zLu+3F+3zCcjkvE9tke4msOGJtb8H9ca1frSx4KoFWsEUtwaXwuqQoVUpir1GatOM0mdNCG8n4GJgQ+wgDbiEIlFnyH1dTGlfSsrNxrO/GqQZ+AeaGkjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750694659; c=relaxed/simple;
	bh=LrKGy4WBpoQHJ3dVz+8gr7LXnPo+a03MXlgQE5KvJug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n0jfhif0y9dJduUYKQ09SL2HkTcKsszRF9tzLbM8Um/KbfkHvQLJfKVw/35NhqmI1OoOvH8pqqPR/hquIFPdtoEdA3HbqTP3CGQ/7AN/q8MviBdFk4eyAptpzWv6xrCZcsDXXKV4SfADVrg+JqZSb7Sq4knmFPbaWzCjzqGx4VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 107A7113E;
	Mon, 23 Jun 2025 09:03:58 -0700 (PDT)
Received: from [10.57.29.183] (unknown [10.57.29.183])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA5B23F66E;
	Mon, 23 Jun 2025 09:04:11 -0700 (PDT)
Message-ID: <69e0107f-6c40-4ea1-ac69-51ad8aa78dff@arm.com>
Date: Mon, 23 Jun 2025 17:04:09 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 20/43] arm64: RME: Runtime faulting of memory
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-21-steven.price@arm.com>
 <e75dfc47-5b74-4898-91c0-fed9880f9727@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <e75dfc47-5b74-4898-91c0-fed9880f9727@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 16/06/2025 12:55, Gavin Shan wrote:
> Hi Steven,
> 
> On 6/11/25 8:48 PM, Steven Price wrote:
>> At runtime if the realm guest accesses memory which hasn't yet been
>> mapped then KVM needs to either populate the region or fault the guest.
>>
>> For memory in the lower (protected) region of IPA a fresh page is
>> provided to the RMM which will zero the contents. For memory in the
>> upper (shared) region of IPA, the memory from the memslot is mapped
>> into the realm VM non secure.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h |  10 ++
>>   arch/arm64/include/asm/kvm_rme.h     |  10 ++
>>   arch/arm64/kvm/mmu.c                 | 133 ++++++++++++++++++++-
>>   arch/arm64/kvm/rme.c                 | 165 +++++++++++++++++++++++++++
>>   4 files changed, 312 insertions(+), 6 deletions(-)
>>
> 
> [...]
> 
>> @@ -1078,6 +1091,9 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>       if (kvm_is_realm(kvm) &&
>>           (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>>            kvm_realm_state(kvm) != REALM_STATE_NONE)) {
>> +        struct realm *realm = &kvm->arch.realm;
>> +
>> +        kvm_stage2_unmap_range(mmu, 0, BIT(realm->ia_bits - 1), false);
>>           write_unlock(&kvm->mmu_lock);
>>           kvm_realm_destroy_rtts(kvm, pgt->ia_bits);
>>   
> 
> I'm giving it a try before taking time to review, @may_block needs to be
> true.
> I don't see there is anything why not to do so :)

You are right - I've no idea why I passed false to may_block. Thanks for
the report.

Thanks,
Steve

>   kvm_stage2_unmap_range(mmu, 0, BIT(realm->ia_bits - 1), true);
> 
> Otherwise, there is RCU stall when the VM is destroyed.
> 
> [12730.399825] rcu: INFO: rcu_preempt self-detected stall on CPU
> [12730.401922] rcu:     5-....: (5165 ticks this GP)
> idle=3544/1/0x4000000000000000 softirq=41673/46605 fqs=2625
> [12730.404598] rcu:     (t=5251 jiffies g=61757 q=36 ncpus=8)
> [12730.406771] CPU: 5 UID: 0 PID: 170 Comm: qemu-system-aar Not tainted
> 6.16.0-rc1-gavin-gfbc56042a9cf #36 PREEMPT
> [12730.407918] Hardware name: QEMU QEMU Virtual Machine, BIOS unknown
> 02/02/2022
> [12730.408796] pstate: 61402009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS
> BTYPE=--)
> [12730.409515] pc : realm_unmap_private_range+0x1b4/0x310
> [12730.410825] lr : realm_unmap_private_range+0x98/0x310
> [12730.411377] sp : ffff8000808f3920
> [12730.411777] x29: ffff8000808f3920 x28: 0000000104d29000 x27:
> 000000004229b000
> [12730.413410] x26: 0000000000000000 x25: ffffb8c82d23f000 x24:
> 00007fffffffffff
> [12730.414292] x23: 000000004229c000 x22: 0001000000000000 x21:
> ffff80008019deb8
> [12730.415229] x20: 0000000101b3f000 x19: 000000004229b000 x18:
> ffff8000808f3bd0
> [12730.416119] x17: 0000000000000001 x16: ffffffffffffffff x15:
> 0000ffff91cc5000
> [12730.417004] x14: ffffb8c82cfccb48 x13: 0000ffff4b1fffff x12:
> 0000000000000000
> [12730.417876] x11: 0000000038e38e39 x10: 0000000000000004 x9 :
> ffffb8c82c39a030
> [12730.418863] x8 : ffff80008019deb8 x7 : 0000010000000000 x6 :
> 0000000000000000
> [12730.419738] x5 : 0000000038e38e39 x4 : ffff0000c0d80000 x3 :
> 0000000000000000
> [12730.420609] x2 : 000000004229c000 x1 : 0000000104d2a000 x0 :
> 0000000000000000
> [12730.421602] Call trace:
> [12730.422209]  realm_unmap_private_range+0x1b4/0x310 (P)
> [12730.423096]  kvm_realm_unmap_range+0xbc/0xe0
> [12730.423657]  __unmap_stage2_range+0x74/0xa8
> [12730.424198]  kvm_free_stage2_pgd+0xc8/0x120
> [12730.424746]  kvm_uninit_stage2_mmu+0x24/0x48
> [12730.425284]  kvm_arch_flush_shadow_all+0x74/0x98
> [12730.425849]  kvm_mmu_notifier_release+0x38/0xa0
> [12730.426409]  __mmu_notifier_release+0x80/0x1f0
> [12730.427031]  exit_mmap+0x3d8/0x438
> [12730.427526]  __mmput+0x38/0x160
> [12730.428000]  mmput+0x58/0x78
> [12730.428463]  do_exit+0x210/0x9d8
> [12730.428945]  do_group_exit+0x3c/0xa0
> [12730.429458]  get_signal+0x8d4/0x9c0
> [12730.429954]  do_signal+0x98/0x400
> [12730.430455]  do_notify_resume+0xec/0x1a0
> [12730.431030]  el0_svc+0xe8/0x130
> [12730.431536]  el0t_64_sync_handler+0x10c/0x138
> [12730.432085]  el0t_64_sync+0x1ac/0x1b0
> 
> Thanks,
> Gavin
> 


