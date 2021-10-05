Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225B3422765
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbhJENL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:11:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26127 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233365AbhJENLV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:11:21 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195D3pNP017306;
        Tue, 5 Oct 2021 09:09:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=n5UEgaUcOrLZ89eQIX7A0DmmkYfk/A/7vPAsnZI/KLQ=;
 b=fQQz3iXqpni19Ux2zQammSWm39yOU/oH3kWIlkVCJafZ24Er3RZbA2N9dN/vUmv64UEr
 MvjiWlo2BgV/8uOuTNyBe9G2kA9pg8a4QLsbkkvr1Z6zyB1dspkOaWiA/5gM52yMNphp
 jw1cassqN/ROEKfumoJIZi4XoEI1RQpTVse9tARcr8G6q63gQ5/2S+bbvvX8XCiADqVb
 O2ZukHusx+yLpQ76IGJJbvftyU1zHC6Qad2xCy0S7X7mDDcd2v4Xj8byKs/Q7v4sUqu/
 HFTmQH5h6SoXTkkjq5GDZyfG0tS4T8Uj5NZcTL56NIcQTdQJNP4+XeM47ePKqgE633qa cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgq1k0mc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:09:28 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 195D4GhP024166;
        Tue, 5 Oct 2021 09:09:28 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgq1k0mbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:09:28 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195D6oGb022013;
        Tue, 5 Oct 2021 13:09:26 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3bef2atjeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 13:09:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195D9McH43385190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 13:09:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAA70A4067;
        Tue,  5 Oct 2021 13:09:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29482A405F;
        Tue,  5 Oct 2021 13:09:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.133])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Oct 2021 13:09:22 +0000 (GMT)
Date:   Tue, 5 Oct 2021 15:09:19 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: Add specification
 exception interception test
Message-ID: <20211005150919.04425060@p-imbrenda>
In-Reply-To: <20211005091153.1863139-3-scgl@linux.ibm.com>
References: <20211005091153.1863139-1-scgl@linux.ibm.com>
        <20211005091153.1863139-3-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pgjMPb_tgndzvSttlMHAwW4jlue_ehOY
X-Proofpoint-GUID: -uHU1VX53VGAjzL5MtAfnLxIEIjSjRa4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_02,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110050078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 Oct 2021 11:11:53 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Check that specification exceptions cause intercepts when
> specification exception interpretation is off.
> Check that specification exceptions caused by program new PSWs
> cause interceptions.
> We cannot assert that non program new PSW specification exceptions
> are interpreted because whether interpretation occurs or not is
> configuration dependent.
>=20
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  s390x/Makefile             |  2 +
>  lib/s390x/sie.h            |  1 +
>  s390x/snippets/c/spec_ex.c | 20 +++++++++
>  s390x/spec_ex-sie.c        | 83 ++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg        |  3 ++
>  5 files changed, 109 insertions(+)
>  create mode 100644 s390x/snippets/c/spec_ex.c
>  create mode 100644 s390x/spec_ex-sie.c
>=20
> diff --git a/s390x/Makefile b/s390x/Makefile
> index ef8041a..7198882 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -24,6 +24,7 @@ tests +=3D $(TEST_DIR)/mvpg.elf
>  tests +=3D $(TEST_DIR)/uv-host.elf
>  tests +=3D $(TEST_DIR)/edat.elf
>  tests +=3D $(TEST_DIR)/mvpg-sie.elf
> +tests +=3D $(TEST_DIR)/spec_ex-sie.elf
> =20
>  tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
>  ifneq ($(HOST_KEY_DOCUMENT),)
> @@ -85,6 +86,7 @@ snippet_asmlib =3D $(SNIPPET_DIR)/c/cstart.o
>  # perquisites (=3Dguests) for the snippet hosts.
>  # $(TEST_DIR)/<snippet-host>.elf: snippets =3D $(SNIPPET_DIR)/<c/asm>/<s=
nippet>.gbin
>  $(TEST_DIR)/mvpg-sie.elf: snippets =3D $(SNIPPET_DIR)/c/mvpg-snippet.gbin
> +$(TEST_DIR)/spec_ex-sie.elf: snippets =3D $(SNIPPET_DIR)/c/spec_ex.gbin
> =20
>  $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
>  	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index ca514ef..7ef7251 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -98,6 +98,7 @@ struct kvm_s390_sie_block {
>  	uint8_t		fpf;			/* 0x0060 */
>  #define ECB_GS		0x40
>  #define ECB_TE		0x10
> +#define ECB_SPECI	0x08
>  #define ECB_SRSI	0x04
>  #define ECB_HOSTPROTINT	0x02
>  	uint8_t		ecb;			/* 0x0061 */
> diff --git a/s390x/snippets/c/spec_ex.c b/s390x/snippets/c/spec_ex.c
> new file mode 100644
> index 0000000..bdba4f4
> --- /dev/null
> +++ b/s390x/snippets/c/spec_ex.c
> @@ -0,0 +1,20 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * =C2=A9 Copyright IBM Corp. 2021
> + *
> + * Snippet used by specification exception interception test.
> + */
> +#include <stdint.h>
> +#include <asm/arch_def.h>
> +
> +__attribute__((section(".text"))) int main(void)
> +{
> +	struct lowcore *lowcore =3D (struct lowcore *) 0;
> +	uint64_t bad_psw =3D 0;
> +
> +	/* PSW bit 12 has no name or meaning and must be 0 */
> +	lowcore->pgm_new_psw.mask =3D 1UL << (63 - 12);

you can use the BIT or BIT_ULL macro

> +	lowcore->pgm_new_psw.addr =3D 0xdeadbeee;

if the system is broken, it might actually jump at that address; in
that case, will the test fail?

> +	asm volatile ("lpsw %0" :: "Q"(bad_psw));
> +	return 0;
> +}
> diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
> new file mode 100644
> index 0000000..b7e79de
> --- /dev/null
> +++ b/s390x/spec_ex-sie.c
> @@ -0,0 +1,83 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * =C2=A9 Copyright IBM Corp. 2021
> + *
> + * Specification exception interception test.
> + * Checks that specification exception interceptions occur as expected w=
hen
> + * specification exception interpretation is off/on.
> + */
> +#include <libcflat.h>
> +#include <sclp.h>
> +#include <asm/page.h>
> +#include <asm/arch_def.h>
> +#include <alloc_page.h>
> +#include <vm.h>
> +#include <sie.h>
> +
> +static struct vm vm;
> +extern const char _binary_s390x_snippets_c_spec_ex_gbin_start[];
> +extern const char _binary_s390x_snippets_c_spec_ex_gbin_end[];
> +
> +static void setup_guest(void)
> +{
> +	char *guest;
> +	int binary_size =3D ((uintptr_t)_binary_s390x_snippets_c_spec_ex_gbin_e=
nd -
> +			   (uintptr_t)_binary_s390x_snippets_c_spec_ex_gbin_start);
> +
> +	setup_vm();
> +	guest =3D alloc_pages(8);
> +	memcpy(guest, _binary_s390x_snippets_c_spec_ex_gbin_start, binary_size);
> +	sie_guest_create(&vm, (uint64_t) guest, HPAGE_SIZE);
> +}
> +
> +static void reset_guest(void)
> +{
> +	vm.sblk->gpsw.addr =3D PAGE_SIZE * 4;
> +	vm.sblk->gpsw.mask =3D PSW_MASK_64;
> +	vm.sblk->icptcode =3D 0;
> +}
> +
> +static void test_spec_ex_sie(void)
> +{
> +	setup_guest();
> +
> +	report_prefix_push("SIE spec ex interpretation");
> +	report_prefix_push("off");
> +	reset_guest();
> +	sie(&vm);
> +	/* interpretation off -> initial exception must cause interception */
> +	report(vm.sblk->icptcode =3D=3D ICPT_PROGI
> +	       && vm.sblk->iprcc =3D=3D PGM_INT_CODE_SPECIFICATION
> +	       && vm.sblk->gpsw.addr !=3D 0xdeadbeee,
> +	       "Received specification exception intercept for initial exceptio=
n");
> +	report_prefix_pop();
> +
> +	report_prefix_push("on");
> +	vm.sblk->ecb |=3D ECB_SPECI;
> +	reset_guest();
> +	sie(&vm);
> +	/* interpretation on -> configuration dependent if initial exception ca=
uses
> +	 * interception, but invalid new program PSW must
> +	 */
> +	report(vm.sblk->icptcode =3D=3D ICPT_PROGI
> +	       && vm.sblk->iprcc =3D=3D PGM_INT_CODE_SPECIFICATION,
> +	       "Received specification exception intercept");
> +	if (vm.sblk->gpsw.addr =3D=3D 0xdeadbeee)
> +		report_info("Interpreted initial exception, intercepted invalid progra=
m new PSW exception");
> +	else
> +		report_info("Did not interpret initial exception");
> +	report_prefix_pop();
> +	report_prefix_pop();
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	if (!sclp_facilities.has_sief2) {
> +		report_skip("SIEF2 facility unavailable");
> +		goto out;
> +	}
> +
> +	test_spec_ex_sie();
> +out:
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 9e1802f..3b454b7 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -109,3 +109,6 @@ file =3D edat.elf
> =20
>  [mvpg-sie]
>  file =3D mvpg-sie.elf
> +
> +[spec_ex-sie]
> +file =3D spec_ex-sie.elf

