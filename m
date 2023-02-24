Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8451F6A1A5B
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 11:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjBXKdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 05:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjBXKc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 05:32:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6401E69AFB;
        Fri, 24 Feb 2023 02:31:58 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OA3Fmc026695;
        Fri, 24 Feb 2023 10:31:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MgyB3An/rfDorfOmnS1Qb76soeG2jIhRLWXC8Adq0p0=;
 b=RYtPTvo1hF1PqkjyQOWK8M9Rd1IQjSLx8MpxPctdySyxvNkptMuBA7pz+vxvRT3/Gk4L
 dK9qYks/KYwtGmzuESmJX70oVBVa6xRBiMYacFcgMeVNPzwDc8JNsWuohnRIMu81HHOl
 xExEUqfJmL/SPX2b/RW5EBjBMF/iO2w4QO//5Y3z6sZa9O0O/UPcYpiJysOi5BP+lO40
 R93HqtBdRl8/YtKDl+7nztaoigqZYIjgWjOePA8byF1xtau+23e509nxhPtajfrMkiGl
 K4UfL8b9Do0K8z/6AJwy86upLsz21nTaFEF6tL/ZgvOVQs+Dzy0fjbyn+HP7ECLWlSIL mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nxu550ken-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 10:31:33 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31OA5HIl000627;
        Fri, 24 Feb 2023 10:31:33 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nxu550ke2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 10:31:32 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31NMZV8F016665;
        Fri, 24 Feb 2023 10:31:31 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ntpa6fu53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 10:31:31 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31OAVRl952101502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 10:31:27 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACE9920043;
        Fri, 24 Feb 2023 10:31:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3565A20040;
        Fri, 24 Feb 2023 10:31:27 +0000 (GMT)
Received: from [9.171.22.148] (unknown [9.171.22.148])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Feb 2023 10:31:27 +0000 (GMT)
Message-ID: <e9ea477a-29fd-9957-9a80-5aca300edee8@linux.ibm.com>
Date:   Fri, 24 Feb 2023 11:31:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, mimu@linux.ibm.com,
        agordeev@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230223162236.51569-1-nrb@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v1] KVM: s390: interrupt: fix virtual-physical confusion
 for next alert GISA
In-Reply-To: <20230223162236.51569-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6QeBoIFATPhHQv6g3CiIATtwL86sVzW0
X-Proofpoint-GUID: 41LlA4ASA6y36iLpduWFsinfBenoBeV0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_04,2023-02-23_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240083
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/23/23 17:22, Nico Boehr wrote:
> We sometimes put a virtual address in next_alert, which should always be
> a physical address, since it is shared with hardware.
> 
> This currently works, because virtual and physical addresses are
> the same.

I'd replace that with something like:

The gisa next alert address is defined as a host absolute address so 
let's use virt_to_phys() to make sure we always write an absolute 
address to this hardware structure.

This is not a bug since we're currently still running as a virtual == 
physical kernel but plan to move away from that.

> 
> Add phys_to_virt() to resolve the virtual-physical confusion.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

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

