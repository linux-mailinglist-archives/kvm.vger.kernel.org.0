Return-Path: <kvm+bounces-58538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1314B9665D
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:49:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D233D175244
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5EE019E7E2;
	Tue, 23 Sep 2025 14:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KTHYIt9j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0873D544;
	Tue, 23 Sep 2025 14:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758638689; cv=none; b=f5QrxRhnfqDBjBNwAB+Lx1I8V7wYC/yCOV4dk1zbZ2DvpAS8D4+wCqikV2GsEd2opkJ6Zn+srxPqkXiIUKzu2b9kqmhK4WAAj6yQKiKq3q/515PxWBw0MTk+Hcb1UcSnTF16duFy0DFykwY9qLMx5hLg7Xgh5p7BMmfntDlVrTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758638689; c=relaxed/simple;
	bh=hIW2FclH1g5vA9b4dxlT9n1UH4vYHvNGgdlk6GKis/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VlX3bX7hXdoR2EY1GVuCcAogWOrLzUtfOM+wR5TJ52HV1l+HRC+wYm+LhibbBnZ5iZSO7TedAxSBwq/6VZxJfzNc9EA76tozNun2WY/MhjrY6DQQmPEHWfKtQh/8AAGvXvlD059AZqVgOg6H3Av4+W43325O9oeP85tRM55cwJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KTHYIt9j; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758638688; x=1790174688;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hIW2FclH1g5vA9b4dxlT9n1UH4vYHvNGgdlk6GKis/E=;
  b=KTHYIt9jD19FDX6ekFPQROdg8P950vA1wmTj1K2uIe37oVVQhe9SEPTF
   2viJhR+XZ1ckQsjcJBAc364W+fd3oO9ec8RUZwVbS8CbPgRyPdCoHdjXV
   x1St5V4W0WLrXLxSWZaC0eiYkPWYIXgR9O0C4IeOGd5egMjWFFp9i98me
   SBuH74GuG5JDLXdu2jMM0EtVjIQLxxU3GYZ8VfnRx3TBN1jT6CoMxpc1p
   m3aw1KusN0Qtb06tFmC7T9FRQRR2SphFH5sI0A0s7Cz2ch87AnBm2Ofxj
   VeXgiaXNTq3Pd5oFHhIL7d7EBcgtOiZAo284TV5t4X5SXHSexKQTew+Vg
   w==;
X-CSE-ConnectionGUID: Vo5+DFQfRV2lVUnjH/SIRw==
X-CSE-MsgGUID: GDpibQFKScav3mZiq4sDGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="86360198"
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="86360198"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:44:47 -0700
X-CSE-ConnectionGUID: dIlySU0eQaaanhxNWFbn+A==
X-CSE-MsgGUID: qE4KwowJRUqTHnGoR0HEkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="177157139"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:44:41 -0700
Message-ID: <5dbc1100-6685-4eac-aa04-07f5621d3979@intel.com>
Date: Tue, 23 Sep 2025 22:44:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 27/51] KVM: x86: Disable support for IBT and SHSTK if
 allow_smaller_maxphyaddr is true
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-28-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250919223258.1604852-28-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> Make IBT and SHSTK virtualization mutually exclusive with "officially"
> supporting setups with guest.MAXPHYADDR < host.MAXPHYADDR, i.e. if the
> allow_smaller_maxphyaddr module param is set.  Running a guest with a
> smaller MAXPHYADDR requires intercepting #PF, and can also trigger
> emulation of arbitrary instructions.  Intercepting and reacting to #PFs
> doesn't play nice with SHSTK, as KVM's MMU hasn't been taught to handle
> Shadow Stack accesses, and emulating arbitrary instructions doesn't play
> nice with IBT or SHSTK, as KVM's emulator doesn't handle the various side
> effects, e.g. doesn't enforce end-branch markers or model Shadow Stack
> updates.
> 
> Note, hiding IBT and SHSTK based solely on allow_smaller_maxphyaddr is
> overkill, as allow_smaller_maxphyaddr is only problematic if the guest is
> actually configured to have a smaller MAXPHYADDR.  However, KVM's ABI
> doesn't provide a way to express that IBT and SHSTK may break if enabled
> in conjunction with guest.MAXPHYADDR < host.MAXPHYADDR.  I.e. the
> alternative is to do nothing in KVM and instead update documentation and
> hope KVM users are thorough readers.  

KVM_SET_CPUID* can return error to userspace. So KVM can return -EINVAL 
when userspace sets a smaller maxphyaddr with SHSTK/IBT enabled.

> Go with the conservative-but-correct
> approach; worst case scenario, this restriction can be dropped if there's
> a strong use case for enabling CET on hosts with allow_smaller_maxphyaddr.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/cpuid.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 499c86bd457e..b5c4cb13630c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -963,6 +963,16 @@ void kvm_set_cpu_caps(void)
>   	if (!tdp_enabled)
>   		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>   
> +	/*
> +	 * Disable support for IBT and SHSTK if KVM is configured to emulate
> +	 * accesses to reserved GPAs, as KVM's emulator doesn't support IBT or
> +	 * SHSTK, nor does KVM handle Shadow Stack #PFs (see above).
> +	 */
> +	if (allow_smaller_maxphyaddr) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +	}
> +
>   	kvm_cpu_cap_init(CPUID_7_EDX,
>   		F(AVX512_4VNNIW),
>   		F(AVX512_4FMAPS),


