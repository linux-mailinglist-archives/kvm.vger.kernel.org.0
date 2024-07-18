Return-Path: <kvm+bounces-21880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB24A9352E5
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 671CA2819D3
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1903D1459F8;
	Thu, 18 Jul 2024 21:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eVXKR1re"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EF51EA8F
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 21:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337058; cv=none; b=Q/fPZmkv92cWFxLYAE5PqWuN5lK2iSPRqIEPc2zwY8mh45SXhK31QLOax9g0fIv9RzK9BUeFTw8oYCpkmIX0T3dxoCqkHwuYiqWLgSV5zccm97kJ6j3C/YTZrX9YBx5BLcQ/xWnGf4lpNpM6urA/N4gaX5SZkl6LViVcSZK3dlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337058; c=relaxed/simple;
	bh=m0/N8F93ymgUGd+cp9IcrwKS34MurLS7rkuJ++xQVwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rtfPnOjJWP57V7P2JX1j+LP+poRMU+8MY4ECRirYc2zWGo5ku9XA9jHCv9wpB0BwlopGLSHuEpyLHHwBreQxJFopZ4G9aBCkeuTDkc8iBOf7YneUcGwjCp/RaBWLn0/xNQlClNyG+soBnBPXICXHSZfh5B4PtciBNeOPjQ7r+dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eVXKR1re; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337057; x=1752873057;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m0/N8F93ymgUGd+cp9IcrwKS34MurLS7rkuJ++xQVwc=;
  b=eVXKR1reQHlj/wm9W6WssIzW7edRkyMLTHnd8ZWSidRnS166EDGqqDGn
   6XOMHu/peNKySYXEXv2JpkpbvXTdtZVK5wmt6p36gMFF5tyg18v8THvo6
   gJdNGmB1CgFfgYEx+NkkmB8ey6V1iveODe+i+4X/n9PlACavhmRQ1TQAr
   GwSqi8WhZxKzoEGO3HBCmUzCvC3ZirWDyHMktejxTo+s++0NmG1xkaFjp
   6qH1ATuy/7gKH4hfp2/Auh9cNQe3anD7XNtunSCn63OTgxLSYEM5KyHEB
   GUgDj7hJ6ITJhTKpWPmuD+kEJTdUU+0CRKwcT5GPxdTEiQnGvhqWZI4vK
   w==;
X-CSE-ConnectionGUID: D/IV6SyTSjCz82jx1xrq9w==
X-CSE-MsgGUID: WrF5d4aqR7i+q6S6TGr4lg==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="36370708"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="36370708"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:10:56 -0700
X-CSE-ConnectionGUID: SqqwjxawRF2m8oA+QFUVDg==
X-CSE-MsgGUID: TffSMjvYTfeZCOkOneU1ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="81935053"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.107]) ([10.24.10.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:10:55 -0700
Message-ID: <93cb9db8-80cb-424e-8b2b-3e9fd9e6010e@intel.com>
Date: Thu, 18 Jul 2024 14:10:55 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/9] target/i386/kvm: Clean up error handling in
 kvm_arch_init()
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240716161015.263031-1-zhao1.liu@intel.com>
 <20240716161015.263031-9-zhao1.liu@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240716161015.263031-9-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/16/2024 9:10 AM, Zhao Liu wrote:
> Currently, there're following incorrect error handling cases in
> kvm_arch_init():
> * Missed to handle failure of kvm_get_supported_feature_msrs().
> * Missed to return when KVM_CAP_X86_DISABLE_EXITS enabling fails.
> * MSR filter related cases called exit() directly instead of returning
>   to kvm_init().
> 
> Fix the above cases.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Zide Chen <zide.chen@intel.com>


> ---
> v3: new commit.
> ---
>  target/i386/kvm/kvm.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index f68be68eb411..d47476e96813 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2682,7 +2682,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>          return ret;
>      }
>  
> -    kvm_get_supported_feature_msrs(s);
> +    ret = kvm_get_supported_feature_msrs(s);
> +    if (ret < 0) {
> +        return ret;
> +    }
>  
>      uname(&utsname);
>      lm_capable_kernel = strcmp(utsname.machine, "x86_64") == 0;
> @@ -2740,6 +2743,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>          if (ret < 0) {
>              error_report("kvm: guest stopping CPU not supported: %s",
>                           strerror(-ret));
> +            return ret;
>          }
>      }
>  
> @@ -2785,7 +2789,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>          if (ret) {
>              error_report("Could not enable user space MSRs: %s",
>                           strerror(-ret));
> -            exit(1);
> +            return ret;
>          }
>  
>          ret = kvm_filter_msr(s, MSR_CORE_THREAD_COUNT,
> @@ -2793,7 +2797,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>          if (ret) {
>              error_report("Could not install MSR_CORE_THREAD_COUNT handler: %s",
>                           strerror(-ret));
> -            exit(1);
> +            return ret;
>          }
>      }
>  

