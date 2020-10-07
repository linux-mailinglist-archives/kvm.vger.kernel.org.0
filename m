Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CA32860EA
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 16:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgJGOFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 10:05:32 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43862 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728594AbgJGOFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 10:05:25 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602079522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LzEHXmRA/+S5FieraB+lOb+37CIRymPBPLiuuZ72Uwk=;
        b=b6EMJ38hmOqqUdMLN9WMFDwfP4fMnCTTl8fHq1oNh5Fn7xxrab46j41h8HKuigv/4EySCn
        u28RtIZIYyAYA19YhTq72UPlwsYHxjB4dngvqX4XWiwgvw94/cLbMRqJ1TagClt/+dt0T5
        n0Mx+im9bz+jT0YtBkcNuXOWeqZtPMLYrV3hlpxAOjhmgMsxEzH/IkDaQtJAacFAKEnC4S
        0F9WzKxw4CWmG28NiL4DYWo/PBBVlC37qG2dqkSOjCiPwVpzbWHEFQhCB/7k50BWceRCC3
        5V5eGsE+H1qYqi/npGRe9m4CCa//I4ZSUnQiTyxPLDTtlWhoVJfx2wt8znrz1g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602079522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LzEHXmRA/+S5FieraB+lOb+37CIRymPBPLiuuZ72Uwk=;
        b=WbLYp+LR99UXVn5/klOP92H7Pro/dNqWl0O1lh22POQqCRrntPUpVMGuc5Rvzh48CCVDUv
        urLq7f177+6X/1AQ==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/13] x86/irq: Limit IOAPIC and MSI domains' affinity without IR
In-Reply-To: <F9476D19-3D08-4CE6-A535-6C1D2E9BA88D@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org> <20201005152856.974112-1-dwmw2@infradead.org> <20201005152856.974112-10-dwmw2@infradead.org> <87d01v58bw.fsf@nanos.tec.linutronix.de> <d34efce9ca5a4a9d8d8609f872143e306bf5ee98.camel@infradead.org> <874kn65h0r.fsf@nanos.tec.linutronix.de> <F9476D19-3D08-4CE6-A535-6C1D2E9BA88D@infradead.org>
Date:   Wed, 07 Oct 2020 16:05:21 +0200
Message-ID: <87imbm3zdq.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07 2020 at 14:08, David Woodhouse wrote:
> On 7 October 2020 13:59:00 BST, Thomas Gleixner <tglx@linutronix.de> wrote:
>>On Wed, Oct 07 2020 at 08:48, David Woodhouse wrote:
>>> To fix *that* case, we really do need the whole series giving us per-
>>> domain restricted affinity, and to use it for those MSIs/IOAPICs that
>>> the IRQ remapping doesn't cover.
>>
>>Which do not exist today.
>
> Sure. But at patch 10/13 into this particular patch series, it *does*
> exist.

As I told you before: Your ordering is wrong. We do not introduce bugs
first and then fix them later ....

>>And all of this is completely wrong to begin with.
>>
>>The information has to property of the relevant irq domains and the
>>hierarchy allows you nicely to retrieve it from there instead of
>>sprinkling this all over the place.
>
> No. This is not a property of the parent domain per se. Especially if
> you're thinking that we could inherit the affinity mask from the
> parent, then twice no.
>
> This is a property of the MSI domain itself, and how many bits of
> destination ID the hardware at *this* level can interpret and pass on
> to the parent domain.

Errm what?

The MSI domain does not know anything about what the underlying domain
can handle and it shouldn't.

If MSI is on top of remapping then the remapping domain defines what the
MSI domain can do and not the other way round. Ditto for the non
remapped case in which the vector domain decides.

The top most MSI irq chip does not even have a compose function, neither
for the remap nor for the vector case. The composition is done by the
parent domain from the data which the parent domain constructed. Same
for the IO/APIC just less clearly separated.

The top most chip just takes what the underlying domain constructed and
writes it to the message store, because that's what the top most chip
controls. It does not control the content.

Thanks,

        tglx
