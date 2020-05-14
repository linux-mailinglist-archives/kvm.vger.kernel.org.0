Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFD91D3930
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 20:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgENSiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 14:38:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52681 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726188AbgENSiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 14:38:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589481488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=yFeZoccsGxpHwAVgbCCDi7AVNqTFr5ki88Ybtz6RKpk=;
        b=MFB75l8+DeK6mSuWFW3M0Xr/JV1gBOX4NyQaX6jq7aanfeCmQ17ZT9nGzggtIbay0/1JGI
        imGQkyNWlfI4zajOUoHo3WnNpjSj4rdeVzfUd52D/Vdl9hC1z+V+BQREIxu6i6lJiPl39d
        xl4FZGD6xPJhoyDzEgvnqSOgSp5YdHQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-ul8CmvAfNfSRRsmSofBlVg-1; Thu, 14 May 2020 14:38:04 -0400
X-MC-Unique: ul8CmvAfNfSRRsmSofBlVg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40BA780058A;
        Thu, 14 May 2020 18:38:03 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-56.ams2.redhat.com [10.36.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 94D7C341E3;
        Thu, 14 May 2020 18:37:57 +0000 (UTC)
Subject: Re: [PATCH v6 2/2] s390/kvm: diagnose 318 handling
To:     Collin Walling <walling@linux.ibm.com>,
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
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <af478798-eced-a279-8425-a1bb23d2bd48@redhat.com>
Date:   Thu, 14 May 2020 20:37:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <2aa0d573-b9d4-8022-9ec5-79f7156d1bcb@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/05/2020 19.20, Collin Walling wrote:
> On 5/14/20 5:53 AM, David Hildenbrand wrote:
>> On 14.05.20 11:49, Janosch Frank wrote:
>>> On 5/14/20 11:37 AM, David Hildenbrand wrote:
>>>> On 14.05.20 10:52, Janosch Frank wrote:
>>>>> On 5/14/20 9:53 AM, Thomas Huth wrote:
>>>>>> On 14/05/2020 00.15, Collin Walling wrote:
>>>>>>> DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
>>>>>>> be intercepted by SIE and handled via KVM. Let's introduce some
>>>>>>> functions to communicate between userspace and KVM via ioctls. These
>>>>>>> will be used to get/set the diag318 related information, as well as
>>>>>>> check the system if KVM supports handling this instruction.
>>>>>>>
>>>>>>> This information can help with diagnosing the environment the VM is
>>>>>>> running in (Linux, z/VM, etc) if the OS calls this instruction.
>>>>>>>
>>>>>>> By default, this feature is disabled and can only be enabled if a
>>>>>>> user space program (such as QEMU) explicitly requests it.
>>>>>>>
>>>>>>> The Control Program Name Code (CPNC) is stored in the SIE block
>>>>>>> and a copy is retained in each VCPU. The Control Program Version
>>>>>>> Code (CPVC) is not designed to be stored in the SIE block, so we
>>>>>>> retain a copy in each VCPU next to the CPNC.
>>>>>>>
>>>>>>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>>>>>>> ---
>>>>>>>  Documentation/virt/kvm/devices/vm.rst | 29 +++++++++
>>>>>>>  arch/s390/include/asm/kvm_host.h      |  6 +-
>>>>>>>  arch/s390/include/uapi/asm/kvm.h      |  5 ++
>>>>>>>  arch/s390/kvm/diag.c                  | 20 ++++++
>>>>>>>  arch/s390/kvm/kvm-s390.c              | 89 +++++++++++++++++++++++++++
>>>>>>>  arch/s390/kvm/kvm-s390.h              |  1 +
>>>>>>>  arch/s390/kvm/vsie.c                  |  2 +
>>>>>>>  7 files changed, 151 insertions(+), 1 deletion(-)
>>>>>> [...]
>>>>>>> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
>>>>>>> index 563429dece03..3caed4b880c8 100644
>>>>>>> --- a/arch/s390/kvm/diag.c
>>>>>>> +++ b/arch/s390/kvm/diag.c
>>>>>>> @@ -253,6 +253,24 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
>>>>>>>  	return ret < 0 ? ret : 0;
>>>>>>>  }
>>>>>>>  
>>>>>>> +static int __diag_set_diag318_info(struct kvm_vcpu *vcpu)
>>>>>>> +{
>>>>>>> +	unsigned int reg = (vcpu->arch.sie_block->ipa & 0xf0) >> 4;
>>>>>>> +	u64 info = vcpu->run->s.regs.gprs[reg];
>>>>>>> +
>>>>>>> +	if (!vcpu->kvm->arch.use_diag318)
>>>>>>> +		return -EOPNOTSUPP;
>>>>>>> +
>>>>>>> +	vcpu->stat.diagnose_318++;
>>>>>>> +	kvm_s390_set_diag318_info(vcpu->kvm, info);
>>>>>>> +
>>>>>>> +	VCPU_EVENT(vcpu, 3, "diag 0x318 cpnc: 0x%x cpvc: 0x%llx",
>>>>>>> +		   vcpu->kvm->arch.diag318_info.cpnc,
>>>>>>> +		   (u64)vcpu->kvm->arch.diag318_info.cpvc);
> 
> Errr.. thought I dropped this message. We favored just using the
> VM_EVENT from last time.
> 
>>>>>>> +
>>>>>>> +	return 0;
>>>>>>> +}
>>>>>>> +
>>>>>>>  int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>>>>>>>  {
>>>>>>>  	int code = kvm_s390_get_base_disp_rs(vcpu, NULL) & 0xffff;
>>>>>>> @@ -272,6 +290,8 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>>>>>>>  		return __diag_page_ref_service(vcpu);
>>>>>>>  	case 0x308:
>>>>>>>  		return __diag_ipl_functions(vcpu);
>>>>>>> +	case 0x318:
>>>>>>> +		return __diag_set_diag318_info(vcpu);
>>>>>>>  	case 0x500:
>>>>>>>  		return __diag_virtio_hypercall(vcpu);
>>>>>>
>>>>>> I wonder whether it would make more sense to simply drop to userspace
>>>>>> and handle the diag 318 call there? That way the userspace would always
>>>>>> be up-to-date, and as we've seen in the past (e.g. with the various SIGP
>>>>>> handling), it's better if the userspace is in control... e.g. userspace
>>>>>> could also decide to only use KVM_S390_VM_MISC_ENABLE_DIAG318 if the
>>>>>> guest just executed the diag 318 instruction.
>>>>>>
>>>>>> And you need the kvm_s390_vm_get/set_misc functions anyway, so these
>>>>>> could also be simply used by the diag 318 handler in userspace?
> 
> Pardon my ignorance, but I do not think I fully understand what exactly
> should be dropped in favor of doing things in userspace.
> 
> My assumption: if a diag handler is not found in KVM, then we
> fallthrough to userspace handling?

Right, if you simply omit this change to diag.c, the default case
returns -EOPNOTSUPP which then should cause an exit to userspace. You
can then add the code in QEMU to handle_diag() in target/s390x/kvm.c
instead.

 Thomas

