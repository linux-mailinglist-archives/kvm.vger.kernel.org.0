Return-Path: <kvm+bounces-34387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 413749FD15A
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 08:30:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D279F163B0B
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 07:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9923D1487C5;
	Fri, 27 Dec 2024 07:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="OKeTQRuM"
X-Original-To: kvm@vger.kernel.org
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9571AD21;
	Fri, 27 Dec 2024 07:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735284645; cv=none; b=a4WfJB6sg29n6g2fn4kfgtQ0Robr71nDcTXxU0I6u+p7aem6Sc7aGNOnVS53VS862KbxdIVmcVhmqvTcaMaFuxjWXpiI0qPl0jQNn2wbZpo+X7fTDIQ52Jgp67iYhglCP25u+7e5X0Cp/GkEQEUHz+EflAqk4M8ue5OBLSWsAf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735284645; c=relaxed/simple;
	bh=+vj3FYbukl5Pvzm4y9/gm4TgOOVamzZoYEOp9/OlbXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=Z1Y0q4PsIpiJTVC+Gq/QqyNhGYJQ6qLGR6MCxX1OKbq/wF6sDEe8Y/nxq0czoL+IGv+/LZP7xDhJpeuAEoeeBSU3lpElHOP3k4Y4Dj+g70YnuCZRYEbKCXtWkBp9m4xig1/XMKqAmyybmUvYRmRVLqHnnDgpbj1x88dLw1Id+QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=OKeTQRuM; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735284639; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=usSELyODZ1alEsRTFRW1ZTNvatNfFp763mepPQuF1SU=;
	b=OKeTQRuMJvw52/ccmMX3gNzLIC7xCRCgL7667hfKhpDBsBC0/e8h8+KG4LhVtH5rewuq3AUtJRPfamfIkA3+YIqZpLCjqXWH0IYwe7B540FukSNLuYTlBmNEHU+4Eem5Zen7GCE5lCmApNMu6ox6SxFCu5ybBH4yRGr20pl235U=
Received: from 192.168.117.78(mailfrom:zijie.wei@linux.alibaba.com fp:SMTPD_---0WMKRAcr_1735284636 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Dec 2024 15:30:38 +0800
Message-ID: <b29a499f-36d3-476a-a1bb-99402ef6be2a@linux.alibaba.com>
Date: Fri, 27 Dec 2024 15:30:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: ioapic: Optimize EOI handling to reduce
 unnecessary VM exits
To: Sean Christopherson <seanjc@google.com>
References: <20241121065039.183716-1-zijie.wei@linux.alibaba.com>
 <Z2IDkWPz2rhDLD0P@google.com>
From: wzj <zijie.wei@linux.alibaba.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, xuyun_xy.xy@linux.alibaba.com
In-Reply-To: <Z2IDkWPz2rhDLD0P@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On December 18, 2024, Sean Christopherson wrote:
> On Thu, Nov 21, 2024, weizijie wrote:
>> Address performance issues caused by a vector being reused by a
>> non-IOAPIC source.
>>
>> commit 0fc5a36dd6b3
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
>>
>> Simple Fix Proposal:
>> A straightforward solution is to record the vector that is pending at
>> the time of injection. Then, upon the next guest exit, clean up the
>> ioapic_handled_vectors corresponding to the vector number that was
>> pending. This ensures that interrupts are properly handled and prevents
>> performance issues.
>>
>> Signed-off-by: weizijie <zijie.wei@linux.alibaba.com>
>> Signed-off-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
> Your SoB should be last, and assuming Xuyun is a co-author, they need to be
> credited via Co-developed-by.  See Documentation/process/submitting-patches.rst
> for details.

I'm sincerely apologize, that was my oversight. I will add 
Co-developed-by and move my SoB to the end.

>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  1 +
>>   arch/x86/kvm/ioapic.c           | 11 +++++++++--
>>   arch/x86/kvm/vmx/vmx.c          | 10 ++++++++++
>>   3 files changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index e159e44a6a1b..b008c933d2ab 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1041,6 +1041,7 @@ struct kvm_vcpu_arch {
>>   #if IS_ENABLED(CONFIG_HYPERV)
>>   	hpa_t hv_root_tdp;
>>   #endif
>> +	DECLARE_BITMAP(ioapic_pending_vectors, 256);
>>   };
>>   
>>   struct kvm_lpage_info {
>> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>> index 995eb5054360..6f5a88dc63da 100644
>> --- a/arch/x86/kvm/ioapic.c
>> +++ b/arch/x86/kvm/ioapic.c
>> @@ -284,6 +284,8 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulong *ioapic_handled_vectors)
> The split IRQ chip mode should have the same enhancement.

You are absolutely right; the split IRQ has the same issue.

We will apply the same enhancement here as will.

>
>>   	spin_lock(&ioapic->lock);
>>   
>> +	bitmap_zero(vcpu->arch.ioapic_pending_vectors, 256);
> Rather than use a bitmap, what does performance look like if this is a single u8
> that tracks the highest in-service IRQ at the time of the last scan?  And then
> when that IRQ is EOI'd, do a full KVM_REQ_SCAN_IOAPIC instead of
> KVM_REQ_LOAD_EOI_EXITMAP?  Having multiple interrupts in-flight at the time of
> scan should be quite rare.
>
> I like the idea, but burning 32 bytes for an edge case of an edge case seems
> unnecessary.

This is truly an excellent modification suggestion. Your comprehensive 
consideration is impressive. Using just a u8 to record highest 
in-service IRQ and only redoing a full KVM_REQ_SCAN_IOAPIC when the 
recorded IRQ is EOI'd not only avoids impacting other interrupts that 
should cause a vm exit, but also saves space.

>   
>> +
>>   	/* Make sure we see any missing RTC EOI */
>>   	if (test_bit(vcpu->vcpu_id, dest_map->map))
>>   		__set_bit(dest_map->vectors[vcpu->vcpu_id],
>> @@ -297,10 +299,15 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulong *ioapic_handled_vectors)
>>   			u16 dm = kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
>>   
>>   			if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
>> -						e->fields.dest_id, dm) ||
>> -			    kvm_apic_pending_eoi(vcpu, e->fields.vector))
>> +						e->fields.dest_id, dm))
>> +				__set_bit(e->fields.vector,
>> +					  ioapic_handled_vectors);
>> +			else if (kvm_apic_pending_eoi(vcpu, e->fields.vector)) {
>>   				__set_bit(e->fields.vector,
>>   					  ioapic_handled_vectors);
>> +				__set_bit(e->fields.vector,
>> +					  vcpu->arch.ioapic_pending_vectors);
>> +			}
>>   		}
>>   	}
>>   	spin_unlock(&ioapic->lock);
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 0f008f5ef6f0..572e6f9b8602 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5710,6 +5710,16 @@ static int handle_apic_eoi_induced(struct kvm_vcpu *vcpu)
>>   
>>   	/* EOI-induced VM exit is trap-like and thus no need to adjust IP */
>>   	kvm_apic_set_eoi_accelerated(vcpu, vector);
>> +
>> +	/* When there are instances where ioapic_handled_vectors is
>> +	 * set due to pending interrupts, clean up the record and the
>> +	 * corresponding bit after the interrupt is completed.
>> +	 */
>> +	if (test_bit(vector, vcpu->arch.ioapic_pending_vectors)) {
> This belongs in common code, probably kvm_ioapic_send_eoi().
We make the code on the common path as simple as possible.
>> +		clear_bit(vector, vcpu->arch.ioapic_pending_vectors);
>> +		clear_bit(vector, vcpu->arch.ioapic_handled_vectors);
>> +		kvm_make_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu);
>> +	}
>>   	return 1;
>>   }
>>   
KVM: x86: ioapic: Optimize EOI handling to reduce
  unnecessary VM exits

Address performance issues caused by a vector being reused by a
non-IOAPIC source.

commit 0fc5a36dd6b3
("KVM: x86: ioapic: Fix level-triggered EOI and IOAPIC reconfigure race")
addressed the issues related to EOI and IOAPIC reconfiguration races.
However, it has introduced some performance concerns:

Configuring IOAPIC interrupts while an interrupt request (IRQ) is
already in service can unintentionally trigger a VM exit for other
interrupts that normally do not require one, due to the settings of
`ioapic_handled_vectors`. If the IOAPIC is not reconfigured during
runtime, this issue persists, continuing to adversely affect
performance.

Simple Fix Proposal:
A straightforward solution is to record highest in-service IRQ that
is pending at the time of the last scan. Then, upon the next guest
exit, do a full KVM_REQ_SCAN_IOAPIC. This ensures that a re-scan of
the ioapic occurs only when the recorded vector is EOI'd, and
subsequently, the extra bit in the eoi_exit_bitmap are cleared,
avoiding unnecessary VM exits.

Co-developed-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
Signed-off-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
Signed-off-by: weizijie <zijie.wei@linux.alibaba.com>
---
v1 -> v2

* Move my SoB to the end and add Co-developed-by for Xuyun

* Use a u8 type to record a pending IRQ during the ioapic scan process

* Made the same changes for the split IRQ chip mode

arch/x86/include/asm/kvm_host.h |  1 +
  arch/x86/kvm/ioapic.c           | 10 ++++++++--
  arch/x86/kvm/irq_comm.c         |  9 +++++++--
  arch/x86/kvm/vmx/vmx.c          |  9 +++++++++
  4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h 
b/arch/x86/include/asm/kvm_host.h
index e159e44a6a1b..f84a4881afa4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1041,6 +1041,7 @@ struct kvm_vcpu_arch {
  #if IS_ENABLED(CONFIG_HYPERV)
         hpa_t hv_root_tdp;
  #endif
+       u8 last_pending_vector;
  };

  struct kvm_lpage_info {
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 995eb5054360..40252a800897 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -297,10 +297,16 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, 
ulong *ioapic_handled_vectors)
                         u16 dm = 
kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);

                         if (kvm_apic_match_dest(vcpu, NULL, 
APIC_DEST_NOSHORT,
- e->fields.dest_id, dm) ||
-                           kvm_apic_pending_eoi(vcpu, e->fields.vector))
+ e->fields.dest_id, dm))
                                 __set_bit(e->fields.vector,
                                           ioapic_handled_vectors);
+                       else if (kvm_apic_pending_eoi(vcpu, 
e->fields.vector)) {
+                               __set_bit(e->fields.vector,
+                                         ioapic_handled_vectors);
+                               vcpu->arch.last_pending_vector = 
e->fields.vector >
+ vcpu->arch.last_pending_vector ? e->fields.vector :
+ vcpu->arch.last_pending_vector;
+                       }
                 }
         }
         spin_unlock(&ioapic->lock);
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 8136695f7b96..1d23c52576e1 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -426,9 +426,14 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,

                         if (irq.trig_mode &&
                             (kvm_apic_match_dest(vcpu, NULL, 
APIC_DEST_NOSHORT,
-                                                irq.dest_id, 
irq.dest_mode) ||
-                            kvm_apic_pending_eoi(vcpu, irq.vector)))
+                                                irq.dest_id, 
irq.dest_mode)))
                                 __set_bit(irq.vector, 
ioapic_handled_vectors);
+                       else if (kvm_apic_pending_eoi(vcpu, irq.vector)) {
+                               __set_bit(irq.vector, 
ioapic_handled_vectors);
+                               vcpu->arch.last_pending_vector = 
irq.vector >
+ vcpu->arch.last_pending_vector ? irq.vector :
+ vcpu->arch.last_pending_vector;
+                       }
                 }
         }
         srcu_read_unlock(&kvm->irq_srcu, idx);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 893366e53732..cd0db1496ce7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5702,6 +5702,15 @@ static int handle_apic_eoi_induced(struct 
kvm_vcpu *vcpu)

         /* EOI-induced VM exit is trap-like and thus no need to adjust 
IP */
         kvm_apic_set_eoi_accelerated(vcpu, vector);
+
+       /* When there are instances where ioapic_handled_vectors is
+        * set due to pending interrupts, clean up the record and do
+        * a full KVM_REQ_SCAN_IOAPIC.
+        */
+       if (vcpu->arch.last_pending_vector == vector) {
+               vcpu->arch.last_pending_vector = 0;
+               kvm_make_request(KVM_REQ_SCAN_IOAPIC, vcpu);
+       }
         return 1;
  }

>> -- 
>> 2.43.5
>>

