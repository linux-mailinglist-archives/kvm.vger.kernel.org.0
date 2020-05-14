Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0021D37E7
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 19:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgENRVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 13:21:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48306 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbgENRVD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 13:21:03 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04EH2Pmn066830;
        Thu, 14 May 2020 13:21:03 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3111w8tcrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 13:21:02 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04EH3VRI072520;
        Thu, 14 May 2020 13:21:02 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3111w8tcre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 13:21:02 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04EHCmOS018153;
        Thu, 14 May 2020 17:21:01 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 3100uccdu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 17:21:01 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04EHKvhx60162510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 17:20:57 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65782C605F;
        Thu, 14 May 2020 17:20:57 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 851A7C6057;
        Thu, 14 May 2020 17:20:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.130.116])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 14 May 2020 17:20:56 +0000 (GMT)
Subject: Re: [PATCH v6 2/2] s390/kvm: diagnose 318 handling
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com
References: <20200513221557.14366-1-walling@linux.ibm.com>
 <20200513221557.14366-3-walling@linux.ibm.com>
 <d4320d09-7b3a-ac13-77be-02397f4ccc83@redhat.com>
 <de4e4416-5158-b60f-e2a8-fb6d3d48d516@linux.ibm.com>
 <88d27a61-b55b-ee68-f7f9-85ce7fcefd64@redhat.com>
 <e7691d9a-a446-17db-320e-a2348e0eb057@linux.ibm.com>
 <516405b3-67c4-aa12-1fa5-772e401e4403@redhat.com>
From:   Collin Walling <walling@linux.ibm.com>
Message-ID: <2aa0d573-b9d4-8022-9ec5-79f7156d1bcb@linux.ibm.com>
Date:   Thu, 14 May 2020 13:20:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <516405b3-67c4-aa12-1fa5-772e401e4403@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_05:2020-05-14,2020-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 cotscore=-2147483648 clxscore=1015 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/14/20 5:53 AM, David Hildenbrand wrote:
> On 14.05.20 11:49, Janosch Frank wrote:
>> On 5/14/20 11:37 AM, David Hildenbrand wrote:
>>> On 14.05.20 10:52, Janosch Frank wrote:
>>>> On 5/14/20 9:53 AM, Thomas Huth wrote:
>>>>> On 14/05/2020 00.15, Collin Walling wrote:
>>>>>> DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
>>>>>> be intercepted by SIE and handled via KVM. Let's introduce some
>>>>>> functions to communicate between userspace and KVM via ioctls. These
>>>>>> will be used to get/set the diag318 related information, as well as
>>>>>> check the system if KVM supports handling this instruction.
>>>>>>
>>>>>> This information can help with diagnosing the environment the VM is
>>>>>> running in (Linux, z/VM, etc) if the OS calls this instruction.
>>>>>>
>>>>>> By default, this feature is disabled and can only be enabled if a
>>>>>> user space program (such as QEMU) explicitly requests it.
>>>>>>
>>>>>> The Control Program Name Code (CPNC) is stored in the SIE block
>>>>>> and a copy is retained in each VCPU. The Control Program Version
>>>>>> Code (CPVC) is not designed to be stored in the SIE block, so we
>>>>>> retain a copy in each VCPU next to the CPNC.
>>>>>>
>>>>>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>>>>>> ---
>>>>>>  Documentation/virt/kvm/devices/vm.rst | 29 +++++++++
>>>>>>  arch/s390/include/asm/kvm_host.h      |  6 +-
>>>>>>  arch/s390/include/uapi/asm/kvm.h      |  5 ++
>>>>>>  arch/s390/kvm/diag.c                  | 20 ++++++
>>>>>>  arch/s390/kvm/kvm-s390.c              | 89 +++++++++++++++++++++++++++
>>>>>>  arch/s390/kvm/kvm-s390.h              |  1 +
>>>>>>  arch/s390/kvm/vsie.c                  |  2 +
>>>>>>  7 files changed, 151 insertions(+), 1 deletion(-)
>>>>> [...]
>>>>>> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
>>>>>> index 563429dece03..3caed4b880c8 100644
>>>>>> --- a/arch/s390/kvm/diag.c
>>>>>> +++ b/arch/s390/kvm/diag.c
>>>>>> @@ -253,6 +253,24 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
>>>>>>  	return ret < 0 ? ret : 0;
>>>>>>  }
>>>>>>  
>>>>>> +static int __diag_set_diag318_info(struct kvm_vcpu *vcpu)
>>>>>> +{
>>>>>> +	unsigned int reg = (vcpu->arch.sie_block->ipa & 0xf0) >> 4;
>>>>>> +	u64 info = vcpu->run->s.regs.gprs[reg];
>>>>>> +
>>>>>> +	if (!vcpu->kvm->arch.use_diag318)
>>>>>> +		return -EOPNOTSUPP;
>>>>>> +
>>>>>> +	vcpu->stat.diagnose_318++;
>>>>>> +	kvm_s390_set_diag318_info(vcpu->kvm, info);
>>>>>> +
>>>>>> +	VCPU_EVENT(vcpu, 3, "diag 0x318 cpnc: 0x%x cpvc: 0x%llx",
>>>>>> +		   vcpu->kvm->arch.diag318_info.cpnc,
>>>>>> +		   (u64)vcpu->kvm->arch.diag318_info.cpvc);

Errr.. thought I dropped this message. We favored just using the
VM_EVENT from last time.

>>>>>> +
>>>>>> +	return 0;
>>>>>> +}
>>>>>> +
>>>>>>  int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>>>>>>  {
>>>>>>  	int code = kvm_s390_get_base_disp_rs(vcpu, NULL) & 0xffff;
>>>>>> @@ -272,6 +290,8 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>>>>>>  		return __diag_page_ref_service(vcpu);
>>>>>>  	case 0x308:
>>>>>>  		return __diag_ipl_functions(vcpu);
>>>>>> +	case 0x318:
>>>>>> +		return __diag_set_diag318_info(vcpu);
>>>>>>  	case 0x500:
>>>>>>  		return __diag_virtio_hypercall(vcpu);
>>>>>
>>>>> I wonder whether it would make more sense to simply drop to userspace
>>>>> and handle the diag 318 call there? That way the userspace would always
>>>>> be up-to-date, and as we've seen in the past (e.g. with the various SIGP
>>>>> handling), it's better if the userspace is in control... e.g. userspace
>>>>> could also decide to only use KVM_S390_VM_MISC_ENABLE_DIAG318 if the
>>>>> guest just executed the diag 318 instruction.
>>>>>
>>>>> And you need the kvm_s390_vm_get/set_misc functions anyway, so these
>>>>> could also be simply used by the diag 318 handler in userspace?

Pardon my ignorance, but I do not think I fully understand what exactly
should be dropped in favor of doing things in userspace.

My assumption: if a diag handler is not found in KVM, then we
fallthrough to userspace handling?

>>>>>
>>>>>>  	default:
>>>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>>>> index d05bb040fd42..c3eee468815f 100644
>>>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>>>> @@ -159,6 +159,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>>>>>>  	{ "diag_9c_ignored", VCPU_STAT(diagnose_9c_ignored) },
>>>>>>  	{ "instruction_diag_258", VCPU_STAT(diagnose_258) },
>>>>>>  	{ "instruction_diag_308", VCPU_STAT(diagnose_308) },
>>>>>> +	{ "instruction_diag_318", VCPU_STAT(diagnose_318) },
>>>>>>  	{ "instruction_diag_500", VCPU_STAT(diagnose_500) },
>>>>>>  	{ "instruction_diag_other", VCPU_STAT(diagnose_other) },
>>>>>>  	{ NULL }
>>>>>> @@ -1243,6 +1244,76 @@ static int kvm_s390_get_tod(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>>>  	return ret;
>>>>>>  }
>>>>>>  
>>>>>> +void kvm_s390_set_diag318_info(struct kvm *kvm, u64 info)
>>>>>> +{
>>>>>> +	struct kvm_vcpu *vcpu;
>>>>>> +	int i;
>>>>>> +
>>>>>> +	kvm->arch.diag318_info.val = info;
>>>>>> +
>>>>>> +	VM_EVENT(kvm, 3, "SET: CPNC: 0x%x CPVC: 0x%llx",
>>>>>> +		 kvm->arch.diag318_info.cpnc, kvm->arch.diag318_info.cpvc);
>>>>>> +
>>>>>> +	if (sclp.has_diag318) {
>>>>>> +		kvm_for_each_vcpu(i, vcpu, kvm) {
>>>>>> +			vcpu->arch.sie_block->cpnc = kvm->arch.diag318_info.cpnc;
>>>>>> +		}
>>>>>> +	}
>>>>>> +}
>>>>>> +
>>>>>> +static int kvm_s390_vm_set_misc(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>>> +{
>>>>>> +	int ret;
>>>>>> +	u64 diag318_info;
>>>>>> +
>>>>>> +	switch (attr->attr) {
>>>>>> +	case KVM_S390_VM_MISC_ENABLE_DIAG318:
>>>>>> +		kvm->arch.use_diag318 = 1;
>>>>>> +		ret = 0;
>>>>>> +		break;
>>>>>
>>>>> Would it make sense to set kvm->arch.use_diag318 = 1 during the first
>>>>> execution of KVM_S390_VM_MISC_DIAG318 instead, so that we could get
>>>>> along without the KVM_S390_VM_MISC_ENABLE_DIAG318 ?
>>>>

Hmmm... is your thought set the flag in the diag handler in KVM? That
way the get/set functions are only enabled if the instruction was
actually called? I like that, actually. I think that makes more sense.

>>>> I'm not an expert in feature negotiation, but why isn't this a cpu
>>>> feature like sief2 instead of a attribute?
>>>>
>>>> @David?
>>>
>>> In the end you want to have it somehow in the CPU model I guess. You
>>> cannot glue it to QEMU machines, because availability depends on HW+KVM
>>> support.
>>>
>>> How does the guest detect that it can use diag318? I assume/hope via a a
>>> STFLE feature.
>>>
>> SCLP
> 
> Okay, so just another feature flag, which implies it belongs into the
> CPU model. How we communicate support from kvm to QEMU can be done via
> features, bot also via attributes. Important part is that we can
> sense/enable/disable.
> 
> 

Right. KVM for instruction handling and for get/setting (setting also
handles setting the name code in the SIE block), and QEMU for migration
/ resetting.

There are a lot of moving parts for a simple 8-byte string of data, but
its very useful for giving us more information regarding the OS during
firmware / service events.

-- 
--
Regards,
Collin

Stay safe and stay healthy
