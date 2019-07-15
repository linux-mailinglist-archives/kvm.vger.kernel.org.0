Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF8AB6871C
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 12:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbfGOKe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 06:34:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45504 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729530AbfGOKe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 06:34:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/tb2YFKotIun+RrxUFkUJ3SPYjEiIEB8yDIasy299tI=; b=V5CMHU9SdBHFe0JHCPJ/DfQ9M
        whb9p82Se2ZevWYbvvkDuh9u+U8Uiaonxw43GBYwgQDNYEP3CSLvWClmBZIh3Lm+Ag21BXBcQk1Mb
        tgDnaHbBDgvqR/pGJQkjgPMBi8ydXL5TMB2U0D5aL+V/dJu7peXHwVcCgDtxjqnZvWk5TdtQ3tgPx
        IGTM4iWolBrZicJtBD0iROZpa0kB57IsFZqVCacCQtfX+9jji7DKttASvz4iWs+PWk4iVM7PXf/6Y
        Had9FeMPHZ0ajhZ94uJ2xDAy1FsLZzeKnZY3WncpD74MtSscMFXyqrGpbZ1cwCRW0KIHhvnq6mOlo
        gLv5bHwWA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hmyIt-0001jj-LI; Mon, 15 Jul 2019 10:33:55 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 01F3E20B29100; Mon, 15 Jul 2019 12:33:53 +0200 (CEST)
Date:   Mon, 15 Jul 2019 12:33:53 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>,
        Alexander Graf <graf@amazon.de>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Paul Turner <pjt@google.com>
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
Message-ID: <20190715103353.GC3419@hirez.programming.kicks-ass.net>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com>
 <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de>
 <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com>
 <20190712125059.GP3419@hirez.programming.kicks-ass.net>
 <alpine.DEB.2.21.1907121459180.1788@nanos.tec.linutronix.de>
 <3ca70237-bf8e-57d9-bed5-bc2329d17177@oracle.com>
 <20190712190620.GX3419@hirez.programming.kicks-ass.net>
 <CALCETrWcnJhtUsJ2nrwAqqgdbRrZG6FNLKY_T-WTETL6-B-C1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWcnJhtUsJ2nrwAqqgdbRrZG6FNLKY_T-WTETL6-B-C1g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 14, 2019 at 08:06:12AM -0700, Andy Lutomirski wrote:
> On Fri, Jul 12, 2019 at 12:06 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Fri, Jul 12, 2019 at 06:37:47PM +0200, Alexandre Chartre wrote:
> > > On 7/12/19 5:16 PM, Thomas Gleixner wrote:
> >
> > > > Right. If we decide to expose more parts of the kernel mappings then that's
> > > > just adding more stuff to the existing user (PTI) map mechanics.
> > >
> > > If we expose more parts of the kernel mapping by adding them to the existing
> > > user (PTI) map, then we only control the mapping of kernel sensitive data but
> > > we don't control user mapping (with ASI, we exclude all user mappings).
> > >
> > > How would you control the mapping of userland sensitive data and exclude them
> > > from the user map? Would you have the application explicitly identify sensitive
> > > data (like Andy suggested with a /dev/xpfo device)?
> >
> > To what purpose do you want to exclude userspace from the kernel
> > mapping; that is, what are you mitigating against with that?
> 
> Mutually distrusting user/guest tenants.  Imagine an attack against a
> VM hosting provider (GCE, for example).  If the overall system is
> well-designed, the host kernel won't possess secrets that are
> important to the overall hosting network.  The interesting secrets are
> in the memory of other tenants running under the same host.  So, if we
> can mostly or completely avoid mapping one tenant's memory in the
> host, we reduce the amount of valuable information that could leak via
> a speculation (or wild read) attack to another tenant.
> 
> The practicality of such a scheme is obviously an open question.

Ah, ok. So it's some virt specific nonsense. I'll go on ignoring it then
;-)
