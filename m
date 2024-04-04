Return-Path: <kvm+bounces-13589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B6A9898D31
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 19:31:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC2BEB21620
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 17:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F44412DD9E;
	Thu,  4 Apr 2024 17:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r7UDiK71"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB9012AAC5
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 17:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712251868; cv=none; b=DvbP+Rv6SRqbHQXhGQCDr/FXELxszgwS/Iffl2eMnecrPFUdxZjRnnL5fj6cK437DaUO7kQgMs1M/Hqt2Trwdtxlst9uurXi46CR20ZMGeZYgVfeCtkrwFvWA94dtknWqvfx2/hfjYAICV/TLcNOVKe/GQ9mvYwy/59C/kj5cBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712251868; c=relaxed/simple;
	bh=9+nALMnWqMtktQiKdj6h/JJPaQ9s+Le7L/1VmoPzmqY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pKR8tl2n4y0MpYJojh9vE9+FjT6rKa0rnwuquK950XcZxzLNWcVvmA43Dl7f5rvLnE8RMTF9Qx+kFkMCjCUSixDOVAHlR3TIgZoZLbDwa4fmCm32nIxI6chavdivYtx5f/+JqlaIhpxAlnGGJP8nD7lPewsz16DGRfdDM5cjK/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r7UDiK71; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-ddaf165a8d9so2167141276.1
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 10:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712251866; x=1712856666; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo/SkK+TlNjp4T3bV1tp4QVg1mYvFjNY2jevZHmIKp0=;
        b=r7UDiK71LM6DruG/FsIRIuqNzoW6t90LwF4qzeciOZZCTsSmReW6k1JHrPqJdQ9TDt
         oVxF6pmJrh3E9bEo5cXjj1lJmw4wpqotgNwCzFE4g4ms9wwvCeB3UfF4woGfJriTSUI2
         NNqSA9hvOLJBAjNe94PdfBnpOyk32fCRp+wK+40StG2SNVY9d8xhzfRvtZThS5UagBuX
         YCrfxYKSuzzy7c8JUkd3t6cVsRz34mEyStgNKzSdCS22WC0wQv6N5RrYURAnpCjbGCoY
         0dmD9+BojCjl/zTMutkoM1FZltaN21BlLPqpjw+z11oEOSZSAxnEjUwUdVsK8zUn6Y/i
         Os8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712251866; x=1712856666;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo/SkK+TlNjp4T3bV1tp4QVg1mYvFjNY2jevZHmIKp0=;
        b=MklKeYLD3sU5XWwbTMZAu8YWoVs6x9xUK4cGkgzy/1J8qk0dtREn47+gFpLLD5Yb8d
         ev4euWS+9bKqbpwtdkYYIbZ/OpMdLxDmwJD/G5xAjj11YoZRiAdD7T1z2C3tFUNeumrG
         mKT5GC66f+VUR58anxIyxE1dRfq+GYufHtQJC3feZNzRrMCytj1EKiKpqucCOo65Us2S
         gv+6zOZK0yRZlAYiVhgs4ZoOJvWeyhjtZEXCfmRFcSHBFDGoDfLdfo+QNMo3m+9PFJC8
         o5D5gMhzjyj1kS9zl2NddKoVbM+bCrKmEP4mErYOh2WOEMXTWsfgcYOQnrTQQr4MwLS8
         CnuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUb5MRC9AvW2ewFckkQ0cojz7DfDKc8itgDhtgd9WI0KLgQKpx6i5sZ59JtAxJgFujtePfZWIMbjjXznAL93nRLy7wa
X-Gm-Message-State: AOJu0Yzr0omU5P9l0DrLnAozrMsi1ganZlQ3XZpma9ZJyYXhh83dFvUC
	/GNJbxjYNIVagVVpGSsTQ7AiNpIgu/Aj7RqKBQmQXnU1E7WasTPPTDN2ud9Qg6eKMWuodbYEFZN
	fLA==
X-Google-Smtp-Source: AGHT+IGxpleOXBSwibp1OJgiAWgTAeCKVGrLENZB5db4WF5+xM6eEryutq9uucKSEKwloLFURA8Eo/IRbrc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2d05:b0:dc2:2ace:860 with SMTP id
 fo5-20020a0569022d0500b00dc22ace0860mr20394ybb.2.1712251866075; Thu, 04 Apr
 2024 10:31:06 -0700 (PDT)
Date: Thu, 4 Apr 2024 10:31:04 -0700
In-Reply-To: <42dbf562-5eab-4f82-ad77-5ee5b8c79285@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240320005024.3216282-1-seanjc@google.com> <4d04b010-98f3-4eae-b320-a7dd6104b0bf@redhat.com>
 <CALzav=eLH+V_5Y6ZWsRkmnbEb6fxPa55B7xyWxP3o6qsrs_nHA@mail.gmail.com>
 <a2fff462-dfe6-4979-a7b2-131c6e0b5017@redhat.com> <ZgygGmaEuddZGKyX@google.com>
 <ca1f320b-dc06-48e0-b4f5-ce860a72f0e2@redhat.com> <Zg3V-M3iospVUEDU@google.com>
 <42dbf562-5eab-4f82-ad77-5ee5b8c79285@redhat.com>
Message-ID: <Zg7j2D6WFqcPaXFB@google.com>
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: Rework marking folios dirty/accessed
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 04, 2024, David Hildenbrand wrote:
> On 04.04.24 00:19, Sean Christopherson wrote:
> > Hmm, we essentially already have an mmu_notifier today, since secondary MMUs need
> > to be invalidated before consuming dirty status.  Isn't the end result essentially
> > a sane FOLL_TOUCH?
> 
> Likely. As stated in my first mail, FOLL_TOUCH is a bit of a mess right now.
> 
> Having something that makes sure the writable PTE/PMD is dirty (or
> alternatively sets it dirty), paired with MMU notifiers notifying on any
> mkclean would be one option that would leave handling how to handle dirtying
> of folios completely to the core. It would behave just like a CPU writing to
> the page table, which would set the pte dirty.
> 
> Of course, if frequent clearing of the dirty PTE/PMD bit would be a problem
> (like we discussed for the accessed bit), that would not be an option. But
> from what I recall, only clearing the PTE/PMD dirty bit is rather rare.

And AFAICT, all cases already invalidate secondary MMUs anyways, so if anything
it would probably be a net positive, e.g. the notification could more precisely
say that SPTEs need to be read-only, not blasted away completely.

