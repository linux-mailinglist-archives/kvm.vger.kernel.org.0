Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDEC7D9C84
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 17:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346211AbjJ0PFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 11:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346173AbjJ0PFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 11:05:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5880C4;
        Fri, 27 Oct 2023 08:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698419138; x=1729955138;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ih1/FvjaAtODxSz8/KkvT2j4WuoO2ecH6jCbepamajw=;
  b=eU7BPMbSC+ntD7w1Zxp7sFMYHIDNEHNwMdS0V9ov7OOYZ7cSFDCN3sBN
   XmwBj9F6op5Wpj8vcZbcsmWI/G5hUiA2TGW4RgVAOx92fCY6TAUSTOTx6
   c6Npto4wmSrCQGYoPStporM0fQAIpJD1AFlJM0neXwp93NjPKL36ENXf5
   2TLWswpWLZUys0759BYKb2PEC4hPhYaDD6k0C6yjIarQvKHSLuF667qG6
   kL8qjgmDfiAAywbGpGJQ2onRpzmZ2iWElTouoN4p3R3eG1zyBed5Q6gPz
   gNlcrgZnxX5oV6gR9bIi+oKd1oNGCPyAnfJ8BdYuGw+igjxZFFz9bPOiL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="384994166"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="384994166"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 08:05:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="850985"
Received: from dmnassar-mobl.amr.corp.intel.com (HELO desk) ([10.212.203.39])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 08:05:25 -0700
Date:   Fri, 27 Oct 2023 08:05:35 -0700
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
Message-ID: <20231027150535.s4nlkppsvzeahm7t@desk>
References: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
 <20231027144848.GGZTvN0AtGIQ9kBtkA@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231027144848.GGZTvN0AtGIQ9kBtkA@fat_crate.local>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 27, 2023 at 04:48:48PM +0200, Borislav Petkov wrote:
> On Fri, Oct 27, 2023 at 07:38:34AM -0700, Pawan Gupta wrote:
> > v4:
> 
> Why are you spamming people with your patchset? You've sent it 4 times
> in a week:
> 
> Oct 20               Pawan Gupta ( :  75|) [PATCH 0/6] Delay VERW
> Oct 24               Pawan Gupta ( :7.3K|) [PATCH v2 0/6] Delay VERW
> Oct 25               Pawan Gupta ( :7.5K|) [PATCH v3 0/6] Delay VERW
> Oct 27               Pawan Gupta ( :8.8K|) [PATCH v4 0/6] Delay VERW
> 
> Is this something urgent or can you take your time like everyone else?

I am going on a long vacation next week, I won't be working for the rest
of the year. So I wanted to get this in a good shape quickly. This
patchset addresses some security issues (although theoretical). So there
is some sense of urgency. Sorry for spamming, I'll take you off the To:
list.
