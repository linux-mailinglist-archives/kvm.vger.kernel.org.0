Return-Path: <kvm+bounces-39856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64705A4B756
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 06:01:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66BA8188CBC7
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 05:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FBB61D88A6;
	Mon,  3 Mar 2025 05:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="PPcjleDA"
X-Original-To: kvm@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E13820EB;
	Mon,  3 Mar 2025 05:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740978079; cv=none; b=EbHr/JEKKcuqSSEWcdsODNYd30gMhBT0ZPSgTalvJzp6RZXkgBlQcww+cSBg4ARUpcAsPIdM+eYmWbCzadbPgzAg2dz/urGTPbKuClrFy5FX/XXWIUepRDCTSTGDE0g06QLs8BdWxW7yFlL7x9EdqFL3j/kY+aoWOJu6qvZZXl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740978079; c=relaxed/simple;
	bh=noenWBf4V+zIvOYXaoUlTjEtmvuStjOeGst1Yh1cfQE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NF4Yz+TL/3EuKTkAp3fA8gXp2kOZD7pYt0nCa6eACHTLG25AuPTe7T5jN3DNT1S+VMEIL3BolIf6Yql6udoFCH9dTT8eB+oiZkNmtTdnWqepCLKv7z6oz+HEXo30X9JWv4E5klgIO+4gddsog3pLKtjyUPNPamdmmN6QTrfwZso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=PPcjleDA; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1740978072; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MgRAOZ7IC/MEKf4HOLHXDkLJJ1k9VrHnAWAy3ZEbw0A=;
	b=PPcjleDAkK29kvphTMZc+vsxycXEFMm0/QAW73wtuXy41kcuORssYdmYz7L5ZXcFc8aHsSXbBH5D2s/aGbGPsGvA6YvpDiWDAHoEmXNW6+UXBGHitNNILzdXYRFMuqjH1/EluFXzgnKy6zoa7bJQ6KmP5t89tD1VQSQUmiR0IsY=
Received: from 192.168.117.78(mailfrom:zijie.wei@linux.alibaba.com fp:SMTPD_---0WQYeI1X_1740978070 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 03 Mar 2025 13:01:11 +0800
Message-ID: <f7636788-4fa2-4fa6-afe6-a8fa2edb72ab@linux.alibaba.com>
Date: Mon, 3 Mar 2025 13:01:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] KVM: x86: ioapic: Optimize EOI handling to reduce
 unnecessary VM exits
To: "Huang, Kai" <kai.huang@intel.com>, seanjc@google.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 tglx@linutronix.de, x86@kernel.org, xuyun_xy.xy@linux.alibaba.com,
 zijie.wei@linux.alibaba.com
References: <20241121065039.183716-1-zijie.wei@linux.alibaba.com>
 <20250228021500.516834-1-zijie.wei@linux.alibaba.com>
 <9553f84e3a4533278e06938a4693991cf23cdfc3.camel@intel.com>
From: wzj <zijie.wei@linux.alibaba.com>
Reply-To: 9553f84e3a4533278e06938a4693991cf23cdfc3.camel@intel.com
In-Reply-To: <9553f84e3a4533278e06938a4693991cf23cdfc3.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2025/2/28 20:25, Huang, Kai wrote:
> On Fri, 2025-02-28 at 10:15 +0800, weizijie wrote:
>> Address performance issues caused by a vector being reused by a
>> non-IOAPIC source.
> 
> I saw your reply in v2.  Thanks.
> 
> Some minor comments below, which may be just nits for Sean/Paolo, so feel free
> to add:
> 
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> 
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
> 
> So in short:
> 
>    The "rare case" mentioned in db2bdcbbbd32 and 0fc5a36dd6b3 is actually
>    not that rare and can actually happen in the good behaved guest.
> 
> The above commit message isn't very clear to me, though.  How about below?
> 
> Configuring IOAPIC routed interrupts triggers KVM to rescan all vCPU's
> ioapic_handled_vectors which is used to control which vectors need to trigger
> EOI-induced VMEXITs.  If any interrupt is already in service on some vCPU using
> some vector when the IOAPIC is being rescanned, the vector is set to vCPU's
> ioapic_handled_vectors.  If the vector is then reused by other interrupts, each
> of them will cause a VMEXIT even it is unnecessary.  W/o further IOAPIC rescan,
> the vector remains set, and this issue persists, impacting guest's interrupt
> performance.
> 
> Both commit
> 
>    db2bdcbbbd32 (KVM: x86: fix edge EOI and IOAPIC reconfig race)
> 
> and commit
> 
>    0fc5a36dd6b3 (KVM: x86: ioapic: Fix level-triggered EOI and IOAPIC reconfigure
> race)
> 
> mentioned this issue, but it was considered as "rare" thus was not addressed.
> However in real environment this issue can actually happen in a well-behaved
> guest.
> 

Thank you very much for your suggestions on the comment modifications.
I will apply it to this patch.

>>
>> Simple Fix Proposal:
>> A straightforward solution is to record highest in-service IRQ that
>> is pending at the time of the last scan. Then, upon the next guest
>> exit, do a full KVM_REQ_SCAN_IOAPIC. This ensures that a re-scan of
>> the ioapic occurs only when the recorded vector is EOI'd, and
>> subsequently, the extra bit in the eoi_exit_bitmap are cleared,
> 			  ^
> 			  bits
> 

Thank you for the correction.

>> avoiding unnecessary VM exits.
>>
>> Co-developed-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
>> Signed-off-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
>> Signed-off-by: weizijie <zijie.wei@linux.alibaba.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  1 +
>>   arch/x86/kvm/ioapic.c           | 10 ++++++++--
>>   arch/x86/kvm/irq_comm.c         |  9 +++++++--
>>   arch/x86/kvm/lapic.c            | 10 ++++++++++
>>   4 files changed, 26 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 0b7af5902ff7..8c50e7b4a96f 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1062,6 +1062,7 @@ struct kvm_vcpu_arch {
>>   #if IS_ENABLED(CONFIG_HYPERV)
>>   	hpa_t hv_root_tdp;
>>   #endif
>> +	u8 last_pending_vector;
>>   };
>>   
>>   struct kvm_lpage_info {
>> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>> index 995eb5054360..40252a800897 100644
>> --- a/arch/x86/kvm/ioapic.c
>> +++ b/arch/x86/kvm/ioapic.c
>> @@ -297,10 +297,16 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulong *ioapic_handled_vectors)
>>   			u16 dm = kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
>>   
>>   			if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
>> -						e->fields.dest_id, dm) ||
>> -			    kvm_apic_pending_eoi(vcpu, e->fields.vector))
>> +						e->fields.dest_id, dm))
>>   				__set_bit(e->fields.vector,
>>   					  ioapic_handled_vectors);
>> +			else if (kvm_apic_pending_eoi(vcpu, e->fields.vector)) {
>> +				__set_bit(e->fields.vector,
>> +					  ioapic_handled_vectors);
>> +				vcpu->arch.last_pending_vector = e->fields.vector >
>> +					vcpu->arch.last_pending_vector ? e->fields.vector :
>> +					vcpu->arch.last_pending_vector;
>> +			}
>>   		}
>>   	}
>>   	spin_unlock(&ioapic->lock);
>> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
>> index 8136695f7b96..1d23c52576e1 100644
>> --- a/arch/x86/kvm/irq_comm.c
>> +++ b/arch/x86/kvm/irq_comm.c
>> @@ -426,9 +426,14 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
>>   
>>   			if (irq.trig_mode &&
>>   			    (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
>> -						 irq.dest_id, irq.dest_mode) ||
>> -			     kvm_apic_pending_eoi(vcpu, irq.vector)))
>> +						 irq.dest_id, irq.dest_mode)))
>>   				__set_bit(irq.vector, ioapic_handled_vectors);
>> +			else if (kvm_apic_pending_eoi(vcpu, irq.vector)) {
>> +				__set_bit(irq.vector, ioapic_handled_vectors);
>> +				vcpu->arch.last_pending_vector = irq.vector >
>> +					vcpu->arch.last_pending_vector ? irq.vector :
>> +					vcpu->arch.last_pending_vector;
>> +			}
>>   		}
>>   	}
>>   	srcu_read_unlock(&kvm->irq_srcu, idx);
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index a009c94c26c2..5d62ea5f1503 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -1466,6 +1466,16 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
>>   	if (!kvm_ioapic_handles_vector(apic, vector))
>>   		return;
>>   
>> +	/*
>> +	 * When there are instances where ioapic_handled_vectors is
>> +	 * set due to pending interrupts, clean up the record and do
>> +	 * a full KVM_REQ_SCAN_IOAPIC.
>> +	 */
> 
> How about also add below to the comment?
> 
> 	This ensures the vector is cleared in the vCPU's ioapic_handled_vectors
> 	if the vector is reused by non-IOAPIC interrupts,  avoiding unnecessary
> 	EOI-induced VMEXITs for that vector.
> 

This additional information seems to make it easier to understand. Thank 
you very much.

>> +	if (apic->vcpu->arch.last_pending_vector == vector) {
>> +		apic->vcpu->arch.last_pending_vector = 0;
>> +		kvm_make_request(KVM_REQ_SCAN_IOAPIC, apic->vcpu);
>> +	}
>> +
>>   	/* Request a KVM exit to inform the userspace IOAPIC. */
>>   	if (irqchip_split(apic->vcpu->kvm)) {
>>   		apic->vcpu->arch.pending_ioapic_eoi = vector;
> 


