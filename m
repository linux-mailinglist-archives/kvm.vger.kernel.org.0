Return-Path: <kvm+bounces-35302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E837DA0BD7D
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 17:30:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B3C33AB980
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 16:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD41A22BABD;
	Mon, 13 Jan 2025 16:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t8QaL0Ld"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8393A22BAAA
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 16:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736785690; cv=none; b=p+meMZDgcPq3F8aLCYh8NGw/d+KK0q0On2+4wufU1YGL5/WUNGPsm7NOCSpprQoxRrBKI6/b50KXnftGuAixC3soQUrLMHJhxzkB9tdoPNELEG4KGptyuPbP2+47hSM/IQLlrMvOKO2wYxHjH7S1JtmMwYXisM7D0Ttcb9wI2qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736785690; c=relaxed/simple;
	bh=OFqmR4pQyacu3qz8WDQLw3IVhOuZKiexucTpsDBrGiY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qw+XKyhLfMy1C196WzdzVVOa/Mgqx+FMY4ZvAscmhm1DtoptwvawQ7Yx+Q1oz+ojgJNaAqPyC4AnikpHpY/paRH7ZBbnVtGEQ7o0HLeeZtKREchGi4KzW/QQ3C5R4nMj1dZexCfWk7JWpgVbQR/RbJigTFFW1rtOn24KeTb22eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t8QaL0Ld; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef80d30df1so7717976a91.1
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 08:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736785688; x=1737390488; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kxBRobYSKMOIg8M+dmSSfAke++9WEaaBlf5KGft5ZTU=;
        b=t8QaL0LdwVxpmf11KZlWfDh2OPzMPfuCUrPGB4N+/VcT7iiFb2WRVn1tlJ0NCzqdY0
         gxWZTFdJoZALNWn2KRFv8tO/5MAqX3/fmHN19KXMEnimyD5DKcQNOLlAp0iuuYo661rU
         dTaWs2mVqN1BH7ro+Wa6NCKLP/11R4BOrcSa3K57P7jGgxfXfPSXUigjkGvYvZzGpB2I
         +HugXCjBaDyyG1pXWsOqjA7ju+mftsItYnF2ocYfTgFQ8sQkZWFgNeT90NE11KY5uJbf
         ohOxqkXQcPHRQZSV24jSoHSgPiEuWXBUcS4m8yGRygAeM9QWYnyL7t5ab0bu3PaWGKoI
         fb0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736785688; x=1737390488;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kxBRobYSKMOIg8M+dmSSfAke++9WEaaBlf5KGft5ZTU=;
        b=TcC539TDbladIesJzsrgW7LK5vV6L8+AAWaOCj6rqn/Iiz6utVyCuScfjVkNwbjZGT
         PY6tmIm/KSUsPDaKG5KOnz4iqRgHwFakaFkfuSQMJ7A15c7JHe2I9vdsAYIbbwvhqod1
         A4rdpHBwXZxQ5RYeWtVeZfq8YiiyYeUZBNk/IdRvXNnlkasVB/5RkX/hZz1v4t9EAZy6
         0cTLfCG3sIY9EM49DIQWnhW898FBQF0Ks9k23Oxez1eaAzTkLOcJVIfVn2+slZMD2QfI
         KS2VJLdwOfz/dBGp+dZoXjVAeYsR2XyU4b4q02+xdS3EoMUy1xCUqeU+BmeylcHF/DFI
         tWUg==
X-Forwarded-Encrypted: i=1; AJvYcCWrar5X/LJitkGW+HS2YPOuHYzdkvKANqycU4gkId06alxPtgMGiaxyoKhnpteeKkZjFfs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzF5pUl4yz9LNMHpnp4mQnmq1asgBRm5VAmTsTCpBo7aHinX+bS
	EdbR3vVFqgCqSYA5uezoNuRJJKqzZPpy1Qrd36v2/XKVn/5PcwuAHD+zqVTV0DwgDhsBIXO1cFd
	IBg==
X-Google-Smtp-Source: AGHT+IHm8mlLtOHzzRN/IJkeOc9u0LPz1Em92fdzBNz9Den2ih2pyvwwsfys1g8gLHWG4HBBBtv/laNZ6f8=
X-Received: from pfxa2.prod.google.com ([2002:a05:6a00:1d02:b0:72a:a7a4:9a53])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1811:b0:725:e057:c3de
 with SMTP id d2e1a72fcca58-72d21feda34mr30656075b3a.23.1736785687864; Mon, 13
 Jan 2025 08:28:07 -0800 (PST)
Date: Mon, 13 Jan 2025 08:28:06 -0800
In-Reply-To: <Z4S65wQcApuITa7h@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111010409.1252942-1-seanjc@google.com> <20250111010409.1252942-4-seanjc@google.com>
 <Z4S65wQcApuITa7h@yzhao56-desk.sh.intel.com>
Message-ID: <Z4U_FvvdSBXrzENW@google.com>
Subject: Re: [PATCH 3/5] KVM: Conditionally reschedule when resetting the
 dirty ring
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 13, 2025, Yan Zhao wrote:
> On Fri, Jan 10, 2025 at 05:04:07PM -0800, Sean Christopherson wrote:
> > diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> > index a81ad17d5eef..37eb2b7142bd 100644
> > --- a/virt/kvm/dirty_ring.c
> > +++ b/virt/kvm/dirty_ring.c
> > @@ -133,6 +133,16 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> >  
> >  		ring->reset_index++;
> >  		(*nr_entries_reset)++;
> > +
> > +		/*
> > +		 * While the size of each ring is fixed, it's possible for the
> > +		 * ring to be constantly re-dirtied/harvested while the reset
> > +		 * is in-progress (the hard limit exists only to guard against
> > +		 * wrapping the count into negative space).
> > +		 */
> > +		if (!first_round)
> > +			cond_resched();
> > +
> Will cond_resched() per entry be too frequent?

No, if it is too frequent, KVM has other problems.  cond_resched() only takes a
handful of cycles when no work needs to be done, and on PREEMPTION=y kernels,
dropping mmu_lock in kvm_reset_dirty_gfn() already includes a NEED_RESCHED check.

> Could we combine the cond_resched() per ring? e.g.
> 
> if (count >= ring->soft_limit)
> 	cond_resched();
> 
> or simply
> while (count < ring->size) {
> 	...
> }

I don't think I have any objections to bounding the reset at ring->size?  I
assumed the unbounded walk was deliberate, e.g. to let userspace reset entries
in a separate thread, but looking at the QEMU code, that doesn't appear to be
the case.

However, IMO that's an orthogonal discussion.  I think KVM should still check for
NEED_RESCHED after processing each entry regardless of how the loop is bounded.
E.g. write-protecting 65536 GFNs is definitely going to have measurable latency.

