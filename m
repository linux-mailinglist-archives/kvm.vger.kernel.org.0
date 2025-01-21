Return-Path: <kvm+bounces-36165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9988CA182A9
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:15:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3B0A16913B
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B82B71F5419;
	Tue, 21 Jan 2025 17:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hpdjv4AR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264AB5028C;
	Tue, 21 Jan 2025 17:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737479738; cv=none; b=g0vUnBPah8hgQiYPX04EWUZ5sPPgtpkUCc98/UqB2ddFpx4RgN5dpSCe8j6PDgzx/O0iz7T4Ibg3EvzTAbsjRQ6Mo+1LicceXc5Eqr0sC96jxr2RR5h0zn3z0KFDdUpfXWhz6JMwrFObzkZ/LzoOFTcNis/eKASMcwAoC1IprgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737479738; c=relaxed/simple;
	bh=prfwR+o2z8U+nzTJpIqaUwrtY1+BuLeQiRA1Cc8W/MA=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Z6Lin6QoHENNC3EtsRxibeRLWFBKg32oLdMSilPUXWlhWBmwdWhgVj09wmbw32h4+IyKAQ0XbnUMeyltgA9IkeCrtadBFi1XRKOVFYtbaZ1WjdeV294B5VzLG9FkpMok5x8NkUc0l51Fw9ONwO6B728iCoTxDglCh8R9tt4E3MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hpdjv4AR; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4361f664af5so68287325e9.1;
        Tue, 21 Jan 2025 09:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737479735; x=1738084535; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QOJ9ZnoJLOm1w1HYnQlQZ3PT07vHbOVA08Cw2DmHMws=;
        b=hpdjv4ARl8sYrw21sjQUslfQVXilJ0J0GGAQF+McgU05n1SHLhZvybrroYm4RVXvWN
         MKpOA+C0keL9sPTP74wNaXc4cA5ZBI1aaOPerQKqpN9iQCI3DBRREZROG3g4gfR3rpQg
         6Upb+XBsES1KS1NoChGuMt23VK1XfFCXKsAoOHxTGHPX8V6VgvGZCvXU9lUPOZROYKdH
         qHoeEXKcVSeZhyeNGEgSV1Ijad35m5/NqW26qzT8rQOZxhZMClmJ99o0fyQP0lI44l6R
         1cGHnWGpqwapOg+8eq+kiKsL+Ac7NljdKu3WMsQ4JstChvt8b9LipkkmPhuztdD8nh3j
         kSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737479735; x=1738084535;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QOJ9ZnoJLOm1w1HYnQlQZ3PT07vHbOVA08Cw2DmHMws=;
        b=SifRofBDCVt2zhjfucvdqkSSB7pLLm3lAMLcC/zNctJlvIJcHCd3w6r4LV/0mwAy37
         55LI20N+aAtdBuqni6jflpOdbIxNl1MaZIBi4GlDwZxhXWhPoNW693ZQCDIR7t0+71xX
         lYsoHaxqh2p5LiWnqgnoQmlP+u9XfYMduYawx+Nm6ay+X444HiNXwUVZgLmfPprXQfaC
         fAQfWCzIqAUNcKtdJLhlaXJNxRj5KBSl4JX7hwk3d5gUbnxF7WZvcn63r8gNWG6VKE3e
         5x/JYGpAy9/pKYq1wpwm3ETbnFwJ1WeQ3OBK+IVLTXaq77cdiGMG5QtyTdS8UHngs9z3
         +hxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkoY8ejjl9JQguHD3FexHPKvZ1iqsaWl7uftn/eZymWALztxwnTxPB8WUyzts7sIkd3QM=@vger.kernel.org, AJvYcCWpVzzYpgqvH4gjgXDy4vwkgc14vr+yVsMrRo56njAkDtA1LfLNlIINBAYl3iB1hkNKtNO4Q3bNy/ENyFpi@vger.kernel.org
X-Gm-Message-State: AOJu0YwLayzVZucU16QycziGbGUX9UWxen0TrY5I0qQ909s+DAYYDEVy
	pMe+Mh5tLZuJJzG1ZhsTGQwmi9nHWOjJPWFkGMQSLad92IUBMGY9
X-Gm-Gg: ASbGncvm0Tjj2OrfFRWf1x7S4nRMrEEwlt++Y9BEijVMKehjgRhL0CFmI+xhYjnHxQl
	faFVLunRfMpCrAY7KK9LYn1QMcv3kQrFyH9M9pINkbd9luO0cc0DZBTDsqvggzeQ6Y9NJ6aLL6K
	hdhLlXXJ78ZLEvgNx9RFzUK3JuyAxadXtAjuH+yAeEbl0w8cLNLeYof4SUUpU5YRQkvCBW8gjTk
	5DU2wJDS3LEuxnSuYo2MS+AfcREtPRevUFjinstiHO9i267DVXQyWpr3yE7DKZIm4WZjVQchpY3
	SqehbG09/6kHC9fJgcIcnJsrXA==
X-Google-Smtp-Source: AGHT+IFGpQBIZtm6VxsQtXGIylwF3NqlikADjvJwNwKWcoy68WBKv+8jB8GdXYiyXtT61QAlM+hQ0g==
X-Received: by 2002:a05:6000:4008:b0:385:df2c:91b5 with SMTP id ffacd0b85a97d-38bf55bebd7mr17252503f8f.0.1737479735187;
        Tue, 21 Jan 2025 09:15:35 -0800 (PST)
Received: from [192.168.19.15] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf327556dsm13925896f8f.71.2025.01.21.09.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 09:15:34 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <4f788368-b8da-4e22-8028-b609975806a0@xen.org>
Date: Tue, 21 Jan 2025 17:15:33 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 04/10] KVM: x86: Set PVCLOCK_GUEST_STOPPED only for
 kvmclock, not for Xen PV clock
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20250118005552.2626804-1-seanjc@google.com>
 <20250118005552.2626804-5-seanjc@google.com>
 <f80fc36f-dd58-4934-9bc0-8e91352a36b2@xen.org> <Z4_U16jb7IbVdlLi@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <Z4_U16jb7IbVdlLi@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21/01/2025 17:09, Sean Christopherson wrote:
> On Tue, Jan 21, 2025, Paul Durrant wrote:
>>> ---
>>>    arch/x86/kvm/x86.c | 20 ++++++++++++++------
>>>    1 file changed, 14 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index d8ee37dd2b57..3c4d210e8a9e 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -3150,11 +3150,6 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
>>>    	/* retain PVCLOCK_GUEST_STOPPED if set in guest copy */
>>>    	vcpu->hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
>>> -	if (vcpu->pvclock_set_guest_stopped_request) {
>>> -		vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
>>> -		vcpu->pvclock_set_guest_stopped_request = false;
>>> -	}
>>> -
>>>    	memcpy(guest_hv_clock, &vcpu->hv_clock, sizeof(*guest_hv_clock));
>>>    	if (force_tsc_unstable)
>>> @@ -3264,8 +3259,21 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>>>    	if (use_master_clock)
>>>    		vcpu->hv_clock.flags |= PVCLOCK_TSC_STABLE_BIT;
>>> -	if (vcpu->pv_time.active)
>>> +	if (vcpu->pv_time.active) {
>>> +		/*
>>> +		 * GUEST_STOPPED is only supported by kvmclock, and KVM's
>>> +		 * historic behavior is to only process the request if kvmclock
>>> +		 * is active/enabled.
>>> +		 */
>>> +		if (vcpu->pvclock_set_guest_stopped_request) {
>>> +			vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
>>> +			vcpu->pvclock_set_guest_stopped_request = false;
>>> +		}
>>>    		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
>>> +
>>> +		vcpu->hv_clock.flags &= ~PVCLOCK_GUEST_STOPPED;
>>
>> Is this intentional? The line above your change in kvm_setup_guest_pvclock()
>> clearly keeps the flag enabled if it already set and, without this patch, I
>> don't see anything clearing it.
> 
> Oh, I see what you're getting at.  Hrm.  Yes, clearing the flag is intentional,
> otherwise the patch wouldn't do what it claims to do (set PVCLOCK_GUEST_STOPPED
> only for kvmclock).
> 
> Swapping the order of this patch and the next patch ("don't bleed ...") doesn't
> break the cycle because that would result in PVCLOCK_GUEST_STOPPED only being
> applied to the first active clock (kvmclock).
> 
> The only way I can think of to fully isolate the changes would be to split this
> into two patches: (4a) hoist pvclock_set_guest_stopped_request processing into
> kvm_guest_time_update() and (4b) apply it only to kvmclock, and then make the
> ordering 4a, 5, 4b, i.e. "hoist", "don't bleed", "only kvmclock".
> 
> 4a would be quite ugly, because to avoid introducing a functional change, it
> would need to be:
> 
> 	if (vcpu->pv_time.active || vcpu->xen.vcpu_info_cache.active ||
> 	    vcpu->xen.vcpu_time_info_cache.active) {
> 		vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
> 		vcpu->pvclock_set_guest_stopped_request = false;
> 	}
> 
> But it's not the worst intermediate code, so I'm not opposed to going that
> route.
> 

What about putting this change after patch 7. Then you could take a 
local copy of hv_clock in which you could set PVCLOCK_GUEST_STOPPED and 
so avoid bleeding the flag that way?

>>> +	}
>>> +
>>>    #ifdef CONFIG_KVM_XEN
>>>    	if (vcpu->xen.vcpu_info_cache.active)
>>>    		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
>>


