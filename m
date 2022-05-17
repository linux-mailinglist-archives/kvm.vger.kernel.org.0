Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCDDD529C38
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 10:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243376AbiEQISe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 04:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242924AbiEQISC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 04:18:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D1F3CFCB;
        Tue, 17 May 2022 01:17:29 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24H5DJOb001817;
        Tue, 17 May 2022 08:17:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=99iLdgC7LJ7I8yVTgHGdc+B+5YEYkmDPHryfWT08zpE=;
 b=BXjBUIp2S5dTAJmFJFymGaJYHeyEaS5EwS+n6BsgNlEeDoIQkC1p3h1SPFrHbDfqxS6j
 IDOvXIGxtZZo+HLvSVMJ0vqETbtXn8SBEm5+o8gEkCfw8n3AI6szsWwNGoWMafglgfgI
 Y17UfwgPk3l79BYe1j31r/Ornid+Y3CLQqexuukRMXecDSH9ftdv38MWHvyRbBkn8+qy
 owmTbGiebS103V9n3BX5RB+h+W5dIqYkEfGQJVUw6H8iOgzb76iW2k5NMgjKpqPp6cFE
 zWt0iHUWVNW+l1Lq+ROLwg6QhF/x0b5iPDrp8Dz0eHTkdNwVMmVTLgmIQJTDETq6QfDB Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g45c63ks0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 08:17:28 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24H7ULJn009153;
        Tue, 17 May 2022 08:17:27 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g45c63krn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 08:17:27 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24H8CN8L024053;
        Tue, 17 May 2022 08:17:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3g2428k2xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 08:17:25 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24H8HM7l46858656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 08:17:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9765DAE051;
        Tue, 17 May 2022 08:17:22 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FAF2AE045;
        Tue, 17 May 2022 08:17:22 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.55.58])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 08:17:22 +0000 (GMT)
Message-ID: <3ab95d5d553362a686b9526c8b53996dcaf20400.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: add migration test for
 storage keys
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Date:   Tue, 17 May 2022 10:17:22 +0200
In-Reply-To: <947af627-64e0-486d-18e2-c877bc4c4ba6@linux.ibm.com>
References: <20220516090702.1939253-1-nrb@linux.ibm.com>
         <20220516090702.1939253-2-nrb@linux.ibm.com>
         <947af627-64e0-486d-18e2-c877bc4c4ba6@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ChnUQPcNoslWaNsFl0armD3xU7Y9NbDN
X-Proofpoint-GUID: ZfRUhInKflrWhAnuDBwUbw3cYbJE_GK2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_01,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=710 suspectscore=0
 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-05-16 at 18:47 +0200, Janis Schoetterl-Glausch wrote:
> On 5/16/22 11:07, Nico Boehr wrote:
> > Upon migration, we expect storage keys being set by the guest to be
> > preserved,
> > so add a test for it.
>=20
> "being set" implies that keys are set while the migration is going
> on.
> That's not the case, is it?

Fixed.

> > We keep 128 pages and set predictable storage keys. Then, we
> > migrate and check
> > they can be read back and the respective access restrictions are in
> > place when
>=20
> ... check that they ...

Added that.

>=20
> > the access key in the PSW doesn't match.
>=20
> The latter half of the sentence doesn't apply anymore, now that you
> simplified the test.
> So maybe something like: ... and check that they can be read back and
> match the value
> originally set.

Fixed.

> > diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> > new file mode 100644
> > index 000000000000..ee4622eb94ba
> > --- /dev/null
> > +++ b/s390x/migration-skey.c
> > @@ -0,0 +1,78 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Storage Key migration tests
> > + *
> > + * Copyright IBM Corp. 2022
> > + *
> > + * Authors:
> > + *=C2=A0 Nico Boehr <nrb@linux.ibm.com>
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
> > __attribute__((aligned(PAGE_SIZE)));
> > +
> > +static void test_migration(void)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int i, key_to_set;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint8_t *page;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0union skey expected_key, act=
ual_key;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for (i =3D 0; i < NUM_PAGES;=
 i++) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0/*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * Storage keys are 7 bit, lowest bit is always
> > returned as zero
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * by iske
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0key_to_set =3D i * 2;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0set_storage_key(pagebuf[i], key_to_set, 1);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0puts("Please migrate me, the=
n press return\n");
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(void)getchar();
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for (i =3D 0; i < NUM_PAGES;=
 i++) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0report_prefix_pushf("page %d", i);
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0page =3D &pagebuf[i][0];
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0actual_key.val =3D get_storage_key(page);
>=20
> The page variable is kinda useless now, I'd just do
> get_storage_key(pagebuf[0]).

Removed.

> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0expected_key.val =3D i * 2;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0/* ignore reference bit */
>=20
> Why? Are there any implicit references I'm missing?

Since the PoP specifies (p. 5-122):

"The record of references provided by the reference
bit is not necessarily accurate. However, in the major-
ity of situations, reference recording approximately
coincides with the related storage reference."

I don't really see a way to test this properly.

Maybe I missed something?


