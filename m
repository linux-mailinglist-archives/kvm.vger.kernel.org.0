Return-Path: <kvm+bounces-15449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B4F78AC2A7
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 03:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57C31280E51
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 01:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D80974C6F;
	Mon, 22 Apr 2024 01:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e8Vrgf8w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D032595;
	Mon, 22 Apr 2024 01:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713750974; cv=none; b=kA5uwtXtMbECYmwWxMY1Pmpnaq5KoWrpfuLUXC4dgUTjuSXqLsnEtZ1DZ1Mg6G7PZZ9ONCcU/FMSLojIPYztpsleaWycjciaGzW4S2wJrQX4zWPTaQd5HowEntXt3c6cLlFlbFt7D9DGZaZoTp0TJcpXhAhuCNcnD/q2hqobUX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713750974; c=relaxed/simple;
	bh=pc0+DFhUnhDyqWAXr1SyPZIimJcwgm1tRpRj/vXiOPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s1upm3H7wEU06oP3GNGIzjZotHNlqlXJL03Gxt+rHRd9rVFDDON/BXvXcXcb3Bb+gf1drJxuujMDilD9eOIiRFCXrgyzVuleKym4DVuuaUUZn7p5x78YkAAMTxtNMPislQmcn5zryivQmyRqiX+gH+6lw/Y+nBCDTXSG9bTEhGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e8Vrgf8w; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713750973; x=1745286973;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pc0+DFhUnhDyqWAXr1SyPZIimJcwgm1tRpRj/vXiOPI=;
  b=e8Vrgf8wkggUkIm8gXRVpuvg7yTPD2/cA//yq+LXC/y9Se3xPqp7g/7e
   Jjpki3Tge+m3DuplQuWyHXeWndLoWH14wS1fHSiox1qUIR40p/GaF3QE5
   79aiDkurvzXlvQNnCTjKNT87Dg1VM89s6giTYmFIfpfODYNoWPnMrpzR6
   ElaTDncXG4s50/T1cyWdXLmSE/XqOyxqKTYeGi31ZTZ8mKExM7qnUoRQ1
   Y6dXiPTVvvSL4hhAdT/dUo+c4HwylVtGjeySN7q+TaSM1/CHcZPuC4A8C
   qvs+D5Kv6KDqwmukahYnWgbbP2bBXsSxJbS79NfWLVKAnu8Zb/Wsqfa1F
   Q==;
X-CSE-ConnectionGUID: jYx0fKqITTuvJSW1O9Z7Yw==
X-CSE-MsgGUID: rhEFXTPKQ6WBC1RzFPvNDw==
X-IronPort-AV: E=McAfee;i="6600,9927,11051"; a="9131984"
X-IronPort-AV: E=Sophos;i="6.07,219,1708416000"; 
   d="scan'208";a="9131984"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2024 18:56:12 -0700
X-CSE-ConnectionGUID: wi5hlz+XRde6C1OlC/+K2w==
X-CSE-MsgGUID: 834t/sWqSJqftSHZnQR6OA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,219,1708416000"; 
   d="scan'208";a="61310180"
Received: from unknown (HELO [10.238.8.201]) ([10.238.8.201])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2024 18:56:08 -0700
Message-ID: <1a3f4283-0dfd-4b7d-ae1b-f22c13a8c4e1@linux.intel.com>
Date: Mon, 22 Apr 2024 09:56:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 125/130] KVM: TDX: Add methods to ignore virtual apic
 related operation
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <52300c655b1e7d6cc0a13727d977f1f02729a4bb.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <52300c655b1e7d6cc0a13727d977f1f02729a4bb.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:27 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX protects TDX guest APIC state from VMM.  Implement access methods of
> TDX guest vAPIC state to ignore them or return zero.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c    | 61 ++++++++++++++++++++++++++++++++++----
>   arch/x86/kvm/vmx/tdx.c     |  6 ++++
>   arch/x86/kvm/vmx/x86_ops.h |  3 ++
>   3 files changed, 64 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index fae5a3668361..c46c860be0f2 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -352,6 +352,14 @@ static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>   	return vmx_apic_init_signal_blocked(vcpu);
>   }
>   
> +static void vt_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_set_virtual_apic_mode(vcpu);
Can open code this function...

> +
> +	return vmx_set_virtual_apic_mode(vcpu);
> +}
> +
[...]
>   
> +void tdx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> +{
> +	/* Only x2APIC mode is supported for TD. */
> +	WARN_ON_ONCE(kvm_get_apic_mode(vcpu) != LAPIC_MODE_X2APIC);
> +}
> +

