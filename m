Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FA06239A6
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 03:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbiKJCPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 21:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiKJCPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 21:15:23 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2FC1B791;
        Wed,  9 Nov 2022 18:15:22 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9NFcEk007649;
        Thu, 10 Nov 2022 02:15:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=e2m5+JKe4VF4G0szoN1MCchG+F1CeXesH6mU/V2sgPo=;
 b=MyMT5csXm+z/Efna78setnNVfNKjhi1Do6tQ5/rrQXTzgbsF8oGdraJ0THiXNRDZKn8D
 OI0hPK+kMTKbeDFXo7o2c7+AjHxDAcX7LT0RIDbPjXokXOJ46ybCr8sFNXM+rXpCFzWK
 KCmK111RkhkbvgEekE9EdRXckxKgxqhEUpAuSUyYnuWo1JHqC3JbtpUIm/2IxS4kZcYz
 PUfhsnhpupc0+1VexME9lpPZKodc3sEvPNRQOXV4xbddJYBM/VapAybm8DRPaMajC/x4
 u94bfoOJba6DBii2vAyfFbf3ghzJky5Ri76nAfJEEcmfvNPOmTiatuSZtigPBHIk5E53 Kw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3krnqf381n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 02:15:22 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AA256Dq011629;
        Thu, 10 Nov 2022 02:15:21 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 3kngmtj0nx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 02:15:21 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AA2FIAS22676158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 02:15:18 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6E985805F;
        Thu, 10 Nov 2022 02:15:19 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8BF05805C;
        Thu, 10 Nov 2022 02:15:18 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.65.229.253])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 10 Nov 2022 02:15:18 +0000 (GMT)
Message-ID: <c459f18c3ccd8ea39b9f585537366b4a9d19d626.camel@linux.ibm.com>
Subject: Re: [PATCH 1/2] vfio-ccw: sort out physical vs virtual pointers
 usage
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Date:   Wed, 09 Nov 2022 21:15:18 -0500
In-Reply-To: <c9e7229e-a88d-2185-bb6b-a94e9dac7b7a@linux.ibm.com>
References: <20221109202157.1050545-1-farman@linux.ibm.com>
         <20221109202157.1050545-2-farman@linux.ibm.com>
         <c9e7229e-a88d-2185-bb6b-a94e9dac7b7a@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QJ-Pu_e6vhSe-dEx3s92vn04mwEIRHSv
X-Proofpoint-GUID: QJ-Pu_e6vhSe-dEx3s92vn04mwEIRHSv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211100013
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-11-09 at 17:20 -0500, Matthew Rosato wrote:
> On 11/9/22 3:21 PM, Eric Farman wrote:
> > From: Alexander Gordeev <agordeev@linux.ibm.com>
> >=20
> > The ORB is a construct that is sent to the real hardware,
> > so should contain a physical address in its interrupt
> > parameter field. Let's clarify that.
> >=20
> > Note: this currently doesn't fix a real bug, since virtual
> > addresses are identical to physical ones.
> >=20
> > Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> > [EF: Updated commit message]
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> > =C2=A0drivers/s390/cio/vfio_ccw_fsm.c | 2 +-
> > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/s390/cio/vfio_ccw_fsm.c
> > b/drivers/s390/cio/vfio_ccw_fsm.c
> > index a59c758869f8..0a5e8b4a6743 100644
> > --- a/drivers/s390/cio/vfio_ccw_fsm.c
> > +++ b/drivers/s390/cio/vfio_ccw_fsm.c
> > @@ -29,7 +29,7 @@ static int fsm_io_helper(struct vfio_ccw_private
> > *private)
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_lock_irqsave(sch->=
lock, flags);
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0orb =3D cp_get_orb(&private-=
>cp, (u32)(addr_t)sch, sch->lpm);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0orb =3D cp_get_orb(&private-=
>cp, (u32)virt_to_phys(sch), sch-
> > >lpm);
>=20
> Nit: I think it would make more sense to do the virt_to_phys inside
> cp_get_orb at the time we place the address in the orb (since that's
> what gets sent to hardware), rather than requiring all callers of
> cp_get_orb to pass a physical address.=C2=A0 I realize there is only 1
> caller today.

Eh, maybe so. But that takes me into the 'what are we passing to this
routine and how can we simplify it' rabbit hole, and it stops becoming
a nit pretty quickly. I'd rather keep this patch as the simple change
described here. I have some more involved rework in the broader cp code
in the pipe, and can include your suggestion with that.

>=20
> Nit++: Can we make the patch subjects match?=C2=A0 vfio/ccw or vfio-ccw

Heh, fair. "vfio/ccw" has been the style du jour of late.

>=20
> Either way:
>=20
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

Thanks!

>=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!orb) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0ret =3D -EIO;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0goto out;
>=20

