Return-Path: <kvm+bounces-35304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C30EA0BDF3
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 17:48:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B3F3164043
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 16:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C112229804;
	Mon, 13 Jan 2025 16:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OjiyP7dw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0322297E1
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 16:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736786912; cv=none; b=geROdQUSpzOG2jLLpBMwCnxQqB24a5RJDNIwjWdxenL5M/aKyed7KdLNxEvIVE63SAJIzanZwqs0qxkez0qL4v4pKAdNwNFN9VeO4u+G1wbftpBZmpKSV/51StUCgkrO0py13oajLcWwrWKhWWVBvhbWTK9c2b1PtRPvOX/+okc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736786912; c=relaxed/simple;
	bh=AqUEg4jPd3gdc0ZrKxbCPxP508slXmBYza21VJEGWmM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o3Dz1Wn5/VGwc1qrZ6LWwxcRwV/DmvSvuirGzusGNZyI2TExHlrQUYKQsQePMeUw5dix9FthmBE8vxKmgDtBVv38d4CvJOUFZ3Nj7sQc6lB/eR/yKBysAyL2aVmKVAo+oGOuPX9veOL9jDbGfF10BBPNNx60SoSYx9rQhnG8HVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OjiyP7dw; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-216430a88b0so85620295ad.0
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 08:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736786910; x=1737391710; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KdzkJXloILoledAikhtT8z+TQc6Jd5QhrekVDplnaf8=;
        b=OjiyP7dwderoERZNQGkPM45q6Lh9y93CEXp3hjiXspN7KvbfrmOrlnDnxzdH4/HlMD
         RZ98Uqtq0+NMrfgY9tD8ZDK3WLI7189Y8AdCEROqhnWNq6ki82npp+juZCXrkI9Q7Y+V
         CiCKYYIepzugfpiFLuWhypuvgJaZzvF7yYLN6inRX+LLt4FyyQ8AEv3wPIYe6LDFzIYI
         EJ4h7L8joETO+Nrl4pjbmcH9z+Uy9AV/YeXJ0/WM1SrL3AUowahQORwnOOpO4YGdBYBq
         1jsc5vE14Zy8w3lSpVWDN/5av2Kkpn3dRl7maw1a/+LADyzNFs42HgHqOnyn+c7bH/Tf
         Z8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736786910; x=1737391710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KdzkJXloILoledAikhtT8z+TQc6Jd5QhrekVDplnaf8=;
        b=RkHidfeHL7syB8hs9M/Sfh+R2skGi6312aRHX2jMnBSzZbJ8JuEzLDjrkB0g4kkYba
         x78KJg6XfUt/OA9Z4yAw69UyxsU8iDrNTIG0oq9BPnlTFOGf3sd2JMgGfwUKK0NUR2sB
         VhiwD2Sz2R81Tu50L6IkT5yjmRPgPH6sLyDQkuTqtGIv9w4sBGICO6WngttMI/ezjoqk
         zXjomYPk7UjfPs4PyyDMXwVSHCu5d6arKjdK95bRCWrlOQllhA28pWCv3WoYruJXJLTo
         a/AmS/5XPgs9jBt3b5bvDYsYj19ovNJRMLfc0TPQgzqkd9bexW4l16r29nVXfLS/WTkL
         NE5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXQnEVr0R7zO3kRzfEalWJHfCNrrBjCYZuWtgfE3QpbEZ7oBgKzb/0a0uk0DnKyRlQ5zwg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzD4iDwdmlgHWz/EcMidKWE2vmJPIQFNgJ7TTw91UM/gUoRfNhT
	c8u6rXjTRkrr+8CYAPbYdCOn7k2tyhajyCCsmr/fZTMwh8kwJIjuSxCG+rV/Cxk1PKyhycWeepu
	I5Q==
X-Google-Smtp-Source: AGHT+IEhXLguLVVlB2uMkRYKCqWDmWgyqzXZyQWRPUNpNJuNKno1KXMBErxQc0c7qjKIHmxBNNTEv0LCsQ0=
X-Received: from pfbmc53.prod.google.com ([2002:a05:6a00:76b5:b0:728:e2c6:8741])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:431a:b0:1d2:eb91:c0c1
 with SMTP id adf61e73a8af0-1e88d0ddde5mr33087152637.42.1736786909791; Mon, 13
 Jan 2025 08:48:29 -0800 (PST)
Date: Mon, 13 Jan 2025 08:48:28 -0800
In-Reply-To: <Z4TrQedpUgNrW2OB@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111010409.1252942-1-seanjc@google.com> <20250111010409.1252942-5-seanjc@google.com>
 <Z4TrQedpUgNrW2OB@yzhao56-desk.sh.intel.com>
Message-ID: <Z4VD3AaQskK7IkYU@google.com>
Subject: Re: [PATCH 4/5] KVM: Check for empty mask of harvested dirty ring
 entries in caller
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 13, 2025, Yan Zhao wrote:
> On Fri, Jan 10, 2025 at 05:04:08PM -0800, Sean Christopherson wrote:
> > @@ -163,14 +157,31 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> >  				continue;
> >  			}
> >  		}
> > -		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > +
> > +		/*
> > +		 * Reset the slot for all the harvested entries that have been
> > +		 * gathered, but not yet fully processed.
> > +		 */
> I really like the logs as it took me quite a while figuring out how this part of
> the code works :)
> 
> Does "processed" mean the entries have been reset, and "gathered" means they've
> been read from the ring?

Yeah.

> I'm not sure, but do you like this version? e.g.
> "Combined reset of the harvested entries that can be identified by curr_slot
> plus cur_offset+mask" ?

I have no objection to documenting the mechanics *and* the high level intent,
but I definitely want to document the "what", not just the "how".

> > +		if (mask)
> > +			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > +
> > +		/*
> > +		 * The current slot was reset or this is the first harvested
> > +		 * entry, (re)initialize the metadata.
> > +		 */
> What about
> "Save the current slot and cur_offset (with mask initialized to 1) to check if
> any future entries can be found for a combined reset." ?

Hmm, what if I add a comment at the top to document the overall behavior and the
variables,

	/*
	 * To minimize mmu_lock contention, batch resets for harvested entries
	 * whose gfns are in the same slot, and are within N frame numbers of
	 * each other, where N is the number of bits in an unsigned long.  For
	 * simplicity, process the current set of entries when the next entry
	 * can't be included in the batch.
	 *
	 * Track the current batch slot, the gfn offset into the slot for the
	 * batch, and the bitmask of gfns that need to be reset (relative to
	 * offset).  Note, the offset may be adjusted backwards, e.g. so that
	 * a sequence of gfns X, X-1, ... X-N can be batched.
	 */
	u32 cur_slot, next_slot;
	u64 cur_offset, next_offset;
	unsigned long mask = 0;
	struct kvm_dirty_gfn *entry;

and then keep this as:

		/*
		 * The current slot was reset or this is the first harvested
		 * entry, (re)initialize the batching metadata.
		 */

> 
> >  		cur_slot = next_slot;
> >  		cur_offset = next_offset;
> >  		mask = 1;
> >  		first_round = false;
> >  	}
> >  
> > -	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > +	/*
> > +	 * Perform a final reset if there are harvested entries that haven't
> > +	 * been processed. The loop only performs a reset when an entry can't
> > +	 * be coalesced, i.e. always leaves at least one entry pending.
> The loop only performs a reset when an entry can be coalesced?

No, if an entry can be coalesced then the loop doesn't perform a reset.  Does
this read better?

	/*
	 * Perform a final reset if there are harvested entries that haven't
	 * been processed, which is guaranteed if at least one harvested was
	 * found.  The loop only performs a reset when the "next" entry can't
	 * be batched with "current" the entry(s), and that reset processes the
	 * _current_ entry(s), i.e. the last harvested entry, a.k.a. next, will
	 * will always be left pending.
	 */

> > +	 */
> > +	if (mask)
> > +		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> >  
> >  	/*
> >  	 * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared
> > -- 
> > 2.47.1.613.gc27f4b7a9f-goog
> > 

