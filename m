Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A5828539F
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 23:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgJFVHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 17:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727176AbgJFVHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 17:07:35 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0705AC061755;
        Tue,  6 Oct 2020 14:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=raBJSUw2Pij7PT/rmhEwVTTdaxcjc+zHVTOGifxTEq0=; b=gyjSY0FpzhPBu92z/xXp6in+HW
        CNRn7wm1Ue5GnjypviGr/n6WwXPtKA3mLrAhl629I0lDHj1gOQmdh7AnTFiM4uyVr8g+zBAobtiw1
        oMNcsgyuAAnLIN1FJpsr5D55fQc+neHiaDLDlOQ6B61p8AG5Lu2/5XVNcgFR9yR38ISnSR2NX9iV2
        A0Bk+bwYFEWaZOe+2W2ZGokjAqbVYgTscw8RfHWrWTLpV+1Tc5VNC12DC0GGKPYh5u1sZ+3Ir9I+X
        WaA9qVsjoNSA713IFdYBe01Qli0aJShZkySZFpr/eB1fNxyW/hRM5E/aJpQ3G16bttEqpKW+0cPe/
        hbi0nacA==;
Received: from [2001:8b0:10b:1:ad95:471b:fe64:9cc3]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPuBF-0003ga-DY; Tue, 06 Oct 2020 21:07:29 +0000
Date:   Tue, 06 Oct 2020 22:07:26 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <87r1qb5ash.fsf@nanos.tec.linutronix.de>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org> <20201005152856.974112-1-dwmw2@infradead.org> <20201005152856.974112-5-dwmw2@infradead.org> <87r1qb5ash.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 05/13] genirq: Prepare for default affinity to be passed to __irq_alloc_descs()
To:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
CC:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <BC75F5DC-BA63-46D6-B273-E30EEAA3D989@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6 October 2020 22:01:18 BST, Thomas Gleixner <tglx@linutronix=2Ede> wro=
te:
>On Mon, Oct 05 2020 at 16:28, David Woodhouse wrote:
>> =20
>>  #else /* CONFIG_SMP */
>> =20
>> +#define irq_default_affinity (NULL)
>
>=2E=2E=2E
>
>>  static int alloc_descs(unsigned int start, unsigned int cnt, int
>node,
>>  		       const struct irq_affinity_desc *affinity,
>> +		       const struct cpumask *default_affinity,
>>  		       struct module *owner)
>>  {
>>  	struct irq_desc *desc;
>>  	int i;
>> =20
>>  	/* Validate affinity mask(s) */
>> +	if (!default_affinity || cpumask_empty(default_affinity))
>> +		return -EINVAL;
>
>How is that supposed to work on UP?

Hm, good point=2E

>Aside of that I really hate to have yet another argument just
>because=2E

Yeah, I was trying to avoid having to allocate a whole array of irq_affini=
ty_desc just to fill them all in with the same default=2E

But perhaps I need to treat the "affinity_max" like we do cpu_online_mask,=
 and allow affinity to be set even to offline/unreachable CPUs at this poin=
t=2E Then we can be more relaxed about the default affinities=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
