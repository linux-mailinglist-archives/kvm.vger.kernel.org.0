Return-Path: <kvm+bounces-32329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B809D56CF
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 01:41:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F2F11F229E4
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 00:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 221BE4A0C;
	Fri, 22 Nov 2024 00:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J4AwyMS5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130F2469D
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 00:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732236087; cv=none; b=Z2MoxjhII/qCZmOgNGDiqmpdzRwA1grIBrF/o8eLIgyyAsOjMi/MfVN+mS8WTx/o8/ZqKCrSkgnZG6oaCmjc35MOk3m6o+lCrRdDaUl4PPrxXZLmA7AEk+af5tPS8uZyhgd7mFmRoTUp9YAfH5tpzsGJdahsnAQ0rh/XlqlBlsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732236087; c=relaxed/simple;
	bh=NdpP+4bWiTMCkpxPRgpNPSthwcnvj/WjOPY3Piwt4EM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JOLRz4z2Qgh9tKu66msicnp9De8eWsJwCgF1bi5CUrdDRyb7ElgafpzTRvZC5sSFnClwXlFe7ayKcBEDLOG7T9Z30xjt1BAVWX/yMhueAbMVUkBJgW7glWilidD3u2UVlnlt4HLB1ygvlA3K2oTeJrffRHeOpYCrRDmFPFbx5t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J4AwyMS5; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732236085; x=1763772085;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NdpP+4bWiTMCkpxPRgpNPSthwcnvj/WjOPY3Piwt4EM=;
  b=J4AwyMS51ZmetV+lHVlc9jHZp9hNXeXcE+H/ZVpbCGJU+NFqYggeMOhW
   JQ/Ajg+HpG/xBE9/Oa1FcTmk9bMaJ5r2lSFT8ASb0qzmj/ahA2EdblQux
   JPhzmEkatW7axlGBuhLuXW9h5gl95PSCuyMlaQMGqPTTHjv6ZEBht/axE
   F0htOvEQSxcAapBpkk2XjfHNE81wH6Fbxie//yWaBnRtn0Co7mQu7SdRi
   zkPIKo48UI7fHlbJWRyyyLz+IsXxwKAoUSJQlPWNRFoNm0o0kCuPRy7HB
   /unF+ITIF536CRE3wa6pTvxnviQtHsD3WHHEyipdbcY0txjmfcQVPUPAH
   g==;
X-CSE-ConnectionGUID: vwHhvHOlQRmwlmK0WZiMNw==
X-CSE-MsgGUID: e8U+lAduRBCyo23nVEgZFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="32618734"
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="32618734"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 16:41:24 -0800
X-CSE-ConnectionGUID: 9HP5apQ2Q+Cb3J8A8P7ABw==
X-CSE-MsgGUID: xdnk8wqiSRWoVEDaIBA5yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="95220291"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 16:41:24 -0800
Date: Thu, 21 Nov 2024 16:41:24 -0800
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	thomas.lendacky@amd.com, santosh.shukla@amd.com, bp@alien8.de,
	ketanch@iitk.ac.in, rick.p.edgecombe@intel.com, mtosatti@redhat.com
Subject: Re: [RFC PATCH 0/5] Enable Secure TSC for SEV-SNP
Message-ID: <Zz/TNEYIi/AFbOCv@ls.amr.corp.intel.com>
References: <20240829053748.8283-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240829053748.8283-1-nikunj@amd.com>

On Thu, Aug 29, 2024 at 11:07:43AM +0530,
Nikunj A Dadhania <nikunj@amd.com> wrote:

> TSC value calculations for the guest are controlled by the hypervisor. A
> malicious hypervisor can prevent guest from moving forward. The Secure TSC
> feature for SEV-SNP allows guests to securely use the RDTSC and RDTSCP
> instructions. This ensures the guest gets a consistent view of time and
> prevents a malicious hypervisor from making it appear that time rolls
> backwards, advancing at an unusually fast rate, or employing similar tricks.
> For more details, please refer to "Secure Nested Paging (SEV-SNP)" section,
> subsection "Secure TSC" of APM Volume 2

Hello. Although I replied at [1], let raise this here too.

Don't we need to prevent the KVM from modifying KVM vcpu tsc offset/multiplier
(vcpu->arch.tsc_offset etc.)?

As long as I understand, the spec (APM volume2) says the timer interrupt (TSC
deadline timer or local APIC timer) is not virtualized by hardware so that KVM
emulates timer interrupt.
If KVM modifies guest offset/multiplier from the original value
(the SEV-SNP secure tsc uses or the TDX module uses), the timer interrupt
emulation by KVM will be inaccurate.  It's injected late or early than
the guest expects.

Please notice that kvm_arch_vcpu_create() calls
kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz) after
kvm_x86_call(vcpu_create)().


[1] https://lore.kernel.org/kvm/Zz%2FDGOoo%2FmEvULiG@ls.amr.corp.intel.com/


> This patchset is also available at:
> 
>   https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest
> 
> and is based on v6.11-rc5
> 
> Testing SecureTSC
> -----------------
>  
> SecureTSC Guest patches:
> https://github.com/AMDESE/linux-kvm/tree/sectsc-guest-latest
>  
> QEMU changes:
> https://github.com/nikunjad/qemu/tree/snp-securetsc-latest
>  
> QEMU commandline SEV-SNP with SecureTSC:
>  
>   qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
>      -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
>      -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on \
>      -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
>      ...

Did you test it with tsc frequency/offset different from the kvm system default
value (max_tsc_khz or kvm_caps.default_tsc_scaling_ranio etc.)?
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

