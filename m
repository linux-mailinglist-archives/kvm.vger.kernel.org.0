Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE4734A158
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 07:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhCZGBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 02:01:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22686 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230051AbhCZGBH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 02:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616738466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/U9zAzwwoNMAg4tLXema5e6Vkp/Mqb99ZdM6uDfZAno=;
        b=X/1m6Ml8XB2wIk47YphYqoKLw8B2Zu4DhZBXgQbONpIC3thzwO7qcbl+TFnWqJSu6WP/x3
        qtgTona/zNcfkvSutUCkUu0NVpoZ1mzacff+mf41zcp0c+usmZywWUL/YmVyKriE6ipNxV
        UYKRsp1llbQCrCNLcI8QsmV3AvBu198=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-H_Ojx0aZORy44Wd4sclk4g-1; Fri, 26 Mar 2021 02:01:03 -0400
X-MC-Unique: H_Ojx0aZORy44Wd4sclk4g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 152A7881276;
        Fri, 26 Mar 2021 06:01:02 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-10.pek2.redhat.com [10.72.13.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 965F6891BD;
        Fri, 26 Mar 2021 06:00:51 +0000 (UTC)
Subject: Re: [RFC v3 2/5] KVM: x86: add support for ioregionfd signal handling
To:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com, mst@redhat.com,
        cohuck@redhat.com, john.levon@nutanix.com
References: <cover.1613828726.git.eafanasova@gmail.com>
 <575df1656277c55f26e660b7274a7c570b448636.1613828727.git.eafanasova@gmail.com>
 <e276b54a-b2c0-c12e-fdae-22f54824ee6f@redhat.com>
 <c8c374b5490ee2df19375e1a0a86aa9749deb319.camel@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7cc1cd90-cbd4-c47e-f5f5-c9adb2ba2d30@redhat.com>
Date:   Fri, 26 Mar 2021 14:00:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <c8c374b5490ee2df19375e1a0a86aa9749deb319.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/3/17 下午10:19, Elena Afanasova 写道:
> On Tue, 2021-03-09 at 13:51 +0800, Jason Wang wrote:
>> On 2021/2/21 8:04 下午, Elena Afanasova wrote:
>>> The vCPU thread may receive a signal during ioregionfd
>>> communication,
>>> ioctl(KVM_RUN) needs to return to userspace and then ioctl(KVM_RUN)
>>> must resume ioregionfd.
>> After a glance at the patch, I wonder can we split the patch into
>> two?
>>
>> 1) sleepable iodevice which is not supported currently, probably with
>> a
>> new cap?
>> 2) ioregionfd specific codes (I wonder if it has any)
>>
>> Then the sleepable iodevice could be reused by future features.
>>
> Do you have an idea of another possible use cases?


I don't but iodevice is a genreal infrastrucutre, having a dedicated 
patch for that helps lot e.g for reviewing.


> Could you please
> describe your idea in more details?


So it's something like:

patch 1: to introduce the sleepable iodevce infrastructure
patch 2: add ioregionfd on top


>
>>> Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
>>> ---
>>> v3:
>>>    - add FAST_MMIO bus support
>>>    - move ioregion_interrupted flag to ioregion_ctx
>>>    - reorder ioregion_ctx fields
>>>    - rework complete_ioregion operations
>>>    - add signal handling support for crossing a page boundary case
>>>    - fix kvm_arch_vcpu_ioctl_run() should return -EINTR in case
>>> ioregionfd
>>>      is interrupted
>>>
>>>    arch/x86/kvm/vmx/vmx.c   |  40 +++++-
>>>    arch/x86/kvm/x86.c       | 272
>>> +++++++++++++++++++++++++++++++++++++--
>>>    include/linux/kvm_host.h |  10 ++
>>>    virt/kvm/kvm_main.c      |  16 ++-
>>>    4 files changed, 317 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index 47b8357b9751..39db31afd27e 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -5357,19 +5357,51 @@ static int handle_ept_violation(struct
>>> kvm_vcpu *vcpu)
>>>    	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
>>>    }
>>>    
>>> +#ifdef CONFIG_KVM_IOREGION
>>> +static int complete_ioregion_fast_mmio(struct kvm_vcpu *vcpu)
>>> +{
>>> +	int ret, idx;
>>> +
>>> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
>>> +	ret = kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS,
>>> +			       vcpu->ioregion_ctx.addr, 0, NULL);
>>> +	if (ret) {
>>> +		ret = kvm_mmu_page_fault(vcpu, vcpu->ioregion_ctx.addr,
>>> +					 PFERR_RSVD_MASK, NULL, 0);
>>> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
>>> +		return ret;
>>> +	}
>>> +
>>> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>>> +	return kvm_skip_emulated_instruction(vcpu);
>>> +}
>>> +#endif
>>> +
>>>    static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
>>>    {
>>>    	gpa_t gpa;
>>> +	int ret;
>>>    
>>>    	/*
>>>    	 * A nested guest cannot optimize MMIO vmexits, because we have
>>> an
>>>    	 * nGPA here instead of the required GPA.
>>>    	 */
>>>    	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
>>> -	if (!is_guest_mode(vcpu) &&
>>> -	    !kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
>>> -		trace_kvm_fast_mmio(gpa);
>>> -		return kvm_skip_emulated_instruction(vcpu);
>>> +	if (!is_guest_mode(vcpu)) {
>>> +		ret = kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0,
>>> NULL);
>>> +		if (!ret) {
>>> +			trace_kvm_fast_mmio(gpa);
>>> +			return kvm_skip_emulated_instruction(vcpu);
>>> +		}
>>> +
>>> +#ifdef CONFIG_KVM_IOREGION
>>> +		if (unlikely(vcpu->ioregion_ctx.is_interrupted && ret
>>> == -EINTR)) {
>> So the question still, EINTR looks wrong which means the syscall
>> can't
>> be restarted. Not that the syscal doesn't mean KVM_RUN but actually
>> the
>> kernel_read|write() you want to do with the ioregion fd.
>>
>> Also do we need to treat differently for EINTR and ERESTARTSYS since
>> EINTR means the kernel_read()|write() can't be resumed.
>>
>> Thanks
>>
> I don’t mind replacing EINTR with ERESTARTSYS. I think in this case
> there is no more need to process EINTR for ioregionfd. Also it seems
> that the QEMU code doesn’t support ERESTARTSYS handling.


So ERESTARTSYS is something that should not be seen by userspace. When 
SA_RESTART is not set for the signal, kernel will return -EINTR.

My understanding is that you want to implement a mandated restsart the 
read()/write() syscall which should be fine. The problem is not all the 
read()/write() can be restarted (the read/write that doesn't return 
-ERESTARTSYS). In that case we need fail the VCPU_RUN probably.


> Can something
> like (run_ret == -EINTR || run_ret == -EAGAIN || run_ret ==
> -ERESTARTSYS) in kvm_cpu_exec help in this case?


I can't git grep kvm_cpu_exec in the source.

Thanks


>
> Thank you
>
>

