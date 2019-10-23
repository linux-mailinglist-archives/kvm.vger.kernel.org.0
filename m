Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B03E2E149C
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 10:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390534AbfJWIrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 04:47:23 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42155 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390391AbfJWIrX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Oct 2019 04:47:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571820443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BjjrmiYhb9Vayn2zyhbA3JP+Y6pXaN5xQ7y6mWAzc94=;
        b=MRIBlxmcREaBIHvecheq5wXk9CmDZooKvRO1F4Andz3dd6w2WdVyk7LqMgqJorlUj7/jB2
        YJz2/l8IDRPQzIub66PerPgn5P+EKIMyg+gVGBMwa/YaaTA1XDg373dvTYmtQmiWBYy56J
        ck2ywKISxaKpxgELhT9anfJa0mJ7gAE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-OG6Gno-9MXyx5AsQZJzjWw-1; Wed, 23 Oct 2019 04:47:19 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3ED9800D54;
        Wed, 23 Oct 2019 08:47:18 +0000 (UTC)
Received: from [10.36.117.79] (ovpn-117-79.ams2.redhat.com [10.36.117.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1EB55DD79;
        Wed, 23 Oct 2019 08:47:17 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] s390x: Fix selftest malloc check
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com
References: <20191023084017.13142-1-frankja@linux.ibm.com>
 <b5363884-7360-ffc4-b572-f1942cbfae20@redhat.com>
 <cce26d3f-83d5-09e8-7a22-de37a2d117dc@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <c0710aad-7e40-5f4a-8608-5b5132379baa@redhat.com>
Date:   Wed, 23 Oct 2019 10:47:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <cce26d3f-83d5-09e8-7a22-de37a2d117dc@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: OG6Gno-9MXyx5AsQZJzjWw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23.10.19 10:45, Janosch Frank wrote:
> On 10/23/19 10:41 AM, David Hildenbrand wrote:
>> On 23.10.19 10:40, Janosch Frank wrote:
>>> Commit c09c54c ("lib: use an argument which doesn't require default
>>> argument promotion") broke the selftest. Let's fix it by converting
>>> the binary operations to bool.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>    s390x/selftest.c | 4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/s390x/selftest.c b/s390x/selftest.c
>>> index f4acdc4..9cd6943 100644
>>> --- a/s390x/selftest.c
>>> +++ b/s390x/selftest.c
>>> @@ -49,9 +49,9 @@ static void test_malloc(void)
>>>    =09*tmp2 =3D 123456789;
>>>    =09mb();
>>>   =20
>>> -=09report("malloc: got vaddr", (uintptr_t)tmp & 0xf000000000000000ul);
>>> +=09report("malloc: got vaddr", !!((uintptr_t)tmp & 0xf000000000000000u=
l));
>>>    =09report("malloc: access works", *tmp =3D=3D 123456789);
>>> -=09report("malloc: got 2nd vaddr", (uintptr_t)tmp2 & 0xf00000000000000=
0ul);
>>> +=09report("malloc: got 2nd vaddr", !!((uintptr_t)tmp2 & 0xf00000000000=
0000ul));
>>>    =09report("malloc: access works", (*tmp2 =3D=3D 123456789));
>>>    =09report("malloc: addresses differ", tmp !=3D tmp2);
>>>   =20
>>>
>>
>> See
>>
>> https://lore.kernel.org/kvm/CAGG=3D3QUdVBg5JArMaBcRbBLrHqLLCpAcrtvgT4q1h=
0V7SHbbEQ@mail.gmail.com/T/
>>
>=20
> I completely missed that patch and only looked for fixpatches on the
> list -_-
>=20
> If possible CC me if something like this turns up, so I don't have the
> CI flashing red lights at me unexpectedly :)

Will do in case I don't forget :)

--=20

Thanks,

David / dhildenb

