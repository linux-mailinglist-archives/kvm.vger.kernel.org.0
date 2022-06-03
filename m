Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3D853D2E1
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 22:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242546AbiFCUiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 16:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiFCUix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 16:38:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F50B562C7;
        Fri,  3 Jun 2022 13:38:53 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 253KYJYU017994;
        Fri, 3 Jun 2022 20:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=SSJ0+aztQ1Mynd0YrGQzjAK4VUW5ebVnfqkQw23wd1o=;
 b=GtV16EZ7FDYyHOMVqL5NwkUWGdsORQMj3rJ3di+0Xt/efhiRrhb+Mc72WhRr1KenprlA
 f+sAt1EGfL1bzkAk1CYLzLhaVhPA4tfyrW1Q3oVEQ5zPu+Pe4qEsYnRRYjp/jYGZZdtV
 eDSpHkkf4jsKk7xblgUECELwa44+jKO2V8tv2anHEdGhSSqvAE6i7T55Bf2WxRivJHDW
 Vsb40uLjRqCS6BgnbqpU1OK0YgHo2DTAZtM5LwVDUNFloMzd3takPwrY6x4O33kppEPp
 9obU+Jd9VrJ9mVXY6ZgQ81vGBEsEkY+WzgWgJ9vObiCyl293Ai0ikZAZkjijcp4L3wpH tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfgg8k402-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 20:38:49 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 253KCLaP032740;
        Fri, 3 Jun 2022 20:38:49 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfgg8k3yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 20:38:49 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 253KK1tJ026300;
        Fri, 3 Jun 2022 20:38:48 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03wdc.us.ibm.com with ESMTP id 3gbc9w3r17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 20:38:48 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 253Kcl284063926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 20:38:47 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B8D3AC060;
        Fri,  3 Jun 2022 20:38:47 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F6C3AC05B;
        Fri,  3 Jun 2022 20:38:45 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.94.47])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 20:38:45 +0000 (GMT)
Message-ID: <60c94024db45dde89e46d1a5f5020355c4bf5a85.camel@linux.ibm.com>
Subject: Re: [PATCH v1 07/18] vfio/ccw: Flatten MDEV device (un)register
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Fri, 03 Jun 2022 16:38:44 -0400
In-Reply-To: <22bf0a16-9949-ff8d-955a-4b97cfb37207@linux.ibm.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
         <20220602171948.2790690-8-farman@linux.ibm.com>
         <22bf0a16-9949-ff8d-955a-4b97cfb37207@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ki-OXnNtSoxJ2pUJCkDQbC-odsOnR1h1
X-Proofpoint-GUID: lwoPF7e2iSvzKT8QBUXwGjqtQQNHTz6T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_07,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-06-02 at 15:14 -0400, Matthew Rosato wrote:
> On 6/2/22 1:19 PM, Eric Farman wrote:
> > The vfio_ccw_mdev_(un)reg routines are merely vfio-ccw routines
> > that
> > pass control to mdev_(un)register_device. Since there's only one
> > caller of each, let's just call the mdev routines directly.
> 
> I'd reword slightly to reference the ops extern
> 
> ".. caller of each, externalize vfio_ccw_mdev_ops and call..."

Of course vfio_ccw_mdev_ops was removed in 5.19 via commit 6b42f491e17c
("vfio/mdev: Remove mdev_parent_ops"), so the extern doesn't happen
now.

> 
> regardless,
> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> >   drivers/s390/cio/vfio_ccw_drv.c     |  4 ++--
> >   drivers/s390/cio/vfio_ccw_ops.c     | 12 +-----------
> >   drivers/s390/cio/vfio_ccw_private.h |  4 +---
> >   3 files changed, 4 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/s390/cio/vfio_ccw_drv.c
> > b/drivers/s390/cio/vfio_ccw_drv.c
> > index 9d817aa2f1c4..3784eb4cda85 100644
> > --- a/drivers/s390/cio/vfio_ccw_drv.c
> > +++ b/drivers/s390/cio/vfio_ccw_drv.c
> > @@ -239,7 +239,7 @@ static int vfio_ccw_sch_probe(struct subchannel
> > *sch)
> >   
> >   	private->state = VFIO_CCW_STATE_STANDBY;
> >   
> > -	ret = vfio_ccw_mdev_reg(sch);
> > +	ret = mdev_register_device(&sch->dev, &vfio_ccw_mdev_ops);
> >   	if (ret)
> >   		goto out_disable;
> >   
> > @@ -261,7 +261,7 @@ static void vfio_ccw_sch_remove(struct
> > subchannel *sch)
> >   	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
> >   
> >   	vfio_ccw_sch_quiesce(sch);
> > -	vfio_ccw_mdev_unreg(sch);
> > +	mdev_unregister_device(&sch->dev);
> >   
> >   	dev_set_drvdata(&sch->dev, NULL);
> >   
> > diff --git a/drivers/s390/cio/vfio_ccw_ops.c
> > b/drivers/s390/cio/vfio_ccw_ops.c
> > index 4a64c176facb..497e1b7ffd61 100644
> > --- a/drivers/s390/cio/vfio_ccw_ops.c
> > +++ b/drivers/s390/cio/vfio_ccw_ops.c
> > @@ -656,18 +656,8 @@ struct mdev_driver vfio_ccw_mdev_driver = {
> >   	.remove = vfio_ccw_mdev_remove,
> >   };
> >   
> > -static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
> > +const struct mdev_parent_ops vfio_ccw_mdev_ops = {
> >   	.owner			= THIS_MODULE,
> >   	.device_driver		= &vfio_ccw_mdev_driver,
> >   	.supported_type_groups  = mdev_type_groups,
> >   };
> > -
> > -int vfio_ccw_mdev_reg(struct subchannel *sch)
> > -{
> > -	return mdev_register_device(&sch->dev, &vfio_ccw_mdev_ops);
> > -}
> > -
> > -void vfio_ccw_mdev_unreg(struct subchannel *sch)
> > -{
> > -	mdev_unregister_device(&sch->dev);
> > -}
> > diff --git a/drivers/s390/cio/vfio_ccw_private.h
> > b/drivers/s390/cio/vfio_ccw_private.h
> > index 5c128eec596b..2e0744ac6492 100644
> > --- a/drivers/s390/cio/vfio_ccw_private.h
> > +++ b/drivers/s390/cio/vfio_ccw_private.h
> > @@ -117,12 +117,10 @@ struct vfio_ccw_private {
> >   	struct work_struct	crw_work;
> >   } __aligned(8);
> >   
> > -extern int vfio_ccw_mdev_reg(struct subchannel *sch);
> > -extern void vfio_ccw_mdev_unreg(struct subchannel *sch);
> > -
> >   extern int vfio_ccw_sch_quiesce(struct subchannel *sch);
> >   
> >   extern struct mdev_driver vfio_ccw_mdev_driver;
> > +extern const struct mdev_parent_ops vfio_ccw_mdev_ops;
> >   
> >   /*
> >    * States of the device statemachine.

