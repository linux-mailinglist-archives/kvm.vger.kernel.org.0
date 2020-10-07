Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF34286367
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 18:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgJGQPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 12:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbgJGQPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 12:15:54 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840F5C061755;
        Wed,  7 Oct 2020 09:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=Q6S7G7tGIHEqMVdJUjNSVW5hIw+z7ajO0YGWhkaXjSI=; b=i3r5Nrb74EDsnzTQBZt426eZe6
        lhKaUTzwFykgLMHJIO9OgQlL4q1LwPDiWCtoZkxbt+rOyshpP0Sd2sFad9uGV0Za1Qr7L/9U6jKE2
        sr6l2Fi4NRgzf++ci9sF7M8RzzIzflkeKGEODWBKiWe1qJWU53ZP3e2rTYxAbmDhIQ6NINBfu0qmx
        9pX3HbVZQgxWh9kpWoyD60hm8ze4PSznFcKIB8mPZpEmKNNFw+jIEyjS7TTKAuIuIfVRrBmV1CxUO
        rNkSnSsEyKmpx7F3DACHLp42gF+HxNWNHGhPtZOw/t9UTC4ifHPMq+VNmtjm3lkO+26b037kcV+7U
        pIE+/r6w==;
Received: from [2001:8b0:10b:1:ad95:471b:fe64:9cc3]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQC6Y-0005hC-Mm; Wed, 07 Oct 2020 16:15:50 +0000
Date:   Wed, 07 Oct 2020 17:15:48 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <877ds23txo.fsf@nanos.tec.linutronix.de>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org> <20201005152856.974112-1-dwmw2@infradead.org> <20201005152856.974112-10-dwmw2@infradead.org> <87d01v58bw.fsf@nanos.tec.linutronix.de> <d34efce9ca5a4a9d8d8609f872143e306bf5ee98.camel@infradead.org> <874kn65h0r.fsf@nanos.tec.linutronix.de> <F9476D19-3D08-4CE6-A535-6C1D2E9BA88D@infradead.org> <87imbm3zdq.fsf@nanos.tec.linutronix.de> <1b1fda3079627748e1f5084ddae8a686258c78d9.camel@infradead.org> <877ds23txo.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 10/13] x86/irq: Limit IOAPIC and MSI domains' affinity without IR
To:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
CC:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <244EB899-6273-416C-8376-68FBCE0DA47A@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7 October 2020 17:02:59 BST, Thomas Gleixner <tglx@linutronix=2Ede> wro=
te:
>On Wed, Oct 07 2020 at 15:23, David Woodhouse wrote:
>> On Wed, 2020-10-07 at 16:05 +0200, Thomas Gleixner wrote:
>>> On Wed, Oct 07 2020 at 14:08, David Woodhouse wrote:
>>> > On 7 October 2020 13:59:00 BST, Thomas Gleixner
><tglx@linutronix=2Ede> wrote:
>>> > > On Wed, Oct 07 2020 at 08:48, David Woodhouse wrote:
>>> > > > To fix *that* case, we really do need the whole series giving
>us per-
>>> > > > domain restricted affinity, and to use it for those
>MSIs/IOAPICs that
>>> > > > the IRQ remapping doesn't cover=2E
>>> > >=20
>>> > > Which do not exist today=2E
>>> >=20
>>> > Sure=2E But at patch 10/13 into this particular patch series, it
>*does*
>>> > exist=2E
>>>=20
>>> As I told you before: Your ordering is wrong=2E We do not introduce
>bugs
>>> first and then fix them later =2E=2E=2E=2E
>>
>> I didn't introduce that bug; it's been there for years=2E Fixing it
>> properly requires per-irqdomain affinity limits=2E
>>
>> There's a cute little TODO at least in the Intel irq-remapping
>driver,
>> noting that we should probably check if there are any IOAPICs that
>> aren't in the scope of any DRHD at all=2E But that's all=2E
>
>So someone forgot to remove the cute little TODO when this was added:
>
>       if (parse_ioapics_under_ir()) {
>                pr_info("Not enabling interrupt remapping\n");
>                goto error;
>        }

And HPET, and PCI devices including those that might be hotplugged in futu=
re and not be covered by any extant IOMMU's scope?

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
