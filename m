Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020FB7D4386
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 02:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjJXAAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 20:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjJXAAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 20:00:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D15DC;
        Mon, 23 Oct 2023 17:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698105648; x=1729641648;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rqLtEYc52ldeaBeaKpK8SUaczck2gWzp5TJSpCAbldg=;
  b=kz5G4wSf3QPFnNc5ueoELYFzluRGfv50VNOHk91Ek3+tlWggl713Znmn
   GBTjIu0tma4BtF1r8/qcspy3QiMRbQ02i0Z8XQboUHtXSjowAhkPtm6Zm
   qkYc8vUOerVD4yoaqd21BcPppS6pNcgadkB01ug/s3jVweBJDf9uL3HcE
   IEAXcwYSJI1fHr36Cd/OXCnVTMglWfyb0ro26IUoShgd6ahA8qioRpiLc
   L0FHJ7dWnIt3ZCg4PLxce1yxIz6SfFjh3M2Li7EZ6Xmfho256e4S33fcL
   RT2/uz4RUeXkfkTSAvLVzlcEgMjAnfAKBgg5kg0r3v9j5qg276Zr4BdY6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="389799298"
X-IronPort-AV: E=Sophos;i="6.03,246,1694761200"; 
   d="scan'208";a="389799298"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2023 17:00:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="824115767"
X-IronPort-AV: E=Sophos;i="6.03,246,1694761200"; 
   d="scan'208";a="824115767"
Received: from qwilliam-mobl.amr.corp.intel.com (HELO desk) ([10.212.150.186])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2023 17:00:46 -0700
Date:   Mon, 23 Oct 2023 17:00:38 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [PATCH 2/6] x86/entry_64: Add VERW just before userspace
 transition
Message-ID: <20231024000038.7zmaydklgf5ahbxq@desk>
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
 <20231020-delay-verw-v1-2-cff54096326d@linux.intel.com>
 <20231023183521.zdlrfxvsdxftpxly@treble>
 <20231023210410.6oj7ekelf5puoud6@desk>
 <20231023214752.2d75h2m64yw6qzcw@treble>
 <20231023223059.4p7l474o5w3sdjuc@desk>
 <18da71ef-8586-400f-ae71-6d471f2fedcb@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18da71ef-8586-400f-ae71-6d471f2fedcb@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 03:45:41PM -0700, Dave Hansen wrote:
> On 10/23/23 15:30, Pawan Gupta wrote:
> >>>>>  	/*
> >>>>>  	 * iretq reads the "iret" frame and exits the NMI stack in a
> >>>>>  	 * single instruction.  We are returning to kernel mode, so this
> >>>> This isn't needed here.  This is the NMI return-to-kernel path.
> >>> Yes, the VERW here can be omitted. But probably need to check if an NMI
> >>> occuring between VERW and ring transition will still execute VERW after
> >>> the NMI.
> >> That window does exist, though I'm not sure it's worth worrying about.
> > I am in favor of omitting the VERW here, unless someone objects with a
> > rationale. IMO, precisely timing the NMIs in such a narrow window is
> > impractical.
> 
> I'd bet that given the right PMU event you could make this pretty
> reliable.  But normal users can't do that by default.  That leaves the
> NMI watchdog which (I bet) you can still time, but which is pretty low
> frequency.
> 
> Are there any other NMI sources that a normal user can cause problems with?

Generating recoverable parity check errors using rowhammer? But, thats
probably going too far for very little gain.

> Let's at least leave a marker in here that folks can grep for:
> 
> 	/* Skip CLEAR_CPU_BUFFERS since it will rarely help */

Sure.

> and some nice logic in the changelog that they can dig out if need be.
> 
> But, basically it sounds like the logic is:
> 
> 1. It's rare to get an NMI after VERW but before returning to userspace
> 2. There is no known way to make that NMI less rare or target it
> 3. It would take a large number of these precisely-timed NMIs to mount
>    an actual attack.  There's presumably not enough bandwidth.

Thanks for this.

> Anything else?

4. The NMI in question occurs after a VERW, i.e. when user state is
   restored and most interesting data is already scrubbed. Whats left is
   only the data that NMI touches, and that may or may not be
   interesting.
