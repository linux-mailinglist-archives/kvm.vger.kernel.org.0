Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B04B7424DE
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 13:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjF2LQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 07:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjF2LQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 07:16:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4AC10CF;
        Thu, 29 Jun 2023 04:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688037371; x=1719573371;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AmSC6QSDI6fA0PB2pX5j89MVglE58ZfjBAk4Tqqgf7c=;
  b=Dza0h1K5yE22gsHfNKgTlNexL4x/DRucFw4/rqfZnyHPwRoCHf63YM9+
   cNe3eMgZOXHODqYRLzCfJk7sKmBfdhsOzNrTjmbN7DV2FB2e4wBCftGsB
   r7rVMbq8HGIgOXiLJD45CixaVWAx/E9BKXDNRyb1aaetUToCSLmHydWUs
   4RHZLR5N1kSNUaddtSSGDPCd7+ts965NaqN0fRG8FxW/4eouQo2MA6xfN
   YVNYvaOlPV+297+x+WTS2HzjJFtS6Nykvse/cELrqYiIebo1UtYMpjzby
   f/sJKB6k3tm0zgumESPNYlerWMRi9qCmh5OhTYiYtWoBNvkkusD8hzvg1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="365545203"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="365545203"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 04:16:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="787334581"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="787334581"
Received: from aperepel-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.47.231])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 04:16:03 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 9AC471095DD; Thu, 29 Jun 2023 14:16:00 +0300 (+03)
Date:   Thu, 29 Jun 2023 14:16:00 +0300
From:   kirill.shutemov@linux.intel.com
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        dave.hansen@intel.com, tony.luck@intel.com, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Message-ID: <20230629111600.hq4carptan6pfu37@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
 <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
 <20230628203823.GR38236@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628203823.GR38236@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 10:38:23PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 28, 2023 at 05:29:01PM +0200, Peter Zijlstra wrote:
> > On Tue, Jun 27, 2023 at 02:12:50AM +1200, Kai Huang wrote:
> > > diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
> > > index 49a54356ae99..757b0c34be10 100644
> > > --- a/arch/x86/virt/vmx/tdx/tdxcall.S
> > > +++ b/arch/x86/virt/vmx/tdx/tdxcall.S
> > > @@ -1,6 +1,7 @@
> > >  /* SPDX-License-Identifier: GPL-2.0 */
> > >  #include <asm/asm-offsets.h>
> > >  #include <asm/tdx.h>
> > > +#include <asm/asm.h>
> > >  
> > >  /*
> > >   * TDCALL and SEAMCALL are supported in Binutils >= 2.36.
> > > @@ -45,6 +46,7 @@
> > >  	/* Leave input param 2 in RDX */
> > >  
> > >  	.if \host
> > > +1:
> > >  	seamcall
> > 
> > So what registers are actually clobbered by SEAMCALL ? There's a
> > distinct lack of it in SDM Vol.2 instruction list :-(
> 
> With the exception of the abomination that is TDH.VP.ENTER all SEAMCALLs
> seem to be limited to the set presented here (c,d,8,9,10,11) and all
> other registers should be available.
> 
> Can we please make that a hard requirement, SEAMCALL must not use
> registers outside this? We can hardly program to random future
> extentions; we need hard ABI guarantees here.
> 
> That also means we should be able to use si,di for the cmovc below.
> 
> Kirill, back when we did __tdx_hypercall() we got bp removed as a valid
> register, the 1.0 spec still lists that, and it is also listed in
> TDH.VP.ENTER, I'm assuming it will be removed there too?
> 
> bp must not be used -- it violates the pre-existing calling convention.

I've just brought it up again internally. Let's see what will happen.
 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
