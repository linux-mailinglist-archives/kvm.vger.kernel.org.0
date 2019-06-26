Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C09D56B5E
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 15:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfFZN6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 09:58:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727481AbfFZN6H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jun 2019 09:58:07 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5QDvpVF102851
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 09:58:05 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tc8apwvss-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 09:58:04 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <walling@linux.ibm.com>;
        Wed, 26 Jun 2019 14:58:03 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 26 Jun 2019 14:57:59 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5QDvwH147055216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 13:57:58 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36CED2805E;
        Wed, 26 Jun 2019 13:57:58 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 199A32805A;
        Wed, 26 Jun 2019 13:57:58 +0000 (GMT)
Received: from [9.63.14.61] (unknown [9.63.14.61])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jun 2019 13:57:58 +0000 (GMT)
Subject: Re: [PATCH v5 2/2] s390/kvm: diagnose 318 handling
To:     David Hildenbrand <david@redhat.com>, cohuck@redhat.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <1561475022-18348-1-git-send-email-walling@linux.ibm.com>
 <1561475022-18348-3-git-send-email-walling@linux.ibm.com>
 <cb01cb7b-51c5-b1e7-0a07-b2db4b1f2cf8@redhat.com>
From:   Collin Walling <walling@linux.ibm.com>
Date:   Wed, 26 Jun 2019 09:57:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <cb01cb7b-51c5-b1e7-0a07-b2db4b1f2cf8@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19062613-0072-0000-0000-0000044140D8
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011334; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01223555; UDB=6.00643911; IPR=6.01004734;
 MB=3.00027476; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-26 13:58:01
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062613-0073-0000-0000-00004CB16983
Message-Id: <9a828de6-91ba-e37b-e5e7-92cc853bff0b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906260167
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/26/19 5:08 AM, David Hildenbrand wrote:
> On 25.06.19 17:03, Collin Walling wrote:
>> DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
>> be intercepted by SIE and handled via KVM. Let's introduce some
>> functions to communicate between userspace and KVM via ioctls. These
>> will be used to get/set the diag318 related information, as well as
>> check the system if KVM supports handling this instruction.
>>
>> This information can help with diagnosing the environment the VM is
>> running in (Linux, z/VM, etc) if the OS calls this instruction.
>>
>> The get/set functions are introduced primarily for VM migration and
>> reset, though no harm could be done to the system if a userspace
>> program decides to alter this data (this is highly discouraged).
>>
>> The Control Program Name Code (CPNC) is stored in the SIE block (if
>> host hardware supports it) and a copy is retained in each VCPU. The
>> Control Program Version Code (CPVC) is not designed to be stored in
>> the SIE block, so we retain a copy in each VCPU next to the CPNC.
>>
>> At this time, the CPVC is not reported during a VM_EVENT as its
>> format is yet to be properly defined.
>>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> 
> Only some minor comments.
> 
> 
>> ---
>>   Documentation/virtual/kvm/devices/vm.txt | 14 ++++++
>>   arch/s390/include/asm/kvm_host.h         |  5 +-
>>   arch/s390/include/uapi/asm/kvm.h         |  4 ++
>>   arch/s390/kvm/diag.c                     | 17 +++++++
>>   arch/s390/kvm/kvm-s390.c                 | 81 ++++++++++++++++++++++++++++++++
>>   arch/s390/kvm/kvm-s390.h                 |  1 +
>>   arch/s390/kvm/vsie.c                     |  2 +
>>   7 files changed, 123 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virtual/kvm/devices/vm.txt b/Documentation/virtual/kvm/devices/vm.txt
>> index 4ffb82b..56f7d9c 100644
>> --- a/Documentation/virtual/kvm/devices/vm.txt
>> +++ b/Documentation/virtual/kvm/devices/vm.txt
>> @@ -268,3 +268,17 @@ Parameters: address of a buffer in user space to store the data (u64) to;
>>   	    if it is enabled
>>   Returns:    -EFAULT if the given address is not accessible from kernel space
>>   	    0 in case of success.
>> +
>> +6. GROUP: KVM_S390_VM_MISC
>> +Architectures: s390
>> +
>> +6.1. KVM_S390_VM_MISC_DIAG318 (r/w)
>> +
>> +Allows userspace to access the DIAGNOSE 0x318 information which consists of a
>> +1-byte "Control Program Name Code" and a 7-byte "Control Program Version Code".
>> +This information is initialized during IPL and must be preserved during
>> +migration.
>> +
>> +Parameters: address of a buffer in user space to store the data (u64) to
>> +Returns:    -EFAULT if the given address is not accessible from kernel space
>> +	     0 in case of success.
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index 2b00a3e..b70e8a4 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -229,7 +229,8 @@ struct kvm_s390_sie_block {
>>   	__u32	scaol;			/* 0x0064 */
>>   	__u8	reserved68;		/* 0x0068 */
>>   	__u8    epdx;			/* 0x0069 */
>> -	__u8    reserved6a[2];		/* 0x006a */
>> +	__u8	cpnc;			/* 0x006a */
>> +	__u8	reserved6b;		/* 0x006b */
>>   	__u32	todpr;			/* 0x006c */
>>   #define GISA_FORMAT1 0x00000001
>>   	__u32	gd;			/* 0x0070 */
>> @@ -393,6 +394,7 @@ struct kvm_vcpu_stat {
>>   	u64 diagnose_9c;
>>   	u64 diagnose_258;
>>   	u64 diagnose_308;
>> +	u64 diagnose_318;
>>   	u64 diagnose_500;
>>   	u64 diagnose_other;
>>   };
>> @@ -868,6 +870,7 @@ struct kvm_arch{
>>   	DECLARE_BITMAP(cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
>>   	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
>>   	struct kvm_s390_gisa_interrupt gisa_int;
>> +	union diag318_info diag318_info;
>>   };
>>   
>>   #define KVM_HVA_ERR_BAD		(-1UL)
>> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
>> index 47104e5..e0684da 100644
>> --- a/arch/s390/include/uapi/asm/kvm.h
>> +++ b/arch/s390/include/uapi/asm/kvm.h
>> @@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
>>   #define KVM_S390_VM_CRYPTO		2
>>   #define KVM_S390_VM_CPU_MODEL		3
>>   #define KVM_S390_VM_MIGRATION		4
>> +#define KVM_S390_VM_MISC		5
>>   
>>   /* kvm attributes for mem_ctrl */
>>   #define KVM_S390_VM_MEM_ENABLE_CMMA	0
>> @@ -171,6 +172,9 @@ struct kvm_s390_vm_cpu_subfunc {
>>   #define KVM_S390_VM_MIGRATION_START	1
>>   #define KVM_S390_VM_MIGRATION_STATUS	2
>>   
>> +/* kvm attributes for KVM_S390_VM_MISC */
>> +#define KVM_S390_VM_MISC_DIAG318	0
>> +
>>   /* for KVM_GET_REGS and KVM_SET_REGS */
>>   struct kvm_regs {
>>   	/* general purpose regs for s390 */
>> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
>> index 45634b3d..42a8db3 100644
>> --- a/arch/s390/kvm/diag.c
>> +++ b/arch/s390/kvm/diag.c
>> @@ -235,6 +235,21 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
>>   	return ret < 0 ? ret : 0;
>>   }
>>   
>> +static int __diag_set_diag318_info(struct kvm_vcpu *vcpu)
>> +{
>> +	unsigned int reg = (vcpu->arch.sie_block->ipa & 0xf0) >> 4;
>> +	u64 info = vcpu->run->s.regs.gprs[reg];
>> +
>> +	vcpu->stat.diagnose_318++;
>> +	kvm_s390_set_diag318_info(vcpu->kvm, info);
>> +
>> +	VCPU_EVENT(vcpu, 3, "diag 0x318 cpnc: 0x%x cpvc: 0x%llx",
>> +		   vcpu->kvm->arch.diag318_info.cpnc,
>> +		   (u64)vcpu->kvm->arch.diag318_info.cpvc);
> 
> We have the event in kvm_s390_set_diag318_info(), do we really need this
> one, too?
> 

The other is a VM_EVENT, which I find more helpful than the VCPU_EVENT
imho. I put this in here for consistency's sake with the rest of the
__diag_* functions, but it certainly isn't needed.

I'd vote to remove the VCPU event.

>> +
>> +	return 0;
>> +}
>> +
>>   int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>>   {
>>   	int code = kvm_s390_get_base_disp_rs(vcpu, NULL) & 0xffff;
>> @@ -254,6 +269,8 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>>   		return __diag_page_ref_service(vcpu);
>>   	case 0x308:
>>   		return __diag_ipl_functions(vcpu);
>> +	case 0x318:
>> +		return __diag_set_diag318_info(vcpu);
>>   	case 0x500:
>>   		return __diag_virtio_hypercall(vcpu);
>>   	default:
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 28ebd64..8be9867 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -157,6 +157,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>>   	{ "instruction_diag_9c", VCPU_STAT(diagnose_9c) },
>>   	{ "instruction_diag_258", VCPU_STAT(diagnose_258) },
>>   	{ "instruction_diag_308", VCPU_STAT(diagnose_308) },
>> +	{ "instruction_diag_318", VCPU_STAT(diagnose_318) },
>>   	{ "instruction_diag_500", VCPU_STAT(diagnose_500) },
>>   	{ "instruction_diag_other", VCPU_STAT(diagnose_other) },
>>   	{ NULL }
>> @@ -1228,6 +1229,68 @@ static int kvm_s390_get_tod(struct kvm *kvm, struct kvm_device_attr *attr)
>>   	return ret;
>>   }
>>   
>> +void kvm_s390_set_diag318_info(struct kvm *kvm, u64 info)
>> +{
>> +	struct kvm_vcpu *vcpu;
>> +	int i;
>> +
>> +	kvm->arch.diag318_info.val = info;
>> +
>> +	VM_EVENT(kvm, 3, "SET: CPNC: 0x%x CPVC: 0x%llx",
>> +		 kvm->arch.diag318_info.cpnc, (u64)kvm->arch.diag318_info.cpvc);
>> +
>> +	if (sclp.has_diag318) {
>> +		kvm_for_each_vcpu(i, vcpu, kvm) {
>> +			vcpu->arch.sie_block->cpnc = kvm->arch.diag318_info.cpnc;
>> +		}
> 
> If two CPUs would be executing this in parallel, we could create an
> inconsistent cpnc value in the HW. Not sure if we care.
> 
> Also, there is a possible race with CPU hotplug, depending on the
> compiler optimizations if I'm not wrong.
> 
> Sure we don't want to protect this by a mutex just to avoid having to
> worry about such stuff?
> 
> I guess, for ordinary guest operations, these races shouldn't matter.
> 

The CPNC is harmless, but if we have the opportunity to protect
ourselves from unwanted behavior, why not take it? I'll put the mutexes
back in for the set operation.

>> +	}
>> +}
>> +
>> +static int kvm_s390_set_misc(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +	int ret;
>> +	u64 diag318_info;
> 
> nit: reorder both
> 

Noted.

>> +
>> +	switch (attr->attr) {
>> +	case KVM_S390_VM_MISC_DIAG318:
>> +		ret = -EFAULT;
>> +		if (get_user(diag318_info, (u64 __user *)attr->addr))
>> +			break;
>> +		kvm_s390_set_diag318_info(kvm, diag318_info);
>> +		ret = 0;
>> +		break;
>> +	default:
>> +		ret = -ENXIO;
>> +		break;
>> +	}
>> +	return ret;
>> +}
>> +
>> +static int kvm_s390_get_diag318_info(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +	if (put_user(kvm->arch.diag318_info.val, (u64 __user *)attr->addr))
>> +		return -EFAULT;
>> +
>> +	VM_EVENT(kvm, 3, "QUERY: CPNC: 0x%x, CPVC: 0x%llx",
>> +		 kvm->arch.diag318_info.cpnc, (u64)kvm->arch.diag318_info.cpvc);
> 
> Sure we need that cast / can't avoid it?
> 

Compiler says we don't need it :)

>> +	return 0;
>> +}
>> +
>> +static int kvm_s390_get_misc(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +	int ret;
>> +
>> +	switch (attr->attr) {
>> +	case KVM_S390_VM_MISC_DIAG318:
>> +		ret = kvm_s390_get_diag318_info(kvm, attr);
>> +		break;
>> +	default:
>> +		ret = -ENXIO;
>> +		break;
>> +	}
>> +	return ret;
>> +}
>> +
>>   static int kvm_s390_set_processor(struct kvm *kvm, struct kvm_device_attr *attr)
>>   {
>>   	struct kvm_s390_vm_cpu_processor *proc;
>> @@ -1674,6 +1737,9 @@ static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>>   	case KVM_S390_VM_MIGRATION:
>>   		ret = kvm_s390_vm_set_migration(kvm, attr);
>>   		break;
>> +	case KVM_S390_VM_MISC:
>> +		ret = kvm_s390_set_misc(kvm, attr);
>> +		break;
>>   	default:
>>   		ret = -ENXIO;
>>   		break;
>> @@ -1699,6 +1765,9 @@ static int kvm_s390_vm_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>>   	case KVM_S390_VM_MIGRATION:
>>   		ret = kvm_s390_vm_get_migration(kvm, attr);
>>   		break;
>> +	case KVM_S390_VM_MISC:
>> +		ret = kvm_s390_get_misc(kvm, attr);
>> +		break;
>>   	default:
>>   		ret = -ENXIO;
>>   		break;
>> @@ -1772,6 +1841,16 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>>   	case KVM_S390_VM_MIGRATION:
>>   		ret = 0;
>>   		break;
>> +	case KVM_S390_VM_MISC:
>> +		switch (attr->attr) {
>> +		case KVM_S390_VM_MISC_DIAG318:
>> +			ret = 0;
>> +			break;
>> +		default:
>> +			ret = -ENXIO;
>> +			break;
>> +		}
>> +		break;
>>   	default:
>>   		ret = -ENXIO;
>>   		break;
>> @@ -2892,6 +2971,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>>   		vcpu->arch.sie_block->ictl |= ICTL_OPEREXC;
>>   	/* make vcpu_load load the right gmap on the first trigger */
>>   	vcpu->arch.enabled_gmap = vcpu->arch.gmap;
>> +	if (sclp.has_diag318)
>> +		vcpu->arch.sie_block->cpnc = vcpu->kvm->arch.diag318_info.cpnc;
>>   }
>>   
>>   static bool kvm_has_pckmo_subfunc(struct kvm *kvm, unsigned long nr)
>> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
>> index 6d9448d..70a21b4 100644
>> --- a/arch/s390/kvm/kvm-s390.h
>> +++ b/arch/s390/kvm/kvm-s390.h
>> @@ -281,6 +281,7 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
>>   int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
>>   
>>   /* implemented in kvm-s390.c */
>> +void kvm_s390_set_diag318_info(struct kvm *kvm, u64 info);
>>   void kvm_s390_set_tod_clock(struct kvm *kvm,
>>   			    const struct kvm_s390_vm_tod_clock *gtod);
>>   long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> index 076090f..50e522e0 100644
>> --- a/arch/s390/kvm/vsie.c
>> +++ b/arch/s390/kvm/vsie.c
>> @@ -548,6 +548,8 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>>   		scb_s->ecd |= scb_o->ecd & ECD_ETOKENF;
>>   
>>   	scb_s->hpid = HPID_VSIE;
>> +	if (sclp.has_diag318)
>> +		scb_s->cpnc = scb_o->cpnc;
>>   
>>   	prepare_ibc(vcpu, vsie_page);
>>   	rc = shadow_crycb(vcpu, vsie_page);
>>
> 
> 

Thanks for the review!

