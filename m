Return-Path: <kvm+bounces-31385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D2F29C3303
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 16:12:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DAC85B20EA3
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 15:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31AA842C0B;
	Sun, 10 Nov 2024 15:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eXcd2zAr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB0D10A3E
	for <kvm@vger.kernel.org>; Sun, 10 Nov 2024 15:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731251510; cv=none; b=ELE/aMmntj046tJYlWsvS/4AwrjmI/LA2HEvQqQmzchuc4dOCV54iWoylLvF8N7M6iki1heYZ+odfF508dOflisC9ENHOSThG5IXugvS6v844zPxvo8Xv2HGcsFXjaHQzLLi23RWvEKKQRHjEqghUuPGhXjEOhjbeW6RTqScXFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731251510; c=relaxed/simple;
	bh=USl1nY3YjGmLI1eF88k5ItXmHiKnBx4f1MQDRmVEU6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=je+Y72harfN95NRLE2wAj8vc2vpxqbhoAGKYCauIXiiNxxJ1xmw07XaXS8BjvrgQZcJmXM26Pf24qrCCZqRBjzs8cR/fKhsW3Dzl4s6gKLKlMuoiBauhewHQHwTsGR0JI/ozyjcUPTc7Hulee+1quimbk5HD+mjibqH7Wa3Ys4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eXcd2zAr; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731251508; x=1762787508;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=USl1nY3YjGmLI1eF88k5ItXmHiKnBx4f1MQDRmVEU6Y=;
  b=eXcd2zArtYd7haaE6Cz8lt1HdyulRIxTUpVeprDoGvUJHH1YAd41Dpy8
   qyhbuZ30RK+a3ZOPbHbt/Ckr9y4P7QMTBgBd9sSYX4DebciH+SaVzYnBE
   g3U23CP5BzmOok55/GLMtOKTk505mfHoX/8/vaYqcr2f643kO1denBtfL
   8R+gSKzMIRoPAY/0Yw8iDXlfhOkyvihISv/pwblugmN+9e/YkXIXJ9xQ9
   ZF7lg9Sji8UPtClptj2uovRHxoTes7BuNKL0fLJSoqnndnlvyvb3AFWiS
   Y2JpnGgH//cSEvAYv7qBNIGwjuM3jR0DwGU57cGJzr2ME5bgGF8n9/5ck
   w==;
X-CSE-ConnectionGUID: 9puhuVbsSQ61q/vl2O/qhw==
X-CSE-MsgGUID: 8elcU2VxR122AKrLnmX8Zw==
X-IronPort-AV: E=McAfee;i="6700,10204,11252"; a="42455145"
X-IronPort-AV: E=Sophos;i="6.12,143,1728975600"; 
   d="scan'208";a="42455145"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2024 07:11:47 -0800
X-CSE-ConnectionGUID: Zq6s1SMsTH2DN0QsWMsSMA==
X-CSE-MsgGUID: N/+1CAqGQFG9Nk32wDYC0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,143,1728975600"; 
   d="scan'208";a="86820275"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 10 Nov 2024 07:11:43 -0800
Date: Sun, 10 Nov 2024 23:29:41 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, lyan@digitalocean.com,
	khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
	den@virtuozzo.com, joe.jin@oracle.com, davydov-max@yandex-team.ru
Subject: Re: [PATCH 3/7] target/i386/kvm: init PMU information only once
Message-ID: <ZzDRZcy7EdK40PO1@intel.com>
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-4-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241104094119.4131-4-dongli.zhang@oracle.com>

Hi Dongli,

>  int kvm_arch_init_vcpu(CPUState *cs)
>  {
>      struct {
> @@ -2237,6 +2247,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
>      cpuid_data.cpuid.nent = cpuid_i;
>  
> +    /*
> +     * Initialize PMU information only once for the first vCPU.
> +     */
> +    if (cs == first_cpu) {
> +        kvm_init_pmu_info(env);
> +    }
> +

Thank you for the optimization. However, I think it¡¯s not necessary
because:

* This is not a hot path and not a performance bottleneck.
* Many CPUID leaves are consistent across CPUs, and 0xA is just one of them.
* And encoding them all in kvm_x86_build_cpuid() is a common pattern.
  Separating out 0xa disrupts code readability and fragments the CPUID encoding.

Therefore, code maintainability and correctness might be more important here,
than performance concern.

>      if (((env->cpuid_version >> 8)&0xF) >= 6
>          && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
>             (CPUID_MCE | CPUID_MCA)) {
> -- 
> 2.39.3
> 

