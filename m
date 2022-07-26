Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26FE58170B
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 18:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbiGZQMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 12:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiGZQMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 12:12:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F99EB1E7;
        Tue, 26 Jul 2022 09:12:52 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QFvvgI026174;
        Tue, 26 Jul 2022 16:12:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=4N0Fxz/Zn4HZ7Hp8S9rAmNSnp1iFJ8eyPLjUsTDZuGA=;
 b=NEms+G/kf9Ej3LjzNPIm9C7WAIRc8d8QBTpe9S2IcDV4fiCtJDPhMN8GndBL5xNvpsx7
 shMvseMrH2mLcemlhEeOsoFeBWX1BQ0qa7BkA/AqSOiirw7WN+wJNRDSY5N/dTmmD0CH
 nF+VPd8jVVg3lMdbhe3iRsHgQPS3AgnqEM0XPBCKK/Y3vLDmHhLaLPHMPih2Y0mtK/in
 RnIbx0busg/ajzCiaB1TOkXDOD+AGDdrcz2vgiwuVT2zQXHVhX/I0BxAumuNTwrokvIn
 pOubXHICKvykuC9FNXVJDW5tm1zVP0Rc2EnuZTvBFo75S6u8f7fC83XgZxLkNNJLgev4 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjkcf0n0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 16:12:50 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26QG0SDm009694;
        Tue, 26 Jul 2022 16:12:50 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjkcf0mya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 16:12:50 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26QG5ib7009079;
        Tue, 26 Jul 2022 16:12:49 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 3hg978gjtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 16:12:48 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26QGClKt32047400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 16:12:47 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A268B7805E;
        Tue, 26 Jul 2022 16:12:47 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC6537805C;
        Tue, 26 Jul 2022 16:12:46 +0000 (GMT)
Received: from [9.211.41.39] (unknown [9.211.41.39])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 26 Jul 2022 16:12:46 +0000 (GMT)
Message-ID: <74db2158-a334-abb7-d93e-158b97305a57@linux.ibm.com>
Date:   Tue, 26 Jul 2022 12:12:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/2] vfio/ccw: Add length to DMA_UNMAP checks
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220726150123.2567761-1-farman@linux.ibm.com>
 <20220726150123.2567761-2-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220726150123.2567761-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lAZl1JBaYZ5JHpmYIFznYJwJ1gQnTDlL
X-Proofpoint-GUID: EjUNwnh1u0VvTf8pxh37-VUzFpguxyNd
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_04,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207260062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/26/22 11:01 AM, Eric Farman wrote:
> As pointed out with the simplification of the
> VFIO_IOMMU_NOTIFY_DMA_UNMAP notifier [1], the length
> parameter was never used to check against the pinned
> pages.
> 
> Let's correct that, and see if a page is within the
> affected range instead of simply the first page of
> the range.
> 
> [1] https://lore.kernel.org/kvm/20220720170457.39cda0d0.alex.williamson@redhat.com/
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   drivers/s390/cio/vfio_ccw_cp.c  | 11 +++++++----
>   drivers/s390/cio/vfio_ccw_cp.h  |  2 +-
>   drivers/s390/cio/vfio_ccw_ops.c |  2 +-
>   3 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 8963f452f963..f15b5114abd1 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -170,12 +170,14 @@ static void page_array_unpin_free(struct page_array *pa, struct vfio_device *vde
>   	kfree(pa->pa_iova);
>   }
>   
> -static bool page_array_iova_pinned(struct page_array *pa, unsigned long iova)
> +static bool page_array_iova_pinned(struct page_array *pa, unsigned long iova,
> +				   unsigned long length)
>   {
>   	int i;
>   
>   	for (i = 0; i < pa->pa_nr; i++)
> -		if (pa->pa_iova[i] == iova)
> +		if (pa->pa_iova[i] >= iova &&
> +		    pa->pa_iova[i] <= iova + length)

For the sake of completeness, I think you want to be checking to make 
sure the end of the page is also within the range, not just the start?

if (pa->pa_iova[i] >= iova &&
     pa->pa_iova[i] + PAGE_SIZE <= iova + length)
