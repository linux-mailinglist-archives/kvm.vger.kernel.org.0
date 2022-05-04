Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B093519A06
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 10:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346435AbiEDIm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 04:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346460AbiEDImX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 04:42:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403271EC78;
        Wed,  4 May 2022 01:38:48 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2448Gp2r003238;
        Wed, 4 May 2022 08:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oShbc3ojYqstiZ98mnsKeaplsueV3IBbAG2DrfT9FJQ=;
 b=ke6wViisE1n7mWfl+37OxeY6Y8NXXfYhvVQodM7FPIOanvQe7V8hCprRiYzxWwBg8+ro
 lQ7ORf1PZ1FZMv/nMERsun8JlIcxoYrMNVCpTgQzGu7iZ4EWPIV//PTfHqgLHz/AEHJD
 nT8gg+fAU6cwnyl//FQL+nLj73/Kx/5WG6lnvX/Km6FdoiKufM1/2CHR/fL41rCwtDhw
 nMZnXhn8mTWdnUikXN0b0Rb4TXYaax9WEIBq7fEZKi8o6TivckHCLCPKJvx+MvCd8fwE
 M9VSG1PZuPWepIammHTZfYVE4X5eoX1oOYGxN79hHdYtt9FsumKJo+XnU4McjjzZk5R6 ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3funubg8b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 08:38:47 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2448YoXZ026108;
        Wed, 4 May 2022 08:38:47 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3funubg8ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 08:38:47 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2448b4ag028135;
        Wed, 4 May 2022 08:38:45 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ftp7ft5jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 08:38:44 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2448cfLR50463224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 May 2022 08:38:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DD99A405B;
        Wed,  4 May 2022 08:38:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E9B6A405C;
        Wed,  4 May 2022 08:38:41 +0000 (GMT)
Received: from [9.152.224.247] (unknown [9.152.224.247])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 May 2022 08:38:41 +0000 (GMT)
Message-ID: <d80270fe-e0a2-d6c3-8638-54881fe05d8a@linux.ibm.com>
Date:   Wed, 4 May 2022 10:38:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v5 4/6] s390x: uv-guest: Remove double
 report_prefix_pop
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220502093925.4118-1-seiden@linux.ibm.com>
 <20220502093925.4118-5-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220502093925.4118-5-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ItiJsboLNF5cKyaeF_lRwqG5Awo2XSNp
X-Proofpoint-GUID: RHqaf9O5drhd1JeG0Z08WAzTcqDEzDTh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-04_02,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205040057
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/2/22 11:39, Steffen Eiden wrote:
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   s390x/uv-guest.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index 728c60aa..fd2cfef1 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -111,8 +111,6 @@ static void test_sharing(void)
>   	cc = uv_call(0, (u64)&uvcb);
>   	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "unshare");
>   	report_prefix_pop();
> -
> -	report_prefix_pop();
>   }
>   
>   static struct {

