Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0671F2865D2
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 19:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgJGRX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 13:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbgJGRX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 13:23:27 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FF0C061755;
        Wed,  7 Oct 2020 10:23:27 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602091405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=US7OlZB3Wbd40lN+C7dejW8T4VUhOzqwycXqKeH1chA=;
        b=QIG24b30dkPJU+bwwhTSk8gJh6XPe2rUyTiPSLsWd4EG0orRqjbdFDCNycbz6yThp1SxBp
        y4gl81oKkoxGH4yLQdeGTjVmS1gezWE8x+VJKwPv2F+Sgd+P8P85+zJlYkpBZqtY8vHMw2
        oSzoVBcMrLvuX0i3MVGPuEnCXPe0NK6lri3KoP9ins8/YjRYvSnxOPVVUZUn8XWQo9vXC/
        xJuGVJnvqAsGwv9IDJAT9uG68Wb+QYVQMh22rraUekqZXOgQWIB5Y5wzyVkcZyHFr9ZND2
        WH2JVcX8FSinw2ho9Nms+9MDJn8DOop3KAqKLzyrLIaQlRpC26+zuRm2WAZDLw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602091405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=US7OlZB3Wbd40lN+C7dejW8T4VUhOzqwycXqKeH1chA=;
        b=2cRl4Fva7xJupCoSyVzWI4Md54ZIcgq3iaG+hUCZcRdCP5oQWa2sq+1ACWV3i/AQuyDlzD
        bf6ZhuqDBgw8PmAA==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/13] x86/irq: Limit IOAPIC and MSI domains' affinity without IR
In-Reply-To: <2f09a1f97d97e638e90c6eca3ebeebb4be852f58.camel@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org> <20201005152856.974112-1-dwmw2@infradead.org> <20201005152856.974112-10-dwmw2@infradead.org> <87d01v58bw.fsf@nanos.tec.linutronix.de> <d34efce9ca5a4a9d8d8609f872143e306bf5ee98.camel@infradead.org> <874kn65h0r.fsf@nanos.tec.linutronix.de> <F9476D19-3D08-4CE6-A535-6C1D2E9BA88D@infradead.org> <87imbm3zdq.fsf@nanos.tec.linutronix.de> <f73340328712558c3329e11b75e32c364d01edf6.camel@infradead.org> <87d01u3vo6.fsf@nanos.tec.linutronix.de> <2f09a1f97d97e638e90c6eca3ebeebb4be852f58.camel@infradead.org>
Date:   Wed, 07 Oct 2020 19:23:25 +0200
Message-ID: <874kn63q7m.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07 2020 at 16:46, David Woodhouse wrote:
> The PCI MSI domain, HPET, and even the IOAPIC are just the things out
> there on the bus which might perform those physical address cycles. And
> yes, as you say they're just a message store sending exactly the
> message that was composed for them. They know absolutely nothing about
> what the message means and how it is composed.

That's what I said.

> It so happens that in Linux, we don't really architect the software
> like that. So each of the PCI MSI domain, HPET, and IOAPIC have their
> *own* message composer which has the same limits and composes basically
> the same messages as if it was *their* format, not dictated to them by
> the APIC upstream. And that's what we're both getting our panties in a
> knot about, I think.

Are you actually reading what I write and caring to look at the code?

PCI-MSI does not have a compose message callback in the irq chip. The
message is composed by the underlying parent domain. Same for HPET.

The only dogdy part is the IO/APIC for hysterical raisins and because
I did not come around yet to sort that out.

> It really doesn't matter that much to the underlying generic irqdomain
> support for limited affinities. Except that you want to make the
> generic code support the concept of a child domain supporting *more*
> CPUs than its parent, which really doesn't make much sense if you think
> about it.

Right. So we really want to stick the restriction into a compat-MSI
domain to make stuff match reality and to avoid banging the head against
the wall sooner than later.

Thanks,

        tglx

