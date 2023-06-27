Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B7B73FB3B
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 13:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjF0Lif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 07:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbjF0Lib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 07:38:31 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE242977;
        Tue, 27 Jun 2023 04:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687865902; x=1719401902;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pblGJiVM9kZOdgL3JsS2LvFnPRI4Ksm9ReZEZ35fwAc=;
  b=KuYIBTvSnOuO/27SQ/qRm/I3mjUaw2sEz5PFKbPE+/UfCO8bFkIVri80
   TBVM/yoV+Em/kJPnOWse7mNY4gbGU0x5BV264aw81Jo1yhru47ngFtYzp
   Sb7JyUl/hEyLjY3hiYEG/4WBLzyI7sOZPjqEiGQEHhGVvUkaHBR/elSAk
   xTaZVWRj9sXdJG6Eaxra8UJXwfI2zml04NjHddsZwgBltUPwsFCEs6cbQ
   4hyP9cZtgybdJREryq1sBMSrbOlUUMoEuT01JmIg33H7piLRJq1mEZPej
   GfZDQFREELexGJ7NQn6wVKdX97lGPpr7RBUIPNiA1/RV1HrC7JI/YoOYv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="425216430"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="425216430"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 04:38:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="710620519"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="710620519"
Received: from rbhaumik-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.251.217.121])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 04:37:55 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 05756103738; Tue, 27 Jun 2023 14:37:53 +0300 (+03)
Date:   Tue, 27 Jun 2023 14:37:52 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 08/22] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Message-ID: <20230627113752.djyxgt4io6aiixwy@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <a33f372df345f6232b55e26d498ea67d4adc18f0.1687784645.git.kai.huang@intel.com>
 <20230627095124.nhiypr6ivi4kdfrw@box.shutemov.name>
 <49f197f7756ac05b99717a9f63d56cfb860ab88b.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49f197f7756ac05b99717a9f63d56cfb860ab88b.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 10:45:33AM +0000, Huang, Kai wrote:
> On Tue, 2023-06-27 at 12:51 +0300, kirill.shutemov@linux.intel.com wrote:
> > On Tue, Jun 27, 2023 at 02:12:38AM +1200, Kai Huang wrote:
> > >  static int init_tdx_module(void)
> > >  {
> > > +	struct tdsysinfo_struct *sysinfo;
> > > +	struct cmr_info *cmr_array;
> > > +	int ret;
> > > +
> > > +	/*
> > > +	 * Get the TDSYSINFO_STRUCT and CMRs from the TDX module.
> > > +	 *
> > > +	 * The buffers of the TDSYSINFO_STRUCT and the CMR array passed
> > > +	 * to the TDX module must be 1024-bytes and 512-bytes aligned
> > > +	 * respectively.  Allocate one page to accommodate them both and
> > > +	 * also meet those alignment requirements.
> > > +	 */
> > > +	sysinfo = (struct tdsysinfo_struct *)__get_free_page(GFP_KERNEL);
> > > +	if (!sysinfo)
> > > +		return -ENOMEM;
> > > +	cmr_array = (struct cmr_info *)((unsigned long)sysinfo + PAGE_SIZE / 2);
> > > +
> > > +	BUILD_BUG_ON(PAGE_SIZE / 2 < TDSYSINFO_STRUCT_SIZE);
> > > +	BUILD_BUG_ON(PAGE_SIZE / 2 < sizeof(struct cmr_info) * MAX_CMRS);
> > 
> > This works, but why not just use slab for this? kmalloc has 512 and 1024
> > pools already and you won't waste memory for rounding up.
> > 
> > Something like this:
> > 
> >         sysinfo = kmalloc(TDSYSINFO_STRUCT_SIZE, GFP_KERNEL);
> >         if (!sysinfo)
> >                 return -ENOMEM;
> > 
> >         cmr_array_size = sizeof(struct cmr_info) * MAX_CMRS;
> > 
> >         /* CMR array has to be 512-aligned */
> >         cmr_array_size = round_up(cmr_array_size, 512);
> 
> Should we define a macro for 512
> 
> 	+#define CMR_INFO_ARRAY_ALIGNMENT	512
> 
> And get rid of this comment?  AFAICT Dave didn't like such comment mentioning
> 512-bytes aligned if we have a macro for that.

Good idea.

> >         cmr_array = kmalloc(cmr_array_size, GFP_KERNEL);
> >         if (!cmr_array) {
> >                 kfree(sysinfo);
> >                 return -ENOMEM;
> >         }
> > 
> > ?
> > 
> 
> I confess the reason I used __get_free_page() was to avoid having to allocate
> twice, and in case of failure, I need to handle additional memory free.  But I
> can do if you think it's clearer?

Less trickery is always cleaner. Especially if the trick is not justified.

> I wouldn't worry about wasting memory.  The buffer is freed anyway for now. 
> Long-termly it's just 4K.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
