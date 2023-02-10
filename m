Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52235692128
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 15:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbjBJOwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 09:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbjBJOwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 09:52:07 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ECA3E616;
        Fri, 10 Feb 2023 06:52:06 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AEfsgV013310;
        Fri, 10 Feb 2023 14:52:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=4Rt2v7mkn8lZECC2eYJOwVFQEs2kv98v/OLLdDmWpHQ=;
 b=CYdeUEDSF7tTED0CUJGk5x1Tukw1zRtNQSBkWUjFRRwByktaDzv4k4+8LmDWbHaN0f0+
 9FQ9xZnOYhcpID0KTFAEvDyMXBZHRw6PhL6XWFNpKjBLiaT1appTiTtUAzxC/wdKVFyO
 3PY327mqTLoeM9NOVfD42iByYFScWhqzCbid1ynMlrHEwBGuc14Dif+JTcWxYclEtXi2
 cM26yb0IBwS2NGWAl6EnIYYAApmkiNw9InYSROSsL/VGv9GeHs9kKyADZfjFWWGBp0Po
 iG4MI6R+z71ieTl23cYKv6Xk6D/Mk8g0yNaOuqG5fkz/PHW3POGaAki5trvt7MQ0qyom zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nnqwqge57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 14:52:05 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31AEijQS029598;
        Fri, 10 Feb 2023 14:52:05 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nnqwqge2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 14:52:05 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31AD6K3q025825;
        Fri, 10 Feb 2023 14:52:02 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06ynpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 14:52:02 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31AEpx0W21889516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 14:51:59 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 233AB20043;
        Fri, 10 Feb 2023 14:51:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E13E520040;
        Fri, 10 Feb 2023 14:51:58 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.142.171])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 10 Feb 2023 14:51:58 +0000 (GMT)
Message-ID: <c4bb7c1854a1e46eb312ef629c3cb1bc9044b549.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v6 1/2] s390x: topology: Check the
 Perform Topology Function
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com
Date:   Fri, 10 Feb 2023 15:51:58 +0100
In-Reply-To: <20230202092814.151081-2-pmorel@linux.ibm.com>
References: <20230202092814.151081-1-pmorel@linux.ibm.com>
         <20230202092814.151081-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: M5ZDDZmtaElk-HCZJNSj-7yGXEph1hBE
X-Proofpoint-GUID: mRbC6Do5GMXb9ANiKqmu4cgUJXCzYDP1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_09,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302100120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-02-02 at 10:28 +0100, Pierre Morel wrote:
> We check that the PTF instruction is working correctly when
> the cpu topology facility is available.
>=20
> For KVM only, we test changing of the polarity between horizontal
> and vertical and that a reset set the horizontal polarity.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/topology.c    | 155 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   3 +
>  3 files changed, 159 insertions(+)
>  create mode 100644 s390x/topology.c
>=20
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 52a9d82..b5fe8a3 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -39,6 +39,7 @@ tests +=3D $(TEST_DIR)/panic-loop-extint.elf
>  tests +=3D $(TEST_DIR)/panic-loop-pgm.elf
>  tests +=3D $(TEST_DIR)/migration-sck.elf
>  tests +=3D $(TEST_DIR)/exittime.elf
> +tests +=3D $(TEST_DIR)/topology.elf
> =20
>  pv-tests +=3D $(TEST_DIR)/pv-diags.elf
> =20
> diff --git a/s390x/topology.c b/s390x/topology.c
> new file mode 100644
> index 0000000..20f7ba2
> --- /dev/null
> +++ b/s390x/topology.c
> @@ -0,0 +1,155 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + */
> +
> +#include <libcflat.h>
> +#include <asm/page.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <asm/facility.h>
> +#include <smp.h>
> +#include <sclp.h>
> +#include <s390x/hardware.h>
> +
> +#define PTF_REQ_HORIZONTAL	0
> +#define PTF_REQ_VERTICAL	1
> +#define PTF_REQ_CHECK		2
> +
> +#define PTF_ERR_NO_REASON	0
> +#define PTF_ERR_ALRDY_POLARIZED	1
> +#define PTF_ERR_IN_PROGRESS	2

Maybe also give the CC codes names for improved readability.

> +
> +extern int diag308_load_reset(u64);
> +
> +static int ptf(unsigned long fc, unsigned long *rc)
> +{
> +	int cc;
> +
> +	asm volatile(
> +		"       .insn   rre,0xb9a20000,%1,0\n"
> +		"       ipm     %0\n"
> +		"       srl     %0,28\n"
> +		: "=3Dd" (cc), "+d" (fc)
> +		:
> +		: "cc");

Personally I always name asm arguments, but it is a very short snippet,
so still very readable. Could also pull the shift into C code,
but again, small difference.

> +
> +	*rc =3D fc >> 8;
> +	return cc;
> +}
> +
> +static void test_ptf(void)
> +{
> +	unsigned long rc;
> +	int cc;
> +
> +	/* PTF is a privilege instruction */
> +	report_prefix_push("Privilege");
> +	enter_pstate();
> +	expect_pgm_int();
> +	ptf(PTF_REQ_CHECK, &rc);
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();

IMO, you should repeat this test for all FCs, since some are emulated,
others interpreted by SIE.

> +
> +	report_prefix_push("Wrong fc");

"Undefined fc" is more informative IMO.

> +	expect_pgm_int();
> +	ptf(0xff, &rc);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("Reserved bits");
> +	expect_pgm_int();
> +	ptf(0xffffffffffffff00UL, &rc);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("Topology Report pending");
> +	/*
> +	 * At this moment the topology may already have changed
> +	 * since the VM has been started.
> +	 * However, we can test if a second PTF instruction
> +	 * reports that the topology did not change since the
> +	 * preceding PFT instruction.
> +	 */
> +	ptf(PTF_REQ_CHECK, &rc);
> +	cc =3D ptf(PTF_REQ_CHECK, &rc);
> +	report(cc =3D=3D 0, "PTF check should clear topology report");
> +	report_prefix_pop();
> +
> +	report_prefix_push("Topology polarisation check");
> +	/*
> +	 * We can not assume the state of the polarization for
> +	 * any Virtual Machine but KVM.

Random Capitalization :)
Why can you not test the same thing for other hypervisors/LPAR?

> +	 * Let's skip the polarisation tests for other VMs.
> +	 */
> +	if (!host_is_kvm()) {
> +		report_skip("Topology polarisation check is done for KVM only");
> +		goto end;
> +	}
> +
> +	/*
> +	 * Set vertical polarization to verify that RESET sets
> +	 * horizontal polarization back.
> +	 */

You might want to do a reset here also, since there could be some other
test case that could have run before and modified the polarization.
There isn't right now of course, but doing a reset improves separation of t=
ests.

> +	cc =3D ptf(PTF_REQ_VERTICAL, &rc);
> +	report(cc =3D=3D 0, "Set vertical polarization.");
> +
> +	report(diag308_load_reset(1), "load normal reset done");
> +
> +	cc =3D ptf(PTF_REQ_CHECK, &rc);
> +	report(cc =3D=3D 0, "Reset should clear topology report");
> +
> +	cc =3D ptf(PTF_REQ_HORIZONTAL, &rc);
> +	report(cc =3D=3D 2 && rc =3D=3D PTF_ERR_ALRDY_POLARIZED,
> +	       "After RESET polarization is horizontal");
> +
> +	/* Flip between vertical and horizontal polarization */
> +	cc =3D ptf(PTF_REQ_VERTICAL, &rc);
> +	report(cc =3D=3D 0, "Change to vertical polarization.");
> +
> +	cc =3D ptf(PTF_REQ_CHECK, &rc);
> +	report(cc =3D=3D 1, "Polarization change should set topology report");
> +
> +	cc =3D ptf(PTF_REQ_HORIZONTAL, &rc);
> +	report(cc =3D=3D 0, "Change to horizontal polarization.");
> +
> +end:
> +	report_prefix_pop();
> +}
> +
> +static struct {
> +	const char *name;
> +	void (*func)(void);
> +} tests[] =3D {
> +	{ "PTF", test_ptf},
> +	{ NULL, NULL }
> +};
> +
> +int main(int argc, char *argv[])
> +{
> +	int i;
> +
> +	report_prefix_push("CPU Topology");
> +
> +	if (!test_facility(11)) {
> +		report_skip("Topology facility not present");
> +		goto end;
> +	}
> +
> +	report_info("Virtual machine level %ld", stsi_get_fc());
> +
> +	for (i =3D 0; tests[i].name; i++) {
> +		report_prefix_push(tests[i].name);
> +		tests[i].func();
> +		report_prefix_pop();
> +	}
> +
> +end:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 3caf81e..3530cc4 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -208,3 +208,6 @@ groups =3D migration
>  [exittime]
>  file =3D exittime.elf
>  smp =3D 2
> +
> +[topology]
> +file =3D topology.elf

