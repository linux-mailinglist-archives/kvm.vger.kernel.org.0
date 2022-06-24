Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733E1559345
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 08:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiFXGWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 02:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiFXGWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 02:22:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96C43FDA5;
        Thu, 23 Jun 2022 23:22:42 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25O5orOT006898;
        Fri, 24 Jun 2022 06:22:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Di51jl6wOZ18ExhrQMG2SxXoh7hgGushxQFiaaPCd9Q=;
 b=n2xZ7L0mM7V7Huz787QNeqiB4mT0ttcPOP6ORdNlp28T/G1C27lckGxV6SBfgMFzeboq
 szAFrBD8Wta+6QV9VKvebSzp4FYquRTJiT4uOfMdc3gat9g6u0cujvnvkYNm5xjsHqPl
 CYV+YCddv/5OjyaRB2Beso/iDCKSlp0yewxTnINVY6t5XSBGz7dU85Ag27y/QUHamfeW
 bgh+t0suYCAGrR+ikjZN0NVRGou2n4QV5LyGSiGFP3SunwtousR+S+WbqdR/UTct4zd9
 NW5/XFMQ2pMrFzZHBecJQ6fVqn10Z/rLy+iB+KH/iBlP5uS8x+I5+eK0+xmdSfRpwCuP aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gw7fxrpmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 06:22:42 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25O5u0GV027351;
        Fri, 24 Jun 2022 06:22:41 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gw7fxrpm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 06:22:41 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25O6K4uZ016759;
        Fri, 24 Jun 2022 06:22:39 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3gv3mba4na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 06:22:39 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25O6MZkO20644100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 06:22:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7014C4C040;
        Fri, 24 Jun 2022 06:22:35 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C0EC4C044;
        Fri, 24 Jun 2022 06:22:34 +0000 (GMT)
Received: from [9.145.85.86] (unknown [9.145.85.86])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Jun 2022 06:22:34 +0000 (GMT)
Message-ID: <5217b1ec-c170-d046-5158-e17ffcfe8316@linux.ibm.com>
Date:   Fri, 24 Jun 2022 08:22:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
 <20220620125437.37122-3-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v10 2/3] KVM: s390: guest support for topology function
In-Reply-To: <20220620125437.37122-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lb-mluRrEEYCQspZr6VJMT6wCmQyqykT
X-Proofpoint-ORIG-GUID: IpcmkmX6gChLJNIVCbJ2K3pyAaprb5J9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_04,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206240022
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
> We report a topology change to the guest for any CPU hotplug.
> 
> The reporting to the guest is done using the Multiprocessor
> Topology-Change-Report (MTCR) bit of the utility entry in the guest's
> SCA which will be cleared during the interpretation of PTF.
> 
> On every vCPU creation we set the MCTR bit to let the guest know the
> next time he uses the PTF with command 2 instruction that the
> topology changed and that he should use the STSI(15.1.x) instruction
> to get the topology details.
> 
> STSI(15.1.x) gives information on the CPU configuration topology.
> Let's accept the interception of STSI with the function code 15 and
> let the userland part of the hypervisor handle it when userland
> support the CPU Topology facility.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h | 11 ++++++++---
>   arch/s390/kvm/kvm-s390.c         | 27 ++++++++++++++++++++++++++-
>   arch/s390/kvm/priv.c             | 15 +++++++++++----
>   arch/s390/kvm/vsie.c             |  3 +++
>   4 files changed, 48 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 766028d54a3e..bb54196d4ed6 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -97,15 +97,19 @@ struct bsca_block {
>   	union ipte_control ipte_control;
>   	__u64	reserved[5];
>   	__u64	mcn;
> -	__u64	reserved2;
> +#define SCA_UTILITY_MTCR	0x8000

I'm not too happy having this in the bsca but not in the esca. I'd 
suggest putting it outside the structs or to go with my next suggestion:

Just make it a bit field struct and make that a member in bsca/esca.
No messing about with ANDing, ORing etc.

It's unfortunate that we only use one bit in that field but I'd still 
find it easier to read.

> +	__u16	utility;
> +	__u8	reserved2[6];
>   	struct bsca_entry cpu[KVM_S390_BSCA_CPU_SLOTS];
>   };
>   
>   struct esca_block {
>   	union ipte_control ipte_control;
> -	__u64   reserved1[7];
> +	__u64   reserved1[6];
> +	__u16	utility;
> +	__u8	reserved2[6];
>   	__u64   mcn[4];
> -	__u64   reserved2[20];
> +	__u64   reserved3[20];
>   	struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
>   };
>   
> @@ -249,6 +253,7 @@ struct kvm_s390_sie_block {
>   #define ECB_SPECI	0x08
>   #define ECB_SRSI	0x04
>   #define ECB_HOSTPROTINT	0x02
> +#define ECB_PTF		0x01
>   	__u8	ecb;			/* 0x0061 */
>   #define ECB2_CMMA	0x80
>   #define ECB2_IEP	0x20
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 8fcb56141689..95b96019ca8e 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1691,6 +1691,25 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>   	return ret;
>   }
>   
> +/**
> + * kvm_s390_sca_set_mtcr
> + * @kvm: guest KVM description
> + *
> + * Is only relevant if the topology facility is present,
> + * the caller should check KVM facility 11

I'm not sure that this statement make sense since you set the mctr in 
kvm_s390_vcpu_setup() unconditionally and don't check stfle 11.

I think we can remove the second line from this.

> + *
> + * Updates the Multiprocessor Topology-Change-Report to signal
> + * the guest with a topology change.

Please swap those two comments

> + */
> +static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
> +{
> +	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */

Please put the comment above the statement and maybe extend it a bit:
SCA version doesn't matter, the utility field always has the same offset.

> +
> +	ipte_lock(kvm);
> +	sca->utility |= SCA_UTILITY_MTCR;
> +	ipte_unlock(kvm);
> +}
> +
>   static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>   {
>   	int ret;
> @@ -3143,7 +3162,6 @@ __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu)
>   
>   void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   {
> -

Please remove that change

>   	gmap_enable(vcpu->arch.enabled_gmap);
>   	kvm_s390_set_cpuflags(vcpu, CPUSTAT_RUNNING);
>   	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
> @@ -3272,6 +3290,11 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>   		vcpu->arch.sie_block->ecb |= ECB_HOSTPROTINT;
>   	if (test_kvm_facility(vcpu->kvm, 9))
>   		vcpu->arch.sie_block->ecb |= ECB_SRSI;
> +
> +	/* PTF needs guest facilities to enable interpretation */
> +	if (test_kvm_facility(vcpu->kvm, 11))
> +		vcpu->arch.sie_block->ecb |= ECB_PTF;
> +
>   	if (test_kvm_facility(vcpu->kvm, 73))
>   		vcpu->arch.sie_block->ecb |= ECB_TE;
>   	if (!kvm_is_ucontrol(vcpu->kvm))
> @@ -3403,6 +3426,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   	rc = kvm_s390_vcpu_setup(vcpu);
>   	if (rc)
>   		goto out_ucontrol_uninit;
> +
> +	kvm_s390_sca_set_mtcr(vcpu->kvm);
>   	return 0;
>   
>   out_ucontrol_uninit:
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 12c464c7cddf..77a692238585 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -873,10 +873,13 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>   	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>   		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>   
> -	if (fc > 3) {
> -		kvm_s390_set_psw_cc(vcpu, 3);
> -		return 0;
> -	}
> +	/* Bailout forbidden function codes */
> +	if (fc > 3 && fc != 15)
> +		goto out_no_data;
> +
> +	/* fc 15 is provided with PTF/CPU topology support */
> +	if (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))
> +		goto out_no_data;
>   
>   	if (vcpu->run->s.regs.gprs[0] & 0x0fffff00
>   	    || vcpu->run->s.regs.gprs[1] & 0xffff0000)
> @@ -910,6 +913,10 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>   			goto out_no_data;
>   		handle_stsi_3_2_2(vcpu, (void *) mem);
>   		break;
> +	case 15:
> +		trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
> +		insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
> +		return -EREMOTE;
>   	}
>   	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
>   		memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index dada78b92691..4f4fee697550 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -503,6 +503,9 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   	/* Host-protection-interruption introduced with ESOP */
>   	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_ESOP))
>   		scb_s->ecb |= scb_o->ecb & ECB_HOSTPROTINT;
> +	/* CPU Topology */

Maybe also add:
This facility only uses the utility field of the SCA and none of the cpu 
entries that are problematic with the other interpretation facilities so 
we can pass it through.

> +	if (test_kvm_facility(vcpu->kvm, 11))
> +		scb_s->ecb |= scb_o->ecb & ECB_PTF;
>   	/* transactional execution */
>   	if (test_kvm_facility(vcpu->kvm, 73) && wants_tx) {
>   		/* remap the prefix is tx is toggled on */

