Return-Path: <kvm+bounces-16071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 101F78B3E1C
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 19:30:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 423D51C21ABC
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 17:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68EC173354;
	Fri, 26 Apr 2024 17:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WLbHYH33"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438A2181B9A
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 17:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714152210; cv=none; b=TnGbGOp1NSR8kkQN8BzNMdu1FT4pGJiBWKoN9YnwEPeVVcv4Ke0V1PBWLy0UHrbBnDW6j3nXgCPM34tgXLY7fpQsqfokb9XolWMLStrXcQBaZeVVMJXBFTRzxtWwVVPw36TEgdWZdk9Itepr1jQDlQru3FrYbPtOPSnMDs3pQiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714152210; c=relaxed/simple;
	bh=KnYbAszjZrxr8PTiejoIwc2DTVTVf+JChhwgv7diWtU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M+oAR8d8RxOYezRWSMFNE0RI5A0V1xKVqBK1/Ti4WEqvv5EA5vGkaFdUIvywpc5pxWd8F+IrzPmngYb2aoWtNogi7UsRonA7YjrAPupbW+LunlGNWKResfO4Nm25YbVshfNVZjOFlf8RLj4ynfIZz52Bt5EOhUlUsAyQ/uYuJRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WLbHYH33; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714152208; x=1745688208;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KnYbAszjZrxr8PTiejoIwc2DTVTVf+JChhwgv7diWtU=;
  b=WLbHYH33ONYOklPE/zydZyPMuCtdJkzhkakzTq76XMXeqAwnPS7pZGK4
   Z59xWkvTsDOkwLj/3swohX+N+RA0Hum25L4H2HyNh1wOcjB59fWcWYWzs
   2G4wUS+bLyKxRL3PlHnuvxHI3gwQPe4lcuhE+gcbDDtIBWTQcBqPAfNIl
   RRmlwjuLefknkjPlbSp+sQJLQeAMGr+UhQC+BISRgm7jAkiJIiPAsgpil
   en6S0HpDedNseZfNWev0itzlQILYAYAF9ZRg/qrW1JOrW4ua2wfSLlJ40
   8c9Ad4SKGoZcM+sU19dNdyxiFvFBjOeNY9vg0AOmc0epaSUf3cJufk3UM
   Q==;
X-CSE-ConnectionGUID: MLV6a2vjSC6qq2sovKEGUw==
X-CSE-MsgGUID: eODC1NU8QyqMF8Ou1Bfk/g==
X-IronPort-AV: E=McAfee;i="6600,9927,11056"; a="9759083"
X-IronPort-AV: E=Sophos;i="6.07,233,1708416000"; 
   d="scan'208";a="9759083"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 10:23:27 -0700
X-CSE-ConnectionGUID: z7sUbiCGSFmKd5rsK5d8Zg==
X-CSE-MsgGUID: /IxMH9VbTjmblPTzfqH4oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,233,1708416000"; 
   d="scan'208";a="26116258"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.50]) ([10.24.10.50])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 10:23:27 -0700
Message-ID: <04d827f7-fb18-4c93-b223-91dd5e190421@intel.com>
Date: Fri, 26 Apr 2024 10:23:27 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] target/i386/kvm: Add feature bit definitions for KVM
 CPUID
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20240426100716.2111688-1-zhao1.liu@intel.com>
 <20240426100716.2111688-2-zhao1.liu@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240426100716.2111688-2-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/26/2024 3:07 AM, Zhao Liu wrote:
> Add feature definiations for KVM_CPUID_FEATURES in CPUID (
> CPUID[4000_0001].EAX and CPUID[4000_0001].EDX), to get rid of lots of
> offset calculations.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> v2: Changed the prefix from CPUID_FEAT_KVM_* to CPUID_KVM_*. (Xiaoyao)
> ---
>  hw/i386/kvm/clock.c   |  5 ++---
>  target/i386/cpu.h     | 23 +++++++++++++++++++++++
>  target/i386/kvm/kvm.c | 28 ++++++++++++++--------------
>  3 files changed, 39 insertions(+), 17 deletions(-)
> 
> diff --git a/hw/i386/kvm/clock.c b/hw/i386/kvm/clock.c
> index 40aa9a32c32c..ce416c05a3d0 100644
> --- a/hw/i386/kvm/clock.c
> +++ b/hw/i386/kvm/clock.c
> @@ -27,7 +27,6 @@
>  #include "qapi/error.h"
>  
>  #include <linux/kvm.h>
> -#include "standard-headers/asm-x86/kvm_para.h"
>  #include "qom/object.h"
>  
>  #define TYPE_KVM_CLOCK "kvmclock"
> @@ -334,8 +333,8 @@ void kvmclock_create(bool create_always)
>  
>      assert(kvm_enabled());
>      if (create_always ||
> -        cpu->env.features[FEAT_KVM] & ((1ULL << KVM_FEATURE_CLOCKSOURCE) |
> -                                       (1ULL << KVM_FEATURE_CLOCKSOURCE2))) {
> +        cpu->env.features[FEAT_KVM] & (CPUID_KVM_CLOCK |
> +                                       CPUID_KVM_CLOCK2)) {

To achieve this purpose, how about doing the alternative to define an
API similar to KVM's guest_pv_has()?

xxxx_has() is simpler and clearer than "features[] & CPUID_xxxxx",
additionally, this helps to keep the definitions identical to KVM, more
readable and easier for future maintenance.

