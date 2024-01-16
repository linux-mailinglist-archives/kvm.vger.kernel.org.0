Return-Path: <kvm+bounces-6350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D543C82F2C0
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 17:58:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 873971F25AA7
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 16:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D5991CABC;
	Tue, 16 Jan 2024 16:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BcKDiB1w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360011CA87
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 16:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbce2a8d700so11716204276.1
        for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 08:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705424292; x=1706029092; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iVWfZWnnweCon4Kq5ddDNFgrUnMdPNHcYUHJ92vD+fM=;
        b=BcKDiB1weZXUJwMlaTv/EgPOVKRTt8dZPbbdEATc3se1Um22mq+4h8H+JG9Ef/GN4Y
         hdFbgH0sfTz8U+NUIpnvfBR+ygWYu3B/RA7eOxq5fStU6dpFkqjzYAicPuuOetDyDmZU
         qZJJjaOs6m/vQp/G+gcGUC6DZFfHQ4RP0X8VCBorCiwY6JBzWY17KfkAQpgTqeFT2gX6
         xvDQ7amljxoqf28GJSg//qlDDGSxso2Bxe/gMtxcvEwIHsesF8sj9AHS6sJwskzRA1tT
         zVE1wEV/3CPCMyEEvSuVzWxUvPjPT7+zE5ZEaZ0CjRU5m44lrQg9ZUu/nqn0Vy4ldBTt
         GGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705424292; x=1706029092;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iVWfZWnnweCon4Kq5ddDNFgrUnMdPNHcYUHJ92vD+fM=;
        b=GKzxHWQ8qk7jj9uuaP1r3U02ajJ+bLDOT24JmH3sEiUb066esr3r9h42HDTcNC48Yf
         5cKaByekBxQUNNju5iUasXZC0NsZuA4XtXszC3lAPGhbnUfr9wkgzpj9V38oD4KN82/c
         6kjLqv//a9TCj63NR55oejWBNpJNQtmm3p/rotKB6Ujj2HGJeqA12JvV3Ix5R1iCZN00
         qdMgtgik9wsDWcUYckj1sgsfJ0pIvBbbgw+aq0ekycGZKiihx9/7Qf0ya6nDjVA5QxjN
         nDvVsZAHcBBs3/6zdMhOVisqErLLYsmquYEFP5wKkZ+fpJu5oeuukjiym2/AxTCwkvte
         x/Tg==
X-Gm-Message-State: AOJu0YzcN8Evx9sS5ie9YSu/EZpjF5EKmQ2jhHzjb/MVKLaIX/3txAo2
	cgX1sut9X8fsQKqqXunys9ZjkqU0cpuhAN7sfA==
X-Google-Smtp-Source: AGHT+IE1nNWckKzVXkEfyiJOevcVb97W+XKPvrnyDZ0rTYxlLX73urn1E9g8V7tpxUADNAsDNPFxeA2opfI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1002:b0:dbe:ae9c:ee49 with SMTP id
 w2-20020a056902100200b00dbeae9cee49mr351073ybt.6.1705424292219; Tue, 16 Jan
 2024 08:58:12 -0800 (PST)
Date: Tue, 16 Jan 2024 08:58:10 -0800
In-Reply-To: <72edaedc-50d7-415e-9c45-f17ffe0c1c23@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240112091128.3868059-1-foxywang@tencent.com>
 <ZaFor2Lvdm4O2NWa@google.com> <CAN35MuSkQf0XmBZ5ZXGhcpUCGD-kKoyTv9G7ya4QVD1xiqOxLg@mail.gmail.com>
 <72edaedc-50d7-415e-9c45-f17ffe0c1c23@linux.ibm.com>
Message-ID: <Zaa1omCaDQOxxy2j@google.com>
Subject: Re: [PATCH] KVM: irqchip: synchronize srcu only if needed
From: Sean Christopherson <seanjc@google.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Yi Wang <up2wing@gmail.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	wanpengli@tencent.com, Yi Wang <foxywang@tencent.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 16, 2024, Christian Borntraeger wrote:
>=20
>=20
> Am 15.01.24 um 17:01 schrieb Yi Wang:
> > Many thanks for your such kind and detailed reply, Sean!
> >=20
> > On Sat, Jan 13, 2024 at 12:28=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >=20
> > > +other KVM maintainers
> > >=20
> > > On Fri, Jan 12, 2024, Yi Wang wrote:
> > > > From: Yi Wang <foxywang@tencent.com>
> > > >=20
> > > > We found that it may cost more than 20 milliseconds very accidental=
ly
> > > > to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
> > > > already.
> > > >=20
> > > > The reason is that when vmm(qemu/CloudHypervisor) invokes
> > > > KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() an=
d
> > > > might_sleep and kworker of srcu may cost some delay during this per=
iod.
> > >=20
> > > might_sleep() yielding is not justification for changing KVM.  That's=
 more or
> > > less saying "my task got preempted and took longer to run".  Well, ye=
ah.
> >=20
> > Agree. But I suppose it may be one of the reasons that makes  time of
> > KVM_CAP_SPLIT_IRQCHIP delayed, of course, the kworker has the biggest
> > suspicion :)
> >=20
> > >=20
> > > > Since this happens during creating vm, it's no need to synchronize =
srcu
> > > > now 'cause everything is not ready(vcpu/irqfd) and none uses irq_sr=
cu now.
> >=20
> > ....
> >=20
> > > And on x86, I'm pretty sure as of commit 654f1f13ea56 ("kvm: Check ir=
qchip mode
> > > before assign irqfd"), which added kvm_arch_irqfd_allowed(), it's imp=
ossible for
> > > kvm_irq_map_gsi() to encounter a NULL irq_routing _on x86_.
> > >=20
> > > But I strongly suspect other architectures can reach kvm_irq_map_gsi(=
) with a
> > > NULL irq_routing, e.g. RISC-V dynamically configures its interrupt co=
ntroller,
> > > yet doesn't implement kvm_arch_intc_initialized().
> > >=20
> > > So instead of special casing x86, what if we instead have KVM setup a=
n empty
> > > IRQ routing table during kvm_create_vm(), and then avoid this mess en=
tirely?
> > > That way x86 and s390 no longer need to set empty/dummy routing when =
creating
> > > an IRQCHIP, and the worst case scenario of userspace misusing an ioct=
l() is no
> > > longer a NULL pointer deref.
>=20
> Sounds like a good idea. This should also speedup guest creation on s390 =
since
> it would avoid one syncronize_irq.
> >=20
> > To setup an empty IRQ routing table during kvm_create_vm() sounds a goo=
d idea,
> > at this time vCPU have not been created and kvm->lock is held so skippi=
ng
> > synchronization is safe here.
> >=20
> > However, there is one drawback, if vmm wants to emulate irqchip itself,
> > e.g. qemu with command line '-machine kernel-irqchip=3Doff' may not nee=
d
> > irqchip in kernel. How do we handle this issue?
>=20
> I would be fine with wasted memory.

+1.  If we really, really want to avoid the negligible memory overhead, we =
could
pre-configure a static global table and directly use that as the dummy tabl=
e (and
exempt it from being freed by free_irq_routing_table()).

> The only question is does it have a functional impact or can we simply ig=
nore
> the dummy routing.

Given the lack of sanity checks on kvm->irq_routing, I'm pretty sure the on=
ly way
for there to be functional impact is if there's a latent NULL pointer deref=
 hiding
somewhere.

