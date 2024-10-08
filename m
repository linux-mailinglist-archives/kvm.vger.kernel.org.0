Return-Path: <kvm+bounces-28151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 75AD699577C
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 21:15:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECF291F26F5B
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 19:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D5EF213ED5;
	Tue,  8 Oct 2024 19:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TVABWEmg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DDE1F472B
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 19:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728414918; cv=none; b=dt2Y/O4nh2lultSfU3zawcyEPBSgetvvzgOHFYMi7i2pkMEmX8Kl6jno0bPiW+qU61uev8X4mA0ykc9CdUKbLN/maUSweOVm3VQgIpufFZGYOHOFJWvF92cxEv2pzwrUp5qCXBkSd9RxVjcHkyjEhnVyM7L/VaSgI1SnuGOfqzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728414918; c=relaxed/simple;
	bh=uxyP+G90T5Z46UyueTr78UUAWQH9McOja+2QMJkzsjo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BAzNqghd65pxRSFkQdKXAUQePteqygWBPm1rnlrhwqLM0jy3/RbFurem/oe6sr/HAP3mV3WJCwa6JlPyD/P5UD/JJLxlXcuir0wLd2jEYcBLhstcOD9ES5e8MZta/zELLJqhbC3+gj38qobX8YsWKezlUpZV6YjgmR1Oy52xa7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TVABWEmg; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e21dcc7044so87791447b3.1
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2024 12:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728414916; x=1729019716; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YWbK2GHs6Abt2fMXMTJtF7ITQZREFcgTyAL1OTvzEzA=;
        b=TVABWEmgeKWNqz2u08Pkp1gUdchyWC4pOMRb305o/80extUUoRcHH9MghK/1XKn4Xr
         vktC59fTJokMt/j9iRe+ecZx4lomdBDBuN9/jfWPiE2cQwlOi7oQwOrsFfuc/UEkhoGk
         XIrwBLBQklBqalecrVhW4t5YDZxxSQYCxoEqW2nEGqZ8UJIb6hd1+bGQ3nQPtu+e+hge
         qZ5BndgSPy58Rb64XFqrkbyKUmolGwGGYZgZDI6/QX52CGSlSSfuZVgtHclX2ErcjERF
         c5Da0u9N/MCeEXTEcuPKwn+K4iXn8l94WwoLCxPUjdFXlTWr7z6B4c1qvypPJ02XlL7f
         xuUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728414916; x=1729019716;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YWbK2GHs6Abt2fMXMTJtF7ITQZREFcgTyAL1OTvzEzA=;
        b=sGbzdEthM4HJnj9jxs0aBoeM4KqDY6KhAuQb851ZX4kVUPfXkXip2jUCX3J37vRsov
         dYVtY/i4RWumUBeGPeI8FufBBuJXuWrQ2FUprGnozHjhZTLaGAI1+LKgZYiAeiINdZsT
         GWo2D35axoXuDW8zULth25ni8ANSSNvLhScdpE4r6ShhMoXMhsRXcnNaz8MVgbc3Xx4V
         I91nIDDSU7AF7QDexq5qJnv+64KapSwE28U4Pg8m2ivgWv5tTXaJTxUtDbo4aRsOVPNU
         vcGpWPPk6Fvqjn5LF03tgGbk1iXFuRmvZSVDGS0KsRNSaGwhjktvkf7ZnBhoPtkzqlRp
         nBZA==
X-Forwarded-Encrypted: i=1; AJvYcCVopT0eA/7zKihMxzS4dpBB6OA5OvM71wc9PSmiHiD352ljGDArgrCEN4sTlYAzMpp8JO4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAd/9jRJ4w0AQRx2GuO1DgKpeTKZoZ6116CzDEJWG9EOWN5afV
	qFLptWqk4HeeEcjixXh7V5+UxEAhpRZTkh1UpiVkapswAXmo6v/jjGdglFJhoKpK3wBXh8YdaLM
	47A==
X-Google-Smtp-Source: AGHT+IHxscgrbZUbpRMZFTv0mtM0fh4IXzW81h1gMKWUpeG/Fr+LBw21kX62SIQc+671mmmchltyWE1KylY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:20a3:b0:6e3:b08:92c7 with SMTP id
 00721157ae682-6e321fb7d24mr7937b3.0.1728414915807; Tue, 08 Oct 2024 12:15:15
 -0700 (PDT)
Date: Tue, 8 Oct 2024 12:15:14 -0700
In-Reply-To: <ZvbJ7sJKmw1rWPsq@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6eecc450d0326c9bedfbb34096a0279410923c8d.1726182754.git.isaku.yamahata@intel.com>
 <ZuOCXarfAwPjYj19@google.com> <ZvUS+Cwg6DyA62EC@yzhao56-desk.sh.intel.com>
 <Zva4aORxE9ljlMNe@google.com> <ZvbB6s6MYZ2dmQxr@google.com> <ZvbJ7sJKmw1rWPsq@google.com>
Message-ID: <ZwWEwnv1_9eayJjN@google.com>
Subject: Re: [PATCH] KVM: x86/tdp_mmu: Trigger the callback only when an
 interesting change
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org, sagis@google.com, 
	chao.gao@intel.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 27, 2024, Sean Christopherson wrote:
> On Fri, Sep 27, 2024, Sean Christopherson wrote:
> > On Fri, Sep 27, 2024, Sean Christopherson wrote:

...

> > > Oh, right, I forgot about that.  I'll tweak the changelog to call that out before
> > > posting.  Hmm, and I'll drop the Cc: stable@ too, as commit b64d740ea7dd ("kvm:
> > > x86: mmu: Always flush TLBs when enabling dirty logging") was a bug fix, i.e. if
> > > anything should be backported it's that commit.
> > 
> > Actually, a better idea.  I think it makes sense to fully commit to not flushing
> > when overwriting SPTEs, and instead rely on the dirty logging logic to do a remote
> > TLB flush.
> 
> Oooh, but there's a bug.

Nope, there's not.

> KVM can tolerate/handle stale Dirty/Writable TLB entries when dirty logging,
> but KVM cannot tolerate stale Writable TLB entries when write- protecting for
> shadow paging.  The TDP MMU always flushes when clearing the MMU- writable
> flag (modulo a bug that would cause KVM to make the SPTE !MMU-writable in the
> page fault path), but the shadow MMU does not.
> 
> So I'm pretty sure we need the below, and then it may or may not make sense to have
> a common "flush needed" helper (outside of the write-protecting flows, KVM probably
> should WARN if MMU-writable is cleared).
> 
> ---
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ce8323354d2d..7bd9c296f70e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -514,9 +514,12 @@ static u64 mmu_spte_update_no_track(u64 *sptep, u64 new_spte)
>  /* Rules for using mmu_spte_update:
>   * Update the state bits, it means the mapped pfn is not changed.
>   *
> - * Whenever an MMU-writable SPTE is overwritten with a read-only SPTE, remote
> - * TLBs must be flushed. Otherwise rmap_write_protect will find a read-only
> - * spte, even though the writable spte might be cached on a CPU's TLB.
> + * If the MMU-writable flag is cleared, i.e. the SPTE is write-protected for
> + * write-tracking, remote TLBs must be flushed, even if the SPTE was read-only,
> + * as KVM allows stale Writable TLB entries to exist.  When dirty logging, KVM
> + * flushes TLBs based on whether or not dirty bitmap/ring entries were reaped,
> + * not whether or not SPTEs were modified, i.e. only the write-protected case
> + * needs to precisely flush when modifying SPTEs.
>   *
>   * Returns true if the TLB needs to be flushed
>   */
> @@ -533,8 +536,7 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
>          * we always atomically update it, see the comments in
>          * spte_has_volatile_bits().
>          */
> -       if (is_mmu_writable_spte(old_spte) &&
> -             !is_writable_pte(new_spte))
> +       if (is_mmu_writable_spte(old_spte) && !is_mmu_writable_spte(new_spte))

It took me forever and a day to realize this, but !is_writable_pte(new_spte) is
correct, because the logic is checking if the new SPTE is !Writable, it's *not*
checking to see if the Writable bit is _cleared_.  I.e. KVM will flush if the
old SPTE is read-only but MMU-writable.

That said, I'm still going to include this change, albet with a drastically
different changelog.  Checking is_mmu_writable_spte() instead of is_writable_pte()
is still desirable, as it avoids unnecessary TLB flushes in the rare case where
KVM "refreshes" a !Writable SPTE.  Of course, with the other change to not clobber
SPTEs when prefetching, that scenario becomes even more rare, but it's still worth
doing, especially since IMO it makes it more obvious when KVM _does_ need to do a
remote TLB flush (before dropping mmu_lock).

