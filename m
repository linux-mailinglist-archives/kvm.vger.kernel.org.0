Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFDB072BA0A
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 10:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbjFLIRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 04:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjFLIQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 04:16:59 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54671B3;
        Mon, 12 Jun 2023 01:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686557815; x=1718093815;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ardrXUUaDCUC8rYZCEBB1Od/Uz+5UBeHiqci3S1ZWy0=;
  b=YJKR9XUJKHPzbG3FpLGDi0XSCdvGHDU8DqE9SlJqmBWhIas7+sYoCZMI
   rS+2ajFgNVl7fxdVSZNeHooLfUnQkLHsO3iRrv9qZ8/oGU4Gj0R7S4Lv4
   5v8b0hoLDKbXb8a4reGGKWvbrUBsZaH5oFC/1fNILChjDeRfTLg6Um81d
   6+tyuYgzkoNAaXOxkyKSFCIXOdP9lTTHIY2ehJU9HNJStHvDmv99AT2ja
   6KGSpBIvhZQfe5P8IUXpB1OqZ3FaqQHFazrfYP1weQE5DcsqsufzEnmE9
   y/flNQSybSOPiMDJ/pwChTPkEVk0aMWviE54HAIaT9FOXl1+nccOMn/yS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="360457577"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="360457577"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 00:59:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="855514931"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="855514931"
Received: from smizr3x-mobl3.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.43.127])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 00:59:13 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 470A010CC1C; Mon, 12 Jun 2023 10:59:10 +0300 (+03)
Date:   Mon, 12 Jun 2023 10:59:10 +0300
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
Subject: Re: [PATCH v11 19/20] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Message-ID: <20230612075910.jqkiofjm6mkdl7cy@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <116cafb15625ac0bcda7b47143921d0c42061b69.1685887183.git.kai.huang@intel.com>
 <20230609131754.dhii5ctfwtzx667o@box.shutemov.name>
 <90aefcfd663c654197c5878e410f55cc4473eb79.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90aefcfd663c654197c5878e410f55cc4473eb79.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023 at 03:08:40AM +0000, Huang, Kai wrote:
> On Fri, 2023-06-09 at 16:17 +0300, kirill.shutemov@linux.intel.com wrote:
> > On Mon, Jun 05, 2023 at 02:27:32AM +1200, Kai Huang wrote:
> > > The first few generations of TDX hardware have an erratum.  Triggering
> > > it in Linux requires some kind of kernel bug involving relatively exotic
> > > memory writes to TDX private memory and will manifest via
> > > spurious-looking machine checks when reading the affected memory.
> > > 
> > > == Background ==
> > > 
> > > Virtually all kernel memory accesses operations happen in full
> > > cachelines.  In practice, writing a "byte" of memory usually reads a 64
> > > byte cacheline of memory, modifies it, then writes the whole line back.
> > > Those operations do not trigger this problem.
> > > 
> > > This problem is triggered by "partial" writes where a write transaction
> > > of less than cacheline lands at the memory controller.  The CPU does
> > > these via non-temporal write instructions (like MOVNTI), or through
> > > UC/WC memory mappings.  The issue can also be triggered away from the
> > > CPU by devices doing partial writes via DMA.
> > > 
> > > == Problem ==
> > > 
> > > A partial write to a TDX private memory cacheline will silently "poison"
> > > the line.  Subsequent reads will consume the poison and generate a
> > > machine check.  According to the TDX hardware spec, neither of these
> > > things should have happened.
> > > 
> > > To add insult to injury, the Linux machine code will present these as a
> > > literal "Hardware error" when they were, in fact, a software-triggered
> > > issue.
> > > 
> > > == Solution ==
> > > 
> > > In the end, this issue is hard to trigger.  Rather than do something
> > > rash (and incomplete) like unmap TDX private memory from the direct map,
> > > improve the machine check handler.
> > > 
> > > Currently, the #MC handler doesn't distinguish whether the memory is
> > > TDX private memory or not but just dump, for instance, below message:
> > > 
> > >  [...] mce: [Hardware Error]: CPU 147: Machine Check Exception: f Bank 1: bd80000000100134
> > >  [...] mce: [Hardware Error]: RIP 10:<ffffffffadb69870> {__tlb_remove_page_size+0x10/0xa0}
> > >  	...
> > >  [...] mce: [Hardware Error]: Run the above through 'mcelog --ascii'
> > >  [...] mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
> > >  [...] Kernel panic - not syncing: Fatal local machine check
> > > 
> > > Which says "Hardware Error" and "Data load in unrecoverable area of
> > > kernel".
> > > 
> > > Ideally, it's better for the log to say "software bug around TDX private
> > > memory" instead of "Hardware Error".  But in reality the real hardware
> > > memory error can happen, and sadly such software-triggered #MC cannot be
> > > distinguished from the real hardware error.  Also, the error message is
> > > used by userspace tool 'mcelog' to parse, so changing the output may
> > > break userspace.
> > > 
> > > So keep the "Hardware Error".  The "Data load in unrecoverable area of
> > > kernel" is also helpful, so keep it too.
> > > 
> > > Instead of modifying above error log, improve the error log by printing
> > > additional TDX related message to make the log like:
> > > 
> > >   ...
> > >  [...] mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
> > >  [...] mce: [Hardware Error]: Machine Check: Memory error from TDX private memory. May be result of CPU erratum.
> > 
> > The message mentions one part of issue -- CPU erratum -- but misses the
> > other required part -- kernel bug that makes kernel access the memory it
> > not suppose to.
> > 
> 
> How about below?
> 
> "Memory error from TDX private memory. May be result of CPU erratum caused by
> kernel bug."

Fine, I guess.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
