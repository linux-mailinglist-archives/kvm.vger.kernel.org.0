Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D73539E37
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 09:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350314AbiFAHaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 03:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350326AbiFAHaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 03:30:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFB56AA47;
        Wed,  1 Jun 2022 00:30:06 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2516i3s4022473;
        Wed, 1 Jun 2022 07:30:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=lzG6DxYnWWvkuJZ0Xwy0AvuwKlWLv5luH1uePCi9W8I=;
 b=saiugwYczUflwQzcBWrz2CX0FXDnOIDlM9KAJs5aueDD5VNJYtPkjAyMv+6gvBTSGd+C
 /IOxW2UsiUopBp0BwPt6VVZrTwMrW1sXzhyEBjhoSIZAi2HbbdO9TtD/nqOYG7yh7YI0
 9ZppV3O3s6EstJv7L+HzGh57VoNr//LG6ebsqexbUggCzVoGK2yNeIQWz4+3NhXDjrZy
 DY0FIv3EMr7NMhCHFlPnz5qu4vhrXIDIbFX/WPeFn2Knzt4wmnUkrtjoqW1drqbsr+aj
 pMawEVqsLuxMu/0s3uAuv0rrw8S6t3Rdb1Wkzf2Ds1rcr70a8T2sRct1juV0FZi9eaWW SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ge33p8xky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 07:30:05 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2517U5K3022599;
        Wed, 1 Jun 2022 07:30:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ge33p8xjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 07:30:05 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2517Kw1M006863;
        Wed, 1 Jun 2022 07:30:02 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3gbc7h5838-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 07:30:02 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2517TxK134013472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 07:29:59 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E87D2A405B;
        Wed,  1 Jun 2022 07:29:58 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68D5AA405C;
        Wed,  1 Jun 2022 07:29:58 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1 (unknown [9.171.76.15])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed,  1 Jun 2022 07:29:58 +0000 (GMT)
Date:   Wed, 1 Jun 2022 09:29:55 +0200
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, scgl@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: add migration test for
 storage keys
Message-ID: <20220601092955.374abb63@li-ca45c2cc-336f-11b2-a85c-c6e71de567f1>
In-Reply-To: <ed8e3b8a-e7ac-d432-f733-82fdaf668c1b@redhat.com>
References: <20220531083713.48534-1-nrb@linux.ibm.com>
        <20220531083713.48534-2-nrb@linux.ibm.com>
        <ed8e3b8a-e7ac-d432-f733-82fdaf668c1b@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7QqCvNEG4qVeMCJyA2IVP2wQ7U41YlUT
X-Proofpoint-ORIG-GUID: 5WIg3Hni5fXe749S0HL140pUAtKUo35N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_02,2022-05-30_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206010031
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 31 May 2022 10:55:27 +0200
Thomas Huth <thuth@redhat.com> wrote:

> On 31/05/2022 10.37, Nico Boehr wrote:
> > Upon migration, we expect storage keys set by the guest to be
> > preserved, so add a test for it.
> > 
> > We keep 128 pages and set predictable storage keys. Then, we
> > migrate and check that they can be read back and match the value
> > originally set.
> > 
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   s390x/Makefile         |  1 +
> >   s390x/migration-skey.c | 76
> > ++++++++++++++++++++++++++++++++++++++++++ s390x/unittests.cfg    |
> >  4 +++ 3 files changed, 81 insertions(+)
> >   create mode 100644 s390x/migration-skey.c
> > 
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index 25802428fa13..94fc5c1a3527 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -33,6 +33,7 @@ tests += $(TEST_DIR)/adtl-status.elf
> >   tests += $(TEST_DIR)/migration.elf
> >   tests += $(TEST_DIR)/pv-attest.elf
> >   tests += $(TEST_DIR)/migration-cmm.elf
> > +tests += $(TEST_DIR)/migration-skey.elf
> >   
> >   pv-tests += $(TEST_DIR)/pv-diags.elf
> >   
> > diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> > new file mode 100644
> > index 000000000000..f846ac435836
> > --- /dev/null
> > +++ b/s390x/migration-skey.c
> > @@ -0,0 +1,76 @@
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
> > +static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE]
> > __attribute__((aligned(PAGE_SIZE))); +
> > +static void test_migration(void)
> > +{
> > +	union skey expected_key, actual_key;
> > +	int i, key_to_set;
> > +
> > +	for (i = 0; i < NUM_PAGES; i++) {
> > +		/*
> > +		 * Storage keys are 7 bit, lowest bit is always
> > returned as zero
> > +		 * by iske
> > +		 */
> > +		key_to_set = i * 2;
> > +		set_storage_key(pagebuf[i], key_to_set, 1);
> > +	}
> > +
> > +	puts("Please migrate me, then press return\n");
> > +	(void)getchar();
> > +
> > +	for (i = 0; i < NUM_PAGES; i++) {
> > +		report_prefix_pushf("page %d", i);
> > +
> > +		actual_key.val = get_storage_key(pagebuf[i]);
> > +		expected_key.val = i * 2;
> > +
> > +		/* ignore reference bit */
> > +		actual_key.str.rf = 0;
> > +		expected_key.str.rf = 0;  
> 
> If the reference bit gets always ignored, testing 64 pages should be
> enough? OTOH this will complicate the for-loop / creation of the key
> value, so I don't mind too much if we keep it this way.
> 
> > +		report(actual_key.val == expected_key.val,
> > "expected_key=0x%x actual_key=0x%x", expected_key.val,
> > actual_key.val); +
> > +		report_prefix_pop();
> > +	}
> > +}
> > +
> > +int main(void)
> > +{
> > +	report_prefix_push("migration-skey");
> > +	if (test_facility(169)) {
> > +		report_skip("storage key removal facility is
> > active"); +
> > +		/*
> > +		 * If we just exit and don't ask migrate_cmd to
> > migrate us, it
> > +		 * will just hang forever. Hence, also ask for
> > migration when we
> > +		 * skip this test altogether.
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
> 
> 	} else {
> 		test_migration();
> 	}
> 
> to get rid of the goto?
> 
> > +	report_prefix_pop();
> > +	return report_summary();
> > +}  
> 
> Either way:
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

