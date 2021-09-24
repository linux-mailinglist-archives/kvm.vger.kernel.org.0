Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BE3416A32
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 04:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243965AbhIXCz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 22:55:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243921AbhIXCzZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 22:55:25 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18O1dWP7018194;
        Thu, 23 Sep 2021 22:53:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=wuouC2eqvPDvQ1Md7kHHpeWYjluxjEmJURkvCvdNlcs=;
 b=rNEIbh80Df3xj+oBlUfUz/ifiBmf2od1re3ZROT1t6M+X+3HgCobqOdlFHHTTS4GgR18
 NeaT56ACus5MT7Owl7H+Zed2qaTebaWE5S+sIJWEJ+FnDdZFrKtWmSRN+WX3tVOgSWZz
 wp2nWrWKM8/9bduQCQVSZFpCrey1DOQ+WPA0/TPFscmBouH+c1piVOlL/5GU4UU4LwCU
 Ys6t3wuMX1TaucjJc/VHU8xgR9uhnikRLGAlS/ADFbYQk0Ql1WwCcQUSdBegBPdODqoI
 k0zKNd5GKwvWGvQ0gSrmn7JyDmTarcaw2aniWqwTe7BiuncLSQiX9fP0ghupY6Nzi6sX Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b93suatwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Sep 2021 22:53:44 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18O2mTFU017258;
        Thu, 23 Sep 2021 22:53:43 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b93suatwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Sep 2021 22:53:43 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18O2lXBH002397;
        Fri, 24 Sep 2021 02:53:42 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 3b93g1u8j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Sep 2021 02:53:42 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18O2reqp39649698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 02:53:41 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE3CC136060;
        Fri, 24 Sep 2021 02:53:40 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D54D513605D;
        Fri, 24 Sep 2021 02:53:38 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.34.14])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 24 Sep 2021 02:53:38 +0000 (GMT)
Message-ID: <144b3f129af82c0e928250342b71f2372cc67ea3.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/9] vfio/ccw: Use functions for alloc/free of the
 vfio_ccw_private
From:   Eric Farman <farman@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>
Date:   Thu, 23 Sep 2021 22:53:37 -0400
In-Reply-To: <1-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
References: <1-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _r2Z3ezORzHmn3cXQji0mW9FA5OFlGWs
X-Proofpoint-GUID: dAyJm55gTKyHAGMoz8sVyegi9l8Z5giQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-23_07,2021-09-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=947 mlxscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2109240011
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-09-09 at 16:38 -0300, Jason Gunthorpe wrote:
> Makes the code easier to understand what is memory lifecycle and what
> is
> other stuff.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c | 137 ++++++++++++++++++----------
> ----
>  1 file changed, 78 insertions(+), 59 deletions(-)

Reviewed-by: Eric Farman <farman@linux.ibm.com>

