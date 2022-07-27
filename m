Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9153582F5A
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 19:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242061AbiG0RYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 13:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241959AbiG0RXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 13:23:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88ED27AC04;
        Wed, 27 Jul 2022 09:45:49 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26RGITtG007902;
        Wed, 27 Jul 2022 16:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=5PcERGFTTciFJd0v0+nxjz2F0QqyHBO5FhRMqSoh0v8=;
 b=I9jV7GbEzPJZ0IA5CUGCXltUND7KnPsyQnOuVnZj6jvDPtg1Qv9TEicXL4B2g4P33zVE
 F78QEMCZJrVAyNixGsJjjddDVIDuI/+1uLhhma7OhVJqrehkV5R/cpFBsxp9J4cxauct
 bkRbWW6iDJK+7r0da0vV00w0rLyGTufwjfXHEuetAyJCdeOVCMkJJkmvU8FVByU1mJ8v
 NbXfbZib8aGV8ndnaRDa8MMU4qJFqzYKcYzbViLg6k0ofQ6y2CvmvauTnTv0DZzaHtfu
 PPTfTtb8dxP9VGuNWt2a9drfe42J5pO2NOKfoaUKvekaRUKlpdGryDXINUDPnreXpeMk yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hk8rtrxgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 16:45:42 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26RGJ2Ov010725;
        Wed, 27 Jul 2022 16:45:41 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hk8rtrxf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 16:45:41 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26RGZAEE021857;
        Wed, 27 Jul 2022 16:45:39 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 3hg98s8s4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 16:45:39 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26RGjcDF63439246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 16:45:38 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B586DB205F;
        Wed, 27 Jul 2022 16:45:38 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DF18B206A;
        Wed, 27 Jul 2022 16:45:37 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.142.12])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 27 Jul 2022 16:45:36 +0000 (GMT)
Message-ID: <82a08af9dd2d83537d20e26416bf99148fdd94f9.camel@linux.ibm.com>
Subject: Re: [PATCH 1/2] vfio/ccw: Add length to DMA_UNMAP checks
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Wed, 27 Jul 2022 12:45:36 -0400
In-Reply-To: <74db2158-a334-abb7-d93e-158b97305a57@linux.ibm.com>
References: <20220726150123.2567761-1-farman@linux.ibm.com>
         <20220726150123.2567761-2-farman@linux.ibm.com>
         <74db2158-a334-abb7-d93e-158b97305a57@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zp1jFKw_2W8gCYDKe3aokXws9E_7uR3i
X-Proofpoint-ORIG-GUID: MzQ-WIpq8GZemCPhWjPSataonhVJFLmw
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_06,2022-07-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207270069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-26 at 12:12 -0400, Matthew Rosato wrote:
> On 7/26/22 11:01 AM, Eric Farman wrote:
> > As pointed out with the simplification of the
> > VFIO_IOMMU_NOTIFY_DMA_UNMAP notifier [1], the length
> > parameter was never used to check against the pinned
> > pages.
> > 
> > Let's correct that, and see if a page is within the
> > affected range instead of simply the first page of
> > the range.
> > 
> > [1] 
> > https://lore.kernel.org/kvm/20220720170457.39cda0d0.alex.williamson@redhat.com/
> > 
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> >   drivers/s390/cio/vfio_ccw_cp.c  | 11 +++++++----
> >   drivers/s390/cio/vfio_ccw_cp.h  |  2 +-
> >   drivers/s390/cio/vfio_ccw_ops.c |  2 +-
> >   3 files changed, 9 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/s390/cio/vfio_ccw_cp.c
> > b/drivers/s390/cio/vfio_ccw_cp.c
> > index 8963f452f963..f15b5114abd1 100644
> > --- a/drivers/s390/cio/vfio_ccw_cp.c
> > +++ b/drivers/s390/cio/vfio_ccw_cp.c
> > @@ -170,12 +170,14 @@ static void page_array_unpin_free(struct
> > page_array *pa, struct vfio_device *vde
> >   	kfree(pa->pa_iova);
> >   }
> >   
> > -static bool page_array_iova_pinned(struct page_array *pa, unsigned
> > long iova)
> > +static bool page_array_iova_pinned(struct page_array *pa, unsigned
> > long iova,
> > +				   unsigned long length)
> >   {
> >   	int i;
> >   
> >   	for (i = 0; i < pa->pa_nr; i++)
> > -		if (pa->pa_iova[i] == iova)
> > +		if (pa->pa_iova[i] >= iova &&
> > +		    pa->pa_iova[i] <= iova + length)
> 
> For the sake of completeness, I think you want to be checking to
> make 
> sure the end of the page is also within the range, not just the
> start?
> 
> if (pa->pa_iova[i] >= iova &&
>      pa->pa_iova[i] + PAGE_SIZE <= iova + length)

Well +PAGE_SIZE would iterate to the next page, so that would be
captured on the next iteration of the for(i) loop if the pages were
contiguous (or not applicable, if the pages weren't).

But, since the comment is really about the end of the page (0xfff), I
guess I'm not understanding what that gets us so perhaps you could help
elaborate your question? From my chair, since the pa_iova argument
passed to vfio_pin_pages() pins the whole page, checking the start
address versus the end (or anywhere in between) should still capture
its interaction with an affected range. That is to say, we don't care
about the -whole- page being within the unmap range, but -any- part of
it.



