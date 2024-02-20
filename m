Return-Path: <kvm+bounces-9138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 09D8985B54A
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:32:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E80AB225CD
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 08:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25C645D460;
	Tue, 20 Feb 2024 08:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k5Fk98FK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8E05B1F1
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 08:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708417947; cv=none; b=mGXTiz/H7HRssVd1IfMVP15014Y+Q0rBSoPsk2MXlFuBTO0gs5LML6pU/o/fFTEpPL272/s09BcgdPSPYCrsdIx6WjNsY4b/N+pcHM2Y0HvagTJLz7x73yKk6ZmqcAS0/bDhohoRrPbfatPaHdMTZXCnQz+Ec/110QtLqKhJSZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708417947; c=relaxed/simple;
	bh=4i3wXuUUCZl45VDOs9eLSI3djwSURdciX6oeG3Vvx9M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ijydORr4eLEtRjv2/v0as+o9VNCfS829UTYJUPau+vo/bIufsqvj/9ckPLFrIjAMc04k/NuHoCuVnG8LV45y5tOPWbFKZxA76lqmGCVuOPF+VleLWDA0WZP9dGccwFz8EyyeseTDrqjgIqu7lWUHyLvwGnNX5rzXXq/QR2rtMqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k5Fk98FK; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708417945; x=1739953945;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4i3wXuUUCZl45VDOs9eLSI3djwSURdciX6oeG3Vvx9M=;
  b=k5Fk98FKn7jcd6zm5QRfgKy0pKsSbqmCgyIrTzo/egy/RaG//bc9NmiI
   /9E6z1eg+tp5GQI691XvMxLIaw/TEiqkHPN8NM2vNggtEjFRnisZwP6D/
   0cyEpHJpex2tcJNVSUNmpnW7beu/jdkX0JKsnPRPwFMa51VkQN8lCDo/C
   N0TY1AyYKe8jJvEoabC53ct/j7MEuEn1XDnoVc7Jld912JFHTRgQ+s9sn
   icXxpbX2OaiJGlRtOnU2qDDUy1e7C3b3zWW/+0yXjqT7FKRyxM0+SioEj
   e9LGCPIQ2boAMwRGtTN+BvNg99vpg38926XyK4x/hhFXDS+9Rp6BH/yqA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="20040933"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="20040933"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 00:32:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="4679611"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.12.199]) ([10.93.12.199])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 00:32:08 -0800
Message-ID: <b041fdb3-5b08-4a85-913a-ebb3c7dfbe1d@intel.com>
Date: Tue, 20 Feb 2024 16:32:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] target/i386/kvm: Refine VMX controls setting for
 backward compatibility
To: EwanHai <ewanhai-oc@zhaoxin.com>, pbonzini@redhat.com,
 mtosatti@redhat.com, kvm@vger.kernel.org, zhao1.liu@intel.com
Cc: qemu-devel@nongnu.org, cobechen@zhaoxin.com, ewanhai@zhaoxin.com
References: <20231127034326.257596-1-ewanhai-oc@zhaoxin.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20231127034326.257596-1-ewanhai-oc@zhaoxin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/2023 11:43 AM, EwanHai wrote:
> Commit 4a910e1 ("target/i386: do not set unsupported VMX secondary
> execution controls") implemented a workaround for hosts that have
> specific CPUID features but do not support the corresponding VMX
> controls, e.g., hosts support RDSEED but do not support RDSEED-Exiting.
> 
> In detail, commit 4a910e1 introduced a flag `has_msr_vmx_procbased_clts2`.
> If KVM has `MSR_IA32_VMX_PROCBASED_CTLS2` in its msr list, QEMU would
> use KVM's settings, avoiding any modifications to this MSR.
> 
> However, this commit (4a910e1) didn't account for cases in older Linux
> kernels(<5.3) where `MSR_IA32_VMX_PROCBASED_CTLS2` is in
> `kvm_feature_msrs`-obtained by ioctl(KVM_GET_MSR_FEATURE_INDEX_LIST),
> but not in `kvm_msr_list`-obtained by ioctl(KVM_GET_MSR_INDEX_LIST).
> As a result,it did not set the `has_msr_vmx_procbased_clts2` flag based
> on `kvm_msr_list` alone, even though KVM maintains the value of this MSR.
> 
> This patch supplements the above logic, ensuring that
> `has_msr_vmx_procbased_clts2` is correctly set by checking both MSR
> lists, thus maintaining compatibility with older kernels.
> 
> Signed-off-by: EwanHai <ewanhai-oc@zhaoxin.com>
> ---
> In response to the suggestions from ZhaoLiu(zhao1.liu@intel.com),
> the following changes have been implemented in v2:
> - Adjusted some punctuation in the commit message as per the
>    suggestions.
> - Added comments to the newly added code to indicate that it is a
>    compatibility fix.
> 
> v1 link:
> https://lore.kernel.org/all/20230925071453.14908-1-ewanhai-oc@zhaoxin.com/
> ---
>   target/i386/kvm/kvm.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 11b8177eff..c8f6c0b531 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2296,6 +2296,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
>   static int kvm_get_supported_feature_msrs(KVMState *s)
>   {
>       int ret = 0;
> +    int i;
>   
>       if (kvm_feature_msrs != NULL) {
>           return 0;
> @@ -2330,6 +2331,19 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
>           return ret;
>       }
>   
> +    /*
> +     * Compatibility fix:
> +     * Older Linux kernels(<5.3) include the MSR_IA32_VMX_PROCBASED_CTLS2

we can be more accurate, that kernel version 4.17 to 5.2, reports 
MSR_IA32_VMX_PROCBASED_CTLS2 in KVM_GET_MSR_FEATURE_INDEX_LIST but not 
KVM_GET_MSR_INDEX_LIST.

> +     * only in feature msr list, but not in regular msr list. This lead to
> +     * an issue in older kernel versions where QEMU, through the regular
> +     * MSR list check, assumes the kernel doesn't maintain this msr,
> +     * resulting in incorrect settings by QEMU for this msr.
> +     */
> +    for (i = 0; i < kvm_feature_msrs->nmsrs; i++) {
> +        if (kvm_feature_msrs->indices[i] == MSR_IA32_VMX_PROCBASED_CTLS2) {
> +            has_msr_vmx_procbased_ctls2 = true;
> +        }
> +    }

I'm wondering should we move all the initialization of has_msr_*, that 
associated with feature MSRs, to here. e.g., has_msr_arch_capabs, 
has_msr_vmx_vmfunc,...

>       return 0;
>   }
>   


