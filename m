Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A4F65103D
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 17:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbiLSQWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 11:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiLSQWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 11:22:51 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCA3133;
        Mon, 19 Dec 2022 08:22:50 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJGD1ce026377;
        Mon, 19 Dec 2022 16:22:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3HtBoTonzOT2hExbR8J6XPSPHD4+uMWJFOenI/y/MBw=;
 b=lBtYXND2yPDnfjOa+1ThIV29LpEa0EkRhIPElp90dR8lW3JoiY84QRVo69/JDLOqLXr5
 mJiT/WgCZGwXwdwr7KvEXkTqpNfwgEM4mMTcnGQ0nr4ZXKM3tAuecOxdX/juKCvVlxup
 kfdEyOjYhrTF5FcgBV7Lx08bfSM4kBOCz0XhNpRPuC24JnxH/dPjziQWzTrtMBPkJoW1
 3c5vw12nOM1KcRRuhi2OYUT65OVlSG5kmY78kOejvUX7GCtcBFXOvdOof8bknuy7YbhP
 YB78+7tE+aD4pYiDsrXivxQwR/x+eGRHK9sST8XtxyrrJy/IChIge2OnsXgQWHbxN1u0 eA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mju9egd17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 16:22:49 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJFC8aZ007421;
        Mon, 19 Dec 2022 16:22:48 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3mh6yxeer3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 16:22:48 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJGMlWa8782448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 16:22:47 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 386D15805F;
        Mon, 19 Dec 2022 16:22:47 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6F5F58058;
        Mon, 19 Dec 2022 16:22:45 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.60.89.68])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Dec 2022 16:22:45 +0000 (GMT)
Message-ID: <838d9eb9c83637c3f9b8fe9aa5d4128785f501f0.camel@linux.ibm.com>
Subject: Re: [PATCH v1 08/16] vfio/ccw: pass page count to page_array struct
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Date:   Mon, 19 Dec 2022 11:22:45 -0500
In-Reply-To: <caa39cd9-d488-fea2-6569-88d08b9621b3@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
         <20221121214056.1187700-9-farman@linux.ibm.com>
         <caa39cd9-d488-fea2-6569-88d08b9621b3@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Iwb7yzS5RFr102qfc2E8PTwJGwQ75UVD
X-Proofpoint-GUID: Iwb7yzS5RFr102qfc2E8PTwJGwQ75UVD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 phishscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212190142
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-12-16 at 14:59 -0500, Matthew Rosato wrote:
> On 11/21/22 4:40 PM, Eric Farman wrote:
> > The allocation of our page_array struct calculates the number
> > of 4K pages that would be needed to hold a certain number of
> > bytes. But, since the number of pages that will be pinned is
> > also calculated by the length of the IDAL, this logic is
> > unnecessary. Let's pass that information in directly, and
> > avoid the math within the allocator.
> >=20
> > Also, let's make this two allocations instead of one,
> > to make it apparent what's happening within here.
> >=20
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> > =C2=A0drivers/s390/cio/vfio_ccw_cp.c | 23 +++++++++++++----------
> > =C2=A01 file changed, 13 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/drivers/s390/cio/vfio_ccw_cp.c
> > b/drivers/s390/cio/vfio_ccw_cp.c
> > index 4b6b5f9dc92d..66e890441163 100644
> > --- a/drivers/s390/cio/vfio_ccw_cp.c
> > +++ b/drivers/s390/cio/vfio_ccw_cp.c
> > @@ -43,7 +43,7 @@ struct ccwchain {
> > =C2=A0 * page_array_alloc() - alloc memory for page array
> > =C2=A0 * @pa: page_array on which to perform the operation
> > =C2=A0 * @iova: target guest physical address
> > - * @len: number of bytes that should be pinned from @iova
> > + * @len: number of pages that should be pinned from @iova
> > =C2=A0 *
> > =C2=A0 * Attempt to allocate memory for page array.
> > =C2=A0 *
> > @@ -63,18 +63,20 @@ static int page_array_alloc(struct page_array
> > *pa, u64 iova, unsigned int len)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (pa->pa_nr || pa->pa=
_iova)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pa->pa_nr =3D ((iova & ~PAGE=
_MASK) + len + (PAGE_SIZE - 1))
> > >> PAGE_SHIFT;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!pa->pa_nr)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!len)
>=20
> Seems like a weird way to check this.=C2=A0 if (len =3D=3D 0) ?

Yeah... Weird before, weird now. I'll fix this up.

>=20
> Otherwise:
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

Thanks!

Eric
