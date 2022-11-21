Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1419D631CBF
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 10:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiKUJWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 04:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiKUJWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 04:22:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C37031DFC
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 01:22:10 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AL7KEWr004975;
        Mon, 21 Nov 2022 09:22:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=P3gDgFbVdBhrzTB4X9Hmm53gXt/UmmbSptPObkyfukA=;
 b=g9OrKIBxgsFwcF0mq+5Uc/43/xNEU43/j1DV7D9HsbEp5y8U9IQc/7HayWSwX5LcziKG
 jhbyKuyEBymHc/XtYFWzWLwhqea7B11V7fpK0A7BJTyef6dY7mQdi02ETcPZ3uesvPIB
 10b/2T+Bfv3Bn1fwpfWrmhcvGAGiMPt6GiU8r8e+aDrRgYNzw5Sfm2W6qcLTeE3RTr6y
 LkOcA3LNZ73AoMfDcfzhTfbwCplsG/1LvrulQhSHqdFgNMosdwxNy7sE1UKP4CyG8Yeo
 WU7duo55Y3CDJnlZ/KkF9tIcDZHemDdyBoMv7EgWeVAysz04VkURsrXGuLpjg62k7VW9 UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ky931caau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 09:22:05 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AL7vr4E011994;
        Mon, 21 Nov 2022 09:22:05 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ky931caac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 09:22:05 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AL9LQqx005945;
        Mon, 21 Nov 2022 09:22:03 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3kxps8ssuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 09:22:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AL9FpcW46465288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 09:15:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F689AE051;
        Mon, 21 Nov 2022 09:22:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06265AE04D;
        Mon, 21 Nov 2022 09:22:01 +0000 (GMT)
Received: from [9.171.18.226] (unknown [9.171.18.226])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Nov 2022 09:22:00 +0000 (GMT)
Message-ID: <64be9403-b46f-3805-35cc-d1b6656709da@linux.ibm.com>
Date:   Mon, 21 Nov 2022 10:22:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [RFC PATCH 3/3] KVM: Obey kvm.halt_poll_ns in VMs not using
 KVM_CAP_HALT_POLL
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>
References: <20221117001657.1067231-1-dmatlack@google.com>
 <20221117001657.1067231-4-dmatlack@google.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221117001657.1067231-4-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -5BgcuXxnosLLFaM8P_5pZs8o03imVPm
X-Proofpoint-ORIG-GUID: JHZTwM7s_pqVX9X5oWodneS-OgYfVgKi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_05,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 adultscore=0 clxscore=1015 bulkscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 17.11.22 um 01:16 schrieb David Matlack:
> Obey kvm.halt_poll_ns in VMs not using KVM_CAP_HALT_POLL on every halt,
> rather than just sampling the module parameter when the VM is first
> created. This restore the original behavior of kvm.halt_poll_ns for VMs
> that have not opted into KVM_CAP_HALT_POLL.
> 
> Notably, this change restores the ability for admins to disable or
> change the maximum halt-polling time system wide for VMs not using
> KVM_CAP_HALT_POLL.
> 
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Fixes: acd05785e48c ("kvm: add capability for halt polling")
> Signed-off-by: David Matlack <dmatlack@google.com>

Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

One thing. This does not apply without the other 2 patches. Not sure
if we want to redo this somehow to allow for stable backports?


> ---
>   include/linux/kvm_host.h |  1 +
>   virt/kvm/kvm_main.c      | 27 ++++++++++++++++++++++++---
>   2 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e6e66c5e56f2..253ad055b6ad 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -788,6 +788,7 @@ struct kvm {
>   	struct srcu_struct srcu;
>   	struct srcu_struct irq_srcu;
>   	pid_t userspace_pid;
> +	bool override_halt_poll_ns;
>   	unsigned int max_halt_poll_ns;
>   	u32 dirty_ring_size;
>   	bool vm_bugged;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 78caf19608eb..7f73ce99bd0e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1198,8 +1198,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>   			goto out_err_no_arch_destroy_vm;
>   	}
>   
> -	kvm->max_halt_poll_ns = halt_poll_ns;
> -
>   	r = kvm_arch_init_vm(kvm, type);
>   	if (r)
>   		goto out_err_no_arch_destroy_vm;
> @@ -3490,7 +3488,20 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>   
>   static unsigned int kvm_vcpu_max_halt_poll_ns(struct kvm_vcpu *vcpu)
>   {
> -	return READ_ONCE(vcpu->kvm->max_halt_poll_ns);
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	if (kvm->override_halt_poll_ns) {
> +		/*
> +		 * Ensure kvm->max_halt_poll_ns is not read before
> +		 * kvm->override_halt_poll_ns.
> +		 *
> +		 * Pairs with the smp_wmb() when enabling KVM_CAP_HALT_POLL.
> +		 */
> +		smp_rmb();
> +		return READ_ONCE(kvm->max_halt_poll_ns);
> +	}
> +
> +	return READ_ONCE(halt_poll_ns);
>   }
>   
>   /*
> @@ -4600,6 +4611,16 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>   			return -EINVAL;
>   
>   		kvm->max_halt_poll_ns = cap->args[0];
> +
> +		/*
> +		 * Ensure kvm->override_halt_poll_ns does not become visible
> +		 * before kvm->max_halt_poll_ns.
> +		 *
> +		 * Pairs with the smp_rmb() in kvm_vcpu_max_halt_poll_ns().
> +		 */
> +		smp_wmb();
> +		kvm->override_halt_poll_ns = true;
> +
>   		return 0;
>   	}
>   	case KVM_CAP_DIRTY_LOG_RING:
