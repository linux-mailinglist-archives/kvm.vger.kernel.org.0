Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068A7212578
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 15:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbgGBN7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 09:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgGBN7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 09:59:09 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BADC08C5C1;
        Thu,  2 Jul 2020 06:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gl1jKq2wcYbRMLXz2bIDCOo5JcG5MyTdy5yY3rjDs6A=; b=m8T/FHGXVQuNDN0fShATSEBI4v
        gdrv0UOm+Qc/TVk/hko/YWkvsicyavkQ7T9kgB1cXA3f7SjZGveySW1lNZ9pj7AAP82GfbQIZyFHG
        zIE/4hT4rRZHeOu0DKsXG9q2FaZhCLNucDE/UC0Nd/S35IgBPjOvQksaJDcpvMVzz1T3OuEJBqp/Y
        65ZZ5ev6vizlBoY4BgFQw8w3IoiMECG3nxictrZc5jD3AMR8gm9YDJ4ph+8dg4ZqKeiWnkvUBInFh
        hRtFgvtrFhaZLOIBTYl8vUlDtHnDdTrCDeaVSN3VUb9IY4fvK5ibZneIRU4p0OvqMhjBx74ZuS5SV
        PXmXmfMw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqzjh-0003A1-DO; Thu, 02 Jul 2020 13:58:45 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4321730015A;
        Thu,  2 Jul 2020 15:58:42 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3057B203DA8CF; Thu,  2 Jul 2020 15:58:42 +0200 (CEST)
Date:   Thu, 2 Jul 2020 15:58:42 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "Liang, Kan" <kan.liang@intel.com>
Subject: Re: [PATCH v12 00/11] Guest Last Branch Recording Enabling
Message-ID: <20200702135842.GR4800@hirez.programming.kicks-ass.net>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
 <20200702074059.GX4781@hirez.programming.kicks-ass.net>
 <5d3980e3-1c49-4174-4cdb-f40fc21ee6c1@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d3980e3-1c49-4174-4cdb-f40fc21ee6c1@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 02, 2020 at 09:11:06AM -0400, Liang, Kan wrote:
> On 7/2/2020 3:40 AM, Peter Zijlstra wrote:
> > On Sat, Jun 13, 2020 at 04:09:45PM +0800, Like Xu wrote:
> > > Like Xu (10):
> > >    perf/x86/core: Refactor hw->idx checks and cleanup
> > >    perf/x86/lbr: Add interface to get LBR information
> > >    perf/x86: Add constraint to create guest LBR event without hw counter
> > >    perf/x86: Keep LBR records unchanged in host context for guest usage
> > 
> > > Wei Wang (1):
> > >    perf/x86: Fix variable types for LBR registers
> > 
> > >   arch/x86/events/core.c            |  26 +--
> > >   arch/x86/events/intel/core.c      | 109 ++++++++-----
> > >   arch/x86/events/intel/lbr.c       |  51 +++++-
> > >   arch/x86/events/perf_event.h      |   8 +-
> > >   arch/x86/include/asm/perf_event.h |  34 +++-
> > 
> > These look good to me; but at the same time Kan is sending me
> > Architectural LBR patches.
> > 
> > Kan, if I take these perf patches and stick them in a tip/perf/vlbr
> > topic branch, can you rebase the arch lbr stuff on top, or is there
> > anything in the arch-lbr series that badly conflicts with this work?
> > 
> 
> Yes, I can rebase the arch lbr patches on top of them.
> Please push the tip/perf/vlbr branch, so I can pull and rebase my patches.

For now I have:

  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git perf/vlbr

Once the 0day robot comes back all-green, I'll push it out to
tip/perf/vlbr and merge it into tip/perf/core.

Thanks!
