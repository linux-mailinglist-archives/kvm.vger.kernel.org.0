Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87FDD522212
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 19:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345743AbiEJRRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 13:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239349AbiEJRRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 13:17:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52AC1F2C0A;
        Tue, 10 May 2022 10:13:21 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AH1vdF020553;
        Tue, 10 May 2022 17:13:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yHbXdpGx3oYPB6yPLWlIq1cBObBxBVu+pIAiZ3VjDMU=;
 b=OhqXDtSrdsSAbu+P/zZTd41j0XGzcno48GMYJDIkcPpY3YxE+ioCVcy1NN2KaTCjl75t
 1ZSH4gk+RanKeJZhkGCLCafaBtUOpY3aVwUCwzhColQ2ke0o+iUi+1YqYRjK7vnsaQLp
 Ch+6QMHRL/3OoGEKNxDhqpvhe9hHGuTVN9pkMpL777PhzIW4lnpDhGo1Y8TVoxPB3BzH
 8lAvcpMs0GiloeLZDjWpfzOeMxXpdWaIResiu373JqT/URz9br2Fn4JVgNxvVVNGaxHA
 9cNG7/DJ0l1GxX3yUJaJklANsiDUdsJx2hpIaN526GsnfJ/NdurTBXop+/0GixxXPoJK UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fyv3gg8uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 17:13:21 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24AH53R2001693;
        Tue, 10 May 2022 17:13:20 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fyv3gg8ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 17:13:20 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24AHD5wV006752;
        Tue, 10 May 2022 17:13:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3fwgd8ud2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 17:13:18 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24AHDES640894924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 17:13:14 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96B58A405F;
        Tue, 10 May 2022 17:13:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09A6DA4054;
        Tue, 10 May 2022 17:13:14 +0000 (GMT)
Received: from [9.145.38.155] (unknown [9.145.38.155])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 May 2022 17:13:13 +0000 (GMT)
Message-ID: <ff77e8df-cf67-6ee2-8a9f-7f79a5d90622@linux.ibm.com>
Date:   Tue, 10 May 2022 19:13:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Fix sclp facility bit numbers
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220505124656.1954092-1-scgl@linux.ibm.com>
 <20220505124656.1954092-2-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220505124656.1954092-2-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R5-S0Z1jS7RRV3GoxB2aWh5qbvwjZUKs
X-Proofpoint-GUID: qKFsjEj8ARNAQuTliqLE-21hkBlTbP7F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_05,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100074
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/22 14:46, Janis Schoetterl-Glausch wrote:
> sclp_feat_check takes care of adjusting the bit numbering such that they
> can be defined as they are in the documentation.
> 
> Fixes: 4dd649c8 ("lib: s390x: sclp: Extend feature probing")
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

The fixing part of this is:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

But please add the (E)SOP bits in the other patches.

> ---
>   lib/s390x/sclp.h | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index fead007a..4ce2209f 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -134,13 +134,15 @@ struct sclp_facilities {
>   };
>   
>   /* bit number within a certain byte */
> -#define SCLP_FEAT_85_BIT_GSLS		7
> -#define SCLP_FEAT_98_BIT_KSS		0
> -#define SCLP_FEAT_116_BIT_64BSCAO	7
> -#define SCLP_FEAT_116_BIT_CMMA		6
> -#define SCLP_FEAT_116_BIT_ESCA		3
> -#define SCLP_FEAT_117_BIT_PFMFI		6
> -#define SCLP_FEAT_117_BIT_IBS		5
> +#define SCLP_FEAT_80_BIT_SOP		2
> +#define SCLP_FEAT_85_BIT_GSLS		0
> +#define SCLP_FEAT_85_BIT_ESOP		6
> +#define SCLP_FEAT_98_BIT_KSS		7
> +#define SCLP_FEAT_116_BIT_64BSCAO	0
> +#define SCLP_FEAT_116_BIT_CMMA		1
> +#define SCLP_FEAT_116_BIT_ESCA		4
> +#define SCLP_FEAT_117_BIT_PFMFI		1
> +#define SCLP_FEAT_117_BIT_IBS		2
>   
>   typedef struct ReadInfo {
>   	SCCBHeader h;

