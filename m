Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB3A2E7592
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 16:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390178AbfJ1Pyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Oct 2019 11:54:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37041 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726387AbfJ1Pyo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Oct 2019 11:54:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572278083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iWxllc1G8SHq1RkOK7kCt83EB2YbceKdCT0ElOAOVVk=;
        b=ab8+/fyFLk7oVARGRieNNkHVAZCvmR/afvq91VFV5L/n5mgmPadxFIEAdApMa9d7hbMPGe
        VCY9KgW4wwrNUahSUbY8JYBqOzx1yHGTeggke8nRnnBrpH0jBT0OnQoGjwfn1uD7LaHCil
        y++tOOlxIE2EX0kj9fty9rg6fxy4NMk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-FgDxBwwEOaeigqXAT-gtiw-1; Mon, 28 Oct 2019 11:54:40 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3D34801E64;
        Mon, 28 Oct 2019 15:54:38 +0000 (UTC)
Received: from [10.36.117.63] (ovpn-117-63.ams2.redhat.com [10.36.117.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D15C55C1B2;
        Mon, 28 Oct 2019 15:54:36 +0000 (UTC)
Subject: Re: [RFC 03/37] s390/protvirt: add ultravisor initialization
To:     Vasily Gorbik <gor@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-4-frankja@linux.ibm.com>
 <d0bc545a-fdbb-2aa9-4f0a-2e0ea1abce5b@redhat.com>
 <your-ad-here.call-01572277730-ext-9266@work.hours>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <6a5b7e54-ca44-4341-9772-e782aa67cd53@redhat.com>
Date:   Mon, 28 Oct 2019 16:54:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <your-ad-here.call-01572277730-ext-9266@work.hours>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: FgDxBwwEOaeigqXAT-gtiw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28.10.19 16:48, Vasily Gorbik wrote:
> On Fri, Oct 25, 2019 at 11:21:05AM +0200, David Hildenbrand wrote:
>> On 24.10.19 13:40, Janosch Frank wrote:
>>> From: Vasily Gorbik <gor@linux.ibm.com>
>>>
>>> Before being able to host protected virtual machines, donate some of
>>> the memory to the ultravisor. Besides that the ultravisor might impose
>>> addressing limitations for memory used to back protected VM storage. Tr=
eat
>>> that limit as protected virtualization host's virtual memory limit.
>>>
>>> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
>>> ---
>>>    arch/s390/include/asm/uv.h | 16 ++++++++++++
>>>    arch/s390/kernel/setup.c   |  3 +++
>>>    arch/s390/kernel/uv.c      | 53 ++++++++++++++++++++++++++++++++++++=
++
>>>    3 files changed, 72 insertions(+)
>>>
>>> --- a/arch/s390/kernel/setup.c
>>> +++ b/arch/s390/kernel/setup.c
>>> @@ -567,6 +567,8 @@ static void __init setup_memory_end(void)
>>>    =09=09=09vmax =3D _REGION1_SIZE; /* 4-level kernel page table */
>>>    =09}
>>> +=09adjust_to_uv_max(&vmax);
>>
>> I do wonder what would happen if vmax < max_physmem_end. Not sure if tha=
t is
>> relevant at all.
>=20
> Then identity mapping would be shorter then actual physical memory availa=
ble
> and everything above would be lost. But in reality "max_sec_stor_addr"
> is big enough to not worry about it in the foreseeable future at all.
>=20
>>> +void __init setup_uv(void)
>>> +{
>>> +=09unsigned long uv_stor_base;
>>> +
>>> +=09if (!prot_virt_host)
>>> +=09=09return;
>>> +
>>> +=09uv_stor_base =3D (unsigned long)memblock_alloc_try_nid(
>>> +=09=09uv_info.uv_base_stor_len, SZ_1M, SZ_2G,
>>> +=09=09MEMBLOCK_ALLOC_ACCESSIBLE, NUMA_NO_NODE);
>>> +=09if (!uv_stor_base) {
>>> +=09=09pr_info("Failed to reserve %lu bytes for ultravisor base storage=
\n",
>>> +=09=09=09uv_info.uv_base_stor_len);
>>> +=09=09goto fail;
>>> +=09}
>>
>> If I'm not wrong, we could setup/reserve a CMA area here and defer the
>> actual allocation. Then, any MOVABLE data can end up on this CMA area un=
til
>> needed.
>>
>> But I am neither an expert on CMA nor on UV, so most probably what I say=
 is
>> wrong ;)
>=20
>  From pure memory management this sounds like a good idea. And I tried
> it and cma_declare_contiguous fulfills our needs, just had to export
> cma_alloc/cma_release symbols. Nevertheless, delaying ultravisor init mea=
ns we
> would be potentially left with vmax =3D=3D max_sec_stor_addr even if we w=
ouldn't
> be able to run protected VMs after all (currently setup_uv() is called
> before kernel address space layout setup). Another much more fundamental
> reason is that ultravisor init has to be called with a single cpu running=
,
> which means it's easy to do before bringing other cpus up and we currentl=
y
> don't have api to stop cpus at a later point (stop_machine won't cut it).

Interesting point, I guess. One could hack around that. Emphasis on=20
*hack* :) In stop_machine() you caught all CPUs. You could just=20
temporarily SIGP STOP all running ones, issue the UV init call, and SIGP=20
START them again. Not sure how that works with SMP, though ...

But yeah, this is stuff for the future, just an idea from my side :)

--=20

Thanks,

David / dhildenb

