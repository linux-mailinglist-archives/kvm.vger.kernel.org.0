Return-Path: <kvm+bounces-7198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CE9283E1ED
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 19:49:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 826581C20DC4
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 18:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D22A42233D;
	Fri, 26 Jan 2024 18:49:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794D421371;
	Fri, 26 Jan 2024 18:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.28.154.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706294955; cv=none; b=CMgiMGZ4iiTLH2nqnNnz5ehqnSl5seZzskBmGa1s/DRXxF6/UIcU4EvA/rEuwFnazfijQF7LQR6s5yHaeQW1JU3WD3/luSmnMXE/9cdE6ol7Jwnh84T5XQpkRr7JzWDtQh/kccSqaYtVOmzBQIG8zSHu2Ss3CJxZrLkfhbEXgHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706294955; c=relaxed/simple;
	bh=pStHePFSIKYPMYDhCKX9LHB74JCGqh+BFv00THOanSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qGKNNrNR4C9NUOW0FQmhCvVz32C/JMRI3ngKZZDxfYG5N/IpPrnBUAxQwGm75nenOAvKUZBdbNUdf/c7hGRBwpta5/3avrM26u0nOc9bSb/Wv2OHjUvQ/cKzWAABP9koBCPGzM//6ZaBJpIyHsNJBroGYk4c8Z5zwS3cfB7bGYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=maciej.szmigiero.name; arc=none smtp.client-ip=37.28.154.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maciej.szmigiero.name
Received: from MUA
	by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.94.2)
	(envelope-from <mail@maciej.szmigiero.name>)
	id 1rTRG6-0007EI-DT; Fri, 26 Jan 2024 19:48:58 +0100
Message-ID: <592977b7-e4c9-43af-aa33-1ce3b6fa1275@maciej.szmigiero.name>
Date: Fri, 26 Jan 2024 19:48:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Give a hint when Win2016 might fail to boot due
 to XSAVES erratum
Content-Language: en-US, pl-PL
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <b83ab45c5e239e5d148b0ae7750133a67ac9575c.1706127425.git.maciej.szmigiero@oracle.com>
 <CABgObfZ1YzigovNEiYF7pbmRxv-SUzEFqnpaQZ4GT_hDssm65g@mail.gmail.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Autocrypt: addr=mail@maciej.szmigiero.name; keydata=
 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
Disposition-Notification-To: "Maciej S. Szmigiero"
 <mail@maciej.szmigiero.name>
In-Reply-To: <CABgObfZ1YzigovNEiYF7pbmRxv-SUzEFqnpaQZ4GT_hDssm65g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26.01.2024 19:36, Paolo Bonzini wrote:
> On Wed, Jan 24, 2024 at 9:18 PM Maciej S. Szmigiero
> <mail@maciej.szmigiero.name> wrote:
>> +static void kvm_hv_xsaves_xsavec_maybe_warn_unlocked(struct kvm_vcpu *vcpu)
> 
> Calling this function "unlocked" is confusing (others would say
> "locked" is confusing instead). The double-underscore convention is
> more common.
> 
>> +{
>> +       struct kvm *kvm = vcpu->kvm;
>> +       struct kvm_hv *hv = to_kvm_hv(kvm);
>> +
>> +       if (hv->xsaves_xsavec_warned)
>> +               return;
>> +
>> +       if (!vcpu->arch.hyperv_enabled)
>> +               return;
> 
> I think these two should be in kvm_hv_xsaves_xsavec_maybe_warn(),
> though the former needs to be checked again under the lock.
> 
>> +       if ((hv->hv_guest_os_id & KVM_HV_WIN2016_GUEST_ID_MASK) !=
>> +           KVM_HV_WIN2016_GUEST_ID)
>> +               return;
> 
> At this point there is no need to return. You can set
> xsaves_xsavec_warned and save the checks in the future.
>
>> +       /* UP configurations aren't affected */
>> +       if (atomic_read(&kvm->online_vcpus) < 2)
>> +               return;
>> +
>> +       if (boot_cpu_has(X86_FEATURE_XSAVES) ||
>> +           !guest_cpuid_has(vcpu, X86_FEATURE_XSAVEC))
>> +               return;
> 
> boot_cpu_has can also be done first to cull the whole check.
> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 27e23714e960..db0a2c40d749 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1782,6 +1782,10 @@ static int set_efer
>>         if ((efer ^ old_efer) & KVM_MMU_EFER_ROLE_BITS)
>>                 kvm_mmu_reset_context(vcpu);
>>
>> +       if (guest_cpuid_is_amd_or_hygon(vcpu) &&
>> +           efer & EFER_SVME)
>> +               kvm_hv_xsaves_xsavec_maybe_warn(vcpu);
>> +
>>         return 0;
>> }
> 
> Checking guest_cpuid_is_amd_or_hygon() is relatively expensive, it
> should be done after "efer & EFER_SVME" but really the bug can happen
> just as well on Intel as far as I understand? It's just less likely
> due to the AMD erratum.

Yes, I've checked this guest on an Intel host and it also fails to
boot in !XSAVES && XSAVEC configuration.

Only on Intel it's purely a theoretical problem as AFAIK there's
no corresponding Intel errata that disables just XSAVES.

> 
> I'll send a v2.
> 
> Paolo
> 

Thanks,
Maciej


