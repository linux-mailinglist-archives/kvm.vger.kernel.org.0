Return-Path: <kvm+bounces-61143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8EFAC0C649
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 09:46:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E3DE18A34D9
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 08:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01EF32F12B6;
	Mon, 27 Oct 2025 08:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cmYFHn5/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC402EDD4D
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 08:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761554588; cv=none; b=gIapV/fv1VtLBKc1UUci38cGvp91FZ9+R2DR+qOLUZH4TBEucE/Gfr0P+Y66dJB9df1nCHe2xTbSvt2wbfaF1bGTlUxPzP7fsYSZ6omvdSazXVPNZtJu4w1snWrC6SFQuECefO2lqpfcFO2ILp+vK+eB2ntxfimS11tbSI2ejY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761554588; c=relaxed/simple;
	bh=EMbzEKeXsUzP0lsfCgvG+XKe9Fk6bXujPvl2lOBxAAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gsGZLqSr/VBUgyI02HjwX7Im8UpxOYsRLa5J/9gTWU3m5ZXa37+8aNYynNNSQ1iielpjnlI1wUt/o93D+ldr2J/Oaka/zk1JUixTdZhhsAltw6BACsbonjI+D5v8+m0T4YZ3oJX4SiSaUTil5uCYfOCFNTGzvg0QnKA1SC7to60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cmYFHn5/; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761554585; x=1793090585;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EMbzEKeXsUzP0lsfCgvG+XKe9Fk6bXujPvl2lOBxAAQ=;
  b=cmYFHn5/S5iXooI2I+yQ/m89WxZVuOhp0eAtnY4rOB2c9LwZ8zBsc6Gc
   +D5JvRJKmMLvky8zyL2ajigemZV2/cN42+UGqnjqWpTprYSz9bPTHylip
   hmBvHTf/6GwrVGUesq58hBQxdAoVBFROS0ZrkpP1WhQ+WqZ5UXHpz1Ycg
   s6e/V8T5gPmehEyFFMTxBSOZceWSQRvRq5hXbcFR2iCokc6+KT8sEXC9n
   m1vN8JYdD9qOVc9YFDc/He5vhJWf8TNiH584XOcKqaXrptwcqZfaSaj1I
   wlTNtp3a9iMhXyhkAW33i5J4/GbPs6ODRapQgHj6XDIhWFlJ7GdxV8+6B
   Q==;
X-CSE-ConnectionGUID: jmWp3K2zTgutjjH0IoaLcw==
X-CSE-MsgGUID: VHBMKQyjSHO7tTX4hVp6Dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74229969"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="74229969"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 01:43:04 -0700
X-CSE-ConnectionGUID: vfbcSDChQSmufMSf7Uh7yw==
X-CSE-MsgGUID: S7QixNJtSYCAjBQIFFYspg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184604403"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 01:43:00 -0700
Message-ID: <0dc79cc8-f932-4025-aff3-b1d5b56cb654@intel.com>
Date: Mon, 27 Oct 2025 16:42:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/20] i386/cpu: Add missing migratable xsave features
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-11-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-11-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:
> Xtile-cfg & xtile-data are both user xstates. Their xstates are cached
> in X86CPUState, and there's a related vmsd "vmstate_amx_xtile", so that
> it's safe to mark them as migratable.
> 
> Arch lbr xstate is a supervisor xstate, and it is save & load by saving
> & loading related arch lbr MSRs, which are cached in X86CPUState, and
> there's a related vmsd "vmstate_arch_lbr". So it's also safe to mark it
> as migratable (even though KVM hasn't supported it - its migration
> support is completed in QEMU).
> 
> PT is still unmigratable since KVM disabled it and there's no vmsd and
> no other emulation/simulation support.

The patch itself looks reasonable.

I'm wondering why there is no issue reported since I believe folks 
tested the functionality of AMX live migration when AMX support was 
upstreamed. So I explore a bit and find that the 
migrable_flags/ungratable_flags in XCR0/XSS leaf don't take any effect 
because of the
x86_cpu_enable_xsave_components()

Though the feature expansion in x86_cpu_expand_features() under

	if (xcc->max_features) {
		...
	}

only enables migratable features when cpu->migratable is true, 
x86_cpu_enable_xsave_components() overwrite the value later.

> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>   target/i386/cpu.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 1917376dbea9..b01729ad36d2 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1522,7 +1522,8 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>           .migratable_flags = XSTATE_FP_MASK | XSTATE_SSE_MASK |
>               XSTATE_YMM_MASK | XSTATE_BNDREGS_MASK | XSTATE_BNDCSR_MASK |
>               XSTATE_OPMASK_MASK | XSTATE_ZMM_Hi256_MASK | XSTATE_Hi16_ZMM_MASK |
> -            XSTATE_PKRU_MASK,
> +            XSTATE_PKRU_MASK | XSTATE_ARCH_LBR_MASK | XSTATE_XTILE_CFG_MASK |
> +            XSTATE_XTILE_DATA_MASK,
>       },
>       [FEAT_XSAVE_XCR0_HI] = {
>           .type = CPUID_FEATURE_WORD,


