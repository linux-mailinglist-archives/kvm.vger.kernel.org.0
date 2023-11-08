Return-Path: <kvm+bounces-1190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC07F7E55C7
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:49:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65263280D6D
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23534168CD;
	Wed,  8 Nov 2023 11:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VoH14TI8"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C28B2CA8
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 11:49:28 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9161711;
	Wed,  8 Nov 2023 03:49:27 -0800 (PST)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8BJgwL028743;
	Wed, 8 Nov 2023 11:49:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=CEJaMbaHhCqIClsnYdCkXryOy8I92xAA0bWxJfAZYto=;
 b=VoH14TI8sA2zsXeaaLbpyChIPLEdIc2PawPtirZvA6V1jIDTatHj/mqqgC7ygao441VW
 m17mkKtHXsL4dp9ZI1593o4xBt25R8DRebgvW7mC19Z0JjDGK2KaC+Ckdl8yHP0PVTDB
 rNBLE4P7CC8lVPly3UmEBUxYyH7Iy73DGnBycOF4HNk1Y449pLR68MCun0Nd/4gwyR+M
 vYlHCiYqxXanqPtZejglIGjK4zP0CDyKJ1hlUMcBy3/qWEcACXO/gnN8yAnTpheCtT/6
 OgEi+avE3m2Iq2dMUhQ8ezAdSdVKJy2G7qZA1YOZClr/wnGNND7Zg8Qm1FKjRLJsD0v6 Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u89byh5kf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 11:49:26 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A8BduaA017436;
	Wed, 8 Nov 2023 11:49:26 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u89byh5k8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 11:49:26 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8BUAeC014506;
	Wed, 8 Nov 2023 11:49:25 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w21vejx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 11:49:25 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A8BnMoS6619696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Nov 2023 11:49:22 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 440D320040;
	Wed,  8 Nov 2023 11:49:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C4572004E;
	Wed,  8 Nov 2023 11:49:21 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.7.102])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Nov 2023 11:49:21 +0000 (GMT)
Message-ID: <2c15b9a6b97666805491a06deee4bac497ed88cd.camel@linux.ibm.com>
Subject: Re: [PATCH v2 2/4] KVM: s390: vsie: Fix length of facility list
 shadowed
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sven Schnelle
 <svens@linux.ibm.com>
Date: Wed, 08 Nov 2023 12:49:21 +0100
In-Reply-To: <20231108122338.0ff2052e@p-imbrenda>
References: <20231107123118.778364-1-nsg@linux.ibm.com>
	 <20231107123118.778364-3-nsg@linux.ibm.com>
	 <20231108122338.0ff2052e@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: URwrf1P0upx-d4CQwioRC4_AbXOHfxZ1
X-Proofpoint-GUID: kp19vDC3t1XntH_n0vFrNhPoOrnmESsO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_01,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=615 spamscore=0 phishscore=0
 clxscore=1015 adultscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311080098

On Wed, 2023-11-08 at 12:23 +0100, Claudio Imbrenda wrote:
> On Tue,  7 Nov 2023 13:31:16 +0100
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> [...]
>=20
> > diff --git a/arch/s390/kernel/facility.c b/arch/s390/kernel/facility.c
> > new file mode 100644
> > index 000000000000..5e80a4f65363
> > --- /dev/null
> > +++ b/arch/s390/kernel/facility.c
> > @@ -0,0 +1,21 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright IBM Corp. 2023
> > + */
> > +
> > +#include <asm/facility.h>
> > +
> > +unsigned int stfle_size(void)
> > +{
> > +	static unsigned int size;
> > +	u64 dummy;
> > +	unsigned int r;
>=20
> reverse Christmas tree please :)

Might be an opportunity to clear that up for me.
AFAIK reverse christmas tree isn't universally enforced in the kernel.
Do we do it in generic s390 code? I know we do for s390 kvm.
Personally I don't quite get the rational, but I don't care much either :)
Heiko?

> with that fixed:
>=20
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>=20
> [...]


