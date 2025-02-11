Return-Path: <kvm+bounces-37818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B337EA3046D
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 08:25:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57E051885F4E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 07:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B67B71EE002;
	Tue, 11 Feb 2025 07:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iWh7loAi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FCD1EDA0A;
	Tue, 11 Feb 2025 07:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739258638; cv=none; b=K/N4da+2GkBqBuA32kO4nIEHupfzkRVDjXlEgTZS7psb4twqOrZGPX59v1Sct4414X4ikKaAskVx6GRtB1q/QuXcRdMv5ObGhmoUIF2+bnb5uDD66m1o4FE/DjZ657CwrEosdmkHX5JQYSd1+0JVAqK+BTqdBEKnMH3Yj+VUjcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739258638; c=relaxed/simple;
	bh=F5r4C8NMbCEE1meAqoRpnKA1CAxFer5RTHKPUUhaNVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=saUu++zYgAkhZ3tekQl/Ew5+C+92tI5VvNwkJI42UWExJvGSjgI1T6HS3rK+HQJCgXs/yZj2zVNdCAxy5yvv60yyqnNrB7lfbrC58yeiryKS0XZAfYpXtsWlM2C+2Cw9zVFYR9dtu4aujUJTRMIKqEr9TRSvZ+vVoTQimQKQ9ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iWh7loAi; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739258637; x=1770794637;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=F5r4C8NMbCEE1meAqoRpnKA1CAxFer5RTHKPUUhaNVQ=;
  b=iWh7loAifpws11naVi743balS94qnauuLc2dhFkSTTiQIU3RmzOzD8e8
   WksnBDBpj5zqgrKzsDqCyrHECS4QDHiscAlyM5FThJyCMxAfmjMZwsX34
   OfYG2vTHUKMBtmv0ExZq1C29gSRzrFpv+Tp48wwrAWU7a0FyL/bWBeDTK
   BwDvi6Q7+iPDAMUGuppltC60e9VjZ8FP4nXOk7cE9at/6JXjazYvw3eu0
   se7V34lLPRNSDQ+UtNud7D5QfxLsPJZX1YzAsJQ+jcsMXU00zJepJbmSU
   zM3ArzYuKzpClipdsR2pNQazl58pNF38OGvJ0rfiZMWa+OTzmDOXhBFeN
   w==;
X-CSE-ConnectionGUID: XCOj3alBQ9ez+8J4Pb/dfA==
X-CSE-MsgGUID: qcXNutIARo6gVp/pBBSTOw==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="65220555"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="65220555"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 23:23:56 -0800
X-CSE-ConnectionGUID: oLqsXSh5S+yyTEkSX9GI0w==
X-CSE-MsgGUID: d9NYU0kBTaWYW0Jkwxk83A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112287055"
Received: from unknown (HELO [10.238.9.235]) ([10.238.9.235])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 23:23:53 -0800
Message-ID: <f2ae9257-8da5-4bdf-b7d0-eaeaadd208fe@linux.intel.com>
Date: Tue, 11 Feb 2025 15:23:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/17] KVM: TDX: Add support for find pending IRQ in a
 protected local APIC
To: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 linux-kernel@vger.kernel.org
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
 <20250211025828.3072076-2-binbin.wu@linux.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250211025828.3072076-2-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/11/2025 10:58 AM, Binbin Wu wrote:
[...]
> diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
> index 63f66c51975a..f0644d0bbe11 100644
> --- a/arch/x86/kvm/irq.c
> +++ b/arch/x86/kvm/irq.c
> @@ -100,6 +100,9 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
>   	if (kvm_cpu_has_extint(v))
>   		return 1;
>   
> +	if (lapic_in_kernel(v) && v->arch.apic->guest_apic_protected)
> +		return static_call(kvm_x86_protected_apic_has_interrupt)(v);
No functional impact.
But forgot to replace "static_call(kvm_x86_protected_apic_has_interrupt)(v)"
by "kvm_x86_call(protected_apic_has_interrupt)(v)"

> +
>   	return kvm_apic_has_interrupt(v) != -1;	/* LAPIC */
>   }
>   EXPORT_SYMBOL_GPL(kvm_cpu_has_interrupt);
[...]

