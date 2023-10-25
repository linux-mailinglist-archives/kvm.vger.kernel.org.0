Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D010E7D7074
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344183AbjJYPK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbjJYPKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:10:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B533137;
        Wed, 25 Oct 2023 08:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698246623; x=1729782623;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h5JI00UNVOxIMLEny8kw2e5sk3c/Y4lPR8sE6MoghvM=;
  b=SVtr6NfL6tFbGVgA65VUig3Lq7hnL/XH8qNRsRU1p/bCgAtm3LGQVQRf
   YwqSnKmPpyDwR6EsZRwNniDkdc4nGFcMNzqA6Q4yqKA7m92w363mrPm8C
   ekKC+9ScUB0wQUWOsqUlmE6sGPyyNBk2tHvkXb+aaL3tW/wI8Jdx5366b
   g2HqowT1jPGO09Siyz2s/Qg9WF/Pe7eDCr5k8R3tCSc/Apdhk1cx1Fcxx
   c9e+DBL/20HbfQmIcRNBCko6ELER21aByHLMsJpE/4UXtGDP3yR60Ug+3
   zPBJVU96HR01K4vZ1AqQCC5Nv5E1xuAsBKt6KNqTTqd8Y2wZ2ccX642Qk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="391197318"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="391197318"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 08:10:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="6570949"
Received: from mhans-mobl3.amr.corp.intel.com (HELO desk) ([10.252.132.200])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 08:09:02 -0700
Date:   Wed, 25 Oct 2023 08:10:01 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
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
        Alyssa Milburn <alyssa.milburn@intel.com>
Subject: Re: [PATCH  v2 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20231025151001.bhia5kxmld5dfgr7@desk>
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
 <20231024-delay-verw-v2-1-f1881340c807@linux.intel.com>
 <20231024103601.GH31411@noisy.programming.kicks-ass.net>
 <20231025040029.uglv4dwmlnfhcjde@desk>
 <20231025065818.GB31201@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025065818.GB31201@noisy.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023 at 08:58:18AM +0200, Peter Zijlstra wrote:
> > +.pushsection .rodata
> > +.align 64
> > +mds_verw_sel:
> > +	.word __KERNEL_DS
> > + 	.byte 0xcc
> > +.align 64
> > +.popsection
> 
> This should not be in a header file, you'll get an instance of this per
> translation unit, not what you want.

Agh, sorry I missed it.
