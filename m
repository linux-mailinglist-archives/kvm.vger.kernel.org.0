Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC62613692A
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 09:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgAJItl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 03:49:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33174 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727156AbgAJItl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 03:49:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578646179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=RtzxVuBVMD4E1065H5hqBgApEqUzix/HKFco2L9ah6o=;
        b=Jx1hG95Ny6apbv+g+cRvwVyCgZOvZVmoDX6g0Avbtrs+lzdQH3ePD8cjdLItaCaS2Cz+zK
        /OmCzCfXdlH06V55Vz7NmMe+axDOBtLztoX2lTclb3t/bhNMzyDrWiAiw++DwfX5tA6Z7w
        6YRAuHqpczHRpV8QOvE3ImYABOPCnmE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-bDqvPKupMAyZFs9TmcchRQ-1; Fri, 10 Jan 2020 03:49:36 -0500
X-MC-Unique: bDqvPKupMAyZFs9TmcchRQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E6A418B9FEB;
        Fri, 10 Jan 2020 08:49:35 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-154.ams2.redhat.com [10.36.116.154])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D5B1F5DA60;
        Fri, 10 Jan 2020 08:49:31 +0000 (UTC)
Subject: Re: [PATCH v4] KVM: s390: Add new reset vcpu API
To:     Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
References: <20200109155602.18985-1-frankja@linux.ibm.com>
 <20200109180841.6843cb92.cohuck@redhat.com>
 <f79b523e-f3e8-95b8-c242-1e7ca0083012@linux.ibm.com>
 <f18955c0-4002-c494-b14e-1b9733aad20e@redhat.com>
 <c0049bfb-9516-a382-c69c-0693cb0fbfda@linux.ibm.com>
 <90f65536-c2bb-9234-aef4-7941d477369e@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ed25755c-0c5c-039b-7ab5-89a714729357@redhat.com>
Date:   Fri, 10 Jan 2020 09:49:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <90f65536-c2bb-9234-aef4-7941d477369e@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/01/2020 09.43, Janosch Frank wrote:
> On 1/10/20 8:14 AM, Janosch Frank wrote:
>> On 1/10/20 8:03 AM, Thomas Huth wrote:
>>> On 09/01/2020 18.51, Janosch Frank wrote:
>>>> On 1/9/20 6:08 PM, Cornelia Huck wrote:
>>>>> On Thu,  9 Jan 2020 10:56:01 -0500
>>>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>>>
>>>>>> The architecture states that we need to reset local IRQs for all CPU
>>>>>> resets. Because the old reset interface did not support the normal CPU
>>>>>> reset we never did that on a normal reset.
>>>>>>
>>>>>> Let's implement an interface for the missing normal and clear resets
>>>>>> and reset all local IRQs, registers and control structures as stated
>>>>>> in the architecture.
>>>>>>
>>>>>> Userspace might already reset the registers via the vcpu run struct,
>>>>>> but as we need the interface for the interrupt clearing part anyway,
>>>>>> we implement the resets fully and don't rely on userspace to reset the
>>>>>> rest.
>>>>>>
>>>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>>>> ---
>>>>>>
>>>>>> I dropped the reviews, as I changed quite a lot.  
>>>>>>
>>>>>> Keep in mind, that now we'll need a new parameter in normal and
>>>>>> initial reset for protected virtualization to indicate that we need to
>>>>>> do the reset via the UV call. The Ultravisor does only accept the
>>>>>> needed reset, not any subset resets.
>>>>>
>>>>> In the interface, or externally?
>>>>
>>>> ?
>>>>
>>>>>
>>>>> [Apologies, but the details of the protected virt stuff are no longer
>>>>> in my cache.
>>>> Reworded explanation:
>>>> I can't use a fallthrough, because the UV will reject the normal reset
>>>> if we do an initial reset (same goes for the clear reset). To address
>>>> this issue, I added a boolean to the normal and initial reset functions
>>>> which tells the function if it was called directly or was called because
>>>> of the fallthrough.
>>>>
>>>> Only if called directly a UV call for the reset is done, that way we can
>>>> keep the fallthrough.
>>>
>>> Sounds complicated. And do we need the fallthrough stuff here at all?
>>> What about doing something like:
>>
>> That would work and I thought about it, it just comes down to taste :-)
>> I don't have any strong feelings for a specific implementation.
> 
> To be more specific:
> 
> 
> Commit c72db49c098bceb8b73c2e9d305caf37a41fb3bf
> Author: Janosch Frank <frankja@linux.ibm.com>
> Date:   Thu Jan 9 04:37:50 2020 -0500
> 
>     KVM: s390: protvirt: Add UV cpu reset calls
> 
>     For protected VMs, the VCPU resets are done by the Ultravisor, as KVM
>     has no access to the VCPU registers.
> 
>     As the Ultravisor will only accept a call for the reset that is
>     needed, we need to fence the UV calls when chaining resets.
> 
>     Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 63dc2bd97582..d5876527e464 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3476,8 +3476,11 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(struct
> kvm_vcpu *vcpu,
>  	return r;
>  }
> 
> -static int kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
> +static int kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu, bool
> chain)
>  {
> +	int rc = 0;
> +	u32 ret;
> +
>  	vcpu->arch.sie_block->gpsw.mask = ~PSW_MASK_RI;
>  	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
>  	memset(vcpu->run->s.regs.riccb, 0, sizeof(vcpu->run->s.regs.riccb));
> @@ -3487,11 +3490,21 @@ static int
> kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
>  		kvm_s390_vcpu_stop(vcpu);
>  	kvm_s390_clear_local_irqs(vcpu);
> 
> -	return 0;
> +	if (kvm_s390_pv_handle_cpu(vcpu) && !chain) {
> +		rc = uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
> +				   UVC_CMD_CPU_RESET, &ret);
> +		VCPU_EVENT(vcpu, 3, "PROTVIRT RESET NORMAL VCPU: cpu %d rc %x rrc %x",
> +			   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
> +	}
> +
> +	return rc;
>  }
[...]
> @@ -4738,12 +4767,16 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> 
>  	case KVM_S390_CLEAR_RESET:
>  		r = kvm_arch_vcpu_ioctl_clear_reset(vcpu);
> +		if (r)
> +			break;
>  		/* fallthrough */
>  	case KVM_S390_INITIAL_RESET:
> -		r = kvm_arch_vcpu_ioctl_initial_reset(vcpu);
> +		r = kvm_arch_vcpu_ioctl_initial_reset(vcpu, ioctl !=
> KVM_S390_INITIAL_RESET);
> +		if (r)
> +			break;
>  		/* fallthrough */
>  	case KVM_S390_NORMAL_RESET:
> -		r = kvm_arch_vcpu_ioctl_normal_reset(vcpu);
> +		r = kvm_arch_vcpu_ioctl_normal_reset(vcpu, ioctl !=
> KVM_S390_NORMAL_RESET);
>  		break;
>  	case KVM_SET_ONE_REG:
>  	case KVM_GET_ONE_REG: {
> 

As you said, it's mostly a matter of taste, but at least in my eyes this
approach with fallthroughs and the additional parameter looks rather
harder to understand compared to what I've suggested.

 Thomas

