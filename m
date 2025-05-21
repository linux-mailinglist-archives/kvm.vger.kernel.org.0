Return-Path: <kvm+bounces-47282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1299BABF8D2
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:07:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A7A657B78CA
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9F6213E94;
	Wed, 21 May 2025 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jLvQsI+a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8C3189513
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 15:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747839912; cv=none; b=GI4UkjEi+YH+FsN7AACZZmqv45BfbXQcbAYsKpaF0D36cdY6o0X1O8Zskq5MHpOO5ISe6q3wa4LZa4AUiyroZ1Ct5f8TMSpHl8HMWFbXiGFIEPJczlJqA5hWpHnFXOBi/uV9ac3gd90MVv8/Az6fzgYvwdagw5fDq0SoIO9NB5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747839912; c=relaxed/simple;
	bh=RKB2z0hQP/qo6VCyUDMpywyny5OcLY+qjiNZEUbDqQ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KbN9u2OdJvD/VXqXJw/9tvDM0HCrnuXAQpDryGoBQc3u/NVg2on814s5MIlekYeagnPTWcY5fe9cucAx5v18IW/BMinUoGRDaec/S21DPK8bbCpgvhgUUvzChXCTHDQOe6V4zsc7sj57WZKp8OION6kkF8dku8WeyzLEzCCjFDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jLvQsI+a; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26e38174e5so6761471a12.1
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 08:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747839910; x=1748444710; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zVleagUiVHw/5vhkBi8LDSAfw55ruRJcasWRJK+un3M=;
        b=jLvQsI+awZL+vflIDEkAZoFJ95fpqQfmyhhnMJuB2Gj0kGhVPa8Vlasz6SLmH4wirU
         DFHQVjTBm+6L8UyJDD756Cvgz0kSPr6xuXBGcOHIKPXn7+e+kg0BMDDFGde2IKeBMa1U
         drn/MfNbuDc02al4Wx4SXGi5gYVpv6MkeE0fjA8Q5x6cPd++0HfXp+gyWQtM5gRODF4q
         gBP7YNeDam1K+TYQcS1TMiTLpGEHbLjU2w9XzqQBfRJ2TYk8a4JS6EkSP0jkl/nXE/Yy
         i68WNdmToSOmxGVPFApl4yOanbbz6wvy5oIAtR058o87ugq54IFWpxt7teOHIzN4BDLi
         +vmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747839910; x=1748444710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zVleagUiVHw/5vhkBi8LDSAfw55ruRJcasWRJK+un3M=;
        b=OgKKz4snkNuc9c0XKGzZwrrfqjhs3ucsl/2dWdyftfwcDSkvXocfJ5DWf7ncVgN1ew
         erXk5gnvl+ppZyWk3MgZv+6ot+4K+Z/D8dQVBMpab7QSPf+DT9kuHQIjEOFMdy0RHA3Y
         jJnlratrDJW3WeMTUsBjZdcMeYskZPiRCSZTFvPt5GF1hiId9U9sJ912nvfMXz0djgM/
         JowY4bnIyVRV6lSUdRX9Kv8MqAOodasGJfGCDbKWlrA5Yk4ySBEYwP2HyH2DaRCTlYzU
         DsAYb/sm0gxlVuOAij9P8W0rjDsbG9l7YtpEpsCwMk7UYJh4qeCNBDTwUnSGY3tZM/3B
         hiWg==
X-Forwarded-Encrypted: i=1; AJvYcCVUUjC4u5Ub5isc1eXWtBSI5uUyZTgYq6n1R0Rax4kogEumRSn70EKA6qfFpUNJTm6scp0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhegGNfzidvNl204dlWNU+eUhoY0eu6+egSCP28FGuBYKhvy2B
	iCdk1u+H+JV/rQukFpHec1QMNb+rvVpxWuIGUxX4AsWXLe7gXBaWGgY2qopo0FPZdmceNLUN1vI
	VwBUxJg==
X-Google-Smtp-Source: AGHT+IHGSpJmNv8SAS14hmKKh6ZIg5876VKcdbgoWSZxr3DEmUJT2DSMLR2M8INJy/4FyAqIRr98hcZr/w0=
X-Received: from pgbfe5.prod.google.com ([2002:a05:6a02:2885:b0:b26:eac3:3979])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:103:b0:1fe:90c5:7d00
 with SMTP id adf61e73a8af0-216219c82fcmr35252646637.28.1747839910386; Wed, 21
 May 2025 08:05:10 -0700 (PDT)
Date: Wed, 21 May 2025 08:05:09 -0700
In-Reply-To: <BN7PR02MB4148503E1599C1310F408863D49EA@BN7PR02MB4148.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com> <20250519185514.2678456-9-seanjc@google.com>
 <20250520191816.GJ16434@noisy.programming.kicks-ass.net> <aC0AEJX0FIMl9lDy@google.com>
 <20250521114233.GC39944@noisy.programming.kicks-ass.net> <BN7PR02MB4148503E1599C1310F408863D49EA@BN7PR02MB4148.namprd02.prod.outlook.com>
Message-ID: <aC3rpZChhtw4NODS@google.com>
Subject: Re: [PATCH v2 08/12] sched/wait: Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority()
From: Sean Christopherson <seanjc@google.com>
To: Michael Kelley <mhklinux@outlook.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Nuno Das Neves <nunodasneves@linux.microsoft.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Matlack <dmatlack@google.com>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 21, 2025, Michael Kelley wrote:
> From: Peter Zijlstra <peterz@infradead.org> Sent: Wednesday, May 21, 2025 4:43 AM
> > 
> > On Tue, May 20, 2025 at 03:20:00PM -0700, Sean Christopherson wrote:
> > > On Tue, May 20, 2025, Peter Zijlstra wrote:
> > > > On Mon, May 19, 2025 at 11:55:10AM -0700, Sean Christopherson wrote:
> > > > > Drop the setting of WQ_FLAG_EXCLUSIVE from add_wait_queue_priority() to
> > > > > differentiate it from add_wait_queue_priority_exclusive().  The one and
> > > > > only user add_wait_queue_priority(), Xen privcmd's irqfd_wakeup(),
> > > > > unconditionally returns '0', i.e. doesn't actually operate in exclusive
> > > > > mode.
> > > >
> > > > I find:
> > > >
> > > > drivers/hv/mshv_eventfd.c:      add_wait_queue_priority(wqh, &irqfd->irqfd_wait);
> > > > drivers/xen/privcmd.c:  add_wait_queue_priority(wqh, &kirqfd->wait);
> > > >
> > > > I mean, it might still be true and all, but hyperv seems to also use
> > > > this now.
> > >
> > > Oh FFS, another "heavily inspired by KVM".  I should have bribed someone to take
> > > this series when I had the chance.  *sigh*
> > >
> > > Unfortunately, the Hyper-V code does actually operate in exclusive mode.  Unless
> > > you have a better idea, I'll tweak the series to:
> > >
> > >   1. Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority() and have the callers
> > >      explicitly set the flag,
> > >   2. Add a patch to drop WQ_FLAG_EXCLUSIVE from Xen privcmd entirely.
> > >   3. Introduce add_wait_queue_priority_exclusive() and switch KVM to use it.
> > >
> > > That has an added bonus of introducing the Xen change in a dedicated patch, i.e.
> > > is probably a sequence anyways.
> > >
> > > Alternatively, I could rewrite the Hyper-V code a la the KVM changes, but I'm not
> > > feeling very charitable at the moment (the complete lack of documentation for
> > > their ioctl doesn't help).
> > 
> > Works for me. Michael is typically very responsive wrt hyperv (but you
> > probably know this).
> 
> I can't be much help on this issue. This Hyper-V code is for Linux running in
> the root partition (i.e., "dom0") and I don't have a setup where I can run and
> test that configuration.
> 
> Adding Nuno Das Neves from Microsoft for his thoughts.

A slightly more helpful, less ranty explanation of what's going on:

KVM's irqfd code, which was pretty copied verbatim for Hyper-V partitions, disallows
binding an eventfd to a single VM multiple times, but doesn't handle the scenario
where an eventfd is bound to multiple VMs, i.e. to multiple partitions.  What's
particular "fun" about such a scenario is that WQ_FLAG_EXCLUSIVE+WQ_FLAG_PRIORITY
means only the first VM/partition that bound the eventfd will be notified.

For KVM-based setups, this is a legitimate concern because KVM supports intra-host
migration.  E.g. to upgrade the userspace VMM, a guest can be "migrated" from the
old VMM's "struct kvm" instance to the new VMM's "struct kvm".  If userspace mucks
up the migration, e.g. doesn't *unbind* the eventfd from the old VM(M) before
resuming the guest in the new VM(M), KVM will effectively drop virtual IRQs.

This is purely a hardening exercise, i.e. isn't required for correctness, assuming
userspace userspace is bug-free.  The KVM patches surrounding this patch show how
I am planning on ensuring a 1:1 eventfd:VM binding.

To not block the KVM hardening on Hyper-V's eventfd usage, I am planning on making
this change in the next version of the series:

diff --git a/drivers/hv/mshv_eventfd.c b/drivers/hv/mshv_eventfd.c
index 8dd22be2ca0b..b348928871c2 100644
--- a/drivers/hv/mshv_eventfd.c
+++ b/drivers/hv/mshv_eventfd.c
@@ -368,6 +368,14 @@ static void mshv_irqfd_queue_proc(struct file *file, wait_queue_head_t *wqh,
                        container_of(polltbl, struct mshv_irqfd, irqfd_polltbl);
 
        irqfd->irqfd_wqh = wqh;
+
+       /*
+        * TODO: Ensure there isn't already an exclusive, priority waiter, e.g.
+        * that the irqfd isn't already bound to another partition.  Only the
+        * first exclusive waiter encountered will be notified, and
+        * add_wait_queue_priority() doesn't enforce exclusivity.
+        */
+       irqfd->irqfd_wait.flags |= WQ_FLAG_EXCLUSIVE;
        add_wait_queue_priority(wqh, &irqfd->irqfd_wait);
 }

