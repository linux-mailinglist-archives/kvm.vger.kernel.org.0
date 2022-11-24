Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029E3637520
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 10:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiKXJ0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 04:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiKXJ0f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 04:26:35 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4291111605A;
        Thu, 24 Nov 2022 01:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SQZFDjndEHG3J/gZQ4hoB38UGRP7fGtXudSzN0rEezs=; b=wJdaVrg+LdaOfZl/BWnSKP3ydA
        UfFD3UMOwMOgDqdguC3qJaLTJxU5N2Wyfpn567fFuQ7IoSIa5+t+uYlm/sIcNKNpCLizneI9lP750
        ak4fAmyZLock5gyuzPhODX+p0Y8q5oFRybW8iiE1/94zoJy9QjMdZytVdt436o+bzsdWBQ5y+cVZ9
        PmRLPFtDpzsV5nmiZTzAvDq7qvRVYrIw3adfPR53tfJCZLHpAbXm2I/owg8xXLUBXv3tF5sJ3xcG1
        2xZb6yfC43G1/A1W6PO5dvFQSD9tXgT+JGLhrElM6ZlbSNNjqnESyP++iVxDOovGWy6HqtqSQaR+d
        6grxBkFA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oy8V2-008ZN0-Ps; Thu, 24 Nov 2022 09:26:28 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 04B6F300202;
        Thu, 24 Nov 2022 10:26:21 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DD8E9203CF645; Thu, 24 Nov 2022 10:26:20 +0100 (CET)
Date:   Thu, 24 Nov 2022 10:26:20 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, seanjc@google.com,
        pbonzini@redhat.com, dave.hansen@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Message-ID: <Y384vDcfTpTnFxx+@hirez.programming.kicks-ass.net>
References: <cover.1668988357.git.kai.huang@intel.com>
 <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
 <637ecded7b0f9_160eb329418@dwillia2-xfh.jf.intel.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <637ecded7b0f9_160eb329418@dwillia2-xfh.jf.intel.com.notmuch>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 05:50:37PM -0800, Dan Williams wrote:

> arch_add_memory() does not add memory to the page allocator.  For
> example, memremap_pages() uses arch_add_memory() and explicitly does not
> release the memory to the page allocator. This check belongs in
> add_memory_resource() to prevent new memory that violates TDX from being
> onlined. Hopefully there is also an option to disable TDX from the
> kernel boot command line to recover memory-hotplug without needing to
> boot into the BIOS to toggle TDX.

So I've been pushing for all this to either require: tdx=force on the
cmdline to boot-time enable, or delay all the memory allocation to the
first KVM/TDX instance being created.

That is, by default, none of this crud should ever trigger and consume
memory if you're not using TDX (most of us really).

(every machine I have loads kvm.ko unconditionally -- even if I never
user KVM, so kvm.ko load time is not a valid point in time to do TDX
enablement).


