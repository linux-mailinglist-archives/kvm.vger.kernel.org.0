Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E267D417B
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 23:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjJWVJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 17:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjJWVJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 17:09:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F23BE;
        Mon, 23 Oct 2023 14:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698095370; x=1729631370;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L2w/kXBofndyWdYUQVmhwsOzDUT2zGReL0yLPLKLC3Q=;
  b=XwBadt4IDgi9lg068pF+yi3Xh+56Cr8QhMpVGg3CfOld1a4yj1WLRNid
   50gvWOamYfBWHRI80/eLpdOXP/E265MP31Jtf6ZJbYidhBD6gXBE9jZcW
   Z6KFbhZ4lFxXZGtoD4xErAMN+vZDLIrtAku4iih3NuPaLpRqtlgJaKD3E
   zLVmJvp8NaG+ucHXfAOJEPirG3MyOoLOQk22fuPuzryEbsFsesV09wdq9
   flI+vdAN0MgMWN+HJ96Tnyzl2kUI1xfXsmBVNOAgpcW75pc7w9+RAQ+5K
   sa6pAh4xf+8Zq0yawmEGqc/5sf+aPRHg71eZrZ5KhUcjXGbjahIMepVg9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="366272076"
X-IronPort-AV: E=Sophos;i="6.03,246,1694761200"; 
   d="scan'208";a="366272076"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2023 14:09:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="758249892"
X-IronPort-AV: E=Sophos;i="6.03,246,1694761200"; 
   d="scan'208";a="758249892"
Received: from qwilliam-mobl.amr.corp.intel.com (HELO desk) ([10.212.150.186])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2023 14:09:28 -0700
Date:   Mon, 23 Oct 2023 14:09:20 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH  4/6] x86/bugs: Use ALTERNATIVE() instead of
 mds_user_clear static key
Message-ID: <20231023210920.p53cxpxptocpgcw4@desk>
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
 <20231020-delay-verw-v1-4-cff54096326d@linux.intel.com>
 <20231023184844.e2loaxlldm4zbko2@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023184844.e2loaxlldm4zbko2@treble>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 11:48:44AM -0700, Josh Poimboeuf wrote:
> On Fri, Oct 20, 2023 at 01:45:15PM -0700, Pawan Gupta wrote:
> > @@ -484,11 +484,11 @@ static void __init md_clear_update_mitigation(void)
> >  	if (cpu_mitigations_off())
> >  		return;
> >  
> > -	if (!static_key_enabled(&mds_user_clear))
> > +	if (!boot_cpu_has(X86_FEATURE_USER_CLEAR_CPU_BUF))
> >  		goto out;
> >  
> >  	/*
> > -	 * mds_user_clear is now enabled. Update MDS, TAA and MMIO Stale Data
> > +	 * X86_FEATURE_USER_CLEAR_CPU_BUF is now enabled. Update MDS, TAA and MMIO Stale Data
> >  	 * mitigation, if necessary.
> >  	 */
> 
> This comment line got long, the paragraph can be reformatted.

Yes, will fix.
