Return-Path: <kvm+bounces-16926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 490A18BEE70
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 22:55:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4058A1C20D62
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B294A71B32;
	Tue,  7 May 2024 20:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QI/LU4Os"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDA5187326;
	Tue,  7 May 2024 20:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715115346; cv=none; b=ipuqqy8yWr8bV1A99FKqqpmFz7dRxWIDygsUMGaXpY10Z8VVSeOnz5FFRPGeu3mDYd6fnS9/xPjosM0A6lyO0oXWtfbzd5QyvVe1dvxtytNxTdOMEcnO6h1xIWNR8/Puhi+g0hcnMDhtnDxk4xITLXLHYk+nar72lmJ1JtxwZPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715115346; c=relaxed/simple;
	bh=MXhk8PIuaqJAa98ag0HQIihWLoExROQ3x78g9+wPDTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b+2xcum7ApWPDUOuh73eNfUV8eL7fk5SDRIOfSvSh3DtGgjqpBD7u1htsApC8mkmKej563qCkcRbWFzj5BUgOR56ZUehnTpf/M2HWjnnWM8hyGfgIz/suBrDZYDCMHhOVMBVI/mQEcGxUfi9EmP4ji/9imjFpeIDW2OW9uGzFik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QI/LU4Os; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715115345; x=1746651345;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=MXhk8PIuaqJAa98ag0HQIihWLoExROQ3x78g9+wPDTw=;
  b=QI/LU4OswF9BFG2iLd1QjisB0sxuYh4W6eqjS1sDG1p9nYXo44aZg7vz
   fmu5n5XpgSalLz0lt0QH60V71nrteWNwhrc3NpBAA3m4fPKG6BiAvX+Q7
   HybJZ1l4QegFYrsmgeQOG7enlzQ/PGlFWX/gSlsrMmNYVoQoBGW/fVY5I
   LXawyXMixqc+TjTcGvz2FtlpxomDQg5yrOSrnqh9IFzlrMCVODOGD015Z
   mb6/PgVcorAuDI2WhrzCjx4hrnLmAmERVMDtaspwfBg1IM0Z3fhWr4ZA8
   uCeDaFNo8kOUTl+yJmgM/5ttEz4QK0B9xgDCl1hGFa1+K4lUVpRp+WJHR
   g==;
X-CSE-ConnectionGUID: yFmNsj2oRk2qa0FEj1uPWA==
X-CSE-MsgGUID: itIJOLdgTdqMSPy7qt7dSQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="11155919"
X-IronPort-AV: E=Sophos;i="6.08,143,1712646000"; 
   d="scan'208";a="11155919"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 13:55:44 -0700
X-CSE-ConnectionGUID: 3V4KOvHtTUeab6D7f4AwMw==
X-CSE-MsgGUID: zKBCLUQ+Tkq7rhFlGAUl4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,143,1712646000"; 
   d="scan'208";a="66075104"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 13:55:44 -0700
Date: Tue, 7 May 2024 13:55:43 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com,
	Reinette Chatre <reinette.chatre@intel.com>,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH v19 103/130] KVM: TDX: Handle EXIT_REASON_OTHER_SMI with
 MSMI
Message-ID: <20240507205543.GF13783@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <4a96a33c01b547f6e89ecf40224c80afa59c6aa4.1708933498.git.isaku.yamahata@intel.com>
 <Zgp62iK3HQEvcDyQ@chao-email>
 <20240403222336.GM2444378@ls.amr.corp.intel.com>
 <7ac867ff-62f4-419f-9a76-db015cd78ad7@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ac867ff-62f4-419f-9a76-db015cd78ad7@linux.intel.com>

On Tue, May 07, 2024 at 03:06:57PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > > > +		/*
> > > > +		 * The only reason it gets EXIT_REASON_OTHER_SMI is there is an
> > > > +		 * #MSMI(Machine Check System Management Interrupt) with
> > > > +		 * exit_qualification bit 0 set in TD guest.
> > > > +		 * The #MSMI is delivered right after SEAMCALL returns,
> > > > +		 * and an #MC is delivered to host kernel after SMI handler
> > > > +		 * returns.
> > > > +		 *
> > > > +		 * The #MC right after SEAMCALL is fixed up and skipped in #MC
> > > Looks fixing up and skipping #MC on the first instruction after TD-exit is
> > > missing in v19?
> > Right. We removed it as MSMI will provides if #MC happened in SEAM or not.
> 
> According to the patch of host #MC handler
> https://lore.kernel.org/lkml/171265126376.10875.16864387954272613660.tip-bot2@tip-bot2/,
> the #MC triggered by MSMI can be handled by kernel #MC handler.
> There is no need to call kvm_machine_check().
> 
> Does the following fixup make sense to you?

Yes. Now this patch becomes mostly none. So it makes more sense to squash
this patch into [PATCH v19 100/130] KVM: TDX: handle EXIT_REASON_OTHER_SMI.

> --------
> 
> KVM: TDX: Handle EXIT_REASON_OTHER_SMI
> 
> Handle "Other SMI" VM exit for TDX.
> 
> Unlike VMX, an SMI occurs in SEAM non-root mode cause VM exit to TDX
> module, then SEAMRET to KVM. Once it exits to KVM, SMI is delivered and
> handled by kernel handler right away.
> 
> Specifically, when BIOS eMCA MCE-SMI morphing is enabled, the #MC occurs
> in TDX guest is delivered as an Machine Check System Management Interrupt
> (MSMI) with the exit reason of EXIT_REASON_OTHER_SMI with MSMI (bit 0) set
> in the exit qualification.  On VM exit, TDX module checks whether the "Other
> SMI" is caused by a MSMI or not.  If so, TDX module makes TD as fatal,
> preventing further TD entries, and then completes the TD exit flow to KVM
> with the TDH.VP.ENTER outputs indicating TDX_NON_RECOVERABLE_TD.
> After TD exit, the MSMI is delivered and eventually handled by the kernel
> #MC handler[1].
> 
> So, to handle "Other SMI" VM exit:
> - For non-MSMI case, KVM doesn't need to do anything, just continue TDX vCPU
>   execution.
> - For MSMI case, since the TDX guest is dead, follow other non-recoverable
>   cases, exit to userspace.
> 
> [1] The patch supports handling MSMI signaled during SEAM operation.
>     It's already in tip tree.
> https://lore.kernel.org/lkml/171265126376.10875.16864387954272613660.tip-bot2@tip-bot2/
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 4ee94bfb17e2..fd756d231204 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -975,30 +975,6 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> tdexit_intr_info(vcpu));
>         else if (exit_reason == EXIT_REASON_EXCEPTION_NMI)
>                 vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
> -       else if (unlikely(tdx->exit_reason.non_recoverable ||
> -                tdx->exit_reason.error)) {
> -               /*
> -                * The only reason it gets EXIT_REASON_OTHER_SMI is there is
> an
> -                * #MSMI(Machine Check System Management Interrupt) with
> -                * exit_qualification bit 0 set in TD guest.
> -                * The #MSMI is delivered right after SEAMCALL returns,
> -                * and an #MC is delivered to host kernel after SMI handler
> -                * returns.
> -                *
> -                * The #MC right after SEAMCALL is fixed up and skipped in
> #MC
> -                * handler because it's an #MC happens in TD guest we cannot
> -                * handle it with host's context.
> -                *
> -                * Call KVM's machine check handler explicitly here.
> -                */
> -               if (tdx->exit_reason.basic == EXIT_REASON_OTHER_SMI) {
> -                       unsigned long exit_qual;
> -
> -                       exit_qual = tdexit_exit_qual(vcpu);
> -                       if (exit_qual & TD_EXIT_OTHER_SMI_IS_MSMI)
> -                               kvm_machine_check();
> -               }
> -       }
>  }
> 
>  static int tdx_handle_exception(struct kvm_vcpu *vcpu)
> @@ -1923,10 +1899,6 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t
> fastpath)
>                               to_kvm_tdx(vcpu->kvm)->hkid,
>                               set_hkid_to_hpa(0,
> to_kvm_tdx(vcpu->kvm)->hkid));
> 
> -               /*
> -                * tdx_handle_exit_irqoff() handled EXIT_REASON_OTHER_SMI. 
> It
> -                * must be handled before enabling preemption because it's
> #MC.
> -                */
>                 goto unhandled_exit;
>         }
> 
> @@ -1970,14 +1942,14 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu,
> fastpath_t fastpath)
>                 return tdx_handle_ept_misconfig(vcpu);
>         case EXIT_REASON_OTHER_SMI:
>                 /*
> -                * Unlike VMX, all the SMI in SEAM non-root mode (i.e. when
> -                * TD guest vcpu is running) will cause TD exit to TDX
> module,
> -                * then SEAMRET to KVM. Once it exits to KVM, SMI is
> delivered
> -                * and handled right away.
> +                * Unlike VMX, SMI occurs in SEAM non-root mode (i.e. when
> +                * TD guest vCPU is running) will cause VM exit to TDX
> module,
> +                * then SEAMRET to KVM.  Once it exits to KVM, SMI is
> delivered
> +                * and handled by kernel handler right away.
>                  *
> -                * - If it's an Machine Check System Management Interrupt
> -                *   (MSMI), it's handled above due to non_recoverable bit
> set.
> -                * - If it's not an MSMI, don't need to do anything here.
> +                * - A MSMI will not reach here, it's handled as
> non_recoverable
> +                *   case above.
> +                * - If it's not a MSMI, no need to do anything here.
>                  */
>                 return 1;
>         default:
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> index 2aecffe9f276..aa2fea7b2652 100644
> --- a/arch/x86/kvm/vmx/tdx_arch.h
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -41,8 +41,6 @@
>  #define TDH_PHYMEM_PAGE_WBINVD         41
>  #define TDH_VP_WR                      43
> 
> -#define TD_EXIT_OTHER_SMI_IS_MSMI      BIT_ULL(1)
> -
>  /* TDX control structure (TDR/TDCS/TDVPS) field access codes */
>  #define TDX_NON_ARCH                   BIT_ULL(63)
>  #define TDX_CLASS_SHIFT                        56
> 
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

