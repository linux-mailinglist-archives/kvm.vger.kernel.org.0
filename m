Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202F2F0653
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 20:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfKETxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 14:53:22 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23966 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726368AbfKETxV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Nov 2019 14:53:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572983599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cs8rrq4D6iWgBd/KEbQ97aB2BdD9wmZzx9N28weGUpo=;
        b=U4v6h0OB5s7V6ZULhNw+6qslPOVUHO6jBrEKYwgwLCKMXG//gIRu9QOt9VYijvqiLJ4vWv
        R8L0W/UCbZ1uZS44aqA+l6hXNmu5IP3XEEk+XfiSvG6fRyTisgE7iNgQ79s3ZpVJenDbkP
        LILaHlQLK9Txy8yDvvxDdnwpfgKnDGU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-BNB7lTiQOwONKOtuyzk4DQ-1; Tue, 05 Nov 2019 14:53:16 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BD0D107ACC3;
        Tue,  5 Nov 2019 19:53:15 +0000 (UTC)
Received: from [10.36.116.98] (ovpn-116-98.ams2.redhat.com [10.36.116.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 843BD60BF4;
        Tue,  5 Nov 2019 19:53:14 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: Remove DAT and add short
 indication psw bits on diag308 reset
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com
References: <20191105162828.2490-1-frankja@linux.ibm.com>
 <20191105162828.2490-3-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <15a9d438-d906-dcc6-0bda-8c6b049c946d@redhat.com>
Date:   Tue, 5 Nov 2019 20:53:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191105162828.2490-3-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: BNB7lTiQOwONKOtuyzk4DQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05.11.19 17:28, Janosch Frank wrote:

In the subject "Disable" vs. "Remove" ?

> On a diag308 subcode 0 CRs will be reset, so we need to mask of PSW
> DAT indication until we restore our CRs.
>=20
> Also we need to set the short psw indication to be compliant with the
> architecture.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/asm-offsets.c  |  1 +
>   lib/s390x/asm/arch_def.h |  3 ++-
>   s390x/cstart64.S         | 20 ++++++++++++++------
>   3 files changed, 17 insertions(+), 7 deletions(-)
>=20
> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
> index 4b213f8..61d2658 100644
> --- a/lib/s390x/asm-offsets.c
> +++ b/lib/s390x/asm-offsets.c
> @@ -58,6 +58,7 @@ int main(void)
>   =09OFFSET(GEN_LC_SW_INT_FPRS, lowcore, sw_int_fprs);
>   =09OFFSET(GEN_LC_SW_INT_FPC, lowcore, sw_int_fpc);
>   =09OFFSET(GEN_LC_SW_INT_CRS, lowcore, sw_int_crs);
> +=09OFFSET(GEN_LC_SW_INT_PSW, lowcore, sw_int_psw);
>   =09OFFSET(GEN_LC_MCCK_EXT_SA_ADDR, lowcore, mcck_ext_sa_addr);
>   =09OFFSET(GEN_LC_FPRS_SA, lowcore, fprs_sa);
>   =09OFFSET(GEN_LC_GRS_SA, lowcore, grs_sa);
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 07d4e5e..7d25e4f 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -79,7 +79,8 @@ struct lowcore {
>   =09uint32_t=09sw_int_fpc;=09=09=09/* 0x0300 */
>   =09uint8_t=09=09pad_0x0304[0x0308 - 0x0304];=09/* 0x0304 */
>   =09uint64_t=09sw_int_crs[16];=09=09=09/* 0x0308 */
> -=09uint8_t=09=09pad_0x0310[0x11b0 - 0x0388];=09/* 0x0388 */
> +=09struct psw=09sw_int_psw;=09=09=09/* 0x0388 */
> +=09uint8_t=09=09pad_0x0310[0x11b0 - 0x0390];=09/* 0x0390 */
>   =09uint64_t=09mcck_ext_sa_addr;=09=09/* 0x11b0 */
>   =09uint8_t=09=09pad_0x11b8[0x1200 - 0x11b8];=09/* 0x11b8 */
>   =09uint64_t=09fprs_sa[16];=09=09=09/* 0x1200 */
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 0455591..2e0dcf5 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -129,8 +129,15 @@ memsetxc:
>   .globl diag308_load_reset
>   diag308_load_reset:
>   =09SAVE_REGS
> -=09/* Save the first PSW word to the IPL PSW */
> +=09/* Backup current PSW */

/*
  * Backup the current PSW MASK, as we have to restore it on
  * success.
  */

>   =09epsw=09%r0, %r1
> +=09st=09%r0, GEN_LC_SW_INT_PSW
> +=09st=09%r1, GEN_LC_SW_INT_PSW + 4

I was confused at first, but then I realized that you really only store=20
the PSW mask here and not also the PSW address ...


> +=09/* Disable DAT as the CRs will be reset too */
> +=09nilh=09%r0, 0xfbff
> +=09/* Add psw bit 12 to indicate short psw */
> +=09oilh=09%r0, 0x0008

Why care about the old PSW mask here at all? Wouldn't it be easier to=20
just construct a new PSW mask from scratch? (64bit, PSW bit 12 set ...)

Save it somewhere and just load it directly from memory.

> +=09/* Save the first PSW word to the IPL PSW */
>   =09st=09%r0, 0
>   =09/* Store the address and the bit for 31 bit addressing */
>   =09larl    %r0, 0f
> @@ -142,12 +149,13 @@ diag308_load_reset:
>   =09xgr=09%r2, %r2
>   =09br=09%r14
>   =09/* Success path */
> -=09/* We lost cr0 due to the reset */
> -0:=09larl=09%r1, initial_cr0
> -=09lctlg=09%c0, %c0, 0(%r1)
> -=09RESTORE_REGS
> +=09/* Switch to z/Architecture mode and 64-bit */
> +0:=09RESTORE_REGS
>   =09lhi=09%r2, 1
> -=09br=09%r14
> +=09larl=09%r0, 1f
> +=09stg=09%r0, GEN_LC_SW_INT_PSW + 8
> +=09lpswe=09GEN_LC_SW_INT_PSW
> +1:=09br=09%r14
>  =20
>   .globl smp_cpu_setup_state
>   smp_cpu_setup_state:
>=20


--=20

Thanks,

David / dhildenb

