Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 196F21C3A7
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 09:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfENHJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 03:09:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55886 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfENHJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 03:09:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/z5RzNGJzW1HToa5OVxP0O9danntTUkXNkeid122vEM=; b=uX/PF8/BZSeVv5cPYS/kBWxFp
        UDDr+gcUIfetuw8aGDKQAfysqqZJaUz81VHEMON8xTdLLiTpmvG5WCRkt/CEY21gb3D6P2AlCsjNa
        sf0i36/+rwA+lGQOrFddAhvfXScybliJbFvtwsTcLmcFia80AO9SPV6fbZAreQpv5iwSvaXbG5clt
        qAWW+0m229JhnOySjs3Bm0qnNwoc5kzUN/Zdjgf7IEFS/vVTiv9X4ZmIi0PMu6AnplhZzKcMcqcbA
        pBmJBkzg/ZEv1TJPg3f7a2OKjgL7A/SQEMkkAMbOx0FX6IMKXMEaIGyTsnQkbUyFo8ri6RR70llLI
        uwPjbMl2g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQRZH-0006YZ-Fs; Tue, 14 May 2019 07:09:43 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 032842029F87A; Tue, 14 May 2019 09:09:41 +0200 (CEST)
Date:   Tue, 14 May 2019 09:09:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
Subject: Re: [RFC KVM 18/27] kvm/isolation: function to copy page table
 entries for percpu buffer
Message-ID: <20190514070941.GE2589@hirez.programming.kicks-ass.net>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-19-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrWUKZv=wdcnYjLrHDakamMBrJv48wp2XBxZsEmzuearRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWUKZv=wdcnYjLrHDakamMBrJv48wp2XBxZsEmzuearRQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 11:18:41AM -0700, Andy Lutomirski wrote:
> On Mon, May 13, 2019 at 7:39 AM Alexandre Chartre
> <alexandre.chartre@oracle.com> wrote:
> >
> > pcpu_base_addr is already mapped to the KVM address space, but this
> > represents the first percpu chunk. To access a per-cpu buffer not
> > allocated in the first chunk, add a function which maps all cpu
> > buffers corresponding to that per-cpu buffer.
> >
> > Also add function to clear page table entries for a percpu buffer.
> >
> 
> This needs some kind of clarification so that readers can tell whether
> you're trying to map all percpu memory or just map a specific
> variable.  In either case, you're making a dubious assumption that
> percpu memory contains no secrets.

I'm thinking the per-cpu random pool is a secrit. IOW, it demonstrably
does contain secrits, invalidating that premise.
