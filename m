Return-Path: <kvm+bounces-44573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70801A9F280
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 15:37:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE01C17D781
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 13:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 346CE26B0BF;
	Mon, 28 Apr 2025 13:37:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E003C26AA83
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 13:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745847458; cv=none; b=Yf9/+OmjM17MN03xa8m7hNN76wKsH5ldRemMNIuzTtu2fsp5fWkdQecj3U0jbKfk7ZcpX/2p02Kn4ZKB9ryTo2YoStWEyEPqQnG9h6joBdzocOrUAMyXOAlhX5azagQuOM1emeUevp9xEsQ9SYdTshCX7GHsrStfB65tj0TqafQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745847458; c=relaxed/simple;
	bh=X1xSRHTB0PyWf/pfUW0jATiHdpAptbsL/b7Yy/v+ng0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YAakmom2yj7k+rdxlo0YCu9O4vHk/DHxvE+iGlU1L7YbDroXY60BfnXsjlQ9w8gnq1dUiLm1I5m09Ti42xyD4hxBEKqKjRnZX+TM4kBE4Mhkdh/pLodiP7HPp2x7u1dKa1hICV4Cpc7HLVzVias18dSJ3DLHWfxbH5zuHl6XimI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B94131516;
	Mon, 28 Apr 2025 06:37:29 -0700 (PDT)
Received: from [10.1.37.44] (Suzukis-MBP.cambridge.arm.com [10.1.37.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 478833F673;
	Mon, 28 Apr 2025 06:37:35 -0700 (PDT)
Message-ID: <9e2fe85c-f3ad-4e13-b635-78a80c115499@arm.com>
Date: Mon, 28 Apr 2025 14:37:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v3 2/3] cpu: vmexit: Retry KVM_RUN ioctl on EINTR
 and EAGAIN
Content-Language: en-GB
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org
Cc: Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20250428115745.70832-1-aneesh.kumar@kernel.org>
 <20250428115745.70832-3-aneesh.kumar@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250428115745.70832-3-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Aneesh

On 28/04/2025 12:57, Aneesh Kumar K.V (Arm) wrote:
> When KVM_RUN fails with EINTR or EAGAIN, we should retry the ioctl
> without checking kvm_run->exit_reason. These errors don't indicate a
> valid VM exit, hence exit_reason may contain stale or undefined values.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>   include/kvm/kvm-cpu.h |  2 +-
>   kvm-cpu.c             | 17 ++++++++++++-----
>   2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/include/kvm/kvm-cpu.h b/include/kvm/kvm-cpu.h
> index 8f76f8a1123a..72cbb86e6cef 100644
> --- a/include/kvm/kvm-cpu.h
> +++ b/include/kvm/kvm-cpu.h
> @@ -16,7 +16,7 @@ void kvm_cpu__delete(struct kvm_cpu *vcpu);
>   void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu);
>   void kvm_cpu__setup_cpuid(struct kvm_cpu *vcpu);
>   void kvm_cpu__enable_singlestep(struct kvm_cpu *vcpu);
> -void kvm_cpu__run(struct kvm_cpu *vcpu);
> +int kvm_cpu__run(struct kvm_cpu *vcpu);
>   int kvm_cpu__start(struct kvm_cpu *cpu);
>   bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu);
>   int kvm_cpu__get_endianness(struct kvm_cpu *vcpu);
> diff --git a/kvm-cpu.c b/kvm-cpu.c
> index 40041a22b3fe..7abbdcebf075 100644
> --- a/kvm-cpu.c
> +++ b/kvm-cpu.c
> @@ -35,27 +35,32 @@ void kvm_cpu__enable_singlestep(struct kvm_cpu *vcpu)
>   		pr_warning("KVM_SET_GUEST_DEBUG failed");
>   }
>   
> -void kvm_cpu__run(struct kvm_cpu *vcpu)
> +/*
> + * return value -1 if we need to call the kvm_cpu__run again without checking
> + * exit_reason. return value 0 results in taking action based on exit_reason.
> + */

minor nit: Should we make the return value meaningful, say -EAGAIN 
instead of -1 ?

> +int kvm_cpu__run(struct kvm_cpu *vcpu)
>   {
>   	int err;
>   
>   	if (!vcpu->is_running)
> -		return;
> +		return -1;
>   
>   	err = ioctl(vcpu->vcpu_fd, KVM_RUN, 0);
>   	if (err < 0) {
>   		switch (errno) {
>   		case EINTR:
>   		case EAGAIN:
> -			return;
> +			return -1;
>   		case EFAULT:
>   			if (vcpu->kvm_run->exit_reason == KVM_EXIT_MEMORY_FAULT)
> -				return;
> +				return 0;
>   			/* fallthrough */
>   		default:
>   			die_perror("KVM_RUN failed");
>   		}
>   	}
> +	return 0;
>   }
>   
>   static void kvm_cpu_signal_handler(int signum)
> @@ -179,7 +184,9 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
>   		if (cpu->task)
>   			kvm_cpu__run_task(cpu);
>   
> -		kvm_cpu__run(cpu);
> +		if (kvm_cpu__run(cpu) == -1)

and this could be :
		if (kvm_cpu__run(cpu) == -EAGAIN)

> +			/* retry without an exit_reason check */
> +			continue;
>   
>   		switch (cpu->kvm_run->exit_reason) {
>   		case KVM_EXIT_UNKNOWN:


Suzuki

