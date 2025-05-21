Return-Path: <kvm+bounces-47278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA03DABF8B3
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:04:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C70F61BC7727
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56C0221700;
	Wed, 21 May 2025 14:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3j9sLhbj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54BB1EB18A
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 14:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747839325; cv=none; b=CPnWZ1e4Cg8UCnCGo12xiQIK78VKFISMqeTDHOOY2rClF7FseLL5MO4oRkwS32tFp/nhyfpgp3GlIETEJ4G4yD/RQgLz/bGSOO/frnte+G3wWFi5B45WUSpToxuS6X3feONCFAMS0ruqHbv3rdWozAoFrbwze1RZtNxDAogzvZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747839325; c=relaxed/simple;
	bh=O5sJy0530ExVjxfypTtpMC3Y59Ak4yYgb+R+ZUkl+KQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eERwx9vFezSzJM8zibxvylaNiXkXT66bgEEdLDmAkY5+Fssz25QdHa5L++bQY57QpBWEWZLVbpnI9SgcRbUuLIramjMsv0s0tViDqZXbUFKuIzU8bHB1JWSYb+DIXGvJw/BcqCxksgsgABuM2NJXWV1ZT5pUI3vZERGrXjb+1FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3j9sLhbj; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b00e4358a34so4163166a12.0
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 07:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747839323; x=1748444123; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bDpXqKhQ4ICuU1Y2giEphwOi7h1njnNeNM+cWlT6WKc=;
        b=3j9sLhbjfCEI6r5tunaUnJWFjTxYlWCPCQUWso92a+ABJ4hsqRBjzESwVsaNYmDvrY
         Siw61imsZ91fbHmpcN77HYqcuEb6XjHsDMfJCf7h/UiRpmeFdof+b4ta2Fgvs5z1quvV
         9Cko/mVZmD1LnRz8EK9nzLZwXrNT34tm3uYjhSGCdTXIAUjTz7P0PQH+7Awc/pCQysPY
         4g/uUFEOixBd7I+fmt3HA3eBW8SIEYuPOd9hv/WVJ3F6eTtkv5nRfteEVIQcUKJYxNdC
         f9bk7fL3MCMrTQDkg1h/vbZCzILDF4sk1OAc90KtssKgEwzSxr/9QZ1QBveAUUfN4Yu/
         zQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747839323; x=1748444123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bDpXqKhQ4ICuU1Y2giEphwOi7h1njnNeNM+cWlT6WKc=;
        b=GAFuiT4LWAWGGPCSbXBiXz0TkXnhSgxGhzXxTuX4HyZGwuYteIKoOvactWpTPVd+wi
         GL2r7d221CSfknPOuYlD6QQhC1nQhfVrAO94enpQCToX0swMijOtlWCb8ECB7ta3otno
         Sjkywy5g4qehxrFh3s+LcpTP2CIaPLJTeWDwHH67VC5VmM/s9odwCXwAgKwusC0mtLh+
         761ROsxUykNP3UzdemQIQSUlVpEyQ530bZev8BwjNG+3GLs3nCaqvHNJTth08vWfwfJp
         uD/N5mnr0UvawRiYn/A2+w0QifeuVysdrlT1cWbtSVfuFfVULtU3WhT4CwPR3Tr41lBy
         adlw==
X-Forwarded-Encrypted: i=1; AJvYcCUZuF8rhyqaV+WptIeruecwwpJLaILtGEZing0VYiRd5eb0xNewGVcHv33OajSvLnbWALs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNen2CpuR1U611R7ZjGlU04rr8y1h07HfV7w4vvQimkHA/YtaT
	klB+A6PdQYII/2J6Mgnxp/FfjH8AoHpqY/jJw3XB9InOQAU3Cq3P0jL64kGr6cHFS2mTiy481tl
	Uea9bUQ==
X-Google-Smtp-Source: AGHT+IE14Lmz/nRFNIY20LyDCl9qEUvt6gWN6ZkQVOAJ6+PFcGmygAsOR1CKTNQZzkgN15CZOf2jdexMRXo=
X-Received: from pjbhl12.prod.google.com ([2002:a17:90b:134c:b0:30a:7da4:f075])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:574c:b0:2f1:2fa5:1924
 with SMTP id 98e67ed59e1d1-30e7d5b6f64mr27777821a91.26.1747839322910; Wed, 21
 May 2025 07:55:22 -0700 (PDT)
Date: Wed, 21 May 2025 07:55:20 -0700
In-Reply-To: <aC2Z2U/HR5wAay3s@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516213540.2546077-1-seanjc@google.com> <20250516213540.2546077-5-seanjc@google.com>
 <aC2Z2U/HR5wAay3s@yzhao56-desk.sh.intel.com>
Message-ID: <aC3pWOUnMWvsxYWc@google.com>
Subject: Re: [PATCH v3 4/6] KVM: Check for empty mask of harvested dirty ring
 entries in caller
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, James Houghton <jthoughton@google.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 21, 2025, Yan Zhao wrote:
> On Fri, May 16, 2025 at 02:35:38PM -0700, Sean Christopherson wrote:
> > @@ -108,15 +105,24 @@ static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
> >  int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> >  			 int *nr_entries_reset)
> >  {
> > +	/*
> > +	 * To minimize mmu_lock contention, batch resets for harvested entries
> > +	 * whose gfns are in the same slot, and are within N frame numbers of
> > +	 * each other, where N is the number of bits in an unsigned long.  For
> Suppose N is 64,
> 
> > +	 * simplicity, process the current set of entries when the next entry
> > +	 * can't be included in the batch.
> > +	 *
> > +	 * Track the current batch slot, the gfn offset into the slot for the
> > +	 * batch, and the bitmask of gfns that need to be reset (relative to
> > +	 * offset).  Note, the offset may be adjusted backwards, e.g. so that
> > +	 * a sequence of gfns X, X-1, ... X-N can be batched.
> X-N can't be batched, right?

Hah!  Yeah, off-by-one error.

