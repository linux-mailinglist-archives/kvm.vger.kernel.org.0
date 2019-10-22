Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA72EE07BF
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 17:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732008AbfJVPq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 11:46:26 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52639 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731556AbfJVPq0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Oct 2019 11:46:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571759185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2x718xOwr0K6es+E8t+LhS3fopKpjY38Em+QSJaQcfo=;
        b=eYY09yinhJt8VaD/I3uWaQPYzeQkuQM6JhNJp3j5jQWp8sWvIy2bAD6NJ8Taf8lawBcCpB
        Ja0OFcJ+pYwpz6UQMbdbCxqtzTKxMBSHk8Jg0MJ+lqC/MdzLJJug9SIzJ9S5DRXbASsQWm
        rHPK8iG7rCYpcV/g827ffzlXFGmvV44=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-ooGfiTFRMrO5rHkPWf5lVA-1; Tue, 22 Oct 2019 11:46:22 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6811E800D49;
        Tue, 22 Oct 2019 15:46:21 +0000 (UTC)
Received: from [10.36.116.248] (ovpn-116-248.ams2.redhat.com [10.36.116.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 362F01059A54;
        Tue, 22 Oct 2019 15:46:20 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 4/5] s390x: sclp: add service call
 instruction wrapper
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <1571741584-17621-1-git-send-email-imbrenda@linux.ibm.com>
 <1571741584-17621-5-git-send-email-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <aeff96b6-8097-d89b-337c-22300fc4a70e@redhat.com>
Date:   Tue, 22 Oct 2019 17:46:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1571741584-17621-5-git-send-email-imbrenda@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: ooGfiTFRMrO5rHkPWf5lVA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.10.19 12:53, Claudio Imbrenda wrote:
> Add a wrapper for the service call instruction, and use it for SCLP
> interactions instead of using inline assembly everywhere.

The description is weird.

"Let's factor out the assembly for the service call instruction, we want=20
to reuse that for actual SCLP service call tests soon."

Reviewed-by: David Hildenbrand <david@redhat.com>

>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h | 13 +++++++++++++
>   lib/s390x/sclp.c         |  7 +------
>   2 files changed, 14 insertions(+), 6 deletions(-)
>=20
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 96cca2e..b3caff6 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -269,4 +269,17 @@ static inline int stsi(void *addr, int fc, int sel1,=
 int sel2)
>   =09return cc;
>   }
>  =20
> +static inline int servc(uint32_t command, unsigned long sccb)
> +{
> +=09int cc;
> +
> +=09asm volatile(
> +=09=09"       .insn   rre,0xb2200000,%1,%2\n"  /* servc %1,%2 */
> +=09=09"       ipm     %0\n"
> +=09=09"       srl     %0,28"
> +=09=09: "=3D&d" (cc) : "d" (command), "a" (sccb)
> +=09=09: "cc", "memory");
> +=09return cc;
> +}
> +
>   #endif
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index a57096c..376040e 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -116,12 +116,7 @@ int sclp_service_call(unsigned int command, void *sc=
cb)
>   =09int cc;
>  =20
>   =09sclp_setup_int();
> -=09asm volatile(
> -=09=09"       .insn   rre,0xb2200000,%1,%2\n"  /* servc %1,%2 */
> -=09=09"       ipm     %0\n"
> -=09=09"       srl     %0,28"
> -=09=09: "=3D&d" (cc) : "d" (command), "a" (__pa(sccb))
> -=09=09: "cc", "memory");
> +=09cc =3D servc(command, __pa(sccb));
>   =09sclp_wait_busy();
>   =09if (cc =3D=3D 3)
>   =09=09return -1;
>=20


--=20

Thanks,

David / dhildenb

