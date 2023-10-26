Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19BE7D89D1
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 22:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjJZUsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 16:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjJZUsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 16:48:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD971A5;
        Thu, 26 Oct 2023 13:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698353293; x=1729889293;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=J1BrGAfKkjJZBIaI54OTtvmbMBd/XWt9LY8Jmd/+zok=;
  b=hFiVAM4hyCCWw/AVF40hZ8MstA2xL6tKn95v+fBYzKfc7ZIXeWvDqVkf
   iWbG885Y81XZeW5wppXzaG2zOF6gaWDHAwrP46CaN4OE7Yp3AahIJ3Z2/
   VfCSeqIC5qHiL3aGrT5T54XL/IKgkjtKi5RyKEsUF5J9oj26c1xu/FTRs
   nk88+5gBsS+khIPeVgjOSHSkcCCYH6giWpyGljtHwZ1QpeZV0E3fU2A3G
   mqIOAP/QFNw5cTBK37BXPj6PaQIeuExEmmjuuRTprFl2VuVNUGqX+vonD
   mdmUYkfcQxBumh7qa+EUOTTmBYil+hAqrSqSfF4DQU8jem7hknOMTnoXA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="378007616"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="378007616"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 13:48:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="762977705"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="762977705"
Received: from paseron-mobl4.amr.corp.intel.com (HELO desk) ([10.209.17.113])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 13:48:12 -0700
Date:   Thu, 26 Oct 2023 13:48:10 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH  v3 6/6] KVM: VMX: Move VERW closer to VMentry for MDS
 mitigation
Message-ID: <20231026204810.chvljddk6noxsuqi@desk>
References: <20231025-delay-verw-v3-0-52663677ee35@linux.intel.com>
 <20231025-delay-verw-v3-6-52663677ee35@linux.intel.com>
 <ZTq-b0uVyf6KLNV0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTq-b0uVyf6KLNV0@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 26, 2023 at 12:30:55PM -0700, Sean Christopherson wrote:
> > -	/* L1D Flush includes CPU buffer clear to mitigate MDS */
> > +	/*
> > +	 * L1D Flush includes CPU buffer clear to mitigate MDS, but VERW
> > +	 * mitigation for MDS is done late in VMentry and is still
> > +	 * executed inspite of L1D Flush. This is because an extra VERW
> 
> in spite

Ok.

> > +	 * should not matter much after the big hammer L1D Flush.
> > +	 */
> >  	if (static_branch_unlikely(&vmx_l1d_should_flush))
> >  		vmx_l1d_flush(vcpu);
> 
> There's an existing bug here.  vmx_1ld_flush() is not guaranteed to do a flush in
> "conditional mode", and is not guaranteed to do a ucode-based flush

AFAICT, it is based on the condition whether after a VMexit any
sensitive data could have been touched or not. If L1TF mitigation
doesn't consider certain data sensitive and skips L1D flush, executing
VERW isn't giving any protection, since that data can anyways be leaked
from L1D using L1TF.

> (though I can't tell if it's possible for the VERW magic to exist
> without X86_FEATURE_FLUSH_L1D).

Likely not, ucode that adds VERW should have X86_FEATURE_FLUSH_L1D as
L1TF was mitigation prior to MDS.

> If we care, something like the diff at the bottom is probably needed.
> 
> > -	else if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF))
> > -		mds_clear_cpu_buffers();
> >  	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
> >  		 kvm_arch_has_assigned_device(vcpu->kvm))
> > +		/* MMIO mitigation is mutually exclusive with MDS mitigation later in asm */
> 
> Please don't put comments inside an if/elif without curly braces (and I don't
> want to add curly braces).  Though I think that's a moot point if we first fix
> the conditional L1D flush issue.  E.g. when the dust settles we can end up with:

Ok.

> 	/*
> 	 * Note, a ucode-based L1D flush also flushes CPU buffers, i.e. the
> 	 * manual VERW in __vmx_vcpu_run() to mitigate MDS *may* be redundant.
> 	 * But an L1D Flush is not guaranteed for "conditional mode", and the
> 	 * cost of an extra VERW after a full L1D flush is negligible.
> 	 */
> 	if (static_branch_unlikely(&vmx_l1d_should_flush))
> 		cpu_buffers_flushed = vmx_l1d_flush(vcpu);
> 
> 	/*
> 	 * The MMIO stale data vulnerability is a subset of the general MDS
> 	 * vulnerability, i.e. this is mutually exclusive with the VERW that's
> 	 * done just before VM-Enter.  The vulnerability requires the attacker,
> 	 * i.e. the guest, to do MMIO, so this "clear" can be done earlier.
> 	 */
> 	if (static_branch_unlikely(&mmio_stale_data_clear) &&
> 	    !cpu_buffers_flushed && kvm_arch_has_assigned_device(vcpu->kvm))
> 		mds_clear_cpu_buffers();

This is certainly better, but I don't know what scenario is this helping with.

> >  		mds_clear_cpu_buffers();
> >  
> >  	vmx_disable_fb_clear(vmx);
> 
> LOL, nice.  IIUC, setting FB_CLEAR_DIS is mutually exclusive with doing a late
> VERW, as KVM will never set FB_CLEAR_DIS if the CPU is susceptible to X86_BUG_MDS.
> But the checks aren't identical, which makes this _look_ sketchy.
> 
> Can you do something like this to ensure we don't accidentally neuter the late VERW?
> 
> static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
> {
> 	vmx->disable_fb_clear = (host_arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
> 				!boot_cpu_has_bug(X86_BUG_MDS) &&
> 				!boot_cpu_has_bug(X86_BUG_TAA);
> 
> 	if (vmx->disable_fb_clear &&
> 	    WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF)))
> 	    	vmx->disable_fb_clear = false;

Will do, this makes a lot of sense.
