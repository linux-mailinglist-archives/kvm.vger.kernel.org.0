Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F4E5EB6D6
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 03:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiI0BbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 21:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiI0BbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 21:31:06 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382A1A4B08;
        Mon, 26 Sep 2022 18:31:05 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28R1Nn2Z017127;
        Tue, 27 Sep 2022 01:30:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : in-reply-to : references : content-type :
 content-transfer-encoding : date : mime-version; s=pp1;
 bh=OLbEPMMwREeRUfG8ToLRA3YBWODNlYMoVb9RSvb3Gq0=;
 b=jbPQHunhZPFLdFT4ADpENMnSUic25jPZpzH03S8zG3N4iZoLLNM0zcWNaLzzoaFzUSEq
 baMs+/Yfne6+MYgJXrVSFBsv0S1CvCnjzh/nS/oBT6YuhwEIxI4gYCdAkuij7mesPGvx
 nFdWoPgENHWzdOEMJ+/wcBMWgyQ8AZFgkcKO8rOsVHRW9ICULA9pbqV9xN/DPN6Z7yz6
 qhlPm+fvjGaomLl79LMFDzadfxzvi/Fu7RVhEJaI6BwnfPX+9ebBalDehLw1kib59G+e
 W2JcYbRggvtbJ1o0spnH53QEgDinm1Q38nZtVX5+DAO53aqO3OUPQjvh5LH6EX9Ki994 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3juqfrg593-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 01:30:57 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28R1REfX027763;
        Tue, 27 Sep 2022 01:30:56 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3juqfrg58g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 01:30:56 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28R1Kisf012174;
        Tue, 27 Sep 2022 01:30:55 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 3jssha5xex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 01:30:55 +0000
Received: from smtpav04.wdc07v.mail.ibm.com ([9.208.128.116])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28R1UrZ928770720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Sep 2022 01:30:54 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B3E158050;
        Tue, 27 Sep 2022 01:30:53 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75B065806B;
        Tue, 27 Sep 2022 01:30:51 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.160.170.198])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 27 Sep 2022 01:30:51 +0000 (GMT)
Message-ID: <3a30787e9fb444e9b773d98300a056213cb5caed.camel@linux.ibm.com>
Subject: Re: [PATCH 09/14] vfio/mdev: remove mtype_get_parent_dev
From:   Eric Farman <farman@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
In-Reply-To: <20220923092652.100656-10-hch@lst.de>
References: <20220923092652.100656-1-hch@lst.de>
         <20220923092652.100656-10-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 26 Sep 2022 21:28:24 -0400
MIME-Version: 1.0
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WUFMbdsLbauPT1Ne85Vw3to9mIuRPOWt
X-Proofpoint-ORIG-GUID: XnKaxFMg9BMifJT4cLJ5kFsBT7GAKDGR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_11,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 clxscore=1015 mlxlogscore=999 impostorscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209270005
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-09-23 at 11:26 +0200, Christoph Hellwig wrote:
> Just open code the dereferences in the only user.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>

Reviewed-by: Eric Farman <farman@linux.ibm.com>

> ---
> =C2=A0drivers/s390/cio/vfio_ccw_ops.c |=C2=A0 3 +--
> =C2=A0drivers/vfio/mdev/mdev_core.c=C2=A0=C2=A0 | 10 ----------
> =C2=A0include/linux/mdev.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 --
> =C2=A03 files changed, 1 insertion(+), 14 deletions(-)
>=20
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c
> b/drivers/s390/cio/vfio_ccw_ops.c
> index c37e712a4b069..3db6251b31143 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -62,8 +62,7 @@ static ssize_t available_instances_show(struct
> mdev_type *mtype,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0struct mdev_type_attribute
> *attr,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0char *buf)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct vfio_ccw_private *priva=
te =3D
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0dev_get_drvdata(mtype_get_parent_dev(mtype));
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct vfio_ccw_private *priva=
te =3D dev_get_drvdata(mtype-
> >parent->dev);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return sprintf(buf, "%d\n=
", atomic_read(&private->avail));
> =C2=A0}
> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index 75628759a3bf0..93f8caf2e5f77 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -23,16 +23,6 @@ static struct class_compat *mdev_bus_compat_class;
> =C2=A0static LIST_HEAD(mdev_list);
> =C2=A0static DEFINE_MUTEX(mdev_list_lock);
> =C2=A0
> -/*
> - * Used in mdev_type_attribute sysfs functions to return the parent
> struct
> - * device
> - */
> -struct device *mtype_get_parent_dev(struct mdev_type *mtype)
> -{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return mtype->parent->dev;
> -}
> -EXPORT_SYMBOL(mtype_get_parent_dev);
> -
> =C2=A0/* Caller must hold parent unreg_sem read or write lock */
> =C2=A0static void mdev_device_remove_common(struct mdev_device *mdev)
> =C2=A0{
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index bbedffcb38d48..e445f809ceca3 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -51,8 +51,6 @@ static inline struct mdev_device
> *to_mdev_device(struct device *dev)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return container_of(dev, =
struct mdev_device, dev);
> =C2=A0}
> =C2=A0
> -struct device *mtype_get_parent_dev(struct mdev_type *mtype);
> -
> =C2=A0/* interface for exporting mdev supported type attributes */
> =C2=A0struct mdev_type_attribute {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct attribute attr;

