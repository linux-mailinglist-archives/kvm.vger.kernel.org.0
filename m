Return-Path: <kvm+bounces-50817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B65AE994F
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 10:59:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9046C189C02C
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 08:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81793298982;
	Thu, 26 Jun 2025 08:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iJhUcXn6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55B24A33;
	Thu, 26 Jun 2025 08:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750928350; cv=none; b=CLZy//o9T+Man48Tb860FLRRSObbiTHcwR3m4sXk+HQpnxzv3h0O2Z3XrJaJff/aga1r/AEoEPz47XA13my+fxswQcxkcCTklfRNWwtr3R7nP7oALM479lD+gHvI77rBkbZy4RkxdaxhQnBpjhlQOziFmsJUs5zsKsrxkuD9itg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750928350; c=relaxed/simple;
	bh=vz8yrG7TsUr+PK7JlGaU9k8zdE+Zt3hQF4t9uML7Scs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ror/VajWSG0VGTlTtbl3IkvhcBKeXz7lOopNKkgM7dQhZaBa+NFAQk/zSaXWkpqoe/qlu8qnXSGDf6YNNqwKf7tYXhteo2SvtAb981B+M6tAjrp5USJuwE2TaJoy/3BvFTgf2Z9nHxmmYaaahHElHvFPqdQPhBoa4JEnriWso50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iJhUcXn6; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750928348; x=1782464348;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vz8yrG7TsUr+PK7JlGaU9k8zdE+Zt3hQF4t9uML7Scs=;
  b=iJhUcXn6nGwDWEBHZTIjWu0ece+aBVTNpIDw5Q5K0UTu0jxeWp6HEgtf
   6I1iOY2xfsEvWLK/e40jTKz5Wgq5+Bm7sgza0uHlqBEpS828sgw1nciDc
   mZXCnrFYT/omJRfIv10rpRIeLJ88QHQgiDCS0NmJtN8XvSRZb+zDkW0fh
   E7UvPgrHoUC1SbH7/q18IiYi8wQgU9LbdJxU+O8CKxXeyAqYjMPx0tcz2
   hHmAjyEwi/O4YdZbIjFNO9crcMREAtwFGWgOPhwnbIsnTWwf9OXCkhDUo
   J9eYAlWQv4Rks6bLz6E5WdpwkMYIXEpcYfJ6hJVV6Vj60EyTTvC2VgOAd
   A==;
X-CSE-ConnectionGUID: BuUJ1mjNRVCXsxW93Fn34w==
X-CSE-MsgGUID: X73oQGbSTF2/vMbPt60n6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="64649966"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="64649966"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 01:59:08 -0700
X-CSE-ConnectionGUID: PSt5q9rgRv23Z+qWHnxY4g==
X-CSE-MsgGUID: 1ZRIWUhETUuNPdnq4pMsGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="152632462"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 01:59:05 -0700
Message-ID: <bc7aea45-f254-4cbc-8dc0-5435417d8577@intel.com>
Date: Thu, 26 Jun 2025 16:59:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/5] KVM: x86: Provide a capability to disable
 APERF/MPERF read intercepts
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Jim Mattson <jmattson@google.com>
References: <20250626001225.744268-1-seanjc@google.com>
 <20250626001225.744268-3-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250626001225.744268-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/26/2025 8:12 AM, Sean Christopherson wrote:
> From: Jim Mattson <jmattson@google.com>
> 
> Allow a guest to read the physical IA32_APERF and IA32_MPERF MSRs
> without interception.
> 
> The IA32_APERF and IA32_MPERF MSRs are not virtualized. Writes are not
> handled at all. The MSR values are not zeroed on vCPU creation, saved
> on suspend, or restored on resume. No accommodation is made for
> processor migration or for sharing a logical processor with other
> tasks. No adjustments are made for non-unit TSC multipliers. The MSRs
> do not account for time the same way as the comparable PMU events,
> whether the PMU is virtualized by the traditional emulation method or
> the new mediated pass-through approach.
> 
> Nonetheless, in a properly constrained environment, this capability
> can be combined with a guest CPUID table that advertises support for
> CPUID.6:ECX.APERFMPERF[bit 0] to induce a Linux guest to report the
> effective physical CPU frequency in /proc/cpuinfo. Moreover, there is
> no performance cost for this capability.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Link: https://lore.kernel.org/r/20250530185239.2335185-3-jmattson@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   Documentation/virt/kvm/api.rst | 23 +++++++++++++++++++++++
>   arch/x86/kvm/svm/nested.c      |  4 +++-
>   arch/x86/kvm/svm/svm.c         |  5 +++++
>   arch/x86/kvm/vmx/nested.c      |  6 ++++++
>   arch/x86/kvm/vmx/vmx.c         |  4 ++++
>   arch/x86/kvm/x86.c             |  6 +++++-
>   arch/x86/kvm/x86.h             |  5 +++++
>   include/uapi/linux/kvm.h       |  1 +
>   tools/include/uapi/linux/kvm.h |  1 +
>   9 files changed, 53 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 43ed57e048a8..27ced3ee2b53 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7844,6 +7844,7 @@ Valid bits in args[0] are::
>     #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
>     #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
>     #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
> +  #define KVM_X86_DISABLE_EXITS_APERFMPERF       (1 << 4)
>   
>   Enabling this capability on a VM provides userspace with a way to no
>   longer intercept some instructions for improved latency in some
> @@ -7854,6 +7855,28 @@ all such vmexits.
>   
>   Do not enable KVM_FEATURE_PV_UNHALT if you disable HLT exits.
>   
> +Virtualizing the ``IA32_APERF`` and ``IA32_MPERF`` MSRs requires more
> +than just disabling APERF/MPERF exits. While both Intel and AMD
> +document strict usage conditions for these MSRs--emphasizing that only
> +the ratio of their deltas over a time interval (T0 to T1) is
> +architecturally defined--simply passing through the MSRs can still
> +produce an incorrect ratio.
> +
> +This erroneous ratio can occur if, between T0 and T1:
> +
> +1. The vCPU thread migrates between logical processors.
> +2. Live migration or suspend/resume operations take place.
> +3. Another task shares the vCPU's logical processor.
> +4. C-states lower thean C0 are emulated (e.g., via HLT interception).

s/thean/than/

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

