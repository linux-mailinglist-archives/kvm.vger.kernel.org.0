Return-Path: <kvm+bounces-30432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C20E69BAAAD
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 02:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E857281F14
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 01:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 451E61632D2;
	Mon,  4 Nov 2024 01:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mFp8x5/1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925646FD5;
	Mon,  4 Nov 2024 01:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730685484; cv=none; b=q3kcH54L9hDotr8eLwqlCDqZtqnmcHqfL3W52cHKmK4MGfKmnp1f2bjpry5+uj1XLAXh3d956vl2LuvSKHDROIK4J2wY5XQ3PBENKWBnu+gLKAq1HxL9sezAoc+PwPlUw5219TvRQmAXd540D3DA4NRjmGYtSYaBcJ2aTyUr4FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730685484; c=relaxed/simple;
	bh=RKYYmz04I/gjRRUcjLHhCjZfiVF/e/LPA2rPuzFUwgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s07zgmsF8T7Gyi+T5f9q5CXzqZYET4z8wfdk7dpB92Te4mWwrgVhK/JzSsve67d3N2vkX8tneikjFIVtoN8jXhZz+0C2it7wd3CUz7RsAVbduy0/WJbfap0v6f2Zabv/allybpEZ9V1dzYcoMcOgsz41e6ZcwBmnsLIT6YW++zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mFp8x5/1; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730685483; x=1762221483;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RKYYmz04I/gjRRUcjLHhCjZfiVF/e/LPA2rPuzFUwgI=;
  b=mFp8x5/10BePu25ZyXBM4JURPRCz8IHuWBAHZiXz6Qerj0YbVj5VyJeO
   WK2t1w/QgYvtvbdhibk4Bqb2iKghSO5cRFUn8k5Z1XCicODOwDl8VGz+w
   lDRyPHM3X9dNfBuw89+ZqLugRVHPWdVMImkuvrzw87WqbwQrbJD+Zluto
   xhNxQBMcPgMtbe+B74QpUVP3NLtZMQ2NBqaUVYR2ClOZ3dxaKK8knuHYA
   5Bex9mb0mpcb1wRF+V83yu/+isgUXYULZu26qrRQynZx9RYDVIj08VFpH
   y8gonHsEoRf+qoB+JB38qLM5esIEpMaDWOsu6lwXoyWZ+PFlTkeWXGaQM
   A==;
X-CSE-ConnectionGUID: WfD0kT/NSMWgV56vznBGYQ==
X-CSE-MsgGUID: PI/GawB9Ry+mgl74fKG2xw==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="41743390"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="41743390"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 17:58:02 -0800
X-CSE-ConnectionGUID: PymJpey5TLqZme9yjp6kAw==
X-CSE-MsgGUID: t0lghpvKT/SnWIg+sSy81A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="106857727"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 17:57:59 -0800
Message-ID: <57e322e8-f486-4276-b9d5-4dc6c1e6e914@intel.com>
Date: Mon, 4 Nov 2024 09:57:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: VMX: Allow toggling bits in MSR_IA32_RTIT_CTL
 when enable bit is cleared
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Adrian Hunter <adrian.hunter@intel.com>
References: <20241101185031.1799556-1-seanjc@google.com>
 <20241101185031.1799556-3-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241101185031.1799556-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/2/2024 2:50 AM, Sean Christopherson wrote:
> From: Adrian Hunter <adrian.hunter@intel.com>
> 
> Allow toggling other bits in MSR_IA32_RTIT_CTL if the enable bit is being
> cleared, the existing logic simply ignores the enable bit.  E.g. KVM will
> incorrectly reject a write of '0' to stop tracing.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Fixes: bf8c55d8dc09 ("KVM: x86: Implement Intel PT MSRs read/write emulation")
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> [sean: rework changelog, drop stable@]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 087504fb1589..9b9d115c4824 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1636,7 +1636,8 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
>   	 * result in a #GP unless the same write also clears TraceEn.
>   	 */
>   	if ((vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) &&
> -		((vmx->pt_desc.guest.ctl ^ data) & ~RTIT_CTL_TRACEEN))
> +	    (data & RTIT_CTL_TRACEEN) &&
> +	    data != vmx->pt_desc.guest.ctl)
>   		return 1;
>   
>   	/*


