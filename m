Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7771452BE
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 11:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgAVKkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 05:40:10 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21593 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726094AbgAVKkK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jan 2020 05:40:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579689608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=nm1hYCCCb3zYcgQnXIdKCebmKBYVaGVsM9H9zV/xL4I=;
        b=GMjou9N0+WYdH4hc7tRbpPK8rkZetCxRwUgJ/jKCEjfnr3AeVRog8MN1yiSfU4SQdClNNQ
        YAT+57I1hwecqtgdXzvDXzkbxshWrjvoRJhZPzQY0S8XePXyGe5LVMJ4t/005EdiLE2TlR
        ZDne/cjepUawO36oFQY9zYb2Nbtm2XM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-F_hTRkctNPKhn0Evz02eOQ-1; Wed, 22 Jan 2020 05:40:04 -0500
X-MC-Unique: F_hTRkctNPKhn0Evz02eOQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E60A8010D6;
        Wed, 22 Jan 2020 10:40:00 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-176.ams2.redhat.com [10.36.116.176])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FAB287EF8;
        Wed, 22 Jan 2020 10:39:55 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 6/6] s390x: SCLP unit test
To:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com
References: <20200120184256.188698-1-imbrenda@linux.ibm.com>
 <20200120184256.188698-7-imbrenda@linux.ibm.com>
 <35e59971-c09e-2808-1be6-f2ccd555c4f6@redhat.com>
 <42c5b040-733d-4e5b-0276-5b94315336bb@redhat.com>
 <e406268e-7881-f5c3-7b28-70e355765539@redhat.com>
 <997a62b7-7ab7-6119-4948-e8779e639101@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4d09b567-c2ae-ec9d-59d0-bd259a86b14d@redhat.com>
Date:   Wed, 22 Jan 2020 11:39:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <997a62b7-7ab7-6119-4948-e8779e639101@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/01/2020 11.32, David Hildenbrand wrote:
> On 22.01.20 11:31, Thomas Huth wrote:
>> On 22/01/2020 11.22, David Hildenbrand wrote:
>>> On 22.01.20 11:10, David Hildenbrand wrote:
>>>> On 20.01.20 19:42, Claudio Imbrenda wrote:
>>>>> SCLP unit test. Testing the following:
>>>>>
>>>>> * Correctly ignoring instruction bits that should be ignored
>>>>> * Privileged instruction check
>>>>> * Check for addressing exceptions
>>>>> * Specification exceptions:
>>>>>   - SCCB size less than 8
>>>>>   - SCCB unaligned
>>>>>   - SCCB overlaps prefix or lowcore
>>>>>   - SCCB address higher than 2GB
>>>>> * Return codes for
>>>>>   - Invalid command
>>>>>   - SCCB too short (but at least 8)
>>>>>   - SCCB page boundary violation
>>>>>
>>>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>>>> Acked-by: Janosch Frank <frankja@linux.ibm.com>
>>>>> ---
>>>>>  s390x/Makefile      |   1 +
>>>>>  s390x/sclp.c        | 474 ++++++++++++++++++++++++++++++++++++++++=
++++
>>>>>  s390x/unittests.cfg |   8 +
>>>>>  3 files changed, 483 insertions(+)
>>>>>  create mode 100644 s390x/sclp.c
>>>>>
>>>>> diff --git a/s390x/Makefile b/s390x/Makefile
>>>>> index 3744372..ddb4b48 100644
>>>>> --- a/s390x/Makefile
>>>>> +++ b/s390x/Makefile
>>>>> @@ -16,6 +16,7 @@ tests +=3D $(TEST_DIR)/diag288.elf
>>>>>  tests +=3D $(TEST_DIR)/stsi.elf
>>>>>  tests +=3D $(TEST_DIR)/skrf.elf
>>>>>  tests +=3D $(TEST_DIR)/smp.elf
>>>>> +tests +=3D $(TEST_DIR)/sclp.elf
>>>>>  tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
>>>>> =20
>>>>>  all: directories test_cases test_cases_binary
>>>>> diff --git a/s390x/sclp.c b/s390x/sclp.c
>>>>> new file mode 100644
>>>>> index 0000000..215347e
>>>>> --- /dev/null
>>>>> +++ b/s390x/sclp.c
>>>>> @@ -0,0 +1,474 @@
>>>>> +/*
>>>>> + * Service Call tests
>>>>> + *
>>>>> + * Copyright (c) 2019 IBM Corp
>>>>> + *
>>>>> + * Authors:
>>>>> + *  Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>>> + *
>>>>> + * This code is free software; you can redistribute it and/or modi=
fy it
>>>>> + * under the terms of the GNU General Public License version 2.
>>>>> + */
>>>>> +
>>>>> +#include <libcflat.h>
>>>>> +#include <asm/page.h>
>>>>> +#include <asm/asm-offsets.h>
>>>>> +#include <asm/interrupt.h>
>>>>> +#include <sclp.h>
>>>>> +
>>>>> +#define PGM_NONE	1
>>>>> +#define PGM_BIT_SPEC	(1ULL << PGM_INT_CODE_SPECIFICATION)
>>>>> +#define PGM_BIT_ADDR	(1ULL << PGM_INT_CODE_ADDRESSING)
>>>>> +#define PGM_BIT_PRIV	(1ULL << PGM_INT_CODE_PRIVILEGED_OPERATION)
>>>>> +#define MKPTR(x) ((void *)(uint64_t)(x))
>>>>> +
>>>>> +#define LC_SIZE (2 * PAGE_SIZE)
>>>>> +
>>>>> +static uint8_t pagebuf[LC_SIZE] __attribute__((aligned(LC_SIZE)));=
	/* scratch pages used for some tests */
>>>>> +static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)=
));	/* temporary lowcore for test_sccb_prefix */
>>>>> +static uint8_t sccb_template[PAGE_SIZE];				/* SCCB template to be=
 used */
>>>>> +static uint32_t valid_code;						/* valid command code for READ SC=
P INFO */
>>>>> +static struct lowcore *lc;
>>>>> +
>>>>> +/**
>>>>> + * Perform one service call, handling exceptions and interrupts.
>>>>> + */
>>>>> +static int sclp_service_call_test(unsigned int command, void *sccb=
)
>>>>> +{
>>>>> +	int cc;
>>>>> +
>>>>> +	sclp_mark_busy();
>>>>> +	sclp_setup_int();
>>>>> +	cc =3D servc(command, __pa(sccb));
>>>>> +	if (lc->pgm_int_code) {
>>>>> +		sclp_handle_ext();
>>>>> +		return 0;
>>>>> +	}
>>>>> +	if (!cc)
>>>>> +		sclp_wait_busy();
>>>>> +	return cc;
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + * Perform one test at the given address, optionally using the SCC=
B template,
>>>>> + * checking for the expected program interrupts and return codes.
>>>>> + *
>>>>> + * The parameter buf_len indicates the number of bytes of the temp=
late that
>>>>> + * should be copied to the test address, and should be 0 when the =
test
>>>>> + * address is invalid, in which case nothing is copied.
>>>>> + *
>>>>> + * The template is used to simplify tests where the same buffer co=
ntent is
>>>>> + * used many times in a row, at different addresses.
>>>>> + *
>>>>> + * Returns true in case of success or false in case of failure
>>>>> + */
>>>>> +static bool test_one_sccb(uint32_t cmd, uint8_t *addr, uint16_t bu=
f_len, uint64_t exp_pgm, uint16_t exp_rc)
>>>>> +{
>>>>> +	SCCBHeader *h =3D (SCCBHeader *)addr;
>>>>> +	int res, pgm;
>>>>> +
>>>>> +	/* Copy the template to the test address if needed */
>>>>> +	if (buf_len)
>>>>> +		memcpy(addr, sccb_template, buf_len);
>>>>> +	if (exp_pgm !=3D PGM_NONE)
>>>>> +		expect_pgm_int();
>>>>> +	/* perform the actual call */
>>>>> +	res =3D sclp_service_call_test(cmd, h);
>>>>> +	if (res) {
>>>>> +		report_info("SCLP not ready (command %#x, address %p, cc %d)", c=
md, addr, res);
>>>>> +		return false;
>>>>> +	}
>>>>> +	pgm =3D clear_pgm_int();
>>>>> +	/* Check if the program exception was one of the expected ones */
>>>>> +	if (!((1ULL << pgm) & exp_pgm)) {
>>>>> +		report_info("First failure at addr %p, buf_len %d, cmd %#x, pgm =
code %d",
>>>>> +				addr, buf_len, cmd, pgm);
>>>>> +		return false;
>>>>> +	}
>>>>> +	/* Check if the response code is the one expected */
>>>>> +	if (exp_rc && exp_rc !=3D h->response_code) {
>>>>> +		report_info("First failure at addr %p, buf_len %d, cmd %#x, resp=
 code %#x",
>>>>> +				addr, buf_len, cmd, h->response_code);
>>>>> +		return false;
>>>>> +	}
>>>>> +	return true;
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + * Wrapper for test_one_sccb to be used when the template should n=
ot be
>>>>> + * copied and the memory address should not be touched.
>>>>> + */
>>>>> +static bool test_one_ro(uint32_t cmd, uint8_t *addr, uint64_t exp_=
pgm, uint16_t exp_rc)
>>>>> +{
>>>>> +	return test_one_sccb(cmd, addr, 0, exp_pgm, exp_rc);
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + * Wrapper for test_one_sccb to set up a simple SCCB template.
>>>>> + *
>>>>> + * The parameter sccb_len indicates the value that will be saved i=
n the SCCB
>>>>> + * length field of the SCCB, buf_len indicates the number of bytes=
 of
>>>>> + * template that need to be copied to the actual test address. In =
many cases
>>>>> + * it's enough to clear/copy the first 8 bytes of the buffer, whil=
e the SCCB
>>>>> + * itself can be larger.
>>>>> + *
>>>>> + * Returns true in case of success or false in case of failure
>>>>> + */
>>>>> +static bool test_one_simple(uint32_t cmd, uint8_t *addr, uint16_t =
sccb_len,
>>>>> +			uint16_t buf_len, uint64_t exp_pgm, uint16_t exp_rc)
>>>>> +{
>>>>> +	memset(sccb_template, 0, sizeof(sccb_template));
>>>>> +	((SCCBHeader *)sccb_template)->length =3D sccb_len;
>>>>> +	return test_one_sccb(cmd, addr, buf_len, exp_pgm, exp_rc);
>>>>
>>>> Doing a fresh ./configure + make on RHEL7 gives me
>>>>
>>>> [linux1@rhkvm01 kvm-unit-tests]$ make
>>>> gcc  -std=3Dgnu99 -ffreestanding -I /home/linux1/git/kvm-unit-tests/=
lib -I /home/linux1/git/kvm-unit-tests/lib/s390x -I lib -O2 -march=3DzEC1=
2 -fno-delete-null-pointer-checks -g -MMD -MF s390x/.sclp.d -Wall -Wwrite=
-strings -Wempty-body -Wuninitialized -Wignored-qualifiers -Werror  -fomi=
t-frame-pointer    -Wno-frame-address   -fno-pic    -Wclobbered  -Wunused=
-but-set-parameter  -Wmissing-parameter-type  -Wold-style-declaration -Wo=
verride-init -Wmissing-prototypes -Wstrict-prototypes   -c -o s390x/sclp.=
o s390x/sclp.c
>>>> s390x/sclp.c: In function 'test_one_simple':
>>>> s390x/sclp.c:121:2: error: dereferencing type-punned pointer will br=
eak strict-aliasing rules [-Werror=3Dstrict-aliasing]
>>>>   ((SCCBHeader *)sccb_template)->length =3D sccb_len;
>>>>   ^
>>>> s390x/sclp.c: At top level:
>>>> cc1: error: unrecognized command line option "-Wno-frame-address" [-=
Werror]
>>>> cc1: all warnings being treated as errors
>>>> make: *** [s390x/sclp.o] Error 1
>>>
>>> The following makes it work:
>>>
>>>
>>> diff --git a/s390x/sclp.c b/s390x/sclp.c
>>> index c13fa60..0b8117a 100644
>>> --- a/s390x/sclp.c
>>> +++ b/s390x/sclp.c
>>> @@ -117,8 +117,10 @@ static bool test_one_ro(uint32_t cmd, uint8_t *a=
ddr, uint64_t exp_pgm, uint16_t
>>>  static bool test_one_simple(uint32_t cmd, uint8_t *addr, uint16_t sc=
cb_len,
>>>                         uint16_t buf_len, uint64_t exp_pgm, uint16_t =
exp_rc)
>>>  {
>>> +       SCCBHeader *header =3D (void *)sccb_template;
>>> +
>>>         memset(sccb_template, 0, sizeof(sccb_template));
>>> -       ((SCCBHeader *)sccb_template)->length =3D sccb_len;
>>> +       header->length =3D sccb_len;
>>
>> While that might silence the compiler warning, we still might get
>> aliasing problems here, I think.
>> The right way to solve this problem is to turn sccb_template into a
>> union of the various structs/arrays that you want to use and then acce=
ss
>> the fields through the union instead ("type-punning through union").
>=20
> We do have the exact same thing in lib/s390x/sclp.c already, no?

Maybe we should carefully check that code, too...

> Especially, new compilers don't seem to care?

I've seen horrible bugs due to these aliasing problems in the past -
without compiler warnings showing up! Certain versions of GCC assume
that they can re-order code with pointers that point to types of
different sizes, i.e. in the above example, I think they could assume
that they could re-order the memset() and the header->length =3D ... line=
.
I'd feel better if we play safe and use a union here.

 Thomas

