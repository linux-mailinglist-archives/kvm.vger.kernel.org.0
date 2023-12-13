Return-Path: <kvm+bounces-4366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D4C6811A4D
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:01:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A55FC281F42
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8DE34C62F;
	Wed, 13 Dec 2023 17:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Bcay2Ih4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEADD0;
	Wed, 13 Dec 2023 09:00:57 -0800 (PST)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDFND9T027050;
	Wed, 13 Dec 2023 17:00:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=hNTPoikdwEb6oOA+VqHykjaZKyLdgxvqiEq+g0mXvnA=;
 b=Bcay2Ih4p00UyajuRWlMmZKjgmQAbxEiQuD2fTjgXuc7PdnHyqUYWpOVFVX8OmJzNYu8
 x3HBGQV/hKLs9xKwv++mCP8CKMr846dIRJlg9hqNGqWqlGffkcxi78PbIgfIX5YyMtOM
 8bW8CUEYBX7AhZDwTai1pdda2aehMpv5GC9ya0Mm+0SsFGPD9RGiGewSLgsjeXSeBqdE
 +oESxMoOFV+0bTEGE45flMBBBczahV8VtSLpA0yHqwmLfSIr9+e32c614vVYV9uRaKvJ
 f3V98oJawVCjZgrDhX4KzRUI0O1/RXx7RrRs6C9XDZCZ3tb7LWDnpw/Maht0XIRlc7du Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyf72b2ms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:00:48 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BDGgPrk002823;
	Wed, 13 Dec 2023 17:00:47 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyf72b2jq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:00:47 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDG4cWH013878;
	Wed, 13 Dec 2023 17:00:44 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uw5929sd1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:00:44 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BDH0fX133358570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 17:00:42 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E05A820043;
	Wed, 13 Dec 2023 17:00:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C130720040;
	Wed, 13 Dec 2023 17:00:41 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Dec 2023 17:00:41 +0000 (GMT)
Date: Wed, 13 Dec 2023 18:00:33 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Nico =?UTF-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 5/5] s390x: Add test for STFLE
 interpretive execution (format-0)
Message-ID: <20231213180033.54516bdd@p-imbrenda>
In-Reply-To: <20231213124942.604109-6-nsg@linux.ibm.com>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
	<20231213124942.604109-6-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lDwjlNG91U_8fU0YMzihknB93SPAe1B3
X-Proofpoint-GUID: o1kTSGK_bC_RgErfPTfEsE6CHBlrsSwB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_09,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 spamscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312130119

On Wed, 13 Dec 2023 13:49:42 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> The STFLE instruction indicates installed facilities.
> SIE can interpretively execute STFLE.
> Use a snippet guest executing STFLE to get the result of
> interpretive execution and check the result.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

[...]

>  static inline void setup_facilities(void)
> diff --git a/s390x/snippets/c/stfle.c b/s390x/snippets/c/stfle.c
> new file mode 100644
> index 00000000..eb024a6a
> --- /dev/null
> +++ b/s390x/snippets/c/stfle.c
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright IBM Corp. 2023
> + *
> + * Snippet used by the STLFE interpretive execution facilities test.
> + */
> +#include <libcflat.h>
> +#include <snippet-guest.h>
> +
> +int main(void)
> +{
> +	const unsigned int max_fac_len = 8;

why 8?

> +	uint64_t res[max_fac_len + 1];
> +
> +	res[0] = max_fac_len - 1;
> +	asm volatile ( "lg	0,%[len]\n"
> +		"	stfle	%[fac]\n"
> +		"	stg	0,%[len]\n"
> +		: [fac] "=QS"(*(uint64_t(*)[max_fac_len])&res[1]),
> +		  [len] "+RT"(res[0])
> +		:
> +		: "%r0", "cc"
> +	);
> +	force_exit_value((uint64_t)&res);
> +	return 0;
> +}
> diff --git a/s390x/stfle-sie.c b/s390x/stfle-sie.c
> new file mode 100644
> index 00000000..574319ed
> --- /dev/null
> +++ b/s390x/stfle-sie.c
> @@ -0,0 +1,132 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright IBM Corp. 2023
> + *
> + * SIE with STLFE interpretive execution facilities test.
> + */
> +#include <libcflat.h>
> +#include <stdlib.h>
> +#include <asm/facility.h>
> +#include <asm/time.h>
> +#include <snippet-host.h>
> +#include <alloc_page.h>
> +#include <sclp.h>
> +
> +static struct vm vm;
> +static uint64_t (*fac)[PAGE_SIZE / sizeof(uint64_t)];
> +static rand_state rand_s;
> +
> +static void setup_guest(void)
> +{
> +	extern const char SNIPPET_NAME_START(c, stfle)[];
> +	extern const char SNIPPET_NAME_END(c, stfle)[];
> +
> +	setup_vm();
> +	fac = alloc_pages_flags(0, AREA_DMA31);
> +
> +	snippet_setup_guest(&vm, false);
> +	snippet_init(&vm, SNIPPET_NAME_START(c, stfle),
> +		     SNIPPET_LEN(c, stfle), SNIPPET_UNPACK_OFF);
> +}
> +
> +struct guest_stfle_res {
> +	uint16_t len;
> +	uint64_t reg;
> +	unsigned char *mem;
> +};
> +
> +static struct guest_stfle_res run_guest(void)
> +{
> +	struct guest_stfle_res res;
> +	uint64_t guest_stfle_addr;
> +
> +	sie(&vm);
> +	assert(snippet_get_force_exit_value(&vm, &guest_stfle_addr));
> +	res.mem = &vm.guest_mem[guest_stfle_addr];
> +	memcpy(&res.reg, res.mem, sizeof(res.reg));
> +	res.len = (res.reg & 0xff) + 1;
> +	res.mem += sizeof(res.reg);
> +	return res;
> +}
> +
> +static void test_stfle_format_0(void)
> +{
> +	struct guest_stfle_res res;
> +
> +	report_prefix_push("format-0");
> +	for (int j = 0; j < stfle_size(); j++)
> +		WRITE_ONCE((*fac)[j], rand64(&rand_s));

do you really need random numbers? can't you use a static pattern?
maybe something like 0x0001020304050607 etc...

> +	vm.sblk->fac = (uint32_t)(uint64_t)fac;
> +	res = run_guest();
> +	report(res.len == stfle_size(), "stfle len correct");
> +	report(!memcmp(*fac, res.mem, res.len * sizeof(uint64_t)),
> +	       "Guest facility list as specified");

it seems like you are comparing the full facility list (stfle_size
doublewords long) with the result of STFLE in the guest, but the guest
is limited to 8 double words?

> +	report_prefix_pop();
> +}
> +
> +struct args {
> +	uint64_t seed;
> +};
> +
> +static bool parse_uint64_t(const char *arg, uint64_t *out)
> +{
> +	char *end;
> +	uint64_t num;
> +
> +	if (arg[0] == '\0')
> +		return false;
> +	num = strtoul(arg, &end, 0);
> +	if (end[0] != '\0')
> +		return false;
> +	*out = num;
> +	return true;
> +}
> +
> +static struct args parse_args(int argc, char **argv)
> +{
> +	struct args args;
> +	const char *flag;
> +	unsigned int i;
> +	uint64_t arg;
> +	bool has_arg;
> +
> +	stck(&args.seed);
> +
> +	for (i = 1; i < argc; i++) {
> +		if (i + 1 < argc)
> +			has_arg = parse_uint64_t(argv[i + 1], &arg);
> +		else
> +			has_arg = false;
> +
> +		flag = "--seed";
> +		if (!strcmp(flag, argv[i])) {
> +			if (!has_arg)
> +				report_abort("%s needs an uint64_t parameter", flag);
> +			args.seed = arg;
> +			++i;
> +			continue;
> +		}
> +		report_abort("Unsupported parameter '%s'",
> +			     argv[i]);
> +	}
> +
> +	return args;
> +}

this is lots of repeated code in all tests, I should really resurrect
and polish my patchseries for argument parsing

> +
> +int main(int argc, char **argv)
> +{
> +	struct args args = parse_args(argc, argv);
> +
> +	if (!sclp_facilities.has_sief2) {
> +		report_skip("SIEF2 facility unavailable");
> +		goto out;
> +	}
> +
> +	report_info("pseudo rand seed: 0x%lx", args.seed);
> +	rand_s = RAND_STATE_INIT(args.seed);
> +	setup_guest();
> +	if (test_facility(7))
> +		test_stfle_format_0();
> +out:
> +	return report_summary();
> +}


