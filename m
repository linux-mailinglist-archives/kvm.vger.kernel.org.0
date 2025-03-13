Return-Path: <kvm+bounces-40943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F246BA5FA12
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4184D167D92
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 15:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E58C267F64;
	Thu, 13 Mar 2025 15:37:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 836A2282FA
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 15:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741880237; cv=none; b=aHUgLcXSwvqRX3wGVtl2eJ0X/EVpuGUjQFhDx1fcKFGSuxTKFfhBWF9UknIiR64DLXTWluJGYCxhxKv+8Mjr8Z6YWQzpPEq8VHYicWJX/kNG+7Xui/SdGf/c4D6fctWN9Ls/HGY8ei/I297dCxQNYoChxYiV/kMxL+HnBPZ+fGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741880237; c=relaxed/simple;
	bh=lj70Vcf5P1FiVkunK6lCCECN3JyROdomusxRD8izs84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d//qbVcA90o3+4Fop5WIQN6eWuW4g+4bq14dHBWHIBT1BPf6B8ZliJBPphCMmy4vyfmgdzkfoLZmIBF4WNvEy6rkd/soiuDTHA9+akbua5UpnCDDOdptNgjBVF1xhrDblIW80YbP9Ur4tL0zyd5Y1gK1AKFb8hiqPaXXtH7gsY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24E5A1477;
	Thu, 13 Mar 2025 08:37:26 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6F9F3F694;
	Thu, 13 Mar 2025 08:37:14 -0700 (PDT)
Date: Thu, 13 Mar 2025 15:37:12 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool v2 1/2] cpu: vmexit: Handle KVM_EXIT_UNKNOWN exit
 reason correctly
Message-ID: <Z9L7qH_Xv2Co4KM7@raptor>
References: <20250224091000.3925918-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224091000.3925918-1-aneesh.kumar@kernel.org>

Hi Aneesh,

On Mon, Feb 24, 2025 at 02:39:59PM +0530, Aneesh Kumar K.V (Arm) wrote:
> The return value for kernel VM exit handlers is confusing and has led to
> errors in different kernel exit handlers. A return value of 0 indicates
> a return to the VMM, whereas a return value of 1 indicates resuming
> execution in the guest. Some handlers mistakenly return 0 to force a
> return to the guest.
> 
> This worked in kvmtool because the exit_reason defaulted to
> 0 (KVM_EXIT_UNKNOWN), and kvmtool did not error out on an unknown exit
> reason. However, forcing a VMM exit with error on KVM_EXIT_UNKNOWN
> exit_reson would help catch these bugs early.

I think I understand what you're saying - if there's a bug in handle_exit()
in KVM that triggers an erroneous exit to userspace, exit_reason and the
exit information struct could still be at their default values, which are 0
from when kvm_run was allocated (in kvm_vm_ioctl_create_vcpu()).

An exit_reason of 0 is interpreted by userspace as KVM_EXIT_UNKNOWN, but
kvmtool on KVM_EXIT_UNKNOWN resumes the guest instead of signalling the
error, thus masking the buggy KVM behaviour.

The patch looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  kvm-cpu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kvm-cpu.c b/kvm-cpu.c
> index f66dcd07220c..7c62bfc56679 100644
> --- a/kvm-cpu.c
> +++ b/kvm-cpu.c
> @@ -170,7 +170,7 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
>  
>  		switch (cpu->kvm_run->exit_reason) {
>  		case KVM_EXIT_UNKNOWN:
> -			break;
> +			goto panic_kvm;
>  		case KVM_EXIT_DEBUG:
>  			kvm_cpu__show_registers(cpu);
>  			kvm_cpu__show_code(cpu);
> -- 
> 2.43.0
> 

