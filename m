Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6022D607450
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 11:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiJUJkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 05:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiJUJkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 05:40:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA0924CCBA
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 02:40:39 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29L9bq7V028664
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 09:40:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=EUE358VAEu5XSecfhJaXTAd9m1rGoWrSmPYSUbRJwhw=;
 b=OKIJMx4H6NkWE/8z7zX/BuR5N9PHPFsQvicddiNMgBd6qj7xW91cK1Bq0cnT3oWWJDjP
 swhEML89tXJCnLLesRt3iekbw4awlx5aj/3NHlHUpRx+ucSrERUnnN6yhY95T8Ey0Wp2
 Adup03V4DP4kVsfhz8JsqBwry70ByXhZ/C8WAsWnq69a+injVNdHawdDDCDr+Jfc5SZf
 uSGmCKXXfn2EWq+XbR07HRv8V2/c5CWlX5DH9QYtG6HRXNUYpVL5aRgstjD5bUDgw3vN
 LKzCTGHVd9mKOTPg8NOvTyDP2zGwAbAWc7xQoXGgN9Q0nF2MlBDVrj+gkx2YL01IJ3aW uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbrqs8e70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 09:40:38 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29L9cZIs002388
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 09:40:38 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbrqs8e4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 09:40:37 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29L9bUA8003392;
        Fri, 21 Oct 2022 09:40:35 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg9ab98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 09:40:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29L9eWam7340742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Oct 2022 09:40:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13850AE053;
        Fri, 21 Oct 2022 09:40:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB91BAE04D;
        Fri, 21 Oct 2022 09:40:31 +0000 (GMT)
Received: from [9.145.155.93] (unknown [9.145.155.93])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Oct 2022 09:40:31 +0000 (GMT)
Message-ID: <f615f244-e5d6-1f2e-7976-10ff6bcd055e@linux.ibm.com>
Date:   Fri, 21 Oct 2022 11:40:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [kvm-unit-tests PATCH v3 5/6] lib: s390x: Enable reusability of
 VMs that were in PV mode
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
References: <20221021063902.10878-1-frankja@linux.ibm.com>
 <20221021063902.10878-6-frankja@linux.ibm.com>
Content-Language: en-US
From:   Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <20221021063902.10878-6-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VHMsyBvUMBkTMu72hM8BXNoXnukEZUPa
X-Proofpoint-GUID: jR74e8xG-VpNE9gtIBc7wWTI3hqT6nAK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/21/22 08:39, Janosch Frank wrote:
> Convert the sblk to non-PV when the PV guest is destroyed.
> 
> Early return in uv_init() instead of running into the assert. This is
> necessary since snippet_pv_init() will always call uv_init().
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   lib/s390x/uv.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
> index b2a43424..383271a5 100644
> --- a/lib/s390x/uv.c
> +++ b/lib/s390x/uv.c
> @@ -76,7 +76,8 @@ void uv_init(void)
>   	int cc;
>   
>   	/* Let's not do this twice */
> -	assert(!initialized);
> +	if (initialized)
> +		return;
>   	/* Query is done on initialization but let's check anyway */
>   	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100);
>   
> @@ -188,6 +189,14 @@ void uv_destroy_guest(struct vm *vm)
>   	free_pages(vm->uv.conf_var_stor);
>   
>   	free_pages((void *)(vm->uv.asce & PAGE_MASK));
> +	memset(&vm->uv, 0, sizeof(vm->uv));
> +
> +	/* Convert the sblk back to non-PV */
> +	vm->save_area.guest.asce = stctg(1);
> +	vm->sblk->sdf = 0;
> +	vm->sblk->sidad = 0;
> +	vm->sblk->pv_handle_cpu = 0;
> +	vm->sblk->pv_handle_config = 0;
>   }
>   
>   int uv_unpack(struct vm *vm, uint64_t addr, uint64_t len, uint64_t tweak)

