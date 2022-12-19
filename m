Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B169651370
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 20:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbiLSTti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 14:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiLSTth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 14:49:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C11FCC1;
        Mon, 19 Dec 2022 11:49:35 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJJg3LU030390;
        Mon, 19 Dec 2022 19:49:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KHrZlxbv3YMMVzr9lWrQPb+dkaVvMqKKTg+6lFevEys=;
 b=SOGLZoUfPzV9NKzTFH4WphNXL7pr+0W4AfllCqXNijy1t/VnzteFDAZf346tGOeyPo+1
 yo3onhyTHxFQk7F3hwW0gHE7mR/Mufs6xT4WLSj52+M1ZfTvBozmOokMWdXsfsydDjGG
 HWwqotaNFrIzBjt5RgSEqrPdJBQ25yLerpzwAFSXvwyK+0IDH2+fNowvQ8axUQr2HGy0
 OeNCx596APKPfJn923xhV6wgw2yCBPHnPvUqwGiC+QQPfWkp4UAruxCVfPI54qsaTTtE
 E+dtgTX1ihNe9z2C2rolha9yLW17CwmLgY9/XvPvatnyUl7sYdwe9My4UKALwr0vYT0b Kg== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mjxbar4s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 19:49:35 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJHhrJV027521;
        Mon, 19 Dec 2022 19:49:34 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3mh6yuk9hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 19:49:34 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJJnWJs55771618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 19:49:32 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9864C5805B;
        Mon, 19 Dec 2022 19:49:32 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 542B658058;
        Mon, 19 Dec 2022 19:49:31 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Dec 2022 19:49:31 +0000 (GMT)
Message-ID: <46446b52-e773-ec71-f74c-3c39bfdd7c12@linux.ibm.com>
Date:   Mon, 19 Dec 2022 14:49:30 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 12/16] vfio/ccw: calculate number of IDAWs regardless
 of format
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
 <20221121214056.1187700-13-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221121214056.1187700-13-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 58GmcUNpghk_JQk4btuq1yq2kkbQEgbd
X-Proofpoint-ORIG-GUID: 58GmcUNpghk_JQk4btuq1yq2kkbQEgbd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=830 clxscore=1015 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190173
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 4:40 PM, Eric Farman wrote:
> The idal_nr_words() routine works well for 4K IDAWs, but lost its
> ability to handle the old 2K formats with the removal of 31-bit
> builds in commit 5a79859ae0f3 ("s390: remove 31 bit support").
> 
> Since there's nothing preventing a guest from generating this IDAW
> format, let's re-introduce the math for them and use both when
> calculating the number of IDAWs based on the bits specified in
> the ORB.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>  arch/s390/include/asm/idals.h  | 12 ++++++++++++
>  drivers/s390/cio/vfio_ccw_cp.c | 17 ++++++++++++++++-
>  2 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/idals.h b/arch/s390/include/asm/idals.h
> index 40eae2c08d61..0a05a893aedb 100644
> --- a/arch/s390/include/asm/idals.h
> +++ b/arch/s390/include/asm/idals.h
> @@ -23,6 +23,9 @@
>  #define IDA_SIZE_LOG 12 /* 11 for 2k , 12 for 4k */
>  #define IDA_BLOCK_SIZE (1L<<IDA_SIZE_LOG)
>  
> +#define IDA_2K_SIZE_LOG 11
> +#define IDA_2K_BLOCK_SIZE (1L << IDA_2K_SIZE_LOG)
> +
>  /*
>   * Test if an address/length pair needs an idal list.
>   */
> @@ -42,6 +45,15 @@ static inline unsigned int idal_nr_words(void *vaddr, unsigned int length)
>  		(IDA_BLOCK_SIZE-1)) >> IDA_SIZE_LOG;
>  }
>  
> +/*
> + * Return the number of 2K IDA words needed for an address/length pair.
> + */
> +static inline unsigned int idal_2k_nr_words(void *vaddr, unsigned int length)
> +{
> +	return ((__pa(vaddr) & (IDA_2K_BLOCK_SIZE-1)) + length +
> +		(IDA_2K_BLOCK_SIZE-1)) >> IDA_2K_SIZE_LOG;
> +}
> +
>  /*
>   * Create the list of idal words for an address/length pair.
>   */
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 53246f4f95f7..6839e7195182 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -502,6 +502,13 @@ static int ccwchain_fetch_tic(struct ccw1 *ccw,
>   *
>   * @ccw: The Channel Command Word being translated
>   * @cp: Channel Program being processed
> + *
> + * The ORB is examined, since it specifies what IDAWs could actually be
> + * used by any CCW in the channel program, regardless of whether or not
> + * the CCW actually does. An ORB that does not specify Format-2-IDAW
> + * Control could still contain a CCW with an IDAL, which would be
> + * Format-1 and thus only move 2K with each IDAW. Thus all CCWs within
> + * the channel program must follow the same size requirements.
>   */
>  static int ccw_count_idaws(struct ccw1 *ccw,
>  			   struct channel_program *cp)
> @@ -529,7 +536,15 @@ static int ccw_count_idaws(struct ccw1 *ccw,
>  		iova = ccw->cda;
>  	}
>  
> -	return idal_nr_words((void *)iova, bytes);
> +	/* Format-1 IDAWs operate on 2K each */
> +	if (!cp->orb.cmd.c64)
> +		return idal_2k_nr_words((void *)iova, bytes);
> +
> +	/* Format-2 IDAWs operate on either 2K or 4K */
> +	if (cp->orb.cmd.i2k)
> +		return idal_2k_nr_words((void *)iova, bytes);
> +	else

Nit: The else is unnecessary, just unconditionally return idal_nr_words if you reach the end of the function.

Either way:
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> +		return idal_nr_words((void *)iova, bytes);
>  }
>  
>  static int ccwchain_fetch_ccw(struct ccw1 *ccw,

