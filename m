Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB92660A3
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 22:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbfGKUaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 16:30:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728959AbfGKUaj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jul 2019 16:30:39 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6BKQsDP059981
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 16:30:38 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tpat8bk1u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 16:30:38 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Thu, 11 Jul 2019 21:30:37 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 11 Jul 2019 21:30:35 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6BKUYXQ47448374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 20:30:34 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39600AC06A;
        Thu, 11 Jul 2019 20:30:34 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12F5DAC060;
        Thu, 11 Jul 2019 20:30:34 +0000 (GMT)
Received: from [9.60.89.60] (unknown [9.60.89.60])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 11 Jul 2019 20:30:34 +0000 (GMT)
Subject: Re: [PATCH v3 2/5] vfio-ccw: Fix memory leak and don't call cp_free
 in cp_init
To:     Farhan Ali <alifm@linux.ibm.com>, cohuck@redhat.com,
        pasic@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1562854091.git.alifm@linux.ibm.com>
 <3173c4216f4555d9765eb6e4922534982bc820e4.1562854091.git.alifm@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Thu, 11 Jul 2019 16:30:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <3173c4216f4555d9765eb6e4922534982bc820e4.1562854091.git.alifm@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19071120-2213-0000-0000-000003AD12D6
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011410; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01230780; UDB=6.00648305; IPR=6.01012056;
 MB=3.00027682; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-11 20:30:37
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071120-2214-0000-0000-00005F31DBC5
Message-Id: <acb17242-2743-3a6e-f9e3-d1b86b4f39c7@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110226
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/11/19 10:28 AM, Farhan Ali wrote:
> We don't set cp->initialized to true so calling cp_free
> will just return and not do anything.
> 
> Also fix a memory leak where we fail to free a ccwchain
> on an error.
> 
> Fixes: 812271b910 ("s390/cio: Squash cp_free() and cp_unpin_free()")
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>

Reviewed-by: Eric Farman <farman@linux.ibm.com>

> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index c969d48..f862d5d 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -421,7 +421,7 @@ static int ccwchain_loop_tic(struct ccwchain *chain,
>  static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
>  {
>  	struct ccwchain *chain;
> -	int len;
> +	int len, ret;
>  
>  	/* Copy 2K (the most we support today) of possible CCWs */
>  	len = copy_from_iova(cp->mdev, cp->guest_cp, cda,
> @@ -448,7 +448,12 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
>  	memcpy(chain->ch_ccw, cp->guest_cp, len * sizeof(struct ccw1));
>  
>  	/* Loop for tics on this new chain. */
> -	return ccwchain_loop_tic(chain, cp);
> +	ret = ccwchain_loop_tic(chain, cp);
> +
> +	if (ret)
> +		ccwchain_free(chain);
> +
> +	return ret;
>  }
>  
>  /* Loop for TICs. */
> @@ -642,8 +647,6 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
>  
>  	/* Build a ccwchain for the first CCW segment */
>  	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
> -	if (ret)
> -		cp_free(cp);
>  
>  	if (!ret) {
>  		cp->initialized = true;
> 

