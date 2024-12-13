Return-Path: <kvm+bounces-33731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07A929F0F69
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 15:43:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0950F164FFF
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 14:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A98911E231A;
	Fri, 13 Dec 2024 14:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bpS+5qr7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0C01E0E10
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 14:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734100965; cv=none; b=ZCcTklSP9uKL/VeYDvTmTsy75HMUcSxLlfSa4SfMuopERos4jPbw6vStRVcIi4qD3N6mdFZx+io6ylZ5AmHedyW7ci39d44m6zQ/bRWoZSK23NUyYY72KFz7KhtbGy012VpNB6nlvgtI5fGJRg9LeaFBk7uo6R9P3E2ePjugvDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734100965; c=relaxed/simple;
	bh=ewF6klg4X9hljS7CKMG70YMyGmFT9UUVDYLBQ26g12E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GnSUUB/ISqUJ372rt4rkWjSHWsuvR5qUJVMrY8wtALvSDjQt7EEiX1MZ7DFKw8DGD4+TOGp/zUQmdBou8V+xi/hlP25A4aPhHCOpqBF8OwdTlXBd9xf+VBfrrS3cSRXpALxSNs/kr5h8pFUXTPiL1/yoghRoXAsAiU03aWMT0bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bpS+5qr7; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734100963; x=1765636963;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ewF6klg4X9hljS7CKMG70YMyGmFT9UUVDYLBQ26g12E=;
  b=bpS+5qr79tB1vYLKJ7wVjewcVZ4A5dRyo6wrSanuxYsxcGEfjrqNQZRL
   gIn8wbH/f9SNTykuhAhBZIkSWwjUr5jEfMjsB59LSto/nNNugDbqk9Lgc
   M3V71ASF+OLSHHhEw//ONs2FtpNnopZnAofmnF0xOndKGQ5LkOxLjaZUV
   u7tEa3Uc4QHwUEXBxdMzcfJbVifVq59bDPccfDwsPTZHLa7yyL+aojMpo
   vGAfCrT8WfFWqfnZmoPtxSGY7wKuZznWi54OwZ2TBoMn8QGAAUvq7fx+n
   MfKVuzFKzO41NHUP4R8PRU78LPBGNCow3+zPUF9HiN4a4+B4IrYEkaBuO
   w==;
X-CSE-ConnectionGUID: MfEgUEvWS6KrCH9yTvUE6Q==
X-CSE-MsgGUID: 6mZgouHtSwq13POR2HQmAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11285"; a="33881428"
X-IronPort-AV: E=Sophos;i="6.12,231,1728975600"; 
   d="scan'208";a="33881428"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2024 06:42:27 -0800
X-CSE-ConnectionGUID: WUSWQzgSTt+pHbHcWopBQQ==
X-CSE-MsgGUID: e6gS6JrRTEWFSxL5eKTxfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,231,1728975600"; 
   d="scan'208";a="96438363"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.110.201])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2024 06:42:25 -0800
Date: Fri, 13 Dec 2024 08:42:22 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 43/60] i386/tdx: Only configure MSR_IA32_UCODE_REV in
 kvm_init_msrs() for TDs
Message-ID: <Z1xHztTldnFDih8W@iweiny-mobl>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-44-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105062408.3533704-44-xiaoyao.li@intel.com>

On Tue, Nov 05, 2024 at 01:23:51AM -0500, Xiaoyao Li wrote:
> For TDs, only MSR_IA32_UCODE_REV in kvm_init_msrs() can be configured
> by VMM, while the features enumerated/controlled by other MSRs except
> MSR_IA32_UCODE_REV in kvm_init_msrs() are not under control of VMM.

I'm confused by this commit message.  If these features are not under VMM
control with TDX who controls them?  I assume it is the TDX module.  But where
are the qemu hooks to talk to the module?  Are they not needed in qemu at all?

Also, why are the has_msr_* flags true for a TDX TD in the first place?

Ira

> 
> Only configure MSR_IA32_UCODE_REV for TDs.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  target/i386/kvm/kvm.c | 44 ++++++++++++++++++++++---------------------
>  1 file changed, 23 insertions(+), 21 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 595439f4a4d6..8909fce14909 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3852,32 +3852,34 @@ static void kvm_init_msrs(X86CPU *cpu)
>      CPUX86State *env = &cpu->env;
>  
>      kvm_msr_buf_reset(cpu);
> -    if (has_msr_arch_capabs) {
> -        kvm_msr_entry_add(cpu, MSR_IA32_ARCH_CAPABILITIES,
> -                          env->features[FEAT_ARCH_CAPABILITIES]);
> -    }
> -
> -    if (has_msr_core_capabs) {
> -        kvm_msr_entry_add(cpu, MSR_IA32_CORE_CAPABILITY,
> -                          env->features[FEAT_CORE_CAPABILITY]);
> -    }
> -
> -    if (has_msr_perf_capabs && cpu->enable_pmu) {
> -        kvm_msr_entry_add_perf(cpu, env->features);
> +
> +    if (!is_tdx_vm()) {
> +        if (has_msr_arch_capabs) {
> +            kvm_msr_entry_add(cpu, MSR_IA32_ARCH_CAPABILITIES,
> +                                env->features[FEAT_ARCH_CAPABILITIES]);
> +        }
> +
> +        if (has_msr_core_capabs) {
> +            kvm_msr_entry_add(cpu, MSR_IA32_CORE_CAPABILITY,
> +                                env->features[FEAT_CORE_CAPABILITY]);
> +        }
> +
> +        if (has_msr_perf_capabs && cpu->enable_pmu) {
> +            kvm_msr_entry_add_perf(cpu, env->features);
> +        }
> +
> +        /*
> +         * Older kernels do not include VMX MSRs in KVM_GET_MSR_INDEX_LIST, but
> +         * all kernels with MSR features should have them.
> +         */
> +        if (kvm_feature_msrs && cpu_has_vmx(env)) {
> +            kvm_msr_entry_add_vmx(cpu, env->features);
> +        }
>      }
>  
>      if (has_msr_ucode_rev) {
>          kvm_msr_entry_add(cpu, MSR_IA32_UCODE_REV, cpu->ucode_rev);
>      }
> -
> -    /*
> -     * Older kernels do not include VMX MSRs in KVM_GET_MSR_INDEX_LIST, but
> -     * all kernels with MSR features should have them.
> -     */
> -    if (kvm_feature_msrs && cpu_has_vmx(env)) {
> -        kvm_msr_entry_add_vmx(cpu, env->features);
> -    }
> -
>      assert(kvm_buf_set_msrs(cpu) == 0);
>  }
>  
> -- 
> 2.34.1
> 

