Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8AF296C83
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 12:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461929AbgJWKKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 06:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S461865AbgJWKKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 06:10:48 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4926BC0613CE;
        Fri, 23 Oct 2020 03:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=jXQnc7Q33alBw5s5WLWKGYdqKsDW1KG+Q/3M71QxBdI=; b=uqI3gMVHxYqEhYiFk20HpC0ulk
        5pp39b//mVScB2AHwEKx2ff1S7I/ml2Sd0HCXLiP49xnQXhi191xTawF13hrJKNSzoyhfL/CIMR6I
        w6GoSq8vF0eAt6nETjr3O0sN0FolBYB0sJrJzVdvuASdtjpFk1FZR2+4FIpSGTBtgxQswGXncOlHq
        q9P5hCEikbyEBSq7fB9hUZrd2Iv/TYYOuGFXDbxFtVojF8eOKMv5L2oIIymSsYWMQrQ5dHXp/wxld
        VKOmPzgCgDQCpGOFKj4Rcu3FbGKgyG+R75E8XgbinDoaMZEwb4HBfc62yKYh1FvH/ddRtvlWMMXZe
        QDuGUcbw==;
Received: from [2a01:4c8:1094:6472:254e:1156:1596:d8f5]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kVu1z-0001DG-KG; Fri, 23 Oct 2020 10:10:44 +0000
Date:   Fri, 23 Oct 2020 11:10:39 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <87y2jy542v.fsf@nanos.tec.linutronix.de>
References: <87y2jy542v.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 8/8] x86/ioapic: Generate RTE directly from parent irqchip's MSI message
To:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
CC:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <C53CAD52-38F8-47D7-A5BE-4F470532EF20@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22 October 2020 22:43:52 BST, Thomas Gleixner <tglx@linutronix=2Ede> wr=
ote:
>On Fri, Oct 09 2020 at 11:46, David Woodhouse wrote:
>
>@@ -45,12 +45,11 @@ enum irq_alloc_type {
> };
>
>> +static void mp_swizzle_msi_dest_bits(struct irq_data *irq_data, void
>*_entry)
>> +{
>> +	struct msi_msg msg;
>> +	u32 *entry =3D _entry;
>
>Why is this a void * argument and then converting it to a u32 *? Just
>to
>make that function completely unreadable?

It makes the callers slightly more readable, not having to cast to uint32_=
t* from the struct=2E

I did ponder defining a new struct with bitfields named along the lines of=
 'msi_addr_bits_19_to_4', but that seemed like overkill=2E

>> +
>> +	irq_chip_compose_msi_msg(irq_data, &msg);
>
>Lacks a comment=2E Also mp_swizzle=2E=2E=2E is a misnomer as this invokes=
 the
>msi compose function which is not what the function name suggests=2E

It's got a four-line comment right there after it as we use the bits we go=
t from it=2E

>> +	/*
>> +	 * They're in a bit of a random order for historical reasons, but
>> +	 * the IO/APIC is just a device for turning interrupt lines into
>> +	 * MSIs, and various bits of the MSI addr/data are just swizzled
>> +	 * into/from the bits of Redirection Table Entry=2E
>> +	 */
>> +	entry[0] &=3D 0xfffff000;
>> +	entry[0] |=3D (msg=2Edata & (MSI_DATA_DELIVERY_MODE_MASK |
>> +				 MSI_DATA_VECTOR_MASK));
>> +	entry[0] |=3D (msg=2Eaddress_lo & MSI_ADDR_DEST_MODE_MASK) << 9;
>> +
>> +	entry[1] &=3D 0xffff;
>> +	entry[1] |=3D (msg=2Eaddress_lo & MSI_ADDR_DEST_ID_MASK) << 12;
>
>Sorry, but this is unreviewable gunk=2E

Crap=2E Sure, want to look at the I/OAPIC and MSI documentation and observ=
e that it's just shifting bits around and "these bits go there, those bits =
go here=2E=2E=2E" but there's no magic which will make that go away=2E At s=
ome point you end up swizzling bits around with seemingly random bitmasks a=
nd shifts which you have to have worked out from the docs=2E

Now that I killed off the various IOMMU bits which also horrifically touch=
 the RTE directly, perhaps there is more scope for faffing around with it d=
ifferently, but it won't really change much=2E It's just urinating into the=
 atmospheric disturbance=2E


>Aside of that it works magically because polarity,trigger and mask bit
>have been set up before=2E But of course a comment about this is
>completely overrated=2E

Well yes, there's a lot about the I/OAPIC code which is a bit horrid but t=
his patch is doing just one thing: making the bits get from e=2Eg=2E cfg->d=
est_apicid and cfg->vector into the RTE in a generic fashion which does the=
 right thing for IR too=2E Other cleanups are somewhat orthogonal, but yes =
it's a good spot that one of these was somewhat redundant in the first plac=
e=2E We could fix that up in a separate patch which comes first perhaps=2E

If we're starting to clean up I/OAPIC code I'd like to take a long hard lo=
ok at the level ack code paths, and the fact that we have separate ack_apic=
_irq and apic_ack_irq functions (or something like that; on phone now) whic=
h do different things=2E Perhaps the order (or the capitals on APIC which o=
ne of them has) makes it sane and meaningful for them both to exist and do =
different things?

I also note the Hyper-V "remapping" takes the IR code path and I'm not sur=
e that's OK=2E Because of the complete lack of overall documentation on wha=
t it's all doing and why=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
