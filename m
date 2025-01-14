Return-Path: <kvm+bounces-35400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9228A10D52
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 18:16:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1221E1644F4
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 17:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DE831EE7B3;
	Tue, 14 Jan 2025 17:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eoiLsTvt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A8B42A83
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 17:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736875008; cv=none; b=AxNNrwQyz+2eWfSh6Dna3fnTQ3KMVJ+zAEJA3dBQg5OVeZnVVuiRVJ2vkvkll9vGetX/zHXnfCbwiyO7Q8BXtRnA3EpomPQ2xTvmR9bg6THYCDF6XNSeHTEeKccY9UMgug6r/Bjv/8T5+GT/YV5AuItthTRHayiqfh0sRF1/vS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736875008; c=relaxed/simple;
	bh=XrUQj9RHDbBmvmTOjaW72snffQUmtD9kbUzJakdy10s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nQcLqJAW/rvpKrMQhGzk9kha4M6q//KPiJMirerJc5yIZZaRIWaY7SIIol1e9WN+ADninD5drOxvOtlOf3mNUnNtkpxVNZYPu8YXf2+3S5aX8NWWdTMx5ZrxNQHiAM9yiNoLEUD6D1UFoyXYf9XZ0cCkQPkLvMZKEhcfWLA5Kow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eoiLsTvt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef7fbd99a6so10040667a91.1
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 09:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736875006; x=1737479806; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u74CP0NJS+PC9+0Z7XNNpmdYcHLg1NRT5zsP8fpkZAI=;
        b=eoiLsTvtHvYaQa1W+m01UHnECqlt4LWka1MCo5aOdRoJZoxDvgckAIVw78gRWl4Ihl
         BHWrQXiE+EhsAc6mTHQHcWmYguhagb04eXirvDGBD2ioD+YjPxdwaf/qcZKNRB+Jyw9o
         wCeeTW8/3JrupwRcSMkRk19pE0qT7v0dZyOfewzxZHHfxwOAn4JJqsD47olxoIEKvevU
         Bp2E0EEB+IDjnVmUaJJVvtZo2sVhcYGT7gV8GRW8oy8on/OfVZTZi/ASJ/vqs97gkW40
         6dHU3tPlNwTstgrc/iq5lT2vVTSjuUz9etpxtBNmcKhjZuHXb3AaKwz2dQNynSOrUMDh
         r/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736875006; x=1737479806;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u74CP0NJS+PC9+0Z7XNNpmdYcHLg1NRT5zsP8fpkZAI=;
        b=IuKnTDbVxN4AZkr7UP4NkqVJwkB1AN0ByiYvSOcg5bumFN9aJyqbsYKuZZi1sFjjTW
         huQug2XlIUK4STjfvnUVAPQF1kNFGCPxDAlpRz0eWMiPnHEDr+6G53JOH25ki+3/Ou3I
         ljb4CgOsjjROPMvdgHE409c4eS97ZXunqtZ0z+t7S0mjMW20C+D1nIb/YC4ZyaGp9q2Z
         8f++kVN+ZLqQChz7SEEWr8yedMJ8wIdQX6eq7ksuPKG0qsNtIRp1TFDmluNtY6dbn4Af
         QIbk5Hb2DsOpAuzbMstqsl4vktffj0a493ZHAdeC+cU6Fa6HIcoKg7Bp1EQqBleyfYgr
         AuNA==
X-Forwarded-Encrypted: i=1; AJvYcCUqvKejiNDa71W4Zpbav8PYd1WXDpM5pd14hS3nztdRseolaVMzkDPD71aw6jbPQvw/7wI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7aRDW5UWaEsOLpijkZ/HXoKCYbhcQusSUKlSSJOjuPP8rBLaA
	+xrWUtWFAe0QcNFIJAvvE+7PXme5QUJ8Sc2yKg+CslYyj0U/PBFBEe5b3uGUZwdfsjAqZ/ORos+
	VYw==
X-Google-Smtp-Source: AGHT+IHxta/ktS4zlc/MUT7tVP6jASkwW2gElG2G6WYPHea18NR/BWeEycMdSsjZoF0Ux5NfkN0P39F+tQo=
X-Received: from pjbdy4.prod.google.com ([2002:a17:90b:6c4:b0:2ef:7af4:5e8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e0d:b0:2ea:3f34:f190
 with SMTP id 98e67ed59e1d1-2f548f43fa2mr36453531a91.25.1736875006545; Tue, 14
 Jan 2025 09:16:46 -0800 (PST)
Date: Tue, 14 Jan 2025 09:16:45 -0800
In-Reply-To: <Z4YSVGDL7hL2iwVl@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111010409.1252942-1-seanjc@google.com> <20250111010409.1252942-3-seanjc@google.com>
 <Z4TdaxQwMuA7NM5g@yzhao56-desk.sh.intel.com> <Z4U13s_TeP3jAedh@google.com> <Z4YSVGDL7hL2iwVl@yzhao56-desk.sh.intel.com>
Message-ID: <Z4ab_WPpOqhub5uR@google.com>
Subject: Re: [PATCH 2/5] KVM: Bail from the dirty ring reset flow if a signal
 is pending
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 14, 2025, Yan Zhao wrote:
> On Mon, Jan 13, 2025 at 07:48:46AM -0800, Sean Christopherson wrote:
> > On Mon, Jan 13, 2025, Yan Zhao wrote:
> > > On Fri, Jan 10, 2025 at 05:04:06PM -0800, Sean Christopherson wrote:
> > > > Abort a dirty ring reset if the current task has a pending signal, as the
> > > > hard limit of INT_MAX entries doesn't ensure KVM will respond to a signal
> > > > in a timely fashion.
> > > > 
> > > > Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >  virt/kvm/dirty_ring.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > > 
> > > > diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> > > > index 2faf894dec5a..a81ad17d5eef 100644
> > > > --- a/virt/kvm/dirty_ring.c
> > > > +++ b/virt/kvm/dirty_ring.c
> > > > @@ -117,6 +117,9 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> > > >  	cur_slot = cur_offset = mask = 0;
> > > >  
> > > >  	while (likely((*nr_entries_reset) < INT_MAX)) {
> > > > +		if (signal_pending(current))
> > > > +			return -EINTR;
> > > Will it break the userspace when a signal is pending? e.g. QEMU might report an
> > > error like
> > > "kvm_dirty_ring_reap_locked: Assertion `ret == total' failed".
> > 
> > Ugh.  In theory, yes.  In practice, I hope not?  If it's a potential problem for
> > QEMU, the only idea have is to only react to fatal signals by default, and then
> > let userspace opt-in to reacting to non-fatal signals.
> So, what about just fatal_signal_pending() as in other ioctls in kernel?

Ya, though I would leave the decision up to Peter or Paolo (or someone else that
knows what QEMU wants/prefers/tolerates).

> if (fatal_signal_pending(current))
> 	return -EINTR;

