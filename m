Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB4B67587
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 21:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfGLTst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 15:48:49 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44659 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbfGLTst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 15:48:49 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hm1Ws-0007gn-OD; Fri, 12 Jul 2019 21:48:26 +0200
Date:   Fri, 12 Jul 2019 21:48:20 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
cc:     Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, Paul Turner <pjt@google.com>
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
In-Reply-To: <3ca70237-bf8e-57d9-bed5-bc2329d17177@oracle.com>
Message-ID: <alpine.DEB.2.21.1907122059430.1669@nanos.tec.linutronix.de>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com> <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com> <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de> <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com>
 <20190712125059.GP3419@hirez.programming.kicks-ass.net> <alpine.DEB.2.21.1907121459180.1788@nanos.tec.linutronix.de> <3ca70237-bf8e-57d9-bed5-bc2329d17177@oracle.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Jul 2019, Alexandre Chartre wrote:
> On 7/12/19 5:16 PM, Thomas Gleixner wrote:
> > On Fri, 12 Jul 2019, Peter Zijlstra wrote:
> > > On Fri, Jul 12, 2019 at 01:56:44PM +0200, Alexandre Chartre wrote:
> > > And then we've fully replaced PTI.
> > > 
> > > So no, they're not orthogonal.
> > 
> > Right. If we decide to expose more parts of the kernel mappings then that's
> > just adding more stuff to the existing user (PTI) map mechanics.
>  
> If we expose more parts of the kernel mapping by adding them to the existing
> user (PTI) map, then we only control the mapping of kernel sensitive data but
> we don't control user mapping (with ASI, we exclude all user mappings).

What prevents you from adding functionality to do so to the PTI
implementation? Nothing.

Again, the underlying concept is exactly the same:

  1) Create a restricted mapping from an existing mapping

  2) Switch to the restricted mapping when entering a particular execution
     context

  3) Switch to the unrestricted mapping when leaving that execution context

  4) Keep track of the state

The restriction scope is different, but that's conceptually completely
irrelevant. It's a detail which needs to be handled at the implementation
level.

What matters here is the concept and because the concept is the same, this
needs to share the infrastructure for #1 - #4.

It's obvious that this requires changes to the way PTI works today, but
anything which creates a parallel implementation of any part of the above
#1 - #4 is not going anywhere.

This stuff is way too sensitive and has pretty well understood limitations
and corner cases. So it needs to be designed from ground up to handle these
proper. Which also means, that the possible use cases are going to be
limited.

As I said before, come up with a list of possible usage scenarios and
protection scopes first and please take all the ideas other people have
with this into account. This includes PTI of course.

Once we have that we need to figure out whether these things can actually
coexist and do not contradict each other at the semantical level and
whether the outcome justifies the resulting complexity.

After that we can talk about implementation details.

This problem is not going to be solved with handwaving and an ad hoc
implementation which creates more problems than it solves.

Thanks,

	tglx
