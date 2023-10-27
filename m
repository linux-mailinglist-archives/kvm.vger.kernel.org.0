Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5F87D9D06
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 17:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346305AbjJ0Pcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 11:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346291AbjJ0Pcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 11:32:52 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CACAC;
        Fri, 27 Oct 2023 08:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698420769; x=1729956769;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DjuX/wAHbc+xCWejQxL14B3DRyOZ9EdymSlvm/og6O4=;
  b=LoKjxhWauxx39vnxRa7y0tWQ9oAkY+lfxxfbK1/YvbUDDx+uUkQLyRkB
   PVTxUeMD6t3bq9yPodmd4cEfllnrtLCGc1Q7MdpulsaJgrrU2fulW6mAp
   rWY/PH/6FXp8JqhYsHhHUjkDtnTx1Ce7AW3WN74+9jNRPcJeBdKH4uEJP
   cE6XgI07G2N7aQMPlL2PBQ14bEvWqS3Kpf1CKZ8KXjJqJkesE4kqgxfQI
   6Wws0uWLN+YKirieli7LwLOQW7lwZVAQQWC95umudHQO2MDvSjjrrN+P3
   C97TXaF/r0h9HbnJ1b7GHrF9lco6veuHgps4OzQsgq4U7ongrsFdBG5gL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="474035579"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="474035579"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 08:32:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="753150122"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="753150122"
Received: from dmnassar-mobl.amr.corp.intel.com (HELO desk) ([10.212.203.39])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 08:32:44 -0700
Date:   Fri, 27 Oct 2023 08:32:42 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Nikolay Borisov <nik.borisov@suse.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alyssa Milburn <alyssa.milburn@intel.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v4 0/6] Delay VERW
Message-ID: <20231027153242.ruabpxxywhq5upc7@desk>
References: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
 <20231027144848.GGZTvN0AtGIQ9kBtkA@fat_crate.local>
 <20231027150535.s4nlkppsvzeahm7t@desk>
 <20231027151226.GIZTvTWuQUXdsmt6v3@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231027151226.GIZTvTWuQUXdsmt6v3@fat_crate.local>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 27, 2023 at 05:12:26PM +0200, Borislav Petkov wrote:
> On Fri, Oct 27, 2023 at 08:05:35AM -0700, Pawan Gupta wrote:
> > I am going on a long vacation next week, I won't be working for the rest
> > of the year. So I wanted to get this in a good shape quickly. This
> > patchset addresses some security issues (although theoretical). So there
> > is some sense of urgency. Sorry for spamming, I'll take you off the To:
> > list.
> 
> Even if you're leaving for vacation, I'm sure some colleague of yours or
> dhansen will take over this for you. So there's no need to keep sending
> this every day. Imagine everyone who leaves for vacation would start
> doing that...

I can imagine the amount emails maintainers get. I'll take care of this
in future. But, its good to get some idea on how much is too much,
specially for a security issue?
