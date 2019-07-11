Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1DF3660A1
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 22:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbfGKUab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 16:30:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9268 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728405AbfGKUab (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jul 2019 16:30:31 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6BKQw4L140270;
        Thu, 11 Jul 2019 16:30:29 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tp90uftte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Jul 2019 16:30:28 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6BKTnkw006727;
        Thu, 11 Jul 2019 20:30:27 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 2tjk97phqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Jul 2019 20:30:27 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6BKURNk7995788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 20:30:27 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DB8EAC05F;
        Thu, 11 Jul 2019 20:30:27 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3EE8AC060;
        Thu, 11 Jul 2019 20:30:26 +0000 (GMT)
Received: from [9.60.89.60] (unknown [9.60.89.60])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 11 Jul 2019 20:30:26 +0000 (GMT)
Subject: Re: [PATCH v3 1/5] vfio-ccw: Fix misleading comment when setting
 orb.cmd.c64
To:     Farhan Ali <alifm@linux.ibm.com>, cohuck@redhat.com,
        pasic@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1562854091.git.alifm@linux.ibm.com>
 <f68636106aef0faeb6ce9712584d102d1b315ff8.1562854091.git.alifm@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <831c9495-78b7-b03c-1942-d16236d1e518@linux.ibm.com>
Date:   Thu, 11 Jul 2019 16:30:26 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <f68636106aef0faeb6ce9712584d102d1b315ff8.1562854091.git.alifm@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
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
> The comment is misleading because it tells us that
> we should set orb.cmd.c64 before calling ccwchain_calc_length,
> otherwise the function ccwchain_calc_length would return an
> error. This is not completely accurate.
> 
> We want to allow an orb without cmd.c64, and this is fine
> as long as the channel program does not use IDALs. But we do
> want to reject any channel program that uses IDALs and does
> not set the flag, which is what we do in ccwchain_calc_length.
> 
> After we have done the ccw processing, we need to set cmd.c64,
> as we use IDALs for all translated channel programs.
> 
> Also for better code readability let's move the setting of
> cmd.c64 within the non error path.
> 

Per Conny in v2:

Fixes: fb9e7880af35 ("vfio: ccw: push down unsupported IDA check")

> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Reviewed-by: Eric Farman <farman@linux.ibm.com>

> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index d6a8dff..c969d48 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -645,14 +645,15 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
>  	if (ret)
>  		cp_free(cp);
>  
> -	/* It is safe to force: if not set but idals used
> -	 * ccwchain_calc_length returns an error.
> -	 */
> -	cp->orb.cmd.c64 = 1;
> -
> -	if (!ret)
> +	if (!ret) {
>  		cp->initialized = true;
>  
> +		/* It is safe to force: if it was not set but idals used
> +		 * ccwchain_calc_length would have returned an error.
> +		 */
> +		cp->orb.cmd.c64 = 1;
> +	}
> +
>  	return ret;
>  }
>  
> 
