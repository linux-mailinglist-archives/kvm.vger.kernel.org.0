Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143BB7D42AD
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 00:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbjJWWbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 18:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjJWWbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 18:31:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F67310C;
        Mon, 23 Oct 2023 15:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698100269; x=1729636269;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i7z7IMzbJi6+aG7Pz3NCOD4hUct3S3EcCr3SQu21dYE=;
  b=AF+FuwpJVSPSXqohe1axlDgYFwqHELDGL78crSqFq72NWP5gQGpmo01R
   /fYMPX2lQ3wUt4hvFeLL7VQ45GCoLa3W1fwKGRGlGjL/XWLGgJZnBGcqm
   FP40XrS7ibMHfjpeLtSb7UWCzLhDFgrAvUQ8XufPHJdKskSOy/rGl5hh+
   6pBGx4ZuMhLxj7mL/7tIXGXL00sNczgBAn3Sq/laj3T/SKN1ihJQo/Wp+
   j9QHrTysqgwOQSAKNTflryBFdsTW4dTso2qqrfNZ8Aq4WbZxFeYNa6ErA
   tW3ImGgfInSB7/eRS+JlPDeq4doYN8bQErOigsvtTyabSWPF0ob2mPZQs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="367170592"
X-IronPort-AV: E=Sophos;i="6.03,246,1694761200"; 
   d="scan'208";a="367170592"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2023 15:31:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="734817778"
X-IronPort-AV: E=Sophos;i="6.03,246,1694761200"; 
   d="scan'208";a="734817778"
Received: from qwilliam-mobl.amr.corp.intel.com (HELO desk) ([10.212.150.186])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2023 15:31:08 -0700
Date:   Mon, 23 Oct 2023 15:30:59 -0700
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
        antonio.gomez.iglesias@linux.intel.com,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH  2/6] x86/entry_64: Add VERW just before userspace
 transition
Message-ID: <20231023223059.4p7l474o5w3sdjuc@desk>
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
 <20231020-delay-verw-v1-2-cff54096326d@linux.intel.com>
 <20231023183521.zdlrfxvsdxftpxly@treble>
 <20231023210410.6oj7ekelf5puoud6@desk>
 <20231023214752.2d75h2m64yw6qzcw@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023214752.2d75h2m64yw6qzcw@treble>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 02:47:52PM -0700, Josh Poimboeuf wrote:
> > > >  	/*
> > > >  	 * RSP now points to an ordinary IRET frame, except that the page
> > > >  	 * is read-only and RSP[31:16] are preloaded with the userspace
> > > > @@ -1502,6 +1511,9 @@ nmi_restore:
> > > >  	std
> > > >  	movq	$0, 5*8(%rsp)		/* clear "NMI executing" */
> > > >  
> > > > +	/* Mitigate CPU data sampling attacks .e.g. MDS */
> > > > +	USER_CLEAR_CPU_BUFFERS
> > > > +
> > > >  	/*
> > > >  	 * iretq reads the "iret" frame and exits the NMI stack in a
> > > >  	 * single instruction.  We are returning to kernel mode, so this
> > > 
> > > This isn't needed here.  This is the NMI return-to-kernel path.
> > 
> > Yes, the VERW here can be omitted. But probably need to check if an NMI
> > occuring between VERW and ring transition will still execute VERW after
> > the NMI.
> 
> That window does exist, though I'm not sure it's worth worrying about.

I am in favor of omitting the VERW here, unless someone objects with a
rationale. IMO, precisely timing the NMIs in such a narrow window is
impractical.
