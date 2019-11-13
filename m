Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0BA2FACF0
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 10:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfKMJ3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 04:29:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60977 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727166AbfKMJ3H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 04:29:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573637344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2DVCP2/08CFgN2W7uLnMfcZ1lja7Zvdm5cWOXP2OiuY=;
        b=DQsh2N4nK+Cd4TZPbAOMXnpiM7MgBGqXePA55g2Y6dXrlamjG63KQ1OZgf41umg9zO9THX
        MK/G97Pl0dv72f1lX1mMju8HHpW/bcvnz1odFdBZda4QsxEhHs5Gm5mpRqkqa7b3MBu19y
        yMqxAt4ljGKidiVL8dFNWZHBIND3MPM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-Ad4U1jiNNvqLHlnca5ugqQ-1; Wed, 13 Nov 2019 04:29:03 -0500
Received: by mail-wm1-f71.google.com with SMTP id g14so1014526wmk.9
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 01:29:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=q2dbQnHC18PohRp9CEMTpQ5WoArG6QRXmOe76T9Og9w=;
        b=LfqeZRHSHhlsySqs13vfqx+otdDDrn8mNEiuSjP/bo0afHrNDQMMaKai4+Wmkxhs3U
         U8rsyhf5oUaThMH4mBljaZCAQTFPVfDCyus/owqsPqPGbdV5Qup4qIM0k4znjUgd7QUV
         4KvdcWiD+ZY70W1NeIXQFCRUHmaNpyApMOofezb6XrZMbifr4i98HYMxEFjWEJwLH6li
         mNBTTWE5XtkDqpy/U1Wco+SRG0dV7gIyugBS1E1Q3sA6pe9sVf//L+XuVsPpDLyVOijZ
         tqPF9UbuZ0VmX0PuuEa43Yip6SDs82PQMKWdUABh7ZdGYaoA8ufHYkOGUcX/6j0Fd9v6
         J39A==
X-Gm-Message-State: APjAAAXDOEWXqfa+MAuD5Mk4g4ptmHTvfSBmLYGiG2t/EvEQ7DnGfOt1
        HpM4O/oWn/6+RpjGq0jkhsPBv41BobO6VMIPrKMMJMBZNos8zT92tEJNRh/iTJ4eAlgOycmvHzJ
        uXtOD7v+ydMKy
X-Received: by 2002:a05:600c:2944:: with SMTP id n4mr1815548wmd.57.1573637342342;
        Wed, 13 Nov 2019 01:29:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqx6/0hwS2Qik9hidsciA/TR+XW47vLE5hlxH1gDrr6kcqUzz1spT90WZp2P2T6BqXjkDS5uag==
X-Received: by 2002:a05:600c:2944:: with SMTP id n4mr1815524wmd.57.1573637342047;
        Wed, 13 Nov 2019 01:29:02 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b196sm1748684wmd.24.2019.11.13.01.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 01:29:01 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Roman Kagan <rkagan@virtuozzo.com>,
        "lantianyu1986\@gmail.com" <lantianyu1986@gmail.com>
Cc:     "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "rth\@twiddle.net" <rth@twiddle.net>,
        "ehabkost\@redhat.com" <ehabkost@redhat.com>,
        "mtosatti\@redhat.com" <mtosatti@redhat.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "qemu-devel\@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH V4] target/i386/kvm: Add Hyper-V direct tlb flush support
In-Reply-To: <20191112144943.GD2397@rkaganb.sw.ru>
References: <20191112033427.7204-1-Tianyu.Lan@microsoft.com> <20191112144943.GD2397@rkaganb.sw.ru>
Date:   Wed, 13 Nov 2019 10:29:00 +0100
Message-ID: <87eeycktur.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: Ad4U1jiNNvqLHlnca5ugqQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Roman Kagan <rkagan@virtuozzo.com> writes:

> On Tue, Nov 12, 2019 at 11:34:27AM +0800, lantianyu1986@gmail.com wrote:
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>=20
>> Hyper-V direct tlb flush targets KVM on Hyper-V guest.
>> Enable direct TLB flush for its guests meaning that TLB
>> flush hypercalls are handled by Level 0 hypervisor (Hyper-V)
>> bypassing KVM in Level 1. Due to the different ABI for hypercall
>> parameters between Hyper-V and KVM, KVM capabilities should be
>> hidden when enable Hyper-V direct tlb flush otherwise KVM
>> hypercalls may be intercepted by Hyper-V. Add new parameter
>> "hv-direct-tlbflush". Check expose_kvm and Hyper-V tlb flush
>> capability status before enabling the feature.
>>=20
>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>> ---
>> Change since v3:
>>        - Fix logic of Hyper-V passthrough mode with direct
>>        tlb flush.
>>=20
>> Change sicne v2:
>>        - Update new feature description and name.
>>        - Change failure print log.
>>=20
>> Change since v1:
>>        - Add direct tlb flush's Hyper-V property and use
>>        hv_cpuid_check_and_set() to check the dependency of tlbflush
>>        feature.
>>        - Make new feature work with Hyper-V passthrough mode.
>> ---
>>  docs/hyperv.txt   | 10 ++++++++++
>>  target/i386/cpu.c |  2 ++
>>  target/i386/cpu.h |  1 +
>>  target/i386/kvm.c | 24 ++++++++++++++++++++++++
>>  4 files changed, 37 insertions(+)
>>=20
>> diff --git a/docs/hyperv.txt b/docs/hyperv.txt
>> index 8fdf25c829..140a5c7e44 100644
>> --- a/docs/hyperv.txt
>> +++ b/docs/hyperv.txt
>> @@ -184,6 +184,16 @@ enabled.
>> =20
>>  Requires: hv-vpindex, hv-synic, hv-time, hv-stimer
>> =20
>> +3.18. hv-direct-tlbflush
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +Enable direct TLB flush for KVM when it is running as a nested
>> +hypervisor on top Hyper-V. When enabled, TLB flush hypercalls from L2
>> +guests are being passed through to L0 (Hyper-V) for handling. Due to AB=
I
>> +differences between Hyper-V and KVM hypercalls, L2 guests will not be
>> +able to issue KVM hypercalls (as those could be mishanled by L0
>> +Hyper-V), this requires KVM hypervisor signature to be hidden.
>
> On a second thought, I wonder if this is the only conflict we have.
>
> In KVM, kvm_emulate_hypercall, when sees Hyper-V hypercalls enabled,
> just calls kvm_hv_hypercall and returns.  I.e. once the userspace
> enables Hyper-V hypercalls (which QEMU does when any of hv_* flags is
> given), KVM treats *all* hypercalls as Hyper-V ones and handles *no* KVM
> hypercalls.

Yes, but only after guest enables Hyper-V hypercalls by writing to
HV_X64_MSR_HYPERCALL. E.g. if you run a Linux guest and add a couple
hv_* flags on the QEMU command line the guest will still be able to use
KVM hypercalls normally becase Linux won't enable Hyper-V hypercall
page.

>
> So, if hiding the KVM hypervisor signature is the only way to prevent the
> guest from issuing KVM hypercalls (need to double-check), then, I'm
> afraid, we just need to require it as soon as any Hyper-V feature is
> enabled.
>

If we do that we're going to break a lot of setups in the wild which run
Linux guests with hv_* flags (e.g. just to keep configuration the same
for Windows/Linux or by mistake/misunderstanding).

When Hyper-V enlightenments are enabled, KVM signature moves to
0x40000100 so if a guest is still able to find it -- then it knows
what's going on. I'd suggest we maintain the status quo.

--=20
Vitaly

