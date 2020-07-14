Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806AF21F375
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 16:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgGNOFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 10:05:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:39115 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgGNOFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 10:05:34 -0400
IronPort-SDR: JsNTKOUr2gcHeyG3pm1xi41DVInPNb+gT1kXyet7nDBPhj4vb0qXjQwyecVZ9/1hJrfUaVkDT8
 BRzeW43Y/SBQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="146909742"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="146909742"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 07:05:33 -0700
IronPort-SDR: eGszF9rU3raCpmbUyK5l3B5h54O2LKQEwj0CgnC2QNDXO5A+CRyMSFo8tU9PVYazjd+n+HafrJ
 EE1yUQCnww3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="390489117"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 14 Jul 2020 07:05:34 -0700
Date:   Tue, 14 Jul 2020 07:05:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, frankja@linux.ibm.com, david@redhat.com,
        drjones@redhat.com, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] lib/alloc_page: Fix compilation
 issue on 32bit archs
Message-ID: <20200714140534.GB14404@linux.intel.com>
References: <20200714110919.50724-1-imbrenda@linux.ibm.com>
 <20200714110919.50724-3-imbrenda@linux.ibm.com>
 <866d79a4-0205-5d49-d407-4e3415b63762@redhat.com>
 <20200714134123.022b3117@ibm-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714134123.022b3117@ibm-vm>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 01:41:23PM +0200, Claudio Imbrenda wrote:
> On Tue, 14 Jul 2020 13:20:16 +0200
> Thomas Huth <thuth@redhat.com> wrote:
> 
> > On 14/07/2020 13.09, Claudio Imbrenda wrote:
> > > The assert in lib/alloc_page is hardcoded to long, and size_t is
> > > just an int on 32 bit architectures.
> > > 
> > > Adding a cast makes the compiler happy.
> > > 
> > > Fixes: 73f4b202beb39 ("lib/alloc_page: change some parameter types")
> > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > ---
> > >  lib/alloc_page.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> > > index fa3c527..617b003 100644
> > > --- a/lib/alloc_page.c
> > > +++ b/lib/alloc_page.c
> > > @@ -29,11 +29,12 @@ void free_pages(void *mem, size_t size)
> > >  	assert_msg((unsigned long) mem % PAGE_SIZE == 0,
> > >  		   "mem not page aligned: %p", mem);
> > >  
> > > -	assert_msg(size % PAGE_SIZE == 0, "size not page aligned:
> > > %#lx", size);
> > > +	assert_msg(size % PAGE_SIZE == 0, "size not page aligned:
> > > %#lx",
> > > +		(unsigned long)size);
> > >  
> > >  	assert_msg(size == 0 || (uintptr_t)mem == -size ||
> > >  		   (uintptr_t)mem + size > (uintptr_t)mem,
> > > -		   "mem + size overflow: %p + %#lx", mem, size);
> > > +		   "mem + size overflow: %p + %#lx", mem,
> > > (unsigned long)size);  
> > 
> > Looking at lib/printf.c, it seems like it also supports %z ... have
> > you tried?
> 
> no, but in hindsight I should have. It's probably a much cleaner
> solution. I'll try and respin.

I'm not opposed to using size_t, but if we go that route then the entirety
of alloc_page.c should be converted to size_t.  As is, there is code like:

	void free_pages_by_order(void *mem, unsigned int order)
	{
        	free_pages(mem, 1ul << (order + PAGE_SHIFT));
	}

and

	void *alloc_pages(unsigned int order)
	{
		...

		/* Looking for a run of length (1 << order). */
		unsigned long run = 0;
		const unsigned long n = 1ul << order;
		const unsigned long align_mask = (n << PAGE_SHIFT) - 1;
		void *run_start = NULL;
		void *run_prev = NULL;
		unsigned long run_next_pa = 0;
		unsigned long pa;

		assert(order < sizeof(unsigned long) * 8);

		...
	}

that very explicitly uses 'unsigned long' for the size.
