Return-Path: <kvm+bounces-44337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DCDCA9CFDC
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 19:46:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 767001C016EE
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 17:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDF291FCFEE;
	Fri, 25 Apr 2025 17:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MS9WOj6v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264DB2F2A
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 17:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745603109; cv=none; b=ewGB8on3NU5cMsv0RSMv/FcvmeMZnoKDEPKVW9MpyjvtYduRkiDRm40yWRUy5dfc0i7k89xZBYo8o2AGSC27HYo49XOn8oaam0pRG4jEELSB7PDGpRj+W2Cj0yDD9rbGuL/qvq3jr47quFAPA5PjGLQnvREjlhpQniPE7rjWqPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745603109; c=relaxed/simple;
	bh=K0rLCBbTM1mj0xrmWC+9xN0dlLbsdsdAQ1EyRn9wdKI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=up8fnSfLn44x2TwiDYMs2t6NN8WGmDcM1ntc77HzlqzucPXA+x4srL74B5uLksanSRsDCCxvTD5X1Ifisp6nPScUnwWOKoWyyYt4T4dZve9DeM06tFpsbMZNFm4qJmEW0yCL8YAY1wTLPb/Z/ndl3yE4/WrSlH4E7KMHU9/F9Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MS9WOj6v; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff6167e9ccso2929619a91.1
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 10:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745603106; x=1746207906; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LC/p/0ZI4m3syp7+hHV/1IymmAx0F260VaO909MQU2g=;
        b=MS9WOj6vwxPGnGagWfG4kbnj5wsMDfL6oVcsJ2LzjiRxrqK1nz5IoxyouJuQksrgMB
         IW75G1on8CHjQIbGEiyMzill6y663IhoH+BLzHxXyEgNN8WZ/p5iFyZjPb5k9HOshSPr
         gFIvxRUFsKNya1dH33GZkn8efDNDIP9ZiNt5fFTlkH2IYl9nNpglmAMU4bWhUzA7TQ5w
         /cL48X62pBxE3hg7Y3kQME4gkFAu2bpRAz00gmAXYT1CM7J4r4rABFFUcqWAzUFr42qr
         w/ugt2459CQzJW7olPCA8LJCxS80rA4a5MMnxpIe3hCaxAnWqpSEP7FHXRg5PTnYNRFv
         knOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745603106; x=1746207906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LC/p/0ZI4m3syp7+hHV/1IymmAx0F260VaO909MQU2g=;
        b=KtNgGMZkXqlddvNkD07gRDLHseH3SnJBhdvt/LUhtsv2DX7GB8uXk+Vtt4XSYgHbV9
         M46Pt9YV1fOXFPzqlOCSOe3XKOch60l880uO5Q77LHmg4N9/IZUWUL4H/sk3y62mHQjw
         Xr00RJ0cc1/lZZ+4Y+BTg4eZR9bsSDWbq2odtmu/vk3WyVhdiQUQl4xJG3AWXYwtsmvG
         iuklX5ezEPTmpa5XWD2RMIlyAjXp6nmCFMfduHr+msF7HWmjw7cdXL+qMpPdXXIJ1v8S
         bkHtJfXWG+0Ln1ECxTBwzpqi4n0njZ5Cua2FLWok8PDJWN84OcKTQmICc6he0m8Wgint
         q6qA==
X-Forwarded-Encrypted: i=1; AJvYcCVzqRIOUke9skdRlhfgk86eNrrMCDvJ3t4RTBTtqUfGau9Nwe+4CaewX57G6JMBIr73NUc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDq1aK+Kj4Zgf9Nc/U/bydqJTi7xmxYppSfUl1CsRVI/uDrFg/
	NRZlftiNTV7ZanPrrCFFslbp7i4jqHeztuntwsJvucWQ5qoArApNb4TeZ+V+9wjzIz2SNMhGQVY
	hJg==
X-Google-Smtp-Source: AGHT+IFj+66Cpbdz2CF42k7wOzvWZFOoKUu5FeiW+Ft2GA0dpIg8L5s83paAYmPuXY1e6MWuLCMQeo87UdI=
X-Received: from pjbsq7.prod.google.com ([2002:a17:90b:5307:b0:2fc:11a0:c549])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f89:b0:2ee:45fd:34f2
 with SMTP id 98e67ed59e1d1-309f7d98dbcmr4864088a91.6.1745603106303; Fri, 25
 Apr 2025 10:45:06 -0700 (PDT)
Date: Fri, 25 Apr 2025 10:45:04 -0700
In-Reply-To: <aAbhvKa8g973-lV6@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401155714.838398-1-seanjc@google.com> <20250401155714.838398-4-seanjc@google.com>
 <20250415200635.GA210309.vipinsh@google.com> <Z_7VKWxfO7n3eG4p@google.com> <aAbhvKa8g973-lV6@google.com>
Message-ID: <aAvKIPaOgdtOpXlh@google.com>
Subject: Re: [PATCH v2 3/3] KVM: x86/mmu: Defer allocation of shadow MMU's
 hashed page list
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 21, 2025, Sean Christopherson wrote:
> On Tue, Apr 15, 2025, Sean Christopherson wrote:
> > On Tue, Apr 15, 2025, Vipin Sharma wrote:
> > > On 2025-04-01 08:57:14, Sean Christopherson wrote:
> > > > +static __ro_after_init HLIST_HEAD(empty_page_hash);
> > > > +
> > > > +static struct hlist_head *kvm_get_mmu_page_hash(struct kvm *kvm, gfn_t gfn)
> > > > +{
> > > > +	struct hlist_head *page_hash = READ_ONCE(kvm->arch.mmu_page_hash);
> > > > +
> > > > +	if (!page_hash)
> > > > +		return &empty_page_hash;
> > > > +
> > > > +	return &page_hash[kvm_page_table_hashfn(gfn)];
> > > > +}
> > > > +
> > > >  
> > > > @@ -2357,6 +2368,7 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
> > > >  	struct kvm_mmu_page *sp;
> > > >  	bool created = false;
> > > >  
> > > > +	BUG_ON(!kvm->arch.mmu_page_hash);
> > > >  	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> > > 
> > > Why do we need READ_ONCE() at kvm_get_mmu_page_hash() but not here?
> > 
> > We don't (need it in kvm_get_mmu_page_hash()).  I suspect past me was thinking
> > it could be accessed without holding mmu_lock, but that's simply not true.  Unless
> > I'm forgetting, something, I'll drop the READ_ONCE() and WRITE_ONCE() in
> > kvm_mmu_alloc_page_hash(), and instead assert that mmu_lock is held for write.
> 
> I remembered what I was trying to do.  The _writer_, kvm_mmu_alloc_page_hash(),
> doesn't hold mmu_lock, and so the READ/WRITE_ONCE() is needed.
> 
> But looking at this again, there's really no point in such games.  All readers
> hold mmu_lock for write, so kvm_mmu_alloc_page_hash() can take mmu_lock for read
> to ensure correctness.  That's far easier to reason about than taking a dependency
> on shadow_root_allocated.
> 
> For performance, taking mmu_lock for read is unlikely to generate contention, as
> this is only reachable at runtime if the TDP MMU is enabled.  And mmu_lock is
> going to be taken for write anyways (to allocate the shadow root).

Wrong again.  After way, way too many failed attempts (I tried some truly stupid
ideas) and staring, I finally remembered why it's a-ok to set arch.mmu_page_hash
outside of mmu_lock, and why it's a-ok for __kvm_mmu_get_shadow_page() to not use
READ_ONCE().  I guess that's my penance for not writing a decent changelog or
comments.

Setting the list outside of mmu_lock is safe, as concurrent readers must hold
mmu_lock in some capacity, shadow pages can only be added (or removed) from the
list when mmu_lock is held for write, and tasks that are creating a shadow root
are serialized by slots_arch_lock.  I.e. it's impossible for the list to become
non-empty until all readers go away, and so readers are guaranteed to see an empty
list even if they make multiple calls to kvm_get_mmu_page_hash() in a single
mmu_lock critical section.

__kvm_mmu_get_shadow_page() doesn't need READ_ONCE() because it's only reachable
after the task has gone through mmu_first_shadow_root_alloc(), i.e. access to
mmu_page_hash in that context is fully serialized by slots_arch_lock.

> > > My understanding is that it is in kvm_get_mmu_page_hash() to avoid compiler
> > > doing any read tear. If yes, then the same condition is valid here, isn't it?
> > 
> > The intent wasn't to guard against a tear, but to instead ensure mmu_page_hash
> > couldn't be re-read and end up with a NULL pointer deref, e.g. if KVM set
> > mmu_page_hash and then nullfied it because some later step failed.  But if
> > mmu_lock is held for write, that is simply impossible.

So yes, you were 100% correct, the only reason for WRITE_ONCE/READ_ONCE is to
ensure the compiler doesn't do something stupid and tear the accesses.

