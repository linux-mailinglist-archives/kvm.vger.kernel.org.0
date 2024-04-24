Return-Path: <kvm+bounces-15816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 042338B0DAF
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A2B11F26DF6
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5285B15F40B;
	Wed, 24 Apr 2024 15:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c8IF+7Mf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB5A15F3FB
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713971516; cv=none; b=POMQjF6PpWD171NAyBPdsS3x4rBnpC3mmbR4BniRgNd8mc/m+H1Cl02Dgcx3919dKxHeJZKgaNTnRVvJagKDIdSEU/SBza+G1zrBY3uMhnVbjNUDBgus/7+Fi699Zs8hhBxQlTXjN3U2JIqLtHkS8edGVjgs9ecXRGPJGFIA+cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713971516; c=relaxed/simple;
	bh=z+yYUortuN9MLve/Ru6n/slcgqQeEK0ycWBgsD8ltgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p+MdI84D5KKGWeY0gkJ4S0ygvi5oCOjCjq+JV6wc+jyrTbCxM4Bz10HSXINAvIGNi7cDeVxADXckipzgTecp7MeDPZn0plabjZCbnwvWfP44XWCdLfsuOtq+y9JueeCNK239a92r14Dew02/mObW32MZtCw+tnW3fWiCpwIV50c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c8IF+7Mf; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713971515; x=1745507515;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=z+yYUortuN9MLve/Ru6n/slcgqQeEK0ycWBgsD8ltgU=;
  b=c8IF+7MfVz5C0pxTRESMeJYZPisayIc55T3ez6rY+IBEhRHsotYFt6td
   wZtIN9K/oxbn3ikpARRwK4BbcDvRwQX214j2Hx8+44TPJXL1zDH1HyNgD
   YGHuacAp7vNzVbJlcyDHnyVc/bXrluomc6TQytPVhvlvzFr9CvKUF5DoB
   u2CZk0OHwwwm/CGlRoAhPJNgUgfASOHchPUd8rKrBBxn+tPAT8ebetLeV
   /w/2c9YLkXWu/0tfCouS4cyESO+BzGiN2HWm6ojOd84s1/ZU83D1k2Qhp
   H2XAVLVtCk/08B1CNzFCkawxo47Qq5zh/HDnDGIMsRIafKJdoqzDJJldX
   w==;
X-CSE-ConnectionGUID: 5SohohHJQcuFRXAhgZEebg==
X-CSE-MsgGUID: 376KHhRJRwKW3LzIVYvIVw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9772664"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9772664"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 08:11:52 -0700
X-CSE-ConnectionGUID: c9IMInXcT4OiWPCx3Bo/vA==
X-CSE-MsgGUID: SmpQ8IYDRKuV4ZwLsss+Lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="48005578"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 08:11:47 -0700
Message-ID: <5e7cbb8b-51e6-4be9-868b-601a0418374e@intel.com>
Date: Wed, 24 Apr 2024 23:11:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-9.1 2/7] target/i386/kvm: Remove local
 MSR_KVM_WALL_CLOCK and MSR_KVM_SYSTEM_TIME definitions
To: Zhao Liu <zhao1.liu@linux.intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Tim Wiederhake <twiederh@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Zhao Liu <zhao1.liu@intel.com>
References: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
 <20240329101954.3954987-3-zhao1.liu@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240329101954.3954987-3-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/2024 6:19 PM, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> These 2 MSRs have been already defined in the kvm_para header
> (standard-headers/asm-x86/kvm_para.h).
> 
> Remove QEMU local definitions to avoid duplication.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   target/i386/kvm/kvm.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 2f3c8bc3a4ed..be88339fb8bd 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -78,9 +78,6 @@
>   #define KVM_APIC_BUS_CYCLE_NS       1
>   #define KVM_APIC_BUS_FREQUENCY      (1000000000ULL / KVM_APIC_BUS_CYCLE_NS)
>   
> -#define MSR_KVM_WALL_CLOCK  0x11
> -#define MSR_KVM_SYSTEM_TIME 0x12
> -
>   /* A 4096-byte buffer can hold the 8-byte kvm_msrs header, plus
>    * 255 kvm_msr_entry structs */
>   #define MSR_BUF_SIZE 4096


