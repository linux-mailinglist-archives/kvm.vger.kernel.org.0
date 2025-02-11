Return-Path: <kvm+bounces-37859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B0AA30B8D
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 13:17:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 904F93AB8DD
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3CF214815;
	Tue, 11 Feb 2025 12:13:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A3BB20B81B
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 12:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739276018; cv=none; b=G4HyDG/ZpZfAXTL5MaL1V7Y3q7S8anuak+FlFG5UmSynX5nED/ig+42S4z0WgMQAWnCtjV5ClvokEnNYrkSOu5Zmspj+u4cp0Q+2TFV0X3Jlic0JQEd+7JGKKeszRtcpFEH+4vpG1Ta7Kj41MofEpgEPL7I3Qa5xKFunte+lGiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739276018; c=relaxed/simple;
	bh=E0IgkNGRYJFGuca1oZmExrkppwWiC10x8uG5FJy6gMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lvgbOZ5CMNAx2RpTvohSjFfHkj9LFFoBDVYwJDll4yJpezQIH2pPH5jZ5iEOVO/VTbZgJAsyMJ70HERyIYTyMNrPLd48Gl4bTz3T5M+o/KdBrZ2sSA7TzBP3LFIsZk1y+tNtxTg32Ichk2cCTOwzsUvRG5kpP1Tqd4YdbapMc8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B30421424;
	Tue, 11 Feb 2025 04:13:57 -0800 (PST)
Received: from arm.com (e134078.arm.com [10.1.26.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A89ED3F6A8;
	Tue, 11 Feb 2025 04:13:34 -0800 (PST)
Date: Tue, 11 Feb 2025 12:13:31 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool 2/2] cpu: vmexit: Handle KVM_EXIT_MEMORY_FAULT
 correctly
Message-ID: <Z6s+67ICINiO96US@arm.com>
References: <20250211073852.571625-1-aneesh.kumar@kernel.org>
 <20250211073852.571625-2-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211073852.571625-2-aneesh.kumar@kernel.org>

Hi,

On Tue, Feb 11, 2025 at 01:08:52PM +0530, Aneesh Kumar K.V (Arm) wrote:
> Linux kernel documentation states:
> 
> "Note! KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in
> that it accompanies a return code of '-1', not '0'! errno will always be
> set to EFAULT or EHWPOISON when KVM exits with KVM_EXIT_MEMORY_FAULT,
> userspace should assume kvm_run.exit_reason is stale/undefined for all
> other error numbers." "
> 
> Update the KVM_RUN ioctl error handling to correctly handle
> KVM_EXIT_MEMORY_FAULT.

I've tried to follow how kvmtool handles KVM_EXIT_MEMORY_FAULT before and after
this patch.

Before: calls die_perror().
After: prints more information about the error, in kvm_cpu_thread().

Is that what you want? Because "correctly handle KVM_EXIT_MEMORY_FAULT" can be
interpreted as kvmtool resolving the memory fault, which is something that
kvmtool does not do.

Also, can you update kvm_exit_reasons with KVM_EXIT_MEMORY_FAULT, because
otherwise kvm_cpu_thread() will segfault when it tries to access
kvm_exit_reasons[KVM_EXIT_MEMORY_FAULT].

Thanks,
Alex

> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  kvm-cpu.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/kvm-cpu.c b/kvm-cpu.c
> index 66e30ba54e26..40e4efc33a1d 100644
> --- a/kvm-cpu.c
> +++ b/kvm-cpu.c
> @@ -41,8 +41,15 @@ void kvm_cpu__run(struct kvm_cpu *vcpu)
>  		return;
>  
>  	err = ioctl(vcpu->vcpu_fd, KVM_RUN, 0);
> -	if (err < 0 && (errno != EINTR && errno != EAGAIN))
> -		die_perror("KVM_RUN failed");
> +	if (err < 0) {
> +		if (errno == EINTR || errno == EAGAIN)
> +			return;
> +		else if (errno == EFAULT &&
> +			 vcpu->kvm_run->exit_reason == KVM_EXIT_MEMORY_FAULT)
> +			return;
> +		else
> +			die_perror("KVM_RUN failed");
> +	}
>  }
>  
>  static void kvm_cpu_signal_handler(int signum)
> -- 
> 2.43.0
> 
> 

