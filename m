Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CE4526200
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 14:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379952AbiEMMdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 08:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380293AbiEMMdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 08:33:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C7266FB6;
        Fri, 13 May 2022 05:33:32 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24DAU5Cb011649;
        Fri, 13 May 2022 12:33:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=WhG4yz5Z/QrVltPYX+swCE87IQuQLsEPCzyQQPyCQGo=;
 b=pUBQjIhXnxrPkfcZ9XG6tFjE09VDdkXx9WJRKV+4+8WSw9QOQsyc+KQsg5HR5qL/yMYD
 x+DLUkY38VJNpIR+Nd92VwUQNxqkZIXYoUb4fGHTx+xoT3V5sxgbRovlckyFf2Dvfnc+
 sVP4iZJpe+a5ov42CkEKsBUPiFAOwXWiEX4TWvTaEBLvaswxIHGi6Tot0tX9zZJ4beMS
 8qQk3jaPOQTJleIs0Rgqo/pcM8rQSVUSJh4AhsYc+IJL232wmiywHv5hduavJa1XkzFh
 rUv9YoncjC4Ws/F+KSDQ+acZKufs+gXN4T/GAwGU6gFCeizUzLOma4i9uq1rmSo8Luo5 lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1nmttb25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 12:33:31 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24DC7Hos016635;
        Fri, 13 May 2022 12:33:31 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1nmttb1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 12:33:31 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24DCU8qK004045;
        Fri, 13 May 2022 12:33:29 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3g0ma1j3r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 12:33:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24DCJjf353412160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 12:19:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D83AFA405B;
        Fri, 13 May 2022 12:33:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1EA7A4054;
        Fri, 13 May 2022 12:33:25 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 12:33:25 +0000 (GMT)
Date:   Fri, 13 May 2022 14:33:23 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add migration test for
 storage keys
Message-ID: <20220513143323.25ca256a@p-imbrenda>
In-Reply-To: <5781a3a7-c76c-710d-4236-b82f6e821c48@linux.ibm.com>
References: <20220512140107.1432019-1-nrb@linux.ibm.com>
        <20220512140107.1432019-3-nrb@linux.ibm.com>
        <5781a3a7-c76c-710d-4236-b82f6e821c48@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jxrAIucR5S5CRYMOBWVE5HEMlR8cIcdu
X-Proofpoint-GUID: 00fCtgkxeGyK5loQVimsK0RY7h6yAh4m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205130055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 May 2022 13:04:34 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> On 5/12/22 16:01, Nico Boehr wrote:
> > Upon migration, we expect storage keys being set by the guest to be preserved,
> > so add a test for it.
> > 
> > We keep 128 pages and set predictable storage keys. Then, we migrate and check
> > they can be read back and the respective access restrictions are in place when
> > the access key in the PSW doesn't match.
> > 
> > TCG currently doesn't implement key-controlled protection, see
> > target/s390x/mmu_helper.c, function mmu_handle_skey(), hence add the relevant
> > tests as xfails.
> > 
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >  s390x/Makefile         |  1 +
> >  s390x/migration-skey.c | 98 ++++++++++++++++++++++++++++++++++++++++++
> >  s390x/unittests.cfg    |  4 ++
> >  3 files changed, 103 insertions(+)
> >  create mode 100644 s390x/migration-skey.c
> > 
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index a8e04aa6fe4d..f8ea594b641d 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -32,6 +32,7 @@ tests += $(TEST_DIR)/epsw.elf
> >  tests += $(TEST_DIR)/adtl-status.elf
> >  tests += $(TEST_DIR)/migration.elf
> >  tests += $(TEST_DIR)/pv-attest.elf
> > +tests += $(TEST_DIR)/migration-skey.elf
> >  
> >  pv-tests += $(TEST_DIR)/pv-diags.elf
> >  
> > diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> > new file mode 100644
> > index 000000000000..6f3053d8ab40
> > --- /dev/null
> > +++ b/s390x/migration-skey.c
> > @@ -0,0 +1,98 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Storage Key migration tests
> > + *
> > + * Copyright IBM Corp. 2022
> > + *
> > + * Authors:
> > + *  Nico Boehr <nrb@linux.ibm.com>
> > + */
> > +
> > +#include <libcflat.h>
> > +#include <asm/facility.h>
> > +#include <asm/page.h>
> > +#include <asm/mem.h>
> > +#include <asm/interrupt.h>
> > +#include <hardware.h>
> > +
> > +#define NUM_PAGES 128
> > +static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> > +
> > +static void test_migration(void)
> > +{
> > +	int i, key_to_set;
> > +	uint8_t *page;
> > +	union skey expected_key, actual_key, mismatching_key;  
> 
> I would tend to scope those to the bodies of the respective loop,
> but I don't know if that's in accordance with the coding style.

I don't think this is specified explicitly; personally I have a light
preference for declaring everything upfront (like here), but again,
this is not a big deal for me (and maybe Janosch and Thomas should
also chime in and tell what their preference is)

> > +
> > +	for (i = 0; i < NUM_PAGES; i++) {
> > +		/*
> > +		 * Storage keys are 7 bit, lowest bit is always returned as zero
> > +		 * by iske
> > +		 */
> > +		key_to_set = i * 2;
> > +		set_storage_key(pagebuf + i, key_to_set, 1);  
> 
> Why not just pagebuf[i]?
> > +	}
> > +
> > +	puts("Please migrate me, then press return\n");
> > +	(void)getchar();
> > +
> > +	for (i = 0; i < NUM_PAGES; i++) {
> > +		report_prefix_pushf("page %d", i);
> > +
> > +		page = &pagebuf[i][0];
> > +		actual_key.val = get_storage_key(page);
> > +		expected_key.val = i * 2;
> > +
> > +		/* ignore reference bit */
> > +		actual_key.str.rf = 0;
> > +		expected_key.str.rf = 0;
> > +
> > +		report(actual_key.val == expected_key.val, "expected_key=0x%x actual_key=0x%x", expected_key.val, actual_key.val);
> > +
> > +		/* ensure access key doesn't match storage key and is never zero */
> > +		mismatching_key.str.acc = expected_key.str.acc < 15 ? expected_key.str.acc + 1 : 1;
> > +		*page = 0xff;
> > +
> > +		expect_pgm_int();
> > +		asm volatile (
> > +			/* set access key */
> > +			"spka 0(%[mismatching_key])\n"
> > +			/* try to write page */
> > +			"mvi 0(%[page]), 42\n"
> > +			/* reset access key */
> > +			"spka 0\n"
> > +			:
> > +			: [mismatching_key] "a"(mismatching_key.val),
> > +			  [page] "a"(page)
> > +			: "memory"
> > +		);
> > +		check_pgm_int_code_xfail(host_is_tcg(), PGM_INT_CODE_PROTECTION);
> > +		report_xfail(host_is_tcg(), *page == 0xff, "no store occured");  
> 
> What are you testing with this bit? If storage keys are really effective after the migration?
> I'm wondering if using tprot would not be better, it should simplify the code a lot.
> Plus you'd easily test for fetch protection, too.

on the other hand you could have tprot successful, but then not honour
the protection it indicates (I don't know how TPROT is implemented in
TCG)

to be fair, this test is only about checking that storage keys are
correctly migrated, maybe the check for actual protection is out of
scope

> > +
> > +		report_prefix_pop();
> > +	}
> > +}
> > +
> > +int main(void)
> > +{
> > +	report_prefix_push("migration-skey");
> > +	if (test_facility(169)) {
> > +		report_skip("storage key removal facility is active");
> > +
> > +		/*
> > +		 * If we just exit and don't ask migrate_cmd to migrate us, it
> > +		 * will just hang forever. Hence, also ask for migration when we
> > +		 * skip this test alltogether.  
> 
> s/alltogether/altogether/
> 
> > +		 */
> > +		puts("Please migrate me, then press return\n");
> > +		(void)getchar();
> > +
> > +		goto done;
> > +	}
> > +
> > +	test_migration();
> > +
> > +done:
> > +	report_prefix_pop();
> > +	return report_summary();
> > +}
> > diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> > index b456b2881448..1e851d8e3dd8 100644
> > --- a/s390x/unittests.cfg
> > +++ b/s390x/unittests.cfg
> > @@ -176,3 +176,7 @@ extra_params = -cpu qemu,gs=off,vx=off
> >  file = migration.elf
> >  groups = migration
> >  smp = 2
> > +
> > +[migration-skey]
> > +file = migration-skey.elf
> > +groups = migration  
> 

