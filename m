Return-Path: <kvm+bounces-3158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F1E801368
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 20:10:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02D601C20B7B
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 19:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2394E4EB28;
	Fri,  1 Dec 2023 19:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rl0Un9AR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE6B10DF
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 11:10:17 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id 6a1803df08f44-67a9cba087aso4351856d6.3
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 11:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701457816; x=1702062616; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3d5nvTaF8kuJagYDcGaeaUsaeVBNS6VEIq5mpqo9UmA=;
        b=rl0Un9AROA+FYAFH3AqjlnyQdiuDrr1bxnOYd4a2OT+46KnikLND5KBKsCxTZN2fAb
         9bOwxXsMfMivDY9xOuwa3FxIJT65eOw/6/E9vhvpRoiLtTaJruuwjN6ou53vQzi63wD+
         YwX01Qh5kjNRdniAY1roJ5xmcNHDwdXnzn+j6GKCK69SnIMpdMX64smFewEr2SFYQeJn
         9i4cF3wNjpC7tMqgvrvnuFbIMSVcvzYCxbglXwM95urTPH/lFrkvumTJ1UbW934S+tdb
         bRFRoCBpZMLaAdt5VyPMBI/o8n9l1JVkkQU+ksaME+CB/8Zmwonzv/oVr3x8nlAxwuIf
         kvlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701457816; x=1702062616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3d5nvTaF8kuJagYDcGaeaUsaeVBNS6VEIq5mpqo9UmA=;
        b=lq1dqOroq5l4atdz/XmSyscxzGe7UAJYW5etRo0YnbcIYb/g1NYjuZqW5oXFb5CkMT
         xlV9ycZAYONQWlL24r7hBJnjGiEHmSmuj6qBviUeBw4FipEET4QQPqVLKNCYP6943fQx
         9EwTv+M3/HF1ABeHZxsEuxebi48IiFY2Lz1IYlX8gOng+rqnJLmhIn3zNaduNTR+Unnm
         sqBy3pCsOF98BpSwBUeaDl5YJJdhFkStQ2bWhO1P6r9FIlAKfoqAhbrVDMBm8Vt6TM+W
         oCgZHsV1zCo5a6GALzKzU2t8OnoZifkOolwFh0MBFcSfrD7O3WDCvS0O/KnQlNFF87mY
         78Wg==
X-Gm-Message-State: AOJu0YxXViiWkVgTYYDjUqwVwHQLCuOCtI9yETAh/Q8y3g85OOnca+Tv
	srjMy0FF2VxSpD5pO1nPIkQwgDorEOFW5+ALekk8QPTxWg2/PaOM5/TqdhLa
X-Google-Smtp-Source: AGHT+IGTb9xP3Y+0ydU1WznwApXxpeJWvaXzBuS7ilhu+ua5rvEhdeCKPMR+G3OAlX7g3lk4MFCHd20F8zZevl1SAqk=
X-Received: by 2002:a05:6214:e62:b0:679:e2cb:2a30 with SMTP id
 jz2-20020a0562140e6200b00679e2cb2a30mr30256086qvb.52.1701457374338; Fri, 01
 Dec 2023 11:02:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231110003734.1014084-1-jackyli@google.com> <ZWogUHqoIwiHGehZ@google.com>
In-Reply-To: <ZWogUHqoIwiHGehZ@google.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Fri, 1 Dec 2023 11:02:18 -0800
Message-ID: <CAL715WKVHJqpA=VsO3BZhs9bS9AXiy77+k-aMEh+FGOKZREp+g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] KVM: SEV: Limit cache flush operations in sev
 guest memory reclaim events
To: Sean Christopherson <seanjc@google.com>
Cc: Jacky Li <jackyli@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ovidiu Panait <ovidiu.panait@windriver.com>, Liam Merwick <liam.merwick@oracle.com>, 
	Ashish Kalra <Ashish.Kalra@amd.com>, David Rientjes <rientjes@google.com>, 
	David Kaplan <david.kaplan@amd.com>, Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 1, 2023 at 10:05=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Nov 10, 2023, Jacky Li wrote:
> > The cache flush operation in sev guest memory reclaim events was
> > originally introduced to prevent security issues due to cache
> > incoherence and untrusted VMM. However when this operation gets
> > triggered, it causes performance degradation to the whole machine.
> >
> > This cache flush operation is performed in mmu_notifiers, in particular=
,
> > in the mmu_notifier_invalidate_range_start() function, unconditionally
> > on all guest memory regions. Although the intention was to flush
> > cache lines only when guest memory was deallocated, the excessive
> > invocations include many other cases where this flush is unnecessary.
> >
> > This RFC proposes using the mmu notifier event to determine whether a
> > cache flush is needed. Specifically, only do the cache flush when the
> > address range is unmapped, cleared, released or migrated. A bitmap
> > module param is also introduced to provide flexibility when flush is
> > needed in more events or no flush is needed depending on the hardware
> > platform.
>
> I'm still not at all convinced that this is worth doing.  We have clear l=
ine of
> sight to cleanly and optimally handling SNP and beyond.  If there is an a=
ctual
> use case that wants to run SEV and/or SEV-ES VMs, which can't support pag=
e
> migration, on the same host as traditional VMs, _and_ for some reason the=
ir
> userspace is incapable of providing reasonable NUMA locality, then the ow=
ners of
> that use case can speak up and provide justification for taking on this e=
xtra
> complexity in KVM.

Hi Sean,

Jacky and I were looking at some cases like mmu_notifier calls
triggered by the overloaded reason "MMU_NOTIFY_CLEAR". Even if we turn
off page migration etc, splitting PMD may still happen at some point
under this reason, and we will never be able to turn it off by
tweaking kernel CONFIG options. So, I think this is the line of sight
for this series.

Handling SNP could be separate, since in SNP we have per-page
properties, which allow KVM to know which page to flush individually.

Thanks.
-Mingwei

