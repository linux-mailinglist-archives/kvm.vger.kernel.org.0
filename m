Return-Path: <kvm+bounces-53711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8041B1576E
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 04:07:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A0331895730
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 02:08:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77FF41ACED7;
	Wed, 30 Jul 2025 02:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I2VUgDBS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0806C156CA;
	Wed, 30 Jul 2025 02:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753841267; cv=none; b=OG3SI3uEvc1HaqxlzzyGPzCbkWlunatCS2vrdw2ZRJiMpadhKupsGu8FhsorFSUUY701AYZD0aP5EkPqG0nN2IHOzPJoMQYkUtSCbc0MMLMJt30GxF//tClQeCe9o0mK3cZS291m2rWqBEhUml5AWDwBP/DnTu5YHvvoHzspbi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753841267; c=relaxed/simple;
	bh=v6dnOhkoR0tGYQVmkdgXvFqmTTm7IALBGWk838ffNfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AjKECUfJ8T9UE1/s00Cbpg+8IsvVlfAz34/L3JuvgcuIWFQaY3/mnkt85GwvssGrh30QLZBJJIa2qJ9+I8pasv5Cj2hRSeJGDW2DeBHTOMGdGlaqsM2Uj7te6mFJ5AD+4CLPUFcNUqfcoyCGvxOtSQwAm0kxWu8liTGgbYhKBwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I2VUgDBS; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753841266; x=1785377266;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=v6dnOhkoR0tGYQVmkdgXvFqmTTm7IALBGWk838ffNfw=;
  b=I2VUgDBS8FimErInLsf+MZbD39M1XthB8QoceKtvCCJOxiHQT3O0jFUP
   7gv6j3Z03Qr3uN4VyXBjFFd2PEeUNPWLQdx5BCSUFvU/G+jOpOioQ8aGV
   6AGivzoHDSLVnn9yGONtcf/MSVVoODdxaF7QaqLIlZPZKewIjnBuKb3kv
   ZEV7tm9hTtwjUSDV+NcNk3eGy80kPyKD+iymeEKMtWKu+eC3xmdUC5zj2
   pR5mZdZud8RcPUtyR9Gn6b+dPV1cZUQDRPpdw5e/Brsc36a1DA8MnTVK0
   d/f3V135j7HdEiDASAXscUoBI647G1j1R7fHtb1n3TEn+Fgc2+HxysXmP
   g==;
X-CSE-ConnectionGUID: RajVa/SFTPeT9QT+dO4ylg==
X-CSE-MsgGUID: u9ft46tPTR2CJ6vzQtpfRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="59956662"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="59956662"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 19:07:43 -0700
X-CSE-ConnectionGUID: MoMgqtUNQ0OE3upc11w1ig==
X-CSE-MsgGUID: SBJJE9KuRWKMlW9/gXJRzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="186526908"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 19:07:39 -0700
Message-ID: <1b0ea352-c645-461b-9e19-5202791f8e2d@intel.com>
Date: Wed, 30 Jul 2025 10:07:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Adrian Hunter <adrian.hunter@intel.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Nikolay Borisov <nik.borisov@suse.com>
References: <20250729193341.621487-1-seanjc@google.com>
 <20250729193341.621487-3-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250729193341.621487-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/2025 3:33 AM, Sean Christopherson wrote:
> Exit to userspace with -EFAULT and a valid MEMORY_FAULT exit if a vCPU
> hits an unexpected pending S-EPT Violation instead of marking the VM dead.
> While it's unlikely the VM can continue on, whether or not to terminate
> the VM is not KVM's decision to make.
> 
> Set memory_fault.size to zero to communicate to userspace that reported
> fault is "bad", and to effectively terminate the VM if userspace blindly
> treats the exit as a conversion attempt (KVM_SET_MEMORY_ATTRIBUTES will
> fail with -EINVAL if the size is zero).

This sets a special contract on size zero.

I had a patch internally, which introduce a new exit type:

+               /* KVM_EXIT_GUEST_ERROR */
+               struct {
+  #define KVM_GUEST_ERROR_TDX_ACCESS_PENDING_PAGE      0
+                       __u32 error_type;
+                       __u32 ndata;
+                       __u64 data[16];
+               } guest_error;

how about it?

> Opportunistically delete the pr_warn(), which could be abused to spam the
> kernel log, and is largely useless outside of interact debug as it doesn't
> specify which VM encountered a failure.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 3e0d4edee849..c2ef03f39c32 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1937,10 +1937,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>   
>   	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
>   		if (tdx_is_sept_violation_unexpected_pending(vcpu)) {
> -			pr_warn("Guest access before accepting 0x%llx on vCPU %d\n",
> -				gpa, vcpu->vcpu_id);
> -			kvm_vm_dead(vcpu->kvm);
> -			return -EIO;
> +			kvm_prepare_memory_fault_exit(vcpu, gpa, 0, true, false, true);
> +			return -EFAULT;
>   		}
>   		/*
>   		 * Always treat SEPT violations as write faults.  Ignore the


