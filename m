Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275B947C93D
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 23:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237963AbhLUWdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 17:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbhLUWdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 17:33:39 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DB2C061574;
        Tue, 21 Dec 2021 14:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=8pgfZaTJnzrnizB1YY+CYLohEglHXA/iYzzrcnBAi9o=; b=ZEIOdNUP4K8puga+Q1dIKZ1JJE
        qXsDCjeKmQHehSP5X0QcGV5zHPYxmy/jJxGLyHJ7o5aN0w+ZaR+n5bYx+aUikZXG5Gh7mCPvkz7dT
        edzAzSXtQ4GaHEn71vjb7UpnVH50RSjZfCjkrP1aNw/0rXLlehUpAKB4xu3v1+EjWQMopBLEblYMv
        Y45THVzPG/fV2wqBxVY4v+4q1THNPY94BZxJXrsMypauXWaHHdN9ccMp6BwbCI3+TkiHcApr/mIRm
        oamnOjuIpBJ1AFoK056HEygnjO4TMFp3E1Mx7gwt4/MbGo5hvZ2e1tOI/XTE5FWjb0trrohNfGdyR
        uMsFqmOw==;
Received: from [2001:8b0:10b:1:f126:48a8:ed41:1898] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mzngu-002o1y-6F; Tue, 21 Dec 2021 22:33:04 +0000
Date:   Tue, 21 Dec 2021 22:33:04 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Igor Mammedov <imammedo@redhat.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
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
In-Reply-To: <7b079111-3185-e345-acc4-40e72fdd6e92@amd.com>
References: <20211215145633.5238-1-dwmw2@infradead.org> <761c1552-0ca0-403b-3461-8426198180d0@amd.com> <ca0751c864570015ffe4d8cccdc94e0a5ef3086d.camel@infradead.org> <b13eac6c-ea87-aef9-437f-7266be2e2031@amd.com> <721484e0fa719e99f9b8f13e67de05033dd7cc86.camel@infradead.org> <20211217110906.5c38fe7b@redhat.com> <d4cde50b4aab24612823714dfcbe69bc4bb63b60.camel@infradead.org> <36cc857b-7331-8305-ee25-55f6ba733ca6@amd.com> <c1726334d337de7d7a8361be27218b44784887f6.camel@infradead.org> <02be2ef0-8a18-553f-2bd7-1754c3f53477@amd.com> <7b079111-3185-e345-acc4-40e72fdd6e92@amd.com>
Message-ID: <F1CDE4F0-06DB-414E-AA53-415D35D6D87C@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21 December 2021 22:25:35 GMT, Tom Lendacky <thomas=2Elendacky@amd=2Eco=
m> wrote:
>On 12/20/21 3:47 PM, Tom Lendacky wrote:
>> On 12/20/21 3:29 PM, David Woodhouse wrote:
>>> On Mon, 2021-12-20 at 12:54 -0600, Tom Lendacky wrote:
>>>> Took the tree back to commit df9726cb7178 and then applied this chang=
e=2E
>>>> I'm unable to trigger any kind of failure with this change=2E
>>>
>>> Hm=2E=2E=2E I fired up an EC2 m6a=2E48xlarge instance (192 CPUs) to pl=
ay with=2E
>>>
>>> I can reproduce your triple-fault on SMP bringup, but only with kexec=
=2E
>>> And I basically can't get *anything* to kexec without that triple-
>>> fault=2E Not a clean 5=2E16-rc2, not the Fedora stock 5=2E14=2E10 kern=
el=2E
>>>
>>> If I *boot* instead of kexec, I have not yet seen the problem at all=
=2E
>>> This is using Legacy BIOS not UEFI=2E
>>=20
>> Let me try with a legacy BIOS and see if I can repro=2E Might not be un=
til=20
>> tomorrow, though, since I had to let someone borrow the machine=2E
>
>I still encounter the issue using a legacy BIOS (SeaBIOS)=2E

I haven't had much time to play but have seen it with a stock kernel at le=
ast as far back as v5=2E0=2E They all triple-fault on bringing up secondary=
 CPUs, on kexec=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
