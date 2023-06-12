Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB5A72B979
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 10:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjFLIA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 04:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbjFLH7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 03:59:18 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97CC30D2;
        Mon, 12 Jun 2023 00:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686556719; x=1718092719;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EEmcYq3XMCh9eZC3lpJIYouGZl8cqpZH7pVSmmfzWgE=;
  b=ZHqSCapR4iAGc/K8VmhM8GHdFE8TGnGo8MKR5QPEZSZBD+NzpsIS75jO
   ClSY7OwzeZwfzsWQIt7eoefgtBKayNCMV2N6tV2Opt+pnLvFJOyj4Y/Qn
   Sxee+wDnFiuzTjzC/g9H2YWtPEB/4SHN9f2b8ldMxglESgtViYKXJgT3p
   E/rUHdqxq5udmg1Or3iveq2BHxovvo34bb2Vhe1xlsMW7dY85C1X3gm4T
   hGWH5Jv3C4LUq3fsx93AVSZ1SyZh5BIhRZ6uWGwbN+9O+Z+r/3+ZIWjT0
   eoN4+9NoQfKOo2ZRGhwKnp2x2FejK0tsw5hEf6QbIKhqCTQYlI7cx5rk0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="421566819"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="421566819"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 00:58:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="823885252"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="823885252"
Received: from smizr3x-mobl3.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.43.127])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 00:58:33 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 653A210CC1C; Mon, 12 Jun 2023 10:58:30 +0300 (+03)
Date:   Mon, 12 Jun 2023 10:58:30 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Message-ID: <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
 <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
 <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023 at 03:06:48AM +0000, Huang, Kai wrote:
> On Fri, 2023-06-09 at 16:23 +0300, kirill.shutemov@linux.intel.com wrote:
> > On Mon, Jun 05, 2023 at 02:27:31AM +1200, Kai Huang wrote:
> > > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > > index 8ff07256a515..0aa413b712e8 100644
> > > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > > @@ -587,6 +587,14 @@ static int tdmr_set_up_pamt(struct tdmr_info *tdmr,
> > >  		tdmr_pamt_base += pamt_size[pgsz];
> > >  	}
> > >  
> > > +	/*
> > > +	 * tdx_memory_shutdown() also reads TDMR's PAMT during
> > > +	 * kexec() or reboot, which could happen at anytime, even
> > > +	 * during this particular code.  Make sure pamt_4k_base
> > > +	 * is firstly set otherwise tdx_memory_shutdown() may
> > > +	 * get an invalid PAMT base when it sees a valid number
> > > +	 * of PAMT pages.
> > > +	 */
> > 
> > Hmm? What prevents compiler from messing this up. It can reorder as it
> > wishes, no?
> 
> Hmm.. Right. Sorry I missed.
> 
> > 
> > Maybe add a proper locking? Anything that prevent preemption would do,
> > right?
> > 
> > >  	tdmr->pamt_4k_base = pamt_base[TDX_PS_4K];
> > >  	tdmr->pamt_4k_size = pamt_size[TDX_PS_4K];
> > >  	tdmr->pamt_2m_base = pamt_base[TDX_PS_2M];
> > 
> 
> I think a simple memory barrier will do.  How does below look?
> 
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -591,11 +591,12 @@ static int tdmr_set_up_pamt(struct tdmr_info *tdmr,
>          * tdx_memory_shutdown() also reads TDMR's PAMT during
>          * kexec() or reboot, which could happen at anytime, even
>          * during this particular code.  Make sure pamt_4k_base
> -        * is firstly set otherwise tdx_memory_shutdown() may
> -        * get an invalid PAMT base when it sees a valid number
> -        * of PAMT pages.
> +        * is firstly set and place a __mb() after it otherwise
> +        * tdx_memory_shutdown() may get an invalid PAMT base
> +        * when it sees a valid number of PAMT pages.
>          */
>         tdmr->pamt_4k_base = pamt_base[TDX_PS_4K];
> +       __mb();

If you want to play with barriers, assign pamt_4k_base the last with
smp_store_release() and read it first in tdmr_get_pamt() with
smp_load_acquire(). If it is non-zero, all pamt_* fields are valid.

Or just drop this non-sense and use a spin lock for serialization.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
