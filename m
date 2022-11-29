Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A6163C252
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 15:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbiK2OUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 09:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbiK2OUU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 09:20:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5956230546
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 06:17:59 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATEAxkN031801
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 14:17:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=t2ikfCJATtt2JOvQuDP7UY2Eqb9e9n3wJZeD0L3b7SU=;
 b=crpPdU54lfvCqsay8ZIPaNp4hGfk/x89tXVdee3lgwXcdxoPLeTqI5GqIZlPa7D7zXPz
 XQhxKkKMCcvraoGcVH5Zl+eCcppbSX6I60Hcl1I9ywfkBUW9tlfDiGHuRxDfeKwMK3OL
 JGS0BDdjifu5IePUMRd9ZTYqvsA57zHmIYRNRy+p5jNPaQYoYe74dp+QRSfKpDbhXRZv
 f61ybeVR3ienjV8JilURaqOb6i2d6+GXd0Z1SUnsFgi8FC/NqvWemtOePII1+/+SXxu2
 /AF1lwAQLhBaKOse/lamI+3tAi9YnDyA/AvHUXQxvlBJhnvFkGSqtA6lWHy0mvpDxOmr Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5djwt5ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 14:17:58 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ATEBdFU004714
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 14:17:58 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5djwt59k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 14:17:58 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ATE6Bpd021428;
        Tue, 29 Nov 2022 14:17:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3m3ae9c5h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 14:17:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ATEIZLh328396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 14:18:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 480CA4C044;
        Tue, 29 Nov 2022 14:17:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFFC54C040;
        Tue, 29 Nov 2022 14:17:51 +0000 (GMT)
Received: from [9.171.0.95] (unknown [9.171.0.95])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Nov 2022 14:17:51 +0000 (GMT)
Message-ID: <a20220cb-7584-52d8-d3c1-72d3ac2f3aa3@linux.ibm.com>
Date:   Tue, 29 Nov 2022 15:17:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 1/2] lib: s390x: add PSW and PSW_CUR_MASK macros
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     nrb@linux.ibm.com, seiden@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
References: <20221129094142.10141-1-imbrenda@linux.ibm.com>
 <20221129094142.10141-2-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20221129094142.10141-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nd9d2aaSYdti5rWzn7opNao2SHJrkvu2
X-Proofpoint-GUID: WEZeEZgETOwUTxXtD9ndQrbbsOSt6_4M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_08,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290081
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/29/22 10:41, Claudio Imbrenda wrote:
> Since a lot of code starts new CPUs using the current PSW mask, add two
> macros to streamline the creation of generic PSWs and PSWs with the
> current program mask.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 783a7eaa..43137d5f 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -41,6 +41,8 @@ struct psw {
>   	uint64_t	addr;
>   };
>   
> +#define PSW(m, a) ((struct psw){ .mask = (m), .addr = (uint64_t)(a) })
> +
>   struct short_psw {
>   	uint32_t	mask;
>   	uint32_t	addr;
> @@ -321,6 +323,8 @@ static inline uint64_t extract_psw_mask(void)
>   	return (uint64_t) mask_upper << 32 | mask_lower;
>   }
>   
> +#define PSW_CUR_MASK(addr) PSW(extract_psw_mask(), (addr))

This sounds too much like what extract_psw_mask() does.
So we should agree on a name that states that we receive a PSW and not a 
PSW mask.

s/PSW_CUR_MASK/PSW_WITH_CUR_MASK/

Other than that the code looks fine.

> +
>   static inline void load_psw_mask(uint64_t mask)
>   {
>   	struct psw psw = {

