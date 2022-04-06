Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1DA4F5FF1
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 15:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbiDFNHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 09:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbiDFNGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 09:06:20 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1A043F1E0;
        Tue,  5 Apr 2022 18:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649210144; x=1680746144;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UKNgpjiRni3tL6WxubyxbhjwOmfI6ZOVCE+2k1BSHyg=;
  b=DbmfcPplIz3fNRGb8eHMynR0kmHqi53PqgcwETm+Xm0kS2yhpyIJbDxN
   kmT4bFJ0ubBzgyj3g4rolgkaTy6VopHZGwPwmaPjU+xNGUOi594reRQ8y
   UqC234NtdYb0bobpILpcIAvx6lx3nHH3M4upOu/3E5h9dtBhk7WuPnq8x
   41M0W8cC9jKxfpRbheCFWSec/9RBx2nh7tJSrhP2EB7dcw7t7wRoZju1Z
   D8Osg4U3nHZhIYiwjwpj4J10zqekuZiEycN9D/f3KHXVek7MIj06W3bus
   gVWoaznbeVieIlWecJSwvc/EiJ5WWWLM+kI8FXh8tO0zo3xm+C5DTn0lZ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243063871"
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="243063871"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 18:55:38 -0700
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="652151630"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 18:55:30 -0700
Message-ID: <cec13fb656f05d8c9d231c225587072076448d71.camel@intel.com>
Subject: Re: [RFC PATCH v5 023/104] x86/cpu: Add helper functions to
 allocate/free MKTME keyid
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Wed, 06 Apr 2022 13:55:28 +1200
In-Reply-To: <20220331201550.GC2084469@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <a1d1e4f26c6ef44a557e873be2818e6a03e12038.1646422845.git.isaku.yamahata@intel.com>
         <2386151bc0a42b2eda895d85b459bf7930306694.camel@intel.com>
         <20220331201550.GC2084469@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-31 at 13:15 -0700, Isaku Yamahata wrote:
> On Thu, Mar 31, 2022 at 02:21:06PM +1300,
> Kai Huang <kai.huang@intel.com> wrote:
> 
> > On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > MKTME keyid is assigned to guest TD.  The memory controller encrypts guest
> > > TD memory with key id.  Add helper functions to allocate/free MKTME keyid
> > > so that TDX KVM assign keyid.
> > 
> > Using MKTME keyid is wrong, at least not accurate I think.  We should use
> > explicitly use "TDX private KeyID", which is clearly documented in the spec:
> >   
> > https://software.intel.com/content/dam/develop/external/us/en/documents-tps/intel-tdx-cpu-architectural-specification.pdf
> > 
> > Also, description of IA32_MKTME_KEYID_PARTITIONING MSR clearly says TDX private
> > KeyIDs span the range (NUM_MKTME_KIDS+1) through
> > (NUM_MKTME_KIDS+NUM_TDX_PRIV_KIDS).  So please just use TDX private KeyID here.
> > 
> > 
> > > 
> > > Also export MKTME global keyid that is used to encrypt TDX module and its
> > > memory.
> > 
> > This needs explanation why the global keyID needs to be exported.
> 
> How about the followings?
> 
> TDX private host key id is assigned to guest TD.  The memory controller
> encrypts guest TD memory with the assigned host key id (HIKD).  Add helper
> functions to allocate/free TDX private host key id so that TDX KVM manage
> it.

HIKD -> HKID.  

You may also want to use KeyID in consistent way (KeyID, keyid, key id, etc).
The spec uses KeyID.

> 
> Also export the global TDX private host key id that is used to encrypt TDX
> module, its memory and some dynamic data (e.g. TDR).  When VMM releasing
> encrypted page to reuse it, the page needs to be flushed with the used host
> key id.  VMM needs the global TDX private host key id to flush such pages
> TDX module accesses with the global TDX private host key id.
> 
> 

Find to me.

