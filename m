Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A2F75C9D1
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 16:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjGUOXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 10:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjGUOXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 10:23:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255CF1BD;
        Fri, 21 Jul 2023 07:23:22 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36LE6VuN001098;
        Fri, 21 Jul 2023 14:23:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LHzbAf4p3hknDSQFHMo0HLS4YDqB1wYdsh71y9Uf2x8=;
 b=EFBEIMdi4jLgY0lExoehWOhmEq7k2WeXXsZHPEH4YveOMdo6MzWBJ3BdprXKYNOJmOce
 vylwYypHP6qdhVUa41Xp9ki5VtNBX/OjmGReRlPSni65mCrMnRYjwfzLdkQyjBOw+C/O
 mYE93+bseWQcEEUannxldTRZn01MSeOr2p4+ZMcxzr6nv5T/ZU2M0JfAMRvJ+8aHW7vu
 xhPU9oET9ZKwHuJIY5HcpTUiT2FAUJzBRaLR+oEM0j2hFbI7xE0JyzRbh1MGQuSYtEas
 meSAgryILFbnAcKLJxN9Uldv8/zeFHkIdL3ChVCjfzvVtt0gAssMrQdPMJY+4Whp0W1X iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ryc7gdd7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jul 2023 14:23:21 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36LE824c010329;
        Fri, 21 Jul 2023 14:23:21 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ryc7gdd76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jul 2023 14:23:21 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36LCg61i008046;
        Fri, 21 Jul 2023 14:23:20 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rv80jmt5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jul 2023 14:23:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36LENHiF44302868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 14:23:17 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42DB220040;
        Fri, 21 Jul 2023 14:23:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8751120043;
        Fri, 21 Jul 2023 14:23:16 +0000 (GMT)
Received: from [9.171.55.243] (unknown [9.171.55.243])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jul 2023 14:23:16 +0000 (GMT)
Message-ID: <6dc411a6-95fc-0eb2-e8de-5c141292ea62@linux.ibm.com>
Date:   Fri, 21 Jul 2023 16:23:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 5/6] KVM: s390: interrupt: Fix single-stepping ISKE
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>
References: <20230721120046.2262291-1-iii@linux.ibm.com>
 <20230721120046.2262291-6-iii@linux.ibm.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20230721120046.2262291-6-iii@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _TmKtxLSgvwOrUNQcX9My4iKmrl4PVxn
X-Proofpoint-ORIG-GUID: 860VH0J45EDEm7hypxFlcxaKa5MzhO6e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_08,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=782 malwarescore=0 priorityscore=1501
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 clxscore=1015
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2306200000 definitions=main-2307210127
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 21.07.23 um 13:57 schrieb Ilya Leoshkevich:
> kvm_s390_skey_check_enable() does not emulate any instructions, rather,
> it clears CPUSTAT_KSS and arranges for ISKE to run again. Therefore,
> skip the PER check and let ISKE run happen. Otherwise a debugger will
> see two single-step events on the same ISKE.

The same would be true for all instruction triggering a keyless mode exit,
like SSKE, RRBE but also LPSWE with a keyed PSW, no?
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>   arch/s390/kvm/intercept.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index d2f7940c5d03..8793cec066a6 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -630,8 +630,7 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>   		rc = handle_partial_execution(vcpu);
>   		break;
>   	case ICPT_KSS:
> -		rc = kvm_s390_skey_check_enable(vcpu);
> -		break;

maybe add a comment here: /* Instruction will be redriven, skip the PER check */
> +		return kvm_s390_skey_check_enable(vcpu);

>   	case ICPT_MCHKREQ:
>   	case ICPT_INT_ENABLE:
>   		/*
