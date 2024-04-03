Return-Path: <kvm+bounces-13503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0AB9897B80
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 00:19:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C61D41C23272
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 22:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D36156981;
	Wed,  3 Apr 2024 22:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j/2+Rkbd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6622156257
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 22:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712182779; cv=none; b=UMeQqki18lSHbAvHnLBuef9n8ur0tQBmLzY4sKa1Lb8q8WwlvepOlj0Ld01lHxB6wxMb6QfZXJF03hXMm/tbw450g2bQQQao6QVAb1yrJL6AtEWg5tqWKAK3b2Mnxho8OjEA+Z5ETW9TBaI6iwGb8DkfhfPIcTu3K4db4kTaiXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712182779; c=relaxed/simple;
	bh=j3s/mxsLO5drWmnKf3JyGnmUwI+6z8nFIMCiaj3rlB0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p2FFPJ41q1OaurSFDVx7ir4rX1O9xxvI0IwkfS8QmbH8wONKVrkgmvqzsUmWmNu28UJxSSVpoRfqxF3YjbxkDtnvlWPltZZMAJIH+KsesqAq/YLdv58A78y28RULxxTH5LR5NJ3npTd6Wc2lGwMf0A2Kj/2JIFxai5M/UAycyFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j/2+Rkbd; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5ce67a3f275so275437a12.0
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 15:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712182777; x=1712787577; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XiLGqLJDqj0RMgdQUg0B/EASB3VnDvIGEKW06gPzZqs=;
        b=j/2+RkbdVh6hbuLM9NJlSRTIzEgVwzeahSDKsfoNVyRtsYPj4uqShMBvDJHg2U38mO
         aOThjqR3it5Q07IyoYIFQekfDzL2GsB3I3N8A95aJG+sPnS7QV0k4kBV9Vg9aeHEbh70
         sq5LDdPrv7sYZoj4pn38pgIPRRwgzwmVKaIe6dm4ZIxc51fpsIkJ8JszRDllesxqqJds
         XMbVcKH5rpEEGUbZkybhkiE233z6AWvJxvt0NQaxcmKg3/iEQJ8vRCUVYh6o0Y26aqlJ
         2gUrEz09sEHXzsJFMRx7/ZfKA+2zLBSxPCyi9ls6K0VQFN6VmBJiz+09UY+o20fp7hek
         8akQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712182777; x=1712787577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XiLGqLJDqj0RMgdQUg0B/EASB3VnDvIGEKW06gPzZqs=;
        b=XdgsOIq67UH+502ryeeCbtl2zOg4yshK/5cqDSqBRAvUFXTQB9bjoO8jWmqFd5n/43
         4Bp7dv3pQTTXWC52zaewavtlYN+IeSP70IT0ecriz6GRkHDx1QZgsyeFW14TxU1Y7ok2
         thAoqghNy6r8YtD0/0cbf0xW1qwFEFRc1I49jl3Y0v7jvtL1EYZZy28YM/YWPk/vixuC
         VqFhwsr+vPs7fTLZljlpJj3BLTWWfBtfC/boZLOi2ygz5X2wVh1rBP/XarCWiDniCFib
         beR1SX/zsS8ccS4X8Prs2yQaz/ttbsg8bGykMCWG7n8CXlnkfhaBjUTzfOs9MWvrCYib
         BWYg==
X-Forwarded-Encrypted: i=1; AJvYcCXvVSvrR7jb1icIoZ1TfnCjXOoKVxEMOOCNeaBQO3C93uCmZ6b5efl8GE+glPqZxBI64U0rZOpbU0aHW4RzoDEuBgfk
X-Gm-Message-State: AOJu0YxL9KyxEMIfkfpoRaXMtxkC3rYzuLenveKdjaWaYhiiT/KDvn3X
	H18AgEsjmS2+01F+WyF9exDGb80aWeFjyZCPdkpSxHv89wk40zqoJQA0ljNyu7L/tApxO/BRom8
	aEw==
X-Google-Smtp-Source: AGHT+IEfBSKbOVbKIfoSI3GlWo5+aXcXSFK77rflxbChAY8lw1oLakUzOYXTXrufOiCOy4ighi2ZsSwk3EI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:d60a:0:b0:5f3:e755:d832 with SMTP id
 q10-20020a63d60a000000b005f3e755d832mr1009pgg.7.1712182777237; Wed, 03 Apr
 2024 15:19:37 -0700 (PDT)
Date: Wed, 3 Apr 2024 15:19:36 -0700
In-Reply-To: <ca1f320b-dc06-48e0-b4f5-ce860a72f0e2@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240320005024.3216282-1-seanjc@google.com> <4d04b010-98f3-4eae-b320-a7dd6104b0bf@redhat.com>
 <CALzav=eLH+V_5Y6ZWsRkmnbEb6fxPa55B7xyWxP3o6qsrs_nHA@mail.gmail.com>
 <a2fff462-dfe6-4979-a7b2-131c6e0b5017@redhat.com> <ZgygGmaEuddZGKyX@google.com>
 <ca1f320b-dc06-48e0-b4f5-ce860a72f0e2@redhat.com>
Message-ID: <Zg3V-M3iospVUEDU@google.com>
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: Rework marking folios dirty/accessed
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 03, 2024, David Hildenbrand wrote:
> On 03.04.24 02:17, Sean Christopherson wrote:
> > On Tue, Apr 02, 2024, David Hildenbrand wrote:
> > Aha!  But try_to_unmap_one() also checks that refcount==mapcount+1, i.e. will
> > also keep the folio if it has been GUP'd.  And __remove_mapping() explicitly states
> > that it needs to play nice with a GUP'd page being marked dirty before the
> > reference is dropped.
> 
> > 
> > 	 * Must be careful with the order of the tests. When someone has
> > 	 * a ref to the folio, it may be possible that they dirty it then
> > 	 * drop the reference. So if the dirty flag is tested before the
> > 	 * refcount here, then the following race may occur:
> > 
> > So while it's totally possible for KVM to get a W=1,D=0 PTE, if I'm reading the
> > code correctly it's safe/legal so long as KVM either (a) marks the folio dirty
> > while holding a reference or (b) marks the folio dirty before returning from its
> > mmu_notifier_invalidate_range_start() hook, *AND* obviously if KVM drops its
> > mappings in response to mmu_notifier_invalidate_range_start().
> > 
> 
> Yes, I agree that it should work in the context of vmscan. But (b) is
> certainly a bit harder to swallow than "ordinary" (a) :)

Heh, all the more reason to switch KVM x86 from (b) => (a).

> As raised, if having a writable SPTE would imply having a writable+dirty
> PTE, then KVM MMU code wouldn't have to worry about syncing any dirty bits
> ever back to core-mm, so patch #2 would not be required. ... well, it would
> be replaces by an MMU notifier that notifies about clearing the PTE dirty
> bit :)

Hmm, we essentially already have an mmu_notifier today, since secondary MMUs need
to be invalidated before consuming dirty status.  Isn't the end result essentially
a sane FOLL_TOUCH?

> ... because, then, there is also a subtle difference between
> folio_set_dirty() and folio_mark_dirty(), and I am still confused about the
> difference and not competent enough to explain the difference ... and KVM
> always does the former, while zapping code of pagecache folios does the
> latter ... hm

Ugh, just when I thought I finally had my head wrapped around this.

> Related note: IIRC, we usually expect most anon folios to be dirty.
> 
> kvm_set_pfn_dirty()->kvm_set_page_dirty() does an unconditional
> SetPageDirty()->folio_set_dirty(). Doing a test-before-set might frequently
> avoid atomic ops.

Noted, definitely worth poking at.

