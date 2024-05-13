Return-Path: <kvm+bounces-17355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F4C08C48FD
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 23:47:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B2EF1F22AA8
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 21:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92C708405D;
	Mon, 13 May 2024 21:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZSXBDEn4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB13F175A6
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 21:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715636850; cv=none; b=tNVMb6tqhhri0XQQPNzVAypiVeflqml9VsH4YtxGdatYZVX0LhJGyXFv7EaIteR9mEP19LNEwH4C9gBz+H+MUefe11UpF+i+MSt9TeaCB4zSwrZ/KIwuUX4KsvNVIOj/wUsHDw7+EelyHIrpQV4E2Ur2aXotHuqRLQzNWyQGrkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715636850; c=relaxed/simple;
	bh=GsvEB0jrgKOQaYhaQDNrmbyGu9pT3dQg3hSPhGvs95A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cS9giPI2XeKrGtdBoU/oyBq34Wv0fVsrDxDQs0Ii8ByZa3qXF+pzWzwPB+XJ4Pf7oPYO/TY8AmEgLmQTLpeM8COSzLCB+ObBasE2QRKfhK7/DGZiy6TN++lDkisElGYAlr9xtMDtWDZQ6HH5xz9sTZmHmkZS1WeVUwmHVaz3wl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZSXBDEn4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715636847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zezx3lgmnnnDtiiLnluAFlp/ntQq1a9r2G/1DoFg4n0=;
	b=ZSXBDEn4BeX3bMPTbXUivaCe8iGaYvUkGcnimV9F21jPOc3la1vR8Uecw0Md2eeM3bSgru
	f45SMSNO7cPwV9Nbovig6NrpFF4s1YwZOwDlSBairKisuu5sHrzJtEZNXHX5SfwQgqTvvp
	l4GA5hnB3ysKtrxvORZ5CwW6T/gv1ZU=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-pvLsVtOqNhiMu3eKinuKWQ-1; Mon, 13 May 2024 17:47:26 -0400
X-MC-Unique: pvLsVtOqNhiMu3eKinuKWQ-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-43dfa80c9ccso58145941cf.3
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 14:47:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715636845; x=1716241645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zezx3lgmnnnDtiiLnluAFlp/ntQq1a9r2G/1DoFg4n0=;
        b=F64lgB3pRNzbJ2TMfDDP8sDlI+Pww7FeJyEnkJCwACoiKExOA4dmwlRTdg++4N3IbR
         9w67RZd8XxzQPvf+3NvO9ZUqaMOi4CAeZrt+60r3BrF2wPJ1STM9zXazRzeS4DmsM06Y
         yb4ZJwaacQmw+vRAOCHi2CcPU83xOrwiq8ZiergkFdVKYEL+R9eX6LL6T9RoUo656Yl9
         P1AWpFTlEyJ3U8x+P0Pxm6D5GdEv2HQG+fWV4pUR1TjihUUt+nNkO3BYka35d2/3I6Yc
         vAlBjb+SV/MNz4fOPuem9j9nfzRyqRow4DveyIsiz+qpJ13OJ0ou3kgxrjUrDgiOrpw2
         gLzg==
X-Forwarded-Encrypted: i=1; AJvYcCW7joCF3uybdOaqNpGR0URBp13KQeZaxfDAsIGzH1qQwWxCOXclL0kXMbXJideacB8QDfO+59r5Kt+CEnvC8BX66YCO
X-Gm-Message-State: AOJu0YyELtwVvUznP36U+Q9PCmUR77yWLmkYDI4ntiWR+oAGdb++RUjB
	AgkZg6lUqozaMQAyF7fRTZ1liV2VYU5DxxzMFRFcjHCXCoFRDPR03AkUgJCosX8Km1bccu1gsKJ
	1b1O3Lf5UA2Eb7ZcjSOqd7aOlryP7vH7Um5oExrPJ7+cAa4bZhzwqQzf8sZ8ZjD1dSUmlgtY+Ne
	a+gra5dYQ3AVELzF/kPLqNVsRi
X-Received: by 2002:a05:622a:148a:b0:43a:dc29:a219 with SMTP id d75a77b69052e-43dfda8e639mr142376941cf.2.1715636845534;
        Mon, 13 May 2024 14:47:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHl8mtvZ1AqP2eTCQHLv7194Xa2gyO4esR0o+IYBTEGNUDz7XONxYrIUGwyTPc05Dwa+aFhe3D+YU3/19Zu628=
X-Received: by 2002:a05:622a:148a:b0:43a:dc29:a219 with SMTP id
 d75a77b69052e-43dfda8e639mr142376681cf.2.1715636845074; Mon, 13 May 2024
 14:47:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240511020557.1198200-1-leobras@redhat.com> <ZkJsvTH3Nye-TGVa@google.com>
In-Reply-To: <ZkJsvTH3Nye-TGVa@google.com>
From: Leonardo Bras Soares Passos <leobras@redhat.com>
Date: Mon, 13 May 2024 18:47:13 -0300
Message-ID: <CAJ6HWG7pgMu7sAUPykFPtsDfq5Kfh1WecRcgN5wpKQj_EyrbJA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
To: Sean Christopherson <seanjc@google.com>
Cc: Frederic Weisbecker <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 13, 2024 at 4:40=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, May 10, 2024, Leonardo Bras wrote:
> > As of today, KVM notes a quiescent state only in guest entry, which is =
good
> > as it avoids the guest being interrupted for current RCU operations.
> >
> > While the guest vcpu runs, it can be interrupted by a timer IRQ that wi=
ll
> > check for any RCU operations waiting for this CPU. In case there are an=
y of
> > such, it invokes rcu_core() in order to sched-out the current thread an=
d
> > note a quiescent state.
> >
> > This occasional schedule work will introduce tens of microsseconds of
> > latency, which is really bad for vcpus running latency-sensitive
> > applications, such as real-time workloads.
> >
> > So, note a quiescent state in guest exit, so the interrupted guests is =
able
> > to deal with any pending RCU operations before being required to invoke
> > rcu_core(), and thus avoid the overhead of related scheduler work.
>
> Are there any downsides to this?  E.g. extra latency or anything?  KVM wi=
ll note
> a context switch on the next VM-Enter, so even if there is extra latency =
or
> something, KVM will eventually take the hit in the common case no matter =
what.
> But I know some setups are sensitive to handling select VM-Exits as soon =
as possible.
>
> I ask mainly because it seems like a no brainer to me to have both VM-Ent=
ry and
> VM-Exit note the context switch, which begs the question of why KVM isn't=
 already
> doing that.  I assume it was just oversight when commit 126a6a542446 ("kv=
m,rcu,nohz:
> use RCU extended quiescent state when running KVM guest") handled the VM-=
Entry
> case?

I don't know, by the lore I see it happening in guest entry since the
first time it was introduced at
https://lore.kernel.org/all/1423167832-17609-5-git-send-email-riel@redhat.c=
om/

Noting a quiescent state is cheap, but it may cost a few accesses to
possibly non-local cachelines. (Not an expert in this, Paul please let
me know if I got it wrong).

I don't have a historic context on why it was just implemented on
guest_entry, but it would make sense when we don't worry about latency
to take the entry-only approach:
- It saves the overhead of calling rcu_virt_note_context_switch()
twice per guest entry in the loop
- KVM will probably run guest entry soon after guest exit (in loop),
so there is no need to run it twice
- Eventually running rcu_core() may be cheaper than noting quiescent
state every guest entry/exit cycle

Upsides of the new strategy:
- Noting a quiescent state in guest exit avoids calling rcu_core() if
there was a grace period request while guest was running, and timer
interrupt hits the cpu.
- If the loop re-enter quickly there is a high chance that guest
entry's rcu_virt_note_context_switch() will be fast (local cacheline)
as there is low probability of a grace period request happening
between exit & re-entry.
- It allows us to use the rcu patience strategy to avoid rcu_core()
running if any grace period request happens between guest exit and
guest re-entry, which is very important for low latency workloads
running on guests as it reduces maximum latency in long runs.

What do you think?

Thanks!
Leo


