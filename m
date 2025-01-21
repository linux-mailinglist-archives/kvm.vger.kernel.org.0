Return-Path: <kvm+bounces-36153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DBB3A18228
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:43:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2DCA7A529A
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0834E1F4E37;
	Tue, 21 Jan 2025 16:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vb9VaSIH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF8D1741D2;
	Tue, 21 Jan 2025 16:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737477784; cv=none; b=aq9IudjpE1PgSC+9jY6lXip/Uwbct6ytl79flBrB6DbjCVOLe7l/qTMkBFsDAhUSy695DAyjKTiBy+O1+xOKJIdAbhi/1DtIN3Zu0Fpo0POB6N7k8Ju4b8y9pGaMihWBW6vaifPIuB1zlsURQpr3BZ23zQU05FVnmD/N3zEMogY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737477784; c=relaxed/simple;
	bh=p6MMy2sxwQ1daQ/JIMFeQLNaU5ck4P4deJT7M7jlz0U=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=AWtMDJ0JoBsjijq/ixSATbFAJW+tnOJ+jYknF+1jJPkQ+J9MC5GvpV51E+cIUmHHeDgyV9ZJ7bnPKb2T3nOa1MSqjf6xSJCBqEKYn2Ml7/HJE6m4jrcMDQ5kDsQlUFPhSQoCTt3Bv3hgnn0x0y9YNovYKUDNIQKbWI+nv1RBcm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vb9VaSIH; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4368a293339so67736265e9.3;
        Tue, 21 Jan 2025 08:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737477781; x=1738082581; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FJQK4wB05xJxQYQrCn+kHt9jq+Wp1kqdmca/mz01tgQ=;
        b=Vb9VaSIHjpRSaqEs33gw4GEsvgXfPweBDOmMsrkFBpBhg2J56P5WKekt7atjcpXcGb
         Q1BEs+11mUZtX3LiH5/Xt29Uxf4/d8uw+rzzYYCj/ZjKeMb+e9+kjSxJfTqzOuJznTTh
         EUybelUwrlfBWJjGiil/JMzppvyBCktOhLDqJaYxkLLx6afM8ozhfBbu9kx+AI66Uxr8
         8//cS/7mnEpj0WJO6A6yvcde5rtwg8ZxG6yF7jNQ4anUEEQaQav+VYDweP7EdKWrgL+S
         lEiuokJsBspnAu/Md9jnuw6Y7qi1k19ONeDuuTIn+pbQuF7e0GpEs3Zhau1pNetj9VIY
         sznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737477781; x=1738082581;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FJQK4wB05xJxQYQrCn+kHt9jq+Wp1kqdmca/mz01tgQ=;
        b=XHxHCMWxkr6Pfw5mquU068DwB500OFGoyI9fIvqpHrlWNJ/pPBc/wrR+l1AWYePUf0
         IZWDJpUcOiYniEex9ZI5WWkp5xSAS/7EQRIYL22MFrLmQesrSyCEn1v+nQnJRRZlEaj4
         7B501rAK73o/TvwksVwKgTT4dK2x43JcVTfMolVZHBVz/7Q3HmJzPWh14Y7ynKIQEEtz
         S2kLf9kdPjBLQtqBOkjUeGY6Mi7UwAgNXP8WEk1BrLWpERFnkUOuqao4+ZbtDUV4hNk5
         lLJV9etLghmrTY/Ngj7ujCeZ1b3zmvwN6hwIrnJKuUI1sfBkS7ECOHMj9MZAJ7lv5bmj
         6pfA==
X-Forwarded-Encrypted: i=1; AJvYcCX1d9SW1F1c78B47sTy3NQzwBrcKks7U/5pzr7X1WQEWScy6hcC6qz82eIgcIZuqLE7MEjOrKO0kDHhm30=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKJ2MhELzshdPRxVvZ6A+sRRDD4td03752EgZU5dzmmcwL8aCG
	NhNFjc/xp3kGqj+BqXg04JamQMkwDGz/+77SEd1i/zRx5ZO1V/vb
X-Gm-Gg: ASbGncsxWVJ2zv0G78M67S+eeWyi8DvslQNpI7vtyWdfLdXipqZ4ZtTbvd4Cc4xHViD
	vMZ3qrC54PBRXliBoh+Oj8OgzkEP/3kEui4gS3mcOKL1r+tvd67TVwjnnXFljQPtmUxEGobMWr3
	1E6nPO5/V/1YbQyo/03/W6NPwXhx/eSNeOPXTe/QH864ETTsXEPlckPKSo2wmT/9kO6gucwBFgV
	jrm5tBoB3QFETJ1X3lcmQ+oCDP/c7WSC62a4I8npp864T0HCP5Oz5qNUqJ46vFqRoWwsRY6UkP9
	IC7ZWn45fS5vMS/Zk4rHJnWfwA==
X-Google-Smtp-Source: AGHT+IEiNeEYt7mm0jGcoZYIASFoUDLIrZsQrWUu2DNWg0tCfsP37zIKvlyGCJVip6dmtU3x16d9kw==
X-Received: by 2002:a05:600c:35c5:b0:436:ed38:5c85 with SMTP id 5b1f17b1804b1-438913df210mr184907975e9.14.1737477780532;
        Tue, 21 Jan 2025 08:43:00 -0800 (PST)
Received: from [192.168.19.15] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438904621cdsm184753565e9.27.2025.01.21.08.42.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 08:43:00 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <f80fc36f-dd58-4934-9bc0-8e91352a36b2@xen.org>
Date: Tue, 21 Jan 2025 16:42:59 +0000
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
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20250118005552.2626804-1-seanjc@google.com>
 <20250118005552.2626804-5-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250118005552.2626804-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/01/2025 00:55, Sean Christopherson wrote:
> Handle "guest stopped" propagation only for kvmclock, as the flag is set
> if and only if kvmclock is "active", i.e. can only be set for Xen PV clock
> if kvmclock *and* Xen PV clock are in-use by the guest, which creates very
> bizarre behavior for the guest.
> 
> Simply restrict the flag to kvmclock, e.g. instead of trying to handle
> Xen PV clock, as propagation of PVCLOCK_GUEST_STOPPED was unintentionally
> added during a refactoring, and while Xen proper defines
> XEN_PVCLOCK_GUEST_STOPPED, there's no evidence that Xen guests actually
> support the flag.

Indeed. I can find no consumers of the flag.

> 
> Check and clear pvclock_set_guest_stopped_request if and only if kvmclock
> is active to preserve the original behavior, i.e. keep the flag pending
> if kvmclock happens to be disabled when KVM processes the initial request.
> 
> Fixes: aa096aa0a05f ("KVM: x86/xen: setup pvclock updates")
> Cc: Paul Durrant <pdurrant@amazon.com>
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 20 ++++++++++++++------
>   1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d8ee37dd2b57..3c4d210e8a9e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3150,11 +3150,6 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
>   	/* retain PVCLOCK_GUEST_STOPPED if set in guest copy */
>   	vcpu->hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
>   
> -	if (vcpu->pvclock_set_guest_stopped_request) {
> -		vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
> -		vcpu->pvclock_set_guest_stopped_request = false;
> -	}
> -
>   	memcpy(guest_hv_clock, &vcpu->hv_clock, sizeof(*guest_hv_clock));
>   
>   	if (force_tsc_unstable)
> @@ -3264,8 +3259,21 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>   	if (use_master_clock)
>   		vcpu->hv_clock.flags |= PVCLOCK_TSC_STABLE_BIT;
>   
> -	if (vcpu->pv_time.active)
> +	if (vcpu->pv_time.active) {
> +		/*
> +		 * GUEST_STOPPED is only supported by kvmclock, and KVM's
> +		 * historic behavior is to only process the request if kvmclock
> +		 * is active/enabled.
> +		 */
> +		if (vcpu->pvclock_set_guest_stopped_request) {
> +			vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
> +			vcpu->pvclock_set_guest_stopped_request = false;
> +		}
>   		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
> +
> +		vcpu->hv_clock.flags &= ~PVCLOCK_GUEST_STOPPED;

Is this intentional? The line above your change in 
kvm_setup_guest_pvclock() clearly keeps the flag enabled if it already 
set and, without this patch, I don't see anything clearing it.

> +	}
> +
>   #ifdef CONFIG_KVM_XEN
>   	if (vcpu->xen.vcpu_info_cache.active)
>   		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,


