Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA03444207
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 13:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhKCNAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 09:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhKCNAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 09:00:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3F9C061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 05:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=TiHqioQIc7JPWfK8FMzGsS+PD3rtpchhP8b9k03Xp38=; b=tkOV5FMX9a/t/VOsCaA5jd8VS5
        EE3/Nv8h2/NwKgfR7vy4joP//TEvcRbxvak3FYZnmjqK5p5zMq24Qlk7rJC/IffTF797IcULt/8UI
        8Jtni18SUZd22qcMXYeSdayhIyV/PVaTFHWJ6Z7PMJ8ugu0bZG1gfC0R2wcanioSZ/mEHdOIdD6FT
        DsdvqGwMMoT0BDoKZxicvq3wiTcG3JPU5RUXw9xOI8IMP1E5751hpA3LDayDLmqcUEYhNSizGBfz1
        CJnGKM5GIj48D90xf+azsipehkAlA9H2PjjtIHDsPMkji5Ky+vuqpIkGJgmVT7u7qhxashvu3pU2t
        tTkhtbqw==;
Received: from [213.205.240.92] (helo=[127.0.0.1])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miFoO-005D0b-Jz; Wed, 03 Nov 2021 12:56:36 +0000
Date:   Wed, 03 Nov 2021 12:56:14 +0000
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
In-Reply-To: <e05809f3-46fa-8fdf-642d-66821465456e@redhat.com>
References: <5d4002373c3ae614cb87b72ba5b7cdc161a0cd46.camel@infradead.org> <4369bbef7f0c2b239da419c917f9a9f2ca6a76f1.camel@infradead.org> <624bc910-1bec-e6dd-b09a-f86dc6cdbef0@redhat.com> <0372987a52b5f43963721b517664830e7e6f1818.camel@infradead.org> <1f326c33-3acf-911a-d1ef-c72f0a570761@redhat.com> <E4C6E3D6-E789-4F0A-99F7-554A0F852873@infradead.org> <e05809f3-46fa-8fdf-642d-66821465456e@redhat.com>
Message-ID: <0FC7C414-418D-4EFC-93C3-BBB42176CB41@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3 November 2021 12:35:11 GMT, Paolo Bonzini <pbonzini@redhat=2Ecom> wro=
te:
>On 11/3/21 10:47, David Woodhouse wrote:
>> Sorry, it took me a while to realise that by "above comment" you mean
>> the original commit comment (which you want me to reword) instead of
>> just what I'd said in my previous email=2E How about this version? If
>> it's OK like this then I can resubmit later today when I get back to
>> a proper keyboard=2E
>
>No need to resubmit, thanks!  I'll review the code later and decide=20
>whether to include this in 5=2E16 or go for the "good" solution in 5=2E16=
=20
>and submit this one for 5=2E15 only=2E

I would call this the good solution for steal time=2E We really do always =
have a userspace HVA for that when it matters, and we should use it=2E

For Xen event channel delivery we have to do it from hardware interrupts u=
nder arbitrary current->mm and we need a kernel mapping, and we need the MM=
U notifiers and all that stuff=2E But for every mapping we do that way, we =
need extra checks in the MMU notifiers=2E

For steal time there's just no need=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
