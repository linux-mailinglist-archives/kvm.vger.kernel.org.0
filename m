Return-Path: <kvm+bounces-20460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF978916261
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 11:33:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F91D1F235CD
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 09:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A962149DF7;
	Tue, 25 Jun 2024 09:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U1LQbRSc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26CA149C5A
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 09:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308014; cv=none; b=FFxb2wLLaeXZ4xHHlRAjO4yx3HfZ7PdR/3LIIxEcXCIGKqE0hY6Kxg0irXVtHIeMDhwTrfaF5LxxvsN25GJzn3a89D/cy15v9Ki9/cdaAp7dVw6N6inxMf/sqZdDvuDxwwbVlFBcHbRf27jEwJKQ8NDrDHSHwfLFBy8j8r+b4yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308014; c=relaxed/simple;
	bh=/EBGKUq/bPwKFGVxQK4hCA1mKw9MM/cSXI/gZArZTl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UkBpveJ9fW9uAxAaXvWOgeFo4pHPtB50OCp/VkPaXqZlkATFsPBVeqeOhZY3UVsFhglNaBz3Mx7VCc80giZxYQI5dp0xlXZkDzql/WFQD8N97980Ugb9olLZDcJG4HggAWCiu6TWVpwo4/AVXjwHrr5tpfTc+GBp7KMFpZcKc2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U1LQbRSc; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719308013; x=1750844013;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/EBGKUq/bPwKFGVxQK4hCA1mKw9MM/cSXI/gZArZTl0=;
  b=U1LQbRSc/7FUcX4GL6Yn3m4AmeCuKzXJ0+tqCdmTjAcS2EWdqVeqd67R
   UI69MY+jWkzij2IN0YIQpKjiXdoTewDvoq6ElR8RvfSqGqQfGkfevk9kt
   GGekY3G6/nK/MqmsGXqGHWJxBVuF7z3yQKIuD51+C0h/zDb+JhY5IK5p2
   Lgbc+326bwbOos91cEVgTc+G0Amnit1I5VO4vF44utbrwkdDXPJKseGrh
   rjRLxTswiY+6Xv9/FQZYHuBJN3+Xny4lTGONODRNEjVpxPo4KVf4RK24o
   GINR7s0iO3getOvLOjH5SPS1ldvMnC7Qr3iHWlw7EhN/9Dcose2qXHBCA
   A==;
X-CSE-ConnectionGUID: QM4fAFfDSoq3g2tyKiDbRQ==
X-CSE-MsgGUID: +5fGSwg1RFK58j+id20TXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11113"; a="16189564"
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="16189564"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 02:33:32 -0700
X-CSE-ConnectionGUID: b5DvKGjFR2qbuNMfbmZCxA==
X-CSE-MsgGUID: Y6TWtXF1TwGaEfs0FJSv6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="48557661"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa005.jf.intel.com with ESMTP; 25 Jun 2024 02:33:30 -0700
Date: Tue, 25 Jun 2024 17:49:03 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: EwanHai <ewanhai-oc@zhaoxin.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, pbonzini@redhat.com,
	mtosatti@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
	ewanhai@zhaoxin.com, cobechen@zhaoxin.com
Subject: Re: [PATCH v3] target/i386/kvm: Refine VMX controls setting for
 backward compatibility
Message-ID: <ZnqSj4PGrUeZ7OT1@intel.com>
References: <20240624095806.214525-1-ewanhai-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624095806.214525-1-ewanhai-oc@zhaoxin.com>

On Mon, Jun 24, 2024 at 05:58:06AM -0400, EwanHai wrote:
> Date: Mon, 24 Jun 2024 05:58:06 -0400
> From: EwanHai <ewanhai-oc@zhaoxin.com>
> Subject: [PATCH v3] target/i386/kvm: Refine VMX controls setting for
>  backward compatibility
> X-Mailer: git-send-email 2.34.1
> 
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
> kernels(4.17~5.2) where `MSR_IA32_VMX_PROCBASED_CTLS2` is in
> `kvm_feature_msrs`-obtained by ioctl(KVM_GET_MSR_FEATURE_INDEX_LIST),
> but not in `kvm_msr_list`-obtained by ioctl(KVM_GET_MSR_INDEX_LIST).
> As a result,it did not set the `has_msr_vmx_procbased_clts2` flag based
> on `kvm_msr_list` alone, even though KVM does maintain the value of
> this MSR.
> 
> This patch supplements the above logic, ensuring that
> `has_msr_vmx_procbased_clts2` is correctly set by checking both MSR
> lists, thus maintaining compatibility with older kernels.
> 
> Signed-off-by: EwanHai <ewanhai-oc@zhaoxin.com>
> ---
> Changes in v3:
> - Use a more precise version range in the comment, specifically "4.17~5.2"
> instead of "<5.3".
> 
> Changes in v2:
> - Adjusted some punctuation in the commit message as per suggestions.
> - Added comments to the newly added code to indicate that it is a compatibility fix.
> 
> v1 link:
> https://lore.kernel.org/all/20230925071453.14908-1-ewanhai-oc@zhaoxin.com/
> 
> v2 link:
> https://lore.kernel.org/all/20231127034326.257596-1-ewanhai-oc@zhaoxin.com/
> ---
>  target/i386/kvm/kvm.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 7ad8072748..a7c6c5b2d0 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2386,6 +2386,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
>  static int kvm_get_supported_feature_msrs(KVMState *s)
>  {
>      int ret = 0;
> +    int i;
>  
>      if (kvm_feature_msrs != NULL) {
>          return 0;
> @@ -2420,6 +2421,20 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
>          return ret;
>      }
>  
> +   /*
> +    * Compatibility fix:
> +    * Older Linux kernels (4.17~5.2) report MSR_IA32_VMX_PROCBASED_CTLS2
> +    * in KVM_GET_MSR_FEATURE_INDEX_LIST but not in KVM_GET_MSR_INDEX_LIST.
> +    * This leads to an issue in older kernel versions where QEMU,
> +    * through the KVM_GET_MSR_INDEX_LIST check, assumes the kernel
> +    * doesn't maintain MSR_IA32_VMX_PROCBASED_CTLS2, resulting in
> +    * incorrect settings by QEMU for this MSR.
> +    */
> +    for (i = 0; i < kvm_feature_msrs->nmsrs; i++) {

nit: `i` could be declared here,

for (int i = 0; i < kvm_feature_msrs->nmsrs; i++) {

> +        if (kvm_feature_msrs->indices[i] == MSR_IA32_VMX_PROCBASED_CTLS2) {
> +            has_msr_vmx_procbased_ctls2 = true;
> +        }
> +    }
>      return 0;
>  }
>  
> -- 
> 2.34.1
>

Since the minimum KVM version supported for i386 is v4.5 (docs/system/
target-i386.rst), this fix makes sense, so for this patch,

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

Additionally, has_msr_vmx_vmfunc has the similar compat issue. I think
it deserves a fix, too.

-Zhao


