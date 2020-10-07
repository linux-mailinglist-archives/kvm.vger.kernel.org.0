Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A586F28634C
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 18:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgJGQLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 12:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgJGQLe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 12:11:34 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678D3C061755;
        Wed,  7 Oct 2020 09:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=ZMdK3AHaeXJWIQjVp8QzT64GGu36CKZgTfpbzrWwLxY=; b=Uue6SlPblmjJZ3dyLwQtp+wvu4
        FlG8/wt3Nm8Ph3OeQ3/eOFT9td3gqSZZqOjd7y4sc8NXpsAf0OrEw7ngzsqmde3YtlbgXfzVQJ52b
        GRgUGkqhWlm/vmNwqXAOe28C1I8rtH8nnLPonMKmQ2Av64yoR9xGo+gjylkBEMKT6I9o0xDtr3Zxp
        RoY/SAOxE4Zno+fe1zpgJaEVcBPFvtxvqNzzIILIPJshK0+fXCU5u7h+dWFKie+ydqERQ+ylfKpLf
        jeq4y39aWWvylHgvUgkvd4DKnA1KEIs8wDHn+nOCTzGiRGIyTDFnYUjK4C81TjOnCi8Vm7TklVCdd
        n0AljzQg==;
Received: from [2001:8b0:10b:1:ad95:471b:fe64:9cc3]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQC2M-0005Ea-24; Wed, 07 Oct 2020 16:11:30 +0000
Date:   Wed, 07 Oct 2020 17:11:25 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <87a6wy3u6n.fsf@nanos.tec.linutronix.de>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org> <20201005152856.974112-1-dwmw2@infradead.org> <20201005152856.974112-7-dwmw2@infradead.org> <87lfgj59mp.fsf@nanos.tec.linutronix.de> <75d79c50d586c18f0b1509423ed673670fc76431.camel@infradead.org> <87tuv640nw.fsf@nanos.tec.linutronix.de> <336029ca32524147a61b6fa1eb734debc9d51a00.camel@infradead.org> <87a6wy3u6n.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 07/13] irqdomain: Add max_affinity argument to irq_domain_alloc_descs()
To:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
CC:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <7FA24FCF-E197-4502-BC89-0902E4053554@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7 October 2020 16:57:36 BST, Thomas Gleixner <tglx@linutronix=2Ede> wro=
te:
>On Wed, Oct 07 2020 at 15:10, David Woodhouse wrote:
>> On Wed, 2020-10-07 at 15:37 +0200, Thomas Gleixner wrote:
>>> What is preventing you to change the function signature? But handing
>>> down irqdomain here is not cutting it=2E The right thing to do is to
>>> replace 'struct irq_affinity_desc *affinity' with something more
>>> flexible=2E
>>
>> Yeah, although I do think I want to ditch this part completely, and
>> treat the "possible" mask for the domain very much more like we do
>> cpu_online_mask=2E In that we can allow affinities to be *requested*
>> which are outside it, and they can just never be *effective* while
>> those CPUs aren't present and reachable=2E
>
>Huch?
>
>> That way a lot of the nastiness about preparing an "acceptable" mask
>in
>> advance can go away=2E
>
>There is not lot's of nastiness=2E

OK, but I think we do have to cope with the fact that the limit is dynamic=
, and a CPU might be added which widens the mask=2E I think that's fundamen=
tal and not x86-specific=2E

>> It's *also* driven, as I noted, by the realisation that on x86, the
>> x86_non_ir_cpumask will only ever contain those CPUs which have been
>> brought online so far and meet the criteria=2E=2E=2E but won't that be =
true
>> on *any* system where CPU numbers are virtual and not 1:1 mapped with
>> whatever determines reachability by the IRQ domain? It isn't *such*
>an
>> x86ism, surely?
>
>Yes, but that's exactly the reason why I don't want to have whatever
>mask name you chose to be directly exposed and want it to be part of
>the
>irq domains because then you can express arbitrary per domain limits=2E

The x86_non_ir_mask isn't intended to be directly exposed to any generic I=
RQ code=2E

It's set up by the x86 APIC code so that those x86 IRQ domains which are a=
ffected by it, can set it with irqdomain_set_max_affinity() for the generic=
 code to see=2E Without each having to create the cpumask from scratch for =
themselves=2E

> =2E=2E=2E reading for once the kids are elsewhere=2E=2E=2E

Thanks=2E

>It's not rocket science to fix that as the irq remapping code already
>differentiates between the device types=2E

I don't actually like that very much=2E The IRQ remapping code could just =
compose the MSI messages that it desires without really having to care so m=
uch about the child device=2E The bit where IRQ remapping actually composes=
 IOAPIC RTEs makes me particularly sad=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
