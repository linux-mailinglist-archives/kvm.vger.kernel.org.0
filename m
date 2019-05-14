Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38EE81C3E4
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 09:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfENHhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 03:37:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34442 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfENHhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 03:37:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6IoQ7/a9IdkQHn1Z/AXbPyDzwjbmRx3DkVjFwe9CEr4=; b=TyVPLD0SuH8xFWcuuRZSwo1sP
        8NH2oliCz6k+CkUA52kcYMXTQ7tI1VjhC7hYfxAFEAH2MZYgF66I00OTKLwbnA9zwoeDr5xf9yTAp
        EB8PrSa5tGh8JoV74QlruaIt827d4iHtIW8J6WUsCK0Js9irNEkaPSitW+rKhkYW7Ph6gqY84ach0
        IYB0PN/E40HNVyTr7RZAcMu6LsLDAvaMI0S7UEbZPM9hfVJA6z8GKpaAineuy0Mt32gHv13QBjAAC
        4kegUb2GuuJ6eO898xWcEwLFAS+STD4il34l65Pi3sp3p3fydhRKrA1qfUa83YvW9MSN5VVbJiTzN
        humsLFLew==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQS0K-0006Br-11; Tue, 14 May 2019 07:37:40 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8818D2029F87A; Tue, 14 May 2019 09:37:38 +0200 (CEST)
Date:   Tue, 14 May 2019 09:37:38 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
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
        jan.setjeeilers@oracle.com, Jonathan Adams <jwadams@google.com>
Subject: Re: [RFC KVM 00/27] KVM Address Space Isolation
Message-ID: <20190514073738.GH2589@hirez.programming.kicks-ass.net>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrVhRt0vPgcun19VBqAU_sWUkRg1RDVYk4osY6vK0SKzgg@mail.gmail.com>
 <C2A30CC6-1459-4182-B71A-D8FF121A19F2@oracle.com>
 <CALCETrXK8+tUxNA=iVDse31nFRZyiQYvcrQxV1JaidhnL4GC0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXK8+tUxNA=iVDse31nFRZyiQYvcrQxV1JaidhnL4GC0w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 07:07:36PM -0700, Andy Lutomirski wrote:
> On Mon, May 13, 2019 at 2:09 PM Liran Alon <liran.alon@oracle.com> wrote:

> > The hope is that the very vast majority of #VMExit handlers will be
> > able to completely run without requiring to switch to full address
> > space. Therefore, avoiding the performance hit of (2).

> > However, for the very few #VMExits that does require to run in full
> > kernel address space, we must first kick the sibling hyperthread
> > outside of guest and only then switch to full kernel address space
> > and only once all hyperthreads return to KVM address space, then
> > allow then to enter into guest.
> 
> What exactly does "kick" mean in this context?  It sounds like you're
> going to need to be able to kick sibling VMs from extremely atomic
> contexts like NMI and MCE.

Yeah, doing the full synchronous thing from NMI/MCE context sounds
exceedingly dodgy, howver..

Realistically they only need to send an IPI to the other sibling; they
don't need to wait for the VMExit to complete or anything else.

And that is something we can do from NMI context -- with a bit of care.
See also arch_irq_work_raise(); specifically we need to ensure we leave
the APIC in an idle state, such that if we interrupted an APIC sequence
it will not suddenly fail/violate the APIC write/state etc.

