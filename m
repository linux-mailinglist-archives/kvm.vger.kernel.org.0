Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30191D3C7E
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 21:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgENTHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 15:07:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728731AbgENSxc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 14:53:32 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04EIXcDZ133186;
        Thu, 14 May 2020 14:53:31 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3111w8vvsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 14:53:31 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04EIZueU139468;
        Thu, 14 May 2020 14:53:30 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3111w8vvs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 14:53:30 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04EIrMsH024953;
        Thu, 14 May 2020 18:53:29 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 3100ucd2jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 18:53:29 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04EIrPNU9961918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 18:53:25 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD769C6055;
        Thu, 14 May 2020 18:53:25 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3278CC6057;
        Thu, 14 May 2020 18:53:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.130.116])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 14 May 2020 18:53:25 +0000 (GMT)
Subject: Re: [PATCH v6 2/2] s390/kvm: diagnose 318 handling
To:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
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
 <2aa0d573-b9d4-8022-9ec5-79f7156d1bcb@linux.ibm.com>
 <af478798-eced-a279-8425-a1bb23d2bd48@redhat.com>
From:   Collin Walling <walling@linux.ibm.com>
Message-ID: <f3428cd4-d9af-cc99-ff31-4b3f3deee3d2@linux.ibm.com>
Date:   Thu, 14 May 2020 14:53:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <af478798-eced-a279-8425-a1bb23d2bd48@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_06:2020-05-14,2020-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 cotscore=-2147483648 clxscore=1015 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140160
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/14/20 2:37 PM, Thomas Huth wrote:
> On 14/05/2020 19.20, Collin Walling wrote:
>> On 5/14/20 5:53 AM, David Hildenbrand wrote:
>>> On 14.05.20 11:49, Janosch Frank wrote:
>>>> On 5/14/20 11:37 AM, David Hildenbrand wrote:
>>>>> On 14.05.20 10:52, Janosch Frank wrote:
>>>>>> On 5/14/20 9:53 AM, Thomas Huth wrote:
>>>>>>> On 14/05/2020 00.15, Collin Walling wrote:
>>>>>>>> DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
>>>>>>>> be intercepted by SIE and handled via KVM. Let's introduce some
>>>>>>>> functions to communicate between userspace and KVM via ioctls. These
>>>>>>>> will be used to get/set the diag318 related information, as well as
>>>>>>>> check the system if KVM supports handling this instruction.
>>>>>>>>
>>>>>>>> This information can help with diagnosing the environment the VM is
>>>>>>>> running in (Linux, z/VM, etc) if the OS calls this instruction.
>>>>>>>>
>>>>>>>> By default, this feature is disabled and can only be enabled if a
>>>>>>>> user space program (such as QEMU) explicitly requests it.
>>>>>>>>
>>>>>>>> The Control Program Name Code (CPNC) is stored in the SIE block
>>>>>>>> and a copy is retained in each VCPU. The Control Program Version
>>>>>>>> Code (CPVC) is not designed to be stored in the SIE block, so we
>>>>>>>> retain a copy in each VCPU next to the CPNC.
>>>>>>>>
>>>>>>>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>>>>>>>> ---
>>>>>>>>  Documentation/virt/kvm/devices/vm.rst | 29 +++++++++
>>>>>>>>  arch/s390/include/asm/kvm_host.h      |  6 +-
>>>>>>>>  arch/s390/include/uapi/asm/kvm.h      |  5 ++
>>>>>>>>  arch/s390/kvm/diag.c                  | 20 ++++++
>>>>>>>>  arch/s390/kvm/kvm-s390.c              | 89 +++++++++++++++++++++++++++
>>>>>>>>  arch/s390/kvm/kvm-s390.h              |  1 +
>>>>>>>>  arch/s390/kvm/vsie.c                  |  2 +
>>>>>>>>  7 files changed, 151 insertions(+), 1 deletion(-)
>>>>>>> [...]
>>>>>>>> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
>>>>>>>> index 563429dece03..3caed4b880c8 100644
>>>>>>>> --- a/arch/s390/kvm/diag.c
>>>>>>>> +++ b/arch/s390/kvm/diag.c
>>>>>>>> @@ -253,6 +253,24 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
>>>>>>>>  	return ret < 0 ? ret : 0;
>>>>>>>>  }
>>>>>>>>  
>>>>>>>> +static int __diag_set_diag318_info(struct kvm_vcpu *vcpu)
>>>>>>>> +{
>>>>>>>> +	unsigned int reg = (vcpu->arch.sie_block->ipa & 0xf0) >> 4;
>>>>>>>> +	u64 info = vcpu->run->s.regs.gprs[reg];
>>>>>>>> +
>>>>>>>> +	if (!vcpu->kvm->arch.use_diag318)
>>>>>>>> +		return -EOPNOTSUPP;
>>>>>>>> +
>>>>>>>> +	vcpu->stat.diagnose_318++;
>>>>>>>> +	kvm_s390_set_diag318_info(vcpu->kvm, info);
>>>>>>>> +
>>>>>>>> +	VCPU_EVENT(vcpu, 3, "diag 0x318 cpnc: 0x%x cpvc: 0x%llx",
>>>>>>>> +		   vcpu->kvm->arch.diag318_info.cpnc,
>>>>>>>> +		   (u64)vcpu->kvm->arch.diag318_info.cpvc);
>>
>> Errr.. thought I dropped this message. We favored just using the
>> VM_EVENT from last time.
>>
>>>>>>>> +
>>>>>>>> +	return 0;
>>>>>>>> +}
>>>>>>>> +
>>>>>>>>  int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>>>>>>>>  {
>>>>>>>>  	int code = kvm_s390_get_base_disp_rs(vcpu, NULL) & 0xffff;
>>>>>>>> @@ -272,6 +290,8 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>>>>>>>>  		return __diag_page_ref_service(vcpu);
>>>>>>>>  	case 0x308:
>>>>>>>>  		return __diag_ipl_functions(vcpu);
>>>>>>>> +	case 0x318:
>>>>>>>> +		return __diag_set_diag318_info(vcpu);
>>>>>>>>  	case 0x500:
>>>>>>>>  		return __diag_virtio_hypercall(vcpu);
>>>>>>>
>>>>>>> I wonder whether it would make more sense to simply drop to userspace
>>>>>>> and handle the diag 318 call there? That way the userspace would always
>>>>>>> be up-to-date, and as we've seen in the past (e.g. with the various SIGP
>>>>>>> handling), it's better if the userspace is in control... e.g. userspace
>>>>>>> could also decide to only use KVM_S390_VM_MISC_ENABLE_DIAG318 if the
>>>>>>> guest just executed the diag 318 instruction.
>>>>>>>
>>>>>>> And you need the kvm_s390_vm_get/set_misc functions anyway, so these
>>>>>>> could also be simply used by the diag 318 handler in userspace?
>>
>> Pardon my ignorance, but I do not think I fully understand what exactly
>> should be dropped in favor of doing things in userspace.
>>
>> My assumption: if a diag handler is not found in KVM, then we
>> fallthrough to userspace handling?
> 
> Right, if you simply omit this change to diag.c, the default case
> returns -EOPNOTSUPP which then should cause an exit to userspace. You
> can then add the code in QEMU to handle_diag() in target/s390x/kvm.c
> instead.
> 
>  Thomas
> 

Very cool! Okay, I think this makes sense, then. I'll look into this.
Thanks for the tip.

@Conny, I assume this is what you meant as well? If so, ignore my
response I sent earlier :)

-- 
--
Regards,
Collin

Stay safe and stay healthy
