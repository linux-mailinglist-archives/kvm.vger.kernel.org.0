Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0F4477CEE
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 21:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241171AbhLPUAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 15:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241161AbhLPUAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 15:00:39 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B50C061574;
        Thu, 16 Dec 2021 12:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=/tbyhrSETlpUpGhD0V4CZpJ4NJ4ekYWEeecjiaVic+s=; b=enk5B+yDYYwupFnXkTU84KPAfb
        4gvcArFFggB2771NVqEjSCiPVRrXfDRDz1bFaWfq9aTWN4NVhF9fAnwoz7uIkp3ManZjYUXTMf7DC
        twHoaMU2QxDcJN5NsZhrpL5E0dAryCRk0PIf8YeQDnIU7rhLdWNU4/zAUI2jEZWEdSE+FFkqer3zz
        XvkeDipWFHX+Glgyo4gbVKr5twjYJLxEuUHq78W/mP2RINEBuftmVKGQ0mS2EUT/j3aoc4iAON8a8
        lEK+epfx9qCDpY+fW0n9uDwXHQ/uv5R7qi7G/cXBB9aZhIXH50H2twXHcyC9uIfMPpUZsaE+gkeOK
        48b5onFQ==;
Received: from [2001:8b0:10b:1:f126:48a8:ed41:1898] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxwv0-001kAx-Vl; Thu, 16 Dec 2021 19:59:59 +0000
Date:   Thu, 16 Dec 2021 19:59:57 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "luolongjun@huawei.com" <luolongjun@huawei.com>,
        "hejingxian@huawei.com" <hejingxian@huawei.com>
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
User-Agent: K-9 Mail for Android
In-Reply-To: <0247ce40-1f1e-3581-95a2-8a1d51cb8fad@amd.com>
References: <20211215145633.5238-1-dwmw2@infradead.org> <761c1552-0ca0-403b-3461-8426198180d0@amd.com> <f0b4eddc2cdb3aae190bacd0a5285c393e4f8ea3.camel@infradead.org> <0247ce40-1f1e-3581-95a2-8a1d51cb8fad@amd.com>
Message-ID: <E92CDF5A-229A-4D57-8C38-2E89373A37AD@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16 December 2021 19:55:36 GMT, Tom Lendacky <thomas=2Elendacky@amd=2Eco=
m> wrote:
>On 12/16/21 1:52 PM, David Woodhouse wrote:
>> On Thu, 2021-12-16 at 10:27 -0600, Tom Lendacky wrote:
>>> On 12/15/21 8:56 AM, David Woodhouse wrote:
>>>
>>>> Doing the INIT/SIPI/SIPI in parallel for all APs and *then* waiting f=
or
>>>> them shaves about 80% off the AP bringup time on a 96-thread socket
>>>> Skylake box (EC2 c5=2Emetal) =E2=80=94 from about 500ms to 100ms=2E
>>>>
>>>> There are more wins to be had with further parallelisation, but this =
is
>>>> the simple part=2E
>>>
>>> I applied this series and began booting a regular non-SEV guest and hi=
t a
>>> failure at 39 vCPUs=2E No panic or warning, just a reset and OVMF was
>>> executing again=2E I'll try to debug what's going, but not sure how qu=
ickly
>>> I'll arrive at anything=2E
>>=20
>> I've pushed the SEV-ES fix to
>> https://git=2Einfradead=2Eorg/users/dwmw2/linux=2Egit/shortlog/refs/hea=
ds/parallel-5=2E16
>> and in doing so I've moved the 'no_parallel_bringup' command line
>> argument earlier in the series, to Thomas's "Support parallel startup
>> of secondary CPUs" commit (now 191f0899757)=2E It would be interesting =
to
>> see if you can reproduce with just that much, both with and with
>> no_parallel_bringup=2E And then whether the subsequent commit that
>> actually enables the parallel INIT/SIPI/SIPI actually makes the
>> difference?
>>=20
>
>I'll pull it down and give it try=2E

Thanks=2E Note: don't use the whole thing; that last "parallel part2" patc=
h in particular isn't ready=2E And probably isn't where the next low-hangin=
g fruit is anyway=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
