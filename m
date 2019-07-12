Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF21466F92
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 15:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfGLNHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 09:07:34 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:32988 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfGLNHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 09:07:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=T+6x5moI4ijHJRrmZf1/HMLH18HnK/GwuxqCFGxwS5I=; b=A9qfZo9sr9OqLZBSfJxGmDAhT
        ZZZxl019nrb97yxFuvWomOiduo/GheSG9p3CTkWHjArZa/UIhnADvaTM2LCb7qveLtJPfNHxCY5Ap
        VzbwMtbtgFfbjgLgq3H8NkhaQxltntOiM2EFFj4c4+An38q/pSMHUFlzuTruF3le5kVT5DstWyawJ
        0IM58fcRQ4R3Qv6CHhx3ZR71wy6honrRdfbJ4ndntJn2vZRnPGcXcNfzUR/MDifTTAU/5Pb33Ygw9
        xfBSaPB1K6FZ6cTT7Qfx0psmi4ERnnwigSBp81Wf0w32b4Utoxw/Xs+GMw7Sw+zKMa/nE42cMR4oA
        6jQAdEZ5w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hlvGk-0006ES-Se; Fri, 12 Jul 2019 13:07:23 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E8AA3209772E8; Fri, 12 Jul 2019 15:07:20 +0200 (CEST)
Date:   Fri, 12 Jul 2019 15:07:20 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, Paul Turner <pjt@google.com>
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
Message-ID: <20190712130720.GQ3419@hirez.programming.kicks-ass.net>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <20190712114458.GU3402@hirez.programming.kicks-ass.net>
 <1f97f1d9-d209-f2ab-406d-fac765006f91@oracle.com>
 <20190712123653.GO3419@hirez.programming.kicks-ass.net>
 <b1b7f85f-dac3-80a3-c05c-160f58716ce8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1b7f85f-dac3-80a3-c05c-160f58716ce8@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 02:47:23PM +0200, Alexandre Chartre wrote:
> On 7/12/19 2:36 PM, Peter Zijlstra wrote:
> > On Fri, Jul 12, 2019 at 02:17:20PM +0200, Alexandre Chartre wrote:
> > > On 7/12/19 1:44 PM, Peter Zijlstra wrote:
> > 
> > > > AFAIK3 this wants/needs to be combined with core-scheduling to be
> > > > useful, but not a single mention of that is anywhere.
> > > 
> > > No. This is actually an alternative to core-scheduling. Eventually, ASI
> > > will kick all sibling hyperthreads when exiting isolation and it needs to
> > > run with the full kernel page-table (note that's currently not in these
> > > patches).
> > > 
> > > So ASI can be seen as an optimization to disabling hyperthreading: instead
> > > of just disabling hyperthreading you run with ASI, and when ASI can't preserve
> > > isolation you will basically run with a single thread.
> > 
> > You can't do that without much of the scheduler changes present in the
> > core-scheduling patches.
> > 
> 
> We hope we can do that without the whole core-scheduling mechanism. The idea
> is to send an IPI to all sibling hyperthreads. This IPI will interrupt these
> sibling hyperthreads and have them wait for a condition that will allow them
> to resume execution (for example when re-entering isolation). We are
> investigating this in parallel to ASI.

You cannot wait from IPI context, so you have to go somewhere else to
wait.

Also, consider what happens when the task that entered isolation decides
to schedule out / gets migrated.

I think you'll quickly find yourself back at core-scheduling.
