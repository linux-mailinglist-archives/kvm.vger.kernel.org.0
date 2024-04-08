Return-Path: <kvm+bounces-13844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E1AE89B814
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 09:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEA17281BFC
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 07:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 844892562E;
	Mon,  8 Apr 2024 07:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QE9LnlOy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32841F93E;
	Mon,  8 Apr 2024 07:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712559729; cv=none; b=jGAb9TtG2JV3Q8/LC158rh8WpUmjM5CsUMzVG7ISTLh/H9vzzF2D1Y8EQXNIwcmK60RrLU/BU6TUOIPI8+BJXK5avuXZ4xlaq92jU7qYwaTx3WLJxajidEgTzl4yeFadhlPuSszxpcRnZBFLAJmCa9ezFq/TVIbkJzVap+KZmdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712559729; c=relaxed/simple;
	bh=nSEOvxxKA2GkiOTXh/bLCcoY5ImyTca4m0G6OJ/4FZE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=PRWVhq6ToJbQZTQiPT5mao9C9WbZgL2CKiDOMaNOIMRnRrYJWT0eoTHDzMd1wq1R1ztxIYag6nmvmOk5TixABYlnUJX4MZmHLUOeV2xk8jHSOCtJv2iuVf2HgpJGwN62XGFGHElztWytc650CGA+jmKA2gH9uQvFrkoMlA+mYLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QE9LnlOy; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712559728; x=1744095728;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=nSEOvxxKA2GkiOTXh/bLCcoY5ImyTca4m0G6OJ/4FZE=;
  b=QE9LnlOy1yWboM1VC5fQEOhtf3fD0rN6RXMnbwXhGa69zrtWV6NWAtEm
   vAn26S6Dq95anlODCRoKT9KPiMS+icnD4lzTJxA502LpjP6jcdjXTcqeD
   DFBx4jxh/awyPKqkfDEy9qlc3ewzk5mOviv99Vw3Av3tW3NA8kxu8cAlv
   2nm70igRP+TZ0hVs++ARNQXyAHSfkZF1ON0Ylb7HvwZNs139GiDX9LuYP
   RaA1lmPRfDm3BWZfNMBQkIU7sJNTX2+4Ch6BfvJcHkHslU8xagNhlRbtR
   8Sw835QcpmZpm24tAAeANA0G+ndYZ2vIZpt1Q1lw+Dp5tFV5jYy0tPsAg
   A==;
X-CSE-ConnectionGUID: uH8S54TpT429xTOulJO1cQ==
X-CSE-MsgGUID: JXIgCJOPQC6L9USWNnRcnQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11037"; a="8006073"
X-IronPort-AV: E=Sophos;i="6.07,186,1708416000"; 
   d="scan'208";a="8006073"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 00:02:02 -0700
X-CSE-ConnectionGUID: zfaBaHyORCWFLPcV9OMNXw==
X-CSE-MsgGUID: 1Pttfa8xS8mIEGJNZBiH8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,186,1708416000"; 
   d="scan'208";a="24526398"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.252]) ([10.238.9.252])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 00:01:58 -0700
Message-ID: <2c62889c-2978-48bc-accb-8b83183bd1fa@linux.intel.com>
Date: Mon, 8 Apr 2024 15:01:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v19 092/130] KVM: TDX: Implement interrupt injection
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b2d9539b23f155b95864db3eacce55e0e24eed4d.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <b2d9539b23f155b95864db3eacce55e0e24eed4d.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata<isaku.yamahata@intel.com>
>
> TDX supports interrupt inject into vcpu with posted interrupt.  Wire up the
> corresponding kvm x86 operations to posted interrupt.  Move
> kvm_vcpu_trigger_posted_interrupt() from vmx.c to common.h to share the
> code.
>
> VMX can inject interrupt by setting interrupt information field,
> VM_ENTRY_INTR_INFO_FIELD, of VMCS.  TDX supports interrupt injection only
> by posted interrupt.  Ignore the execution path to access
> VM_ENTRY_INTR_INFO_FIELD.
>
> As cpu state is protected and apicv is enabled for the TDX guest, VMM can
> inject interrupt by updating posted interrupt descriptor.  Treat interrupt
> can be injected always.
>
> Signed-off-by: Isaku Yamahata<isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini<pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/common.h      | 71 ++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/main.c        | 93 ++++++++++++++++++++++++++++++----
>   arch/x86/kvm/vmx/posted_intr.c |  2 +-
>   arch/x86/kvm/vmx/posted_intr.h |  2 +
>   arch/x86/kvm/vmx/tdx.c         | 25 +++++++++
>   arch/x86/kvm/vmx/vmx.c         | 67 +-----------------------
>   arch/x86/kvm/vmx/x86_ops.h     |  7 ++-
>   7 files changed, 190 insertions(+), 77 deletions(-)
>
[...]
>   
> +static void vt_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;

Please add a blank line.

> +	vmx_set_interrupt_shadow(vcpu, mask);
> +}
> +
[...]
>   
> @@ -848,6 +853,12 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	trace_kvm_entry(vcpu);
>   
> +	if (pi_test_on(&tdx->pi_desc)) {
> +		apic->send_IPI_self(POSTED_INTR_VECTOR);
> +
> +		kvm_wait_lapic_expire(vcpu);
As Chao pointed out, APIC timer change shouldn't be included in this patch.

Maybe better to put the splitted patch closer to patch
"KVM: x86: Assume timer IRQ was injected if APIC state is proteced"
becasue they are related.

> +	}
> +
>   	tdx_vcpu_enter_exit(tdx);
>   
>   	tdx_user_return_update_cache(vcpu);
> @@ -1213,6 +1224,16 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>   	return tdx_sept_drop_private_spte(kvm, gfn, level, pfn);
>   }
>   
[...]

