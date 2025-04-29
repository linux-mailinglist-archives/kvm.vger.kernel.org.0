Return-Path: <kvm+bounces-44729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71473AA0939
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:07:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 711865A466E
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 11:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356432BEC43;
	Tue, 29 Apr 2025 11:07:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 434291F4199
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 11:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745924828; cv=none; b=QDdf59Ym+b8ajZPVQ8rnmawKqg7wGdP4xzHd1FFnSjbTzg8yK5di6qcVXPyCe2xTBuL/gY/lrW3MsAuhKrYllWIyAt6bK0g2UW4cvqocBAKz14jEd883RA65Q84g5rjyV6+ZShVTphzBMhzyINA3vjK+yd9ooz16cR0kZbQKaVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745924828; c=relaxed/simple;
	bh=BtnjGgaY+VV+X8aDM08nDPwStubsM0m3DM7ZBIxA7Bs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UygvAwupTp9nM62iLrimNTS/x4o60+7r7YidmaG1jl9lvDeukJ1PDJPm4GPtTVS3DIjckZpvRrMMxenQfyruhZlybm8aCqK6H5dLfUVLPa/eu2xD9usLw5E90U9cLw6caxuRZcqu1RPBoQ2jqPIkZpQBugz/GAmBUJ+Nm82tAU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8FCB1515;
	Tue, 29 Apr 2025 04:06:59 -0700 (PDT)
Received: from [10.1.33.43] (Suzukis-MBP.cambridge.arm.com [10.1.33.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A49F33F673;
	Tue, 29 Apr 2025 04:07:05 -0700 (PDT)
Message-ID: <b332d78b-c81e-45ea-b319-12826401e630@arm.com>
Date: Tue, 29 Apr 2025 12:07:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v3 1/3] cpu: vmexit: Handle KVM_EXIT_MEMORY_FAULT
 in KVM_RUN ioctl return
Content-Language: en-GB
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org
Cc: Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
References: <20250428115745.70832-1-aneesh.kumar@kernel.org>
 <20250428115745.70832-2-aneesh.kumar@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250428115745.70832-2-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28/04/2025 12:57, Aneesh Kumar K.V (Arm) wrote:
> Linux kernel documentation states:
> 
> "Note! KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in
> that it accompanies a return code of '-1', not '0'! errno will always be
> set to EFAULT or EHWPOISON when KVM exits with KVM_EXIT_MEMORY_FAULT,
> userspace should assume kvm_run.exit_reason is stale/undefined for all
> other error numbers." "
> 
> Update KVM_RUN ioctl error handling to correctly handle
> KVM_EXIT_MEMORY_FAULT. This enables the memory fault exit handlers in
> the kernel to return -EFAULT as the return value. VMM support is
> still required to handle these memory fault exits, but that is not
> included in this change
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>   kvm-cpu.c | 15 +++++++++++++--
>   kvm.c     |  1 +
>   2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/kvm-cpu.c b/kvm-cpu.c
> index 7362f2e99261..40041a22b3fe 100644
> --- a/kvm-cpu.c
> +++ b/kvm-cpu.c
> @@ -43,8 +43,19 @@ void kvm_cpu__run(struct kvm_cpu *vcpu)
>   		return;
>   
>   	err = ioctl(vcpu->vcpu_fd, KVM_RUN, 0);
> -	if (err < 0 && (errno != EINTR && errno != EAGAIN))
> -		die_perror("KVM_RUN failed");
> +	if (err < 0) {
> +		switch (errno) {
> +		case EINTR:
> +		case EAGAIN:
> +			return;
> +		case EFAULT:

Do we need to handle EHWPOISON too, as per the API ?


Suzuki


> +			if (vcpu->kvm_run->exit_reason == KVM_EXIT_MEMORY_FAULT)
> +				return;
> +			/* fallthrough */
> +		default:
> +			die_perror("KVM_RUN failed");


> +		}
> +	}
>   }
>   
>   static void kvm_cpu_signal_handler(int signum)
> diff --git a/kvm.c b/kvm.c
> index 07089cf1b332..b6375a114d11 100644
> --- a/kvm.c
> +++ b/kvm.c
> @@ -55,6 +55,7 @@ const char *kvm_exit_reasons[] = {
>   #ifdef CONFIG_PPC64
>   	DEFINE_KVM_EXIT_REASON(KVM_EXIT_PAPR_HCALL),
>   #endif
> +	DEFINE_KVM_EXIT_REASON(KVM_EXIT_MEMORY_FAULT),
>   };
>   
>   static int pause_event;


