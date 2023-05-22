Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E977670CBA7
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 22:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbjEVUy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 16:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235041AbjEVUy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 16:54:57 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932A2B7;
        Mon, 22 May 2023 13:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684788896; x=1716324896;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KPUkAez+fw329xYvkr1pY41VL2D8bMppwpAl0MZA/fA=;
  b=cbx7dGFGe9ZQ2TQ+Iw9IeeQCpZzRpjBSGGWu2HSIevqWqMz8Y+mU4eTi
   Q3Sweun1x0RRBRgBOIdTdZZz6Q9rZkvbhDg7GXrNf4VqgyqqqgL0L0O01
   046oecIItTqmaz4BXPwPaJ1ZSVXTs+s97qMjqPGpLk4zzS6LgKin0+4O8
   Qxbm6303YSPaxyAXG4QwAtm+NNPr//Ga2PbYLq7WfxEALNthoQhFJVtmM
   LPKiT5fjaiBQw86VUN0p+akVRY046tVpeCsnvAa5MxCv0H198qGiDFf+x
   apVR5kJGfWbVz1Easn0TZDfxCTyD3gXFZMROQ6x/J0Ye145OdKar+7SrJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="350549513"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="350549513"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 13:54:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="773511984"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="773511984"
Received: from arkaneta-mobl.amr.corp.intel.com (HELO desk) ([10.212.144.239])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 13:54:55 -0700
Date:   Mon, 22 May 2023 13:54:53 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: x86: Track supported ARCH_CAPABILITIES in kvm_caps
Message-ID: <20230522205453.kqhvk5aheye22hfa@desk>
References: <20230506030435.80262-1-chao.gao@intel.com>
 <b472b58d-0469-8a55-985c-1d966ce66419@intel.com>
 <ZGZhW/x5OWPmx1qD@google.com>
 <20230520010237.3tepk3q44j52leuk@desk>
 <ZGup1TjeqBF7bgWG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGup1TjeqBF7bgWG@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023 at 10:43:49AM -0700, Sean Christopherson wrote:
> On Fri, May 19, 2023, Pawan Gupta wrote:
> > On Thu, May 18, 2023 at 10:33:15AM -0700, Sean Christopherson wrote:
> > > I made the mistake of digging into why KVM doesn't advertise ARCH_CAP_FB_CLEAR_CTRL...
> > > 
> > >   1. I see *nothing* in commit 027bbb884be0 ("KVM: x86/speculation: Disable Fill
> > >      buffer clear within guests") that justifies 1x RDMSR and 2x WRMSR on every
> > >      entry+exit.
> > 
> > Unnecessary VERWs in guest will have much higher impact than due to MSR
> > read/write at vmentry/exit.
> 
> Can you provide numbers for something closeish to a real world workload?

I am collecting the numbers, will update here soon.

> > On an Icelake system it is pointless for a guest to incur VERW penalty when
> > the system is not affected by MDS/TAA and guests don't need mitigation for
> > MMIO Stale Data. MSR writes are only done when the guest is likely to execute
> > unnecessary VERWs(e.g. when the guest thinks its running on an older gen
> > CPU).
> >
> > >      KVM just needs to context switch the MSR between guests since the value that's
> > >      loaded while running in the host is irrelevant.  E.g. use a percpu cache to
> > 
> > I will be happy to avoid the MSR read/write, but its worth considering
> > that this MSR can receive more bits that host may want to toggle, then
> > percpu cache implementation would likely change.
> 
> Change in and of itself isn't problematic, so long as whatever code we write won't
> fall over if/when new bits are added, i.e. doesn't clobber unknown bits.

Ok.

> > >   5. MSR_IA32_MCU_OPT_CTRL is not modified by the host after a CPU is brought up,
> > >      i.e. the host's desired value is effectively static post-boot, and barring
> > >      a buggy configuration (running KVM as a guest), the boot CPU's value will be
> > >      the same as every other CPU.
> > 
> > Would the MSR value be same on every CPU, if only some guests have
> > enumerated FB_CLEAR and others haven't?
> 
> Ignore the guest, I'm talking purely about the host.  Specifically, there's no
> reason to do a RDMSR to get the host value on every VM-Enter since the host's
> value is effectively static post-boot.

That right(ignoring late microcode load adding stuff to the MSR or
msr-tools fiddling).

> > MSR writes (to disable FB_CLEAR) are not done when a guest enumerates
> > FB_CLEAR. Enumeration of FB_CLEAR in guest will depend on its configuration.
> > 
> > >   6. Performance aside, KVM should not be speculating (ha!) on what the guest
> > >      will and will not do, and should instead honor whatever behavior is presented
> > >      to the guest.  If the guest CPU model indicates that VERW flushes buffers,
> > >      then KVM damn well needs to let VERW flush buffers.
> > 
> > The current implementation allows guests to have VERW flush buffers when
> > they enumerate FB_CLEAR. It only restricts the flush behavior when the
> > guest is trying to mitigate against a vulnerability(like MDS) on a
> > hardware that is not affected. I guess its common for guests to be
> > running with older gen configuration on a newer hardware.
> 
> Right, I'm saying that that behavior is wrong.  KVM shouldn't assume the guest
> the guest will do things a certain way and should instead honor the "architectural"
> definition, in quotes because I realize there probably is no architectural
> definition for any of this.

Before MMIO Stale Data, processors that were not affected by MDS/TAA did
not clear CPU buffers, even if they enumerated MD_CLEAR. On such
processors guests that deployed VERW(thinking they are vulnerable to
MDS) did not clear the CPU buffers. After MMIO Stale Data was discovered
FB_CLEAR_DIS was introduced to restore this behavior.

> It might be that the code does (unintentionally?) honor the "architecture", i.e.
> this code might actually be accurrate with respect to when the guest can expect
> VERW to flush buffers.  But the comment is so, so wrong.

Agree, the comment needs to explain this well.

> 	/*
> 	 * If guest will not execute VERW, there is no need to set FB_CLEAR_DIS
> 	 * at VMEntry. Skip the MSR read/write when a guest has no use case to
> 	 * execute VERW.
> 	 */
> 	if ((vcpu->arch.arch_capabilities & ARCH_CAP_FB_CLEAR) ||
> 	   ((vcpu->arch.arch_capabilities & ARCH_CAP_MDS_NO) &&
> 	    (vcpu->arch.arch_capabilities & ARCH_CAP_TAA_NO) &&
> 	    (vcpu->arch.arch_capabilities & ARCH_CAP_PSDP_NO) &&
> 	    (vcpu->arch.arch_capabilities & ARCH_CAP_FBSDP_NO) &&
> 	    (vcpu->arch.arch_capabilities & ARCH_CAP_SBDR_SSDP_NO)))
> 		vmx->disable_fb_clear = false;
