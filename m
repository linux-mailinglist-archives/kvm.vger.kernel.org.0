Return-Path: <kvm+bounces-44583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD932A9F448
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 17:22:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46F931897883
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 15:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B11626C39E;
	Mon, 28 Apr 2025 15:22:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05DA6256D
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 15:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745853734; cv=none; b=IaQh/QAdqNweZGw0uQX51TiOlOI2p5rlrdMGiTTMZpk+BrYe+jKIe00pd15HvrO8c+yyknq4JqV0e5638WJMT7tWn8NUxSJpzxVpSPooSAi6jk0yI4yanNLxmlvGvgobut0JPvPzj9Wda0h+GOFB02WYbtWMpCCMLZBTqJpxrf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745853734; c=relaxed/simple;
	bh=gxE7qbr71f04vdkZt/3olchIZHyOW0X9RzYP8P23DLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivaV10gYdVNDyc1dLWa0bTosS4LsWxmTvO+ymqODhmGe1KMcrMGDQqxTZUyImOxN9iEj9tN1KhPeawyHxEZuJyUV7PWN+fe/Od/RPzNPQiPIHaWVJbH4ThzcvmcuyUYfsk90s6+TWPgJWml0DVO8Viun+Y6pc5Nyb4/E5c9AVIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD8761516;
	Mon, 28 Apr 2025 08:22:05 -0700 (PDT)
Received: from arm.com (unknown [10.1.197.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 491FC3F673;
	Mon, 28 Apr 2025 08:22:11 -0700 (PDT)
Date: Mon, 28 Apr 2025 16:22:08 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool v3 2/3] cpu: vmexit: Retry KVM_RUN ioctl on EINTR
 and EAGAIN
Message-ID: <aA+dIAof4faNGjCf@arm.com>
References: <20250428115745.70832-1-aneesh.kumar@kernel.org>
 <20250428115745.70832-3-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250428115745.70832-3-aneesh.kumar@kernel.org>

Hi Aneesh,

Is this to fix Will's report that the series breaks boot on x86?

On Mon, Apr 28, 2025 at 05:27:44PM +0530, Aneesh Kumar K.V (Arm) wrote:
> When KVM_RUN fails with EINTR or EAGAIN, we should retry the ioctl
> without checking kvm_run->exit_reason. These errors don't indicate a
> valid VM exit, hence exit_reason may contain stale or undefined values.

EAGAIN is not documented in Documentation/virt/kvm/api.rst. So I'm going to
assume it's this code path that is causing the -EAGAIN return value [1].

If that's the case, how does retrying KVM_RUN solve the issue? Just trying to
get to the bottom of it, because there's not much detail in the docs.

[1] https://elixir.bootlin.com/linux/v6.15-rc3/source/arch/x86/kvm/x86.c#L11532


Thanks,
Alex

> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  include/kvm/kvm-cpu.h |  2 +-
>  kvm-cpu.c             | 17 ++++++++++++-----
>  2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/include/kvm/kvm-cpu.h b/include/kvm/kvm-cpu.h
> index 8f76f8a1123a..72cbb86e6cef 100644
> --- a/include/kvm/kvm-cpu.h
> +++ b/include/kvm/kvm-cpu.h
> @@ -16,7 +16,7 @@ void kvm_cpu__delete(struct kvm_cpu *vcpu);
>  void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu);
>  void kvm_cpu__setup_cpuid(struct kvm_cpu *vcpu);
>  void kvm_cpu__enable_singlestep(struct kvm_cpu *vcpu);
> -void kvm_cpu__run(struct kvm_cpu *vcpu);
> +int kvm_cpu__run(struct kvm_cpu *vcpu);
>  int kvm_cpu__start(struct kvm_cpu *cpu);
>  bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu);
>  int kvm_cpu__get_endianness(struct kvm_cpu *vcpu);
> diff --git a/kvm-cpu.c b/kvm-cpu.c
> index 40041a22b3fe..7abbdcebf075 100644
> --- a/kvm-cpu.c
> +++ b/kvm-cpu.c
> @@ -35,27 +35,32 @@ void kvm_cpu__enable_singlestep(struct kvm_cpu *vcpu)
>  		pr_warning("KVM_SET_GUEST_DEBUG failed");
>  }
>  
> -void kvm_cpu__run(struct kvm_cpu *vcpu)
> +/*
> + * return value -1 if we need to call the kvm_cpu__run again without checking
> + * exit_reason. return value 0 results in taking action based on exit_reason.
> + */
> +int kvm_cpu__run(struct kvm_cpu *vcpu)
>  {
>  	int err;
>  
>  	if (!vcpu->is_running)
> -		return;
> +		return -1;
>  
>  	err = ioctl(vcpu->vcpu_fd, KVM_RUN, 0);
>  	if (err < 0) {
>  		switch (errno) {
>  		case EINTR:
>  		case EAGAIN:
> -			return;
> +			return -1;
>  		case EFAULT:
>  			if (vcpu->kvm_run->exit_reason == KVM_EXIT_MEMORY_FAULT)
> -				return;
> +				return 0;
>  			/* fallthrough */
>  		default:
>  			die_perror("KVM_RUN failed");
>  		}
>  	}
> +	return 0;
>  }
>  
>  static void kvm_cpu_signal_handler(int signum)
> @@ -179,7 +184,9 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
>  		if (cpu->task)
>  			kvm_cpu__run_task(cpu);
>  
> -		kvm_cpu__run(cpu);
> +		if (kvm_cpu__run(cpu) == -1)
> +			/* retry without an exit_reason check */
> +			continue;
>  
>  		switch (cpu->kvm_run->exit_reason) {
>  		case KVM_EXIT_UNKNOWN:
> -- 
> 2.43.0
> 
> 

