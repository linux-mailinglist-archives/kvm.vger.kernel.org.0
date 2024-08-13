Return-Path: <kvm+bounces-24017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 06FC29508D2
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B08701F25343
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 15:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C2B81A08BB;
	Tue, 13 Aug 2024 15:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jKXpVNU2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4335F1A08AB
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 15:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723562364; cv=none; b=PJfObbWuUK5nBjPs9RdC7Z7MpgOpHf3WH9joDH8uRqOHrDFZ7ARNBwQWbxLArhG/5d+9XVz3VE67bXmPsWruaCx3mf+gZHVSOyylSPEfcG1fbxPWQLGBAM/1Ez2TWcpdxylj4N6cJTJDsBldHLI5Da9O53ihXNC/VZVv9fzJC8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723562364; c=relaxed/simple;
	bh=4Xp48SJMLcVIZJiAwvicvIafG9pNg+39hHzu6XF0VPQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jHmuLMMU4e72thG+qr8lmALYyveGdOG9YNhcQp7wkz9x/xBgX+m5VFTW+tglRLSi1zFhy4XwVq8ISWPuMf54J5HNJssPTGq4dB/pe+K+LOppgJDWOMCp02esqy31AtffBcgnPq/QJ6zZhm55r+jqZpX18YDha7ytfB4biBgH0Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jKXpVNU2; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-710ca162162so4431873b3a.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 08:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723562362; x=1724167162; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yiVajlnnhMg/Yh+qfX66bQ3bWZlc6mtowqxiGC0tj8M=;
        b=jKXpVNU2Ld1vGetyzbbs8IiJ4B9FR+acfv2T1ufUnPQVqP3/6WpDd//qmRe0M0wpch
         bnVK9tEcAbH4pSxPq08NyWkT45blPM7ZkKOYzXemR9JrEsjIqft2Mk7SAxeyhzIy4Hj3
         izsNjZ+XKsm3EwJtM5gzPF78Q+3henvnvHL/ZvzbnGdmsp7XXh7awAJ3Xzb+xERPN2Gy
         wFeO/inL2GWfj2Ado6PAPqw1Js0yRTmNeYGsqbJ7ho2maWEdLX1intB3/bqpFdcylI0o
         Sf3HXw6N9fb1ASJ2w5V66x6Zo396+Xg/4bRXeIA3yNlGbuiV41FhbZ0Y65SpJKkbmo1Y
         gOQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723562362; x=1724167162;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yiVajlnnhMg/Yh+qfX66bQ3bWZlc6mtowqxiGC0tj8M=;
        b=F1oixeUYCB1/gto9VyZTNsVlpB9D++W1772vq8j4iRsmQ8/Llb5TRnK0kMoB64PDlQ
         1YjYaraih9rJRhKOiNqre+UGrUrS6LF2E+gthJ/+1o1R4ThIJCMR+pfihYEimxU1/1O0
         RfFmzwXOvIXMiY3irp3OgwqZSFwYHoRWBFh9Sv2X7+PPGUtqhDialSSBRzm1BFly+MKD
         H7pHPKnSKB6I2f7DwB4YsTmWllcGXJrKQyXVDssr11gfaXvNb4hkJqqJad+DeM+n3tfB
         yO0zFh/NPuQx3by1Is/Wg9chBJaiALDySNxw6iT9O5qLWeSQt+crTfpCRTHOfXp1gLUT
         0r2A==
X-Forwarded-Encrypted: i=1; AJvYcCWjcoNWvaxbrW9LZIUbcECqWh72DLVsbTC0UHaBOEJ0hbtzpvetrEKyq4oycICGT5Tw/nTzKGsmEZXX2XQJE17BfLz4
X-Gm-Message-State: AOJu0YziDjyq/4nsvdfLweezRoPe53TQxZJfLzWyR7rykjD6Er0dKvn6
	KjFd6wRzesxfM+sT6QW5maeKe/Un0jU2tj09EY/SMOEZzr9JM2L4EpLX9OgKNRW/JYkdogPsiKm
	G5A==
X-Google-Smtp-Source: AGHT+IGZphdjDZHrlcnKAsnjY8cAGv5jEiizyXDCv8b9DV58tXXEL/E/tosVycOuJ/VmvuOmGLWv2ESAQ/s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:bef:b0:710:4d08:e41f with SMTP id
 d2e1a72fcca58-712554d8bbamr9757b3a.4.1723562362321; Tue, 13 Aug 2024 08:19:22
 -0700 (PDT)
Date: Tue, 13 Aug 2024 08:19:20 -0700
In-Reply-To: <CAJhGHyDa+-ehMOeLGhZ9-y-ubB4fSXG83hBGUWMRmBOtJ-wSLg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-20-seanjc@google.com>
 <CAJhGHyDjsmQOQQoU52vA95sddWtzg1wh139jpPYBT1miUAgj6Q@mail.gmail.com>
 <ZrooozABEWSnwzxh@google.com> <CAJhGHyDa+-ehMOeLGhZ9-y-ubB4fSXG83hBGUWMRmBOtJ-wSLg@mail.gmail.com>
Message-ID: <Zrt5eNArfQA7x1qj@google.com>
Subject: Re: [PATCH 19/22] KVM: x86/mmu: Add infrastructure to allow walking
 rmaps outside of mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2024, Lai Jiangshan wrote:
> On Mon, Aug 12, 2024 at 11:22=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
>=20
> >
> > Oh yeah, duh, re-read after PAUSE, not before.
> >
> > Definitely holler if you have any alternative ideas for walking rmaps
> > without taking mmu_lock, I guarantee you've spent more time than me
> > thinking about the shadow MMU :-)
>=20
> We use the same bit and the same way for the rmap lock.
>=20
> We just use bit_spin_lock() and the optimization for empty rmap_head is
> handled out of kvm_rmap_lock().

Hmm, I'm leaning towards keeping the custom locking.  There are a handful o=
f
benefits, none of which are all that meaningful on their own, but do add up=
.

 - Callers don't need to manually check for an empty rmap_head.
 - Can avoid the redundant preempt_{disable,enable}() entirely in the commo=
n case
   of being called while mmu_lock is held.
 - Handles the (likely super rare) edge case where a read-only walker encou=
nters
   an rmap that was just emptied (rmap_head->val goes to zero after the ini=
tial
   check to elide the lock).
 - Avoids an atomic when releasing the lock, and any extra instructions ent=
irely
   for writers since they always write the full rmap_head->val when releasi=
ng.

> bit_spin_lock() has the most-needed preempt_disable(). I'm not sure if th=
e
> new kvm_rmap_age_gfn_range_lockless() is called in a preempt disabled reg=
ion.

Oof, it doesn't.  Disabling IRQs crossed my mind, but I completely forgot a=
bout
preemption.

Thanks much!

