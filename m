Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7D9F8F53
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 13:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKLMJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 07:09:38 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57722 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725985AbfKLMJh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Nov 2019 07:09:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573560576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=ib8eycrzl7GMxLwxmatqd1xayK0unDedp/MxbI7BmQ0=;
        b=EvcfmoO3eUsI+e7A8HRBfzkbNqwYODej5bvb7JmTF+Ocmdqqq9EuDTFUEqOglXEOoPzClY
        88Y8/fod6yimYUk1xswfsoxeXll+2mNPQI0D9+QVHBtEpNINaQMoEDbf/RYeSWLbZa0fBs
        ezuBAZbhHky09WbwhECjVv704j3Jj04=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-bmYKDYoEMLyDDOE8PVUNmA-1; Tue, 12 Nov 2019 07:09:34 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F34B285B6F4;
        Tue, 12 Nov 2019 12:09:33 +0000 (UTC)
Received: from [10.36.117.126] (ovpn-117-126.ams2.redhat.com [10.36.117.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF09B6018D;
        Tue, 12 Nov 2019 12:09:31 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Load reset psw on diag308
 reset
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com
References: <20191111153345.22505-1-frankja@linux.ibm.com>
 <20191111153345.22505-4-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <7683adc7-2cd0-1103-d231-8a1577f1e673@redhat.com>
Date:   Tue, 12 Nov 2019 13:09:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191111153345.22505-4-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: bmYKDYoEMLyDDOE8PVUNmA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11.11.19 16:33, Janosch Frank wrote:
> On a diag308 subcode 0 CRs will be reset, so we need a PSW mask
> without DAT. Also we need to set the short psw indication to be
> compliant with the architecture.
>=20
> Let's therefore define a reset PSW mask with 64 bit addressing and
> short PSW indication that is compliant with architecture and use it.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm-offsets.c  |  1 +
>  lib/s390x/asm/arch_def.h |  3 ++-
>  s390x/cstart64.S         | 24 +++++++++++++++++-------
>  3 files changed, 20 insertions(+), 8 deletions(-)
>=20
> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
> index 4b213f8..61d2658 100644
> --- a/lib/s390x/asm-offsets.c
> +++ b/lib/s390x/asm-offsets.c
> @@ -58,6 +58,7 @@ int main(void)
>  =09OFFSET(GEN_LC_SW_INT_FPRS, lowcore, sw_int_fprs);
>  =09OFFSET(GEN_LC_SW_INT_FPC, lowcore, sw_int_fpc);
>  =09OFFSET(GEN_LC_SW_INT_CRS, lowcore, sw_int_crs);
> +=09OFFSET(GEN_LC_SW_INT_PSW, lowcore, sw_int_psw);
>  =09OFFSET(GEN_LC_MCCK_EXT_SA_ADDR, lowcore, mcck_ext_sa_addr);
>  =09OFFSET(GEN_LC_FPRS_SA, lowcore, fprs_sa);
>  =09OFFSET(GEN_LC_GRS_SA, lowcore, grs_sa);
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 07d4e5e..7d25e4f 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -79,7 +79,8 @@ struct lowcore {
>  =09uint32_t=09sw_int_fpc;=09=09=09/* 0x0300 */
>  =09uint8_t=09=09pad_0x0304[0x0308 - 0x0304];=09/* 0x0304 */
>  =09uint64_t=09sw_int_crs[16];=09=09=09/* 0x0308 */
> -=09uint8_t=09=09pad_0x0310[0x11b0 - 0x0388];=09/* 0x0388 */
> +=09struct psw=09sw_int_psw;=09=09=09/* 0x0388 */
> +=09uint8_t=09=09pad_0x0310[0x11b0 - 0x0390];=09/* 0x0390 */
>  =09uint64_t=09mcck_ext_sa_addr;=09=09/* 0x11b0 */
>  =09uint8_t=09=09pad_0x11b8[0x1200 - 0x11b8];=09/* 0x11b8 */
>  =09uint64_t=09fprs_sa[16];=09=09=09/* 0x1200 */
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 4be20fc..86dd4c4 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -126,13 +126,18 @@ memsetxc:
>  .globl diag308_load_reset
>  diag308_load_reset:
>  =09SAVE_REGS
> -=09/* Save the first PSW word to the IPL PSW */
> +=09/* Backup current PSW mask, as we have to restore it on success */
>  =09epsw=09%r0, %r1
> -=09st=09%r0, 0
> -=09/* Store the address and the bit for 31 bit addressing */
> -=09larl    %r0, 0f
> -=09oilh    %r0, 0x8000
> -=09st      %r0, 0x4
> +=09st=09%r0, GEN_LC_SW_INT_PSW
> +=09st=09%r1, GEN_LC_SW_INT_PSW + 4
> +=09/* Load reset psw mask (short psw, 64 bit) */
> +=09lg=09%r0, reset_psw
> +=09/* Load the success label address */
> +=09larl    %r1, 0f
> +=09/* Or it to the mask */
> +=09ogr=09%r0, %r1
> +=09/* Store it at the reset PSW location (real 0x0) */
> +=09stg=09%r0, 0
>  =09/* Do the reset */
>  =09diag    %r0,%r2,0x308
>  =09/* Failure path */
> @@ -144,7 +149,10 @@ diag308_load_reset:
>  =09lctlg=09%c0, %c0, 0(%r1)
>  =09RESTORE_REGS
>  =09lhi=09%r2, 1
> -=09br=09%r14
> +=09larl=09%r0, 1f
> +=09stg=09%r0, GEN_LC_SW_INT_PSW + 8
> +=09lpswe=09GEN_LC_SW_INT_PSW
> +1:=09br=09%r14
> =20
>  .globl smp_cpu_setup_state
>  smp_cpu_setup_state:
> @@ -184,6 +192,8 @@ svc_int:
>  =09lpswe=09GEN_LC_SVC_OLD_PSW
> =20
>  =09.align=098
> +reset_psw:
> +=09.quad=090x0008000180000000
>  initial_psw:
>  =09.quad=090x0000000180000000, clear_bss_start
>  pgm_int_psw:
>=20

This patch breaks the smp test under TCG (no clue and no time to look
into the details :) ):

timeout -k 1s --foreground 90s
/home/dhildenb/git/qemu/s390x-softmmu/qemu-system-s390x -nodefaults
-nographic -machine s390-ccw-virtio,accel=3Dtcg -chardev stdio,id=3Dcon0
-device sclpconsole,chardev=3Dcon0 -kernel s390x/smp.elf -smp 1 -smp 2 #
-initrd /tmp/tmp.EDi4y0tv58
SMP: Initializing, found 2 cpus
PASS: smp: start
PASS: smp: stop
FAIL: smp: stop store status: prefix
PASS: smp: stop store status: stack
PASS: smp: store status at address: running: incorrect state
PASS: smp: store status at address: running: status not written
PASS: smp: store status at address: stopped: status written
PASS: smp: ecall: ecall
PASS: smp: emcall: ecall
PASS: smp: cpu reset: cpu stopped
PASS: smp: reset initial: clear: psw
PASS: smp: reset initial: clear: prefix
PASS: smp: reset initial: clear: fpc
PASS: smp: reset initial: clear: cpu timer
PASS: smp: reset initial: clear: todpr
PASS: smp: reset initial: initialized: cr0 =3D=3D 0xE0
PASS: smp: reset initial: initialized: cr14 =3D=3D 0xC2000000
PASS: smp: reset initial: cpu stopped
SUMMARY: 18 tests, 1 unexpected failures


--=20

Thanks,

David / dhildenb

