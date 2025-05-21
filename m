Return-Path: <kvm+bounces-47308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F160AABFD82
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 21:45:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28EE69E76FD
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 19:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C713A235360;
	Wed, 21 May 2025 19:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gL1vVeiE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C44D1A7AE3
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 19:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747856748; cv=none; b=TSyrIBOuyLjxPWBtLF/QpX2aaks60HKwuMXNYT/KA1W7ZAbRZsYwri1J34mlWcZZDJ2aLo3TaK1r8tAzLMESBFy3I5P6C8PTUTftZ8tVCCaqHyJ8UDZ3k6hy7RaEl5j1qIJ+M942vhpParpAeyKC9tnm288jNO43Urt2z7HoYbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747856748; c=relaxed/simple;
	bh=w/KQK//gGuiZHs6feqriYpY0wTfbHX9Fx3R5JWgYka4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V5dnnWs681x3SLMGvmU4o54uhG+cAwJmyW71XRxstCSZ+gKiYBLILrtDteUlM2OqvHOsEpf+NOvohndYybg5kf6LuHh1+fwuQv1gyDJIEKPADdk6wpO5n1DaHRjl/DI2Nmv9oSvhzvvY44qD/8x6H31PHJXzy2TLI9hZTtHdkGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gL1vVeiE; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e78145dc4so7879641a91.2
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 12:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747856746; x=1748461546; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fJskKCNcT8u+ZGbfFAjJXMYt+V7lIICBJ59GECqjzXE=;
        b=gL1vVeiEvaVHWPH87FroaWJbHcdz8wy7NwAsGQL3HX5Qp9YiPfSEP6t12X5YPo0z6q
         Hb8nEb+Ub3hry9tS3S0ClPkmtvCjQx+PMDo4Kr17vnOEAJwCgpG6erC1d0VhmaMVov7z
         26T5rxoochFOVfWLvojYE95WLISXPRPe8E+JUw2Y2bnCXHsQjRTbPVWfF32FDn6dUyiM
         YCriVMyOIQdSB0G3/bHJV5qfUFyv1WE53Q3BrMQ5aon/Z5RFAQac2bjK5F09kedyhc35
         jI94Tr4IR/+zYle0gz2lkda8nRNHAIrs1qeSg7yRDl8H7z2gTznyoq1bJ8E8AYWJCPOQ
         XZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747856746; x=1748461546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fJskKCNcT8u+ZGbfFAjJXMYt+V7lIICBJ59GECqjzXE=;
        b=UPbROxtpPTGbnoQOYRvo6ji4oiWhNlslyCCeyzK7N1+fqldkNsw+i0XcJfM/wuIENk
         hjxxUvtOpd3IEyyR8dSUyhaAg+y7EWuOpicECaE7AsT8GhJ5mehlGsTb+X3i2sTwkXCs
         d4hVtK3WtddywTNvHhT2lzUuIjdmiqOXTe4TCWJ/UikucymSPCb+rkxl8/YOZb3tEoFH
         WcmisG66a2xGx4UmZusDsK7o0fsuTGf5GiRuyp0Mj7L7WCP9E2aOzIfUv7F3kaTd6TkR
         jSxRheDv4/1ZZkLcGeiZ6AwVWcCepq0OBrRAf7kt/w7g3EAeFEcWQnWMLtxczVeI+toe
         E5zw==
X-Forwarded-Encrypted: i=1; AJvYcCXS5HaIHWAb6OVg6/JlnGsf/2jJ7xqa/T9Aq9OHZPiSwFEoJ2Rkm297l+42vNtpvWTtczE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFn5yB1Ip3TPUws1ksFzjh61i22A5tEvQelpy9euTLHcAnXhPX
	60VW0XFp2xTL2N6Rbc1YuM7qUctoAZyVrxsJZF3NGmHaj5/nyP0J86faNWT1aN77D3YiUJzQVq5
	rrEd/6g==
X-Google-Smtp-Source: AGHT+IH5Hu79pYadIlaminwNsuDOzWNHSuqJi/bY0E31HF6EV6XPSwZJrHO3LDFQ99bghSKyKm/AqQjVQak=
X-Received: from pjb6.prod.google.com ([2002:a17:90b:2f06:b0:2f8:49ad:406c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e8e:b0:2ff:64a0:4a58
 with SMTP id 98e67ed59e1d1-30e7d5a8ademr28966699a91.22.1747856745714; Wed, 21
 May 2025 12:45:45 -0700 (PDT)
Date: Wed, 21 May 2025 12:45:44 -0700
In-Reply-To: <aC3pNVfgNcnuJXUG@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516213540.2546077-1-seanjc@google.com> <20250516213540.2546077-6-seanjc@google.com>
 <aC2Z1X0tcJiAMWSV@yzhao56-desk.sh.intel.com> <aC3pNVfgNcnuJXUG@google.com>
Message-ID: <aC4taDzB45fUNQJr@google.com>
Subject: Re: [PATCH v3 5/6] KVM: Use mask of harvested dirty ring entries to
 coalesce dirty ring resets
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, James Houghton <jthoughton@google.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 21, 2025, Sean Christopherson wrote:
> On Wed, May 21, 2025, Yan Zhao wrote:
> > On Fri, May 16, 2025 at 02:35:39PM -0700, Sean Christopherson wrote:
> > > @@ -141,42 +140,42 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> > >  		ring->reset_index++;
> > >  		(*nr_entries_reset)++;
> > >  
> > > -		/*
> > > -		 * While the size of each ring is fixed, it's possible for the
> > > -		 * ring to be constantly re-dirtied/harvested while the reset
> > > -		 * is in-progress (the hard limit exists only to guard against
> > > -		 * wrapping the count into negative space).
> > > -		 */
> > > -		if (!first_round)
> > > +		if (mask) {
> > > +			/*
> > > +			 * While the size of each ring is fixed, it's possible
> > > +			 * for the ring to be constantly re-dirtied/harvested
> > > +			 * while the reset is in-progress (the hard limit exists
> > > +			 * only to guard against the count becoming negative).
> > > +			 */
> > >  			cond_resched();
> > >  
> > > -		/*
> > > -		 * Try to coalesce the reset operations when the guest is
> > > -		 * scanning pages in the same slot.
> > > -		 */
> > > -		if (!first_round && next_slot == cur_slot) {
> > > -			s64 delta = next_offset - cur_offset;
> > > +			/*
> > > +			 * Try to coalesce the reset operations when the guest
> > > +			 * is scanning pages in the same slot.
> > > +			 */
> > > +			if (next_slot == cur_slot) {
> > > +				s64 delta = next_offset - cur_offset;
> > >  
> > > -			if (delta >= 0 && delta < BITS_PER_LONG) {
> > > -				mask |= 1ull << delta;
> > > -				continue;
> > > -			}
> > > +				if (delta >= 0 && delta < BITS_PER_LONG) {
> > > +					mask |= 1ull << delta;
> > > +					continue;
> > > +				}
> > >  
> > > -			/* Backwards visit, careful about overflows!  */
> > > -			if (delta > -BITS_PER_LONG && delta < 0 &&
> > > -			    (mask << -delta >> -delta) == mask) {
> > > -				cur_offset = next_offset;
> > > -				mask = (mask << -delta) | 1;
> > > -				continue;
> > > +				/* Backwards visit, careful about overflows! */
> > > +				if (delta > -BITS_PER_LONG && delta < 0 &&
> > > +				(mask << -delta >> -delta) == mask) {
> > > +					cur_offset = next_offset;
> > > +					mask = (mask << -delta) | 1;
> > > +					continue;
> > > +				}
> > >  			}
> > > -		}
> > >  
> > > -		/*
> > > -		 * Reset the slot for all the harvested entries that have been
> > > -		 * gathered, but not yet fully processed.
> > > -		 */
> > > -		if (mask)
> > > +			/*
> > > +			 * Reset the slot for all the harvested entries that
> > > +			 * have been gathered, but not yet fully processed.
> > > +			 */
> > >  			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > Nit and feel free to ignore it :)
> > 
> > Would it be better to move the "cond_resched()" to here, i.e., executing it for
> > at most every 64 entries?
> 
> Hmm, yeah, I think that makes sense.  The time spent manipulating the ring and
> mask+offset is quite trivial, so checking on every single entry is unnecessary.

Oh, no, scratch that.  Thankfully, past me explicitly documented this.  From
patch 3:

  Note!  Take care to check for reschedule even in the "continue" paths,
  as a pathological scenario (or malicious userspace) could dirty the same
  gfn over and over, i.e. always hit the continue path.

A batch isn't guaranteed to be flushed after processing 64 entries, it's only
flushed when an entry more than N gfns away is encountered.

