Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBCBFAD08
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 10:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKMJem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 04:34:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31600 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725996AbfKMJem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 04:34:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573637680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fsYTnBjP63T9SHteksKR7xiMx3MCdvm+lEPiCcxmOSM=;
        b=gogIgVruh5MIEnlahgrgXtm7wEzF1tCmbFimP9R18Z72vjiHxtznwrzDtpMMkbUlXZI9ns
        63kaHQjkC9uebO8zA07Xm4FoWVbDap2q1srl3g81/ervkiOONb8sbhDdeW7mJT8fyaVbtC
        AUI4BU5Q+/HFiAcfMiexcv//AEqTOPU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-Hc9usMlJO0mYUkqBjoCjpA-1; Wed, 13 Nov 2019 04:34:37 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1678B11077B2;
        Wed, 13 Nov 2019 09:34:36 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D28C828DCA;
        Wed, 13 Nov 2019 09:34:04 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 2/2] s390x: SCLP unit test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <1573492826-24589-1-git-send-email-imbrenda@linux.ibm.com>
 <1573492826-24589-3-git-send-email-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <fe853e54-ef79-ed94-eaf8-18b2acfd95f5@redhat.com>
Date:   Wed, 13 Nov 2019 10:34:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1573492826-24589-3-git-send-email-imbrenda@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: Hc9usMlJO0mYUkqBjoCjpA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/2019 18.20, Claudio Imbrenda wrote:
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
[...]
> +
> +#define PGM_NONE=091
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

I don't have a strong opinion here, but I think I'd slightly prefer to
use the function from lib/s390x/sclp.c instead, too.

> +/**
> + * Perform one service call, handling exceptions and interrupts.
> + */
> +static int sclp_service_call_test(unsigned int command, void *sccb)
> +{
> +=09int cc;
> +
> +=09sclp_mark_busy();
> +=09sclp_setup_int_test();
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

I think you should at least mention the meaning of the "len" parameter
here, otherwise this is rather confusing (see below, my comment to
sccb_template).

> + * checking for the expected program interrupts and return codes.
> + * Returns 1 in case of success or 0 in case of failure

Could use bool with true + false instead.

> + */
> +static int test_one_sccb(uint32_t cmd, uint8_t *addr, uint16_t len, uint=
64_t exp_pgm, uint16_t exp_rc)
> +{
> +=09SCCBHeader *h =3D (SCCBHeader *)addr;
> +=09int res, pgm;
> +
> +=09/* Copy the template to the test address if needed */
> +=09if (len)
> +=09=09memcpy(addr, sccb_template, len);

Honestly, that sccb_template is rather confusing. Why does the caller
has to provide both, the data in the sccb_template and the "addr"
variable for yet another buffer? Wouldn't it be simpler if the caller
simply sets up everything in a place of choice and then only passes the
"addr" to the buffer?

> +=09expect_pgm_int();
> +=09res =3D sclp_service_call_test(cmd, h);
> +=09if (res) {
> +=09=09report_info("SCLP not ready (command %#x, address %p, cc %d)", cmd=
, addr, res);
> +=09=09return 0;
> +=09}
> +=09pgm =3D clear_pgm_int();
> +=09/* Check if the program exception was one of the expected ones */
> +=09if (!((1ULL << pgm) & exp_pgm)) {
> +=09=09report_info("First failure at addr %p, size %d, cmd %#x, pgm code =
%d", addr, len, cmd, pgm);
> +=09=09return 0;
> +=09}
> +=09/* Check if the response code is the one expected */
> +=09if (exp_rc && (exp_rc !=3D h->response_code)) {

You can drop the parentheses around "exp_rc !=3D h->response_code".

> +=09=09report_info("First failure at addr %p, size %d, cmd %#x, resp code=
 %#x",
> +=09=09=09=09addr, len, cmd, h->response_code);
> +=09=09return 0;
> +=09}
> +=09return 1;
> +}
> +
> +/**
> + * Wrapper for test_one_sccb to set up a simple SCCB template.
> + * Returns 1 in case of success or 0 in case of failure
> + */
> +static int test_one_simple(uint32_t cmd, uint8_t *addr, uint16_t sccb_le=
n,
> +=09=09=09uint16_t buf_len, uint64_t exp_pgm, uint16_t exp_rc)
> +{
> +=09if (buf_len)
> +=09=09memset(sccb_template, 0, sizeof(sccb_template));
> +=09((SCCBHeader *)sccb_template)->length =3D sccb_len;
> +=09return test_one_sccb(cmd, addr, buf_len, exp_pgm, exp_rc);
> +}
[...]
> +/**
> + * Test SCCBs whose address is in the lowcore or prefix area.
> + */
> +static void test_sccb_prefix(void)
> +{
> +=09uint32_t prefix, new_prefix;
> +=09int offset;
> +
> +=09/* can't actually trash the lowcore, unsurprisingly things break if w=
e do */
> +=09for (offset =3D 0; offset < 8192; offset +=3D 8)
> +=09=09if (!test_one_sccb(valid_code, MKPTR(offset), 0, PGM_BIT_SPEC, 0))
> +=09=09=09break;
> +=09report("SCCB low pages", offset =3D=3D 8192);
> +
> +=09memcpy(prefix_buf, 0, 8192);
> +=09new_prefix =3D (uint32_t)(intptr_t)prefix_buf;
> +=09asm volatile("stpx %0" : "=3DQ" (prefix));
> +=09asm volatile("spx %0" : : "Q" (new_prefix) : "memory");
> +
> +=09for (offset =3D 0; offset < 8192; offset +=3D 8)
> +=09=09if (!test_one_simple(valid_code, MKPTR(new_prefix + offset), 8, 8,=
 PGM_BIT_SPEC, 0))
> +=09=09=09break;
> +=09report("SCCB prefix pages", offset =3D=3D 8192);
> +
> +=09memcpy(prefix_buf, 0, 8192);

What's that memcpy() good for? A comment would be helpful.

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
> +=09int i, pgm, len =3D 0;
> +
> +=09h->length =3D 8;
> +
> +=09for (i =3D 0; i < 33; i++)
> +=09=09a[len++] =3D 1UL << (i + 31);
> +=09for (i =3D 0; i < 33; i++)
> +=09=09a[len++] =3D 3UL << (i + 31);
> +=09for (i =3D 0; i < 33; i++)
> +=09=09a[len++] =3D 0xffffffff80000000UL << i;
> +=09a[len++] =3D 0x80000000;
> +=09for (i =3D 1; i < 33; i++, len++)
> +=09=09a[len] =3D a[len - 1] | (1UL << (i + 31));
> +=09for (i =3D 0; i < len; i++)
> +=09=09a[len + i] =3D a[i] + (intptr_t)h;
> +=09len +=3D i;
> +=09a[len++] =3D 0xdeadbeef00000000;
> +=09a[len++] =3D 0xdeaddeadbeef0000;

IMHO a short comment in the code right in front of the above code block
would be helpful to understand what you're doing here.

> +=09maxram =3D get_ram_size();
> +=09for (i =3D 0; i < len; i++) {
> +=09=09pgm =3D PGM_BIT_SPEC | (a[i] >=3D maxram ? PGM_BIT_ADDR : 0);
> +=09=09if (!test_one_sccb(valid_code, (void *)a[i], 0, pgm, 0))
> +=09=09=09break;
> +=09}
> +=09report("SCCB high addresses", i =3D=3D len);
> +}
> +
> +/**
> + * Test invalid commands, both invalid command detail codes and valid
> + * ones with invalid command class code.
> + */
> +static void test_inval(void)
> +{
> +=09const uint16_t res =3D SCLP_RC_INVALID_SCLP_COMMAND;
> +=09uint32_t cmd;
> +=09int i;
> +
> +=09report_prefix_push("Invalid command");
> +=09for (i =3D 0; i < 65536; i++) {
> +=09=09cmd =3D (0xdead0000) | i;

Please remove the parentheses around 0xdead0000

> +=09=09if (!test_one_simple(cmd, pagebuf, PAGE_SIZE, PAGE_SIZE, PGM_NONE,=
 res))
> +=09=09=09break;
> +=09}
> +=09report("Command detail code", i =3D=3D 65536);
> +
> +=09for (i =3D 0; i < 256; i++) {
> +=09=09cmd =3D (valid_code & ~0xff) | i;
> +=09=09if (cmd =3D=3D valid_code)
> +=09=09=09continue;
> +=09=09if (!test_one_simple(cmd, pagebuf, PAGE_SIZE, PAGE_SIZE, PGM_NONE,=
 res))
> +=09=09=09break;
> +=09}
> +=09report("Command class code", i =3D=3D 256);
> +=09report_prefix_pop();
> +}

 Thomas

