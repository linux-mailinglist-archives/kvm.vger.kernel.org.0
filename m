Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7FF64E2F9
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 22:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiLOVTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 16:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiLOVTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 16:19:12 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B28A5D6B9;
        Thu, 15 Dec 2022 13:18:31 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFKi6kl015707;
        Thu, 15 Dec 2022 21:18:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Dzrh8r1mlpBv+DRIrMliH4fePu2+N1NeTVVR7eFuQWc=;
 b=p4+0E7/+a27RBkOfKmlRW6fS3U7wsLBCZ5ftuywDRzDc860KUnkppcY6hz5InMWNwTXB
 Now1EIhPhD1PtqWj1rj2trqnzesECOVlFYek1yFLXdBSSN3HR7qkIlQx4Pk/R7NlQoDG
 CW6C4paXkXzSN7DGFFzWaPmVlLjn1GMpRkF+dlcB1/UOiuGQUqOMEEQZEV1NH8GYnBz8
 XqZKOOlQ0AjogKdjltLwkYl6i7OESk+WrCu0U3RyNgWH6n9DdnuoLOxjEZNOp1cYbxgv
 zdt1bZLDSwV7mJU5PBKsiGdAsk8IoxHTNPBe+erXHsbKuY2omWKOBLOTatlSCl9Ci3Nv qQ== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mgavgrps2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 21:18:30 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFJ5m4H017680;
        Thu, 15 Dec 2022 21:18:29 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3meyqknrpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 21:18:29 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BFLISj68847894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:18:28 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3215F58058;
        Thu, 15 Dec 2022 21:18:28 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96A835805A;
        Thu, 15 Dec 2022 21:18:26 +0000 (GMT)
Received: from [9.160.114.181] (unknown [9.160.114.181])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Dec 2022 21:18:26 +0000 (GMT)
Message-ID: <dd84e145-84ba-04d7-717f-d106d20d5bf7@linux.ibm.com>
Date:   Thu, 15 Dec 2022 16:18:26 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 06/16] vfio/ccw: simplify CCW chain fetch routines
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
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20221121214056.1187700-1-farman@linux.ibm.com>
 <20221121214056.1187700-7-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221121214056.1187700-7-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BOmFFKLTz2JJkYEFHsUu06hMoCHj5NxX
X-Proofpoint-ORIG-GUID: BOmFFKLTz2JJkYEFHsUu06hMoCHj5NxX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212150176
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 4:40 PM, Eric Farman wrote:
> The act of processing a fetched CCW has two components:
> 
>  1) Process a Transfer-in-channel (TIC) CCW
>  2) Process any other CCW
> 
> The former needs to look at whether the TIC jumps backwards into
> the current channel program or forwards into a new one segment,

unnecessary word 'one'?

> while the latter just processes the CCW data address itself.
> 
> Rather than passing the chain segment and index within it to the
> handlers for the above, and requiring each to calculate the
> elements it needs, simply pass the needed pointers directly.
> 
> For the TIC, that means the CCW being processed and the location
> of the entire channel program which holds all segments. For the
> other CCWs, the page_array pointer is also needed to perform the
> page pinning, etc.
> 
> While at it, rename ccwchain_fetch_direct to _ccw, to indicate
> what it is. The name "_direct" is historical, when it used to
> process a direct-addressed CCW, but IDAs are processed here too.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 33 +++++++++++++++------------------
>  1 file changed, 15 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 1eacbb8dc860..d41d94cecdf8 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -482,11 +482,9 @@ static int ccwchain_loop_tic(struct ccwchain *chain, struct channel_program *cp)
>  	return 0;
>  }
>  
> -static int ccwchain_fetch_tic(struct ccwchain *chain,
> -			      int idx,
> +static int ccwchain_fetch_tic(struct ccw1 *ccw,
>  			      struct channel_program *cp)
>  {
> -	struct ccw1 *ccw = chain->ch_ccw + idx;
>  	struct ccwchain *iter;
>  	u32 ccw_head;
>  
> @@ -502,14 +500,12 @@ static int ccwchain_fetch_tic(struct ccwchain *chain,
>  	return -EFAULT;
>  }
>  
> -static int ccwchain_fetch_direct(struct ccwchain *chain,
> -				 int idx,
> -				 struct channel_program *cp)
> +static int ccwchain_fetch_ccw(struct ccw1 *ccw,
> +			      struct page_array *pa,
> +			      struct channel_program *cp)
>  {
>  	struct vfio_device *vdev =
>  		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
> -	struct ccw1 *ccw;
> -	struct page_array *pa;
>  	u64 iova;
>  	unsigned long *idaws;
>  	int ret;
> @@ -517,8 +513,6 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
>  	int idaw_nr, idal_len;
>  	int i;
>  
> -	ccw = chain->ch_ccw + idx;
> -
>  	if (ccw->count)
>  		bytes = ccw->count;
>  
> @@ -548,7 +542,6 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
>  	 * required for the data transfer, since we only only support
>  	 * 4K IDAWs today.
>  	 */
> -	pa = chain->ch_pa + idx;
>  	ret = page_array_alloc(pa, iova, bytes);
>  	if (ret < 0)
>  		goto out_free_idaws;
> @@ -604,16 +597,15 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
>   * and to get rid of the cda 2G limitiaion of ccw1, we'll translate
>   * direct ccws to idal ccws.
>   */
> -static int ccwchain_fetch_one(struct ccwchain *chain,
> -			      int idx,
> +static int ccwchain_fetch_one(struct ccw1 *ccw,
> +			      struct page_array *pa,
>  			      struct channel_program *cp)
> -{
> -	struct ccw1 *ccw = chain->ch_ccw + idx;
>  
> +{
>  	if (ccw_is_tic(ccw))
> -		return ccwchain_fetch_tic(chain, idx, cp);
> +		return ccwchain_fetch_tic(ccw, cp);
>  
> -	return ccwchain_fetch_direct(chain, idx, cp);
> +	return ccwchain_fetch_ccw(ccw, pa, cp);
>  }
>  
>  /**
> @@ -736,6 +728,8 @@ void cp_free(struct channel_program *cp)
>  int cp_prefetch(struct channel_program *cp)
>  {
>  	struct ccwchain *chain;
> +	struct ccw1 *ccw;
> +	struct page_array *pa;
>  	int len, idx, ret;
>  
>  	/* this is an error in the caller */
> @@ -745,7 +739,10 @@ int cp_prefetch(struct channel_program *cp)
>  	list_for_each_entry(chain, &cp->ccwchain_list, next) {
>  		len = chain->ch_len;
>  		for (idx = 0; idx < len; idx++) {
> -			ret = ccwchain_fetch_one(chain, idx, cp);
> +			ccw = chain->ch_ccw + idx;
> +			pa = chain->ch_pa + idx;
> +
> +			ret = ccwchain_fetch_one(ccw, pa, cp);
>  			if (ret)
>  				goto out_err;
>  		}

