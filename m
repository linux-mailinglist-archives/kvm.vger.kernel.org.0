Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0594443F9B
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 10:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhKCJwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 05:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhKCJwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 05:52:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24DEC061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 02:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=ysI0zWoMdz65r767kMUX3KB+4Ck9LTj48gnvfaX60Xw=; b=SF66mCkm4ZIAxq5omN/XrmP0mn
        Fqc2tyKFBNx4ltYalag1cOEr/fjRCxgN5OjMWQ3PHXQ2XtSN4+KMutb86nt/S9SiQJqFlT+o2WrUd
        3QPATOxo1mLIl0KB0cNj3D3y1ogZnQZ5RvUECk4RzTlEOJO2wn5j/ATLIbTPZxsINcMpRLCg77NMW
        3ALDpB0tulKgnNfJgodSuk7RQeuMGWjA5znki7HQirLvXV8uNoBQR7vzPT72tFM4W9lGAL0GG9lLd
        Qa7lVb/XzFDt2cQHyHTBa3gAc3dadYUESCvvNFnk2Rq+vKmUbIip3Fm4TTnBuG66IeK2f2wlge+ly
        Z4bglzKg==;
Received: from [213.205.240.92] (helo=[127.0.0.1])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miCrk-0057K0-N9; Wed, 03 Nov 2021 09:48:25 +0000
Date:   Wed, 03 Nov 2021 09:47:05 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
CC:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2=5D_KVM=3A_x86=3A_Fix_recording?= =?US-ASCII?Q?_of_guest_steal_time_/_preempted_status?=
User-Agent: K-9 Mail for Android
In-Reply-To: <1f326c33-3acf-911a-d1ef-c72f0a570761@redhat.com>
References: <5d4002373c3ae614cb87b72ba5b7cdc161a0cd46.camel@infradead.org> <4369bbef7f0c2b239da419c917f9a9f2ca6a76f1.camel@infradead.org> <624bc910-1bec-e6dd-b09a-f86dc6cdbef0@redhat.com> <0372987a52b5f43963721b517664830e7e6f1818.camel@infradead.org> <1f326c33-3acf-911a-d1ef-c72f0a570761@redhat.com>
Message-ID: <E4C6E3D6-E789-4F0A-99F7-554A0F852873@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2 November 2021 17:19:34 GMT, Paolo Bonzini <pbonzini@redhat=2Ecom> wro=
te:
>On 02/11/21 18:11, David Woodhouse wrote:
>> On Tue, 2021-11-02 at 18:01 +0100, Paolo Bonzini wrote:
>>> On 02/11/21 17:38, David Woodhouse wrote:
>>>> This kind of makes a mockery of this
>>>> repeated map/unmap dance which I thought was supposed to avoid pinnin=
g
>>>> the page
>>>
>>> The map/unmap dance is supposed to catch the moment where you'd look a=
t
>>> a stale cache, by giving the non-atomic code a chance to update the
>>> gfn->pfn mapping=2E
>>>
>>=20
>> It might have *chance* to do so, but it doesn't actually do it=2E
>>=20
>> As noted, a GFN=E2=86=92PFN mapping is really a GFN=E2=86=92HVA=E2=86=
=92PFN mapping=2E And the
>> non-atomic code *does* update the GFN=E2=86=92HVA part of that, correct=
ly
>> looking at the memslots generation etc=2E=2E
>>=20
>> But it pays absolutely no attention to the *second* part, and assumes
>> that the HVA=E2=86=92PFN mapping in the userspace page tables will neve=
r
>> change=2E
>>=20
>> Which isn't necessarily true, even if the underlying physical page *is*
>> pinned to avoid most cases (ksm, swap, etc=2E) of the *kernel* changing
>> it=2E Userspace still can=2E
>
>Yes, I agree=2E  What I am saying is that:
>
>- the map/unmap dance is not (entirely) about whether to pin the page
>
>- the map/unmap API is not a bad API, just an incomplete implementation
>
>And I think the above comment confuses both points above=2E


Sorry, it took me a while to realise that by "above comment" you mean the =
original commit comment (which you want me to reword) instead of just what =
I'd said in my previous email=2E How about this version? If it's OK like th=
is then I can resubmit later today when I get back to a proper keyboard=2E


In commit b043138246a4 ("x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not=
 missed") we switched to using a gfn_to_pfn_cache for accessing the guest s=
teal time structure in order to allow for an atomic xchg of the preempted f=
ield=2E This has a couple of problems=2E

Firstly, kvm_map_gfn() doesn't work at all for IOMEM pages when the atomic=
 flag is set, which it is in kvm_steal_time_set_preempted()=2E So a guest v=
CPU using an IOMEM page for its steal time would never have its preempted f=
ield set=2E

Secondly, the gfn_to_pfn_cache is not invalidated in all cases where it sh=
ould have been=2E There are two stages to the GFN =E2=86=92 PFN conversion;=
 first the GFN is converted to a userspace HVA, and then that HVA is looked=
 up in the process page tables to find the underlying host PFN=2E Correct i=
nvalidation of the latter would require being hooked up to the MMU notifier=
s, but that doesn't happen =E2=80=94 so it just keeps mapping and unmapping=
 the *wrong* PFN after the userspace page tables change=2E

In the !IOMEM case at least the stale page *is* pinned all the time it's c=
ached, so it won't be freed and reused by anyone else while still receiving=
 the steal time updates=2E

To support Xen event channel delivery I will be fixing this up and using t=
he MMU notifiers to mark the mapping invalid at appropriate times =E2=80=94=
 giving us a way to use kvm_map_gfn() safely with an atomic fast path via t=
he kernel mapping, and a slow fallback path for when the mapping needs to b=
e refreshed=2E

But for steal time reporting there's no point in a kernel mapping of it an=
yway, when in all cases we care about, we have a perfectly serviceable (and=
 tautologically not stale) userspace HVA for it=2E We just need to implemen=
t the atomic xchg on the userspace address with appropriate exception handl=
ing, which is fairly trivial=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
