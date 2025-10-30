Return-Path: <kvm+bounces-61456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE388C1E729
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 06:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 169AA400671
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 05:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BDD62F618C;
	Thu, 30 Oct 2025 05:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PI+AP8BB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642B2286419;
	Thu, 30 Oct 2025 05:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761802825; cv=none; b=cWQ1M/z7/GqqYkwrbcx8z2u2095GLgEAS8eY4406MI7vf3cMTmbu1olCmhfuNEcDkCemHccTXJC3VdmEVtNn2rRIgY8SfMonDKpmpEu65SwPOz7qmPoBN2JZYjXDO1vjPse7TNJkqAUhktjsZB3Hwg1EkOYet3icEYL16Ekwq2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761802825; c=relaxed/simple;
	bh=jHCNvinaOkYM655G2d10JGOUEvs4HKvUSGzoQaDdvPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sfc7y2tgh1EcHv5QxYu6+VBYioSM1tBnv2gOt9CMt2EYwKcDWzcuY9yC4IE1IGGP3S5SEBYqaLk+r+3HXTMQFvm9Dn0XCD7sKNNd/Qu/NFf7AEflM9U68Nn4Mf8j++FZ1zSrhTEUDeBKJbwGiygtuYWB6mktQcdIm7ndYfNOGio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PI+AP8BB; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761802823; x=1793338823;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jHCNvinaOkYM655G2d10JGOUEvs4HKvUSGzoQaDdvPo=;
  b=PI+AP8BBEXt5ghpf/S969bZ35x6EGR7QjfR5N006adLJMduzU0atW+jY
   SmK8LfnlAjqxgdvIJABNsoTVy4kt+oZsHx3uDwFKmF0xR8VIBUbpbw5Sw
   2OHb07jO1Zc26CJklh6OPxGn8326CEIMpKniXeSpVxTRWHPp7ipJLhJ2j
   7Bp0SRzDwk0icHq0mEjhtccp9IpiWo8SWimNINBiyaNoLw/AiLI9cEnel
   JUEyUb1rXP8Yjr97U8+sdI6K4oIZGx1d4Fe9ysO7RlnyytaAINHIYPijT
   oJu6Cj5sIuORjbuVshv4jsROKwm+ZyOGtsasK6FGXjIpTw5+q+Z9mTxUn
   w==;
X-CSE-ConnectionGUID: 51seY/GUTa2EHiIpJI2hJA==
X-CSE-MsgGUID: xwVhIhrTSW6DPACO0QBfCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="62958413"
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="62958413"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 22:40:23 -0700
X-CSE-ConnectionGUID: AMlTHf/dSe+VWVWA/3K/gw==
X-CSE-MsgGUID: 3PFZ2nniREmq9C9A9U69zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="190193623"
Received: from vverma7-desk1.amr.corp.intel.com (HELO desk) ([10.124.223.151])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 22:40:22 -0700
Date: Wed, 29 Oct 2025 22:40:14 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Tao Zhang <tao1.zhang@intel.com>,
	Jim Mattson <jmattson@google.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH 2/3] x86/mmio: Rename cpu_buf_vm_clear to
 cpu_buf_vm_clear_mmio_only
Message-ID: <20251030054014.ev7caj7ejrl5hpgv@desk>
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
 <20251029-verw-vm-v1-2-babf9b961519@linux.intel.com>
 <aQKuy34wmCWvXcMS@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQKuy34wmCWvXcMS@google.com>

On Wed, Oct 29, 2025 at 05:18:19PM -0700, Sean Christopherson wrote:
> On Wed, Oct 29, 2025, Pawan Gupta wrote:
> > cpu_buf_vm_clear static key is only used by the MMIO Stale Data mitigation.
> > Rename it to avoid mixing it up with X86_FEATURE_CLEAR_CPU_BUF_VM.
> > 
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> 
> ...
> 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index f87c216d976d7d344c924aa4cc18fe1bf8f9b731..451be757b3d1b2fec6b2b79157f26dd43bc368b8 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -903,7 +903,7 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
> >  	if (!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL))
> >  		flags |= VMX_RUN_SAVE_SPEC_CTRL;
> >  
> > -	if (static_branch_unlikely(&cpu_buf_vm_clear) &&
> > +	if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only) &&
> >  	    kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
> >  		flags |= VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO;
> 
> The use in vmx_vcpu_enter_exit() needs to be renamed as well.  The code gets
> dropped in patch 3, but intermediate builds will fail.

Ya, thanks for catching it.

