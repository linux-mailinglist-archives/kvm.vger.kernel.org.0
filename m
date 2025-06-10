Return-Path: <kvm+bounces-48797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 843DDAD2E9A
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 09:26:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60D353B273C
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 07:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6258127EC7D;
	Tue, 10 Jun 2025 07:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cLtzMBC2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A471F874F;
	Tue, 10 Jun 2025 07:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749540365; cv=none; b=T4t3kliBww6rAG3FWoni4EcyPUErgtoWTzcInl5v+maY9incZ5DEMThBXH0M3DpYaqEEypE/YB3rhiHwUeLQhIcVDyKtyEan0HSGdIzVeUfZjWK88q10xUlJar/dA8d6s4/8OHcMwf6I8JE/s5eR5Ddlb7M23VMSEi6WGI2r8Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749540365; c=relaxed/simple;
	bh=5Y3rWuErxoP+DxbOXS+XbWOfhUALPrEO4AVaKLW4xWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uf0iA41T/T+E4EcFi6N/KIreYLg9cvfi3m8sA69EvYORESniB7/deUCFANPVmXJwxPRzDD9EYecPQJXmRr4D7HvHnxKO0MVPVHJJ5tS9a3iJ3XnTl0toixpy2F/LPqdFglkfNmHctHw0wUmx1W3IadUbWStd+napG3pyWm2dsYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cLtzMBC2; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749540364; x=1781076364;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5Y3rWuErxoP+DxbOXS+XbWOfhUALPrEO4AVaKLW4xWY=;
  b=cLtzMBC2aPcNK3rQ4kedZTMEFYE/GXpFg2ubJ6zRv7P1uJm++VAXBU+a
   4YzWaW+MG/j/oEazKxfmHpA0Zb/gRWJZXPbiLR9/H3fri8ljmg9RmY20T
   BKegRnRHbVwnnPmxqCXyK5DZkHRYRFJvEeXYj9EBEJItBr9DEPYbXzgRX
   XRpTLQYPTYWb8NFZPGhD6/rX2KoJ+UdgB155F96ocSor5GzfZDTLo2kMv
   fOum61mqextERczJr7I6+zky8p6XAmlOFLH8RW+EgUFlFuVnS6cadWcYG
   xmcuU8Wah7iZTsrd1nngXPVGcSR0Ah70s1w+F25f+DlOYkvizFUu+fIBl
   w==;
X-CSE-ConnectionGUID: kUJ55LY0SnefnFhSA+z0Og==
X-CSE-MsgGUID: IHshyRRjQuKLprIwUXuuoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="61906028"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="61906028"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 00:25:47 -0700
X-CSE-ConnectionGUID: JUpyczpCRl+RBIe4uKd3Xg==
X-CSE-MsgGUID: IrHAYlSaQziqxQQTivncUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="177668479"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 00:25:45 -0700
Message-ID: <cf52eac4-a366-41a1-9a4a-962efdb260ca@linux.intel.com>
Date: Tue, 10 Jun 2025 15:25:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 11/16] x86/sev: Use VC_VECTOR from
 processor.h
To: Sean Christopherson <seanjc@google.com>,
 Andrew Jones <andrew.jones@linux.dev>, Janosch Frank
 <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 =?UTF-8?Q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20250529221929.3807680-1-seanjc@google.com>
 <20250529221929.3807680-12-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250529221929.3807680-12-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 5/30/2025 6:19 AM, Sean Christopherson wrote:
> Use VC_VECTOR (defined in processor.h along with all other known vectors)
> and drop the one-off SEV_ES_VC_HANDLER_VECTOR macro.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/x86/amd_sev.c | 4 ++--
>  lib/x86/amd_sev.h | 6 ------
>  2 files changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
> index 66722141..6c0a66ac 100644
> --- a/lib/x86/amd_sev.c
> +++ b/lib/x86/amd_sev.c
> @@ -111,9 +111,9 @@ efi_status_t setup_amd_sev_es(void)
>  	 */
>  	sidt(&idtr);
>  	idt = (idt_entry_t *)idtr.base;
> -	vc_handler_idt = idt[SEV_ES_VC_HANDLER_VECTOR];
> +	vc_handler_idt = idt[VC_VECTOR];
>  	vc_handler_idt.selector = KERNEL_CS;
> -	boot_idt[SEV_ES_VC_HANDLER_VECTOR] = vc_handler_idt;
> +	boot_idt[VC_VECTOR] = vc_handler_idt;
>  
>  	return EFI_SUCCESS;
>  }
> diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
> index ed6e3385..ca7216d4 100644
> --- a/lib/x86/amd_sev.h
> +++ b/lib/x86/amd_sev.h
> @@ -39,12 +39,6 @@
>  bool amd_sev_enabled(void);
>  efi_status_t setup_amd_sev(void);
>  
> -/*
> - * AMD Programmer's Manual Volume 2
> - *   - Section "#VC Exception"
> - */
> -#define SEV_ES_VC_HANDLER_VECTOR 29
> -
>  /*
>   * AMD Programmer's Manual Volume 2
>   *   - Section "GHCB"

LGTM. 

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



