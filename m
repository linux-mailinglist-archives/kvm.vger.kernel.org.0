Return-Path: <kvm+bounces-37205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F70BA269F1
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 03:00:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A441116576E
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 02:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB7A07DA6D;
	Tue,  4 Feb 2025 02:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PDYCdZBg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2A078F49
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 02:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738634414; cv=none; b=m0MzI3zKK/riKqn5mqp5yB5tahBLCm6po9MdXTyDKPm7fx0+mLkxajr2vgtzVk/gmGHyXbBna85sSzimWfXXzIK3fasV3wOshr+14+tsufzciU9OIj76g4B9oa+23ly6Qr/T4D54xzJoI09fqbJBNv9aTD8w2E0/j2j61r+b/ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738634414; c=relaxed/simple;
	bh=LcUOXjH8eIbcE3PKBSEu/PpFrNnBo1CT9+chUuHKUB8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GdP4vxKsAOfm+FQ58spF2iJqLeouwM9+8QChG9ZHoKBXw9xU+HUr5WbLcNVB9HG3R57q9qQUI3u6ObUPqENOvyg/n1WSJLBos4ANlRVo7W6xOX/QIn/Uiq+mBNackHu7CvxarmZwZ29NImDFcfZWK0WaY7Wwtqx2zv+0ZYBKCHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PDYCdZBg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738634410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0LGY+6/g3x0XBxaXTlefV2q5SDTNkHreDKjZyKb49XA=;
	b=PDYCdZBgu2WVoSeSv08b4QzXYzE5vdnbInzSSbAadAg03u1WdZu3mZ5xQcX+7OA3xkPwTo
	g+2vcTNLvmlVf5X09AVSOZiQzbo6/0ZyAEflit+pBdU8KfohiuFP0SCXooCgo86pY5FcS9
	FhpSSTpZSCxAe794vu75kn1SmM2dEXc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-U5yuH1IaPZa-hCY5sXdhvQ-1; Mon, 03 Feb 2025 21:00:09 -0500
X-MC-Unique: U5yuH1IaPZa-hCY5sXdhvQ-1
X-Mimecast-MFC-AGG-ID: U5yuH1IaPZa-hCY5sXdhvQ
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6e4244f9de8so3108496d6.1
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 18:00:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738634409; x=1739239209;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0LGY+6/g3x0XBxaXTlefV2q5SDTNkHreDKjZyKb49XA=;
        b=IBs13jUpOLfKhskez03bttFxpVRczH9V6ZVo+BSYosQoGybLlNhvGedDbo6yvcFAtt
         8QAXz8W0Pnb0hYm3GCc5HNLVndmDBs8uZerlFMT4gNA1rL0dRn/AmRVh4BjnL1PtGnhC
         YV8KuO+clk3qDS816iAL+naa9fb+/Ikz8oI+W29M0VBk8x4rY6eKzNIs7TmoNkYdDHih
         /e7TX29Srl5/MxYA3MW7h7LA0ET85/lAXZ7EZc5cCxa8PNQbAQcqX+XXk6yKEzrJ8bFI
         d7KKoOnbLXy/aUblVD1uH5JUD9M5BnPj2Wgkh51Q4s8CBOXIJ0WlzOEfskriBSQzRRMK
         D9mw==
X-Forwarded-Encrypted: i=1; AJvYcCU1MwZBOjUdKl60osaZ2nkh6qRSnRKnyVo0EQDuQ169H+3JkeoP6cHxpzjWWmYOQKN5JaA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRJujWBSSw7WTGFPjsInvYchQTG/cB/VY16RQu9/ARntKpQHCh
	BvGdk+dNw19GjN+RFgFwjbTWZgBOCuhFT6euQkNOhAPmmEnbNkTZBxVWl3XJsEWzTdwy5d/2EK+
	e2cGZW7SKR0YG8kmDcD8XiAD8Xj1CDGkRjLrmd2MPvIo8WxXNYQ==
X-Gm-Gg: ASbGncs1gqkQH8JGL1pbwT1GjbLjjY4QIlpebYMEST3wmnz8J87DkzcuEFi0YNHSPrb
	+Wx5jPPOK11axuiqpKRjqYeruksmDj1t+jnS78Grt6pni0cfc5+E3qmK26W3PpgHG93IfE7PWsk
	rjckyoDX6NPvQVubxG7C4Q4F4Sl+NIqv0LdM5UQ/4cbumZfZr3wwG2bKHWAnCNUCSZOuGoAsVMI
	2PT6ZlW5FnebE13U44YGIO9zjrfw5FOMY1zwDAQDb41nk1fyzNDPjThAUJYltgk4Yc6FQJej4kB
	QC2e
X-Received: by 2002:a0c:aa10:0:b0:6e2:4b52:ee21 with SMTP id 6a1803df08f44-6e24b52ef3amr229229206d6.9.1738634408541;
        Mon, 03 Feb 2025 18:00:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHCeGl8IrpYydYNSTiAGp5mqvo57QRPgrWXedi9jJu3JucaqYaIT8IzzEz1g678fg0vmKpFjg==
X-Received: by 2002:a0c:aa10:0:b0:6e2:4b52:ee21 with SMTP id 6a1803df08f44-6e24b52ef3amr229228146d6.9.1738634406610;
        Mon, 03 Feb 2025 18:00:06 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e25495e831sm57070446d6.123.2025.02.03.18.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 18:00:06 -0800 (PST)
Message-ID: <30fc469b5b2ec5e2d6703979a0d09ad0a9df29e1.camel@redhat.com>
Subject: Re: [PATCH 2/3] KVM: x86: Remove use of apicv_update_lock when
 toggling guest debug state
From: Maxim Levitsky <mlevitsk@redhat.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Mon, 03 Feb 2025 21:00:05 -0500
In-Reply-To: <dc6cf3403e29c0296926e3bd8f0d4e87b67f4600.1738595289.git.naveen@kernel.org>
References: <cover.1738595289.git.naveen@kernel.org>
	 <dc6cf3403e29c0296926e3bd8f0d4e87b67f4600.1738595289.git.naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2025-02-03 at 22:33 +0530, Naveen N Rao (AMD) wrote:
> apicv_update_lock is not required when querying the state of guest
> debug in all the vcpus. Remove usage of the same, and switch to
> kvm_set_or_clear_apicv_inhibit() helper to simplify the code.

It might be worth to mention that the reason why the lock is not needed,
is because kvm_vcpu_ioctl from which this function is called takes 'vcpu->mutex'
and thus concurrent execution of this function is not really possible.

Besides this:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> ---
>  arch/x86/kvm/x86.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b2d9a16fd4d3..11235e91ae90 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12038,19 +12038,14 @@ static void kvm_arch_vcpu_guestdbg_update_apicv_inhibit(struct kvm *kvm)
>  	struct kvm_vcpu *vcpu;
>  	unsigned long i;
>  
> -	if (!enable_apicv)
> -		return;
> -
> -	down_write(&kvm->arch.apicv_update_lock);
> -
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		if (vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ) {
>  			set = true;
>  			break;
>  		}
>  	}
> -	__kvm_set_or_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_BLOCKIRQ, set);
> -	up_write(&kvm->arch.apicv_update_lock);
> +
> +	kvm_set_or_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_BLOCKIRQ, set);
>  }
>  
>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,





