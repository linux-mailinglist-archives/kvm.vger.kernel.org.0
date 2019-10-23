Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD7AE19BF
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 14:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391263AbfJWMPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 08:15:11 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57858 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388674AbfJWMPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 08:15:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571832903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=brzb9mL9bRicm62YvbgIc+ZtyaQ6Q9JHnhJ4TvFOCsQ=;
        b=jKXThlGbqUfGufkJQwZYF9zsZuHxgGhq52/ULL9k1/f1+ydwRjhqVt+rW0N9XfO1t2W1WH
        sPLe96pPPlPzom9M7wt41kSXhfAAqcfpYOxXdbD0BeBfltTwQoinnFP43y9A4f2a0JsGUP
        fdd4DHQ+jJyJiu73KfKru418ONCo4Qc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-HdEfJCZBOKKPV0doOKrDhA-1; Wed, 23 Oct 2019 08:14:59 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77A0C5E4;
        Wed, 23 Oct 2019 12:14:58 +0000 (UTC)
Received: from [10.36.117.79] (ovpn-117-79.ams2.redhat.com [10.36.117.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10FDC1001DF2;
        Wed, 23 Oct 2019 12:14:56 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 5/5] s390x: SCLP unit test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <1571741584-17621-1-git-send-email-imbrenda@linux.ibm.com>
 <1571741584-17621-6-git-send-email-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <e8398bc4-f7d4-d83c-e106-3f92fb13304e@redhat.com>
Date:   Wed, 23 Oct 2019 14:14:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1571741584-17621-6-git-send-email-imbrenda@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: HdEfJCZBOKKPV0doOKrDhA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.10.19 12:53, Claudio Imbrenda wrote:
> SCLP unit test. Testing the following:
>=20
> * Correctly ignoring instruction bits that should be ignored
> * Privileged instruction check
> * Check for addressing exceptions
> * Specification exceptions:
>    - SCCB size less than 8
>    - SCCB unaligned
>    - SCCB overlaps prefix or lowcore
>    - SCCB address higher than 2GB
> * Return codes for
>    - Invalid command
>    - SCCB too short (but at least 8)
>    - SCCB page boundary violation
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/Makefile      |   1 +
>   s390x/sclp.c        | 373 +++++++++++++++++++++++++++++++++++++++++++++=
+++++++
>   s390x/unittests.cfg |   3 +
>   3 files changed, 377 insertions(+)
>   create mode 100644 s390x/sclp.c
>=20
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 3744372..ddb4b48 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -16,6 +16,7 @@ tests +=3D $(TEST_DIR)/diag288.elf
>   tests +=3D $(TEST_DIR)/stsi.elf
>   tests +=3D $(TEST_DIR)/skrf.elf
>   tests +=3D $(TEST_DIR)/smp.elf
> +tests +=3D $(TEST_DIR)/sclp.elf
>   tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
>  =20
>   all: directories test_cases test_cases_binary
> diff --git a/s390x/sclp.c b/s390x/sclp.c
> new file mode 100644
> index 0000000..d7a9212
> --- /dev/null
> +++ b/s390x/sclp.c
> @@ -0,0 +1,373 @@
> +/*
> + * Store System Information tests
> + *
> + * Copyright (c) 2019 IBM Corp
> + *
> + * Authors:
> + *  Claudio Imbrenda <imbrenda@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.
> + */
> +
> +#include <libcflat.h>
> +#include <asm/page.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <sclp.h>
> +
> +static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE *=
 2)));
> +static uint8_t prefix_buf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZ=
E * 2)));
> +static uint32_t valid_sclp_code;
> +static struct lowcore *lc;
> +
> +static void sclp_setup_int_test(void)
> +{
> +=09uint64_t mask;
> +
> +=09ctl_set_bit(0, 9);
> +
> +=09mask =3D extract_psw_mask();
> +=09mask |=3D PSW_MASK_EXT;
> +=09load_psw_mask(mask);
> +}
> +
> +static int sclp_service_call_test(unsigned int command, void *sccb)

Wouldn't it be easier to pass an uint8_t*, so you can simply forward=20
pagebuf through all functions?

> +{
> +=09int cc;
> +
> +=09sclp_mark_busy();
> +=09sclp_setup_int_test();
> +=09lc->pgm_int_code =3D 0;
> +=09cc =3D servc(command, __pa(sccb));
> +=09if (lc->pgm_int_code) {
> +=09=09sclp_handle_ext();

You receive a PGM interrupt and handle an external interrupt? That looks=20
strange. Please elaborate what's going on here.

> +=09=09return 0;
> +=09}
> +=09if (!cc)
> +=09=09sclp_wait_busy();
> +=09return cc;
> +}
> +
> +static int test_one_sccb(uint32_t cmd, uint64_t addr, uint16_t len,
> +=09=09=09void *data, uint64_t exp_pgm, uint16_t exp_rc)
> +{
> +=09SCCBHeader *h =3D (SCCBHeader *)addr;
> +=09int res, pgm;
> +
> +=09if (data && len)
> +=09=09memcpy((void *)addr, data, len);
> +=09if (!exp_pgm)
> +=09=09exp_pgm =3D 1;
> +=09expect_pgm_int();
> +=09res =3D sclp_service_call_test(cmd, h);
> +=09if (res) {
> +=09=09report_info("SCLP not ready (command %#x, address %#lx, cc %d)",
> +=09=09=09cmd, addr, res);
> +=09=09return 0;
> +=09}
> +=09pgm =3D lc->pgm_int_code;
> +=09if (!((1ULL << pgm) & exp_pgm)) {
> +=09=09report_info("First failure at addr %#lx, size %d, cmd %#x, pgm cod=
e %d",
> +=09=09=09=09addr, len, cmd, pgm);
> +=09=09return 0;
> +=09}
> +=09if (exp_rc && (exp_rc !=3D h->response_code)) {
> +=09=09report_info("First failure at addr %#lx, size %d, cmd %#x, resp co=
de %#x",
> +=09=09=09=09addr, len, cmd, h->response_code);
> +=09=09return 0;
> +=09}
> +=09return 1;
> +}
> +
> +static int test_one_run(uint32_t cmd, uint64_t addr, uint16_t len,
> +=09=09=09uint16_t clear, uint64_t exp_pgm, uint16_t exp_rc)

I somewhat dislike passing in "exp_pgm" and "exp_rc". Why can't you=20
handle both things in the caller where the tests actually become readable?

> +{
> +=09char sccb[4096];

I prefer uint8_t sccb[PAGE_SIZE]

> +=09void *p =3D sccb;
> +
> +=09if (!len && !clear)
> +=09=09p =3D NULL;
> +=09else
> +=09=09memset(sccb, 0, sizeof(sccb));
> +=09((SCCBHeader *)sccb)->length =3D len;
> +=09if (clear && (clear < 8))
> +=09=09clear =3D 8;

Can you elaborate what "clear" means. It is passed as "length".
/me confused

> +=09return test_one_sccb(cmd, addr, clear, p, exp_pgm, exp_rc);
> +}
> +
> +#define PGM_BIT_SPEC=09(1ULL << PGM_INT_CODE_SPECIFICATION)
> +#define PGM_BIT_ADDR=09(1ULL << PGM_INT_CODE_ADDRESSING)
> +#define PGM_BIT_PRIV=09(1ULL << PGM_INT_CODE_PRIVILEGED_OPERATION)
> +
> +#define PGBUF=09((uintptr_t)pagebuf)
> +#define VALID=09(valid_sclp_code)

I dislike both defines, can you get rid of these?

> +
> +static void test_sccb_too_short(void)
> +{
> +=09int cx;

cx is passed as "len". What does cx stand for? Can we give this a better=20
name?

[...] (not reviewing the other stuff in detail because I am still confused)

> +static void test_resp(void)
> +{
> +=09test_inval();
> +=09test_short();
> +=09test_boundary();
> +=09test_toolong();
> +}

Can you just get rid of this function and call all tests from main?
(just separate them in logical blocks eventually with comments)

> +
> +static void test_priv(void)
> +{
> +=09pagebuf[0] =3D 0;
> +=09pagebuf[1] =3D 8;
> +=09expect_pgm_int();
> +=09enter_pstate();
> +=09servc(valid_sclp_code, __pa(pagebuf));
> +=09report_prefix_push("Priv check");
> +=09check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +=09report_prefix_pop();

Can we push at the beginning of the function and pop at the end?

report_prefix_push("Privileged Operation");

expect_pgm_int();
enter_pstate();
servc(valid_sclp_code, __pa(pagebuf));
check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);

report_prefix_pop();

Also shouldn't you better mark sclp busy and wait for interrupts to make
sore you handle it correctly in case the check *fails* and servc=20
completes (cc=3D=3D0)?

> +}
> +
> +static void test_addressing(void)
> +{
> +=09unsigned long cx, maxram =3D get_ram_size();
> +
> +=09if (maxram >=3D 0x80000000) {
> +=09=09report_skip("Invalid SCCB address");
> +=09=09return;
> +=09}

Do we really need maxram here, can't we simply use very high addresses=20
like in all other tests?

E.g. just user address "-PAGE_SIZE"

> +=09for (cx =3D maxram; cx < MIN(maxram + 65536, 0x80000000); cx +=3D 8)
> +=09=09if (!test_one_run(VALID, cx, 0, 0, PGM_BIT_ADDR, 0))
> +=09=09=09goto out;
> +=09for (; cx < MIN((maxram + 0x7fffff) & ~0xfffff, 0x80000000); cx +=3D =
4096)
> +=09=09if (!test_one_run(VALID, cx, 0, 0, PGM_BIT_ADDR, 0))
> +=09=09=09goto out;
> +=09for (; cx < 0x80000000; cx +=3D 1048576)
> +=09=09if (!test_one_run(VALID, cx, 0, 0, PGM_BIT_ADDR, 0))
> +=09=09=09goto out;
> +out:
> +=09report("Invalid SCCB address", cx =3D=3D 0x80000000);
> +}
> +
> +static void test_instbits(void)
> +{
> +=09SCCBHeader *h =3D (SCCBHeader *)pagebuf;
> +=09unsigned long mask;
> +=09int cc;
> +
> +=09sclp_mark_busy();
> +=09h->length =3D 8;
> +
> +=09ctl_set_bit(0, 9);
> +=09mask =3D extract_psw_mask();
> +=09mask |=3D PSW_MASK_EXT;
> +=09load_psw_mask(mask);
> +
> +=09asm volatile(
> +=09=09"       .insn   rre,0xb2204200,%1,%2\n"  /* servc %1,%2 */
> +=09=09"       ipm     %0\n"
> +=09=09"       srl     %0,28"
> +=09=09: "=3D&d" (cc) : "d" (valid_sclp_code), "a" (__pa(pagebuf))
> +=09=09: "cc", "memory");
> +=09sclp_wait_busy();
> +=09report("Instruction format ignored bits", cc =3D=3D 0);
> +}
> +
> +static void find_valid_sclp_code(void)
> +{
> +=09unsigned int commands[] =3D { SCLP_CMDW_READ_SCP_INFO_FORCED,
> +=09=09=09=09    SCLP_CMDW_READ_SCP_INFO };
> +=09SCCBHeader *h =3D (SCCBHeader *)pagebuf;
> +=09int i, cc;
> +
> +=09for (i =3D 0; i < ARRAY_SIZE(commands); i++) {
> +=09=09sclp_mark_busy();
> +=09=09memset(h, 0, sizeof(pagebuf));
> +=09=09h->length =3D 4096;
> +
> +=09=09valid_sclp_code =3D commands[i];
> +=09=09cc =3D sclp_service_call(commands[i], h);
> +=09=09if (cc)
> +=09=09=09break;
> +=09=09if (h->response_code =3D=3D SCLP_RC_NORMAL_READ_COMPLETION)
> +=09=09=09return;
> +=09=09if (h->response_code !=3D SCLP_RC_INVALID_SCLP_COMMAND)
> +=09=09=09break;
> +=09}
> +=09valid_sclp_code =3D 0;
> +=09report_abort("READ_SCP_INFO failed");
> +}
> +
> +int main(void)
> +{
> +=09report_prefix_push("sclp");
> +=09find_valid_sclp_code();
> +=09test_instbits();
> +=09test_priv();
> +=09test_addressing();
> +=09test_spec();
> +=09test_resp();
> +=09return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index f1b07cd..75e3d37 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -75,3 +75,6 @@ file =3D stsi.elf
>   [smp]
>   file =3D smp.elf
>   extra_params =3D-smp 2
> +
> +[sclp]
> +file =3D sclp.elf
>=20


--=20

Thanks,

David / dhildenb

