Return-Path: <kvm+bounces-37237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 52AC9A2741A
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 15:09:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B31497A0517
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 14:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B039E211A08;
	Tue,  4 Feb 2025 14:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aqYkeUUn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED5120B816
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 14:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738678154; cv=none; b=KEpnjVm/f84AObTuCYkyTOo6prKX6LaJIOS2a0cW/9BqRskZnzJpYEBWgaLzwgCgzyvUAu5ESO+uKty/5nGkQM81aTgeFCL8CT6eaJ6zJB0+xg3kCdF8v5UKdxIa3ysXx32ZeswwMQmLYS6zNee27y6lAwae+VN1voa8j/7ed7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738678154; c=relaxed/simple;
	bh=MlUa2zxCd0aB619W1aP7OYYAf2mCp6vvyLgwFjXVIkI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BYCvfb1+k+wEneAu+ZPIApz8mHMz3IPEAbVldbBmPEe7ghmdYY8MXTPpwknKfA5t98SAwKzT2hC2j+J4/UilKIVaiEDxgX+ZF2+k2IDWsV2cZjBF4/V6a0SSXzEUZjjZ/wDUeek+F6baPVus7uhIFWZyoI4IU7jqD8cWYFoe+vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aqYkeUUn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738678151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x7AlNa/3Bz6jmXb0tV375qbZGznQyTRlRyEz/hMH7Vs=;
	b=aqYkeUUnREAnBzls0f84hsyChpToQxNl3kRYdkp1PnF6xLXi74lcwjdzCd0qnz5usJHs7L
	ei7i/KDc/Kgv+zT+kOIXf5OalMP1xBRosCauGR6WQu84Tx/YJvenHvAmmyP2qb6sD9H/lv
	34Gl1y652S7fX5N6lJZwkPxouwcnDiA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-pYiet_dvORifKya2kPRzug-1; Tue, 04 Feb 2025 09:09:10 -0500
X-MC-Unique: pYiet_dvORifKya2kPRzug-1
X-Mimecast-MFC-AGG-ID: pYiet_dvORifKya2kPRzug
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38bf4913669so2689097f8f.2
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 06:09:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738678149; x=1739282949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x7AlNa/3Bz6jmXb0tV375qbZGznQyTRlRyEz/hMH7Vs=;
        b=th3QDSaXT+h/XPcHAvuTv/zkCDRj8s1NsxNsdomzd9GT64O95Id7Ty+Bq5Y49+V7o/
         IFvspHfXFB2SfVaQYEyvPOhLrW0/y6NgfOY7AsE9XnuvPIUXYDz42jL+nCrZAfwE414X
         by17+vx6pSCiid0Tst4fVHCJyjJRHF94+0TmMb7KoCAheYN1kP1oja3Pej33m+1cCfRE
         OvbgkGsgZ4MeGON1Iw4KhMCB6WHog7N6qSO4KmUidKcTqzjMi59uPhc0LPMZYscxUnjO
         IETje/wzAjTxyTAl/oM+Zlf26uThI6j24LzxXtR4MY/3wMcPscrCWqzDPic4UR45RXuT
         Sb3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWlFU63jGhCk8YpWQ+q3AS2hGy9iGGRUKW8mcVDw69pva/QvZO+FAPF4NDRZNR60jOFtPg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSOFwdVvVsthERSeLqXPAd9XPYxHdAnb1jwBT3Eac4cB2SXljI
	lBVRLcdIKPZaCgsWd2ZnywTaOv22UUC1MjIJPBeEm27hJG+MCRpNd3QWhyuTamhv9+71pFCu6az
	3ukdFTJxip6GHM3++SANDQF9dAwOMIkUJq2LiE6QBO75A5msD34mKm3+TrLETo/6LFkVHJR1gcf
	T0fq/w0ktEzWwkyRT/QNh/caIhEdKzOhwyeZgKkA==
X-Gm-Gg: ASbGncvw/ELgV73Dt5sS5vsOGrrZLMTMA4J0vVSU9rb0IG0s2tvh0NQRITYfiCXKPkh
	M8U9oKB9QjWIMTS3PIpzMi+8vO4MSSuvSCu4mhRnnOZNMFCsLWZJa6+N+phO5
X-Received: by 2002:a05:6000:1a86:b0:385:e3b8:f331 with SMTP id ffacd0b85a97d-38c5194a53dmr22252179f8f.14.1738678148686;
        Tue, 04 Feb 2025 06:09:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFJ1Qeas8EuG2gcXr/z5JMp3AF9NG6ZBskqcgQ+BBboaMEhqCjuY/YvpHkRs9ilW/wqGX6fsVWoufp8Xue5k54=
X-Received: by 2002:a05:6000:1a86:b0:385:e3b8:f331 with SMTP id
 ffacd0b85a97d-38c5194a53dmr22252141f8f.14.1738678148306; Tue, 04 Feb 2025
 06:09:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1738595289.git.naveen@kernel.org> <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
 <Z6EOxxZA9XLdXvrA@google.com> <60cef3e4-8e94-4cf1-92ae-34089e78a82d@redhat.com>
 <Z6FVaLOsPqmAPNWu@google.com> <uroh6wvlhfj4whlf2ull4iob6k7nr4igeplcfvax7nksav6mtf@ek5ja23dkjtn>
In-Reply-To: <uroh6wvlhfj4whlf2ull4iob6k7nr4igeplcfvax7nksav6mtf@ek5ja23dkjtn>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 4 Feb 2025 15:08:57 +0100
X-Gm-Features: AWEUYZlNHP3jcjLj3SOzsU6bYvRIb5qLwSJD-N1WfXtldQIwbQl6m8rjvi-VNqA
Message-ID: <CABgObfbZYBRx96Cye9HdF=TMkrVMcGa7hJiyYZ4KY3WvbD+4nw@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86: Decouple APICv activation state from apicv_inhibit_reasons
To: Naveen N Rao <naveen@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 12:15=E2=80=AFPM Naveen N Rao <naveen@kernel.org> wr=
ote:
> As a separate change, I have been testing a patch that moves the
> PIT_REINJ inhibit from PIT creation to the point at which the guest
> actually programs it so that default guest configurations can utilize
> AVIC:

In-kernel PIC and PIT is sort of a legacy setup; the so-called
"split irqchip" (LAPIC in KVM, PIC/PIT in userspace) is strongly
preferred.  So I don't think it's particularly important to cater
for PIT_REINJ.

> If it is, or if we choose to delay PIT_REINJ inhibit to vcpu creation tim=
e,
> then making PT_REINJ or IRQWIN inhibits sticky will prevent AVIC from bei=
ng
> enabled later on. I can see in my tests that BIOS (both seabios and edk2)
> programs the PIT though Linux guest itself doesn't (unless -no-hpet is us=
ed).

Even with -no-hpet, Linux should turn off the PIT relatively soon
and only rely on the local APIC's timer.

> You're right -- APICv isn't actually being toggled, but IRQWIN inhibit is
> constantly being set and cleared while trying to inject device interrupts=
 into
> the guests. The places where we set/clear IRQWIN inhibit has comments
> indicating that it is only required for ExtINT, though that's not actuall=
y the
> case here.
>
> What is actually happening is that since the PIT is in reinject mode, API=
Cv is
> not active in the guest. When that happens, kvm_cpu_has_injectable_intr()
> returns true when any interrupt is pending:
>
>     /*
>      * check if there is injectable interrupt:
>      * when virtual interrupt delivery enabled,
>      * interrupt from apic will handled by hardware,
>      * we don't need to check it here.
>      */
>     int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v)
>     {
>             if (kvm_cpu_has_extint(v))
>                     return 1;
>
>             if (!is_guest_mode(v) && kvm_vcpu_apicv_active(v))
>                     return 0;
>
>             return kvm_apic_has_interrupt(v) !=3D -1; /* LAPIC */
>     }
>
> The second if condition fails since APICv is not active. So,
> kvm_check_and_inject_events() calls enable_irq_window() to request for an=
 IRQ
> window to inject those interrupts.

Ok, that's due solely to the presence of *another* active inhibit.
Since sticky inhibits cannot work, making the IRQWIN inhibit per-CPU
will still cause vCPUs to pound on the apicv_update_lock, but only on
the read side of the rwsem so that should be more tolerable.

Using atomics is considerably more complicated and I'd rather avoid it.

Paolo


