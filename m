Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC9B31A5D3
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 21:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhBLULZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 15:11:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229583AbhBLULZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 15:11:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613160598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5GXwLXYESMaXGOzygMbH9QS3KTjIu4FpiMfv3znr5WE=;
        b=DwFh8AlHwErbPLY6strmjPgoOu1OV634rZlNnf0zntUrMsyZnHWdu0R8AQ4Oh+cH0W1OCH
        dqNLC2X7rCOyuJQH5ROtJeqQCwRV+7uLGZgu7PIxJlStCQAMQsuCqterJk4wEhE0Qdldu7
        OgBq4xHyLWlONQlVK7tujUGS95EJqi0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-kXTngHZcM5C8x_UBmn8ELA-1; Fri, 12 Feb 2021 15:09:56 -0500
X-MC-Unique: kXTngHZcM5C8x_UBmn8ELA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDA53189DF56;
        Fri, 12 Feb 2021 20:09:54 +0000 (UTC)
Received: from gigantic.usersys.redhat.com (helium.bos.redhat.com [10.18.17.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5157A10016F4;
        Fri, 12 Feb 2021 20:09:54 +0000 (UTC)
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
        <jpgy2ft6sn5.fsf@linux.bootlegged.copy>
        <CALMp9eTC2YmG04WVVav-bgzq=6oZbu_5kd-6Dfog3SjkBJcHmg@mail.gmail.com>
Date:   Fri, 12 Feb 2021 15:09:53 -0500
In-Reply-To: <CALMp9eTC2YmG04WVVav-bgzq=6oZbu_5kd-6Dfog3SjkBJcHmg@mail.gmail.com>
        (Jim Mattson's message of "Fri, 12 Feb 2021 11:40:35 -0800")
Message-ID: <jpglfbtyrn2.fsf@linux.bootlegged.copy>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:
...
> On>> >> > I know I was the one to complain about the #GP, but...
>> >> >
>> >> > As a general rule, kvm cannot always guarantee a #UD for an
>> >> > instruction that is hidden from the guest. Consider, for example,
>> >> > popcnt, aesenc, vzeroall, movbe, addcx, clwb, ...
>> >> > I'm pretty sure that Paolo has brought this up in the past when I've
>> >> > made similar complaints.
>> >>
>> >> Ofcourse, even for vm instructions failures, the fixup table always jumps
>> >> to a ud2. I was just trying to address the concern because it is possible
>> >> to inject the correct exception via decoding the instruction.
>> >
>> > But kvm doesn't intercept #GP, except when enable_vmware_backdoor is
>> > set, does it? I don't think it's worth intercepting #GP just to get
>> > this #UD right.
>>
>> I prefer following the spec wherever we can.
>
> One has to wonder why userspace is even trying to execute a privileged
> instruction not enumerated by CPUID, unless it's just trying to expose
> virtualization inconsistencies. Perhaps this could be controlled by a
> new module parameter: "pedantic."
>
Yeah, fair point.

>> Otoh, if kvm can't guarantee injecting the right exception,
>> we should change kvm-unit-tests to just check for exceptions and not a specific
>> exception that adheres to the spec. This one's fine though, as long as we don't add
>> a CPL > 0 invpcid test, the other patch that was posted fixes it.
>
> KVM *can* guarantee the correct exception, but it requires
> intercepting all #GPs. That's probably not a big deal, but it is a
> non-zero cost. Is it the right tradeoff to make?

Not all, we intercept GPs only under a specific condition - just as we
do for vmware_backdoor and for the recent amd errata. IMO, I think it's the right
tradeoff to make to get guest exceptions right.

Bandan

