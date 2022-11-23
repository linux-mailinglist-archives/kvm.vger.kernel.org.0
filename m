Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B255563567B
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 10:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237729AbiKWJbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 04:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237608AbiKWJal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 04:30:41 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864B7112C42
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 01:29:02 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AN854GU034130;
        Wed, 23 Nov 2022 09:28:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ghabRQ0e7b9dyEinT1z0s1WCMY0+UjwHG2Z9E+VrcEk=;
 b=qiLmqvRXQsK0sSM3IO7+pkx8ujm2MgbDEsxq7JQEInlZ8UX8nKEMTphN0PKXCiIVZHSg
 JRZVwZaor4xZt51iN9lZR84dwQbaEjMHQwXOWKVTbEfKvoXrnhs/ChAJmXdWcuJa8loj
 KUkNQQ+pd/KXBVR7NTk9C0QYYjOv4ZjH0O7/b7Jy0D6iZcZznG9A8mywT/xsw1wHrKi+
 fgSLdNv4+T65gZcQORAdkZdXSnFM3hIFwrVqpKk78pF5zMtT0K0WgKLGre4yO0w31MY5
 e2zfzxL6bKX8IlbMJe64TiC7xamf2NgNkNtzJLP4AWV+5NGcyAIRobxcOR1w/YUzveUc fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0x1d4k9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 09:28:58 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AN8wFpK028917;
        Wed, 23 Nov 2022 09:28:58 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0x1d4k8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 09:28:58 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AN9Khhn019959;
        Wed, 23 Nov 2022 09:28:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3kxps8kyd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 09:28:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AN9SrKU1639012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 09:28:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12912A405B;
        Wed, 23 Nov 2022 09:28:53 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A64B6A405F;
        Wed, 23 Nov 2022 09:28:52 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 09:28:52 +0000 (GMT)
Date:   Wed, 23 Nov 2022 10:28:50 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Alex =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 11/27] lib: Add random number
 generator
Message-ID: <20221123102850.08df4bd9@p-imbrenda>
In-Reply-To: <20221122161152.293072-12-mlevitsk@redhat.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
        <20221122161152.293072-12-mlevitsk@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4qipSXFEl2OVQK2wh1PdtqJc8VKzwdaN
X-Proofpoint-ORIG-GUID: 2dFpki1CCF_IPzmVTlH0Js2pCWO6oq8O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Nov 2022 18:11:36 +0200
Maxim Levitsky <mlevitsk@redhat.com> wrote:

> Add a simple pseudo random number generator which can be used
> in the tests to add randomeness in a controlled manner.

ahh, yes I have wanted something like this in the library for quite some
time! thanks!

I have some comments regarding the interfaces (see below), and also a
request, if you could split the x86 part in a different patch, so we
can have a "pure" lib patch, and then you can have an x86-only patch
that uses the new interface

> 
> For x86 add a wrapper which initializes the PRNG with RDRAND,
> unless RANDOM_SEED env variable is set, in which case it is used
> instead.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  Makefile              |  3 ++-
>  README.md             |  1 +
>  lib/prng.c            | 41 +++++++++++++++++++++++++++++++++++++++++
>  lib/prng.h            | 23 +++++++++++++++++++++++
>  lib/x86/random.c      | 33 +++++++++++++++++++++++++++++++++
>  lib/x86/random.h      | 17 +++++++++++++++++
>  scripts/arch-run.bash |  2 +-
>  x86/Makefile.common   |  1 +
>  8 files changed, 119 insertions(+), 2 deletions(-)
>  create mode 100644 lib/prng.c
>  create mode 100644 lib/prng.h
>  create mode 100644 lib/x86/random.c
>  create mode 100644 lib/x86/random.h
> 
> diff --git a/Makefile b/Makefile
> index 6ed5deac..384b5acf 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -29,7 +29,8 @@ cflatobjs := \
>  	lib/string.o \
>  	lib/abort.o \
>  	lib/report.o \
> -	lib/stack.o
> +	lib/stack.o \
> +	lib/prng.o
>  
>  # libfdt paths
>  LIBFDT_objdir = lib/libfdt
> diff --git a/README.md b/README.md
> index 6e82dc22..5a677a03 100644
> --- a/README.md
> +++ b/README.md
> @@ -91,6 +91,7 @@ the framework.  The list of reserved environment variables is below
>      QEMU_ACCEL                   either kvm, hvf or tcg
>      QEMU_VERSION_STRING          string of the form `qemu -h | head -1`
>      KERNEL_VERSION_STRING        string of the form `uname -r`
> +    TEST_SEED                    integer to force a fixed seed for the prng
>  
>  Additionally these self-explanatory variables are reserved
>  
> diff --git a/lib/prng.c b/lib/prng.c
> new file mode 100644
> index 00000000..d9342eb3
> --- /dev/null
> +++ b/lib/prng.c
> @@ -0,0 +1,41 @@
> +
> +/*
> + * Random number generator that is usable from guest code. This is the
> + * Park-Miller LCG using standard constants.
> + */
> +
> +#include "libcflat.h"
> +#include "prng.h"
> +
> +struct random_state new_random_state(uint32_t seed)
> +{
> +	struct random_state s = {.seed = seed};
> +	return s;
> +}
> +
> +uint32_t random_u32(struct random_state *state)
> +{
> +	state->seed = (uint64_t)state->seed * 48271 % ((uint32_t)(1 << 31) - 1);

why not:

state->seed = state->seed * 48271ULL % (BIT_ULL(31) - 1);

I think it's more readable

> +	return state->seed;
> +}
> +
> +
> +uint32_t random_range(struct random_state *state, uint32_t min, uint32_t max)
> +{
> +	uint32_t val = random_u32(state);
> +
> +	return val % (max - min + 1) + min;

what happens if max == UINT_MAX and min = 0 ?

maybe:

if (max - min == UINT_MAX)
	return val;

> +}
> +
> +/*
> + * Returns true randomly in 'percent_true' cases (e.g if percent_true = 70.0,
> + * it will return true in 70.0% of cases)
> + */
> +bool random_decision(struct random_state *state, float percent_true)

I'm not a fan of floats in the lib...

> +{
> +	if (percent_true == 0)
> +		return 0;
> +	if (percent_true == 100)
> +		return 1;
> +	return random_range(state, 1, 10000) < (uint32_t)(percent_true * 100);

...especially when you are only using 2 decimal places anyway

can you rewrite it to take an unsigned int? 
e.g. if percent_true = 7123, it will return true in 71.23% of the cases

then you can rewrite the last line like this:

return random_range(state, 1, 10000) < percent_true;

> +}
> diff --git a/lib/prng.h b/lib/prng.h
> new file mode 100644
> index 00000000..61d3a48b
> --- /dev/null
> +++ b/lib/prng.h
> @@ -0,0 +1,23 @@
> +
> +#ifndef SRC_LIB_PRNG_H_
> +#define SRC_LIB_PRNG_H_
> +
> +struct random_state {
> +	uint32_t seed;
> +};
> +
> +struct random_state new_random_state(uint32_t seed);
> +uint32_t random_u32(struct random_state *state);
> +
> +/*
> + * return a random number from min to max (included)
> + */
> +uint32_t random_range(struct random_state *state, uint32_t min, uint32_t max);
> +
> +/*
> + * Returns true randomly in 'percent_true' cases (e.g if percent_true = 70.0,
> + * it will return true in 70.0% of cases)
> + */
> +bool random_decision(struct random_state *state, float percent_true);
> +
> +#endif /* SRC_LIB_PRNG_H_ */


and then put the rest below in a new patch

> diff --git a/lib/x86/random.c b/lib/x86/random.c
> new file mode 100644
> index 00000000..fcdd5fe8
> --- /dev/null
> +++ b/lib/x86/random.c
> @@ -0,0 +1,33 @@
> +
> +#include "libcflat.h"
> +#include "processor.h"
> +#include "prng.h"
> +#include "smp.h"
> +#include "asm/spinlock.h"
> +#include "random.h"
> +
> +static u32 test_seed;
> +static bool initialized;
> +
> +void init_prng(void)
> +{
> +	char *test_seed_str = getenv("TEST_SEED");
> +
> +	if (test_seed_str && strlen(test_seed_str))
> +		test_seed = atol(test_seed_str);
> +	else
> +#ifdef __x86_64__
> +		test_seed =  (u32)rdrand();
> +#else
> +		test_seed = (u32)(rdtsc() << 4);
> +#endif
> +	initialized = true;
> +
> +	printf("Test seed: %u\n", (unsigned int)test_seed);
> +}
> +
> +struct random_state get_prng(void)
> +{
> +	assert(initialized);
> +	return new_random_state(test_seed + this_cpu_read_smp_id());
> +}
> diff --git a/lib/x86/random.h b/lib/x86/random.h
> new file mode 100644
> index 00000000..795b450b
> --- /dev/null
> +++ b/lib/x86/random.h
> @@ -0,0 +1,17 @@
> +/*
> + * prng.h
> + *
> + *  Created on: Nov 9, 2022
> + *      Author: mlevitsk
> + */
> +
> +#ifndef SRC_LIB_X86_RANDOM_H_
> +#define SRC_LIB_X86_RANDOM_H_
> +
> +#include "libcflat.h"
> +#include "prng.h"
> +
> +void init_prng(void);
> +struct random_state get_prng(void);
> +
> +#endif /* SRC_LIB_X86_RANDOM_H_ */
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 51e4b97b..238d19f8 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -298,7 +298,7 @@ env_params ()
>  	KERNEL_EXTRAVERSION=${KERNEL_EXTRAVERSION%%[!0-9]*}
>  	! [[ $KERNEL_SUBLEVEL =~ ^[0-9]+$ ]] && unset $KERNEL_SUBLEVEL
>  	! [[ $KERNEL_EXTRAVERSION =~ ^[0-9]+$ ]] && unset $KERNEL_EXTRAVERSION
> -	env_add_params KERNEL_VERSION_STRING KERNEL_VERSION KERNEL_PATCHLEVEL KERNEL_SUBLEVEL KERNEL_EXTRAVERSION
> +	env_add_params KERNEL_VERSION_STRING KERNEL_VERSION KERNEL_PATCHLEVEL KERNEL_SUBLEVEL KERNEL_EXTRAVERSION TEST_SEED
>  }
>  
>  env_file ()
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 698a48ab..fa0a50e6 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -23,6 +23,7 @@ cflatobjs += lib/x86/stack.o
>  cflatobjs += lib/x86/fault_test.o
>  cflatobjs += lib/x86/delay.o
>  cflatobjs += lib/x86/pmu.o
> +cflatobjs += lib/x86/random.o
>  ifeq ($(CONFIG_EFI),y)
>  cflatobjs += lib/x86/amd_sev.o
>  cflatobjs += lib/efi.o

