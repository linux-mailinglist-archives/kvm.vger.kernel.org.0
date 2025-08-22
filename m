Return-Path: <kvm+bounces-55563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D8CCB32562
	for <lists+kvm@lfdr.de>; Sat, 23 Aug 2025 01:22:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C311D1C28C38
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6DC2BE033;
	Fri, 22 Aug 2025 23:20:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-ovh.mhejs.net (vps-ovh.mhejs.net [145.239.82.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BBB1BC4E;
	Fri, 22 Aug 2025 23:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.239.82.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755904849; cv=none; b=SclS422x+L7IahMZPFmqYrEJ7NNDP8dIQ5n0BhQD8T101APWAIoxoI7SSaUZ3Ebs3AH1udGSA1I2H4ZI69oE3vs3SvprbdQp1+ZQppKBwGjK1q5mlWW8x0KZ4bxRPYGD+nT1U7J8kBtvBhmiTjOmvufQUMJWu4dpGVM+HoYeNcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755904849; c=relaxed/simple;
	bh=GC+REUV1O+hkHmoytxnK13s0Xdwj2oCSahJkToTPNBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YnI7zQvcPqbbwfbsvImTxBgTYm4eML9DNktKM76VLWJv9tRg8Lqs/eNLYczjZEFaAm2QSwCd9bL/WsGwYxKZYQ/lP7af9Uv0kU3iRhcG0Y2NYbPntSbQFgYm6c/eFDv0MD8wXDA/MRTeK34clhyvITpXFhF3Pviagcf88XdmKhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=vps-ovh.mhejs.net; arc=none smtp.client-ip=145.239.82.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vps-ovh.mhejs.net
Received: from MUA
	by vps-ovh.mhejs.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <mhej@vps-ovh.mhejs.net>)
	id 1upb3h-00000001dx2-3vsQ;
	Sat, 23 Aug 2025 01:20:33 +0200
Message-ID: <90f4e95a-14ca-40aa-9233-389974734c3c@maciej.szmigiero.name>
Date: Sat, 23 Aug 2025 01:20:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR when
 setting LAPIC regs
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Maxim Levitsky
 <mlevitsk@redhat.com>, Suravee Suthikulpanit
 <Suravee.Suthikulpanit@amd.com>,
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Naveen N Rao <naveen@kernel.org>,
 =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <cover.1755609446.git.maciej.szmigiero@oracle.com>
 <2b2cfff9a2bd6bcc97b97fee7f3a3e1186c9b03c.1755609446.git.maciej.szmigiero@oracle.com>
 <aKeDuaW5Df7PgA38@google.com>
Content-Language: en-US, pl-PL
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Autocrypt: addr=mail@maciej.szmigiero.name; keydata=
 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
Disposition-Notification-To: "Maciej S. Szmigiero"
 <mail@maciej.szmigiero.name>
In-Reply-To: <aKeDuaW5Df7PgA38@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: mhej@vps-ovh.mhejs.net

On 21.08.2025 22:38, Sean Christopherson wrote:
> On Tue, Aug 19, 2025, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> When AVIC is enabled the normal pre-VMRUN sync in sync_lapic_to_cr8() is
>> inhibited so any changed TPR in the LAPIC state would not get copied into
>> the V_TPR field of VMCB.
>>
>> AVIC does sync between these two fields, however it does so only on
>> explicit guest writes to one of these fields, not on a bare VMRUN.
>>
>> This is especially true when it is the userspace setting LAPIC state via
>> KVM_SET_LAPIC ioctl() since userspace does not have access to the guest
>> VMCB.
>>
>> Practice shows that it is the V_TPR that is actually used by the AVIC to
>> decide whether to issue pending interrupts to the CPU (not TPR in TASKPRI),
>> so any leftover value in V_TPR will cause serious interrupt delivery issues
>> in the guest when AVIC is enabled.
>>
>> Fix this issue by explicitly copying LAPIC TPR to VMCB::V_TPR in
>> avic_apicv_post_state_restore(), which gets called from KVM_SET_LAPIC and
>> similar code paths when AVIC is enabled.
>>
>> Fixes: 3bbf3565f48c ("svm: Do not intercept CR8 when enable AVIC")
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
>>   arch/x86/kvm/svm/avic.c | 23 +++++++++++++++++++++++
>>   1 file changed, 23 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index a34c5c3b164e..877bc3db2c6e 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -725,8 +725,31 @@ int avic_init_vcpu(struct vcpu_svm *svm)
>>   
>>   void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>>   {
>> +	struct vcpu_svm *svm = to_svm(vcpu);
>> +	u64 cr8;
>> +
>>   	avic_handle_dfr_update(vcpu);
>>   	avic_handle_ldr_update(vcpu);
>> +
>> +	/* Running nested should have inhibited AVIC. */
>> +	if (WARN_ON_ONCE(nested_svm_virtualize_tpr(vcpu)))
>> +		return;
> 
> 
>> +
>> +	/*
>> +	 * Sync TPR from LAPIC TASKPRI into V_TPR field of the VMCB.
>> +	 *
>> +	 * When AVIC is enabled the normal pre-VMRUN sync in sync_lapic_to_cr8()
>> +	 * is inhibited so any set TPR LAPIC state would not get reflected
>> +	 * in V_TPR.
> 
> Hmm, I think that code is straight up wrong.  There's no justification, just a
> claim:
> 
>    commit 3bbf3565f48ce3999b5a12cde946f81bd4475312
>    Author:     Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>    AuthorDate: Wed May 4 14:09:51 2016 -0500
>    Commit:     Paolo Bonzini <pbonzini@redhat.com>
>    CommitDate: Wed May 18 18:04:31 2016 +0200
> 
>      svm: Do not intercept CR8 when enable AVIC
>      
>      When enable AVIC:
>          * Do not intercept CR8 since this should be handled by AVIC HW.
>          * Also, we don't need to sync cr8/V_TPR and APIC backing page.   <======
>      
>      Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>      [Rename svm_in_nested_interrupt_shadow to svm_nested_virtualize_tpr. - Paolo]
>      Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> That claim assumes APIC[TPR] will _never_ be modified by anything other than
> hardware.  That's obviously false for state restore from userspace, and it's also
> technically false at steady state, e.g. if KVM managed to trigger emulation of a
> store to the APIC page, then KVM would bypass the automatic harware sync.
> 
> There's also the comically ancient KVM_SET_VAPIC_ADDR, which AFAICT appears to
> be largely dead code with respect to vTPR (nothing sets KVM_APIC_CHECK_VAPIC
> except for the initial ioctl), but could again set APIC[TPR] without updating
> V_TPR.
> 
> So, rather than manually do the update during state restore, my vote is to restore
> the sync logic.  And if we want to optimize that code (seems unnecessary), then
> we should hook all TPR writes.
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d9931c6c4bc6..1bfebe40854f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4046,8 +4046,7 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
>          struct vcpu_svm *svm = to_svm(vcpu);
>          u64 cr8;
>   
> -       if (nested_svm_virtualize_tpr(vcpu) ||
> -           kvm_vcpu_apicv_active(vcpu))
> +       if (nested_svm_virtualize_tpr(vcpu))
>                  return;
>   
>          cr8 = kvm_get_cr8(vcpu);
> 
> 

So you want to just do an unconditional LAPIC -> V_TPR sync at each VMRUN
and not try to patch every code flow where these possibly could get de-synced
to do such sync only on demand, correct?

By the way, the original Suravee's submission for the aforementioned patch
did *not* inhibit that sync when AVIC is on [1].

Something similar to this sync inhibit only showed in v4 [2],
probably upon Radim's comment on v3 [3] that:
> I think we can exit early with svm_vcpu_avic_enabled().

But the initial sync inhibit condition in v4 was essentially
nested_svm_virtualize_tpr() && svm_vcpu_avic_enabled(),
which suggests there was some confusion what was exactly meant
by the reviewer comment.

The final sync inhibit condition only showed in v5 [4].
No further discussion happened on that point.

Thanks,
Maciej

[1]: https://lore.kernel.org/kvm/1455285574-27892-9-git-send-email-suravee.suthikulpanit@amd.com/
[2]: https://lore.kernel.org/kvm/1460017232-17429-11-git-send-email-Suravee.Suthikulpanit@amd.com/
[3]: https://lore.kernel.org/kvm/20160318211048.GB26119@potion.brq.redhat.com/
[4]: https://lore.kernel.org/kvm/1462388992-25242-13-git-send-email-Suravee.Suthikulpanit@amd.com/


