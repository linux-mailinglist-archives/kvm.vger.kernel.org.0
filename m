Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD491452A2
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 11:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgAVKbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 05:31:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58845 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729016AbgAVKbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 05:31:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579689108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=SegZodBpT7liNuPvddjRkHcQbGfm0rpkMBuXCrj+DWU=;
        b=W1L8Ffqy+m59+2+rZAnSeVUnZoeTG8uv61a4veCO99QXQCkhB+Lw/q/xHqfKFV1rSBBigr
        XcsHbDTcERUM2sTfI2qXyeM+WwIKh6exa62Z1Ke/1/mUbZCSwzI2afyXllzdvUh6vCnftA
        NqjjCYRgEiHFnbMiBVe+8HdlQdLcf4k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-quHkXELGNnyOMWzNV74x5w-1; Wed, 22 Jan 2020 05:31:44 -0500
X-MC-Unique: quHkXELGNnyOMWzNV74x5w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F510477;
        Wed, 22 Jan 2020 10:31:43 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-176.ams2.redhat.com [10.36.116.176])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D9615DA80;
        Wed, 22 Jan 2020 10:31:38 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 6/6] s390x: SCLP unit test
To:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com
References: <20200120184256.188698-1-imbrenda@linux.ibm.com>
 <20200120184256.188698-7-imbrenda@linux.ibm.com>
 <35e59971-c09e-2808-1be6-f2ccd555c4f6@redhat.com>
 <42c5b040-733d-4e5b-0276-5b94315336bb@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e406268e-7881-f5c3-7b28-70e355765539@redhat.com>
Date:   Wed, 22 Jan 2020 11:31:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <42c5b040-733d-4e5b-0276-5b94315336bb@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/01/2020 11.22, David Hildenbrand wrote:
> On 22.01.20 11:10, David Hildenbrand wrote:
>> On 20.01.20 19:42, Claudio Imbrenda wrote:
>>> SCLP unit test. Testing the following:
>>>
>>> * Correctly ignoring instruction bits that should be ignored
>>> * Privileged instruction check
>>> * Check for addressing exceptions
>>> * Specification exceptions:
>>>   - SCCB size less than 8
>>>   - SCCB unaligned
>>>   - SCCB overlaps prefix or lowcore
>>>   - SCCB address higher than 2GB
>>> * Return codes for
>>>   - Invalid command
>>>   - SCCB too short (but at least 8)
>>>   - SCCB page boundary violation
>>>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>> Acked-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>  s390x/Makefile      |   1 +
>>>  s390x/sclp.c        | 474 ++++++++++++++++++++++++++++++++++++++++++=
++
>>>  s390x/unittests.cfg |   8 +
>>>  3 files changed, 483 insertions(+)
>>>  create mode 100644 s390x/sclp.c
>>>
>>> diff --git a/s390x/Makefile b/s390x/Makefile
>>> index 3744372..ddb4b48 100644
>>> --- a/s390x/Makefile
>>> +++ b/s390x/Makefile
>>> @@ -16,6 +16,7 @@ tests +=3D $(TEST_DIR)/diag288.elf
>>>  tests +=3D $(TEST_DIR)/stsi.elf
>>>  tests +=3D $(TEST_DIR)/skrf.elf
>>>  tests +=3D $(TEST_DIR)/smp.elf
>>> +tests +=3D $(TEST_DIR)/sclp.elf
>>>  tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
>>> =20
>>>  all: directories test_cases test_cases_binary
>>> diff --git a/s390x/sclp.c b/s390x/sclp.c
>>> new file mode 100644
>>> index 0000000..215347e
>>> --- /dev/null
>>> +++ b/s390x/sclp.c
>>> @@ -0,0 +1,474 @@
>>> +/*
>>> + * Service Call tests
>>> + *
>>> + * Copyright (c) 2019 IBM Corp
>>> + *
>>> + * Authors:
>>> + *  Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> + *
>>> + * This code is free software; you can redistribute it and/or modify=
 it
>>> + * under the terms of the GNU General Public License version 2.
>>> + */
>>> +
>>> +#include <libcflat.h>
>>> +#include <asm/page.h>
>>> +#include <asm/asm-offsets.h>
>>> +#include <asm/interrupt.h>
>>> +#include <sclp.h>
>>> +
>>> +#define PGM_NONE	1
>>> +#define PGM_BIT_SPEC	(1ULL << PGM_INT_CODE_SPECIFICATION)
>>> +#define PGM_BIT_ADDR	(1ULL << PGM_INT_CODE_ADDRESSING)
>>> +#define PGM_BIT_PRIV	(1ULL << PGM_INT_CODE_PRIVILEGED_OPERATION)
>>> +#define MKPTR(x) ((void *)(uint64_t)(x))
>>> +
>>> +#define LC_SIZE (2 * PAGE_SIZE)
>>> +
>>> +static uint8_t pagebuf[LC_SIZE] __attribute__((aligned(LC_SIZE)));	/=
* scratch pages used for some tests */
>>> +static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)))=
;	/* temporary lowcore for test_sccb_prefix */
>>> +static uint8_t sccb_template[PAGE_SIZE];				/* SCCB template to be u=
sed */
>>> +static uint32_t valid_code;						/* valid command code for READ SCP =
INFO */
>>> +static struct lowcore *lc;
>>> +
>>> +/**
>>> + * Perform one service call, handling exceptions and interrupts.
>>> + */
>>> +static int sclp_service_call_test(unsigned int command, void *sccb)
>>> +{
>>> +	int cc;
>>> +
>>> +	sclp_mark_busy();
>>> +	sclp_setup_int();
>>> +	cc =3D servc(command, __pa(sccb));
>>> +	if (lc->pgm_int_code) {
>>> +		sclp_handle_ext();
>>> +		return 0;
>>> +	}
>>> +	if (!cc)
>>> +		sclp_wait_busy();
>>> +	return cc;
>>> +}
>>> +
>>> +/**
>>> + * Perform one test at the given address, optionally using the SCCB =
template,
>>> + * checking for the expected program interrupts and return codes.
>>> + *
>>> + * The parameter buf_len indicates the number of bytes of the templa=
te that
>>> + * should be copied to the test address, and should be 0 when the te=
st
>>> + * address is invalid, in which case nothing is copied.
>>> + *
>>> + * The template is used to simplify tests where the same buffer cont=
ent is
>>> + * used many times in a row, at different addresses.
>>> + *
>>> + * Returns true in case of success or false in case of failure
>>> + */
>>> +static bool test_one_sccb(uint32_t cmd, uint8_t *addr, uint16_t buf_=
len, uint64_t exp_pgm, uint16_t exp_rc)
>>> +{
>>> +	SCCBHeader *h =3D (SCCBHeader *)addr;
>>> +	int res, pgm;
>>> +
>>> +	/* Copy the template to the test address if needed */
>>> +	if (buf_len)
>>> +		memcpy(addr, sccb_template, buf_len);
>>> +	if (exp_pgm !=3D PGM_NONE)
>>> +		expect_pgm_int();
>>> +	/* perform the actual call */
>>> +	res =3D sclp_service_call_test(cmd, h);
>>> +	if (res) {
>>> +		report_info("SCLP not ready (command %#x, address %p, cc %d)", cmd=
, addr, res);
>>> +		return false;
>>> +	}
>>> +	pgm =3D clear_pgm_int();
>>> +	/* Check if the program exception was one of the expected ones */
>>> +	if (!((1ULL << pgm) & exp_pgm)) {
>>> +		report_info("First failure at addr %p, buf_len %d, cmd %#x, pgm co=
de %d",
>>> +				addr, buf_len, cmd, pgm);
>>> +		return false;
>>> +	}
>>> +	/* Check if the response code is the one expected */
>>> +	if (exp_rc && exp_rc !=3D h->response_code) {
>>> +		report_info("First failure at addr %p, buf_len %d, cmd %#x, resp c=
ode %#x",
>>> +				addr, buf_len, cmd, h->response_code);
>>> +		return false;
>>> +	}
>>> +	return true;
>>> +}
>>> +
>>> +/**
>>> + * Wrapper for test_one_sccb to be used when the template should not=
 be
>>> + * copied and the memory address should not be touched.
>>> + */
>>> +static bool test_one_ro(uint32_t cmd, uint8_t *addr, uint64_t exp_pg=
m, uint16_t exp_rc)
>>> +{
>>> +	return test_one_sccb(cmd, addr, 0, exp_pgm, exp_rc);
>>> +}
>>> +
>>> +/**
>>> + * Wrapper for test_one_sccb to set up a simple SCCB template.
>>> + *
>>> + * The parameter sccb_len indicates the value that will be saved in =
the SCCB
>>> + * length field of the SCCB, buf_len indicates the number of bytes o=
f
>>> + * template that need to be copied to the actual test address. In ma=
ny cases
>>> + * it's enough to clear/copy the first 8 bytes of the buffer, while =
the SCCB
>>> + * itself can be larger.
>>> + *
>>> + * Returns true in case of success or false in case of failure
>>> + */
>>> +static bool test_one_simple(uint32_t cmd, uint8_t *addr, uint16_t sc=
cb_len,
>>> +			uint16_t buf_len, uint64_t exp_pgm, uint16_t exp_rc)
>>> +{
>>> +	memset(sccb_template, 0, sizeof(sccb_template));
>>> +	((SCCBHeader *)sccb_template)->length =3D sccb_len;
>>> +	return test_one_sccb(cmd, addr, buf_len, exp_pgm, exp_rc);
>>
>> Doing a fresh ./configure + make on RHEL7 gives me
>>
>> [linux1@rhkvm01 kvm-unit-tests]$ make
>> gcc  -std=3Dgnu99 -ffreestanding -I /home/linux1/git/kvm-unit-tests/li=
b -I /home/linux1/git/kvm-unit-tests/lib/s390x -I lib -O2 -march=3DzEC12 =
-fno-delete-null-pointer-checks -g -MMD -MF s390x/.sclp.d -Wall -Wwrite-s=
trings -Wempty-body -Wuninitialized -Wignored-qualifiers -Werror  -fomit-=
frame-pointer    -Wno-frame-address   -fno-pic    -Wclobbered  -Wunused-b=
ut-set-parameter  -Wmissing-parameter-type  -Wold-style-declaration -Wove=
rride-init -Wmissing-prototypes -Wstrict-prototypes   -c -o s390x/sclp.o =
s390x/sclp.c
>> s390x/sclp.c: In function 'test_one_simple':
>> s390x/sclp.c:121:2: error: dereferencing type-punned pointer will brea=
k strict-aliasing rules [-Werror=3Dstrict-aliasing]
>>   ((SCCBHeader *)sccb_template)->length =3D sccb_len;
>>   ^
>> s390x/sclp.c: At top level:
>> cc1: error: unrecognized command line option "-Wno-frame-address" [-We=
rror]
>> cc1: all warnings being treated as errors
>> make: *** [s390x/sclp.o] Error 1
>=20
> The following makes it work:
>=20
>=20
> diff --git a/s390x/sclp.c b/s390x/sclp.c
> index c13fa60..0b8117a 100644
> --- a/s390x/sclp.c
> +++ b/s390x/sclp.c
> @@ -117,8 +117,10 @@ static bool test_one_ro(uint32_t cmd, uint8_t *add=
r, uint64_t exp_pgm, uint16_t
>  static bool test_one_simple(uint32_t cmd, uint8_t *addr, uint16_t sccb=
_len,
>                         uint16_t buf_len, uint64_t exp_pgm, uint16_t ex=
p_rc)
>  {
> +       SCCBHeader *header =3D (void *)sccb_template;
> +
>         memset(sccb_template, 0, sizeof(sccb_template));
> -       ((SCCBHeader *)sccb_template)->length =3D sccb_len;
> +       header->length =3D sccb_len;

While that might silence the compiler warning, we still might get
aliasing problems here, I think.
The right way to solve this problem is to turn sccb_template into a
union of the various structs/arrays that you want to use and then access
the fields through the union instead ("type-punning through union").

 Thomas

