Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8356AE16A
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 14:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjCGNx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 08:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbjCGNxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 08:53:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E98FF0D;
        Tue,  7 Mar 2023 05:53:23 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327CrdH9024649;
        Tue, 7 Mar 2023 13:53:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=DCON5TsuaQcWWKw79E0NJbBRLc4I/VqAtW9M+m30o3o=;
 b=hl09OTFnwkgQ3QHTlQ32HMueEX29oK0oY/RKL7U3Vr1zBxbFtHAPerK1CrCvdWPK9D5+
 duASd64jCimCIJefocFcPQBDS0GYPsynjrbAP2bPg7Z9kmodzf3kxlsx1nUNPnHCClD8
 Ahfu8AUmgAb/x7v/iOYncvv+lW04NiHvTCivyxdFWz7TrzPqtd93e25sEp0fUTi2xvj7
 TAgxTxcPtIkI/NV7YgVnRADiAoiy7XhbhG1uAhdNsBMtxvx3/bTYxOHFn8i8QoZnUo7/
 wK9Xifg31+02WOSsynauRvbFykTjzFQAv0lFsMePwedhMm3LQ5XCiC83On+zG+ZuNYI2 kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p65p3hqbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 13:53:23 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 327CsxOS028029;
        Tue, 7 Mar 2023 13:53:22 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p65p3hqac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 13:53:22 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 326Md6CL011404;
        Tue, 7 Mar 2023 13:53:20 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3p418v3cfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 13:53:20 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 327DrGr062652710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Mar 2023 13:53:16 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92A7F20040;
        Tue,  7 Mar 2023 13:53:16 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11CCA20049;
        Tue,  7 Mar 2023 13:53:16 +0000 (GMT)
Received: from [9.171.74.73] (unknown [9.171.74.73])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  7 Mar 2023 13:53:15 +0000 (GMT)
Message-ID: <b03e447f-6f49-cdd0-1b8a-b27f63aa6bae@linux.ibm.com>
Date:   Tue, 7 Mar 2023 14:53:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v1] KVM: s390: interrupt: fix virtual-physical confusion
 for next alert GISA
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        agordeev@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230223162236.51569-1-nrb@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <20230223162236.51569-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3-AWam4YN5lYCO5EDhkyNzVDy9xiTKFj
X-Proofpoint-ORIG-GUID: Ps3J6DvEaK0aAEqMPBR71Fq0Y6Aim5Qh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_07,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23.02.23 17:22, Nico Boehr wrote:
> We sometimes put a virtual address in next_alert, which should always be
> a physical address, since it is shared with hardware.
> 
> This currently works, because virtual and physical addresses are
> the same.
> 
> Add phys_to_virt() to resolve the virtual-physical confusion.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   arch/s390/kvm/interrupt.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index ab26aa53ee37..20743c5b000a 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -305,7 +305,7 @@ static inline u8 gisa_get_ipm_or_restore_iam(struct kvm_s390_gisa_interrupt *gi)
>   
>   static inline int gisa_in_alert_list(struct kvm_s390_gisa *gisa)
>   {
> -	return READ_ONCE(gisa->next_alert) != (u32)(u64)gisa;
> +	return READ_ONCE(gisa->next_alert) != (u32)virt_to_phys(gisa);
>   }
>   
>   static inline void gisa_set_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
> @@ -3167,7 +3167,7 @@ void kvm_s390_gisa_init(struct kvm *kvm)
>   	hrtimer_init(&gi->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>   	gi->timer.function = gisa_vcpu_kicker;
>   	memset(gi->origin, 0, sizeof(struct kvm_s390_gisa));
> -	gi->origin->next_alert = (u32)(u64)gi->origin;
> +	gi->origin->next_alert = (u32)virt_to_phys(gi->origin);
>   	VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
>   }
>   

Here is my

Signed-off-by: Michael Mueller <mimu@linux.ibm.com>

I ran hades tests as well. Thanks.
