Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291356356C4
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 10:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237800AbiKWJba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 04:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237767AbiKWJbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 04:31:07 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375F743874;
        Wed, 23 Nov 2022 01:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SbJhBd7PxrHJEEletiUuq25lFGytClcwopVER3Q2f6w=; b=XaXRz8zC3xm7EJCawMUmwqri3E
        0Yakm1KamvbVF1bwfXXRl7qK5BDfuiT19inEPTo1JRNjmAP8rnlX5xK3JjT5ziWsRghmLTBHXhsL1
        aJUHV27hP9jqjU1EbiQr+jakO1Sy4K2/QjohzNvpgzMhQvPp680+AbVAmAe1mGptCkBW9+j2GrqoI
        l5/qrc8II+GyCwMJ7Q7av262Q3AWAfDOirpb5i7dplgQDRx2Gqv8K0AFz9we2KfL3KyYFTzuR0/zY
        DTHCA/0v0zCpGuKKSKcn3vmMRdLj3j8uRQn58iPQGrE353fd5n5mL0eHm06E/nHTETGYbPJnRT9dB
        nUloIqNw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxm4i-003jja-0E; Wed, 23 Nov 2022 09:29:48 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D98DF300202;
        Wed, 23 Nov 2022 10:29:46 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C05DA2D819C22; Wed, 23 Nov 2022 10:29:46 +0100 (CET)
Date:   Wed, 23 Nov 2022 10:29:46 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, seanjc@google.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Message-ID: <Y33oCuQtLrFugMFc@hirez.programming.kicks-ass.net>
References: <cover.1668988357.git.kai.huang@intel.com>
 <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
 <eb8d0f69-7ada-a358-46ea-da15a3aeac93@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb8d0f69-7ada-a358-46ea-da15a3aeac93@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22, 2022 at 04:21:38PM -0800, Dave Hansen wrote:
> > +	/*
> > +	 * All memory regions that can be used by the TDX module must be
> > +	 * passed to the TDX module during the module initialization.
> > +	 * Once this is done, all "TDX-usable" memory regions are fixed
> > +	 * during module's runtime.
> > +	 *
> > +	 * The initial support of TDX guests only allocates memory from
> > +	 * the global page allocator.  To keep things simple, for now
> > +	 * just make sure all pages in the page allocator are TDX memory.
> > +	 *
> > +	 * To achieve this, use all system memory in the core-mm at the
> > +	 * time of initializing the TDX module as TDX memory, and at the
> > +	 * meantime, reject any new memory in memory hot-add.
> > +	 *
> > +	 * This works as in practice, all boot-time present DIMM is TDX
> > +	 * convertible memory.  However if any new memory is hot-added
> > +	 * before initializing the TDX module, the initialization will
> > +	 * fail due to that memory is not covered by CMR.
> > +	 *
> > +	 * This can be enhanced in the future, i.e. by allowing adding or
> > +	 * onlining non-TDX memory to a separate node, in which case the
> > +	 * "TDX-capable" nodes and the "non-TDX-capable" nodes can exist
> > +	 * together -- the userspace/kernel just needs to make sure pages
> > +	 * for TDX guests must come from those "TDX-capable" nodes.
> > +	 *
> > +	 * Build the list of TDX memory regions as mentioned above so
> > +	 * they can be passed to the TDX module later.
> > +	 */
> 
> This is msotly Documentation/, not a code comment.  Please clean it up.

So personally, I *vastly* prefer code comments over this Documentation/
cesspit. Putting things in Documentation/ is a bit like an
old-folks-home, neatly out of the way to (bit)rot in peace.

And that whole .rst disease is making it unreadable for anybody that
still knows how to use a text editor :-(
