Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A029BEDF50
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 12:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbfKDLz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 06:55:56 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21165 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbfKDLz4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 06:55:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572868555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wy35btpntBTMjiVNCiOtVBVNDH1EykTq0NwzLXwUWUc=;
        b=d57+aaZvYKSayMcf6zL9/vyxBz5WsHIFsLGF1VTv2KxQhC3qYr0ejD+8W6K3HwJPSmHRvr
        YMDQf0sbL3K0aa+evyBj/SI8Mx0sx/oxHpIIUBfaDHj0AjOTB4gVC+wKbpEoBaT1CPUD1K
        U/4+QC0x6JHTMBjH0DLNQuwh5UlXKec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-4rdHAQ8tPWag0qL8P1a_LA-1; Mon, 04 Nov 2019 06:55:52 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C88B91800D53;
        Mon,  4 Nov 2019 11:55:50 +0000 (UTC)
Received: from [10.36.118.62] (unknown [10.36.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9971D60863;
        Mon,  4 Nov 2019 11:55:49 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 5/5] s390x: SCLP unit test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
 <1572023194-14370-6-git-send-email-imbrenda@linux.ibm.com>
 <1df14176-20a7-a9af-5622-2853425d973e@redhat.com>
 <20191104122931.0774ff7a@p-imbrenda.boeblingen.de.ibm.com>
 <56ce2fe9-1a6a-ffd6-3776-0be1b622032b@redhat.com>
 <20191104124912.7cb58664@p-imbrenda.boeblingen.de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <73d233c8-6599-ab1c-6da3-88a4fa719c82@redhat.com>
Date:   Mon, 4 Nov 2019 12:55:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191104124912.7cb58664@p-imbrenda.boeblingen.de.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 4rdHAQ8tPWag0qL8P1a_LA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.19 12:49, Claudio Imbrenda wrote:
> On Mon, 4 Nov 2019 12:31:32 +0100
> David Hildenbrand <david@redhat.com> wrote:
>=20
>> On 04.11.19 12:29, Claudio Imbrenda wrote:
>>> On Mon, 4 Nov 2019 11:58:20 +0100
>>> David Hildenbrand <david@redhat.com> wrote:
>>>
>>> [...]
>>>   =20
>>>> Can we just please rename all "cx" into something like "len"? Or is
>>>> there a real need to have "cx" in there?
>>>
>>> if cx is such a nuisance to you, sure, I can rename it to i
>>
>> better than random characters :)
>=20
> will be in v3
>=20
>>>   =20
>>>> Also, I still dislike "test_one_sccb". Can't we just just do
>>>> something like
>>>>
>>>> expect_pgm_int();
>>>> rc =3D test_one_sccb(...)
>>>> report("whatever pgm", rc =3D=3D WHATEVER);
>>>> report("whatever rc", lc->pgm_int_code =3D=3D WHATEVER);
>>>>
>>>> In the callers to make these tests readable and cleanup
>>>> test_one_sccb(). I don't care if that produces more LOC as long as
>>>> I can actually read and understand the test cases.
>>>
>>> if you think that makes it more readable, ok I guess...
>>>
>>> consider that the output will be unreadable, though
>>>   =20
>>
>> I think his will turn out more readable.
>=20
> two output lines per SCLP call? I  don't think so

To clarify, we don't always need two checks. E.g., I would like to see=20
instead of

+static void test_sccb_too_short(void)
+{
+=09int cx;
+
+=09for (cx =3D 0; cx < 8; cx++)
+=09=09if (!test_one_run(valid_code, pagebuf, cx, 8, PGM_BIT_SPEC, 0))
+=09=09=09break;
+
+=09report("SCCB too short", cx =3D=3D 8);
+}

Something like

static void test_sccb_too_short(void)
{
=09int i;

=09for (i =3D 0; i < 8; i++) {
=09=09expect_pgm_int();
=09=09test_one_sccb(...); // or however that will be called
=09=09check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
=09}
}

If possible.

--=20

Thanks,

David / dhildenb

