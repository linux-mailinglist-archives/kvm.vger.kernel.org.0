Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B2779286D
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbjIEQDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354532AbjIEMWX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 08:22:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466D21A8;
        Tue,  5 Sep 2023 05:22:20 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385CC1T1006030;
        Tue, 5 Sep 2023 12:22:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3UwuvDN+eoewhTwVqzsSpnC1hdkuSFLvc+SkpbZsX9A=;
 b=eakCT4+KJE0QMcdkcs5LbZVZpj0SxSvU/jdZIvMlhpknI6gCbzJivJlXa1/Bm43Pu2Rk
 Ms/MkBb0O1QkDTDFSJK4T4RL//OVIQwi4tbaCDt5deI6NhB+298WzVO7JjvicJ08Gs1J
 Xn+kyTIIqYe+KVlL+1axSJY7QUnUW7Ir5su0iEobCprVjebCDsrr8maAqWu3eXy3SKgJ
 O1FgODDW3MX76kpxUQmgx8aJXWBICT7TbHoEPi8/Z8B9g8OoeQ45NczhuBcS3ebvJh9B
 r6tC7XDmsvzB9IvL53oLz030llbmHZklxF/pFFSkiDGeoPHtjauFR0IGJqFSTbguUIRz zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sx44eg8hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Sep 2023 12:22:19 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 385CDLWT011805;
        Tue, 5 Sep 2023 12:22:19 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sx44eg8hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Sep 2023 12:22:19 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 385BU3QZ001615;
        Tue, 5 Sep 2023 12:22:18 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3svfcsjtdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Sep 2023 12:22:18 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 385CMFPG52298156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Sep 2023 12:22:15 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 831E72004B;
        Tue,  5 Sep 2023 12:22:15 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38F1E20043;
        Tue,  5 Sep 2023 12:22:15 +0000 (GMT)
Received: from [9.171.57.58] (unknown [9.171.57.58])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  5 Sep 2023 12:22:15 +0000 (GMT)
Message-ID: <7e20d088-546a-65c1-1438-c9a9cf0c3810@linux.ibm.com>
Date:   Tue, 5 Sep 2023 14:22:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [kvm-unit-tests PATCH v6 1/8] lib: s390x: introduce bitfield for
 PSW mask
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230904082318.1465055-1-nrb@linux.ibm.com>
 <20230904082318.1465055-2-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230904082318.1465055-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xIhoq4W2Hr6XBLX37b3E7o36nJnZydbt
X-Proofpoint-ORIG-GUID: 9G5yAIsXXXOL0NuPE2qbWrEPNgjcxdmO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_10,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 phishscore=0 mlxscore=0 adultscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxlogscore=758
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309050107
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/4/23 10:22, Nico Boehr wrote:
> Changing the PSW mask is currently little clumsy, since there is only the
> PSW_MASK_* defines. This makes it hard to change e.g. only the address
> space in the current PSW without a lot of bit fiddling.
> 
> Introduce a bitfield for the PSW mask. This makes this kind of
> modifications much simpler and easier to read.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h | 26 +++++++++++++++++++++++++-
>   s390x/selftest.c         | 34 ++++++++++++++++++++++++++++++++++
>   2 files changed, 59 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index bb26e008cc68..5a712f97f129 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -37,12 +37,36 @@ struct stack_frame_int {
>   };
>   
>   struct psw {
> -	uint64_t	mask;
> +	union {
> +		uint64_t	mask;
> +		struct {
> +			uint64_t reserved00:1;
> +			uint64_t per:1;
> +			uint64_t reserved02:3;
> +			uint64_t dat:1;
> +			uint64_t io:1;
> +			uint64_t ext:1;
> +			uint64_t key:4;
> +			uint64_t reserved12:1;
> +			uint64_t mchk:1;
> +			uint64_t wait:1;
> +			uint64_t pstate:1;
> +			uint64_t as:2;
> +			uint64_t cc:2;
> +			uint64_t prg_mask:4;
> +			uint64_t reserved24:7;
> +			uint64_t ea:1;
> +			uint64_t ba:1;
> +			uint64_t reserved33:31;
> +		};
> +	};
>   	uint64_t	addr;
>   };
> +_Static_assert(sizeof(struct psw) == 16, "PSW size");
>   
>   #define PSW(m, a) ((struct psw){ .mask = (m), .addr = (uint64_t)(a) })
>   
> +

We can fix this up when picking.

Other than that:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
