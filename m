Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D684472E056
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 13:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241892AbjFMLFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 07:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbjFMLFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 07:05:46 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBBEE52;
        Tue, 13 Jun 2023 04:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686654345; x=1718190345;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UmOXzsunhXdXp44lTelSL36XFYP6MdWvrrp3FDoTFjA=;
  b=PJr1KaD2KaqHlCXk8wilzv7WrvPGxzve0s26imLoLqDNH8gS5559k2Z5
   U3vZ2XvJRx0ErBua/b1sXLiMd/sZRlyGkQaqbTn+60pg3dG54hmg8nTwn
   A9P1WfM/tQt3rkavxLTOdnhTmP2nqLJviHOrruwyCcJjrYIXiTnuJs6xf
   AzkY0dfhrK69HrQ1ckFk55qrn4h2gY4YflucJdteSFIQAYYE7cGx0Slk4
   nImhjNfUzTPubCXLztOXCvcPNbpHLXURAy6XbgNqksYq9LDcojxm92pp5
   vKb9jxhrEGFGJZZuGd+aKk1WjcyEk0sxA8p+dHFuR9TmLgdUs+EQspc3E
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="355796317"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="355796317"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 04:05:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="781617957"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="781617957"
Received: from attilavx-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.62.33])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 04:05:40 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 0BBBB10BB72; Tue, 13 Jun 2023 14:05:38 +0300 (+03)
Date:   Tue, 13 Jun 2023 14:05:38 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
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
Message-ID: <20230613110538.5pwhy26q6irrlqqx@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
 <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
 <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
 <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
 <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
 <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
 <3bbb6b384ba89dfaa13be01654ad27e41d779fba.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bbb6b384ba89dfaa13be01654ad27e41d779fba.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 13, 2023 at 12:51:23AM +0000, Huang, Kai wrote:
> On Mon, 2023-06-12 at 06:47 -0700, Dave Hansen wrote:
> > On 6/12/23 03:27, Huang, Kai wrote:
> > > So I think a __mb() after setting tdmr->pamt_4k_base should be good enough, as
> > > it guarantees when setting to any pamt_*_size happens, the valid pamt_4k_base
> > > will be seen by other cpus.
> > > 
> > > Does it make sense?
> > 
> > Just use a normal old atomic_t or set_bit()/test_bit().  They have
> > built-in memory barriers are are less likely to get botched.
> 
> Thanks for the suggestion.
> 
> Hi Dave, Kirill,
> 
> I'd like to check with you that whether we should introduce a mechanism to track
> TDX private pages for both this patch and the next.
> 
> As you can see this patch only deals PAMT pages due to couple of reasons that
> mnentioned in the changelog.  The next MCE patch handles all TDX private pages,
> but it uses SEAMCALL in the #MC handler.  Using SEAMCALL has two cons: 1) it is
> slow (probably doesn't matter, though); 2) it brings additional risk of
> triggering further #MC inside TDX module, although such risk should be a
> theoretical thing.
> 
> If we introduce a helper to mark a page as TDX private page, then both above
> patches can utilize it.  We don't need to consult TDMRs to get PAMT anymore in
> this patch (we will need a way to loop all TDX-usable memory pages, but this
> needs to be done anyway with TDX guests).  I believe eventually we can end up
> with less code.
> 
> In terms of how to do, for PAMT pages, we can set page->private to a TDX magic
> number because they come out of page allocator directly.  Secure-EPT pages are
> like PAMT pages too.  For TDX guest private pages, Sean is moving to implement
> KVM's own pseudo filesystem so they will have a unique mapping to identify.
> 
> https://github.com/sean-jc/linux/commit/40d338c8629287dda60a9f7c800ede8549295a7c
> 
> And my thinking is in this TDX host series, we can just handle PAMT pages.  Both
> secure-EPT and TDX guest private pages can be handled later in KVM TDX series. 
> I think eventually we can have a function like below to tell whether a page is
> TDX private page:
> 
> 	bool page_is_tdx_private(struct page *page)
> 	{
> 		if (page->private == TDX_PRIVATE_MAGIC)
> 			return true;
> 
> 		if (!page_mapping(page))
> 			return false;
> 
> 		return page_mapping(page)->a_ops == &kvm_gmem_ops;
> 	}
> 
> How does this sound?  Or any other comments?  Thanks!

If you going to take this path it has to be supported natively by
kvm_gmem_: it has to provide API for that. You should not assume that
page->private is free to use. It is owned by kvm_gmmem.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
