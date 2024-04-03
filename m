Return-Path: <kvm+bounces-13504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CCA4897B94
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 00:23:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42B5728B314
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 22:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B90156991;
	Wed,  3 Apr 2024 22:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="amJTA/YM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C871156980;
	Wed,  3 Apr 2024 22:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712183019; cv=none; b=lOrpQXGWzmbD3TDKoN5lbntRuRAFD3uLhF7agDt/mNzPBfgB29uApa8fqnxdkNJbs7DIMx06lmg31gcMvluEA8oApu/xhUEnbiEQLysIEMcljLMOUPGESv3R5/NKS5fnIChmkL1bCyfX4s73MGLm3frDwzLsrEZoXZM7Zfiw3Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712183019; c=relaxed/simple;
	bh=pWM1onNqeCEXMo93hDuWfRBO3wRf9NoZkKnKyqnZpJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DyPY0QMSzJSeUMfGDVJ6kz9iuIO0miqvwayA8IiBUi5ToYxr6rWaOpLgpBb6PcpeO33m8zPCcm95+AE8roU41McpTOH96WHqKTMZiNxTc5zUh38YggjLMapICzJbpRf/gWy0V5eTL0Tm7VOSS12OF9YJWl6Vv5zwT0zNVZ+5x2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=amJTA/YM; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712183018; x=1743719018;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pWM1onNqeCEXMo93hDuWfRBO3wRf9NoZkKnKyqnZpJI=;
  b=amJTA/YMwMvn6Pef0i7Z/oDCri1zeCkCwo8HiIFMfzh/bFTtNJCGhM1H
   H1jqWCCT3t6dMfBAtNieaD7i/qeZHiCzet/MyiMc9atUrZTJPb0ZcB5vg
   XB/nGqW5ADTqCgfoNMRceU/j/r2Zh/zT1YvqiUN9fwDhm/qhyFVrG3Y7e
   nMQ6hw9nw6CsiQJf7pF2wJKpg8KaG2G/jq3PrgHLz+lH+GHgKuvvqC3Vu
   xL9zr4Z58zC63btXdxi2zLFyfMQs7yIZ2Fu+MWSVcybwkCAWfsha17WJR
   BixPo9hSyuQgTcY65D8T6q756hAvmeqe8JTQoL0m89qPX9TuPtrBj2+HO
   A==;
X-CSE-ConnectionGUID: EF44x61mS7WSn4Ot1aE8wA==
X-CSE-MsgGUID: RAzcJspKTu68usPcNEtsUQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="18802795"
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="18802795"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 15:23:37 -0700
X-CSE-ConnectionGUID: CmrwcCziRYKu2sNvVetC8A==
X-CSE-MsgGUID: HEvgjVJZRJO2MutzNC5igw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="18517399"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 15:23:37 -0700
Date: Wed, 3 Apr 2024 15:23:36 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 103/130] KVM: TDX: Handle EXIT_REASON_OTHER_SMI with
 MSMI
Message-ID: <20240403222336.GM2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <4a96a33c01b547f6e89ecf40224c80afa59c6aa4.1708933498.git.isaku.yamahata@intel.com>
 <Zgp62iK3HQEvcDyQ@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zgp62iK3HQEvcDyQ@chao-email>

On Mon, Apr 01, 2024 at 05:14:02PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Mon, Feb 26, 2024 at 12:26:45AM -0800, isaku.yamahata@intel.com wrote:
> >From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> >When BIOS eMCA MCE-SMI morphing is enabled, the #MC is morphed to MSMI
> >(Machine Check System Management Interrupt).  Then the SMI causes TD exit
> >with the read reason of EXIT_REASON_OTHER_SMI with MSMI bit set in the exit
> >qualification to KVM instead of EXIT_REASON_EXCEPTION_NMI with MC
> >exception.
> >
> >Handle EXIT_REASON_OTHER_SMI with MSMI bit set in the exit qualification as
> >MCE(Machine Check Exception) happened during TD guest running.
> >
> >Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> >---
> > arch/x86/kvm/vmx/tdx.c      | 40 ++++++++++++++++++++++++++++++++++---
> > arch/x86/kvm/vmx/tdx_arch.h |  2 ++
> > 2 files changed, 39 insertions(+), 3 deletions(-)
> >
> >diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> >index bdd74682b474..117c2315f087 100644
> >--- a/arch/x86/kvm/vmx/tdx.c
> >+++ b/arch/x86/kvm/vmx/tdx.c
> >@@ -916,6 +916,30 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> > 						     tdexit_intr_info(vcpu));
> > 	else if (exit_reason == EXIT_REASON_EXCEPTION_NMI)
> > 		vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
> >+	else if (unlikely(tdx->exit_reason.non_recoverable ||
> >+		 tdx->exit_reason.error)) {
> 
> why not just:
> 	else if (tdx->exit_reason.basic == EXIT_REASON_OTHER_SMI) {
> 
> 
> i.e., does EXIT_REASON_OTHER_SMI imply exit_reason.non_recoverable or
> exit_reason.error?

Yes, this should be refined.


> >+		/*
> >+		 * The only reason it gets EXIT_REASON_OTHER_SMI is there is an
> >+		 * #MSMI(Machine Check System Management Interrupt) with
> >+		 * exit_qualification bit 0 set in TD guest.
> >+		 * The #MSMI is delivered right after SEAMCALL returns,
> >+		 * and an #MC is delivered to host kernel after SMI handler
> >+		 * returns.
> >+		 *
> >+		 * The #MC right after SEAMCALL is fixed up and skipped in #MC
> 
> Looks fixing up and skipping #MC on the first instruction after TD-exit is
> missing in v19?

Right. We removed it as MSMI will provides if #MC happened in SEAM or not.


> 
> >+		 * handler because it's an #MC happens in TD guest we cannot
> >+		 * handle it with host's context.
> >+		 *
> >+		 * Call KVM's machine check handler explicitly here.
> >+		 */
> >+		if (tdx->exit_reason.basic == EXIT_REASON_OTHER_SMI) {
> >+			unsigned long exit_qual;
> >+
> >+			exit_qual = tdexit_exit_qual(vcpu);
> >+			if (exit_qual & TD_EXIT_OTHER_SMI_IS_MSMI)
> 
> >+				kvm_machine_check();
> >+		}
> >+	}
> > }
> > 
> > static int tdx_handle_exception(struct kvm_vcpu *vcpu)
> >@@ -1381,6 +1405,11 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> > 			      exit_reason.full, exit_reason.basic,
> > 			      to_kvm_tdx(vcpu->kvm)->hkid,
> > 			      set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid));
> >+
> >+		/*
> >+		 * tdx_handle_exit_irqoff() handled EXIT_REASON_OTHER_SMI.  It
> >+		 * must be handled before enabling preemption because it's #MC.
> >+		 */
> 
> Then EXIT_REASON_OTHER_SMI is handled, why still go to unhandled_exit?

Let me update the comment.
exit_irqoff() doesn't return value to tell vcpu_run loop to continue or exit to
user-space.  As the guest is dead, we'd like to exit to the user-space.


> > 		goto unhandled_exit;
> > 	}
> > 
> >@@ -1419,9 +1448,14 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> > 		return tdx_handle_ept_misconfig(vcpu);
> > 	case EXIT_REASON_OTHER_SMI:
> > 		/*
> >-		 * If reach here, it's not a Machine Check System Management
> >-		 * Interrupt(MSMI).  #SMI is delivered and handled right after
> >-		 * SEAMRET, nothing needs to be done in KVM.
> >+		 * Unlike VMX, all the SMI in SEAM non-root mode (i.e. when
> >+		 * TD guest vcpu is running) will cause TD exit to TDX module,
> >+		 * then SEAMRET to KVM. Once it exits to KVM, SMI is delivered
> >+		 * and handled right away.
> >+		 *
> >+		 * - If it's an Machine Check System Management Interrupt
> >+		 *   (MSMI), it's handled above due to non_recoverable bit set.
> >+		 * - If it's not an MSMI, don't need to do anything here.
> 
> This corrects a comment added in patch 100. Maybe we can just merge patch 100 into 
> this one?

Yes.  Will do.

> > 		 */
> > 		return 1;
> > 	default:
> >diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> >index efc3c61c14ab..87ef22e9cd49 100644
> >--- a/arch/x86/kvm/vmx/tdx_arch.h
> >+++ b/arch/x86/kvm/vmx/tdx_arch.h
> >@@ -42,6 +42,8 @@
> > #define TDH_VP_WR			43
> > #define TDH_SYS_LP_SHUTDOWN		44
> > 
> >+#define TD_EXIT_OTHER_SMI_IS_MSMI	BIT(1)
> >+
> > /* TDX control structure (TDR/TDCS/TDVPS) field access codes */
> > #define TDX_NON_ARCH			BIT_ULL(63)
> > #define TDX_CLASS_SHIFT			56
> >-- 
> >2.25.1
> >
> >
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

