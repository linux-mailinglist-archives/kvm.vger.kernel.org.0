Return-Path: <kvm+bounces-37217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CC1AA26EA4
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 10:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB4737A48E0
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 09:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87F4B207E0F;
	Tue,  4 Feb 2025 09:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jg05QVcz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDEA207DE0;
	Tue,  4 Feb 2025 09:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738661896; cv=none; b=iR1v7+7Awqn5tpdP444WVrPhejr4cWeIsw88yTRoFH6R5lh4WNKWZYMXs808zzHA4NHI4fHcTMkNy8bs6xO8q+0uTQ88g6t7dEMpgDQq3PN4LlOK4lboACILtT2Tj81DiBSoF31RpoFl/al0XRvSDX5pVUI82VIWSTNjfbuunHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738661896; c=relaxed/simple;
	bh=oOeCzDXeF8jK6OYqKTjdctgjul+DBpGMXax4zVKoOzg=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=r0jjhc4YhctVRUN/7DqBoNURYAUIHdka7Dw8wDDL4Rf4HTMd3qdHr0EE5ePUcmyCKD6p5aY5HR+qEu/4YDwal8Il2pf/CikONtwFPx731py8X9Bhs9kngF23FdYV8qlmRLeqpCpmuWJkYBmCwcf2y3jVerN4ONAPIBoptN6cGi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jg05QVcz; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aa67ac42819so803806266b.0;
        Tue, 04 Feb 2025 01:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738661893; x=1739266693; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CxrGF0NbT5RA+zpDXBklhKJHF4FCs+rYNXfB+92lHyY=;
        b=Jg05QVcz3t9E4ZZU/7V568jFU9lGpluCCawgT96l2zW4x7NfQOGRTPeJG5UV0amvbN
         OmaaOijoU+Q70kd7Fj8Hy11XoY5ZlXtaHPiN14ipFX48vaZafxzHIRWXYDaxlRjNQRX1
         CMFbogxlkR+8Jr3FuVNiaXsT+i0mGTdEuuiBIDi0FQiam8tnllI8lNXYVEBmTY50pHdI
         N2Hh5P7d2p6bpp7NltaVk/pG4Z1ZyqHHLFzv0kCx8A0ayFUutcKyfgcoauF+LjIn5o85
         tDpSEWbr8iBAOqLK+feLBCrfsB/7va8AatGpBi10yqDNn7jLkwZfpgIGnxN2kgRqa73r
         pK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738661893; x=1739266693;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CxrGF0NbT5RA+zpDXBklhKJHF4FCs+rYNXfB+92lHyY=;
        b=fZKsh98QMZygzzjeHy8A1eeK1tdi+Zf8gtbL6dZdkkiVW74bfUAdr0xKSezCgwwWVr
         IupI0lQGPiAzUw4+6uu0fgC8gZ4dHkeblDi2aMl51pgq8o49hZpzPn7lBTp+79l2zHy8
         yT2v3UeY0o1A0kX7pDDBe7ueGdvYDuQUtvOB33Bsem/22uyHkfEeZ1TZCWCtW5e3E8St
         DuwnpWvD/Tdb47wZKsflkCTSSAnvKwUJqV47SOPkPmIfHr89+ySgXdwBVFs1uCDU9iiW
         B1qmg4EIYyDYzNGClgf5dX0rgBiEfL9z32F86Kt/FVpxeVGCxyFeHgCGqDDU1CW3p+7o
         FGlQ==
X-Forwarded-Encrypted: i=1; AJvYcCURScQybXy2VzozAvtYkau6ioXdV18D/MW+62WyHZRtYMJntw1RAnt0CI1p07efbaII3RxeNI9+WihiKLk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP5uA0BrSx2EtwXl2qh5G6v7/OEziQaPnSUW52ipJ1DT+VNwUa
	nk5qy6G2T39T6cgC3V3XjI5vawUWd7Pcy6UE+L68FDcDclWV2Q0X
X-Gm-Gg: ASbGnctOVzpMpzNpWVZU0TdvJ1tCpq2VUNjCEkUPiheI44VQ3vB6jskeStSTnRvj8iD
	vtHdGJdy6PH8QbBSfJdGUjhYB+QwZgs5iPBcuRwdP+i8bAOOpfdzTzAa4hhQD1+wmrKEnqkhITL
	ViaEptj7mV6AeZk2lv3abdx1Kk8vQzJgjGIklOP26v3ZEhTTzvrXSq/AKejRyNfx+oIXbMlHnJQ
	+vddwvV3EFuouC6LXOEZeG0+RbsNCa3c9Ik6Dl/PlMKFIOTSgh17ap+KxFRN5PG/W/9UP6iffAO
	INbHV2LybrlsWp3PrlZoBLwdycX2n6/jIZQIHdaZkMVeXtU=
X-Google-Smtp-Source: AGHT+IFDwdCbXMxp8UJ7YfuN/ii8dyMqd4tJD/SwNfC/IgqAQPvlPzSwxAoJ1hb9zADxwcscQVMWbQ==
X-Received: by 2002:a17:907:9482:b0:ab6:85dc:b6d4 with SMTP id a640c23a62f3a-ab6cfcb3b63mr2934683366b.9.1738661892933;
        Tue, 04 Feb 2025 01:38:12 -0800 (PST)
Received: from [192.168.20.51] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab74f50df2csm49252166b.141.2025.02.04.01.38.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 01:38:12 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <6b2d960c-1340-4e91-ad17-0ccadd378a81@xen.org>
Date: Tue, 4 Feb 2025 09:38:11 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 08/11] KVM: x86: Pass reference pvclock as a param to
 kvm_setup_guest_pvclock()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20250201013827.680235-1-seanjc@google.com>
 <20250201013827.680235-9-seanjc@google.com>
 <792ae6f4-903f-41b2-a0f2-369d92a1fc3f@xen.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <792ae6f4-903f-41b2-a0f2-369d92a1fc3f@xen.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 04/02/2025 09:33, Paul Durrant wrote:
> On 01/02/2025 01:38, Sean Christopherson wrote:
>> Pass the reference pvclock structure that's used to setup each individual
>> pvclock as a parameter to kvm_setup_guest_pvclock() as a preparatory step
>> toward removing kvm_vcpu_arch.hv_clock.
>>
>> No functional change intended.
>>
>> Reviewed-by: Paul Durrant <paul@xen.org>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   arch/x86/kvm/x86.c | 14 +++++++-------
>>   1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 5f3ad13a8ac7..06d27b3cc207 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3116,17 +3116,17 @@ u64 get_kvmclock_ns(struct kvm *kvm)
>>       return data.clock;
>>   }
>> -static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
>> +static void kvm_setup_guest_pvclock(struct pvclock_vcpu_time_info 
>> *ref_hv_clock,
>> +                    struct kvm_vcpu *vcpu,
> 
> So, here 'v' becomes 'vcpu'
> 
>>                       struct gfn_to_pfn_cache *gpc,
>>                       unsigned int offset,
>>                       bool force_tsc_unstable)
>>   {
>> -    struct kvm_vcpu_arch *vcpu = &v->arch;
>>       struct pvclock_vcpu_time_info *guest_hv_clock;
>>       struct pvclock_vcpu_time_info hv_clock;
>>       unsigned long flags;
>> -    memcpy(&hv_clock, &vcpu->hv_clock, sizeof(hv_clock));
>> +    memcpy(&hv_clock, ref_hv_clock, sizeof(hv_clock));
>>       read_lock_irqsave(&gpc->lock, flags);
>>       while (!kvm_gpc_check(gpc, offset + sizeof(*guest_hv_clock))) {
>> @@ -3165,7 +3165,7 @@ static void kvm_setup_guest_pvclock(struct 
>> kvm_vcpu *v,
>>       kvm_gpc_mark_dirty_in_slot(gpc);
>>       read_unlock_irqrestore(&gpc->lock, flags);
>> -    trace_kvm_pvclock_update(v->vcpu_id, &hv_clock);
>> +    trace_kvm_pvclock_update(vcpu->vcpu_id, &hv_clock);
>>   }
>>   static int kvm_guest_time_update(struct kvm_vcpu *v)
>> @@ -3272,18 +3272,18 @@ static int kvm_guest_time_update(struct 
>> kvm_vcpu *v)
>>               vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
>>               vcpu->pvclock_set_guest_stopped_request = false;
>>           }
>> -        kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
>> +        kvm_setup_guest_pvclock(&vcpu->hv_clock, v, &vcpu->pv_time, 
>> 0, false);
> 
> Yet here an below you still use 'v'. Does this actually compile?
> 

Sorry, my misreading of the patch... this is in caller context so no 
problem. The inconsistent naming was misleading me.

Reviewed-by: Paul Durrant <paul@xen.org>


