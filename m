Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18DD8E38EA
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 18:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409949AbfJXQyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 12:54:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60770 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2409946AbfJXQyd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 12:54:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571936071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GXaNRnuh7Z/nj/KkILy0Qb0iUElZpHI/665z+zNpnMg=;
        b=LQohfwK+eR2ZrcucrE8CZ8wm1dogaYsvnWAqd4+SZu7FBR5/l+9MF2zmYsFOTnTO99QiN+
        jnDqbz56vcEbQH3Jyekl43dwhVQ5ARcT4CTA8+hAUaekYhIAZZoY0XOo2+1POMvL/fneTk
        jyUvs5CsSLC/HiQs4lYknuCrA/adBN0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-Q3OYW0snPUqUPhMg3Taqmw-1; Thu, 24 Oct 2019 12:54:30 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD0D01800D6B;
        Thu, 24 Oct 2019 16:54:28 +0000 (UTC)
Received: from [10.36.116.202] (ovpn-116-202.ams2.redhat.com [10.36.116.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C120A60126;
        Thu, 24 Oct 2019 16:54:26 +0000 (UTC)
Subject: Re: [RFC 02/37] s390/protvirt: introduce host side setup
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-3-frankja@linux.ibm.com>
 <e1a12cc7-de97-127d-6076-f86b7be6bac1@redhat.com>
 <b78483e0-e438-feb8-8dfa-1d8f0df18c73@redhat.com>
 <d78f708a-7536-d556-f027-adb7cc7b94f5@de.ibm.com>
 <bd716a5e-eb1b-10e5-5750-269846967522@redhat.com>
 <20191024183009.1cb1ec50@p-imbrenda.boeblingen.de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <c525b6ea-69aa-5ab2-8532-bfe6a0dc9af5@redhat.com>
Date:   Thu, 24 Oct 2019 18:54:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024183009.1cb1ec50@p-imbrenda.boeblingen.de.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: Q3OYW0snPUqUPhMg3Taqmw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 18:30, Claudio Imbrenda wrote:
> On Thu, 24 Oct 2019 17:52:31 +0200
> David Hildenbrand <david@redhat.com> wrote:
>=20
>> On 24.10.19 15:40, Christian Borntraeger wrote:
>>>
>>>
>>> On 24.10.19 15:27, David Hildenbrand wrote:
>>>> On 24.10.19 15:25, David Hildenbrand wrote:
>>>>> On 24.10.19 13:40, Janosch Frank wrote:
>>>>>> From: Vasily Gorbik <gor@linux.ibm.com>
>>>>>>
>>>>>> Introduce KVM_S390_PROTECTED_VIRTUALIZATION_HOST kbuild option
>>>>>> for protected virtual machines hosting support code.
>>>>>>
>>>>>> Add "prot_virt" command line option which controls if the kernel
>>>>>> protected VMs support is enabled at runtime.
>>>>>>
>>>>>> Extend ultravisor info definitions and expose it via uv_info
>>>>>> struct filled in during startup.
>>>>>>
>>>>>> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
>>>>>> ---
>>>>>>   =C2=A0=C2=A0 .../admin-guide/kernel-parameters.txt=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 ++
>>>>>>   =C2=A0=C2=A0 arch/s390/boot/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
>>>>>>   =C2=A0=C2=A0 arch/s390/boot/uv.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 20 +++++++-
>>>>>>   =C2=A0=C2=A0 arch/s390/include/asm/uv.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 46
>>>>>> ++++++++++++++++-- arch/s390/kernel/Makefile
>>>>>> |=C2=A0 1 + arch/s390/kernel/setup.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 --
>>>>>>   =C2=A0=C2=A0 arch/s390/kernel/uv.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 48
>>>>>> +++++++++++++++++++
>>>>>> arch/s390/kvm/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 9 ++++ 8 files
>>>>>> changed, 126 insertions(+), 9 deletions(-) create mode 100644
>>>>>> arch/s390/kernel/uv.c
>>>>>>
>>>>>> diff --git a/Documentation/admin-guide/kernel-parameters.txt
>>>>>> b/Documentation/admin-guide/kernel-parameters.txt index
>>>>>> c7ac2f3ac99f..aa22e36b3105 100644 ---
>>>>>> a/Documentation/admin-guide/kernel-parameters.txt +++
>>>>>> b/Documentation/admin-guide/kernel-parameters.txt @@ -3693,6
>>>>>> +3693,11 @@ before loading.
>>>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 See
>>>>>> Documentation/admin-guide/blockdev/ramdisk.rst.
>>>>>>   =C2=A0=C2=A0 +=C2=A0=C2=A0=C2=A0 prot_virt=3D=C2=A0=C2=A0=C2=A0 [S=
390] enable hosting protected virtual
>>>>>> machines
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
isolated from the hypervisor (if hardware supports
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
that).
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
Format: <bool>
>>>>>
>>>>> Isn't that a virt driver detail that should come in via KVM module
>>>>> parameters? I don't see quite yet why this has to be a kernel
>>>>> parameter (that can be changed at runtime).
>>>>>  =20
>>>>
>>>> I was confused by "runtime" in "which controls if the kernel
>>>> protected VMs support is enabled at runtime"
>>>>
>>>> So this can't be changed at runtime. Can you clarify why kvm can't
>>>> initialize that when loaded and why we need a kernel parameter?
>>>
>>> We have to do the opt-in very early for several reasons:
>>> - we have to donate a potentially largish contiguous (in real)
>>> range of memory to the ultravisor
>>
>> If you'd be using CMA (or alloc_contig_pages() with less guarantees)
>> you could be making good use of the memory until you actually start
>> an encrypted guest.
>=20
> no, the memory needs to be allocated before any other interaction with
> the ultravisor is attempted, and the size depends on the size of the

I fail to see why you need interaction with the UV before you actually=20
start/create an encrypted guest (IOW why you can't defer uv_init()) -=20
but I am not past "[RFC 07/37] KVM: s390: protvirt: Secure memory is not=20
mergeable" yet and ...

> _host_ memory. it can be a very substantial amount of memory, and thus
> it's very likely to fail unless it's done very early at boot time.

... I guess you could still do that via CMA ... but it doesn't really=20
matter right now :) I understood the rational.

>=20
>>
>>> - The opt-in will also disable some features in the host that could
>>> affect guest integrity (e.g. time sync via STP to avoid the host
>>> messing with the guest time stepping). Linux is not happy when you
>>> remove features at a later point in time
>>
>> At least disabling STP shouldn't be a real issue if I'm not wrong
>> (maybe I am). But there seem to be more features.
>>
>> (when I saw "prot_virt" it felt like somebody is using a big hammer
>> for small nails (e.g., compared to "stp=3Doff").)
>>
>> Can you guys add these details to the patch description?
>=20
> yeah, probably a good idea
>=20

If a patch explains why it does something and not only what it does=20
usually makes me ask less stupid questions :)

--=20

Thanks,

David / dhildenb

