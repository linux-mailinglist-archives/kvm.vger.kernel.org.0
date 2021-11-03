Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FDB444268
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 14:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhKCNbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 09:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbhKCNbY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 09:31:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE84EC061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 06:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=BnodT9g3b50SryFWSJ/nr4k5SEKyg6jhj+yB/s0NiZM=; b=gYL7CuxM+YcTMaHZow++MtE6MZ
        Utk/KtmzU664DI+vfkp+x/6rADs63QISxyGDdyf4mqxdf67nZtea1sBnBiXWrlZR3abE5xEK/Z5Fd
        KOWZpiITStIhkmdJr/fqBwpbQl/00wmjsxISBWbisdzuVVK1uB3X9LL5IEx2b72fWr7NopFYW4Bqs
        MomYgMLdRoR3vWm5zoQFy+TIkNy7SkzZ7+RR84ZkmvFUdBXhjpj7loEmQNpm4NBURbbE8+DNttRek
        vskRMfFdETQCKbGUHk3MeNS06o37fO1rGFikQWCgJ4Aew2/Q5TtU75byvrKbFRaH/NzgCgk6/rw5Z
        EfE2sEkg==;
Received: from [213.205.240.92] (helo=[127.0.0.1])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miGEu-005Dkn-7U; Wed, 03 Nov 2021 13:27:21 +0000
Date:   Wed, 03 Nov 2021 13:23:07 +0000
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
In-Reply-To: <69495972-c3b8-cad2-40d9-5044d2837043@redhat.com>
References: <5d4002373c3ae614cb87b72ba5b7cdc161a0cd46.camel@infradead.org> <4369bbef7f0c2b239da419c917f9a9f2ca6a76f1.camel@infradead.org> <624bc910-1bec-e6dd-b09a-f86dc6cdbef0@redhat.com> <0372987a52b5f43963721b517664830e7e6f1818.camel@infradead.org> <1f326c33-3acf-911a-d1ef-c72f0a570761@redhat.com> <E4C6E3D6-E789-4F0A-99F7-554A0F852873@infradead.org> <e05809f3-46fa-8fdf-642d-66821465456e@redhat.com> <0FC7C414-418D-4EFC-93C3-BBB42176CB41@infradead.org> <69495972-c3b8-cad2-40d9-5044d2837043@redhat.com>
Message-ID: <6CE46819-C089-49B0-A2F5-1C04EEDA8CBB@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3 November 2021 13:05:11 GMT, Paolo Bonzini <pbonzini@redhat=2Ecom> wro=
te:
>On 11/3/21 13:56, David Woodhouse wrote:
>>> No need to resubmit, thanks!  I'll review the code later and
>>> decide whether to include this in 5=2E16 or go for the "good"
>>> solution in 5=2E16 and submit this one for 5=2E15 only=2E
>> I would call this the good solution for steal time=2E We really do
>> always have a userspace HVA for that when it matters, and we should
>> use it=2E
>>=20
>> For Xen event channel delivery we have to do it from hardware
>> interrupts under arbitrary current->mm and we need a kernel mapping,
>> and we need the MMU notifiers and all that stuff=2E But for every
>> mapping we do that way, we need extra checks in the MMU notifiers=2E
>>=20
>> For steal time there's just no need=2E
>
>Yes, but doing things by hand that it is slightly harder to get right,=20
>between the asm and the manual user_access_{begin,end}=2E

Yes=2E Before I embarked on this I did have a fantasy that I could just us=
e the futex asm helpers which already do much of that, but it didn't turn o=
ut that way=2E But once that part is done it shouldn't need to be touched a=
gain=2E It's only for the *locked* accesses like bit set and xchg; for anyt=
hing else the normal user access works=2E

>The good solution would be to handle the remapping of _all_ gfn-to-pfn=20
>caches from the MMU notifiers, so that you can still do map/unmap, keep=
=20
>the code simple, and get for free the KVM-specific details such as=20
>marking the gfn as dirty=2E
>
>When I was working on it before, I got stuck with wanting to do it not=20
>just good but perfect, including the eVMCS page in it=2E  But that makes=
=20
>no sense because really all that needs to be fixed is the _current_=20
>users of the gfn-to-pfn cache=2E

Yeah=2E Well, let's take a look at the Xen evtchn stuff and heckle the new=
 rwlock I used, and the way we have to hold that lock *while* doing the acc=
ess=2E Then we can ponder whether we want to offer that as a "generic" thin=
g for providing a kernel mapping, and have the MMU notifiers walk a list of=
 them to check for invalidation=2E Or whether we can actually use an HVA af=
ter all (and in at least some cases we really can)=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
