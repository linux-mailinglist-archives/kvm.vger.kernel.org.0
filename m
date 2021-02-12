Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D40231A4A1
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 19:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhBLShQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 13:37:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229451AbhBLShQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 13:37:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613154948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7uto97gAJDU7+KNd/QZ5N1GjaFQsdkozBlUoctAZ6SY=;
        b=d/rd75FqjPpOMLxEluSQEle+j/B5T2udOGONTGLv9F6Iy6Ft8s6o/kYqKTawSJA8bd1Bia
        xG0L0uRobWLixP1SN7R4gDDvSMKgbe13TK5hV5GL99eZVg7XAymttfKoOzVHvSHsJ+1lNC
        3GQ8WIlbIarY3fnsIn1pNlPqXtVcxLQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-TArSyaORNSq0oUnZUrct2g-1; Fri, 12 Feb 2021 13:35:44 -0500
X-MC-Unique: TArSyaORNSq0oUnZUrct2g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E813100CCC0;
        Fri, 12 Feb 2021 18:35:43 +0000 (UTC)
Received: from gigantic.usersys.redhat.com (helium.bos.redhat.com [10.18.17.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DA5E25DEFB;
        Fri, 12 Feb 2021 18:35:42 +0000 (UTC)
From:   Bandan Das <bsd@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Huang2\, Wei" <wei.huang2@amd.com>,
        "Moger\, Babu" <babu.moger@amd.com>
Subject: Re: [PATCH 0/3] AMD invpcid exception fix
References: <20210211212241.3958897-1-bsd@redhat.com>
        <ac52c9b9-1561-21cd-6c8c-dad21e9356c6@redhat.com>
        <jpgo8gpbath.fsf@linux.bootlegged.copy>
        <CALMp9eQ370MQ1ZPtby4ezodCga9wDeXXGTcrqoXjj03WPJOEhQ@mail.gmail.com>
        <jpg35y1f9x8.fsf@linux.bootlegged.copy>
        <CALMp9eSk1Ar0UB0udM050sZpGaG_OGL3kOs4LbQ+bigUr_s8CA@mail.gmail.com>
Date:   Fri, 12 Feb 2021 13:35:42 -0500
In-Reply-To: <CALMp9eSk1Ar0UB0udM050sZpGaG_OGL3kOs4LbQ+bigUr_s8CA@mail.gmail.com>
        (Jim Mattson's message of "Fri, 12 Feb 2021 10:20:52 -0800")
Message-ID: <jpgy2ft6sn5.fsf@linux.bootlegged.copy>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Fri, Feb 12, 2021 at 9:55 AM Bandan Das <bsd@redhat.com> wrote:
>>
>> Jim Mattson <jmattson@google.com> writes:
>>
>> > On Fri, Feb 12, 2021 at 6:49 AM Bandan Das <bsd@redhat.com> wrote:
>> >>
>> >> Paolo Bonzini <pbonzini@redhat.com> writes:
>> >>
>> >> > On 11/02/21 22:22, Bandan Das wrote:
>> >> >> The pcid-disabled test from kvm-unit-tests fails on a Milan host because the
>> >> >> processor injects a #GP while the test expects #UD. While setting the intercept
>> >> >> when the guest has it disabled seemed like the obvious thing to do, Babu Moger (AMD)
>> >> >> pointed me to an earlier discussion here - https://lkml.org/lkml/2020/6/11/949
>> >> >>
>> >> >> Jim points out there that  #GP has precedence over the intercept bit when invpcid is
>> >> >> called with CPL > 0 and so even if we intercept invpcid, the guest would end up with getting
>> >> >> and "incorrect" exception. To inject the right exception, I created an entry for the instruction
>> >> >> in the emulator to decode it successfully and then inject a UD instead of a GP when
>> >> >> the guest has it disabled.
>> >> >>
>> >> >> Bandan Das (3):
>> >> >>    KVM: Add a stub for invpcid in the emulator table
>> >> >>    KVM: SVM: Handle invpcid during gp interception
>> >> >>    KVM: SVM:  check if we need to track GP intercept for invpcid
>> >> >>
>> >> >>   arch/x86/kvm/emulate.c |  3 ++-
>> >> >>   arch/x86/kvm/svm/svm.c | 22 +++++++++++++++++++++-
>> >> >>   2 files changed, 23 insertions(+), 2 deletions(-)
>> >> >>
>> >> >
>> >> > Isn't this the same thing that "[PATCH 1/3] KVM: SVM: Intercept
>> >> > INVPCID when it's disabled to inject #UD" also does?
>> >> >
>> >> Yeah, Babu pointed me to Sean's series after I posted mine.
>> >> 1/3 indeed will fix the kvm-unit-test failure. IIUC, It doesn't look like it
>> >> handles the case for the guest executing invpcid at CPL > 0 when it's
>> >> disabled for the guest - #GP takes precedence over intercepts and will
>> >> be incorrectly injected instead of an #UD.
>> >
>> > I know I was the one to complain about the #GP, but...
>> >
>> > As a general rule, kvm cannot always guarantee a #UD for an
>> > instruction that is hidden from the guest. Consider, for example,
>> > popcnt, aesenc, vzeroall, movbe, addcx, clwb, ...
>> > I'm pretty sure that Paolo has brought this up in the past when I've
>> > made similar complaints.
>>
>> Ofcourse, even for vm instructions failures, the fixup table always jumps
>> to a ud2. I was just trying to address the concern because it is possible
>> to inject the correct exception via decoding the instruction.
>
> But kvm doesn't intercept #GP, except when enable_vmware_backdoor is
> set, does it? I don't think it's worth intercepting #GP just to get
> this #UD right.

I prefer following the spec wherever we can.
Otoh, if kvm can't guarantee injecting the right exception,
we should change kvm-unit-tests to just check for exceptions and not a specific
exception that adheres to the spec. This one's fine though, as long as we don't add
a CPL > 0 invpcid test, the other patch that was posted fixes it.

Bandan

