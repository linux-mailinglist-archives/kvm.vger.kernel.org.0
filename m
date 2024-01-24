Return-Path: <kvm+bounces-6886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DB1383B5C5
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 00:59:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BAD51C23452
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 23:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C42E8136678;
	Wed, 24 Jan 2024 23:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cVqP6DW6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE1A136656
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 23:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706140779; cv=none; b=JpMhWZ5tKSBEPxylX8zYX651c4kAMyAHguO6uJ0Ec/ZsPwbnn1liDrUYyqVK8FQO9VKImu3L9/JK6HuOLOGFu0CkcjpNakiQ2VH9x3u6zkVbZGkMqSAMW6G0P25yoJoM9J8HV6rxjCPq4TIGx+O7vp7ZZ/GYrtT6Z2ZA5J8Jy6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706140779; c=relaxed/simple;
	bh=scENOXkY1wABPly8RGgZYqWRLrty6coqRZ73vXcMm0U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r8wOlQMGdIeaZKxzz5Uo9SWHUg6F568txLp4uOwOaz6gNFGSpbDffbuGFVubaxzVCE6wbTfPRpT0arPw8AAj3vDrn+MPd74v1AO1dwjBsv6H6iwDE26+4bXXZUGERHI9dqUiuZYvU6fXgdhZJ863+dnFWAOYR7uVkogQAOB/+kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cVqP6DW6; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cec8bc5c66so3519081a12.1
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 15:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706140776; x=1706745576; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KYf0G/iha9uYMgJquZY7B6AN3rc0OYW7kIi56vMpuic=;
        b=cVqP6DW6KlEZIfiEtqNmIKPCOb5YpqXTFyL4oJjndFSrV5eS9GBSIynYCrpk0gGrs8
         hWB8UincBVEDsXgKsdluRiiKaSY+btWe0kM/eSd8beNKVsvxqqSyWpqwYScXiop4HcOc
         OJ/7I+cBJo2oVPCtUY9mxleIbXg7CtqWUXLHqwMVXeVI9Ea7iwDX+6J8B6MK6eJxC6J3
         kZ3KhSbIHq5UUN8MHk+eMiQvj4IU7bq4UZFKprqyWD9qXNfskz02z4eXTL3+VQuEex7A
         ghXXwh3BEbD/FHcxN7ek4Z7guJCmEQZmuBCAWjXmFgQYr/t6x6aLgeIL7dJbZT4PYhpt
         N8pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706140776; x=1706745576;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KYf0G/iha9uYMgJquZY7B6AN3rc0OYW7kIi56vMpuic=;
        b=ExXuXxkD8OK8ucHBWnn3Ep1GrCf8YhZfZkQy6nYqyNQNWLtMAesFMLjvpBuIwIY8Mf
         wtKMtIHIJPK+QldQugzES5i1RslCWDDYSaUeL0T8GA/RqqHf8lU6DMzptBR4pRYISHt+
         eAVdycUbtlD6l2tBEdyloJPUmK/zrLNwGZU7jKguc0uArZj0xmbGZvEO5FwOTXRN8xEW
         IbyF1GJ6jjdZEtptMXO/8DzczIhnNkdds8hzcY74QQNjQnY624Ejd5WaXjTk2fuV7pS0
         +6/My1RqsquHRtdD7tnjrDINAESta+gF7Ya0qr7VZJzQ5sscMFULp4aatZRLbWuBF5S6
         Dzyg==
X-Gm-Message-State: AOJu0Yw5/fFOu/HRQLdDi68Nf21rm+IPxw0dylcRxs9ks1LZuZdmQerW
	WdHNbHLYhbCM6wnUnFKR56sjUk3W+hWetJSmiaCHjve/hFS7cpRtV3l4Zykuh/awEyNF0aIStIp
	mdg==
X-Google-Smtp-Source: AGHT+IGriMVgnsOLni0yAcaVoR6zDhSN+dZ55FV93lTp2LIDR22wkfjbtYKhrBRkbGfhxNjinrpfLzqmaUU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:59d:b0:5cd:fa8d:f3e1 with SMTP id
 by29-20020a056a02059d00b005cdfa8df3e1mr9pgb.4.1706140776563; Wed, 24 Jan 2024
 15:59:36 -0800 (PST)
Date: Wed, 24 Jan 2024 15:59:34 -0800
In-Reply-To: <20240124190158.230-1-moehanabichan@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZbFMXtGmtIMavZKW@google.com> <20240124190158.230-1-moehanabichan@outlook.com>
Message-ID: <ZbGkZlFmi1war6vq@google.com>
Subject: Re: Re: Re: [PATCH] KVM: x86: Check irqchip mode before create PIT
From: Sean Christopherson <seanjc@google.com>
To: Brilliant Hanabi <moehanabichan@gmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 25, 2024, Brilliant Hanabi wrote:
> > On Thu, Jan 25, 2024, moehanabi wrote:
> > > > On Thu, Jan 25, 2024, Brilliant Hanabi wrote:
> > > > > As the kvm api(https://docs.kernel.org/virt/kvm/api.html) reads,
> > > > > KVM_CREATE_PIT2 call is only valid after enabling in-kernel irqchip
> > > > > support via KVM_CREATE_IRQCHIP.
> > > > > 
> > > > > Without this check, I can create PIT first and enable irqchip-split
> > > > > then, which may cause the PIT invalid because of lacking of in-kernel
> > > > > PIC to inject the interrupt.
> > > > 
> > > > Does this cause actual problems beyond the PIT not working for the guest?  E.g.
> > > > does it put the host kernel at risk?  If the only problem is that the PIT doesn't
> > > > work as expected, I'm tempted to tweak the docs to say that KVM's PIT emulation
> > > > won't work without an in-kernel I/O APIC.  Rejecting the ioctl could theoertically
> > > > break misconfigured setups that happen to work, e.g. because the guest never uses
> > > > the PIT.
> > > 
> > > I don't think it will put the host kernel at risk. But that's exactly what
> > > kvmtool does: it creates in-kernel PIT first and set KVM_CREATE_IRQCHIP then.
> > 
> > Right.  My concern, which could be unfounded paranoia, is that rejecting an ioctl()
> > that used to succeed could break existing setups.  E.g. if a userspace VMM creates
> > a PIT and checks the ioctl() result, but its guest(s) never actually use the PIT
> > and so don't care that the PIT is busted.
> 
> Thanks for your review. In my opinion, it is better to avoid potential bugs
> which is difficult to detect, as long as you can return errors to let
> developers know about them in advance, although the kernel is not to blame
> for this bug.

Oh, I completely agree that explict errors are far better.  My only concern is
that there's a teeny tiny chance that rejecting an ioctl() that used to work
could break userspace.

> > > I found this problem because I was working on implementing a userspace PIC
> > > and PIT in kvmtool. As I planned, I'm going to commit a related patch to 
> > > kvmtool if this patch will be applied.
> > > 
> > > > > Signed-off-by: Brilliant Hanabi <moehanabichan@gmail.com>
> > > > > ---
> > > > >  arch/x86/kvm/x86.c | 2 ++
> > > > >  1 file changed, 2 insertions(+)
> > > > > 
> > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > index 27e23714e960..3edc8478310f 100644
> > > > > --- a/arch/x86/kvm/x86.c
> > > > > +++ b/arch/x86/kvm/x86.c
> > > > > @@ -7016,6 +7016,8 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> > > > >  		r = -EEXIST;
> > > > >  		if (kvm->arch.vpit)
> > > > >  			goto create_pit_unlock;
> > > > > +		if (!pic_in_kernel(kvm))
> > > > > +			goto create_pit_unlock;
> > > > 
> > > > -EEXIST is not an appropriate errno.
> > > 
> > > Which errno do you think is better?
> > 
> > Maybe ENOENT?
> >
> 
> I'm glad to send a new version patch if you're willing to accept the
> patch.

Go ahead and send v2.  I'll get Paolo's thoughts on whether or not this is likely
to break userspace and we can go from there.

