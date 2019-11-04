Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C37EDC00
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 11:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfKDKAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 05:00:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34813 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727499AbfKDKAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 05:00:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572861649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jctxpAE2aKccjqYIk0DD5XcoIdfd1cAd6hpRAvEk1mY=;
        b=i+jpIaJfp3IZmPsesLVDqNjBjgDo6imCl04kkh7SBF5cATha45265qM+JhGiURoESM6ZV1
        LG7Gw0wz1PqDFg/NF9d+LyWrTMRjythP7JOraGinjZYpIap0LAT3vg2naR/V1por/scs8+
        bbpReRzqOkqvYnq2nHP2dCHx/rF+mzs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-JmTpG22gOgSk-_r5avEp-Q-1; Mon, 04 Nov 2019 05:00:46 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E0D18017DD;
        Mon,  4 Nov 2019 10:00:45 +0000 (UTC)
Received: from [10.36.118.62] (unknown [10.36.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 027185D9E5;
        Mon,  4 Nov 2019 10:00:41 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] s390x: Use loop to save and restore fprs
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, pmorel@linux.ibm.com
References: <20191104085533.2892-1-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <284994ac-6d9d-d5b5-5030-2c612f74bf42@redhat.com>
Date:   Mon, 4 Nov 2019 11:00:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191104085533.2892-1-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: JmTpG22gOgSk-_r5avEp-Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.19 09:55, Janosch Frank wrote:
> Let's save some lines in the assembly by using a loop to save and
> restore the fprs.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/cstart64.S | 38 ++++++--------------------------------
>   1 file changed, 6 insertions(+), 32 deletions(-)
>=20
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 5dc1577..8e2b21e 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -99,44 +99,18 @@ memsetxc:
>   =09lctlg=09%c0, %c0, 0(%r1)
>   =09/* save fprs 0-15 + fpc */
>   =09la=09%r1, GEN_LC_SW_INT_FPRS
> -=09std=09%f0, 0(%r1)
> -=09std=09%f1, 8(%r1)
> -=09std=09%f2, 16(%r1)
> -=09std=09%f3, 24(%r1)
> -=09std=09%f4, 32(%r1)
> -=09std=09%f5, 40(%r1)
> -=09std=09%f6, 48(%r1)
> -=09std=09%f7, 56(%r1)
> -=09std=09%f8, 64(%r1)
> -=09std=09%f9, 72(%r1)
> -=09std=09%f10, 80(%r1)
> -=09std=09%f11, 88(%r1)
> -=09std=09%f12, 96(%r1)
> -=09std=09%f13, 104(%r1)
> -=09std=09%f14, 112(%r1)
> -=09std=09%f15, 120(%r1)
> +=09.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> +=09std=09\i, \i * 8(%r1)
> +=09.endr
>   =09stfpc=09GEN_LC_SW_INT_FPC
>   =09.endm
>  =20
>   =09.macro RESTORE_REGS
>   =09/* restore fprs 0-15 + fpc */
>   =09la=09%r1, GEN_LC_SW_INT_FPRS
> -=09ld=09%f0, 0(%r1)
> -=09ld=09%f1, 8(%r1)
> -=09ld=09%f2, 16(%r1)
> -=09ld=09%f3, 24(%r1)
> -=09ld=09%f4, 32(%r1)
> -=09ld=09%f5, 40(%r1)
> -=09ld=09%f6, 48(%r1)
> -=09ld=09%f7, 56(%r1)
> -=09ld=09%f8, 64(%r1)
> -=09ld=09%f9, 72(%r1)
> -=09ld=09%f10, 80(%r1)
> -=09ld=09%f11, 88(%r1)
> -=09ld=09%f12, 96(%r1)
> -=09ld=09%f13, 104(%r1)
> -=09ld=09%f14, 112(%r1)
> -=09ld=09%f15, 120(%r1)
> +=09.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> +=09ld=09\i, \i * 8(%r1)
> +=09.endr
>   =09lfpc=09GEN_LC_SW_INT_FPC
>   =09/* restore cr0 */
>   =09lctlg=09%c0, %c0, GEN_LC_SW_INT_CR0
>=20

Looks good to me!

Queued to

https://github.com/davidhildenbrand/kvm-unit-tests.git s390x-next

For now, but waiting for more review.

--=20

Thanks,

David / dhildenb

