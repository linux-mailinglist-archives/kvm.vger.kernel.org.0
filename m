Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7614E3793
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 18:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439752AbfJXQM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 12:12:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22147 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2436631AbfJXQM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 12:12:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571933539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RBbR6QwqhpCEh7MghmlTY7a/HGmU9By6CyJ79EcgHvE=;
        b=NoRu+QsoCwqJXXng59H3LLuQx6HWyFiKvot2G02d/iWUwp9efFUfzi0q4kNcOS8CBQBQPL
        I9cnwqDdhamxzJhrqWcLc1WLLldlCODV9bnRSpK7zyabh41S8PFQ9z6aRS4e+bD1uL2W1V
        6kM0Z2GnGEU03BxAZTkQQn8dondnflM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-lptHBHfKPpeIcfJymcAFQQ-1; Thu, 24 Oct 2019 11:54:08 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 657C81005591;
        Thu, 24 Oct 2019 15:52:34 +0000 (UTC)
Received: from [10.36.116.202] (ovpn-116-202.ams2.redhat.com [10.36.116.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DEEA1001B05;
        Thu, 24 Oct 2019 15:52:32 +0000 (UTC)
Subject: Re: [RFC 02/37] s390/protvirt: introduce host side setup
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        cohuck@redhat.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-3-frankja@linux.ibm.com>
 <e1a12cc7-de97-127d-6076-f86b7be6bac1@redhat.com>
 <b78483e0-e438-feb8-8dfa-1d8f0df18c73@redhat.com>
 <d78f708a-7536-d556-f027-adb7cc7b94f5@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <bd716a5e-eb1b-10e5-5750-269846967522@redhat.com>
Date:   Thu, 24 Oct 2019 17:52:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <d78f708a-7536-d556-f027-adb7cc7b94f5@de.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: lptHBHfKPpeIcfJymcAFQQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 15:40, Christian Borntraeger wrote:
>=20
>=20
> On 24.10.19 15:27, David Hildenbrand wrote:
>> On 24.10.19 15:25, David Hildenbrand wrote:
>>> On 24.10.19 13:40, Janosch Frank wrote:
>>>> From: Vasily Gorbik <gor@linux.ibm.com>
>>>>
>>>> Introduce KVM_S390_PROTECTED_VIRTUALIZATION_HOST kbuild option for
>>>> protected virtual machines hosting support code.
>>>>
>>>> Add "prot_virt" command line option which controls if the kernel
>>>> protected VMs support is enabled at runtime.
>>>>
>>>> Extend ultravisor info definitions and expose it via uv_info struct
>>>> filled in during startup.
>>>>
>>>> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
>>>> ---
>>>>  =C2=A0=C2=A0 .../admin-guide/kernel-parameters.txt=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 ++
>>>>  =C2=A0=C2=A0 arch/s390/boot/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
>>>>  =C2=A0=C2=A0 arch/s390/boot/uv.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 20 +++++++-
>>>>  =C2=A0=C2=A0 arch/s390/include/asm/uv.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 | 46 ++++++++++++++++--
>>>>  =C2=A0=C2=A0 arch/s390/kernel/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0 1 +
>>>>  =C2=A0=C2=A0 arch/s390/kernel/setup.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 --
>>>>  =C2=A0=C2=A0 arch/s390/kernel/uv.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 48 +++++++++++++++++++
>>>>  =C2=A0=C2=A0 arch/s390/kvm/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 9 ++++
>>>>  =C2=A0=C2=A0 8 files changed, 126 insertions(+), 9 deletions(-)
>>>>  =C2=A0=C2=A0 create mode 100644 arch/s390/kernel/uv.c
>>>>
>>>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documen=
tation/admin-guide/kernel-parameters.txt
>>>> index c7ac2f3ac99f..aa22e36b3105 100644
>>>> --- a/Documentation/admin-guide/kernel-parameters.txt
>>>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>>>> @@ -3693,6 +3693,11 @@
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 before loading.
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 See Documentation/admin-guide/blockdev/ramdisk.rst.
>>>>  =C2=A0=C2=A0 +=C2=A0=C2=A0=C2=A0 prot_virt=3D=C2=A0=C2=A0=C2=A0 [S390=
] enable hosting protected virtual machines
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 is=
olated from the hypervisor (if hardware supports
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 th=
at).
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Fo=
rmat: <bool>
>>>
>>> Isn't that a virt driver detail that should come in via KVM module
>>> parameters? I don't see quite yet why this has to be a kernel parameter
>>> (that can be changed at runtime).
>>>
>>
>> I was confused by "runtime" in "which controls if the kernel protected V=
Ms support is enabled at runtime"
>>
>> So this can't be changed at runtime. Can you clarify why kvm can't initi=
alize that when loaded and why we need a kernel parameter?
>=20
> We have to do the opt-in very early for several reasons:
> - we have to donate a potentially largish contiguous (in real) range of m=
emory to the ultravisor

If you'd be using CMA (or alloc_contig_pages() with less guarantees) you=20
could be making good use of the memory until you actually start an=20
encrypted guest.

I can see that using the memblock allocator early is easier. But you=20
waste "largish ... range of memory" even if you never run VMs.

Maybe something to work on in the future.

> - The opt-in will also disable some features in the host that could affec=
t guest integrity (e.g.
> time sync via STP to avoid the host messing with the guest time stepping)=
. Linux is not happy
> when you remove features at a later point in time

At least disabling STP shouldn't be a real issue if I'm not wrong (maybe=20
I am). But there seem to be more features.

(when I saw "prot_virt" it felt like somebody is using a big hammer for=20
small nails (e.g., compared to "stp=3Doff").)

Can you guys add these details to the patch description?

--=20

Thanks,

David / dhildenb

