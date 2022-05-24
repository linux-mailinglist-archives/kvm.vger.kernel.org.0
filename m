Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45495532C5E
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 16:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238247AbiEXOks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 10:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235060AbiEXOkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 10:40:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C8C8FF90;
        Tue, 24 May 2022 07:40:45 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ODoKVq019690;
        Tue, 24 May 2022 14:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=AWmwG0/S/BRP/SUjFpFjATNaYnxz1l+/KwNEieF0G8Q=;
 b=ilAn4qimMmuSnCDyO0VOjQ+t2kRPYIalqmM0/4suHdLjxmUbIGtJyr1aOxtSYNF3tY4c
 1RpiiIlOwUo/fvGTva4xhshudsTNjxEEQqDvtmKuA4WAGB18PNgMlSVNkaIm+rZYO1Ys
 rbY3V7fIWXpSfzRvxk1dQ3DLziumIesK7OTy54o6rNmfBmlD1+0m6kZp2P2jwCgbf9b9
 3UKf0YLOeuKaHOovLDzANUaQm5aTtOMToNXxLRcbDMg/OUSzjUf84fU65JHpCp1d77mf
 Xx5hBHth2IX3wANA4XUdy4gvVzZM8oIFAqNC0obbcWP+l1L2o2d1Xm+vvOI2UuaREY8k ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g903bt6dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 14:40:44 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24ODpfSQ027689;
        Tue, 24 May 2022 14:40:44 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g903bt6cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 14:40:43 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OEYxcE011190;
        Tue, 24 May 2022 14:40:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3g6qq9cn19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 14:40:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OEecF822217064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 14:40:38 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E51011C054;
        Tue, 24 May 2022 14:40:38 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22E1311C04C;
        Tue, 24 May 2022 14:40:38 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.98])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 14:40:38 +0000 (GMT)
Date:   Tue, 24 May 2022 14:49:11 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: lib: SOP facility query
 function
Message-ID: <20220524144911.39c99888@p-imbrenda>
In-Reply-To: <20220520190850.3445768-3-scgl@linux.ibm.com>
References: <20220520190850.3445768-1-scgl@linux.ibm.com>
        <20220520190850.3445768-3-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LvNXF6sRq0GrejiuPLpXLC0oRdcPzGXQ
X-Proofpoint-GUID: 6nAFYwjAnKVmx-hNN6zIJCZxU3wlkjox
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_07,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 clxscore=1015 mlxscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205240074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 May 2022 21:08:49 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Add function returning which suppression-on-protection facility is
> installed.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/facility.h | 21 +++++++++++++++++++++
>  lib/s390x/sclp.h         |  4 ++++
>  lib/s390x/sclp.c         |  2 ++
>  3 files changed, 27 insertions(+)
> 
> diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
> index 49380203..a66fe56a 100644
> --- a/lib/s390x/asm/facility.h
> +++ b/lib/s390x/asm/facility.h
> @@ -12,6 +12,7 @@
>  #include <asm/facility.h>
>  #include <asm/arch_def.h>
>  #include <bitops.h>
> +#include <sclp.h>
>  
>  #define NB_STFL_DOUBLEWORDS 32
>  extern uint64_t stfl_doublewords[];
> @@ -42,4 +43,24 @@ static inline void setup_facilities(void)
>  		stfle(stfl_doublewords, NB_STFL_DOUBLEWORDS);
>  }
>  
> +enum supp_on_prot_facility {
> +	SOP_NONE,
> +	SOP_BASIC,
> +	SOP_ENHANCED_1,
> +	SOP_ENHANCED_2,
> +};
> +
> +static inline enum supp_on_prot_facility get_supp_on_prot_facility(void)
> +{
> +	if (sclp_facilities.has_esop) {
> +		if (test_facility(131)) /* side-effect-access facility */
> +			return SOP_ENHANCED_2;
> +		else
> +			return SOP_ENHANCED_1;
> +	}
> +	if (sclp_facilities.has_sop)
> +		return SOP_BASIC;
> +	return SOP_NONE;
> +}
> +
>  #endif
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 3488f4d2..853529bf 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -123,7 +123,9 @@ struct sclp_facilities {
>  	uint64_t has_cei : 1;
>  
>  	uint64_t has_diag318 : 1;
> +	uint64_t has_sop : 1;
>  	uint64_t has_gsls : 1;
> +	uint64_t has_esop : 1;
>  	uint64_t has_cmma : 1;
>  	uint64_t has_64bscao : 1;
>  	uint64_t has_esca : 1;
> @@ -134,7 +136,9 @@ struct sclp_facilities {
>  };
>  
>  /* bit number within a certain byte */
> +#define SCLP_FEAT_80_BIT_SOP		2
>  #define SCLP_FEAT_85_BIT_GSLS		0
> +#define SCLP_FEAT_85_BIT_ESOP		6
>  #define SCLP_FEAT_98_BIT_KSS		7
>  #define SCLP_FEAT_116_BIT_64BSCAO	0
>  #define SCLP_FEAT_116_BIT_CMMA		1
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index b8204c5f..e6017f64 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -152,7 +152,9 @@ void sclp_facilities_setup(void)
>  	cpu = sclp_get_cpu_entries();
>  	if (read_info->offset_cpu > 134)
>  		sclp_facilities.has_diag318 = read_info->byte_134_diag318;
> +	sclp_facilities.has_sop = sclp_feat_check(80, SCLP_FEAT_80_BIT_SOP);
>  	sclp_facilities.has_gsls = sclp_feat_check(85, SCLP_FEAT_85_BIT_GSLS);
> +	sclp_facilities.has_esop = sclp_feat_check(85, SCLP_FEAT_85_BIT_ESOP);
>  	sclp_facilities.has_kss = sclp_feat_check(98, SCLP_FEAT_98_BIT_KSS);
>  	sclp_facilities.has_cmma = sclp_feat_check(116, SCLP_FEAT_116_BIT_CMMA);
>  	sclp_facilities.has_64bscao = sclp_feat_check(116, SCLP_FEAT_116_BIT_64BSCAO);

