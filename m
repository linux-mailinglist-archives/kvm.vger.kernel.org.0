Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5437165141E
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 21:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbiLSUlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 15:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiLSUlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 15:41:08 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979C8F5D;
        Mon, 19 Dec 2022 12:41:07 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJKRq9m011933;
        Mon, 19 Dec 2022 20:41:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ccfm/csUN+3asxzUIw4it6+uqGbbDfyAtKXVzncne9g=;
 b=NaDcR6dInZg0AT+n6SQ+gNJB0j+s6ZwaQAvfz55sz6jxYzS4jM/qrAbcwuuvGhnxIXmR
 glBf+WClkGQ7qbfCHbdsMYyVNOiHPLHs6PsoFHL931VMsJyL5JVWhzzIcrAwzwAhbqDy
 g04Pw3AUNeoLEu4qNSW1Ki4bp3Lm+M46hNJ973VAiNuilbLl+LPaXZaMqZLfgHpB8ZRl
 NuHzXD8KXcXj8fMJWOzcBtSJTRa87/WKNwtDz83Z1msxRwVBkuNTpA1xJoXFPfal2C80
 9szDyMTxglmbetleho2cmcDTfSUvxEpfclt+ByzrVP2hxPeg5JoNgXtw3i1WtBPjSKkS 1w== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mjy0ygqwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 20:41:06 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJIDPxq007425;
        Mon, 19 Dec 2022 20:40:45 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3mh6yxfnep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 20:40:45 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJKeiOf56623374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 20:40:44 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3741258059;
        Mon, 19 Dec 2022 20:40:44 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0921B58058;
        Mon, 19 Dec 2022 20:40:43 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Dec 2022 20:40:42 +0000 (GMT)
Message-ID: <a7782feb-6196-44df-fb08-f14286567698@linux.ibm.com>
Date:   Mon, 19 Dec 2022 15:40:42 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 15/16] vfio/ccw: don't group contiguous pages on 2K
 IDAWs
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
 <20221121214056.1187700-16-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221121214056.1187700-16-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S4GeHODhrFwNz-tpbXRzn0VImtWj0r2N
X-Proofpoint-GUID: S4GeHODhrFwNz-tpbXRzn0VImtWj0r2N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 malwarescore=0 phishscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190181
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 4:40 PM, Eric Farman wrote:
> The vfio_pin_pages() interface allows contiguous pages to be
> pinned as a single request, which is great for the 4K pages
> that are normally processed. Old IDA formats operate on 2K
> chunks, which makes this logic more difficult.
> 
> Since these formats are rare, let's just invoke the page
> pinning one-at-a-time, instead of trying to group them.
> We can rework this code at a later date if needed.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 9527f3d8da77..3829c346583c 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -88,7 +88,7 @@ static int page_array_alloc(struct page_array *pa, unsigned int len)
>   * otherwise only clear pa->pa_nr
>   */
>  static void page_array_unpin(struct page_array *pa,
> -			     struct vfio_device *vdev, int pa_nr)
> +			     struct vfio_device *vdev, int pa_nr, bool unaligned)

Please add 'unaligned' the comment block above this function with a short explanation...

>  {
>  	int unpinned = 0, npage = 1;
>  
> @@ -97,7 +97,8 @@ static void page_array_unpin(struct page_array *pa,
>  		dma_addr_t *last = &first[npage];
>  
>  		if (unpinned + npage < pa_nr &&
> -		    *first + npage * PAGE_SIZE == *last) {
> +		    *first + npage * PAGE_SIZE == *last &&
> +		    !unaligned) {
>  			npage++;
>  			continue;
>  		}
> @@ -119,7 +120,7 @@ static void page_array_unpin(struct page_array *pa,
>   * If the pin request partially succeeds, or fails completely,
>   * all pages are left unpinned and a negative error value is returned.
>   */
> -static int page_array_pin(struct page_array *pa, struct vfio_device *vdev)
> +static int page_array_pin(struct page_array *pa, struct vfio_device *vdev, bool unaligned)

...  Also here.  Otherwise, I agree re-work can be done later since this is not a common case.

With those changes:

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

>  {
>  	int pinned = 0, npage = 1;
>  	int ret = 0;
> @@ -129,7 +130,8 @@ static int page_array_pin(struct page_array *pa, struct vfio_device *vdev)
>  		dma_addr_t *last = &first[npage];
>  
>  		if (pinned + npage < pa->pa_nr &&
> -		    *first + npage * PAGE_SIZE == *last) {
> +		    *first + npage * PAGE_SIZE == *last &&
> +		    !unaligned) {
>  			npage++;
>  			continue;
>  		}
> @@ -151,14 +153,14 @@ static int page_array_pin(struct page_array *pa, struct vfio_device *vdev)
>  	return ret;
>  
>  err_out:
> -	page_array_unpin(pa, vdev, pinned);
> +	page_array_unpin(pa, vdev, pinned, unaligned);
>  	return ret;
>  }
>  
>  /* Unpin the pages before releasing the memory. */
> -static void page_array_unpin_free(struct page_array *pa, struct vfio_device *vdev)
> +static void page_array_unpin_free(struct page_array *pa, struct vfio_device *vdev, bool unaligned)
>  {
> -	page_array_unpin(pa, vdev, pa->pa_nr);
> +	page_array_unpin(pa, vdev, pa->pa_nr, unaligned);
>  	kfree(pa->pa_page);
>  	kfree(pa->pa_iova);
>  }
> @@ -638,7 +640,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
>  	}
>  
>  	if (ccw_does_data_transfer(ccw)) {
> -		ret = page_array_pin(pa, vdev);
> +		ret = page_array_pin(pa, vdev, idal_is_2k(cp));
>  		if (ret < 0)
>  			goto out_unpin;
>  	} else {
> @@ -654,7 +656,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
>  	return 0;
>  
>  out_unpin:
> -	page_array_unpin_free(pa, vdev);
> +	page_array_unpin_free(pa, vdev, idal_is_2k(cp));
>  out_free_idaws:
>  	kfree(idaws);
>  out_init:
> @@ -752,7 +754,7 @@ void cp_free(struct channel_program *cp)
>  	cp->initialized = false;
>  	list_for_each_entry_safe(chain, temp, &cp->ccwchain_list, next) {
>  		for (i = 0; i < chain->ch_len; i++) {
> -			page_array_unpin_free(chain->ch_pa + i, vdev);
> +			page_array_unpin_free(chain->ch_pa + i, vdev, idal_is_2k(cp));
>  			ccwchain_cda_free(chain, i);
>  		}
>  		ccwchain_free(chain);

