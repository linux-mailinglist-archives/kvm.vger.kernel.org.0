Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB46692C82
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 02:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjBKBYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 20:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKBYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 20:24:12 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9A17D3EF;
        Fri, 10 Feb 2023 17:24:11 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31B1BtB3000909;
        Sat, 11 Feb 2023 01:24:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=iH2GWNAE8oZswqJl+V9hVKOZWRQZ+tzd255JikEa+2E=;
 b=qFkEzCQtxli6nTjMiGAHGtd1glOBkCMb7MJq6IiKKX8n7zD1HTTIwe6T9ruA7tDNk18S
 3gqt+YSp8+Q5j7SImvQpojpMfH1if1FiSIk2UtHQUTEqOTr3gmxrVLtcFSFqzRZ0hJP9
 ZaDBNltk3iJBmDO85223mPQvaU/nS3WZ1SeGP6Ury0qhoqc3jn+HkG2154WYyJyGd/XS
 pWqUN9KeQp6A5jyG3nqVwDdO+EsqI/TzDfviDiolcukXgYQh8yLStxCe3bmmUmzIkF8k
 j48y7lp0QajXU7DVkyjvHnkIo+xVPyTPtitTeW4tJkwWrP7+09xlFhZzpkGly6DX7VRh 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3np15285ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 11 Feb 2023 01:24:11 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31B1ILuL005119;
        Sat, 11 Feb 2023 01:24:10 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3np15285e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 11 Feb 2023 01:24:10 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31B00FNh003976;
        Sat, 11 Feb 2023 01:24:09 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3nhf07skjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 11 Feb 2023 01:24:09 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31B1O7Tx25035328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Feb 2023 01:24:07 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55A3258043;
        Sat, 11 Feb 2023 01:24:07 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4076F5805E;
        Sat, 11 Feb 2023 01:24:06 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.160.76.243])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Sat, 11 Feb 2023 01:24:06 +0000 (GMT)
Message-ID: <67809f492928a8d7e60aad7884a3409746793ea6.camel@linux.ibm.com>
Subject: Re: [PATCH] vfio/ccw: Remove WARN_ON during shutdown
From:   Eric Farman <farman@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 10 Feb 2023 20:24:05 -0500
In-Reply-To: <20230210143004.347b17bc.alex.williamson@redhat.com>
References: <20230210174227.2256424-1-farman@linux.ibm.com>
         <20230210143004.347b17bc.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _ZQoQJR0A8UuvHv2lKD7rqIsznMsR8V9
X-Proofpoint-ORIG-GUID: otqSRyCca8pk7yHVHsiq9Z134zOmqbc-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_17,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302110006
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-02-10 at 14:30 -0700, Alex Williamson wrote:
> On Fri, 10 Feb 2023 18:42:27 +0100
> Eric Farman <farman@linux.ibm.com> wrote:
>=20
> > The logic in vfio_ccw_sch_shutdown() always assumed that the input
> > subchannel would point to a vfio_ccw_private struct, without
> > checking
> > that one exists. The blamed commit put in a check for this
> > scenario,
> > to prevent the possibility of a missing private.
> >=20
> > The trouble is that check was put alongside a WARN_ON(), presuming
> > that such a scenario would be a cause for concern. But this can be
> > triggered by binding a subchannel to vfio-ccw, and rebooting the
> > system before starting the mdev (via "mdevctl start" or similar)
> > or after stopping it. In those cases, shutdown doesn't need to
> > worry because either the private was never allocated, or it was
> > cleaned up by vfio_ccw_mdev_remove().
> >=20
> > Remove the WARN_ON() piece of this check, since there are plausible
> > scenarios where private would be NULL in this path.
> >=20
> > Fixes: 9e6f07cd1eaa ("vfio/ccw: create a parent struct")
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> > =C2=A0drivers/s390/cio/vfio_ccw_drv.c | 2 +-
> > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/s390/cio/vfio_ccw_drv.c
> > b/drivers/s390/cio/vfio_ccw_drv.c
> > index 54aba7cceb33..ff538a086fc7 100644
> > --- a/drivers/s390/cio/vfio_ccw_drv.c
> > +++ b/drivers/s390/cio/vfio_ccw_drv.c
> > @@ -225,7 +225,7 @@ static void vfio_ccw_sch_shutdown(struct
> > subchannel *sch)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct vfio_ccw_parent =
*parent =3D dev_get_drvdata(&sch-
> > >dev);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct vfio_ccw_private=
 *private =3D dev_get_drvdata(&parent-
> > >dev);
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (WARN_ON(!private))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!private)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return;
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vfio_ccw_fsm_event(priv=
ate, VFIO_CCW_EVENT_CLOSE);
>=20
> I see I'm on the To: line here, is this intended to go through the
> vfio
> tree rather than s390?=C2=A0

Either way. I put you as "to" as the blamed commit went via vfio, but I
could ask Heiko or Vasili to take it if that's easier.

Eric
