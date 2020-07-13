Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C8B21CD82
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 05:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgGMDH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jul 2020 23:07:29 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:35605 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbgGMDH3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 12 Jul 2020 23:07:29 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01355;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0U2UhFSb_1594609639;
Received: from 30.25.206.74(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0U2UhFSb_1594609639)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 13 Jul 2020 11:07:21 +0800
Subject: Re: [PATCH v4 5/7] KVM: PPC: clean up redundant kvm_run parameters in
 assembly
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     pbonzini@redhat.com, tsbogend@alpha.franken.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
        chenhuacai@gmail.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <20200427043514.16144-6-tianjia.zhang@linux.alibaba.com>
 <20200526055924.GD282305@thinks.paulus.ozlabs.org>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <c3540a4b-a568-3428-0427-ae2a1f30dbe2@linux.alibaba.com>
Date:   Mon, 13 Jul 2020 11:07:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200526055924.GD282305@thinks.paulus.ozlabs.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/5/26 13:59, Paul Mackerras wrote:
> On Mon, Apr 27, 2020 at 12:35:12PM +0800, Tianjia Zhang wrote:
>> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
>> structure. For historical reasons, many kvm-related function parameters
>> retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
>> patch does a unified cleanup of these remaining redundant parameters.
> 
> Some of these changes don't look completely correct to me, see below.
> If you're expecting these patches to go through my tree, I can fix up
> the patch and commit it (with you as author), noting the changes I
> made in the commit message.  Do you want me to do that?
> 

I am very glad for you to do so, although I have submitted a new version 
of patch, I still prefer you to fix up and commit it.

Thanks and best,
Tianjia

>> diff --git a/arch/powerpc/kvm/book3s_interrupts.S b/arch/powerpc/kvm/book3s_interrupts.S
>> index f7ad99d972ce..0eff749d8027 100644
>> --- a/arch/powerpc/kvm/book3s_interrupts.S
>> +++ b/arch/powerpc/kvm/book3s_interrupts.S
>> @@ -55,8 +55,7 @@
>>    ****************************************************************************/
>>   
>>   /* Registers:
>> - *  r3: kvm_run pointer
>> - *  r4: vcpu pointer
>> + *  r3: vcpu pointer
>>    */
>>   _GLOBAL(__kvmppc_vcpu_run)
>>   
>> @@ -68,8 +67,8 @@ kvm_start_entry:
>>   	/* Save host state to the stack */
>>   	PPC_STLU r1, -SWITCH_FRAME_SIZE(r1)
>>   
>> -	/* Save r3 (kvm_run) and r4 (vcpu) */
>> -	SAVE_2GPRS(3, r1)
>> +	/* Save r3 (vcpu) */
>> +	SAVE_GPR(3, r1)
>>   
>>   	/* Save non-volatile registers (r14 - r31) */
>>   	SAVE_NVGPRS(r1)
>> @@ -82,11 +81,11 @@ kvm_start_entry:
>>   	PPC_STL	r0, _LINK(r1)
>>   
>>   	/* Load non-volatile guest state from the vcpu */
>> -	VCPU_LOAD_NVGPRS(r4)
>> +	VCPU_LOAD_NVGPRS(r3)
>>   
>>   kvm_start_lightweight:
>>   	/* Copy registers into shadow vcpu so we can access them in real mode */
>> -	mr	r3, r4
>> +	mr	r4, r3
> 
> This mr doesn't seem necessary.
> 
>>   	bl	FUNC(kvmppc_copy_to_svcpu)
>>   	nop
>>   	REST_GPR(4, r1)
> 
> This should be loading r4 from GPR3(r1), not GPR4(r1) - which is what
> REST_GPR(4, r1) will do.
> 
> Then, in the file but not in the patch context, there is this line:
> 
> 	PPC_LL	r3, GPR4(r1)		/* vcpu pointer */
> 
> where once again GPR4 needs to be GPR3.
> 
>> @@ -191,10 +190,10 @@ after_sprg3_load:
>>   	PPC_STL	r31, VCPU_GPR(R31)(r7)
>>   
>>   	/* Pass the exit number as 3rd argument to kvmppc_handle_exit */
> 
> The comment should be modified to say "2nd" instead of "3rd",
> otherwise it is confusing.
> 
> The rest of the patch looks OK.
> 
> Paul.
> 
