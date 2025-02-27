Return-Path: <kvm+bounces-39565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3999FA47D6A
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 13:19:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 340683AF5FD
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 12:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D10232379;
	Thu, 27 Feb 2025 12:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wpHW840s"
X-Original-To: kvm@vger.kernel.org
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7234F23099F;
	Thu, 27 Feb 2025 12:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740658633; cv=none; b=QRU9Q1OosGdsqnFbuw/TgrLkkPsiv8hotzutXAB/rAdsu741IqdPFzgsnKgh8ICNDaXpvTGb4pLwFXLiPs4Eqpo5PzKKdWKR67YTGe7ebVbPu44ztOuezkPeYdmQp2yw2FvnZgTEGY8SNIq4K4aJ3uvHJ/njz4X21ZAJAgmnCRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740658633; c=relaxed/simple;
	bh=PiF4w06dcmStGdKpjz/UNXxJfVdxs5NQYHvmL6NN2Ic=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=ih/3d5Uxu383Dc4/hIBALum4VSz9bwx+AXovjZM0XXu5fozUJIyE5zBPnXbgXUVVC90+dtX9HZXx7LPKI85DY+yKo37jTubb1pB0vEafDXNkvsg7JHkI3DeTitN/rjIvB0RT3SuViqrH+DfSf6J4eEPX8GrsmX+bB9tWgnDrtMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wpHW840s; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1740658619; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=eMJBS2PZbCvnQKDjS6NEBU5SffzxB8MSKZeLWb/7V9U=;
	b=wpHW840snQFNn75Roo2ZuOOfADCMM99GGyvjuzYmihgiNUv6vmB5m+5paA9cvjIWqP7r6FhLwHrdXN5FnowpLTOLw4YHCunWcjAAB+8c2oI736sqBiKkl7gRolZxO0QHwIhrIY6sDdInspPFc6T0Qy915YEKbpBefszq928kF5g=
Received: from 192.168.117.78(mailfrom:zijie.wei@linux.alibaba.com fp:SMTPD_---0WQMD2JL_1740658618 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Feb 2025 20:16:59 +0800
Message-ID: <166ac755-52c1-4dd2-8a7c-cd5feff11dd7@linux.alibaba.com>
Date: Thu, 27 Feb 2025 20:16:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH Resend] KVM: x86: ioapic: Optimize EOI handling to reduce
 unnecessary VM exits
To: kai.huang@intel.com
References: <Z6uo24Wf3LoetUMc@google.com>
 <20250225064253.309334-1-zijie.wei@linux.alibaba.com>
 <63886376-07d3-45f2-90b3-89e1b63501f3@intel.com>
From: wzj <zijie.wei@linux.alibaba.com>
Reply-To: 63886376-07d3-45f2-90b3-89e1b63501f3@intel.com
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
 pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org,
 xuyun_xy.xy@linux.alibaba.com, zijie.wei@linux.alibaba.com
In-Reply-To: <63886376-07d3-45f2-90b3-89e1b63501f3@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2025/2/26 22:44, Huang, Kai wrote:
> 
> 
> On 25/02/2025 7:42 pm, weizijie wrote:
>> Address performance issues caused by a vector being reused by a
>> non-IOAPIC source.
>>
>> Commit 0fc5a36dd6b3
>> ("KVM: x86: ioapic: Fix level-triggered EOI and IOAPIC reconfigure race")
>> addressed the issues related to EOI and IOAPIC reconfiguration races.
>> However, it has introduced some performance concerns:
>>
>> Configuring IOAPIC interrupts while an interrupt request (IRQ) is
>> already in service can unintentionally trigger a VM exit for other
>> interrupts that normally do not require one, due to the settings of
>> `ioapic_handled_vectors`. If the IOAPIC is not reconfigured during
>> runtime, this issue persists, continuing to adversely affect
>> performance.
> 
> Could you elaborate why the guest would configure the IOAPIC entry to 
> use the same vector of an IRQ which is already in service?  Is it some 
> kinda temporary configuration (which means the guest will either the 
> reconfigure the vector of the conflicting IRQ or the IOAPIC entry soon)?
> 
> I.e., why would this issue persist?
> 
> If such "persist" is due to guest bug or bad behaviour I am not sure we 
> need to tackle that in KVM.
> 

The previous patches:
db2bdcbbbd32 (KVM: x86: fix edge EOI and IOAPIC reconfig race)
0fc5a36dd6b3 (KVM: x86: ioapic: Fix level-triggered EOI and IOAPIC 
reconfigure race)
both mentioned this issue.

For example, when there is an interrupt being processed on CPU0 with 
vector 33, and an IOAPIC interrupt reconfiguration occurs at that 
moment, an interrupt is assigned to CPU1, and this interrupt’s vector
is also 33 (it could also be another value). At this point, the 
interrupt being processed, which originally did not need to cause a VM 
exit, will now need to continuously cause a VM exit afterward.
You are absolutely correct; if the guest triggers an IOAPIC interrupt 
reconfiguration again afterward and does not encounter the 
aforementioned situation, then vector 33 on CPU0 will no longer need to 
cause a VM exit.

>>
>> Simple Fix Proposal:
>> A straightforward solution is to record highest in-service IRQ that
>> is pending at the time of the last scan. Then, upon the next guest
>> exit, do a full KVM_REQ_SCAN_IOAPIC. This ensures that a re-scan of
>> the ioapic occurs only when the recorded vector is EOI'd, and
>> subsequently, the extra bit in the eoi_exit_bitmap are cleared,
>> avoiding unnecessary VM exits.
>>
>> Co-developed-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
>> Signed-off-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
>> Signed-off-by: weizijie <zijie.wei@linux.alibaba.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  1 +
>>   arch/x86/kvm/ioapic.c           | 10 ++++++++--
>>   arch/x86/kvm/irq_comm.c         |  9 +++++++--
>>   arch/x86/kvm/vmx/vmx.c          |  9 +++++++++
>>   4 files changed, 25 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/ 
>> kvm_host.h
>> index 0b7af5902ff7..8c50e7b4a96f 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1062,6 +1062,7 @@ struct kvm_vcpu_arch {
>>   #if IS_ENABLED(CONFIG_HYPERV)
>>       hpa_t hv_root_tdp;
>>   #endif
>> +    u8 last_pending_vector;
>>   };
>>   struct kvm_lpage_info {
>> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>> index 995eb5054360..40252a800897 100644
>> --- a/arch/x86/kvm/ioapic.c
>> +++ b/arch/x86/kvm/ioapic.c
>> @@ -297,10 +297,16 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu 
>> *vcpu, ulong *ioapic_handled_vectors)
>>               u16 dm = kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
>>               if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
>> -                        e->fields.dest_id, dm) ||
>> -                kvm_apic_pending_eoi(vcpu, e->fields.vector))
>> +                        e->fields.dest_id, dm))
>>                   __set_bit(e->fields.vector,
>>                         ioapic_handled_vectors);
>> +            else if (kvm_apic_pending_eoi(vcpu, e->fields.vector)) {
>> +                __set_bit(e->fields.vector,
>> +                      ioapic_handled_vectors);
>> +                vcpu->arch.last_pending_vector = e->fields.vector >
>> +                    vcpu->arch.last_pending_vector ? e->fields.vector :
>> +                    vcpu->arch.last_pending_vector;
>> +            }
>>           }
>>       }
>>       spin_unlock(&ioapic->lock);
>> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
>> index 8136695f7b96..1d23c52576e1 100644
>> --- a/arch/x86/kvm/irq_comm.c
>> +++ b/arch/x86/kvm/irq_comm.c
>> @@ -426,9 +426,14 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
>>               if (irq.trig_mode &&
>>                   (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
>> -                         irq.dest_id, irq.dest_mode) ||
>> -                 kvm_apic_pending_eoi(vcpu, irq.vector)))
>> +                         irq.dest_id, irq.dest_mode)))
>>                   __set_bit(irq.vector, ioapic_handled_vectors);
>> +            else if (kvm_apic_pending_eoi(vcpu, irq.vector)) {
>> +                __set_bit(irq.vector, ioapic_handled_vectors);
>> +                vcpu->arch.last_pending_vector = irq.vector >
>> +                    vcpu->arch.last_pending_vector ? irq.vector :
>> +                    vcpu->arch.last_pending_vector;
>> +            }
>>           }
>>       }
>>       srcu_read_unlock(&kvm->irq_srcu, idx);
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 6c56d5235f0f..047cdd5964e5 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5712,6 +5712,15 @@ static int handle_apic_eoi_induced(struct 
>> kvm_vcpu *vcpu)
>>       /* EOI-induced VM exit is trap-like and thus no need to adjust 
>> IP */
>>       kvm_apic_set_eoi_accelerated(vcpu, vector);
>> +
>> +    /* When there are instances where ioapic_handled_vectors is
>> +     * set due to pending interrupts, clean up the record and do
>> +     * a full KVM_REQ_SCAN_IOAPIC.
>> +     */
> 
> Comment style:
> 
>      /*
>       * When ...
>       */
> 

Thank you very much for your suggestion.

>> +    if (vcpu->arch.last_pending_vector == vector) {
>> +        vcpu->arch.last_pending_vector = 0;
>> +        kvm_make_request(KVM_REQ_SCAN_IOAPIC, vcpu);
>> +    }
> 
> As Sean commented before, this should be in a common code probably in 
> kvm_ioapic_send_eoi().
> 

I will move the modifications here and send a new patch.

> https://lore.kernel.org/all/Z2IDkWPz2rhDLD0P@google.com/

Best regards!


