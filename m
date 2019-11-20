Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3557B104319
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 19:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfKTSQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 13:16:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40761 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727468AbfKTSQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 13:16:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574273773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gYyBv5Rxp1Uje+USM1WcyGRNB3Xlzuqtk5xGVkD8gpY=;
        b=Lyc+Q3eBZcxLVwIS8pM0SNHznJLZoOQAnyC7KIJjhWiRW/HPg6qynvMWjm9e77w0uJBP+Q
        be2gdFMsc6TgdqBieadAlgZDax0WGH8SpU1RyOVKApGnjyfXyvFmXV8Prg2V+xNLiOP47k
        kkedRO6oHjYyBvN7w1nTgQEzwFyH0Bk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-l6OFv6dKMxC7NNiu3rpBmw-1; Wed, 20 Nov 2019 13:16:10 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35B37107ACE6;
        Wed, 20 Nov 2019 18:16:09 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-122.ams2.redhat.com [10.36.116.122])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E46DD5195F;
        Wed, 20 Nov 2019 18:16:04 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 3/3] s390x: SCLP unit test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <1574157219-22052-1-git-send-email-imbrenda@linux.ibm.com>
 <1574157219-22052-4-git-send-email-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <3ed24d20-9c77-7f18-203b-b28a38b5e07f@redhat.com>
Date:   Wed, 20 Nov 2019 19:16:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1574157219-22052-4-git-send-email-imbrenda@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: l6OFv6dKMxC7NNiu3rpBmw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/2019 10.53, Claudio Imbrenda wrote:
> SCLP unit test. Testing the following:
>=20
> * Correctly ignoring instruction bits that should be ignored
> * Privileged instruction check
> * Check for addressing exceptions
> * Specification exceptions:
>   - SCCB size less than 8
>   - SCCB unaligned
>   - SCCB overlaps prefix or lowcore
>   - SCCB address higher than 2GB
> * Return codes for
>   - Invalid command
>   - SCCB too short (but at least 8)
>   - SCCB page boundary violation
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/sclp.c        | 465 ++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  s390x/unittests.cfg |   3 +
>  3 files changed, 469 insertions(+)
>  create mode 100644 s390x/sclp.c
[...]
> +/**
> + * Test SCCB page boundary violations.
> + */
> +static void test_boundary(void)
> +{
> +=09const uint32_t cmd =3D SCLP_CMD_WRITE_EVENT_DATA;
> +=09const uint16_t res =3D SCLP_RC_SCCB_BOUNDARY_VIOLATION;
> +=09WriteEventData *sccb =3D (WriteEventData *)sccb_template;
> +=09int len, offset;
> +
> +=09memset(sccb_template, 0, sizeof(sccb_template));
> +=09sccb->h.function_code =3D SCLP_FC_NORMAL_WRITE;
> +=09for (len =3D 32; len <=3D 4096; len++) {
> +=09=09offset =3D len & 7 ? len & ~7 : len - 8;

I needed some time to understand that line. I think it would be easier
that way:

=09=09offset =3D (len - 1) & ~7;

?

Anyway, no need to respin just because of that line ... the rest of the
patch looks ok to me.

> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index f1b07cd..75e3d37 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -75,3 +75,6 @@ file =3D stsi.elf
>  [smp]
>  file =3D smp.elf
>  extra_params =3D-smp 2
> +
> +[sclp]
> +file =3D sclp.elf

It's a little bit sad that some of the tests require < 2G of RAM while
other tests should (also) be done with > 2G if I understood that
correctly. So currently not all tests can be run automatically but just
starting the "run_tests.sh" script, right?

It does not have to be right now (i.e. could also be a follow-up patch
later), but what about adding two sections to the unittests.cfg file,
one with less and one with more than 2G of RAM? E.g.:

[sclp-1g]
file =3D sclp.elf
extra_params =3D -m 1G

[sclp-3g]
file =3D sclp.elf
extra_params =3D -m 3G -append "somemagicparametertoonlyrunthebigmemtest"

?

 Thomas

