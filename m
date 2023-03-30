Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3028A6D0D1B
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 19:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbjC3Rs0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 13:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbjC3RsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 13:48:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F9DCDDB;
        Thu, 30 Mar 2023 10:48:11 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UGvRH7019394;
        Thu, 30 Mar 2023 17:48:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=O3nu5QSqaF77wKli6710sNiy2Y35JQlExuqZ0f1uD+Q=;
 b=ojL6RorF2qWFcYPzAQWYMjKBsYakR6SGMaMFRPVfe4+jYhTp9+hKk0yIFNrEfa8HAJ1C
 yewzpb8wiWds4YqlhHZafU4Rr/DYdfMLWaY1rSAcoO2dQ9psEVr4d2tq+4jpK1XV3jA0
 9DjteRx9LwxHv/qw/OOXY9jI6VugGZhsZ2g2xbA31rWnH+/7NiY67OI2MYNOfKK8Gquc
 0I9l3G2KWhIoYJwf63rPn56YRTKTh4ie+f96Co8yi/r/dSAJ0pXDg4e6UeSxai7M3jAL
 roJoCW+tz3YBbF/24MyK0cuID4XyyBiQ+aSIAbxCUrjThyRTwqyU5iuQyTzQopCYSq0k sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnb4qfu16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 17:48:08 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32UHm8XQ024827;
        Thu, 30 Mar 2023 17:48:08 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnb4qfu0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 17:48:08 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32UHVFn4019636;
        Thu, 30 Mar 2023 17:48:07 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3phrk848t7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 17:48:07 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32UHm6bd37617992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 17:48:06 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC3A258045;
        Thu, 30 Mar 2023 17:48:05 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E45958054;
        Thu, 30 Mar 2023 17:48:04 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.160.65.50])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 30 Mar 2023 17:48:04 +0000 (GMT)
Message-ID: <9dea1ac2f7624b74050b125bcab01272ea7bbd4e.camel@linux.ibm.com>
Subject: Re: [PATCH v4] virtio: add VIRTIO_F_NOTIFICATION_DATA feature
 support
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Viktor Prutyanov <viktor@daynix.com>
Cc:     jasowang@redhat.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com
Date:   Thu, 30 Mar 2023 13:48:04 -0400
In-Reply-To: <87mt44hh5f.fsf@redhat.com>
References: <20230322141031.2211141-1-viktor@daynix.com>
         <20230322123121-mutt-send-email-mst@kernel.org> <87mt44hh5f.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SeKp13MPISU9O7gIcb_u4yNu6n-p_0z3
X-Proofpoint-ORIG-GUID: Jf2vnugQu5MVEljoStyH1BbNW2cdg9KH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_10,2023-03-30_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 clxscore=1011 mlxscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303300139
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-03-22 at 17:42 +0100, Cornelia Huck wrote:
> On Wed, Mar 22 2023, "Michael S. Tsirkin" <mst@redhat.com> wrote:
>=20
> > On Wed, Mar 22, 2023 at 05:10:31PM +0300, Viktor Prutyanov wrote:
> > > According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
> > > indicates that the driver passes extra data along with the queue
> > > notifications.
> > >=20
> > > In a split queue case, the extra data is 16-bit available index.
> > > In a
> > > packed queue case, the extra data is 1-bit wrap counter and 15-
> > > bit
> > > available index.
> > >=20
> > > Add support for this feature for MMIO, channel I/O and modern PCI
> > > transports.
> > >=20
> > > Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
> > > ---
> > > =C2=A0v4: remove VP_NOTIFY macro and legacy PCI support, add
> > > =C2=A0=C2=A0=C2=A0 virtio_ccw_kvm_notify_with_data to virtio_ccw
> > > =C2=A0v3: support feature in virtio_ccw, remove VM_NOTIFY, use
> > > avail_idx_shadow,
> > > =C2=A0=C2=A0=C2=A0 remove byte swap, rename to vring_notification_dat=
a
> > > =C2=A0v2: reject the feature in virtio_ccw, replace __le32 with u32
> > >=20
> > > =C2=A0Tested with disabled VIRTIO_F_NOTIFICATION_DATA on qemu-system-
> > > s390x
> > > =C2=A0(virtio-blk-ccw), qemu-system-riscv64 (virtio-blk-device,
> > > =C2=A0virtio-rng-device), qemu-system-x86_64 (virtio-blk-pci, virtio-
> > > net-pci)
> > > =C2=A0to make sure nothing is broken.
> > > =C2=A0Tested with enabled VIRTIO_F_NOTIFICATION_DATA on 64-bit RISC-V
> > > Linux
> > > =C2=A0and my hardware implementation of virtio-rng.
> >=20
> > what did you test? virtio pci? mmio? guessing not ccw...
> >=20
> > Cornelia could you hack up something to quickly test ccw?
>=20
> Hm, I'm not entirely sure how notification data is supposed to be
> used
> in real life -- Viktor, what is your virtio-rng implementation doing;
> can this be hacked into all transports?
>=20
> (Also, if the other ccw folks have something handy, please speak up
> :)
>=20

(Sorry for delay, caught the illness going through our house before I
had a chance to look at this.)

I applied v6 of this patch and hacked to QEMU to enable
VIRTIO_F_NOTIFICATION_DATA for virtio-blk, and have the -ccw code
ignore the additional data that then comes along the way. Not
surprisingly, things behave fine once I accommodate the new payload.

To Cornelia's point of how it should be used in real life... I didn't
go beyond using this info as a "debugging aid" here, based on time
constraints. But at least it looks reasonable.

Eric
