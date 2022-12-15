Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB4164E2AF
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 21:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiLOU74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 15:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiLOU7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 15:59:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D050528AF;
        Thu, 15 Dec 2022 12:59:54 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFK3nSo019944;
        Thu, 15 Dec 2022 20:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=+7k7ofH4dUWOmwWaQSlPMgSIk8y4RpetW35vTzz0P1s=;
 b=UTneS7FHFmGwG8Mmpl0K1SovRKiSm7ITrEOweYYOLB7Mf0LPEKX8JBr5vOS+iQDlfGiv
 HFZqe2uoFpV1IaccHKjRcvijTjN0O4f4GsVXY7Eb8geEq0S1/Q86GLtOn3kV4WwaVw5Y
 wKGWBVqj8mYvARwHTG94Unag9bFd2oBl6LBa/90KXUJObcpDHlDz0cmNvOFCz5rOmPdb
 w9ZV+N6Ki9FF30XzhHNBPO06Bg8nZPKFEsA8n0mzXdmaZa2cXXVkDaoDEtG5O8FXwrGd
 uXliPe3w+e2LQCe20H2o7ZOYy+pAX8ftfrTz2xU0PsXJox3vHeTIvwWddMWvOJZ4IAcx sQ== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mga9r95t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 20:59:51 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFKKarR019277;
        Thu, 15 Dec 2022 20:59:51 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3mf03agugk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 20:59:51 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BFKxnYW2818648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 20:59:49 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E67D5805A;
        Thu, 15 Dec 2022 20:59:49 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B712A58058;
        Thu, 15 Dec 2022 20:59:47 +0000 (GMT)
Received: from [9.160.114.181] (unknown [9.160.114.181])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Dec 2022 20:59:47 +0000 (GMT)
Message-ID: <8160f854-a60c-499f-1997-6fc2c10de798@linux.ibm.com>
Date:   Thu, 15 Dec 2022 15:59:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 05/16] vfio/ccw: replace copy_from_iova with
 vfio_dma_rw
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
 <20221121214056.1187700-6-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221121214056.1187700-6-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -lnkitxmWJBqVngcJcu-soCF5_N0bV-E
X-Proofpoint-ORIG-GUID: -lnkitxmWJBqVngcJcu-soCF5_N0bV-E
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150172
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 4:40 PM, Eric Farman wrote:
> It was suggested [1] that we replace the old copy_from_iova() routine
> (which pins a page, does a memcpy, and unpins the page) with the
> newer vfio_dma_rw() interface.
> 
> This has a modest improvement in the overall time spent through the
> fsm_io_request() path, and simplifies some of the code to boot.
> 
> [1] https://lore.kernel.org/r/20220706170553.GK693670@nvidia.com/
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Nice cleanup.

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 56 +++-------------------------------
>  1 file changed, 5 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 3a11132b1685..1eacbb8dc860 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -228,51 +228,6 @@ static void convert_ccw0_to_ccw1(struct ccw1 *source, unsigned long len)
>  	}
>  }
>  
> -/*
> - * Within the domain (@vdev), copy @n bytes from a guest physical
> - * address (@iova) to a host physical address (@to).
> - */
> -static long copy_from_iova(struct vfio_device *vdev, void *to, u64 iova,
> -			   unsigned long n)
> -{
> -	struct page_array pa = {0};
> -	int i, ret;
> -	unsigned long l, m;
> -
> -	ret = page_array_alloc(&pa, iova, n);
> -	if (ret < 0)
> -		return ret;
> -
> -	ret = page_array_pin(&pa, vdev);
> -	if (ret < 0) {
> -		page_array_unpin_free(&pa, vdev);
> -		return ret;
> -	}
> -
> -	l = n;
> -	for (i = 0; i < pa.pa_nr; i++) {
> -		void *from = kmap_local_page(pa.pa_page[i]);
> -
> -		m = PAGE_SIZE;
> -		if (i == 0) {
> -			from += iova & (PAGE_SIZE - 1);
> -			m -= iova & (PAGE_SIZE - 1);
> -		}
> -
> -		m = min(l, m);
> -		memcpy(to + (n - l), from, m);
> -		kunmap_local(from);
> -
> -		l -= m;
> -		if (l == 0)
> -			break;
> -	}
> -
> -	page_array_unpin_free(&pa, vdev);
> -
> -	return l;
> -}
> -
>  /*
>   * Helpers to operate ccwchain.
>   */
> @@ -471,10 +426,9 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
>  	int len, ret;
>  
>  	/* Copy 2K (the most we support today) of possible CCWs */
> -	len = copy_from_iova(vdev, cp->guest_cp, cda,
> -			     CCWCHAIN_LEN_MAX * sizeof(struct ccw1));
> -	if (len)
> -		return len;
> +	ret = vfio_dma_rw(vdev, cda, cp->guest_cp, CCWCHAIN_LEN_MAX * sizeof(struct ccw1), false);
> +	if (ret)
> +		return ret;
>  
>  	/* Convert any Format-0 CCWs to Format-1 */
>  	if (!cp->orb.cmd.fmt)
> @@ -572,7 +526,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
>  	if (ccw_is_idal(ccw)) {
>  		/* Read first IDAW to see if it's 4K-aligned or not. */
>  		/* All subsequent IDAws will be 4K-aligned. */
> -		ret = copy_from_iova(vdev, &iova, ccw->cda, sizeof(iova));
> +		ret = vfio_dma_rw(vdev, ccw->cda, &iova, sizeof(iova), false);
>  		if (ret)
>  			return ret;
>  	} else {
> @@ -601,7 +555,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
>  
>  	if (ccw_is_idal(ccw)) {
>  		/* Copy guest IDAL into host IDAL */
> -		ret = copy_from_iova(vdev, idaws, ccw->cda, idal_len);
> +		ret = vfio_dma_rw(vdev, ccw->cda, idaws, idal_len, false);
>  		if (ret)
>  			goto out_unpin;
>  

