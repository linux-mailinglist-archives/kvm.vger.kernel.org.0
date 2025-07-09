Return-Path: <kvm+bounces-51895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56A23AFE237
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 10:16:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AB28580ED5
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8830273D71;
	Wed,  9 Jul 2025 08:12:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A70238C21
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 08:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752048751; cv=none; b=AJEm3WOOUPxFrmRJbpYGcYacc524ZiNO0HN5G4aGX2W2myVRdgtD6oNFCtC1ptALdHTrXNGi8nICCFnpZe2GC6v447FptOFiFJpS/IxnAF4Ldqj6yXcMNsjA8bm/IMVeXze6pMhK9Es+OVMT1dWduhCca105nHP5ryUH6wdhgBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752048751; c=relaxed/simple;
	bh=zKSIKyAQfm7s+xvMcP8dCeHkRcSWeCevTGLrV4DJAsQ=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=l39fyUw9YzKOVYVDrs+NQbUtu+mO5g2eVGiHJSsV7X5gbIFMxVlGXu23VGML9heoD9Y7o4GvqDT9LaZtijxbSDvKnaPbX3KqVnV1VwnEplPSESTjDaHdkaX2arpLYaxR2H3ET4X+dUDvHl0kfBNCyB7V3sidqOShRz9dwsOO7U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bcVy24B3xz13Mny;
	Wed,  9 Jul 2025 16:09:46 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 513CD140203;
	Wed,  9 Jul 2025 16:12:25 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 9 Jul 2025 16:12:24 +0800
Subject: Re: [PATCH v4 05/20] KVM: arm64: timers: Allow physical offset
 without CNTPOFF_EL2
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton
	<oliver.upton@linux.dev>, Ricardo Koller <ricarkol@google.com>, Simon Veith
	<sveith@amazon.de>, Reiji Watanabe <reijiw@google.com>, Colton Lewis
	<coltonlewis@google.com>, Joey Gouly <joey.gouly@arm.com>,
	<dwmw2@infradead.org>
References: <20230330174800.2677007-1-maz@kernel.org>
 <20230330174800.2677007-6-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <460258be-0102-e922-c342-4e87cd94b9e5@huawei.com>
Date: Wed, 9 Jul 2025 16:12:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230330174800.2677007-6-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk200017.china.huawei.com (7.202.194.83)

[ Record some interesting bits noticed while testing
  arch_timer_edge_cases. ]

On 2023/3/31 1:47, Marc Zyngier wrote:
> CNTPOFF_EL2 is awesome, but it is mostly vapourware, and no publicly
> available implementation has it. So for the common mortals, let's
> implement the emulated version of this thing.
> 
> It means trapping accesses to the physical counter and timer, and
> emulate some of it as necessary.
> 
> As for CNTPOFF_EL2, nobody sets the offset yet.
> 
> Reviewed-by: Colton Lewis <coltonlewis@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h    |  2 +
>  arch/arm64/kvm/arch_timer.c        | 98 +++++++++++++++++++++++-------
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c | 18 ++++--
>  arch/arm64/kvm/sys_regs.c          |  9 +++
>  4 files changed, 98 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 9e3ecba3c4e6..f8da9e1b0c11 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -388,6 +388,7 @@
>  
>  #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
>  
> +#define SYS_CNTPCT_EL0			sys_reg(3, 3, 14, 0, 1)
>  #define SYS_CNTPCTSS_EL0		sys_reg(3, 3, 14, 0, 5)
>  #define SYS_CNTVCTSS_EL0		sys_reg(3, 3, 14, 0, 6)
>  
> @@ -400,6 +401,7 @@
>  
>  #define SYS_AARCH32_CNTP_TVAL		sys_reg(0, 0, 14, 2, 0)
>  #define SYS_AARCH32_CNTP_CTL		sys_reg(0, 0, 14, 2, 1)
> +#define SYS_AARCH32_CNTPCT		sys_reg(0, 0, 0, 14, 0)
>  #define SYS_AARCH32_CNTP_CVAL		sys_reg(0, 2, 0, 14, 0)
>  
>  #define __PMEV_op2(n)			((n) & 0x7)
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 3118ea0a1b41..bb64a71ae193 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -458,6 +458,8 @@ static void timer_save_state(struct arch_timer_context *ctx)
>  		goto out;
>  
>  	switch (index) {
> +		u64 cval;
> +
>  	case TIMER_VTIMER:
>  		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTV_CTL));
>  		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTV_CVAL));
> @@ -485,7 +487,12 @@ static void timer_save_state(struct arch_timer_context *ctx)
>  		break;
>  	case TIMER_PTIMER:
>  		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTP_CTL));
> -		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTP_CVAL));
> +		cval = read_sysreg_el0(SYS_CNTP_CVAL);
> +
> +		if (!has_cntpoff())
> +			cval -= timer_get_offset(ctx);
> +
> +		timer_set_cval(ctx, cval);
>  
>  		/* Disable the timer */
>  		write_sysreg_el0(0, SYS_CNTP_CTL);
> @@ -555,6 +562,8 @@ static void timer_restore_state(struct arch_timer_context *ctx)
>  		goto out;
>  
>  	switch (index) {
> +		u64 cval, offset;
> +
>  	case TIMER_VTIMER:
>  		set_cntvoff(timer_get_offset(ctx));
>  		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTV_CVAL);
> @@ -562,8 +571,12 @@ static void timer_restore_state(struct arch_timer_context *ctx)
>  		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTV_CTL);
>  		break;
>  	case TIMER_PTIMER:
> -		set_cntpoff(timer_get_offset(ctx));
> -		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTP_CVAL);
> +		cval = timer_get_cval(ctx);
> +		offset = timer_get_offset(ctx);
> +		set_cntpoff(offset);
> +		if (!has_cntpoff())
> +			cval += offset;
> +		write_sysreg_el0(cval, SYS_CNTP_CVAL);
>  		isb();
>  		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTP_CTL);
>  		break;

I tested arch_timer_edge_cases on my Kunpeng920 (has VHE, doesn't have
ECV) and noticed that the test_timer_cval() below takes a long period to
return when testing the _physical_ timer.

static void test_timers_in_the_past(enum arch_timer timer)
{
	[...]

	for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
		irq_wait_method_t wm = irq_wait_method[i];

		[...]

		/* Set a timer to counter=0 (in the past) */
		test_timer_cval(timer, 0, wm, DEF_CNT);

The comment is obviously wrong. It should say "Set a timer to CVAL=0".

No physical timer interrupt ("kvm guest ptimer") was triggered when I
executed it separately.

Let me try to explain _this_ test_timer_cval() in a bit more detail.

|Guest					KVM
|-----					---
|local_irq_disable()
|
|reset_timer_state()
|   set_counter()			// SET_ONE_REG via user-space
|					// for KVM_REG_ARM_PTIMER_CNT
|					kvm_arm_timer_set_reg()
|					   timer_set_offset()      [1]
|   timer_set_ctl()
|      MSR CNTP_CTL_EL0, IMASK
|
|set_xval_irq()
|   timer_set_cval()
|      MSR CNTP_CVAL_EL0, cval=0
|   timer_set_ctl()
|      MSR CNTP_CTL_EL0, ENABLE		// trap
|					kvm_arm_timer_write_sysreg()
|					   timer_save_state()
|					   kvm_arm_timer_write()
|					   timer_restore_state()   [2]
|
|/* This method re-enables IRQs to handle the one we're looking for. */
|wm()
|
|assert_irqs_handled(1)
|local_irq_enable()

[1] kvm_phys_timer_read()			= 0x7895c0ab2
    value					= 0x7fffffffffffff
    offset = kvm_phys_timer_read() - value	= 0xff800007895c0ab3

... which was observed in my test.

[2] cval += offset;			// cval	= 0xff800007895c0ab3
    kvm_phys_timer_read()			= 0x7895c1b86

No ptimer interrupt was triggered with that. And we relied on the next
kvm_timer_vcpu_load() to catch the timer expiration and inject an
interrupt to the guest..

It's apparent that this test case is not a practical use case. Not sure
if we should (/can) emulate it properly. Or I may have already missed
some obvious points.

Thanks,
Zenghui

