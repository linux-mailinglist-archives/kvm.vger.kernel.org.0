Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEFB1CD6C
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 19:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfENRFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 13:05:35 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49112 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfENRFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 13:05:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KlbgFAVXgBXigN146B3nlFdjOxF2TXPML68s5DT9K4M=; b=jmPpBeXUM05r6s4bzTOSf6IqR
        +gcxkAlmEIZHWVOGUSv2eKJST1OuQS90zya54qlP9PNVULIwibJlblBwZsXAe2Tw9v0vEg7MjiaM/
        boWCqM4HmbVadcMDA2prEGa3avhoxYuF2vh3xSdRIHCKv6faoneacq3v8ilnKkxoDdFTuTgPbsDuT
        uLEdi9/F+FBWIQlm1a1dv6w5TIgPFvJ8BPFmU5wT6QPVgtTBJ1vdYZpeSo4AAqT0EWeUhZDUEIjFO
        FrcTQwOxOHFzl5NUcBxEpfOaWiTDtXCsTRjQU4nGpWW7HpkKES1Iudvt4IdtGHjcxL1Q9sWZFMh2Z
        b4JKSdzYg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQark-0000lD-Qy; Tue, 14 May 2019 17:05:25 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D00982029F888; Tue, 14 May 2019 19:05:22 +0200 (CEST)
Date:   Tue, 14 May 2019 19:05:22 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
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
Message-ID: <20190514170522.GW2623@hirez.programming.kicks-ass.net>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-19-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrWUKZv=wdcnYjLrHDakamMBrJv48wp2XBxZsEmzuearRQ@mail.gmail.com>
 <20190514070941.GE2589@hirez.programming.kicks-ass.net>
 <b8487de1-83a8-2761-f4a6-26c583eba083@oracle.com>
 <B447B6E8-8CEF-46FF-9967-DFB2E00E55DB@amacapital.net>
 <4e7d52d7-d4d2-3008-b967-c40676ed15d2@oracle.com>
 <CALCETrXtwksWniEjiWKgZWZAyYLDipuq+sQ449OvDKehJ3D-fg@mail.gmail.com>
 <e5fedad9-4607-0aa4-297e-398c0e34ae2b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5fedad9-4607-0aa4-297e-398c0e34ae2b@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 14, 2019 at 06:24:48PM +0200, Alexandre Chartre wrote:
> On 5/14/19 5:23 PM, Andy Lutomirski wrote:

> > How important is the ability to enable IRQs while running with the KVM
> > page tables?
> > 
> 
> I can't say, I would need to check but we probably need IRQs at least for
> some timers. Sounds like you would really prefer IRQs to be disabled.
> 

I think what amluto is getting at, is:

again:
	local_irq_disable();
	switch_to_kvm_mm();
	/* do very little -- (A) */
	VMEnter()

		/* runs as guest */

	/* IRQ happens */
	WMExit()
	/* inspect exit raisin */
	if (/* IRQ pending */) {
		switch_from_kvm_mm();
		local_irq_restore();
		goto again;
	}


but I don't know anything about VMX/SVM at all, so the above might not
be feasible, specifically I read something about how VMX allows NMIs
where SVM did not somewhere around (A) -- or something like that,
earlier in this thread.
