Return-Path: <kvm+bounces-40025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E3DB4A4DE94
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 14:00:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E25C81896B73
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 13:00:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1DF620409B;
	Tue,  4 Mar 2025 13:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jv8mNw0s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B0378F33
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 13:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741093202; cv=none; b=HXV3zhScEf91Bebn1uMP9n4l8e9uQ44cp/yI2WIyKg0MZAgJLmJVVM5DGmjCmWu8nK9ouTgSriYgDA8SYcOug5dQoI0UhOB21zg+QqNN+dHH0i+rdgLMQgqmAWwXqW6GB7Y3NYFwyFxqcT20QzbGKtL+YC7jZ/FiI4AFQ1Nrwck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741093202; c=relaxed/simple;
	bh=8n0b19N4k88oTV+0CWK8ErwPE6M+xXUkDhITJJVj73Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nFd5xt7spoNXuooJTJRo0UL6uy+WEmQGXUXdBa6GzWEmNm34pVwnhtQfQWG0j7aNJkkSLKPjTrOigp1WBYpQOKT0d84oxbSeEHAthcGIN043AOmavZnybuf1mssj7DAyBnFAqMbK5FHNzidIRzBY2MPL48v23EmRjlS8MpMCghs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jv8mNw0s; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741093199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DHYNfO7wOdQLmm55pmQOPH3dGtE2gZNcuaLKTm02ejc=;
	b=Jv8mNw0sodFF6qTVT1jKJkOLfiZ4+tuGZ0aOdll3A4nhYU83o/2gy6L3/pa6kK/IOwnh4t
	gJH9pk6Cl+QXONtoz4JHi4YFQwzRqp3d6qvWNrnhiDiTJXOwkk28HA9UBrqH368D9YkXM8
	UAGN8h82BBSRq8KdcDFn/fCAbt3ePPw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-eaRtSlSiNU2PSIp-8-6Caw-1; Tue, 04 Mar 2025 07:59:56 -0500
X-MC-Unique: eaRtSlSiNU2PSIp-8-6Caw-1
X-Mimecast-MFC-AGG-ID: eaRtSlSiNU2PSIp-8-6Caw_1741093195
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-390de58dc4eso5288929f8f.0
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 04:59:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741093195; x=1741697995;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DHYNfO7wOdQLmm55pmQOPH3dGtE2gZNcuaLKTm02ejc=;
        b=vhDo785ypbvTIeKc4Yg1pRC5iZW7FZZIX3CnxBII9Jt+q5T1G9KKM58krWdkdSH9Y1
         R1rDWGsk66Ni9zQEPfIQ1oiW+FgXe2po9Ng5QuPTQGyySJAG/hnp7t6yZKvfX8dmD6my
         4Xhh2r0BQ/PYgbGlda1e4ldMwcF/UJy1YSgzpnmaJSnoOrvggS9+K9zYwbiWEv2Sky3v
         xuDr53MqQ8Hjw/DtxlYqRL1hwP4LPyEcWj2/Oc+rZ1lZPxRgX0YrHgZ71sfnLAHlBJ6e
         m4T75M4KrbkSI5zlR6AGPqNEOO/KccgsnUAgepbaswcxxoMwTJSkjlORXAqsU1CVKq+7
         qnTQ==
X-Gm-Message-State: AOJu0Yye9k/Qt01UYraUJD+IIfN0gA9ezbPY7A8bVs/uxmNXsyVlh39z
	s/ayTp/5gg1MQxywF7wOhysuaRuoiihv3dHArwTH8ss1TNY+6hIlk/ICuEdtor9+hZW0z4bhgcz
	84zOw1gxjXzzlxo2kxkyILnFAxpFlGnvGpQuAAjPN9TKGCXBXKw==
X-Gm-Gg: ASbGncsL3Cugj7Z6pB5puWJfmDg/ZjHI1RcP64/tgTAZCttSzD38nVNJoxFAhsnorRW
	7p5uEjgKfwq/e0fJCYKlhmwYodCfPA5p0btQCzcWvjngDyMf8kpUI8BzII/xTdsNmawyAho2psT
	3Bul6nmcLw6SIH6Dm8kBp0pfQMUFd8QrtAC9F41zpAi32WBc7Qe1r5KrIZGGH49jX7olBTc5mtM
	K4xK/ymy5whaBCHMV1kls43T7yam9eJAn56RmhmJUdH5C/puKwhYaA2AL4/SyYkZ3WtN/3o/xgU
	qzdsQtSWOXE=
X-Received: by 2002:a5d:64a1:0:b0:38d:dfb8:3679 with SMTP id ffacd0b85a97d-390ec7cdabemr14702338f8f.17.1741093195008;
        Tue, 04 Mar 2025 04:59:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFTPRu7i/PFI1l57JUzpOpX55q4Iy6EySkNQ2cm/5kvYEuhBy0AgYK+O3UhK/RTW8R7BHllPg==
X-Received: by 2002:a5d:64a1:0:b0:38d:dfb8:3679 with SMTP id ffacd0b85a97d-390ec7cdabemr14702315f8f.17.1741093194666;
        Tue, 04 Mar 2025 04:59:54 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e485db77sm17334901f8f.86.2025.03.04.04.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 04:59:54 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, Maciej S. Szmigiero
 <maciej.szmigiero@oracle.com>
Subject: Re: QEMU's Hyper-V HV_X64_MSR_EOM is broken with split IRQCHIP
In-Reply-To: <Z8ZBzEJ7--VWKdWd@google.com>
References: <Z8ZBzEJ7--VWKdWd@google.com>
Date: Tue, 04 Mar 2025 13:59:53 +0100
Message-ID: <87ikoposs6.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> FYI, QEMU's Hyper-V emulation of HV_X64_MSR_EOM has been broken since QEMU commit
> c82d9d43ed ("KVM: Kick resamplefd for split kernel irqchip"), as nothing in KVM
> will forward the EOM notification to userspace.  I have no idea if anything in
> QEMU besides hyperv_testdev.c cares.

The only VMBus device in QEMU besides the testdev seems to be Hyper-V
ballooning driver, Cc: Maciej to check whether it's a real problem for
it or not.

>
> The bug is reproducible by running the hyperv_connections KVM-Unit-Test with a
> split IRQCHIP.

Thanks, I can reproduce the problem too.

>
> Hacking QEMU and KVM (see KVM commit 654f1f13ea56 ("kvm: Check irqchip mode before
> assign irqfd") as below gets the test to pass.  Assuming that's not a palatable
> solution, the other options I can think of would be for QEMU to intercept
> HV_X64_MSR_EOM when using a split IRQCHIP, or to modify KVM to do KVM_EXIT_HYPERV_SYNIC
> on writes to HV_X64_MSR_EOM with a split IRQCHIP.

AFAIR, Hyper-V message interface is a fairly generic communication
mechanism which in theory can be used without interrupts at all: the
corresponding SINT can be masked and the guest can be polling for
messages, proccessing them and then writing to HV_X64_MSR_EOM to trigger
delivery on the next queued message. To support this scenario on the
backend, we need to receive HV_X64_MSR_EOM writes regardless of whether
irqchip is split or not. (In theory, we can get away without this by
just checking if pending messages can be delivered upon each vCPU entry
but this can take an undefined amount of time in some scenarios so I
guess we're better off with notifications).

>
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index c65b790433..820bc1692e 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2261,10 +2261,9 @@ static int kvm_irqchip_assign_irqfd(KVMState *s, EventNotifier *event,
>               * the INTx slow path).
>               */
>              kvm_resample_fd_insert(virq, resample);
> -        } else {
> -            irqfd.flags |= KVM_IRQFD_FLAG_RESAMPLE;
> -            irqfd.resamplefd = rfd;
>          }
> +        irqfd.flags |= KVM_IRQFD_FLAG_RESAMPLE;
> +        irqfd.resamplefd = rfd;
>      } else if (!assign) {
>          if (kvm_irqchip_is_split()) {
>              kvm_resample_fd_remove(virq);
>
>
> diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
> index 63f66c51975a..0bf85f89eb27 100644
> --- a/arch/x86/kvm/irq.c
> +++ b/arch/x86/kvm/irq.c
> @@ -166,9 +166,7 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
>  
>  bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
>  {
> -       bool resample = args->flags & KVM_IRQFD_FLAG_RESAMPLE;
> -
> -       return resample ? irqchip_kernel(kvm) : irqchip_in_kernel(kvm);
> +       return irqchip_in_kernel(kvm);
>  }
>  
>  bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
>
>

-- 
Vitaly


