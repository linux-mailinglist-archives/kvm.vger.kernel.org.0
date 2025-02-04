Return-Path: <kvm+bounces-37203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DD979A269CD
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 02:29:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 319247A213A
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 01:27:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89A7513C3F6;
	Tue,  4 Feb 2025 01:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RBSy4bZT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A0C78F37
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 01:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738632221; cv=none; b=RnLtGXd6BTo8WGAe4kXZS58+LPNJwJfywJgp6rR8M74xLS+0Pckl7eZsCCb4wWhuPbT/ZTzgBbWGGGmXhjuQHKdU/mlkWeAGH/fQKPe4632l1y3jZ2CjgkN9OYE/a6exOfWIVaSFZElWfNnVuGvwy2jlLUEasnO+Z3pETOyaV7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738632221; c=relaxed/simple;
	bh=cOpTxEufk2fJx6WpgJqhe0pQwrDVrQLtuM3AJEZw05s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LH5qn5HpDzA/EKmTiCyAW62IdtuMdH40FKoXpnAgpLCbQMlqM1PRr5bX8UWjiyS8Wib1Pn9Onea3mZSg4LXdmQi59ItuuPWQMUkaytLBiSoEXOIZY2IO+VMkHXJbjLEYQQGfndc9n0qLGUWNRq2Et10XUern1awmSH7NSfiO9WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RBSy4bZT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738632218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FfjLQH0ugfJpeoQ4yGzWnUgAvVZA+tG6GNbkZhovQWY=;
	b=RBSy4bZTwMG4UjJEu6EpFCAMH1aXw1qmM3toK+eVlsBi3QX/dIPYsG+waquokx/qzdO786
	MSYfX73Htfk3H2F/2nvrZsCyStQY5qlGyB5+LHYvStlsWfCqNJfc77x8Va6yUGg9ZL+R7C
	xdxU8WaFsnqXs7H16H6yuehDoOckbjY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-myWPEHSPNVaXv27uAIo4PQ-1; Mon, 03 Feb 2025 20:23:37 -0500
X-MC-Unique: myWPEHSPNVaXv27uAIo4PQ-1
X-Mimecast-MFC-AGG-ID: myWPEHSPNVaXv27uAIo4PQ
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7b6e1b036e9so478112885a.1
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 17:23:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738632216; x=1739237016;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FfjLQH0ugfJpeoQ4yGzWnUgAvVZA+tG6GNbkZhovQWY=;
        b=Aqkw5bKvvKOPjFDhfsmlk4HEb1FBkjoaKaLEkaB6P53oDrPAHpZhVFrsEJkliX8Lu5
         VkEqX7eyIorkk0EN9AYhGbglzvGUWPq1klkb1CrbUeAt8onv3eUOLimaoybCt7D2Enno
         NiYn2mif/rIgGp8z7q6De9Bp4S0nxZVCE1YB1jbtvwwcJ4VvzLE+TXK6Anwutq3XdaRG
         UC3ahZLz+hHLJSdyP9O6PhmU84LGbvU8h9cRqOBhv32fvV02kCEApkhFiWz57xAs5Dw7
         52pPPwkNIdKyQauIYrDdtbT2+Jna+8j6pn0ipmhjfkTdg6gWfu2wdt3Eav5mspwYCBEh
         Z53A==
X-Forwarded-Encrypted: i=1; AJvYcCUqIx24g8gtAAFOJDx9yMVRTm98bOZ9rWr9upTL2g2xcG2T5W+T4UBkUFtPchunAHSv+zM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8LXKQPfOcyZcO8wOib8seosH1vI+5DvRr9SgE3TbpuKNwVEtP
	Ck/68joqLv0htZJ2xG5z28vtK096SffJIxfNBYjADlT5zmyC0S6m3P9nAO8/vIjPYiNLUcampkH
	fLsrdh+LjbfzivAyI8ygw9IKOpls981BfdG+uMlDigbGR8FfqqA==
X-Gm-Gg: ASbGncuwHz5GywUdQ0yR2ZsNScDRbun2DdUY+iUyiPH3YXdcAIw7Ps9DV/Y0WIMBueW
	x6s7hunU6PuzR0w+6vEEpTCI9FJX3GRYi7oO6CvS1+nyVJt8/Gt0DQWCSiicN1Yr5o2AYtv5EmU
	MkBAZim06/6pTrNzzPB0mNQOYYg2m9kLiRFMtR+1ss+6mC7Kx6LffKNEiD8rcK6hh9lBLlRZ4B3
	YrK2y7xVxrlGr6idPm/bHcI4QOiP8ekHncX3Fi4EKh9uvp5HId3v9F4L35DRV4bLWnMDu09soMF
	VXVp
X-Received: by 2002:a05:620a:2a10:b0:7b6:deab:d485 with SMTP id af79cd13be357-7bffcce52c5mr3094047285a.16.1738632216356;
        Mon, 03 Feb 2025 17:23:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHz1LWLrTgjblfuYTzFwvitmeKL74EinqFy/6HNwfAWhRpjwdT4DQgR+/gydnf6s85MBC70yQ==
X-Received: by 2002:a05:620a:2a10:b0:7b6:deab:d485 with SMTP id af79cd13be357-7bffcce52c5mr3094044785a.16.1738632216039;
        Mon, 03 Feb 2025 17:23:36 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c00a8bbe3asm589043585a.15.2025.02.03.17.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 17:23:35 -0800 (PST)
Message-ID: <0e4bd3004d97b145037c36c785c19e97b6995d42.camel@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86: Decouple APICv activation state from
 apicv_inhibit_reasons
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: "Naveen N Rao (AMD)" <naveen@kernel.org>, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Mon, 03 Feb 2025 20:23:34 -0500
In-Reply-To: <Z6FVaLOsPqmAPNWu@google.com>
References: <cover.1738595289.git.naveen@kernel.org>
	 <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
	 <Z6EOxxZA9XLdXvrA@google.com>
	 <60cef3e4-8e94-4cf1-92ae-34089e78a82d@redhat.com>
	 <Z6FVaLOsPqmAPNWu@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2025-02-03 at 15:46 -0800, Sean Christopherson wrote:
> On Mon, Feb 03, 2025, Paolo Bonzini wrote:
> > On 2/3/25 19:45, Sean Christopherson wrote:
> > > Unless there's a very, very good reason to support a use case that generates
> > > ExtInts during boot, but _only_ during boot, and otherwise doesn't have any APICv
> > > ihibits, I'm leaning towards making SVM's IRQ window inhibit sticky, i.e. never
> > > clear it.
> > 
> > BIOS tends to use PIT, so that may be too much.  With respect to Naveen's report
> > of contention on apicv_update_lock, I would go with the sticky-bit idea but apply
> > it to APICV_INHIBIT_REASON_PIT_REINJ.
> 
> That won't work, at least not with yet more changes, because KVM creates the
> in-kernel PIT with reinjection enabled by default.  The stick-bit idea is that
> if a bit is set and can never be cleared, then there's no need to track new
> updates.  Since userspace needs to explicitly disable reinjection, the inhibit
> can't be sticky.
I confirmed this with a trace, this is indeed the case.

> 
> I assume We could fudge around that easily enough by deferring the inhibit until
> a vCPU is created (or run?), but piggybacking PIT_REINJ won't help the userspace
> I/O APIC case.
> 
> > I don't love adding another inhibit reason but, together, these two should
> > remove the contention on apicv_update_lock.  Another idea could be to move
> > IRQWIN to per-vCPU reason but Maxim tells me that it's not so easy.

I retract this statement, it was based on my knowledge from back when I implemented it.

Looking at the current code again, this should be possible and can be a nice cleanup regardless.

(Or I just might have forgotten the reason that made me think back then that this is not worth it,
because I do remember well that I wanted to make IRQWIN inhibit to be per vcpu)

Basically to do so we need to introduce per-vcpu inhibit field (instead of .vcpu_get_apicv_inhibit_reasons callback)
set the inhibit bit there in svm_enable_irq_window, and raise KVM_REQ_APICV_UPDATE.

Same thing in interrupt_window_interception().

Nested code can be updated to do so as well very easily. IMHO this is a very nice cleanup.

I'll prepare a patch soon for this.

Also regardless, I strongly support Paolo's idea to inhibit APICv/AVIC when more than one ExtINT entry is
enabled, although this might not be enough:

In fact multiple vCPUs with ExtINT enabled I think can trigger the WARN_ON_ONCE below:

kvm_cpu_has_extint will be true on both vCPUs, so kvm_cpu_has_injectable_intr will be true on both
vCPUs as well, and thus both vCPUs can try to pull the interrupt from PIC, with second one likely getting -1,
and that not to mention the possibility of corrupting PIC state due to the concurrent access.


I am talking about this code:


	if (kvm_cpu_has_injectable_intr(vcpu)) {
		r = can_inject ? kvm_x86_call(interrupt_allowed)(vcpu, true) :
				 -EBUSY;
		if (r < 0)
			goto out;
		if (r) {
			int irq = kvm_cpu_get_interrupt(vcpu);

			if (!WARN_ON_ONCE(irq == -1)) {
				kvm_queue_interrupt(vcpu, irq, false);
				kvm_x86_call(inject_irq)(vcpu, false);
				WARN_ON(kvm_x86_call(interrupt_allowed)(vcpu, true) < 0);
			}
		}
		if (kvm_cpu_has_injectable_intr(vcpu))
			kvm_x86_call(enable_irq_window)(vcpu);
	}


So we might need to do something stronger than only inhibiting APICv/AVIC, we might
want to ignore second ExtINT entry, or maybe even better ignore both ExtInt entries and refuse to deliver ExtINT at all? 
(the guest is broken (Intel says that this configuration is frowned upon), so IMHO it deserves to keep both pieces. Do you agree?)


Best regards,
	Maxim Levitsky



> 
> Oh, yeah, that reminds me of the other reason I would vote for a sticky flag:
> if inhibition really is toggling rapidly, performance is going to be quite bad
> because inhibiting APICv requires (a) zapping APIC SPTEs and (b) serializing
> writers if multiple vCPUs trigger the 0=>1 transition.
> 
> And there's some amount of serialization even if there's only a single writer,
> as KVM kicks all vCPUs to toggle APICv (and again to flush TLBs, if necessary).
> 
> Hmm, something doesn't add up.  Naveen's changelog says:
> 
>   KVM additionally inhibits AVIC for requesting a IRQ window every time it has
>   to inject external interrupts resulting in a barrage of inhibits being set and
>   cleared. This shows significant performance degradation compared to AVIC being
>   disabled, due to high contention on apicv_update_lock.
> 
> But if this is a "real world" use case where the only source of ExtInt is the
> PIT, and kernels typically only wire up the PIT to the BSP, why is there
> contention on apicv_update_lock?  APICv isn't actually being toggled, so readers
> blocking writers to handle KVM_REQ_APICV_UPDATE shouldn't be a problem.
> 
> Naveen, do you know why there's a contention on apicv_update_lock?  Are multiple
> vCPUs actually trying to inject ExtInt?
> 



