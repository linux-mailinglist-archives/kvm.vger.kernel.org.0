Return-Path: <kvm+bounces-40085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 329A7A4EFD3
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 23:01:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D3173AC30D
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 22:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7235427933A;
	Tue,  4 Mar 2025 21:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g3WsuEdo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD62278164
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 21:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741125528; cv=none; b=QfOzm10gdWVpWB9SmuuB4x7a0yA81665YgOCYLE8UxvLc1CYyDjWUXTlXSiehngwyDuzcXrKncSNw/kr3S5RlusQV9RnQt6VJ9Iu/Vp5ZUCy1i2IqSbJZ+Ej6QCagKIo+nU6fDvhhqUX86YQhR9CQBD1csoY01vR5IkuR0RP/6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741125528; c=relaxed/simple;
	bh=oSozo7BznZq14l5z/ZoFH+lJ1JJjswQ4w2zFnLW19RQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GAD1jL7Jwu6NqmLDCj046SuBbmdpdfMCju2jzBKkc65o0oOi4s5oZ9XM3jdUeV4SWzG+tSaaAhmsTONxOEkyqPdT8Zvvv8WHypBQ11pnMyNMj/fI2W0s5VAbuC7zMmTzliGg0BUV+ag7ERMbwgk3f89QR3D5gsEXTvsXcpBpKqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g3WsuEdo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe86c01f4aso11808616a91.2
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 13:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741125526; x=1741730326; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rU2M9OXwTVnYbkbyQeQ/NuCDqqxkxOkVZk19DIvCT9w=;
        b=g3WsuEdozEidoSVszolMaen8FvQEIjHsWRG69thS7oOYHL6Z1Bv80d918x9L/dl6tK
         b5TU+5OwqOnnu2hn9kuWl1pDg1uSN2KtbMSZnR9ClVM8BZbIiYf7ottjgm2Ig9yLX5nP
         XxxizzBkk0Ywvn8hBEhDBgCgNZG6T+mYFDJu+O/VOWbBeAqSD6goc36TT+8Z6gISzTjz
         9l03TloDOkr0FU0QhosipemWhEDlohpE81zyK9LFfISSaZ8xvbIVDzQWq0jhRE3TJ29Q
         YcWarntqDXltkQwFw1plHRPwRXInysOuxbCQKK+ytD4DttgrNWFCox5IBU9J/0GTRQZM
         SA+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741125526; x=1741730326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rU2M9OXwTVnYbkbyQeQ/NuCDqqxkxOkVZk19DIvCT9w=;
        b=nPlW1HktD+/2+vl1XrBEJdTWs/4odxZhnVvp0hcfgZxJlSKsdjGSzsPAHCLY1mCcuU
         4F2Z6dBa6fJ5AXnI7KYdG/cA7NL15up5IWXsK6dJFWepk2cuddSX6sGZ+vxrv9wAF5l2
         u3yoKGo9FXXJJ9jL+STs6p7F4edyTD9HUh7ngRSGU9U19kKCcHxYN/uCpQXGBbIsTlmi
         QuDPfj5is2RDQsZkKJBAH093XOy7P61/gFSMvVAcudcoVKcb0BUwTYGa7rOvTOVfiUX1
         PI5/87UrHu31qdC19NnnJdvfTGve6LRNwmNbdhmBPSKYzMAYOZp3o0msreWWXgjNOVDJ
         MvMA==
X-Forwarded-Encrypted: i=1; AJvYcCWfN/5zRY+Nmk1eUZbNeNmMJMG76wYCsR+ZYhLHqTYuxVynAPvA8eNV8BMWpw6jptJ8YNk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRlQmcmElHJmSF49D2H0AjmUsQY0R1ej3Q0X/HHqzteRownvpa
	P0dkMGZZoNbR8KQ7A38QECVu/yg/jeXeqFBIt7SXBzUNflGfzilq+JtijNJEang24nuP9b5pxkc
	uzw==
X-Google-Smtp-Source: AGHT+IFwhJrFtcLOUPHJp0NCI/99GBs81nXEXvmHLfhsmwGYjVBAdZr5LyhZb46FaL0Cxv1fDqlkY4W/+pM=
X-Received: from pjbrr3.prod.google.com ([2002:a17:90b:2b43:b0:2fc:1eb0:5743])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2643:b0:2ee:d7d3:3019
 with SMTP id 98e67ed59e1d1-2ff49728419mr1782201a91.12.1741125526427; Tue, 04
 Mar 2025 13:58:46 -0800 (PST)
Date: Tue, 4 Mar 2025 13:58:44 -0800
In-Reply-To: <217bc786-4c81-4a7a-9c66-71f971c2e8fd@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1740512583.git.ashish.kalra@amd.com> <27a491ee16015824b416e72921b02a02c27433f7.1740512583.git.ashish.kalra@amd.com>
 <Z8IBHuSc3apsxePN@google.com> <cf34c479-c741-4173-8a94-b2e69e89810b@amd.com>
 <Z8I5cwDFFQZ-_wqI@google.com> <8dc83535-a594-4447-a112-22b25aea26f9@amd.com>
 <Z8YV64JanLqzo-DS@google.com> <217bc786-4c81-4a7a-9c66-71f971c2e8fd@amd.com>
Message-ID: <Z8d3lDKfN1ffZbt5@google.com>
Subject: Re: [PATCH v5 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au, 
	michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org, 
	kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, aik@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 03, 2025, Ashish Kalra wrote:
> On 3/3/2025 2:49 PM, Sean Christopherson wrote:
> > On Mon, Mar 03, 2025, Ashish Kalra wrote:
> >> On 2/28/2025 4:32 PM, Sean Christopherson wrote:
> >>> On Fri, Feb 28, 2025, Ashish Kalra wrote:
> >>>> And the other consideration is that runtime setup of especially SEV-ES VMs will not
> >>>> work if/when first SEV-ES VM is launched, if SEV INIT has not been issued at 
> >>>> KVM setup time.
> >>>>
> >>>> This is because qemu has a check for SEV INIT to have been done (via SEV platform
> >>>> status command) prior to launching SEV-ES VMs via KVM_SEV_INIT2 ioctl. 
> >>>>
> >>>> So effectively, __sev_guest_init() does not get invoked in case of launching 
> >>>> SEV_ES VMs, if sev_platform_init() has not been done to issue SEV INIT in 
> >>>> sev_hardware_setup().
> >>>>
> >>>> In other words the deferred initialization only works for SEV VMs and not SEV-ES VMs.
> >>>
> >>> In that case, I vote to kill off deferred initialization entirely, and commit to
> >>> enabling all of SEV+ when KVM loads (which we should have done from day one).
> >>> Assuming we can do that in a way that's compatible with the /dev/sev ioctls.
> >>
> >> Yes, that's what seems to be the right approach to enabling all SEV+ when KVM loads. 
> >>
> >> For SEV firmware hotloading we will do implicit SEV Shutdown prior to DLFW_EX
> >> and SEV (re)INIT after that to ensure that SEV is in UNINIT state before
> >> DLFW_EX.
> >>
> >> We still probably want to keep the deferred initialization for SEV in 
> >> __sev_guest_init() by calling sev_platform_init() to support the SEV INIT_EX
> >> case.
> > 
> > Refresh me, how does INIT_EX fit into all of this?  I.e. why does it need special
> > casing?
> 
> For SEV INIT_EX, we need the filesystem to be up and running as the user-supplied
> SEV related persistent data is read from a regular file and provided to the
> INIT_EX command.
> 
> Now, with the modified SEV/SNP init flow, when SEV/SNP initialization is 
> performed during KVM module load, then as i believe the filesystem will be
> mounted before KVM module loads, so SEV INIT_EX can be supported without
> any issues.
> 
> Therefore, we don't need deferred initialization support for SEV INIT_EX
> in case of KVM being loaded as a module.
> 
> But if KVM module is built-in, then filesystem will not be mounted when 
> SEV/SNP initialization is done during KVM initialization and in that case
> SEV INIT_EX cannot be supported. 
> 
> Therefore to support SEV INIT_EX when KVM module is built-in, the following
> will need to be done:
> 
> - Boot kernel with psp_init_on_probe=false command line.
> - This ensures that during KVM initialization, only SNP INIT is done.
> - Later at runtime, when filesystem has already been mounted, 
> SEV VM launch will trigger deferred SEV (INIT_EX) initialization
> (via the __sev_guest_init() -> sev_platform_init() code path).
> 
> NOTE: psp_init_on_probe module parameter and deferred SEV initialization
> during SEV VM launch (__sev_guest_init()->sev_platform_init()) was added
> specifically to support SEV INIT_EX case.

Ugh.  That's quite the unworkable mess.  sev_hardware_setup() can't determine
if SEV/SEV-ES is fully supported without initializing the platform, but userspace
needs KVM to do initialization so that SEV platform status reads out correctly.

Aha!

Isn't that a Google problem?  And one that resolves itself if initialization is
done on kvm-amd.ko load?

A system/kernel _could_ be configured to use a path during initcalls, with the
approproate initramfs magic.  So there's no hard requirement that makes init_ex_path
incompatible with CRYPTO_DEV_CCP_DD=y or CONFIG_KVM_AMD=y.  Google's environment
simply doesn't jump through those hoops.

But Google _does_ build kvm-amd.ko as a module.

So rather than carry a bunch of hard-to-follow code (and potentially impossible
constraints), always do initialization at kvm-amd.ko load, and require the platform
owner to ensure init_ex_path can be resolved when sev_hardware_setup() runs, i.e.
when kvm-amd.ko is loaded or its initcall runs.

