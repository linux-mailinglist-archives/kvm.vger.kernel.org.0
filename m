Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280F8E341D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbfJXN1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:27:47 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50872 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730227AbfJXN1r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 09:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571923665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FtVm1MIwnva2aDBsHRw3mF4DKv36qcT2H+wAHwUGlRg=;
        b=UbgsS8USCDKDuwhWbW+Ji0CoxtpGSd2PI1X5VVR3UcxFu2CCaOxjzL3F6SQsml1MNgOUkp
        TMgcXb/+oHbfndFp4FMbLd2KWd586NId93LapsjwRmjTmUTmP55nsm99KT5T3VSEeFfAh2
        pU6uUaWH76KsH071C6mmVmGT+um1jK4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-nyKiYtqbOB-ZnfhWvNouCQ-1; Thu, 24 Oct 2019 09:27:41 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 601D0107AD31;
        Thu, 24 Oct 2019 13:27:40 +0000 (UTC)
Received: from [10.36.116.141] (ovpn-116-141.ams2.redhat.com [10.36.116.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77CC410027AB;
        Thu, 24 Oct 2019 13:27:38 +0000 (UTC)
Subject: Re: [RFC 02/37] s390/protvirt: introduce host side setup
From:   David Hildenbrand <david@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-3-frankja@linux.ibm.com>
 <e1a12cc7-de97-127d-6076-f86b7be6bac1@redhat.com>
Organization: Red Hat GmbH
Message-ID: <b78483e0-e438-feb8-8dfa-1d8f0df18c73@redhat.com>
Date:   Thu, 24 Oct 2019 15:27:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <e1a12cc7-de97-127d-6076-f86b7be6bac1@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: nyKiYtqbOB-ZnfhWvNouCQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 15:25, David Hildenbrand wrote:
> On 24.10.19 13:40, Janosch Frank wrote:
>> From: Vasily Gorbik <gor@linux.ibm.com>
>>
>> Introduce KVM_S390_PROTECTED_VIRTUALIZATION_HOST kbuild option for
>> protected virtual machines hosting support code.
>>
>> Add "prot_virt" command line option which controls if the kernel
>> protected VMs support is enabled at runtime.
>>
>> Extend ultravisor info definitions and expose it via uv_info struct
>> filled in during startup.
>>
>> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
>> ---
>>    .../admin-guide/kernel-parameters.txt         |  5 ++
>>    arch/s390/boot/Makefile                       |  2 +-
>>    arch/s390/boot/uv.c                           | 20 +++++++-
>>    arch/s390/include/asm/uv.h                    | 46 ++++++++++++++++--
>>    arch/s390/kernel/Makefile                     |  1 +
>>    arch/s390/kernel/setup.c                      |  4 --
>>    arch/s390/kernel/uv.c                         | 48 ++++++++++++++++++=
+
>>    arch/s390/kvm/Kconfig                         |  9 ++++
>>    8 files changed, 126 insertions(+), 9 deletions(-)
>>    create mode 100644 arch/s390/kernel/uv.c
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documenta=
tion/admin-guide/kernel-parameters.txt
>> index c7ac2f3ac99f..aa22e36b3105 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -3693,6 +3693,11 @@
>>    =09=09=09before loading.
>>    =09=09=09See Documentation/admin-guide/blockdev/ramdisk.rst.
>>   =20
>> +=09prot_virt=3D=09[S390] enable hosting protected virtual machines
>> +=09=09=09isolated from the hypervisor (if hardware supports
>> +=09=09=09that).
>> +=09=09=09Format: <bool>
>=20
> Isn't that a virt driver detail that should come in via KVM module
> parameters? I don't see quite yet why this has to be a kernel parameter
> (that can be changed at runtime).
>=20

I was confused by "runtime" in "which controls if the kernel protected=20
VMs support is enabled at runtime"

So this can't be changed at runtime. Can you clarify why kvm can't=20
initialize that when loaded and why we need a kernel parameter?

--=20

Thanks,

David / dhildenb

