Return-Path: <kvm+bounces-57567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F245FB57975
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B15A2021F6
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5520430214C;
	Mon, 15 Sep 2025 11:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="bgQWvfS6"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7AF301488;
	Mon, 15 Sep 2025 11:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757937304; cv=none; b=U70lKp2VbMx79DKpGpDx2Vo2Z98OaqUvzA4m1dIGgX+irEks/Kpxqi85LfZWCfUNeYa3omb7ss0XZqw/Q1BZnYMVDJsAjUinHbuKMxkJyLdNXYy1p//0AH4pl0mdu6O0Ay5D8T8cLUD7QkFAjTbEq/iVWl7aQrJWUS+hnmJb7tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757937304; c=relaxed/simple;
	bh=pMUO3rlz0NI/IevphTmopjTWISg9EMsAz7+o+oRf+nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PcJ8fTOxpcd7kyXQfWvLUmLIDcfR06jCrxByzL9NjulYz3pgqQJQp1H5zF1IR0aqyLxeCgsrHOcpCWYfJunH+zjYzPY1EmInAR6ecNiPZjhcwPiaUI7L3GesbF3IHPU72T5B61MTHrUx0KQP93AqrgHZEE6WjV2iA+x87Jz90GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=bgQWvfS6; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version:
	Content-Type; bh=TrroQjBi7h1E6ldmwrRFmPvbkBcGEI3cj4vFcdRvkQg=;
	b=bgQWvfS6CJeN6Zmo92U0v6HOb3E+UaKzRV59nPqEbxckOjV1wT0/HPu8jPIlxK
	q0SzrOBf+6VIQvB961yP0gqCNaXIY6thJavqSqIZUePVHgktpZVp4/n06dv4ojkO
	EILW/OIjoWcvUJyCJn7ORu+qD6ww8L7JdmGU0NVd5Yhxc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3PwNa_sdo9pl4BQ--.12038S2;
	Mon, 15 Sep 2025 19:54:04 +0800 (CST)
From: Jinyu Tang <tjytimi@163.com>
To: anup@brainfault.org
Cc: ajones@ventanamicro.com,
	atish.patra@linux.dev,
	conor.dooley@microchip.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	nutty.liu@hotmail.com,
	paul.walmsley@sifive.com,
	tjytimi@163.com,
	yongxuan.wang@sifive.com
Subject: Re:Re: [PATCH v3] riscv: skip csr restore if vcpu preempted reload
Date: Mon, 15 Sep 2025 19:53:33 +0800
Message-ID: <20250915115333.1344626-1-tjytimi@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAAhSdy27hnGS3HOazwnR4Y+SCk94RLnz5CA1kDkzsx7QH3dmwA@mail.gmail.com>
References: <CAAhSdy27hnGS3HOazwnR4Y+SCk94RLnz5CA1kDkzsx7QH3dmwA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3PwNa_sdo9pl4BQ--.12038S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWr47Jw1furWDJryfJr4rGrg_yoWrGF4fpF
	W7CFsI9w48Jry3Gw1IvrsY9FsYvrWvgrn3XryDWFWfAr1DKr95AF4kKrW3ZF98Cr109F1I
	vFyDtFyIkwn0vwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUx-BtUUUUU=
X-CM-SenderInfo: xwm13xlpl6il2tof0z/1tbiZRXJeGjH93FhFgABse

At 2025-09-09 14:49:43,"Anup Patel" <anup@brainfault.org>, said: 
>On Mon, Aug 25, 2025 at 5:44 PM Jinyu Tang <tjytimi@163.com> wrote:
>>
>> The kvm_arch_vcpu_load() function is called in two cases for riscv:
>> 1. When entering KVM_RUN from userspace ioctl.
>> 2. When a preempted VCPU is scheduled back.
>>
>> In the second case, if no other KVM VCPU has run on this CPU since the
>> current VCPU was preempted, the guest CSR (including AIA CSRS and HGTAP)
>> values are still valid in the hardware and do not need to be restored.
>>
>> This patch is to skip the CSR write path when:
>> 1. The VCPU was previously preempted
>> (vcpu->scheduled_out == 1).
>> 2. It is being reloaded on the same physical CPU
>> (vcpu->arch.last_exit_cpu == cpu).
>> 3. No other KVM VCPU has used this CPU in the meantime
>> (vcpu == __this_cpu_read(kvm_former_vcpu)).
>>
>> This reduces many CSR writes with frequent preemption on the same CPU.
>
>Currently, I see the following issues with this patch:
>
>1) It's making Guest usage of IMSIC VS-files on the QEMU virt
>    machine very unstable and Guest never boots. It could be
>    some QEMU issue but I don't want to increase instability
>    on QEMU since it is our primary development vehicle.
>
>2) We have CSRs like hedeleg which can be updated by KVM
>    user space via set_guest_debug() ioctl.
>
>The direction of the patch is fine but it is very fragile at the moment.
>
>Regards,
>Anup
>
Ok, I will find out why it makes guest never boot when using IMSIC VS-files.
Thanks,
Jinyu
>>
>> Signed-off-by: Jinyu Tang <tjytimi@163.com>
>> Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
>> ---
>>  v2 -> v3:
>>  v2 was missing a critical check because I generated the patch from my
>>  wrong (experimental) branch. This is fixed in v3. Sorry for my trouble.
>>
>>  v1 -> v2:
>>  Apply the logic to aia csr load. Thanks for
>>  Andrew Jones's advice.
>>
>>  arch/riscv/kvm/vcpu.c | 13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
>> index f001e5640..66bd3ddd5 100644
>> --- a/arch/riscv/kvm/vcpu.c
>> +++ b/arch/riscv/kvm/vcpu.c
>> @@ -25,6 +25,8 @@
>>  #define CREATE_TRACE_POINTS
>>  #include "trace.h"
>>
>> +static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_former_vcpu);
>> +
>>  const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>>         KVM_GENERIC_VCPU_STATS(),
>>         STATS_DESC_COUNTER(VCPU, ecall_exit_stat),
>> @@ -581,6 +583,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>         struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
>>         struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
>>
>> +       if (vcpu->scheduled_out && vcpu == __this_cpu_read(kvm_former_vcpu) &&
>> +               vcpu->arch.last_exit_cpu == cpu)
>> +               goto csr_restore_done;
>> +
>>         if (kvm_riscv_nacl_sync_csr_available()) {
>>                 nsh = nacl_shmem();
>>                 nacl_csr_write(nsh, CSR_VSSTATUS, csr->vsstatus);
>> @@ -624,6 +630,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>
>>         kvm_riscv_mmu_update_hgatp(vcpu);
>>
>> +       kvm_riscv_vcpu_aia_load(vcpu, cpu);
>> +
>> +csr_restore_done:
>>         kvm_riscv_vcpu_timer_restore(vcpu);
>>
>>         kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
>> @@ -633,8 +642,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>         kvm_riscv_vcpu_guest_vector_restore(&vcpu->arch.guest_context,
>>                                             vcpu->arch.isa);
>>
>> -       kvm_riscv_vcpu_aia_load(vcpu, cpu);
>> -
>>         kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>>
>>         vcpu->cpu = cpu;
>> @@ -645,6 +652,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>         void *nsh;
>>         struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
>>
>> +       __this_cpu_write(kvm_former_vcpu, vcpu);
>> +
>>         vcpu->cpu = -1;
>>
>>         kvm_riscv_vcpu_aia_put(vcpu);
>> --
>> 2.43.0
>>


