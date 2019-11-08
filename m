Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4549FF42EA
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 10:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbfKHJPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 04:15:18 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32680 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730005AbfKHJPS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Nov 2019 04:15:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573204516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lg6bhAYAhOfeB0yDp6BWf3FiCrFGttRnQeXN92whASM=;
        b=MCKszXjHU4xOCg4Pfd7IEFW66YjcwiAzC9liqAxeHMivaeXjO/OfXjq/Ux7upJMFn/EqXd
        4Bs65tBEZJmmDT7rm9cMZZLTVFiO5g1yj3Cvpq9V3HCH6M0TruyOuwwvVPZwWvsasyclxt
        4KqjDePLDHMmkU4r/3ItU64aKjugS3o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-KFptTM_7MjKoCvmSN_658g-1; Fri, 08 Nov 2019 04:15:09 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE3F1180496F;
        Fri,  8 Nov 2019 09:15:08 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-167.ams2.redhat.com [10.36.116.167])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97B055DA70;
        Fri,  8 Nov 2019 09:15:03 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] s390x: Use loop to save and restore fprs
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, pmorel@linux.ibm.com
References: <20191104085533.2892-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <5dfe4c62-5178-3e9c-b1bb-6814e020078e@redhat.com>
Date:   Fri, 8 Nov 2019 10:15:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191104085533.2892-1-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: KFptTM_7MjKoCvmSN_658g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/2019 09.55, Janosch Frank wrote:
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

Produces exactly the same code as before.

Tested-by: Thomas Huth <thuth@redhat.com>

