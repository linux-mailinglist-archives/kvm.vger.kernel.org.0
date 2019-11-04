Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3EBEEDD2C
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 11:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbfKDK6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 05:58:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20764 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728542AbfKDK6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 05:58:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572865107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/iLNSfBwhqMep9Ci+mLp8ZqdTst9O4Sqs3TEtOvgT3g=;
        b=ZOHxdvQeSKppZN0BMDt82Yj/iqNn81rO63oZen9paJz8ioFvwC7tCK60Q+a4CswQ7FVnlq
        kR0Q9a1LYAT+aj8badg2XXME5JqcTjE11KRiQduHlI6cH0G+h/77a+G0/LCX6vGY1pYcuu
        lUvVvk653lfH8B2ArkxtTNohOwU88tA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-xp7ytAf1Meic10cw3Fqc9Q-1; Mon, 04 Nov 2019 05:58:23 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBB2F800C73;
        Mon,  4 Nov 2019 10:58:22 +0000 (UTC)
Received: from [10.36.118.62] (unknown [10.36.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36A89600C4;
        Mon,  4 Nov 2019 10:58:21 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 5/5] s390x: SCLP unit test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
 <1572023194-14370-6-git-send-email-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <1df14176-20a7-a9af-5622-2853425d973e@redhat.com>
Date:   Mon, 4 Nov 2019 11:58:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1572023194-14370-6-git-send-email-imbrenda@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: xp7ytAf1Meic10cw3Fqc9Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25.10.19 19:06, Claudio Imbrenda wrote:
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
>   s390x/sclp.c        | 413 +++++++++++++++++++++++++++++++++++++++++++++=
+++++++
>   s390x/unittests.cfg |   3 +
>   3 files changed, 417 insertions(+)
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
> index 0000000..29ac265
> --- /dev/null
> +++ b/s390x/sclp.c
> @@ -0,0 +1,413 @@
> +/*
> + * Service Call tests
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
> +#define PGM_BIT_SPEC=09(1ULL << PGM_INT_CODE_SPECIFICATION)
> +#define PGM_BIT_ADDR=09(1ULL << PGM_INT_CODE_ADDRESSING)
> +#define PGM_BIT_PRIV=09(1ULL << PGM_INT_CODE_PRIVILEGED_OPERATION)
> +#define MKPTR(x) ((void *)(uint64_t)(x))
> +
> +static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE *=
 2)));
> +static uint8_t prefix_buf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZ=
E * 2)));
> +static uint8_t sccb_template[PAGE_SIZE];
> +static uint32_t valid_code;
> +static struct lowcore *lc;
> +
> +/**
> + * Enable SCLP interrupt.
> + */
> +static void sclp_setup_int_test(void)
> +{
> +=09uint64_t mask;
> +
> +=09ctl_set_bit(0, 9);
> +=09mask =3D extract_psw_mask();
> +=09mask |=3D PSW_MASK_EXT;
> +=09load_psw_mask(mask);
> +}
> +
> +/**
> + * Perform one service call, handling exceptions and interrupts.
> + */
> +static int sclp_service_call_test(unsigned int command, void *sccb)
> +{
> +=09int cc;
> +
> +=09sclp_mark_busy();
> +=09sclp_setup_int_test();
> +=09lc->pgm_int_code =3D 0;
> +=09cc =3D servc(command, __pa(sccb));
> +=09if (lc->pgm_int_code) {
> +=09=09sclp_handle_ext();
> +=09=09return 0;
> +=09}
> +=09if (!cc)
> +=09=09sclp_wait_busy();
> +=09return cc;
> +}
> +
> +/**
> + * Perform one test at the given address, optionally using the SCCB temp=
late,
> + * checking for the expected program interrupts and return codes.
> + */
> +static int test_one_sccb(uint32_t cmd, uint8_t *addr, uint16_t len,
> +=09=09=09uint64_t exp_pgm, uint16_t exp_rc)
> +{
> +=09SCCBHeader *h =3D (SCCBHeader *)addr;
> +=09int res, pgm;
> +
> +=09if (len)
> +=09=09memcpy(addr, sccb_template, len);
> +=09if (!exp_pgm)
> +=09=09exp_pgm =3D 1;
> +=09expect_pgm_int();
> +=09res =3D sclp_service_call_test(cmd, h);
> +=09if (res) {
> +=09=09report_info("SCLP not ready (command %#x, address %p, cc %d)", cmd=
, addr, res);
> +=09=09return 0;
> +=09}
> +=09pgm =3D lc->pgm_int_code;
> +=09if (!((1ULL << pgm) & exp_pgm)) {
> +=09=09report_info("First failure at addr %p, size %d, cmd %#x, pgm code =
%d", addr, len, cmd, pgm);
> +=09=09return 0;
> +=09}
> +=09if (exp_rc && (exp_rc !=3D h->response_code)) {
> +=09=09report_info("First failure at addr %p, size %d, cmd %#x, resp code=
 %#x",
> +=09=09=09=09addr, len, cmd, h->response_code);
> +=09=09return 0;
> +=09}
> +=09return 1;
> +}
> +
> +/**
> + * Wrapper for test_one_sccb to set up an SCCB template
> + */
> +static int test_one_run(uint32_t cmd, uint8_t *addr, uint16_t sccb_len,
> +=09=09=09uint16_t buf_len, uint64_t exp_pgm, uint16_t exp_rc)
> +{
> +=09if (buf_len)
> +=09=09memset(sccb_template, 0, sizeof(sccb_template));
> +=09((SCCBHeader *)sccb_template)->length =3D sccb_len;
> +=09if (buf_len && buf_len < 8)
> +=09=09buf_len =3D 8;
> +=09return test_one_sccb(cmd, addr, buf_len, exp_pgm, exp_rc);
> +}
> +
> +/**
> + * Test SCCB lengths < 8
> + */
> +static void test_sccb_too_short(void)
> +{
> +=09int cx;
> +
> +=09for (cx =3D 0; cx < 8; cx++)
> +=09=09if (!test_one_run(valid_code, pagebuf, cx, 8, PGM_BIT_SPEC, 0))
> +=09=09=09break;
> +
> +=09report("SCCB too short", cx =3D=3D 8);
> +}
> +
> +/**
> + * Test SCCBs that are not 64bits aligned
> + */
> +static void test_sccb_unaligned(void)
> +{
> +=09int cx;
> +
> +=09for (cx =3D 1; cx < 8; cx++)
> +=09=09if (!test_one_run(valid_code, cx + pagebuf, 8, 8, PGM_BIT_SPEC, 0)=
)
> +=09=09=09break;
> +=09report("SCCB unaligned", cx =3D=3D 8);
> +}
> +
> +/**
> + * Test SCCBs whose address is in the lowcore or prefix area
> + */
> +static void test_sccb_prefix(void)
> +{
> +=09uint32_t prefix, new_prefix;
> +=09int cx;
> +
> +=09// can't actually trash the lowcore, unsurprisingly things break if w=
e do
> +=09for (cx =3D 0; cx < 8192; cx +=3D 8)
> +=09=09if (!test_one_sccb(valid_code, MKPTR(cx), 0, PGM_BIT_SPEC, 0))
> +=09=09=09break;
> +=09report("SCCB low pages", cx =3D=3D 8192);
> +
> +=09memcpy(prefix_buf, 0, 8192);
> +=09new_prefix =3D (uint32_t)(intptr_t)prefix_buf;
> +=09asm volatile("stpx %0" : "=3DQ" (prefix));
> +=09asm volatile("spx %0" : : "Q" (new_prefix) : "memory");
> +
> +=09for (cx =3D 0; cx < 8192; cx +=3D 8)
> +=09=09if (!test_one_run(valid_code, MKPTR(new_prefix + cx), 8, 8, PGM_BI=
T_SPEC, 0))
> +=09=09=09break;
> +=09report("SCCB prefix pages", cx =3D=3D 8192);
> +
> +=09memcpy(prefix_buf, 0, 8192);
> +=09asm volatile("spx %0" : : "Q" (prefix) : "memory");
> +}
> +
> +/**
> + * Test SCCBs that are above 2GB. If outside of memory, an addressing
> + * exception is also allowed.
> + */
> +static void test_sccb_high(void)
> +{
> +=09SCCBHeader *h =3D (SCCBHeader *)pagebuf;
> +=09uintptr_t a[33 * 4 * 2 + 2];
> +=09uint64_t maxram;
> +=09int cx, i, pgm;
> +
> +=09h->length =3D 8;
> +
> +=09i =3D 0;
> +=09for (cx =3D 0; cx < 33; cx++)
> +=09=09a[i++] =3D 1UL << (cx + 31);
> +=09for (cx =3D 0; cx < 33; cx++)
> +=09=09a[i++] =3D 3UL << (cx + 31);
> +=09for (cx =3D 0; cx < 33; cx++)
> +=09=09a[i++] =3D 0xffffffff80000000UL << cx;
> +=09a[i++] =3D 0x80000000;
> +=09for (cx =3D 1; cx < 33; cx++, i++)
> +=09=09a[i] =3D a[i - 1] | (1UL << (cx + 31));
> +=09for (cx =3D 0; cx < i; cx++)
> +=09=09a[i + cx] =3D a[cx] + (intptr_t)pagebuf;
> +=09i +=3D cx;
> +=09a[i++] =3D 0xdeadbeef00000000;
> +=09a[i++] =3D 0xdeaddeadbeef0000;
> +
> +=09maxram =3D get_ram_size();
> +=09for (cx =3D 0; cx < i; cx++) {
> +=09=09pgm =3D PGM_BIT_SPEC | (a[cx] >=3D maxram ? PGM_BIT_ADDR : 0);
> +=09=09if (!test_one_sccb(valid_code, (void *)a[cx], 0, pgm, 0))
> +=09=09=09break;
> +=09}
> +=09report("SCCB high addresses", cx =3D=3D i);
> +}
> +
> +/**
> + * Test invalid commands, both invalid command detail codes and valid
> + * ones with invalid command class code.
> + */
> +static void test_inval(void)
> +{
> +=09uint32_t cmd;
> +=09int cx;
> +
> +=09report_prefix_push("Invalid command");
> +=09for (cx =3D 0; cx < 65536; cx++) {
> +=09=09cmd =3D (0xdead0000) | cx;
> +=09=09if (!test_one_run(cmd, pagebuf, PAGE_SIZE, PAGE_SIZE, 0, SCLP_RC_I=
NVALID_SCLP_COMMAND))
> +=09=09=09break;
> +=09}
> +=09report("Command detail code", cx =3D=3D 65536);
> +
> +=09for (cx =3D 0; cx < 256; cx++) {
> +=09=09cmd =3D (valid_code & ~0xff) | cx;
> +=09=09if (cmd =3D=3D valid_code)
> +=09=09=09continue;
> +=09=09if (!test_one_run(cmd, pagebuf, PAGE_SIZE, PAGE_SIZE, 0, SCLP_RC_I=
NVALID_SCLP_COMMAND))
> +=09=09=09break;
> +=09}
> +=09report("Command class code", cx =3D=3D 256);
> +=09report_prefix_pop();
> +}
> +
> +
> +/**
> + * Test short SCCBs (but larger than 8).
> + */
> +static void test_short(void)
> +{
> +=09uint16_t res =3D SCLP_RC_INSUFFICIENT_SCCB_LENGTH;
> +=09int cx;
> +
> +=09for (cx =3D 8; cx < 144; cx++)
> +=09=09if (!test_one_run(valid_code, pagebuf, cx, cx, 0, res))
> +=09=09=09break;
> +=09report("Insufficient SCCB length (Read SCP info)", cx =3D=3D 144);
> +
> +=09for (cx =3D 8; cx < 40; cx++)
> +=09=09if (!test_one_run(SCLP_READ_CPU_INFO, pagebuf, cx, cx, 0, res))
> +=09=09=09break;
> +=09report("Insufficient SCCB length (Read CPU info)", cx =3D=3D 40);
> +}
> +
> +/**
> + * Test SCCB page boundary violations.
> + */
> +static void test_boundary(void)
> +{
> +=09uint32_t cmd =3D SCLP_CMD_WRITE_EVENT_DATA;
> +=09uint16_t res =3D SCLP_RC_SCCB_BOUNDARY_VIOLATION;
> +=09WriteEventData *sccb =3D (WriteEventData *)sccb_template;
> +=09int len, cx;
> +
> +=09memset(sccb_template, 0, sizeof(sccb_template));
> +=09sccb->h.function_code =3D SCLP_FC_NORMAL_WRITE;
> +=09for (len =3D 32; len <=3D 4096; len++) {
> +=09=09cx =3D len & 7 ? len & ~7 : len - 8;
> +=09=09for (cx =3D 4096 - cx; cx < 4096; cx +=3D 8) {
> +=09=09=09sccb->h.length =3D len;
> +=09=09=09if (!test_one_sccb(cmd, cx + pagebuf, len, 0, res))
> +=09=09=09=09goto out;
> +=09=09}
> +=09}
> +out:
> +=09report("SCCB page boundary violation", len > 4096 && cx =3D=3D 4096);
> +}
> +
> +static void test_toolong(void)
> +{
> +=09uint32_t cmd =3D SCLP_CMD_WRITE_EVENT_DATA;
> +=09uint16_t res =3D SCLP_RC_SCCB_BOUNDARY_VIOLATION;
> +=09WriteEventData *sccb =3D (WriteEventData *)sccb_template;
> +=09int cx;
> +
> +=09memset(sccb_template, 0, sizeof(sccb_template));
> +=09sccb->h.function_code =3D SCLP_FC_NORMAL_WRITE;
> +=09for (cx =3D 4097; cx < 8192; cx++) {
> +=09=09sccb->h.length =3D cx;
> +=09=09if (!test_one_sccb(cmd, pagebuf, PAGE_SIZE, 0, res))
> +=09=09=09break;
> +=09}
> +=09report("SCCB bigger than 4k", cx =3D=3D 8192);
> +}
> +
> +/**
> + * Test privileged operation.
> + */
> +static void test_priv(void)
> +{
> +=09report_prefix_push("Privileged operation");
> +=09pagebuf[0] =3D 0;
> +=09pagebuf[1] =3D 8;
> +=09expect_pgm_int();
> +=09enter_pstate();
> +=09servc(valid_code, __pa(pagebuf));
> +=09check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +=09report_prefix_pop();
> +}
> +
> +/**
> + * Test addressing exceptions. We need to test SCCB addresses between th=
e
> + * end of available memory and 2GB, because after 2GB a specification
> + * exception is also allowed.
> + * Only applicable if the VM has less than 2GB of memory
> + */
> +static void test_addressing(void)
> +{
> +=09unsigned long cx, maxram =3D get_ram_size();
> +
> +=09if (maxram >=3D 0x80000000) {
> +=09=09report_skip("Invalid SCCB address");
> +=09=09return;
> +=09}
> +=09for (cx =3D maxram; cx < MIN(maxram + 65536, 0x80000000); cx +=3D 8)
> +=09=09if (!test_one_sccb(valid_code, (void *)cx, 0, PGM_BIT_ADDR, 0))
> +=09=09=09goto out;
> +=09for (; cx < MIN((maxram + 0x7fffff) & ~0xfffff, 0x80000000); cx +=3D =
4096)
> +=09=09if (!test_one_sccb(valid_code, (void *)cx, 0, PGM_BIT_ADDR, 0))
> +=09=09=09goto out;
> +=09for (; cx < 0x80000000; cx +=3D 1048576)
> +=09=09if (!test_one_sccb(valid_code, (void *)cx, 0, PGM_BIT_ADDR, 0))
> +=09=09=09goto out;
> +out:
> +=09report("Invalid SCCB address", cx =3D=3D 0x80000000);
> +}
> +
> +/**
> + * Test some bits in the instruction format that are specified to be ign=
ored.
> + */
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
> +=09=09: "=3D&d" (cc) : "d" (valid_code), "a" (__pa(pagebuf))
> +=09=09: "cc", "memory");
> +=09sclp_wait_busy();
> +=09report("Instruction format ignored bits", cc =3D=3D 0);
> +}
> +
> +/**
> + * Find a valid SCLP command code; not all codes are always allowed, and
> + * probing should be performed in the right order.
> + */
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
> +=09=09valid_code =3D commands[i];
> +=09=09cc =3D sclp_service_call(commands[i], h);
> +=09=09if (cc)
> +=09=09=09break;
> +=09=09if (h->response_code =3D=3D SCLP_RC_NORMAL_READ_COMPLETION)
> +=09=09=09return;
> +=09=09if (h->response_code !=3D SCLP_RC_INVALID_SCLP_COMMAND)
> +=09=09=09break;
> +=09}
> +=09valid_code =3D 0;
> +=09report_abort("READ_SCP_INFO failed");
> +}
> +
> +int main(void)
> +{
> +=09report_prefix_push("sclp");
> +=09find_valid_sclp_code();
> +
> +=09/* Test some basic things */
> +=09test_instbits();
> +=09test_priv();
> +=09test_addressing();
> +
> +=09/* Test the specification exceptions */
> +=09test_sccb_too_short();
> +=09test_sccb_unaligned();
> +=09test_sccb_prefix();
> +=09test_sccb_high();
> +
> +=09/* Test the expected response codes */
> +=09test_inval();
> +=09test_short();
> +=09test_boundary();
> +=09test_toolong();
> +
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

Can we just please rename all "cx" into something like "len"? Or is=20
there a real need to have "cx" in there?

Also, I still dislike "test_one_sccb". Can't we just just do something like

expect_pgm_int();
rc =3D test_one_sccb(...)
report("whatever pgm", rc =3D=3D WHATEVER);
report("whatever rc", lc->pgm_int_code =3D=3D WHATEVER);

In the callers to make these tests readable and cleanup test_one_sccb().=20
I don't care if that produces more LOC as long as I can actually read=20
and understand the test cases.

--=20

Thanks,

David / dhildenb

