Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC69753861
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 12:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbjGNKjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 06:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235969AbjGNKji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 06:39:38 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C37130E7;
        Fri, 14 Jul 2023 03:39:36 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EAMeb8024261;
        Fri, 14 Jul 2023 10:39:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=D/l8Vy0OWGFOokk4nq9VdFAFqFk2R1Vw0pI8PQEgfEw=;
 b=H4TO+vJIdiFgCgYy80ys7Cmox6LjI4P4Q4h/UFjiaKb4p4G4+4hqGXK57AMFFVN+sypQ
 VKx/uDd6HGyzt+bnLQlWdwGtAjF8x0ytre8WiGaxI4O+/0XtzioSHay0snjDBLvA4S7G
 5ys0xZ3ShoQvK2VrZvMzglXoro/S3XW1iBwU/RxaSpPk2edOkloiknHGSDwqe6X3dyFS
 sFy5KU40wHyLM40XKOKF+2BlN/28I0AyQWyiS0uFTvbrYuuVIFfbT2G7x/StZYZkAzSj
 Fcw1jD76vtt64eCS31C3aah6jvHxzNh6LPtYBQK4+SxZjQegibtbiLMUK2Jf6BoRLDmY Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ru4j60c2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 10:39:35 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36EAPNVo001223;
        Fri, 14 Jul 2023 10:39:34 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ru4j60c2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 10:39:34 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36E88EMG031248;
        Fri, 14 Jul 2023 10:39:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3rtpvu12tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 10:39:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36EAdVxg66584892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 10:39:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B6EF20049;
        Fri, 14 Jul 2023 10:39:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7360C20040;
        Fri, 14 Jul 2023 10:39:30 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.42.10])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jul 2023 10:39:30 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <fd822214-ce34-41dd-d0b6-d43709803958@redhat.com>
References: <20230712114149.1291580-1-nrb@linux.ibm.com> <20230712114149.1291580-7-nrb@linux.ibm.com> <1aac769e-7523-a858-8286-35625bfb0145@redhat.com> <168932372015.12187.10530769865303760697@t14-nrb> <fd822214-ce34-41dd-d0b6-d43709803958@redhat.com>
To:     Thomas Huth <thuth@redhat.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 6/6] s390x: add a test for SIE without MSO/MSL
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Message-ID: <168933116940.12187.12275217086609823396@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 14 Jul 2023 12:39:29 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v51SslMG1Vfs5lbw7uE2XxDik04CyI6y
X-Proofpoint-ORIG-GUID: dvxZXq8hyDf_FNDEoJ0NeEkIUPcxEtv0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_05,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 bulkscore=0 clxscore=1015 mlxlogscore=819 mlxscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140096
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-07-14 10:40:28)
> On 14/07/2023 10.35, Nico Boehr wrote:
> > Quoting Thomas Huth (2023-07-13 10:29:48)
> > [...]
> >>> diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
> >>> new file mode 100644
> >>> index 000000000000..b326995dfa85
> >>> --- /dev/null
> >>> +++ b/s390x/sie-dat.c
> >>> @@ -0,0 +1,115 @@
> >>> +/* SPDX-License-Identifier: GPL-2.0-only */
> >>> +/*
> >>> + * Tests SIE with paging.
> >>> + *
> >>> + * Copyright 2023 IBM Corp.
> >>> + *
> >>> + * Authors:
> >>> + *    Nico Boehr <nrb@linux.ibm.com>
> >>> + */
> >>> +#include <libcflat.h>
> >>> +#include <vmalloc.h>
> >>> +#include <asm/pgtable.h>
> >>> +#include <mmu.h>
> >>> +#include <asm/page.h>
> >>> +#include <asm/interrupt.h>
> >>> +#include <alloc_page.h>
> >>> +#include <sclp.h>
> >>> +#include <sie.h>
> >>> +#include <snippet.h>
> >>> +
> >>> +static struct vm vm;
> >>> +static pgd_t *guest_root;
> >>> +
> >>> +/* keep in sync with TEST_PAGE_COUNT in s390x/snippets/c/sie-dat.c */
> >>> +#define GUEST_TEST_PAGE_COUNT 10
> >>> +
> >>> +/* keep in sync with TOTAL_PAGE_COUNT in s390x/snippets/c/sie-dat.c =
*/
> >>> +#define GUEST_TOTAL_PAGE_COUNT 256
> >>
> >> I'd maybe put the defines rather in a header a la s390x/snippets/c/sie=
-dat.h
> >> and include that header here and in the snippet C code.
> >=20
> > I'd have to
> >=20
> > #include "../s390x/snippets/c/sie-dat.h"
> >=20
> > and it feels like I shouldn't be doing this, should I?
>=20
> Why "../s390x/" ? Isn't #include "snippets/c/sie-dat.h" enough? ... that =

> would look reasonable to me.

No, it isn't at least on my box:

s390x/snippets/c/sie-dat.c:15:10: fatal error: snippets/c/sie-dat.h: No suc=
h file or directory
   15 | #include "snippets/c/sie-dat.h"
      |          ^~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
