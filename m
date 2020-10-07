Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4904286213
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 17:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgJGPZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 11:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbgJGPZb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 11:25:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7F8C061755;
        Wed,  7 Oct 2020 08:25:31 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602084330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kiCPfqTAmORWmLAjTEc4XeS46cNwMzONgAXKlkWAebM=;
        b=hG/eyD5caDYgfDBbiW+TGbLPUOv41+4TrMG2q+2yP08Yh5Cnzbx3evZyfO3P84Hd1Qx0Ki
        lJiYwsDb03QKwNnEp4CqYqdTU3Cor73ZS6Driz/6psgwDJupDW6iDPWBYiLXQqdCmFtPol
        D9dvR5nc1QseyT5pX1+jdKFZd0Xjkr0nSkcxokUlQOZKl/ufDaPY6HQf4WV38w88RN01P+
        FI/lJMkiE1ym5md4HGRvmA5nwg7/igZEckY5tJHhIrEvQcdDDUJaxG4TMtzrptcWoMmmpb
        58K+0vUnX+Syn0Di0rMo+6zLD3J1lHqJcxaEltW+6tvNvhKAMomwzhzGrH7QhA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602084330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kiCPfqTAmORWmLAjTEc4XeS46cNwMzONgAXKlkWAebM=;
        b=ph0vAVplpydDLLyAPvUsYQZ8RAAKjLxuve5muHLeg/9YxcppWuYI6fMzantfArp5NcG3GG
        KWgqAElZvf6AXlDg==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/13] x86/irq: Limit IOAPIC and MSI domains' affinity without IR
In-Reply-To: <f73340328712558c3329e11b75e32c364d01edf6.camel@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org> <20201005152856.974112-1-dwmw2@infradead.org> <20201005152856.974112-10-dwmw2@infradead.org> <87d01v58bw.fsf@nanos.tec.linutronix.de> <d34efce9ca5a4a9d8d8609f872143e306bf5ee98.camel@infradead.org> <874kn65h0r.fsf@nanos.tec.linutronix.de> <F9476D19-3D08-4CE6-A535-6C1D2E9BA88D@infradead.org> <87imbm3zdq.fsf@nanos.tec.linutronix.de> <f73340328712558c3329e11b75e32c364d01edf6.camel@infradead.org>
Date:   Wed, 07 Oct 2020 17:25:29 +0200
Message-ID: <87d01u3vo6.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07 2020 at 16:05, David Woodhouse wrote:
> On Wed, 2020-10-07 at 16:05 +0200, Thomas Gleixner wrote:
>> The top most MSI irq chip does not even have a compose function, neither
>> for the remap nor for the vector case. The composition is done by the
>> parent domain from the data which the parent domain constructed. Same
>> for the IO/APIC just less clearly separated.
>> 
>> The top most chip just takes what the underlying domain constructed and
>> writes it to the message store, because that's what the top most chip
>> controls. It does not control the content.
>
> Sure, whatever. The way we arrange the IRQ domain hierarchy in x86
> Linux doesn't really match my understanding of the real hardware, or
> how qemu emulates it either. But it is at least internally self-
> consistent, and in this model it probably does make some sense to claim
> the 8-bit limit on x86_vector_domain itself, and *remove* that limit in
> the remapping irqdomain.

It's clearly how the hardware works. MSI has a message store of some
sorts and if the entry is enabled then the MSI chip (in PCI or
elsewhere) will send exactly the message which is in that message
store. It knows absolutely nothing about what the message means and how
it is composed. The only things which MSI knows about is whether the
message address is 64bit wide or not and whether the entries are
maskable or not and how many entries it can store.

Software allocates a message target at the underlying irq domain (vector
or remap) and that underlying irq domain defines the properties.

If qemu emulates it differently then it's qemu's problem, but that does
not make it in anyway something which influences the irq domain
abstractions which are correctly modeled after how the hardware works.

> Not really the important part to deal with right now, either way.

Oh yes it is. We define that upfront and not after the fact.

Thanks,

        tglx
