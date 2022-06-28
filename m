Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8779655EA14
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbiF1Qo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 12:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235346AbiF1Qnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 12:43:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075BC5F94;
        Tue, 28 Jun 2022 09:42:06 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SGbsuW028382;
        Tue, 28 Jun 2022 16:42:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=K/UBgtt6/6uSNgscEd4vgJNPQ+dVZWfUMfcvFGbarcg=;
 b=DSAEI3dS00lCLQ6/zm/wqXchVF94xuTxk2xA5sGeRRwOVxycQzC+IlW0Czb6iaTzIBGf
 s9S79PPet2qs5vt5sXrTstqVoXmNhXs+FfHnEGyQDOVgNIC4ry2IILqSZxXUYG8J90rM
 AnRvjSkKz08MktFM3WU2Q0PAY65Zxt/m0+45ysITi1ttvFvT7i2wFAeRFudoE0r0hLa0
 7NUSBA5hOQk9/dm7lWN+iNmlwx5PBhss29kDoCUrSXqdUHIr1I8ELOkKge5TU80VBFqj
 nn2zESMU+Q2BLG26T7mWGkD+0jhUisGxbAkdhfJbjjvWHRTxn5o6Wlu8gUsQvGD7Szv1 jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h04ybgmsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 16:42:05 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SGc76A032403;
        Tue, 28 Jun 2022 16:42:05 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h04ybgmrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 16:42:05 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SGLHa7023234;
        Tue, 28 Jun 2022 16:42:03 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3gwsmhuvan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 16:42:03 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SGg0VK22348200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 16:42:00 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09360A4054;
        Tue, 28 Jun 2022 16:42:00 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EFBCA405B;
        Tue, 28 Jun 2022 16:41:59 +0000 (GMT)
Received: from [9.171.1.134] (unknown [9.171.1.134])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 16:41:59 +0000 (GMT)
Message-ID: <03c79e51-7a0b-f406-d4d2-b10f43b6a7a1@linux.ibm.com>
Date:   Tue, 28 Jun 2022 18:41:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v10 3/3] KVM: s390: resetting the Topology-Change-Report
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
 <20220620125437.37122-4-pmorel@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220620125437.37122-4-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dt4x60niNnGOVhDQfRJjS-0ITOpfPtao
X-Proofpoint-ORIG-GUID: T7exu_1iiNudLmngWcsfkf-13S1dGpGU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/22 14:54, Pierre Morel wrote:
> During a subsystem reset the Topology-Change-Report is cleared.
> Let's give userland the possibility to clear the MTCR in the case
> of a subsystem reset.
> 
> To migrate the MTCR, we give userland the possibility to
> query the MTCR state.
> 
> We indicate KVM support for the CPU topology facility with a new
> KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  Documentation/virt/kvm/api.rst   | 31 +++++++++++
>  arch/s390/include/uapi/asm/kvm.h | 10 ++++
>  arch/s390/kvm/kvm-s390.c         | 96 ++++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h         |  1 +
>  4 files changed, 138 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 11e00a46c610..326f8b7e7671 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7956,6 +7956,37 @@ should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
>  When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
>  type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
> 
> +8.37 KVM_CAP_S390_CPU_TOPOLOGY
> +------------------------------
> +
> +:Capability: KVM_CAP_S390_CPU_TOPOLOGY
> +:Architectures: s390
> +:Type: vm
> +
> +This capability indicates that KVM will provide the S390 CPU Topology
> +facility which consist of the interpretation of the PTF instruction for
> +the Function Code 2 along with interception and forwarding of both the
> +PTF instruction with Function Codes 0 or 1 and the STSI(15,1,x)
> +instruction to the userland hypervisor.

The way the code is written, STSI 15.x.x is forwarded to user space,
might actually make sense to future proof the code by restricting that
to 15.1.2-6 in priv.c.
> +
> +The stfle facility 11, CPU Topology facility, should not be provided
> +to the guest without this capability.
> +
> +When this capability is present, KVM provides a new attribute group
> +on vm fd, KVM_S390_VM_CPU_TOPOLOGY.
> +This new attribute allows to get, set or clear the Modified Change
> +Topology Report (MTCR) bit of the SCA through the kvm_device_attr
> +structure.
> +
> +Getting the MTCR bit is realized by using a kvm_device_attr attr
> +entry value of KVM_GET_DEVICE_ATTR and with kvm_device_attr addr
> +entry pointing to the address of a struct kvm_cpu_topology.
> +The value of the MTCR is return by the bit mtcr of the structure.
> +
> +When using KVM_SET_DEVICE_ATTR the MTCR is set by using the
> +attr->attr value KVM_S390_VM_CPU_TOPO_MTCR_SET and cleared by
> +using KVM_S390_VM_CPU_TOPO_MTCR_CLEAR.
> +
>  9. Known KVM API problems
>  =========================
> 
> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
> index 7a6b14874d65..df5e8279ffd0 100644
> --- a/arch/s390/include/uapi/asm/kvm.h
> +++ b/arch/s390/include/uapi/asm/kvm.h
> @@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
>  #define KVM_S390_VM_CRYPTO		2
>  #define KVM_S390_VM_CPU_MODEL		3
>  #define KVM_S390_VM_MIGRATION		4
> +#define KVM_S390_VM_CPU_TOPOLOGY	5
> 
>  /* kvm attributes for mem_ctrl */
>  #define KVM_S390_VM_MEM_ENABLE_CMMA	0
> @@ -171,6 +172,15 @@ struct kvm_s390_vm_cpu_subfunc {
>  #define KVM_S390_VM_MIGRATION_START	1
>  #define KVM_S390_VM_MIGRATION_STATUS	2
> 
> +/* kvm attributes for cpu topology */
> +#define KVM_S390_VM_CPU_TOPO_MTCR_CLEAR	0
> +#define KVM_S390_VM_CPU_TOPO_MTCR_SET	1

Are you going to transition to a set-value-provided-by-user API with the next series?
I don't particularly like that MTCR is user visible, it's kind of an implementation detail.

> +
> +struct kvm_cpu_topology {
> +	__u16 mtcr : 1;

So I'd give this a more descriptive name, report_topology_change/topo_change_report_pending ?

> +	__u16 reserved : 15;

Are these bits for future proofing? If so a few more would do no harm IMO.
> +};

The use of a bit field in uapi surprised my, but I guess it's fine and kvm_sync_regs has them too.
> +
>  /* for KVM_GET_REGS and KVM_SET_REGS */
>  struct kvm_regs {
>  	/* general purpose regs for s390 */
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 95b96019ca8e..ae39041bb149 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -606,6 +606,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_S390_PROTECTED:
>  		r = is_prot_virt_host();
>  		break;
> +	case KVM_CAP_S390_CPU_TOPOLOGY:
> +		r = test_facility(11);
> +		break;
>  	default:
>  		r = 0;
>  	}
> @@ -817,6 +820,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  		icpt_operexc_on_all_vcpus(kvm);
>  		r = 0;
>  		break;
> +	case KVM_CAP_S390_CPU_TOPOLOGY:
> +		r = -EINVAL;
> +		mutex_lock(&kvm->lock);
> +		if (kvm->created_vcpus) {
> +			r = -EBUSY;
> +		} else if (test_facility(11)) {
> +			set_kvm_facility(kvm->arch.model.fac_mask, 11);
> +			set_kvm_facility(kvm->arch.model.fac_list, 11);
> +			r = 0;
> +		}
> +		mutex_unlock(&kvm->lock);
> +		VM_EVENT(kvm, 3, "ENABLE: CPU TOPOLOGY %s",

Most of the other cases spell out the cap, so it'd be "ENABLE: CAP_S390_CPU_TOPOLOGY %s".

> +			 r ? "(not available)" : "(success)");
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -1710,6 +1727,76 @@ static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
>  	ipte_unlock(kvm);
>  }
> 

Some brainstorming function names:

kvm_s390_get_topo_change_report
kvm_s390_(un|re)set_topo_change_report
kvm_s390_(publish|revoke|unpublish)_topo_change_report
kvm_s390_(report|signal|revoke)_topology_change

[...]

