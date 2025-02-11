Return-Path: <kvm+bounces-37858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2875EA30B86
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 13:16:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BBA81883366
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A845824C69C;
	Tue, 11 Feb 2025 12:12:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569BE1FBEAB
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 12:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739275976; cv=none; b=SDLtVwucGVjBQljl5VLFw4j7052WdcytTMXKOj2edeYyH/ClufELGP7WfZeU9GECckjQR7E28HvZRXCUZAu3Ml9xT8+yA8NMmfAPNNLGKJbuVRNt7PcMz84KWQydsvyGEbI+n7ywEhWvbAKoz1gZ3km68J5JXnC7ZTEGI/YBksc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739275976; c=relaxed/simple;
	bh=BnhX5OYAVXAUR9k9wLm8MZaCUO0tNvzkVmT5cMvtcWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LDrcNM2+JUXAsgQYHCQUME/2kRbV/mAhrxj9vpAjQpQSLmLMRlbmbn5xWBD5aCAgCyq+giI4bQs6Jz/Z/mhKTd8PVMXbgT6vS6v6aRDgi3IMNufXYiHr4v1qhzfDP3Prq3tfbbmTXSVqBfLBDt7ZKW/y8RiglX8bhhCEYUHDbWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30E251424;
	Tue, 11 Feb 2025 04:13:15 -0800 (PST)
Received: from arm.com (e134078.arm.com [10.1.26.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 489E13F6A8;
	Tue, 11 Feb 2025 04:12:52 -0800 (PST)
Date: Tue, 11 Feb 2025 12:12:48 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool 1/2] cpu: vmexit: Handle KVM_EXIT_UNKNOWN exit
 reason correctly
Message-ID: <Z6s+s4hCZwoR8uod@arm.com>
References: <20250211073852.571625-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211073852.571625-1-aneesh.kumar@kernel.org>

Hi,

On Tue, Feb 11, 2025 at 01:08:51PM +0530, Aneesh Kumar K.V (Arm) wrote:
> The return value for the KVM_RUN ioctl is confusing and has led to
> errors in different kernel exit handlers. A return value of 0 indicates
> a return to the VMM, whereas a return value of 1 indicates resuming
> execution in the guest. Some handlers mistakenly return 0 to force a
> return to the guest.

I find this paragraph confusing. KVM_RUN, as per the documentation, returns 0 or
-1 (on error). As far as I can tell, at least on arm64, KVM_RUN can never return
1.

Are you referring to the loop in kvm_arch_vcpu_ioctl_run() by any chance? That's
the only place I found where a value of 1 from the handlers signifies return to
the guest.

> 
> This worked in kvmtool because the exit_reason defaulted to
> 0 (KVM_EXIT_UNKNOWN), and kvmtool did not error out on an unknown exit
> reason. However, forcing a KVM panic on an unknown exit reason would
> help catch these bugs early.

I would hope that a VMM cannot force KVM to panic at will, which will bring down
the host. Are you referring to kvmtool exiting with an error? That's what the
unfortunately named 'panic_kvm' label seems to be doing.

Thanks,
Alex

> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  kvm-cpu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kvm-cpu.c b/kvm-cpu.c
> index f66dcd07220c..66e30ba54e26 100644
> --- a/kvm-cpu.c
> +++ b/kvm-cpu.c
> @@ -170,6 +170,7 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
>  
>  		switch (cpu->kvm_run->exit_reason) {
>  		case KVM_EXIT_UNKNOWN:
> +			goto panic_kvm;
>  			break;
>  		case KVM_EXIT_DEBUG:
>  			kvm_cpu__show_registers(cpu);
> 
> base-commit: 6d754d01fe2cb366f3b636d8a530f46ccf3b10d8
> -- 
> 2.43.0
> 
> 

