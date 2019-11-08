Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0ED0F4363
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 10:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbfKHJfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 04:35:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55793 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728513AbfKHJfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 04:35:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573205741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K9rdZ713uN02L/TUP3kmVf9uZmsoSvxQ0XKmnFq1Lrc=;
        b=P3aI0jTGXiYfrBNPcx4wPuMfPxLCSugTi4YVZhinnKWHLjaW5Wgg/XxGly6ue4vRdm9iNY
        snB6iWWcLtg+DCmk5Jl0UNZVzYwiQ5rgMKPvem9kB5OLd5HuwtEiPwCyb0KQS8eKKcyyfa
        jZjJb5XeJxJA5VZqPWZrMn0lsIlT1rA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-Z5O40O75MruFaEXFb2k-Zw-1; Fri, 08 Nov 2019 04:35:39 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4802D800A1A;
        Fri,  8 Nov 2019 09:35:38 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-167.ams2.redhat.com [10.36.116.167])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8952F100194E;
        Fri,  8 Nov 2019 09:35:34 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 5/5] s390x: SCLP unit test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com
References: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
 <1572023194-14370-6-git-send-email-imbrenda@linux.ibm.com>
 <191dbc7f-74b2-6f78-a721-aaac49895948@linux.ibm.com>
 <20191104121901.3b3ab68b@p-imbrenda.boeblingen.de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <b4344967-54d2-5b57-8d36-dd1361654c8e@redhat.com>
Date:   Fri, 8 Nov 2019 10:35:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191104121901.3b3ab68b@p-imbrenda.boeblingen.de.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: Z5O40O75MruFaEXFb2k-Zw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/2019 12.19, Claudio Imbrenda wrote:
> On Mon, 4 Nov 2019 10:45:07 +0100
> Janosch Frank <frankja@linux.ibm.com> wrote:
[...]
>>> +static void test_toolong(void)
>>> +{
>>> +=09uint32_t cmd =3D SCLP_CMD_WRITE_EVENT_DATA;
>>> +=09uint16_t res =3D SCLP_RC_SCCB_BOUNDARY_VIOLATION;
>>
>> Why use variables for constants that are never touched?
>=20
> readability mostly. the names of the constants are rather long.
> the compiler will notice it and do the Right Thing=E2=84=A2

I'd like to suggest to add the "const" keyword to both variables in that=20
case, then it's clear that they are not used to be modified.

>>> +=09=09h->length =3D 4096;
>>> +
>>> +=09=09valid_code =3D commands[i];
>>> +=09=09cc =3D sclp_service_call(commands[i], h);
>>> +=09=09if (cc)
>>> +=09=09=09break;
>>> +=09=09if (h->response_code =3D=3D
>>> SCLP_RC_NORMAL_READ_COMPLETION)
>>> +=09=09=09return;
>>> +=09=09if (h->response_code !=3D
>>> SCLP_RC_INVALID_SCLP_COMMAND)
>>> +=09=09=09break;
>>
>> Depending on line length you could add that to the cc check.
>> Maybe you could also group the error conditions before the success
>> conditions or the other way around.
>=20
> yeah it woud fit, but I'm not sure it would be more readable:
>=20
> if (cc || (h->response_code !=3D SCLP_RC_INVALID_SCLP_COMMAND))
>                          break;

In case you go with that solution, please drop the innermost parentheses.

  Thomas

