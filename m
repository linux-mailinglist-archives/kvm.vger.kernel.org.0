Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD29EDDBE
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 12:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbfKDLbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 06:31:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45131 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728396AbfKDLbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 06:31:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572867112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NSfgomCgWil/+aWIok47V41MYKEfKDPbFO3XgEwAl9k=;
        b=KZFodtZpbwykzaLFotOb7Fm/ZUySdlaAFpzouM/y5ntBLMWnT7WIOZ1RW69gtStJDD/2wj
        78Pb/9vAqXIc2ZGhGndsOrkMa3e+cEuWFNdHuzAVuR9gs0IdVXiZPXjVRoNYmmj4yNX/9o
        3yIZDmAtEwrxGN4ZnU/X5vmTnWKpX58=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133--auulcs6NNGVsRpoHld5HQ-1; Mon, 04 Nov 2019 06:31:51 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C60B8017DD;
        Mon,  4 Nov 2019 11:31:50 +0000 (UTC)
Received: from [10.36.118.62] (unknown [10.36.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E6F55D9CD;
        Mon,  4 Nov 2019 11:31:47 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2] alloc: Add memalign error checks
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        thuth@redhat.com
References: <20191104102916.10554-1-frankja@linux.ibm.com>
 <61db264b-6d29-66bc-ea60-053b5aa8b995@redhat.com>
 <20191104105417.xt2z5gcuk5xqf4bi@kamzik.brq.redhat.com>
 <a91a1828-017a-b0c6-442f-5b31263f3568@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <739917cb-a030-a178-257a-9717efcc15ff@redhat.com>
Date:   Mon, 4 Nov 2019 12:31:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <a91a1828-017a-b0c6-442f-5b31263f3568@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: -auulcs6NNGVsRpoHld5HQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.19 12:29, Paolo Bonzini wrote:
> On 04/11/19 11:54, Andrew Jones wrote:
>>
>> diff --git a/lib/alloc.c b/lib/alloc.c
>> index ecdbbc44dbf9..ed8f5f94c9b0 100644
>> --- a/lib/alloc.c
>> +++ b/lib/alloc.c
>> @@ -46,15 +46,17 @@ void *memalign(size_t alignment, size_t size)
>>   =09uintptr_t blkalign;
>>   =09uintptr_t mem;
>>  =20
>> +=09if (!size)
>> +=09=09return NULL;
>> +
>> +=09assert(alignment >=3D sizeof(void *) && is_power_of_2(alignment));
>>   =09assert(alloc_ops && alloc_ops->memalign);
>> -=09if (alignment <=3D sizeof(uintptr_t))
>> -=09=09alignment =3D sizeof(uintptr_t);
>> -=09else
>> -=09=09size +=3D alignment - 1;
>>  =20
>> +=09size +=3D alignment - 1;
>>   =09blkalign =3D MAX(alignment, alloc_ops->align_min);
>>   =09size =3D ALIGN(size + METADATA_EXTRA, alloc_ops->align_min);
>>   =09p =3D alloc_ops->memalign(blkalign, size);
>> +=09assert(p);
>>  =20
>>   =09/* Leave room for metadata before aligning the result.  */
>>   =09mem =3D (uintptr_t)p + METADATA_EXTRA;
>=20
> Looks good, this is what I am queuing.
>=20
> Paolo
>=20

Please add my

Reviewed-by: David Hildenbrand <david@redhat.com>

--=20

Thanks,

David / dhildenb

