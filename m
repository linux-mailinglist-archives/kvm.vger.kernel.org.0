Return-Path: <kvm+bounces-40945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8108DA5FA1A
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:38:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84E253BD7DB
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 15:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A41268C43;
	Thu, 13 Mar 2025 15:38:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09446267F4F
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 15:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741880280; cv=none; b=p1oK4Y2A9QYGNRIM1MHiEmgqZhm9xyY8NqIxNQdFicqBUmkevbu4oNEzpMP/5MHTpzA4ddlDeZA0+dAAqZ0avwv0wU91ETR7NdCk+vroEZv/4VqIIrmTBIcfYP+voLrXensPRG1WvEiIdpujOl7rnpEgtKw9dCDPRTB3Fnv/9TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741880280; c=relaxed/simple;
	bh=0+ztpTLWwA3UfBqOqdohU477kKuJF8BeqYacH8r0enk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F9HkijapnXiFMGLsYgHViaDRRyX7WB4zWyzJ58U3q4JlvnCBa5/Vwtdl5H9W3RfN0i6iwg9RFcHf2p6Pf9hQ5fi1FYGM4L6vN0lwwv4J3S5h+l6ubg+E4wwAC5/mRB3PkYIiw++CMy1St/fcM8ujRI4vhEZYnQsQ5XVCk9rObsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE1851477;
	Thu, 13 Mar 2025 08:38:08 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 511DB3F694;
	Thu, 13 Mar 2025 08:37:57 -0700 (PDT)
Date: Thu, 13 Mar 2025 15:37:54 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool v2 2/2] cpu: vmexit: Handle KVM_EXIT_MEMORY_FAULT
 in KVM_RUN ioctl return
Message-ID: <Z9L70uG0cUho_A9r@raptor>
References: <20250224091000.3925918-1-aneesh.kumar@kernel.org>
 <20250224091000.3925918-2-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224091000.3925918-2-aneesh.kumar@kernel.org>

Hi Aneesh,

On Mon, Feb 24, 2025 at 02:40:00PM +0530, Aneesh Kumar K.V (Arm) wrote:
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

I think this is too much information. Are all architectures that kvmtool
supports going to/have implemented forwarding memory faults to userspace
this same way? I would think not.

The first paragraph should be enough - kvmtool implements the KVM ABI, it
shouldn't care about how that is implemented by KVM.

Other than that, looks correct to me, and more readable (but that might
just be my personal bias):

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> still required to handle these memory fault exits, but that is not
> included in this change
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  kvm-cpu.c | 15 +++++++++++++--
>  kvm.c     |  1 +
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/kvm-cpu.c b/kvm-cpu.c
> index 7c62bfc56679..c0b10b1534ab 100644
> --- a/kvm-cpu.c
> +++ b/kvm-cpu.c
> @@ -41,8 +41,19 @@ void kvm_cpu__run(struct kvm_cpu *vcpu)
>  		return;
>  
>  	err = ioctl(vcpu->vcpu_fd, KVM_RUN, 0);
> -	if (err < 0 && (errno != EINTR && errno != EAGAIN))
> -		die_perror("KVM_RUN failed");
> +	if (err < 0) {
> +		switch (errno) {
> +		case EINTR:
> +		case EAGAIN:
> +			return;
> +		case EFAULT:
> +			if (vcpu->kvm_run->exit_reason == KVM_EXIT_MEMORY_FAULT)
> +				return;
> +			/* faullthrough */
> +		default:
> +			die_perror("KVM_RUN failed");
> +		}
> +	}
>  }
>  
>  static void kvm_cpu_signal_handler(int signum)
> diff --git a/kvm.c b/kvm.c
> index 42b881217df6..172d951bfe4e 100644
> --- a/kvm.c
> +++ b/kvm.c
> @@ -55,6 +55,7 @@ const char *kvm_exit_reasons[] = {
>  #ifdef CONFIG_PPC64
>  	DEFINE_KVM_EXIT_REASON(KVM_EXIT_PAPR_HCALL),
>  #endif
> +	DEFINE_KVM_EXIT_REASON(KVM_EXIT_MEMORY_FAULT),
>  };
>  
>  static int pause_event;
> -- 
> 2.43.0
> 

