Return-Path: <kvm+bounces-6264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D3C282DCDB
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 17:01:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C3EE1C21A97
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 16:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA367179A8;
	Mon, 15 Jan 2024 16:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BEcpmpco"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C2D17981;
	Mon, 15 Jan 2024 16:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-dbd715ed145so6775698276.1;
        Mon, 15 Jan 2024 08:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705334474; x=1705939274; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/7vSzFgCEm7a7CdYxlSsrgd6aVbtCgT1hsw6iA1apkI=;
        b=BEcpmpcosl0zneqk+7ZksGjZcozfmvZq23asYQJD3KJ6j+LiM3zbUuxWGgbFPxcb9l
         KKJ+cV0+4rENHLt3TbNOKHYglOHc1QYRzSFd2CAFX5oMQTiojHKvDClC+zZW3eB2KBbU
         FelPgVBAMluPbdlUR/JhxifzJtmBuH9/xoRTIS8+1fwH8sPwaVBSG0gKaR35WfXi/BVQ
         up+OfFx4DHYWJxWXMoOCcVIjwrKm4Wg+zld187kEDtmC36gCa9SP6TyXZNx1u/39Vs7F
         iWmifL28L30DFf0bug6AENts+HWwc3ForNSJUXfhPZy4sDBm7+GfqxARUpoJp5mBDJDB
         PEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705334474; x=1705939274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/7vSzFgCEm7a7CdYxlSsrgd6aVbtCgT1hsw6iA1apkI=;
        b=RGN0u4l2+LlI5ljdRIbzop36pUe9z+dHSHlTZN7QzJRAhJnlSiW/yKwsS1k6f9YmZA
         q923uquDIW3fHVcS59CfAqOKg2PoOiw4pRoSUZ4pSWLffmKl6Vl3AMqU/BGerXU8sn8o
         hMR3S0R0YHDJFQSHhkjp5Km9ztyf9+d8tFPvE+29kJvJECmgOYThnZdA4rb4NBZXHkhl
         JIAvifLFikAEQOmZGLy0btYrEJNZJNxNDwLo2Onwh6WfnkVHU0wf1lWkWoOjteC5Gyke
         Yv5zPR7+ukx9mi4M1WlDSNIAw8404QmB8Qq7i7p+jXDDPp9ipesRYcHHr+eAhFqFkpR4
         Uu0g==
X-Gm-Message-State: AOJu0YwAgbDyEYpffsv4LtBkhS1BM5OdiZn+XB5WXpjd1kWJn34GxAu4
	wiK8YXOTMqsg9CCq6G+MV5hZTQUUEiYWsPsjz9I=
X-Google-Smtp-Source: AGHT+IG3czFYcbC9F820rKyx5Oet19ap06tIU0sVWUgk+4e5C/lGHUFJB2avan00hM0s8X9o4pfy3FcQcot+sieqHYA=
X-Received: by 2002:a25:aba2:0:b0:dc2:1ce9:7dd with SMTP id
 v31-20020a25aba2000000b00dc21ce907ddmr269066ybi.58.1705334474342; Mon, 15 Jan
 2024 08:01:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240112091128.3868059-1-foxywang@tencent.com> <ZaFor2Lvdm4O2NWa@google.com>
In-Reply-To: <ZaFor2Lvdm4O2NWa@google.com>
From: Yi Wang <up2wing@gmail.com>
Date: Tue, 16 Jan 2024 00:01:03 +0800
Message-ID: <CAN35MuSkQf0XmBZ5ZXGhcpUCGD-kKoyTv9G7ya4QVD1xiqOxLg@mail.gmail.com>
Subject: Re: [PATCH] KVM: irqchip: synchronize srcu only if needed
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, wanpengli@tencent.com, 
	Yi Wang <foxywang@tencent.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Many thanks for your such kind and detailed reply, Sean!

On Sat, Jan 13, 2024 at 12:28=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> +other KVM maintainers
>
> On Fri, Jan 12, 2024, Yi Wang wrote:
> > From: Yi Wang <foxywang@tencent.com>
> >
> > We found that it may cost more than 20 milliseconds very accidentally
> > to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
> > already.
> >
> > The reason is that when vmm(qemu/CloudHypervisor) invokes
> > KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
> > might_sleep and kworker of srcu may cost some delay during this period.
>
> might_sleep() yielding is not justification for changing KVM.  That's mor=
e or
> less saying "my task got preempted and took longer to run".  Well, yeah.

Agree. But I suppose it may be one of the reasons that makes  time of
KVM_CAP_SPLIT_IRQCHIP delayed, of course, the kworker has the biggest
suspicion :)

>
> > Since this happens during creating vm, it's no need to synchronize srcu
> > now 'cause everything is not ready(vcpu/irqfd) and none uses irq_srcu n=
ow.

....

> And on x86, I'm pretty sure as of commit 654f1f13ea56 ("kvm: Check irqchi=
p mode
> before assign irqfd"), which added kvm_arch_irqfd_allowed(), it's impossi=
ble for
> kvm_irq_map_gsi() to encounter a NULL irq_routing _on x86_.
>
> But I strongly suspect other architectures can reach kvm_irq_map_gsi() wi=
th a
> NULL irq_routing, e.g. RISC-V dynamically configures its interrupt contro=
ller,
> yet doesn't implement kvm_arch_intc_initialized().
>
> So instead of special casing x86, what if we instead have KVM setup an em=
pty
> IRQ routing table during kvm_create_vm(), and then avoid this mess entire=
ly?
> That way x86 and s390 no longer need to set empty/dummy routing when crea=
ting
> an IRQCHIP, and the worst case scenario of userspace misusing an ioctl() =
is no
> longer a NULL pointer deref.

To setup an empty IRQ routing table during kvm_create_vm() sounds a good id=
ea,
at this time vCPU have not been created and kvm->lock is held so skipping
synchronization is safe here.

However, there is one drawback, if vmm wants to emulate irqchip
itself, e.g. qemu
with command line '-machine kernel-irqchip=3Doff' may not need irqchip
in kernel. How
do we handle this issue?


---
Best wishes
Yi Wang

