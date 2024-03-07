Return-Path: <kvm+bounces-11291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 082D2874CFF
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 12:08:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB23FB21147
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 11:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0759E12837A;
	Thu,  7 Mar 2024 11:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SyWeHzFw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EBD127B62;
	Thu,  7 Mar 2024 11:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709809673; cv=none; b=ZKIJFGuc80FVLNdLf3r+25YkQaqRaUq1wnobwBqdwbSX8dZkG18ylQ8fj/4NnPtLAN+TK1z2HBqtn8VTT1qz0YgLO98TWO4Rh1xD8zjhmvpomdB3RHMMsYeiH+584rP5Nl9iNSIwKSeFHXGcA4MaLlyD24Us4Q9OsnlmybDAfaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709809673; c=relaxed/simple;
	bh=GmMF/Xy/ypYDgtpuykoAyNwu3DXc/rSpjDhD9l6pRys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GMqA4PQ9v61R9/7H4As2RJ2rFz+JpyAEHVuVAnELDv3fV58SIz10Zv/mgEwCH04LokSy7k/icS57u+rmA8B7l2xdj6B7fRhQA/g6lBhv6W+IjE3l20SQ8XcGxNHgeH7OqjhfptqEWEU8XGs/yHxnSe8oPMgonw6OJec0Ln5ZY6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SyWeHzFw; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e5760eeb7aso546025b3a.1;
        Thu, 07 Mar 2024 03:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709809671; x=1710414471; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=roGa+cp5rN3dqIvbgjfd3/UmsbreDC7ehCVnuTpvas4=;
        b=SyWeHzFwSVaKRO/snnToXr5rMgrwDRlLjzx5gecUVCj177roLltKr8CZvjtsfZfrq4
         xnK7wfuVoC57d7L6cc0lEP9cElI5Qs+aH3yPhCa0QwwIhxFeAcjYWKvpb0lzD46TcRLo
         2cmMkKYsKnzo3BB9pctiO/xJQzx3MuO6wx+h6Ly7UkIhFeVL5StXFz/Ikj60cohMbaDu
         fANd4YgeHvPqCc/ICMIJSyhIq9TOXrfnE2Mk3nwE0ht4gUe0zjq+GeVCnEcEu9ASpsz0
         IdxhKg7u5cnE4E1/ExKw6+Pr3tdOHeO4TQy3Jn3iY/rhu8PbZEYOHHJ1f/WTV7T1dAmY
         KEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709809671; x=1710414471;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=roGa+cp5rN3dqIvbgjfd3/UmsbreDC7ehCVnuTpvas4=;
        b=Okf02aCvyWPUtecxD7dRY/OrVRxSmv2Csxs3TysolNyy3YEDUI592mRMONaLxEn+VG
         mLDUoHPL7B+pBSyrw1X1pPiPNsn9TPQYkrcdCE53tFw3NLityder0XsVU+D2lnA1ycEw
         LcIqgJm0HUU1aIDfSnMvnqZ+x9Ad52RFXnisu11u0e2IAVMYk0XVTfUTgC9bFbpyT8Ug
         Bh3zNpYWysfxUpYV6LN59ZCzdSuwGWHu5WosDt6ZyQ1NDapz246yN4sTSYHo7MaySFBj
         I2+m5708Ycdw5MYZGt6IoD5HPEaxjY4cYpgVGHxFXY8yDeYwnnN7IU0mDz7ok+btQ9UA
         Am8A==
X-Forwarded-Encrypted: i=1; AJvYcCUMTQdUptM0nHGhPtmuzsQUVctFdEISx9u43ltZ9EWSx243T8/LlOFowwRSqVRTW6gmDRxobraif80WRbnn6YpMcsFrlitHSCnt96KI
X-Gm-Message-State: AOJu0YwUoc+PD9kkHRGlXQyP83Xw2kpvfcTLXpv2+Rs1j/XcbT98PqYA
	EpW0RUyOvP/2Sn5YcagrX2XZZthNGqIuT5kjdhtTPRQ5zDUo/1P9
X-Google-Smtp-Source: AGHT+IHExxJQ23252lznxLRM1Mu0uK1foQyvuWgOhWgRlnHmbcTYDWQondOdRfe1yL9dPjnvWV22WA==
X-Received: by 2002:a05:6a00:a86:b0:6e6:5374:411a with SMTP id b6-20020a056a000a8600b006e65374411amr4231928pfl.18.1709809670903;
        Thu, 07 Mar 2024 03:07:50 -0800 (PST)
Received: from [192.168.255.10] ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id r19-20020aa78453000000b006e4dad633e1sm12644003pfn.177.2024.03.07.03.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Mar 2024 03:07:50 -0800 (PST)
Message-ID: <e34d49b8-4aa2-455a-a623-53a630d484ef@gmail.com>
Date: Thu, 7 Mar 2024 19:07:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/pmu: Disable support for adaptive PEBS
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mingwei Zhang <mizhang@google.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhang Xiong <xiong.y.zhang@intel.com>, Lv Zhiyuan <zhiyuan.lv@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>, Jim Mattson <jmattson@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20240307005833.827147-1-seanjc@google.com>
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20240307005833.827147-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/2024 8:58 am, Sean Christopherson wrote:
> Drop support for virtualizing adaptive PEBS, as KVM's implementation is
> architecturally broken without an obvious/easy path forward, and because
> exposing adaptive PEBS can leak host LBRs to the guest, i.e. can leak
> host kernel addresses to the guest.
> 
> Bug #1 is that KVM doesn't doesn't account for the upper 32 bits of
> IA32_FIXED_CTR_CTRL when (re)programming fixed counters, e.g
> fixed_ctrl_field() drops the upper bits, reprogram_fixed_counters()
> stores local variables as u8s and truncates the upper bits too, etc.
> 
> Bug #2 is that, because KVM _always_ sets precise_ip to a non-zero value
> for PEBS events, perf will _always_ generate an adaptive record, even if
> the guest requested a basic record.  Note, KVM will also enable adaptive
> PEBS in individual *counter*, even if adaptive PEBS isn't exposed to the
> guest, but this is benign as MSR_PEBS_DATA_CFG is guaranteed to be zero,
> i.e. the guest will only ever see Basic records.
> 
> Bug #3 is in perf.  intel_pmu_disable_fixed() doesn't clear the upper
> bits either, i.e. leaves ICL_FIXED_0_ADAPTIVE set, and
> intel_pmu_enable_fixed() effectively doesn't clear ICL_FIXED_0_ADAPTIVE
> either.  I.e. perf _always_ enables ADAPTIVE counters, regardless of what
> KVM requests.

The three issues above all point to a fix in one direction: to pass the value
of vcpu's EVT_SELx.Adaptive_Record[34] or FCx_Adaptive_Record to the
perf/core in a way and let the PEBS assist take effect as expected by vPEBS.

One place to address this is in the intel_guest_get_msrs() again:
- update vPMC[x].pPMC.fcctl_or_evtsel.ADAPTIVE = vPMC[x].use_adaptive
, since guest PEBS is disabled if host PEBS is enabled.

> 
> Bug #4 is that adaptive PEBS *might* effectively bypass event filters set
> by the host, as "Updated Memory Access Info Group" records information
> that might be disallowed by userspace via KVM_SET_PMU_EVENT_FILTER.

This could be seen as a missing feature, that is, whether PMU_EVENT_FILTER
can control PEBS events even if they share the same event encoding.

Furthermore, if LBR_FMT is cleared only by VMM, could the guest use
adaptive pebs to obtain valid guest_lbr records. It's open in the virt context
since real hardware doesn't have this issue.

> 
> Bug #5 is that KVM doesn't ensure LBR MSRs hold guest values (or at least
> zeros) when entering a vCPU with adaptive PEBS, which allows the guest
> to read host LBRs, i.e. host RIPs/addresses, by enabling "LBR Entries"
> records.
> 
> Disable adaptive PEBS support as an immediate fix due to the severity of
> the LBR leak in particular, and because fixing all of the bugs will be
> non-trivial, e.g. not suitable for backporting to stable kernels.
> 
> Note!  This will break live migration, but trying to make KVM play nice
> with live migration would be quite complicated, wouldn't be guaranteed to
> work (i.e. KVM might still kill/confuse the guest), and it's not clear
> that there are any publicly available VMMs that support adaptive PEBS,
> let alone live migrate VMs that support adaptive PEBS, e.g. QEMU doesn't
> support PEBS in any capacity.
> 
> Link: https://lore.kernel.org/all/20240306230153.786365-1-seanjc@google.com
> Link: https://lore.kernel.org/all/ZeepGjHCeSfadANM@google.com
> Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
> Cc: stable@vger.kernel.org
> Cc: Like Xu <like.xu.linux@gmail.com>
> Cc: Mingwei Zhang <mizhang@google.com>
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Zhang Xiong <xiong.y.zhang@intel.com>
> Cc: Lv Zhiyuan <zhiyuan.lv@intel.com>
> Cc: Dapeng Mi <dapeng1.mi@intel.com>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Like Xu <likexu@tencent.com>

> ---
>   arch/x86/kvm/vmx/vmx.c | 24 ++++++++++++++++++++++--
>   1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 7a74388f9ecf..641a7d5bf584 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7864,8 +7864,28 @@ static u64 vmx_get_perf_capabilities(void)
>   
>   	if (vmx_pebs_supported()) {
>   		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
> -		if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
> -			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
> +
> +		/*
> +		 * Disallow adaptive PEBS as it is functionally broken, can be
> +		 * used by the guest to read *host* LBRs, and can be used to
> +		 * bypass userspace event filters.  To correctly and safely
> +		 * support adaptive PEBS, KVM needs to:
> +		 *
> +		 * 1. Account for the ADAPTIVE flag when (re)programming fixed
> +		 *    counters.
> +		 *
> +		 * 2. Gain support from perf (or take direct control of counter
> +		 *    programming) to support events without adaptive PEBS
> +		 *    enabled for the hardware counter.
> +		 *
> +		 * 3. Ensure LBR MSRs cannot hold host data on VM-Entry with
> +		 *    adaptive PEBS enabled and MSR_PEBS_DATA_CFG.LBRS=1.
> +		 *
> +		 * 4. Document which PMU events are effectively exposed to the
> +		 *    guest via adaptive PEBS, and make adaptive PEBS mutually
> +		 *    exclusive with KVM_SET_PMU_EVENT_FILTER if necessary.
> +		 */
> +		perf_cap &= ~PERF_CAP_PEBS_BASELINE;
>   	}
>   
>   	return perf_cap;
> 
> base-commit: 0c64952fec3ea01cb5b09f00134200f3e7ab40d5

