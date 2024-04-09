Return-Path: <kvm+bounces-13995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9BA289DD57
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 16:53:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB39A1C218EE
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 14:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2746712F5A3;
	Tue,  9 Apr 2024 14:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nz5M6gVn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8469374D9;
	Tue,  9 Apr 2024 14:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712674420; cv=none; b=kqOWr1bfKHuZpH1S6oxeRoEAm3fIbTW0h9qvOlwOVOvbhiSDy+kHA82qnc70wiQbkbGA/JQo3jOIPLdpefiMHurPia7nBMM8WcTy9RZDZMjlbbDcoWq+NYTDc+/MP/Pbb++1MpBZEWOamnw5UYbcVbviEH5d/r/q0Lb2j0uO88U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712674420; c=relaxed/simple;
	bh=w1ePFvKR4S780uKjjEPPkdMng6iW3rIAvTCdB4ZkJqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HPXM4c5JDQQnLmOJx0eH6rokCoXwtjPPV/dEwGF33WwYU+gKXxpeRzRkKibcjFbDx8KROrCD1FH1aGm6SXXWJc+i56/qqanQ2kAFTfs6Q4SgKOKZLjqiQNy49msX2SF0IQJ8NdEtETXSgm9pvOrpcGx3OeExNlFQgB/4XtMIizo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nz5M6gVn; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712674418; x=1744210418;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=w1ePFvKR4S780uKjjEPPkdMng6iW3rIAvTCdB4ZkJqw=;
  b=Nz5M6gVnDrqFTYQTnl4UlB/aneJQj3qLprhX0sg6Hxp9g8Lrq0w3dIfQ
   630cbo6K0qxx4FDxOF+tqFlnnog/+bzmSnQFceoNp8W7TlxZMof6qkChy
   tqZtY8KcALC/UlZmHNT80k5WreRdkMaQD6LWUbiDDEkuckBxaOgmkzjU9
   SE0cl/Tcx1s6xo33wAyEr9c3G0imD8a35JrBWwuZnzGDbHZwihEoc8Ujo
   5BaucCdnvexyTakilPRzZfRPMTDtv/Yzk0A9H7bngVuhNHU57TY/CE0+F
   Uq/Bdy/8oLmozGSawzw7MLWrQS04uYiI//goSPyxJyZF2PDAXthDPXOib
   Q==;
X-CSE-ConnectionGUID: lZ1OQNEzQkOhe+u01WWa+A==
X-CSE-MsgGUID: 3h3VOitVTd2QFJ6rIHJDDQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8170542"
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="8170542"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 07:53:38 -0700
X-CSE-ConnectionGUID: FGQrKwuEQCKGPNEQk3CyXg==
X-CSE-MsgGUID: tSbBUUDXS0GwQR9iTpLUdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="20360858"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 07:53:35 -0700
Message-ID: <cb0e3e23-786b-4d9e-984e-8207a58faa24@linux.intel.com>
Date: Tue, 9 Apr 2024 22:53:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 100/130] KVM: TDX: handle EXIT_REASON_OTHER_SMI
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <d1f5a1375c7e402aa121e5970b3599e1a69ffdfb.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d1f5a1375c7e402aa121e5970b3599e1a69ffdfb.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> If the control reaches EXIT_REASON_OTHER_SMI, #SMI is delivered and
> handled right after returning from the TDX module to KVM

need a "," here

>   nothing needs to
> be done in KVM.  Continue TDX vcpu execution.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/include/uapi/asm/vmx.h | 1 +
>   arch/x86/kvm/vmx/tdx.c          | 7 +++++++
>   2 files changed, 8 insertions(+)
>
> diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
> index a5faf6d88f1b..b3a30ef3efdd 100644
> --- a/arch/x86/include/uapi/asm/vmx.h
> +++ b/arch/x86/include/uapi/asm/vmx.h
> @@ -34,6 +34,7 @@
>   #define EXIT_REASON_TRIPLE_FAULT        2
>   #define EXIT_REASON_INIT_SIGNAL			3
>   #define EXIT_REASON_SIPI_SIGNAL         4
> +#define EXIT_REASON_OTHER_SMI           6
What does "OTHER" mean in this macro?

>   
>   #define EXIT_REASON_INTERRUPT_WINDOW    7
>   #define EXIT_REASON_NMI_WINDOW          8
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index cba0fd5029be..2f68e6f2b53a 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1345,6 +1345,13 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>   	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
>   
>   	switch (exit_reason.basic) {
> +	case EXIT_REASON_OTHER_SMI:
> +		/*
> +		 * If reach here, it's not a Machine Check System Management
> +		 * Interrupt(MSMI).
Since it's the first patch that mentions MSMI, maybe some description 
about it in the changelog can make it easier to understand.


>    #SMI is delivered and handled right after
> +		 * SEAMRET, nothing needs to be done in KVM.
> +		 */
> +		return 1;
>   	default:
>   		break;
>   	}


