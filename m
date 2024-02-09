Return-Path: <kvm+bounces-8426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB05784F32D
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 11:18:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DBA61F2294B
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 10:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB8B69942;
	Fri,  9 Feb 2024 10:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ckrXRMd/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53132692E4;
	Fri,  9 Feb 2024 10:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707473889; cv=none; b=tNylZqXHjFw3iV3M7F6ahAkeZ+IFiKKGxLBqRCOrDiC844IIV3FBcvFyvTL/z86IgyVnDydD65yb4JmO0B/8nMV6M3LT5gDHNno6iayRjmqCV3S6++CIOWCDPlDAE+vnXLrKuLAjxtIwjnZ7nfZR5ne8DNwNzo5iDmAfcElNDO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707473889; c=relaxed/simple;
	bh=NjjX68tO0V1IURReN/W7nTc2ejz/EacjGDy8WTWa2Gs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C8dN9tHm4FtfPf99TagU6T0iwb/iKQa1nP7N7aeT5LTJOY+ZHXAnCvyxt2ehZb4ruDmcRQepVuYkcmEua7sAPMr29ifXpN/Uxptkk7Y89JbzFEPzkHVkQCyZk7uPPuLVAZIvAtdnDiUqGHAvFSysY/DX3jslBNB4Rj+xV5pAML8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ckrXRMd/; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-dc754853524so264908276.3;
        Fri, 09 Feb 2024 02:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707473887; x=1708078687; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdwZ4hDuHZxE64kMWieuR4a6X7g5THqN75f1Ypjn7HU=;
        b=ckrXRMd/fqCwcI3tJuAVG89PYSh4N7DQ3gOiJ1D5+30bX2S/32vQlD8ABkL1ddbB3k
         sei4iWPPagGp3YabBGoFfymFeWWKxQ0KJB3GdHisYeEF3cXG0cVwyiUOXVz/W/qnhiyU
         q6rCK7wh+WA2ZmXczlKhVYDdgj/ArGCxwotnLmMtRru2XYRM5/g+4VpnGfvrR2CQuTD+
         L2fS6i0mplyqCH/OtBVXRxYsTvU5byFSp/eKb8+FUfEWhicdbEhPE/CvnZJXfw/osvM5
         wcKzFSRpqKO5VYyIoMRYbhhVEstE+T4YnEJOWa+24cZI1ynbw2SDYN8s52v7jI86Td/Z
         dHAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707473887; x=1708078687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fdwZ4hDuHZxE64kMWieuR4a6X7g5THqN75f1Ypjn7HU=;
        b=UFKxHV1zKYj5zjWMq1RkRQcXGSAAgOcblKg5sD+2rr/QqM2MFcfl7a/LvFpATmwJ6y
         vnnPiGWKzWNMuHldTDBzKKSapSydKYnQzEp3+YlQXX39rp0AUXvA1GZW5xxGC7YznjQ2
         jwqJ3pl3BG52unv6XK8AqQuk3XZTKUU85poavxRQAlYxW5O2KgtH4sRyjpH1xIi3o857
         CwfnLxAbW4ICFwVLj6TQCydlExfnaxSYNcKJmEq7U59gleWbFzStpQz6xfQIUoqMuAq0
         dKT3080dE2LVx5vGfQY98dEBbXiLIgbbjBzSXCCDcmLt9f28ZJgVrFjygTzSp8j7B0g2
         fpDw==
X-Gm-Message-State: AOJu0YyFsueBHCTtZTgNbooBMQdMVF4AqGuvpo1fLSf5YvghYZYXMiqi
	0oPFQ/nUD7fOyV1/huWWfrhZXqOJftcBbpYxvzp1IE4WSqDnXat4HnnrxZVDzIObpfsZPKEERNu
	SsZHzKU3KOLgEUGJBRYenxrVAkBs=
X-Google-Smtp-Source: AGHT+IElOcO3JE5rxCQhOVkS9Z7x30k6PXeBK3RYOi6o8jV6AWVztj/Lwq5jE4YBTxXAgKP96XkNxJZwJx3GUrxxjGI=
X-Received: by 2002:a25:ab0c:0:b0:dc2:5553:ca12 with SMTP id
 u12-20020a25ab0c000000b00dc25553ca12mr1072170ybi.14.1707473887077; Fri, 09
 Feb 2024 02:18:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240124113446.2977003-1-foxywang@tencent.com> <02fe988e-2b42-9610-6ab5-bd17b0d9fb80@oracle.com>
In-Reply-To: <02fe988e-2b42-9610-6ab5-bd17b0d9fb80@oracle.com>
From: Yi Wang <up2wing@gmail.com>
Date: Fri, 9 Feb 2024 18:17:56 +0800
Message-ID: <CAN35MuSanFT1JxM16usksSDjrLLsAAWs-kosJEd20sKckvwJfg@mail.gmail.com>
Subject: Re: [v3 0/3] KVM: irqchip: synchronize srcu only if needed
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	foxywang@tencent.com, seanjc@google.com, pbonzini@redhat.com, 
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com, 
	hpa@zytor.com, bp@alien8.de, wanpengli@tencent.com, oliver.upton@linux.dev, 
	anup@brainfault.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, atishp@atishpatra.org, borntraeger@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dongli,

Thanks for the reply and Happy Spring Festival to all :)

On Fri, Feb 9, 2024 at 5:00=E2=80=AFPM Dongli Zhang <dongli.zhang@oracle.co=
m> wrote:
>
> Hi Yi,
>
> On 1/24/24 03:34, Yi Wang wrote:
> > From: Yi Wang <foxywang@tencent.com>
> >
> > We found that it may cost more than 20 milliseconds very accidentally
> > to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
> > already.
>
> Would you mind explaining the reason that the *number of VMs* matters, as
> KVM_CAP_SPLIT_IRQCHIP is a per-VM cap?
>
> Or it meant it is more likely to have some VM workload impacted by the
> synchronize_srcu_expedited() as in prior discussion?
>
> https://lore.kernel.org/kvm/CAN35MuSkQf0XmBZ5ZXGhcpUCGD-kKoyTv9G7ya4QVD1x=
iqOxLg@mail.gmail.com/
>

The actual reason is might_sleep() and the kworker in
synchronize_srcu_expedited(),
which may cause some delay when there are pretty many threads in the host, =
so
"number of VMs" is just one of  the situations which can trigger the issue =
:)

> Thank you very much!
>
> Dongli Zhang
>
> >
> > The reason is that when vmm(qemu/CloudHypervisor) invokes
> > KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
> > might_sleep and kworker of srcu may cost some delay during this period.
> > One way makes sence is setup empty irq routing when creating vm and
> > so that x86/s390 don't need to setup empty/dummy irq routing.
> >
> > Note: I have no s390 machine so the s390 patch has not been tested.
> >
> > Changelog:
> > ----------
> > v3:
> >   - squash setup empty routing function and use of that into one commit
> >   - drop the comment in s390 part
> >
> > v2:
> >   - setup empty irq routing in kvm_create_vm
> >   - don't setup irq routing in x86 KVM_CAP_SPLIT_IRQCHIP
> >   - don't setup irq routing in s390 KVM_CREATE_IRQCHIP
> >
> > v1: https://urldefense.com/v3/__https://lore.kernel.org/kvm/20240112091=
128.3868059-1-foxywang@tencent.com/__;!!ACWV5N9M2RV99hQ!LjwKfBaGVl3u1l9YQSs=
kg_1RU6278h2-fYnYLsoihF9i43aq73eIDqolGzOmeRvO8UlPreQHLqXEL1bAuw$
> >
> > Yi Wang (3):
> >   KVM: setup empty irq routing when create vm
> >   KVM: x86: don't setup empty irq routing when KVM_CAP_SPLIT_IRQCHIP
> >   KVM: s390: don't setup dummy routing when KVM_CREATE_IRQCHIP
> >
> >  arch/s390/kvm/kvm-s390.c |  9 +--------
> >  arch/x86/kvm/irq.h       |  1 -
> >  arch/x86/kvm/irq_comm.c  |  5 -----
> >  arch/x86/kvm/x86.c       |  3 ---
> >  include/linux/kvm_host.h |  1 +
> >  virt/kvm/irqchip.c       | 19 +++++++++++++++++++
> >  virt/kvm/kvm_main.c      |  4 ++++
> >  7 files changed, 25 insertions(+), 17 deletions(-)
> >



--=20
---
Best wishes
Yi Wang

