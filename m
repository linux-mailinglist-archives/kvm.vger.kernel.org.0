Return-Path: <kvm+bounces-47277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD961ABF8B9
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D26E9E6F2C
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 14:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C770217709;
	Wed, 21 May 2025 14:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VIEvLMp1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808221E3DED
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 14:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747839289; cv=none; b=gFsKP95SMRD4a7IQKleoXmZtcf6bSiu+JIZN9YgKD6k6ik0Rcm1Cb2lkNkLlcFfRGLUforQxZhMvMEL7r5xk5Bc4MvbxFlYQ6HBqkAC3J2oNPAJQ/wU5FHsF3QaYOHHH814dCVcLCP0tVPsQcycmW6sHdflfCV5jNvGt5oU8Plw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747839289; c=relaxed/simple;
	bh=g5o3Nqq+12QtnhdnyLa71d3lmoiKsw+P4TPbuoPLHZ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V2JagRay0aJRxmcI8RXtw8YwYuC3iIeUS7Uu7l1xyvPgOjayDxaRrlh/PEuR8YXF5NwawGImZLkSEeJ/kRNOZ2jTgiIaNn2KD0sdHJl0cPUPC+AXBUYnrTLcvF+NvspHfHLJHfvmNMGR/YqbnO9LpEpHocSCYdseZ0pVwWmmi0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VIEvLMp1; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30ed0017688so3486641a91.2
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 07:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747839287; x=1748444087; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=thYs3889Ousb7k+ZZfQYw/dD0hy82Q8J9WVoVEq9Omc=;
        b=VIEvLMp1i1MqExyDjT+LlPoAMtoBa7szBruNgrHtopq/NW78LLoZBvMULgt3b+/zJp
         PMW25Uv35Xfg/Ry/S++uNZmI/4fQX9vv40M0ljlNFIhx2tDXTztL1vk+SnsiSoJFaRnl
         sc1IdEDw+08048naNNnYDruD8vvwwOXpdKBTEj3CtR4Ib6BM1hsFy5iSNoSyrqcGTHAu
         3q8OUBY8dKv8YCHJ28XseFU9mv6xs7c+oY38c3b5Amgor7U5jd0qjxcMPNrZPre8f8xF
         xvizVEqguw5wP9dK93eYL7rsK9Sr0TwsbiMm85UX9wfnATzCeLVrCfdmyRyPevZ2rUdU
         TrjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747839287; x=1748444087;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=thYs3889Ousb7k+ZZfQYw/dD0hy82Q8J9WVoVEq9Omc=;
        b=q/wPXaBwg0cXkiMUhI3R27SlrZxNGIUO5qiw+ZT3G69YD8YxnVfk9cC3grfqFhgqe+
         Kgn26t7ZtqG0I2DU/K8zHXt3lQoioGi4D7V5qaZyz4I4n9xPZaO8t2kTjlYoTYQfIp64
         E4LlsBHrqml84MSRqkoEMvhfLpI0Bv7PTimnkR8IRvhVHVVHBhOXJdX2p0UIQvmoB/lC
         wkA1+uZ590EYpZm7JQv+JLc7Uy2XcPqKwCB8lMe4xEeWO19vjHvBoOptlUJFB9HI/FqQ
         +QOAmpa/SCibYZRguCEVyNJJcXG/ly2X+wX/9F7cz/m7HLAnzpU7ABfEqLyQvPujrcsH
         k9zg==
X-Forwarded-Encrypted: i=1; AJvYcCVis4GGI2D+FCJffDVLp4DoBdUvRNwR3d04HeLlCnsSXkBG4r6Ox7FobSFmWGXH+oTrXl4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh3zDJcByQWlLH33BpiVPxQBWeL1soWNk/WRKUZp7ferVBXqHY
	vHs/Jiu4YIzqbpg0Yd3RrnspWWyHwbHj1tqbnzazITlzqfBIVZb5b6c5HJepAjSdRkod2AcUlkF
	giw5lKA==
X-Google-Smtp-Source: AGHT+IF6SYrFe7nPRPAq7TPWgFsw7aSxwiQ8XUDXD5y3+wwBUIEf+xIrrkqqONC3ZB2dH96qLqBKSiFqODw=
X-Received: from pjj13.prod.google.com ([2002:a17:90b:554d:b0:2fc:11a0:c549])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c45:b0:30a:4c29:4c9c
 with SMTP id 98e67ed59e1d1-30e7d4eeecdmr31100671a91.6.1747839286735; Wed, 21
 May 2025 07:54:46 -0700 (PDT)
Date: Wed, 21 May 2025 07:54:45 -0700
In-Reply-To: <aC2Z1X0tcJiAMWSV@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516213540.2546077-1-seanjc@google.com> <20250516213540.2546077-6-seanjc@google.com>
 <aC2Z1X0tcJiAMWSV@yzhao56-desk.sh.intel.com>
Message-ID: <aC3pNVfgNcnuJXUG@google.com>
Subject: Re: [PATCH v3 5/6] KVM: Use mask of harvested dirty ring entries to
 coalesce dirty ring resets
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, James Houghton <jthoughton@google.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 21, 2025, Yan Zhao wrote:
> On Fri, May 16, 2025 at 02:35:39PM -0700, Sean Christopherson wrote:
> > @@ -141,42 +140,42 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> >  		ring->reset_index++;
> >  		(*nr_entries_reset)++;
> >  
> > -		/*
> > -		 * While the size of each ring is fixed, it's possible for the
> > -		 * ring to be constantly re-dirtied/harvested while the reset
> > -		 * is in-progress (the hard limit exists only to guard against
> > -		 * wrapping the count into negative space).
> > -		 */
> > -		if (!first_round)
> > +		if (mask) {
> > +			/*
> > +			 * While the size of each ring is fixed, it's possible
> > +			 * for the ring to be constantly re-dirtied/harvested
> > +			 * while the reset is in-progress (the hard limit exists
> > +			 * only to guard against the count becoming negative).
> > +			 */
> >  			cond_resched();
> >  
> > -		/*
> > -		 * Try to coalesce the reset operations when the guest is
> > -		 * scanning pages in the same slot.
> > -		 */
> > -		if (!first_round && next_slot == cur_slot) {
> > -			s64 delta = next_offset - cur_offset;
> > +			/*
> > +			 * Try to coalesce the reset operations when the guest
> > +			 * is scanning pages in the same slot.
> > +			 */
> > +			if (next_slot == cur_slot) {
> > +				s64 delta = next_offset - cur_offset;
> >  
> > -			if (delta >= 0 && delta < BITS_PER_LONG) {
> > -				mask |= 1ull << delta;
> > -				continue;
> > -			}
> > +				if (delta >= 0 && delta < BITS_PER_LONG) {
> > +					mask |= 1ull << delta;
> > +					continue;
> > +				}
> >  
> > -			/* Backwards visit, careful about overflows!  */
> > -			if (delta > -BITS_PER_LONG && delta < 0 &&
> > -			    (mask << -delta >> -delta) == mask) {
> > -				cur_offset = next_offset;
> > -				mask = (mask << -delta) | 1;
> > -				continue;
> > +				/* Backwards visit, careful about overflows! */
> > +				if (delta > -BITS_PER_LONG && delta < 0 &&
> > +				(mask << -delta >> -delta) == mask) {
> > +					cur_offset = next_offset;
> > +					mask = (mask << -delta) | 1;
> > +					continue;
> > +				}
> >  			}
> > -		}
> >  
> > -		/*
> > -		 * Reset the slot for all the harvested entries that have been
> > -		 * gathered, but not yet fully processed.
> > -		 */
> > -		if (mask)
> > +			/*
> > +			 * Reset the slot for all the harvested entries that
> > +			 * have been gathered, but not yet fully processed.
> > +			 */
> >  			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> Nit and feel free to ignore it :)
> 
> Would it be better to move the "cond_resched()" to here, i.e., executing it for
> at most every 64 entries?

Hmm, yeah, I think that makes sense.  The time spent manipulating the ring and
mask+offset is quite trivial, so checking on every single entry is unnecessary.

