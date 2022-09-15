Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB3A5B9BC8
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 15:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiIONYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 09:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiIONYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 09:24:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18FE239
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 06:24:27 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FDCbBH004948;
        Thu, 15 Sep 2022 13:24:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tPPaogyK0l9Tbf9cNkEQ+PD3sWSA0nM6AuoD52aeYZg=;
 b=C754EcwrCk2UL8FWSgymPe9YX6B0hWdBZStE8v0KPPGYbJA7gunAjs5XLB85Bz+MbJWX
 Mixqk1SU99wfP2lLMm5Jh5abr0hXJXqlu1EORvf7XqhY+i9KjpWUsdBeT+U1k/9x5c9V
 MbgfPi934szzM/rM7ktz15ejyZvDVzP9Q0WHYyBvdFcqhQ40kG7g4ZZuqoev1MCSRcH3
 DbCGpV09ssZEyeet8vj7XuMEG1u51qn3dyZCG1ht4TeFy1F8rnhuBkuvpTUW7ehWcVR8
 qZbBCC9boJnyj5W0TB0VSRNQYsdhmDUI55FN/ITpT2srZXhw904CxNDra+Za9DD/ikFo SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm4qr0dv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 13:24:21 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28FDGI00029201;
        Thu, 15 Sep 2022 13:24:19 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm4qr0dtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 13:24:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28FDKcaj020566;
        Thu, 15 Sep 2022 13:24:17 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3jjytx2dwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 13:24:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28FDOEu742533300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 13:24:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBC454C046;
        Thu, 15 Sep 2022 13:24:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39E854C044;
        Thu, 15 Sep 2022 13:24:14 +0000 (GMT)
Received: from [9.171.87.36] (unknown [9.171.87.36])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Sep 2022 13:24:14 +0000 (GMT)
Message-ID: <7f0ffc04-40bf-b8fe-55f5-405c6485b1df@linux.ibm.com>
Date:   Thu, 15 Sep 2022 15:24:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v6 4/5] KVM: s390x: Dirty quota-based throttling of vcpus
Content-Language: en-US
To:     Shivam Kumar <shivam.kumar1@nutanix.com>, pbonzini@redhat.com,
        seanjc@google.com, maz@kernel.org, james.morse@arm.com,
        david@redhat.com
Cc:     kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-5-shivam.kumar1@nutanix.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220915101049.187325-5-shivam.kumar1@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bmNM4YtNeJHl_sVDtvOGmjQU-BNaqWm0
X-Proofpoint-ORIG-GUID: 3wq_zTQuALYdef6fwN1o24uzo_IWmdfP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_06,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2208220000
 definitions=main-2209150074
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 15.09.22 um 12:10 schrieb Shivam Kumar:
> Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
> equals/exceeds dirty quota) to request more dirty quota.
> 
> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index edfd4bbd0cba..2fe2933a7064 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4343,6 +4343,15 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
>   		goto retry;
>   	}
>   
> +	if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
> +		struct kvm_run *run = vcpu->run;
> +
> +		run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
> +		run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
> +		run->dirty_quota_exit.quota = vcpu->dirty_quota;
> +		return 1;
> +	}

Please use
return -EREMOTE;

We use this in s390 code to indicate "we need exit to userspace" and
kvm_arch_vcpu_ioctl_run will change -EREMOTE to 0.

> +
>   	/* nothing to do, just clear the request */
>   	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>   	/* we left the vsie handler, nothing to do, just clear the request */
