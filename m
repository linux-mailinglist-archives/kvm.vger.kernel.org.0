Return-Path: <kvm+bounces-21875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E24859352DC
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:08:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BA0DB21F8A
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F9B1145FFC;
	Thu, 18 Jul 2024 21:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NQ48y0wp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444C51459F3
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 21:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721336828; cv=none; b=eJTOph1I7Hz5ExR/fCAoNlbm5W0KfjPyCsp/DLaS4JDR5LnUevhSQoST3xyAx5ZMH6auCBmUi2mvnTfZhSQmbgK/smj0xDNsHxt4341PABLVpba+VkMRQ1d7D00xdxYCdAszae/CHTryY57bpACia4kUBk0h+3MP7E0lfRXL5zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721336828; c=relaxed/simple;
	bh=6cVAc5ZQ+ZSn/WSm3lNXrMsM9aijcrjimTqBxDauiwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PdsLcsawTo5FtzX6cy5YKmugko+cTEfAlIHTVVeQNTIkTujHEOyGamLMpd5//EDqn2heANzEP9LlxZ//j0uEOThsHy64yPAqacEsOxjgZxdTcS2ir80ZgpjPEKeEgHExXrzDkd+R1Fegc0u5O47mc+ujYtJuMJS6NW2J3Q9wMsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NQ48y0wp; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721336826; x=1752872826;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6cVAc5ZQ+ZSn/WSm3lNXrMsM9aijcrjimTqBxDauiwg=;
  b=NQ48y0wpuiKWXyv8LIgeferworbUNisSR2G17MVp6i69+LzJ/MVMwJa0
   wLwL17R4UxLb4JJI/D9z7n2EzGnggFBvuZ2bhoZwLJMDIngIMLk7QUNRc
   y55DXLVNjluKXhcM8VV+5V+bw7gkms8c63JGeJZ3hY4wDtppvMLp30QAj
   TQR8Nbiu67XNABV+e91dK2rqENwKrK/SEePe+JFzG4ZSpd9IeTCEr8JKy
   H/a27AWTJ5F5WOl8owYBTcIiEZOzLf1InGRZSLFlS2mRmgIIvbJ1SGMAk
   Y5+MEKbHyfPRxMuO0rJ06h3M9iFyXbnRgfAna+ZV1PYA5J8LRtJJkFD7U
   A==;
X-CSE-ConnectionGUID: iGp9J5IqT2SISt++qNpmvg==
X-CSE-MsgGUID: A0CF/MiiSiOD6sbHNHF/Uw==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="21831321"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="21831321"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:07:04 -0700
X-CSE-ConnectionGUID: ITIjB/xtRYW0Rz8JfsIDzw==
X-CSE-MsgGUID: DuMPHg2MSNuzWZ9IKhMS2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55178725"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.107]) ([10.24.10.107])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:07:03 -0700
Message-ID: <5540a8e3-7603-4b14-b7f3-4c0101deb930@intel.com>
Date: Thu, 18 Jul 2024 14:07:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/9] target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK
 and MSR_KVM_SYSTEM_TIME definitions
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240716161015.263031-1-zhao1.liu@intel.com>
 <20240716161015.263031-3-zhao1.liu@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240716161015.263031-3-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/16/2024 9:10 AM, Zhao Liu wrote:
> These 2 MSRs have been already defined in kvm_para.h (standard-headers/
> asm-x86/kvm_para.h).
> 
> Remove QEMU local definitions to avoid duplication.
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>


Reviewed-by: zide.chen@intel.com

> ---
>  target/i386/kvm/kvm.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 86e42beb78bf..6ad5a7dbf1fd 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -81,9 +81,6 @@
>  #define KVM_APIC_BUS_CYCLE_NS       1
>  #define KVM_APIC_BUS_FREQUENCY      (1000000000ULL / KVM_APIC_BUS_CYCLE_NS)
>  
> -#define MSR_KVM_WALL_CLOCK  0x11
> -#define MSR_KVM_SYSTEM_TIME 0x12
> -
>  /* A 4096-byte buffer can hold the 8-byte kvm_msrs header, plus
>   * 255 kvm_msr_entry structs */
>  #define MSR_BUF_SIZE 4096

