Return-Path: <kvm+bounces-59135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1F4FBAC6CC
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:13:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CF2A322485
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418B62F7AA0;
	Tue, 30 Sep 2025 10:13:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDAD82F3C34
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759227193; cv=none; b=DBkCmJK3iG9xlxA7S9os2g1vS7gi+9cfY6Npi7S1pwcxKCA98OxrGWO0wH+1N/x8gJahHIukUkFAzRx2nsqUYrjurhdjV1l5dlBa4IW1EPHK4KfQYMCY00uRyKGG0er9qZEv1LZdMuZ2UsGllFhYXkoNzA5uG4T65r/I26wyeFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759227193; c=relaxed/simple;
	bh=oYIAf+0OJAX/Jhq2Y/GzSe2lZx3Dl1A7OM1VbraNduU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nr5yQbqERBi/lJauiTrebtFLp/sWO3l0TqBxXz0d1CldSQjKrPIg1F0v1JRtAC20d2S7xaml+CvFhgSTzX8GKhlWAivhGGutkSuPdPTtZ1U7DkEjfHWJwrCzlhD5iOkZuise7/43r2yJ16j3zh72tftU0QsSrNTcIgM0jI3TtIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07E161424;
	Tue, 30 Sep 2025 03:13:02 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BEC843F66E;
	Tue, 30 Sep 2025 03:13:08 -0700 (PDT)
Date: Tue, 30 Sep 2025 11:13:03 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 03/13] KVM: arm64: Replace timer context vcpu pointer
 with timer_id
Message-ID: <20250930101303.GA1093338@e124191.cambridge.arm.com>
References: <20250929160458.3351788-1-maz@kernel.org>
 <20250929160458.3351788-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929160458.3351788-4-maz@kernel.org>

On Mon, Sep 29, 2025 at 05:04:47PM +0100, Marc Zyngier wrote:
> Having to follow a pointer to a vcpu is pretty dumb, when the timers
> are are a fixed offset in the vcpu structure itself.
> 
> Trade the vcpu pointer for a timer_id, which can then be used to
> compute the vcpu address as needed.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/arch_timer.c  |  4 ++--
>  include/kvm/arm_arch_timer.h | 11 ++++++-----
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index e5a25e743f5be..c832c293676a3 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -149,7 +149,7 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
>  static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>  {
>  	if (!ctxt->offset.vm_offset) {
> -		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
> +		WARN(offset, "timer %d\n", arch_timer_ctx_index(ctxt));
>  		return;
>  	}
>  
> @@ -1064,7 +1064,7 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
>  	struct arch_timer_context *ctxt = vcpu_get_timer(vcpu, timerid);
>  	struct kvm *kvm = vcpu->kvm;
>  
> -	ctxt->vcpu = vcpu;
> +	ctxt->timer_id = timerid;
>  
>  	if (timerid == TIMER_VTIMER)
>  		ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index d188c716d03cb..d8e400cb2bfff 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -51,8 +51,6 @@ struct arch_timer_vm_data {
>  };
>  
>  struct arch_timer_context {
> -	struct kvm_vcpu			*vcpu;
> -
>  	/* Emulated Timer (may be unused) */
>  	struct hrtimer			hrtimer;
>  	u64				ns_frac;
> @@ -71,6 +69,9 @@ struct arch_timer_context {
>  		bool			level;
>  	} irq;
>  
> +	/* Who am I? */
> +	enum kvm_arch_timers		timer_id;
> +
>  	/* Duplicated state from arch_timer.c for convenience */
>  	u32				host_timer_irq;
>  };
> @@ -127,9 +128,9 @@ void kvm_timer_init_vhe(void);
>  #define vcpu_hvtimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_HVTIMER])
>  #define vcpu_hptimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_HPTIMER])
>  
> -#define arch_timer_ctx_index(ctx)	((ctx) - vcpu_timer((ctx)->vcpu)->timers)
> -#define timer_context_to_vcpu(ctx)	((ctx)->vcpu)
> -#define timer_vm_data(ctx)		(&(ctx)->vcpu->kvm->arch.timer_data)
> +#define arch_timer_ctx_index(ctx)	((ctx)->timer_id)
> +#define timer_context_to_vcpu(ctx)	container_of((ctx), struct kvm_vcpu, arch.timer_cpu.timers[(ctx)->timer_id])
> +#define timer_vm_data(ctx)		(&(timer_context_to_vcpu(ctx)->kvm->arch.timer_data))
>  #define timer_irq(ctx)			(timer_vm_data(ctx)->ppi[arch_timer_ctx_index(ctx)])
>  
>  u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
> -- 
> 2.47.3
> 

