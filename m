Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E051F4B44
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 13:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389837AbfKHMO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 07:14:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47631 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733035AbfKHMO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 07:14:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573215297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H7WeKdbRoP0tf6imHAoI5OYJTFpoEhjRxxfTT3g7nMc=;
        b=E6p1EtckGZbuxVUl9OAvils/N07E3DauM+C7qNFaJDcus2T0unW+z3/y5KRA29utvHBTyJ
        rmEUOcvXkJtgKk40sW3XXDrAmrT/eYlP1Y1WhL+mjgRu/miZKeXNhHCKyQVR3L1faur/Io
        4PYr4dgkJas5yGwESQfpypJHHFRH5AE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-8Dd2l3zKP5SMbEJhjg0Hjw-1; Fri, 08 Nov 2019 07:14:54 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2DD1477;
        Fri,  8 Nov 2019 12:14:52 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-167.ams2.redhat.com [10.36.116.167])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EDDA6084E;
        Fri,  8 Nov 2019 12:14:47 +0000 (UTC)
Subject: Re: [RFC 02/37] s390/protvirt: introduce host side setup
To:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-3-frankja@linux.ibm.com>
 <20191104165427.0e5e6da4.cohuck@redhat.com>
 <5a34febd-8abc-84f5-195e-43decbb366a5@de.ibm.com>
 <20191105102654.223e7b42.cohuck@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <9bbd0930-c55c-084b-6ae1-6a5df6a33778@redhat.com>
Date:   Fri, 8 Nov 2019 13:14:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191105102654.223e7b42.cohuck@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 8Dd2l3zKP5SMbEJhjg0Hjw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/2019 10.26, Cornelia Huck wrote:
> On Mon, 4 Nov 2019 18:50:12 +0100
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>=20
>> On 04.11.19 16:54, Cornelia Huck wrote:
>>> On Thu, 24 Oct 2019 07:40:24 -0400
>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>>>> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
>>>> index ed007f4a6444..88cf8825d169 100644
>>>> --- a/arch/s390/boot/uv.c
>>>> +++ b/arch/s390/boot/uv.c
>>>> @@ -3,7 +3,12 @@
>>>>   #include <asm/facility.h>
>>>>   #include <asm/sections.h>
>>>>  =20
>>>> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>>>>   int __bootdata_preserved(prot_virt_guest);
>>>> +#endif
>>>> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
>>>> +struct uv_info __bootdata_preserved(uv_info);
>>>> +#endif
>>>
>>> Two functions with the same name, but different signatures look really
>>> ugly.
>>>
>>> Also, what happens if I want to build just a single kernel image for
>>> both guest and host?
>>
>> This is not two functions with the same name. It is 2 variable declarati=
ons with
>> the __bootdata_preserved helper. We expect to have all distro kernels to=
 enable
>> both.
>=20
> Ah ok, I misread that. (I'm blaming lack of sleep :/)

Honestly, I have to admit that I mis-read this in the same way as=20
Cornelia at the first glance. Why is that macro not using capital=20
letters? ... then it would be way more obvious that it's not about a=20
function prototype...

  Thomas

