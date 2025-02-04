Return-Path: <kvm+bounces-37216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30644A26E8D
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 10:34:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACC5F1669A8
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 09:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86BFA2080C9;
	Tue,  4 Feb 2025 09:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RpnaCvnT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5134207A37;
	Tue,  4 Feb 2025 09:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738661644; cv=none; b=geKlIzDFOKi+9a+c2L0Rd7sUwQ0eK3QxeNx8ce5ZmnysANiqs1aVwQAkCQdOZ+IYEgatM+INi4WDzoGOQJflXDGb+Gy7kcSw+BVG/svw9TJg3zXh1aZbVo6ss5xl1DkAmT/Z2VcPTqyNQVjye6+xUrV0Fx1HYn2oOqIIQm3WuHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738661644; c=relaxed/simple;
	bh=LvSf9ZnzGgZU8csMghgohPs+RUVEvG6gXl5psnx3fgg=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=VcZ9CIriSbB8NS7A7AFrUoVNLFhSoqJiEwCTLdHDWcH0yRKbNHzDZPev06RNYuoi4AOkiMEpKZrUNmJoglf8Lh8FJc4oMzk1mx14XJjWICwqJDH9Q6+s4Kw3x1+Y+tModopcBOoMyCsl6rApgbWk3bKvKWuTql8RMgqos+r5P8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RpnaCvnT; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5dc89df7eccso6420200a12.3;
        Tue, 04 Feb 2025 01:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738661641; x=1739266441; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6am5li9qHjYilVlqklWDH6xn57EjftSUlFntEeX3OrA=;
        b=RpnaCvnTIl6HB6eQqaTVljZ8KpVRFSJqJ6nF0Bgu6aJnAm4OKJepHRQBRqet+utSqr
         YF9elMvn6C1JiM1SAFvWpALRlJNgh4Ut0msu+njsU0tzyUBwEIvOf7M3Rfud9QYNvExK
         MtFAQ8g0mpC/nLcazm2CLGGzRisQ0LMEKvn24gJAvhFfufOdRqhHSkUwkB7410Gur2fF
         fM6UYloqeOjvXRmc8MXDC/DQmqtlZj93kJ9ywjyYC/7aKAPQmIxSsinHIq781opBI7sN
         ksuS458/TPQ3UjjkEWhIE8Lvd7CcTHTJPt+dxepvVxTwfvAE3HuIK8A1vi9BQiJIBJd/
         z53g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738661641; x=1739266441;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6am5li9qHjYilVlqklWDH6xn57EjftSUlFntEeX3OrA=;
        b=V1bgM4sH9V08oK967ifr7nohD2EsXozszm+yut5zvGrKnt56TWuFaKOLdkSFeSgV9D
         epem12i4WitBw9I2NOw4a0eYxIqubzGznSlqdd4F27P1stBFfh+Icto0eJb/VuKbXWxr
         NvngIJja162XVIimnEkn8YIh6e6myREIZFqVEOk9TeMN/VxM5LCZwrtBVxAdRVbF+JAQ
         ZFDt3SZx7ZrcOoAudow24U2/6u04LK2cfcD8Or39/30JF8KTpcRXFy7mAPlFFhFkrinq
         diUQlPxUiOT894xGMMJt04UfBiKsxOmzrUo4bdQIXmcn29yrlWNyHCu2dapvGXrRcvj9
         O5iA==
X-Forwarded-Encrypted: i=1; AJvYcCUDmp6EHsO+zdUkXvZ9kJ+ufxZ1anuBduIBOzpxfV9cZZzE89ceXQ0bXgLVyVsvsVCahq5RUi7ZOcmzWRY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0BnHMOxaDNk6eud+iYP7j2xLaWQBVAG6tdY99wX/CwXzQJtIH
	BvxeSp+0YImOebr/JS56sJ8F8kTMzsOTb8m+DJfzqPdyQw/B+yf7
X-Gm-Gg: ASbGnct2NJW7SfXAuLZIjfGZKxL60yKPO3EdOdG8BqIHyccyU/GY1KcRt/tulJUoTfv
	iqmHN7N1/7zekrfRBeSr2w1iS5hbqwHu+kW8U+5xUu0KIgpx6+QoXv4y13DOSnSM9pHvdTDJFxi
	BaDDUWVLjaaboqEUpDR4HubDDeC6YmCOMhbuLgCVlk/bn8HD4BPcB5i3vGUxQVmAbgak6tIxwvm
	b9pO8lmbp53rJPykPMoqUlwdJCiO92B+kihxbH66MWElihouFrPxGifv77lj2U+wSWN1m6KDvSa
	16O9cz7G2htsambfnam781Xqrpl690JwxSyzF60ognKwP6Y=
X-Google-Smtp-Source: AGHT+IGdGm6xfeJ1W8YgLtKygV4IfY0oCXzO6NAUIGZr8awA9dow4wzhv9LO02MQHpuFQwMYtPttog==
X-Received: by 2002:a17:907:6d18:b0:ab7:b30:42ed with SMTP id a640c23a62f3a-ab70b3042f7mr1456160466b.0.1738661640684;
        Tue, 04 Feb 2025 01:34:00 -0800 (PST)
Received: from [192.168.20.51] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e47ceadfsm897724666b.51.2025.02.04.01.33.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 01:34:00 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <792ae6f4-903f-41b2-a0f2-369d92a1fc3f@xen.org>
Date: Tue, 4 Feb 2025 09:33:59 +0000
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
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250201013827.680235-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/02/2025 01:38, Sean Christopherson wrote:
> Pass the reference pvclock structure that's used to setup each individual
> pvclock as a parameter to kvm_setup_guest_pvclock() as a preparatory step
> toward removing kvm_vcpu_arch.hv_clock.
> 
> No functional change intended.
> 
> Reviewed-by: Paul Durrant <paul@xen.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5f3ad13a8ac7..06d27b3cc207 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3116,17 +3116,17 @@ u64 get_kvmclock_ns(struct kvm *kvm)
>   	return data.clock;
>   }
>   
> -static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
> +static void kvm_setup_guest_pvclock(struct pvclock_vcpu_time_info *ref_hv_clock,
> +				    struct kvm_vcpu *vcpu,

So, here 'v' becomes 'vcpu'

>   				    struct gfn_to_pfn_cache *gpc,
>   				    unsigned int offset,
>   				    bool force_tsc_unstable)
>   {
> -	struct kvm_vcpu_arch *vcpu = &v->arch;
>   	struct pvclock_vcpu_time_info *guest_hv_clock;
>   	struct pvclock_vcpu_time_info hv_clock;
>   	unsigned long flags;
>   
> -	memcpy(&hv_clock, &vcpu->hv_clock, sizeof(hv_clock));
> +	memcpy(&hv_clock, ref_hv_clock, sizeof(hv_clock));
>   
>   	read_lock_irqsave(&gpc->lock, flags);
>   	while (!kvm_gpc_check(gpc, offset + sizeof(*guest_hv_clock))) {
> @@ -3165,7 +3165,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
>   	kvm_gpc_mark_dirty_in_slot(gpc);
>   	read_unlock_irqrestore(&gpc->lock, flags);
>   
> -	trace_kvm_pvclock_update(v->vcpu_id, &hv_clock);
> +	trace_kvm_pvclock_update(vcpu->vcpu_id, &hv_clock);
>   }
>   
>   static int kvm_guest_time_update(struct kvm_vcpu *v)
> @@ -3272,18 +3272,18 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>   			vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
>   			vcpu->pvclock_set_guest_stopped_request = false;
>   		}
> -		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
> +		kvm_setup_guest_pvclock(&vcpu->hv_clock, v, &vcpu->pv_time, 0, false);

Yet here an below you still use 'v'. Does this actually compile?

>   
>   		vcpu->hv_clock.flags &= ~PVCLOCK_GUEST_STOPPED;
>   	}
>   
>   #ifdef CONFIG_KVM_XEN
>   	if (vcpu->xen.vcpu_info_cache.active)
> -		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
> +		kvm_setup_guest_pvclock(&vcpu->hv_clock, v, &vcpu->xen.vcpu_info_cache,
>   					offsetof(struct compat_vcpu_info, time),
>   					xen_pvclock_tsc_unstable);
>   	if (vcpu->xen.vcpu_time_info_cache.active)
> -		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0,
> +		kvm_setup_guest_pvclock(&vcpu->hv_clock, v, &vcpu->xen.vcpu_time_info_cache, 0,
>   					xen_pvclock_tsc_unstable);
>   #endif
>   	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);


