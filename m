Return-Path: <kvm+bounces-292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A997DDE8C
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 10:37:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 326BB28158D
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 09:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF972749B;
	Wed,  1 Nov 2023 09:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gI3b3JBt"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9D47477
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 09:37:25 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C9CDA;
	Wed,  1 Nov 2023 02:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698831441; x=1730367441;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qfbTbqFe+jHJjnHjeC4C2puWu2l4GMjxnP8YJ6YZt4A=;
  b=gI3b3JBtqOpzmIKbAPc/P4BwyNmTkYUA1uomfo2bnxnvskx/WpYw0Szk
   dTbrYNAcdCGg4zXHSHAIh8ID7DRZYJ7z2IkCLSVtpUyFZYukgED2WkuC6
   HrMGgemUY8RS99EF+SBbO98K2NJGVtxOeYJS2cwrAfPQwzN556HyUALjw
   H3uhkE0KL4daQsyRJbOJz7pRPfNv9oQaAfBJPOUb4TeqN5TeXVkqoimDp
   ZpzRX5Dc8vkyn8AQ8AvSqWuUW7t+kP2J3kmeyL571mGVab+EjefAYaA8B
   UIt2w2txCOOjH0rspAvwGB4IZwrLLGyleAt57uDePe3sy74L2acARsqka
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="388286177"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="388286177"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 02:37:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="934381027"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="934381027"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.12.33]) ([10.93.12.33])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 02:37:18 -0700
Message-ID: <05116375-f22c-4bc8-a766-d64b54b06da0@linux.intel.com>
Date: Wed, 1 Nov 2023 17:37:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] KVM: x86/pmu: Clean up emulated PMC event handling
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mingwei Zhang <mizhang@google.com>, Roman Kagan <rkagan@amazon.de>,
 Jim Mattson <jmattson@google.com>, Like Xu <like.xu.linux@gmail.com>
References: <20231023234000.2499267-1-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20231023234000.2499267-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/24/2023 7:39 AM, Sean Christopherson wrote:
> The ultimate goal of this series is to track emulated counter events using
> a dedicated variable instead of trying to track the previous counter value.
> Tracking the previous counter value is flawed as it takes a snapshot at
> every emulated event, but only checks for overflow prior to VM-Enter, i.e.
> KVM could miss an overflow if KVM ever supports emulating event types that
> can occur multiple times in a single VM-Exit.
>
> Patches 1-5 are (some loosely, some tightly) related fixes and cleanups to
> simplify the emulated counter approach implementation.  The fixes are
> tagged for stable as usersepace could cause some weirdness around perf
> events, but I doubt any real world VMM is actually affected.
>
> Sean Christopherson (6):
>    KVM: x86/pmu: Move PMU reset logic to common x86 code
>    KVM: x86/pmu: Reset the PMU, i.e. stop counters, before refreshing
>    KVM: x86/pmu: Stop calling kvm_pmu_reset() at RESET (it's redundant)
>    KVM: x86/pmu: Remove manual clearing of fields in kvm_pmu_init()
>    KVM: x86/pmu: Update sample period in pmc_write_counter()
>    KVM: x86/pmu: Track emulated counter events instead of previous
>      counter
>
>   arch/x86/include/asm/kvm-x86-pmu-ops.h |   2 +-
>   arch/x86/include/asm/kvm_host.h        |  17 +++-
>   arch/x86/kvm/pmu.c                     | 128 +++++++++++++++++++++----
>   arch/x86/kvm/pmu.h                     |  47 +--------
>   arch/x86/kvm/svm/pmu.c                 |  17 ----
>   arch/x86/kvm/vmx/pmu_intel.c           |  22 -----
>   arch/x86/kvm/x86.c                     |   1 -
>   7 files changed, 127 insertions(+), 107 deletions(-)
>
>
> base-commit: ec2f1daad460c6201338dae606466220ccaa96d5

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


