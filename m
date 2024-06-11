Return-Path: <kvm+bounces-19287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 523A4902E16
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 03:54:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CBD7284E65
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 01:54:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 174ABAD59;
	Tue, 11 Jun 2024 01:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VpJnbOBu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCE58467;
	Tue, 11 Jun 2024 01:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718070858; cv=none; b=lkmQGw2f7gJwDvMKSIyJd+caOjqKwtB+5EVVU5uTRSqnF9bSDOMRPzkvrmhG7tauNuwtyEVTbWOgpd9prVvzU3cetjLrDr1ZVpQzlN9Ho68i3eVtuV8VftSvDIprmRLtEhc7Qcqcz1Ekrw7yh6Zyulj86xf4jrUl1Q/t7H5Fqvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718070858; c=relaxed/simple;
	bh=RMOWDbcLC6kh+q8ipKT+7Rt/jChd0OU5J4NwCfdYe2U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RsgLDORyJt3geXZWzRuO5KcSuiP1PZsTg+3kTwD+7lq/yTMU4+zWtH5HgP4nn+w82yUxe4pp/4a/KHe06UTEZ6rOrCOF8u3NJcajydDhccyMBD7ga7xlRRcO2YCJ24FOy3j2avWGLceociorrNsf4xtDf/D6US8KwsaZrEkGoDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VpJnbOBu; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-dfaff6bee06so3147142276.1;
        Mon, 10 Jun 2024 18:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718070855; x=1718675655; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oXxtw6aEa7wurRX+fjmWBEMlIOgC9GtbLTKqpS66fEw=;
        b=VpJnbOBufbUaQ5vWyioJvIyvMCPuazy+oSzuNHj6oZD6IjsRT33+rPxw4mWkWp2SoI
         uQ9UcMsyFHpW6db+q/6ySzRzSrZk5ZA2wvo443kKqyWSNWXIsyfUdcYodA/WQQbBjDh1
         ZsQFMDzjkAFwPFdu9u8Q1LTZI1y/33uZDRLqxDc3IkCGCd/tM/x/qGEmVWw9sNC7s0hf
         pf3GDX2a04KyVgsJik8tdxE1evZQQ4ONmC9lXn+5aQ9TforYzBbQ8bPccBdQnPSJTmtS
         4pEDJfBXquGdad7ROVPHw1e2BUUdiO3L10YNTq+g8LdyGpUtXDGMpgCE1srI/I1VdlQn
         +Mww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718070855; x=1718675655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oXxtw6aEa7wurRX+fjmWBEMlIOgC9GtbLTKqpS66fEw=;
        b=GNyo5eh1MgFH3+NP5/Q1fLwjBv38krkviEe72VEYKexlpWuGYbGHDONNamSwE2oXaV
         SoKO8wqZhky4aCtWetlct7muFgriqGIM0E/ZZrqCxHJn5leLquFP7YuYQayBixzSRLHf
         Kjgqy2z4IVGBsOFA+ArjlDoJdicRpfiE5ltLV/C1utHov4QNFzonnSUqdj7fPv2QHbT3
         sHMEZhtrmnZ0ofVe+9VthaEmgFYl6z3TAXP687NP0oh/u+n0GnxHJiLmRvjQQJylog6e
         FxISUxpoOSgx3A6i+dLxVMnuIPYmWPlZQAha35JKDS4VdFiaVK8mLuZ6jVWZhd7pfhiI
         9KVw==
X-Forwarded-Encrypted: i=1; AJvYcCV0H9qPJQ9SrleL0oNIxy+Wq4UW6VaBpE/D1d3ESYvFBEmA90V9Yu4wXISPCQJ24xvXr8fNzTlUkn8EfWWnZ1tzaYA2FeS6oSpGNboeMgpPg/1f6FjZJlCtJW6DLXoQA270
X-Gm-Message-State: AOJu0YwhxP/cvt/bFcJBF7Oq5kgvXR9IerUIvGM8aLywtfyr5Ukr13/n
	fWxo3jOnV5TUprJvlukWYZ8guTAVIykX6k6OEx0bZ2XmgBGjBxCMwjSfD14Wu8dsfX1dLKStvpK
	m6cD+hj6rOYEaRRcKl1+IZUoAwFY=
X-Google-Smtp-Source: AGHT+IHEzWnoZRk6uV+VkZaNGSEZuu1/d6Yf+HqHkJ/hDKPQJTmOFIetq9sDt0WqYzcUIRQvDDL0hdh50DKOnHtAw5U=
X-Received: by 2002:a25:2e41:0:b0:dfa:56e1:9eb5 with SMTP id
 3f1490d57ef6-dfaf659080cmr10665536276.48.1718070855459; Mon, 10 Jun 2024
 18:54:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240506101751.3145407-1-foxywang@tencent.com>
 <20240506101751.3145407-3-foxywang@tencent.com> <ZmeZbjFi5FWxv-Mb@google.com>
In-Reply-To: <ZmeZbjFi5FWxv-Mb@google.com>
From: Yi Wang <up2wing@gmail.com>
Date: Tue, 11 Jun 2024 09:54:04 +0800
Message-ID: <CAN35MuTTtjPi-mC4vMM=FcHhgapspk5i6KrU1Em5AYBZzTQJHA@mail.gmail.com>
Subject: Re: [v5 2/3] KVM: x86: don't setup empty irq routing when KVM_CAP_SPLIT_IRQCHIP
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, wanpengli@tencent.com, 
	foxywang@tencent.com, oliver.upton@linux.dev, maz@kernel.org, 
	anup@brainfault.org, atishp@atishpatra.org, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, weijiang.yang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2024 at 8:25=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, May 06, 2024, Yi Wang wrote:
> > From: Yi Wang <foxywang@tencent.com>
> >
> > We found that it may cost more than 20 milliseconds very accidentally
> > to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
> > already.
> >
> > The reason is that when vmm(qemu/CloudHypervisor) invokes
> > KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
> > might_sleep and kworker of srcu may cost some delay during this period.
> >
> > As we have set up empty irq routing when creating vm, so this is no
> > need now.
> >
> > Signed-off-by: Yi Wang <foxywang@tencent.com>
> > ---
> >  arch/x86/kvm/irq.h      | 1 -
> >  arch/x86/kvm/irq_comm.c | 5 -----
> >  arch/x86/kvm/x86.c      | 3 ---
> >  3 files changed, 9 deletions(-)
> >
> > diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
> > index c2d7cfe82d00..76d46b2f41dd 100644
> > --- a/arch/x86/kvm/irq.h
> > +++ b/arch/x86/kvm/irq.h
> > @@ -106,7 +106,6 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu);
> >  int apic_has_pending_timer(struct kvm_vcpu *vcpu);
> >
> >  int kvm_setup_default_irq_routing(struct kvm *kvm);
> > -int kvm_setup_empty_irq_routing(struct kvm *kvm);
> >  int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
> >                            struct kvm_lapic_irq *irq,
> >                            struct dest_map *dest_map);
> > diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> > index 68f3f6c26046..6ee7ca39466e 100644
> > --- a/arch/x86/kvm/irq_comm.c
> > +++ b/arch/x86/kvm/irq_comm.c
> > @@ -397,11 +397,6 @@ int kvm_setup_default_irq_routing(struct kvm *kvm)
> >
> >  static const struct kvm_irq_routing_entry empty_routing[] =3D {};
>
> empty_routing is unused after this patch and can+should be removed, e.g.
>
> arch/x86/kvm/irq_comm.c:398:43: error: =E2=80=98empty_routing=E2=80=99 de=
fined but not used [-Werror=3Dunused-const-variable=3D]
>   398 | static const struct kvm_irq_routing_entry empty_routing[] =3D {};
>
> I'll fix this up when applying, too.


Many thanks for your work, Sean.


---
Best wishes
Yi Wang

