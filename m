Return-Path: <kvm+bounces-35498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA67A117A9
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 04:06:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78FAB7A409C
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 03:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16CEF22DFB4;
	Wed, 15 Jan 2025 03:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l1W/s/p0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D336E212D68
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 03:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736910384; cv=none; b=G8+3gTXMvI7lCu7IO08t6cqN9QDKBGfmFenAcf5JeHKDafNBX+bnY8xsBpL8wRz6P2kIoZ2lhlWeQr9wHy+7qWFcFG7ZC9bXgAQPildnPx0Ydby90tqbEH3xmfhb57v1Ra+wnUFkQEsOez9STwEV/uEkkN0oL7+5Y5cnU5POwGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736910384; c=relaxed/simple;
	bh=EEC74rFlUByCYtLzJ41uJsbUpp21IUPfG5TyTOrVuV4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p6exptp6Q3NQD99VQaiQdXzlGC3xSvQxrhKX8YH5eVa82ciyM6zeV6CC5LytCXNmxbcDWa4mHcPX6plIhHPoPTxIiTDtukteVMITJqq9RXC4AZfdog4Nn+pzVN9RqCafelcjHPVY13uem3jb/PtfBJV25UkIavXEzR5z1sQHq6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l1W/s/p0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f46b7851fcso17408280a91.1
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 19:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736910382; x=1737515182; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0IgGXI2mM2uHHPaOdnwW+AtakjIGYBXWPGxxnTIex44=;
        b=l1W/s/p01TYpxdFzVeFRoUo6ZRocAa26dPJyhm4fUS4xg6V8/Ez8JImNyICUSkPIWe
         CxQdi0uIvQNLkmb0UfzlGzmwIzeMpVTjWF5jQNW1Y3qpLH/qto5m8XKNHVyselp1vXEp
         Kd6kNNMc0E9iLvnMqRpa6+LNcsfxYTWQhAjm+dmc6/FQ7UlP1OR8Tm0meK3qSKaiHdDx
         E2PuC7elh548wB7PtHIe45z/12aTwQh156g4b6qbC84Vj7Y6MZnYwPGSqJ/+WCPggWWl
         w/lUqKerJf5ZYK/Qcl794tM8hg0sdJDY/jlx6/6TqzyDCP35prOZ6KAOhrnPfQ4sOuXO
         oyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736910382; x=1737515182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0IgGXI2mM2uHHPaOdnwW+AtakjIGYBXWPGxxnTIex44=;
        b=YN3kDPKf27pV0vL7Bxm3dYuPojuX1OA4C10FzW4XpY3+qdMV/502vv0fu98gMcJ/5Q
         9RpO7LtHi0RdhYzpum7H034F7MF1PpRjwXAVX4SVBVJ22KelyzEBCDyfD+4ILv2KX3mY
         tcbWVzXoDH9F+AlpN13eQLfI0mwgCZqvFubYW3L61Vai5bjr62b9F/U94DcUUIhUCzdE
         QFF8/LE+x9etnfTR5oJzHcnQjQVasgqyzxx6n66MBbk/b4FnyYezKvJZadPH8L9N3Zhd
         3tNeLYR40h74L451IL43ambvNUnGOMvmPIIcgDlF+wrLwPzRuyDHPMzQ4hzrGgSQdYPp
         Y2ng==
X-Forwarded-Encrypted: i=1; AJvYcCV/56z7MB8sesBVeb54IHCiv07kkk/YD7PWH/NIebVbdcKt1S19hzhdX4Z6l6hB2ZjvfdY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaXXjeS3p2Epki6hTGucIRr6kstr1NDZomzdCx7zHZaagowOiW
	3HwntrDB9cGXhQrT1BW2RWwqzNapkyG+nYctRmP9F+FG7cwW7cAA3OVPIH4mYvSCgIRUMVy1j8s
	3zg==
X-Google-Smtp-Source: AGHT+IHtpD0Tau+LdhYqQEB+5TGJMm1AvQPFGKVD1x6X+saCf4pKDrwRrPk1PzPjdS6sxPJm87sX0iY2YPg=
X-Received: from pja13.prod.google.com ([2002:a17:90b:548d:b0:2ef:9ef2:8790])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:538e:b0:2ee:c4f2:a76d
 with SMTP id 98e67ed59e1d1-2f548f59a46mr36072918a91.21.1736910382268; Tue, 14
 Jan 2025 19:06:22 -0800 (PST)
Date: Tue, 14 Jan 2025 19:06:20 -0800
In-Reply-To: <0862979d-cb85-44a8-904b-7318a5be0460@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241108130737.126567-1-pbonzini@redhat.com> <Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com>
 <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com> <Z2RhNcJbP67CRqaM@kbusch-mbp.dhcp.thefacebook.com>
 <CABgObfYUztpGfBep4ewQXUVJ2vqG_BLrn7c19srBoiXbV+O3+w@mail.gmail.com>
 <Z4Uy1beVh78KoBqN@kbusch-mbp> <0862979d-cb85-44a8-904b-7318a5be0460@redhat.com>
Message-ID: <Z4cmLAu4kdb3cCKo@google.com>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.christie@oracle.com, Tejun Heo <tj@kernel.org>, 
	Luca Boccassi <bluca@debian.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 14, 2025, Paolo Bonzini wrote:
> On 1/13/25 16:35, Keith Busch wrote:
> > > Ok, I found the code and it doesn't exec (e.g.
> > > https://github.com/google/crosvm/blob/b339d3d7/src/crosvm/sys/linux/jail_warden.rs#L122),
> > > so that's not an option. Well, if I understand correctly from a
> > > cursory look at the code, crosvm is creating a jailed child process
> > > early, and then spawns further jails through it; so it's just this
> > > first process that has to cheat.
> > > 
> > > One possibility on the KVM side is to delay creating the vhost_task
> > > until the first KVM_RUN. I don't like it but...
> > 
> > This option is actually kind of appealing in that we don't need to
> > change any application side to filter out kernel tasks, as well as not
> > having a new kernel dependency to even report these types of tasks as
> > kernel threads.
> > 
> > I gave it a quick try. I'm not very familiar with the code here, so not
> > sure if this is thread safe or not,

It's not.

> > but it did successfully get crosvm booting again.
> 
> That looks good to me too.  Would you like to send it with a commit message
> and SoB?

> > ---
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 2401606db2604..422b6b06de4fe 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -7415,6 +7415,8 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
> >   {
> >   	if (nx_hugepage_mitigation_hard_disabled)
> >   		return 0;
> > +	if (kvm->arch.nx_huge_page_recovery_thread)
> > +		return 0;

...

> >   	kvm->arch.nx_huge_page_last = get_jiffies_64();
> >   	kvm->arch.nx_huge_page_recovery_thread = vhost_task_create(
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index c79a8cc57ba42..263363c46626b 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11463,6 +11463,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >   	struct kvm_run *kvm_run = vcpu->run;
> >   	int r;
> > +	r = kvm_mmu_post_init_vm(vcpu->kvm);
> > +	if (r)
> > +		return r;

The only lock held at this point is vcpu->mutex, the obvious choices for guarding
the per-VM task creation are kvm->lock or kvm->mmu_lock, but we definitely don't
want to blindly take either lock in KVM_RUN.

