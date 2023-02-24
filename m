Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984126A2511
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 00:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBXXaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 18:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBXXaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 18:30:20 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE446BF5A;
        Fri, 24 Feb 2023 15:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677281419; x=1708817419;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iYG64KQ8eDbP4/BqEcmXVFBG++OPO7afYUzLr08b6cg=;
  b=mXoBqhTzG9XLc1n8QlcxO7aYqA3aaKqzmCdsWbf/ERZTXQoWxJ5LpxVr
   8Ba3PUw/mwef02Rwkwos19fzkMRqHv1F7SosXnDs3ENZRyW/sHAs13vuH
   mokb9Vguozks2zznJ5tZxIXrGOdV22FYP46BeW9/i5LBliVgLsXmHqa39
   GOTACWm/r1ocBK2gZbDZxRD1AJqneaMMhviHnxkyuoGptXwWfmg3q7OLP
   RbfxStoyufA+r5muS/z8jhJ6IgZR22VsI2iqo3huY7YCcBqsFIQXIs4Y7
   zObEyOm+5ufr5YoBLd8tfQ9xX2wLTv2fnxyWWVXO1KFF/yLd9c0UQ4Fv6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="398334904"
X-IronPort-AV: E=Sophos;i="5.97,326,1669104000"; 
   d="scan'208";a="398334904"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 15:30:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="847106500"
X-IronPort-AV: E=Sophos;i="5.97,326,1669104000"; 
   d="scan'208";a="847106500"
Received: from ydu6-mobl1.gar.corp.intel.com (HELO desk) ([10.209.68.79])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 15:30:18 -0800
Date:   Fri, 24 Feb 2023 15:30:04 -0800
From:   "pawan.kumar.gupta@linux.intel.com" 
        <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Ostrovsky, Boris" <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 7/8] x86/cpu: Support AMD Automatic IBRS
Message-ID: <20230224233004.rf2nzgqvz5c2b73u@desk>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
 <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble>
 <Y/knUC0s+rg6ef2r@zn.tnic>
 <20230224213522.nofavod2jzhn22wp@treble>
 <Y/kzGEqafzQkbU4T@zn.tnic>
 <SJ1PR11MB60834960ECAC976C1D328A86FCA89@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <Y/k2TWHpq1M8QiSa@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/k2TWHpq1M8QiSa@zn.tnic>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 11:12:29PM +0100, Borislav Petkov wrote:
> On Fri, Feb 24, 2023 at 10:03:16PM +0000, Luck, Tony wrote:
> > Should also include Pawan as another unfortunate soul sucked
> > into keeping that file up to date with the latest wreckage. If not
> > as "M", at least as "R":
> > 
> > R: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> 
> We probably should hear from him before you offer his soul into the
> purgatory of hardware speculation.

I will be happy to review what I can.

Soulfully yours,
Pawan
