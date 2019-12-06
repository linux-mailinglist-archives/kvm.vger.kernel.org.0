Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC78115146
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 14:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbfLFNqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 08:46:22 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60263 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726214AbfLFNqW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 08:46:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575639980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qpHMOILt3RkAaNqO5K2mdVIzD7Iatw6c4ZBZ4fsNXEY=;
        b=Y2w0vR7bYLkIMpKl+hF31DJhTjZ9EAB75yQyqIuSU6ayuT3t4EBMiDkRlvBhyofdKIZP0r
        3TR9WJgP+eQSmLs0BMFDSb47by4SdAlMwNWZdzzFER7zN1wG5AYkGEF0Ma0bMl9Hmh9ErE
        8SfJ55OqI6AjnFZaoos9AIEEvrdg4V0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-jYqfE6OHNCSWhVmorVkUOg-1; Fri, 06 Dec 2019 08:46:19 -0500
Received: by mail-wr1-f70.google.com with SMTP id l20so3176776wrc.13
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 05:46:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Wr23wh9KLmpox8MIPwacIKt6mWxF/GlqyYX4lU3W6jY=;
        b=IBpDkJXcQhcDrOX1Dnd5+ly/WakPI0Z0ni01iZGjc2uLVvAp763l79LhCw1267TDWv
         VwjgZh4xYDFUlBSgpWl9wYzazCXTgdx7nSSBrvzLjUZPbkbdz4W+dCznm7Vb9alELXL8
         SVT28bOiusLPEiE3/EuQShR9dtdSCv2axAVAcpV5neN2dFrWLeCLC2zcBb0j6xvLE3Jp
         gOZ/s0Th7gCO+BCC2WosushOEjxpKHLZt9TanICFdHRaYrPKhBI/Wiu7HfJoyeK54gwD
         /6mTiwzu/x/kwFHNmtC9U9lhKJPH32nzKt2gdUbxqxHeWkvdcY4J7XA2nvxhL6zIz4ep
         MI5Q==
X-Gm-Message-State: APjAAAULwVC2y2w5SXEn69NIplOQhPlgyYT3IlDImFabFfpsRF5GTAO9
        RfI1I47V2fBclK9I43wk0tFoiiWVRZMIRr8pcbE+NfbwIuky1IOa32T4Wu/NdupRBnZA8AmxfpT
        HwvlrgVhPGWy8
X-Received: by 2002:adf:ea42:: with SMTP id j2mr15934500wrn.270.1575639977967;
        Fri, 06 Dec 2019 05:46:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqyrTUteZL7RdDo6X3Ze7f/ehJSNermmAl92liSZiDqm5CCM1r7dVbQS/5oMz5BvREVzXxDs6w==
X-Received: by 2002:adf:ea42:: with SMTP id j2mr15934485wrn.270.1575639977680;
        Fri, 06 Dec 2019 05:46:17 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 2sm16855055wrq.31.2019.12.06.05.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 05:46:16 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Ankur Arora <ankur.a.arora@oracle.com>
Cc:     x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is trustworthy
In-Reply-To: <4f835a11-1528-a04e-9e06-1b8cdb97a04d@oracle.com>
References: <20191105161737.21395-1-vkuznets@redhat.com> <de3cade3-c069-dc6b-1d2d-aa10abe365b8@redhat.com> <4f835a11-1528-a04e-9e06-1b8cdb97a04d@oracle.com>
Date:   Fri, 06 Dec 2019 14:46:16 +0100
Message-ID: <87wob9d0t3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: jYqfE6OHNCSWhVmorVkUOg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ankur Arora <ankur.a.arora@oracle.com> writes:

> On 2019-11-05 3:56 p.m., Paolo Bonzini wrote:
>> On 05/11/19 17:17, Vitaly Kuznetsov wrote:
>>> There is also one additional piece of the information missing. A VM can=
 be
>>> sharing physical cores with other VMs (or other userspace tasks on the
>>> host) so does KVM_FEATURE_TRUSTWORTHY_SMT imply that it's not the case =
or
>>> not? It is unclear if this changes anything and can probably be left ou=
t
>>> of scope (just don't do that).
>>>
>>> Similar to the already existent 'NoNonArchitecturalCoreSharing' Hyper-V
>>> enlightenment, the default value of KVM_HINTS_TRUSTWORTHY_SMT is set to
>>> !cpu_smt_possible(). KVM userspace is thus supposed to pass it to guest=
's
>>> CPUIDs in case it is '1' (meaning no SMT on the host at all) or do some
>>> extra work (like CPU pinning and exposing the correct topology) before
>>> passing '1' to the guest.
>>>
>>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>> ---
>>>   Documentation/virt/kvm/cpuid.rst     | 27 +++++++++++++++++++--------
>>>   arch/x86/include/uapi/asm/kvm_para.h |  2 ++
>>>   arch/x86/kvm/cpuid.c                 |  7 ++++++-
>>>   3 files changed, 27 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/=
cpuid.rst
>>> index 01b081f6e7ea..64b94103fc90 100644
>>> --- a/Documentation/virt/kvm/cpuid.rst
>>> +++ b/Documentation/virt/kvm/cpuid.rst
>>> @@ -86,6 +86,10 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest =
checks this feature bit
>>>                                                 before using paravirtua=
lized
>>>                                                 sched yield.
>>>  =20
>>> +KVM_FEATURE_TRUSTWORTHY_SMT       14          set when host supports '=
SMT
>>> +                                              topology is trustworthy'=
 hint
>>> +                                              (KVM_HINTS_TRUSTWORTHY_S=
MT).
>>> +
>>=20
>> Instead of defining a one-off bit, can we make:
>>=20
>> ecx =3D the set of known "hints" (defaults to edx if zero)
>>=20
>> edx =3D the set of hints that apply to the virtual machine
>>
> Just to resurrect this thread, the guest could explicitly ACK
> a KVM_FEATURE_DYNAMIC_HINT at init. This would allow the host
> to change the hints whenever with the guest not needing to separately
> ACK the changed hints.

(I apologize for dropping the ball on this, I'm intended to do RFCv2 in
a nearby future)

Regarding this particular hint (let's call it 'no nonarchitectural
coresharing' for now) I don't see much value in communicating change to
guest when it happens. Imagine our host for some reason is not able to
guarantee that anymore e.g. we've migrated to a host with less pCPUs
and/or special restrictions and have to start sharing. What we, as a
guest, are supposed to do when we receive a notification? "You're now
insecure, deal with it!" :-) Equally, I don't see much value in
pre-acking such change. "I'm fine with becoming insecure at some point".

If we, however, discuss other hints such 'pre-ACK' mechanism may make
sense, however, I'd make it an option to a 'challenge/response'
protocol: if host wants to change a hint it notifies the guest and waits
for an ACK from it (e.g. a pair of MSRs + an interrupt). I, however,
have no good candidate from the existing hints which would require guest
to ACK (e.g revoking PV EOI would probably do but why would we do that?)
As I said before, challenge/response protocol is needed if we'd like to
make TSC frequency change the way Hyper-V does it (required for updating
guest TSC pages in nested case) but this is less and less important with
the appearance of TSC scaling. I'm still not sure if this is an
over-engineering or not. We can wait for the first good candidate to
decide.

--=20
Vitaly

