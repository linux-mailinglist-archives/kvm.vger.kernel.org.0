Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0826D67236
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 17:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfGLPVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 11:21:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55840 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfGLPVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 11:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uWWyW2YDtC0k6gJbqvGGDtXLIh/dygPNqHBQzuripY4=; b=LRpvbwuyvthu0RGBF/kNz9WT4
        TvL6NJFgmKj1YTbH/Q1luwGXROnKib4MoSJRSv36BWnauvOLUIjs4IYaxouYot6WbBAdgj1hGzwzV
        Zhk33bc+ETttOzwYzdkhEDyoYIZHYI8AxkXD+O0QV2M0khTOByI/JtZazzxSVMtWSt5jBFPpm0Gyo
        fipS/Gh/19/eM9Uc5e6dEc11Tz1Mm+DDcAvtfQfB79lcdLherqODj9TUFRVqvOlyRCVMME2XWZ3ri
        RWWywWgE7IGSsa6YH1reuguPfod0XMfoiHdTp37uiPUnwGvUeKrvoUgBqlk3rEotvKmI1X2JXR4FL
        R/HLEg+Gw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hlxLy-0002Dw-U3; Fri, 12 Jul 2019 15:20:55 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DE70D209772EE; Fri, 12 Jul 2019 17:20:52 +0200 (CEST)
Date:   Fri, 12 Jul 2019 17:20:52 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, pbonzini@redhat.com,
        rkrcmar@redhat.com, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, Paul Turner <pjt@google.com>
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
Message-ID: <20190712152052.GU3419@hirez.programming.kicks-ass.net>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com>
 <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de>
 <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com>
 <20190712125059.GP3419@hirez.programming.kicks-ass.net>
 <3626998c-509f-b434-1f66-9db2c09c47d4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3626998c-509f-b434-1f66-9db2c09c47d4@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 06:54:22AM -0700, Dave Hansen wrote:
> On 7/12/19 5:50 AM, Peter Zijlstra wrote:
> > PTI is not mapping         kernel space to avoid             speculation crap (meltdown).
> > ASI is not mapping part of kernel space to avoid (different) speculation crap (MDS).
> > 
> > See how very similar they are?
> 
> That's an interesting point.
> 
> I'd add that PTI maps a part of kernel space that partially overlaps
> with what ASI wants.

Right, wherever we put the boundary, we need whatever is required to
cross it.

> > But looking at it that way, it makes no sense to retain 3 address
> > spaces, namely:
> > 
> >   user / kernel exposed / kernel private.
> > 
> > Specifically, it makes no sense to expose part of the kernel through MDS
> > but not through Meltdown. Therefore we can merge the user and kernel
> > exposed address spaces.
> > 
> > And then we've fully replaced PTI.
> 
> So, in one address space (PTI/user or ASI), we say, "screw it" and all
> the data mapped is exposed to speculation attacks.  We have to be very
> careful about what we map and expose here.

Yes, which is why, in an earlier email, I've asked for a clear
definition of 'sensitive" :-)

> So, maybe we're not replacing PTI as much as we're growing PTI so that
> we can run more kernel code with the (now inappropriately named) user
> page tables.

Right.
