Return-Path: <kvm+bounces-46985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1130EABBF50
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 15:37:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 82D99189416D
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 13:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 032D227A117;
	Mon, 19 May 2025 13:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aPwU1EH/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D888E19B3CB
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 13:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747661827; cv=none; b=HoP7R39YaoAZLZTu8qe8xBg0j5SpbbiEVLEgZWpA5zVVQTfiEgduZVHZthcsgsq65vGLDX4oCZA8c6M5hG+1jg4pbsHm3A2O/FCLJXVo+s+/pW6QjrmRcTpQkgF/Mku7/1muW5omTyE6b5YTmDlfKauMUdI8VZJg4BrwW1cjvTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747661827; c=relaxed/simple;
	bh=Ih+Sy8cNdeXWqKE/CD+IDJzasQTcEDVwvNhOjlF4Odg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=POxU/mvyTim/MIWjCRDIZsDBjf3IQWXO0oeTHC2KXqUwnaJFNevpJ4skofCX+VPK3xly4Csu2PVet+/4G49ur1nnQ1f7TcqCg0xNe8/hUI39m6j58jTxABlGUFWRxYphSgNxOKr5Eui+NIaSan/9CaDB6RKAJwBVfKagrEVGQxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aPwU1EH/; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-740270e168aso3958534b3a.1
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 06:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747661825; x=1748266625; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z5wDnxumtqGt9ogcrPZCsFOhMaoLEW4JK23LDoIRw8Y=;
        b=aPwU1EH/rX2BCpBPWwUYhOZV5u6II5heieY0t2CKvcEssn5b0kW+ypo8NQtlmNh6U1
         52xc2v+5+dFip3+p7sAx/lVi+MYZAiMnnjiAQisUlWaiHcXPKTWN7xj2SUieI/GCBFaA
         +j/4zryUBdLBNRz727ESseJpGdq2gJhAxTQaw/WnAZbEajXX+KYmLKem9OuiT36/hH3z
         y8IQXsAuBjK9TGG2p8tzcXnnrURwgFP1yIdPKIY5J9G0KuKWZvXx33sG4nxQ2SnpnPua
         aloinTuizoR6m/N3Av9TImuwn8azvs2Q9XwWdK2BpIgFVjbL95bJsHwIvYgtQPP75fxx
         lkJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747661825; x=1748266625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z5wDnxumtqGt9ogcrPZCsFOhMaoLEW4JK23LDoIRw8Y=;
        b=MBkRIEVXvlZyxVGwh/cBagOgJSYiCP4je2jp5rhega9pL4IibTb0Yhi/pha1fRitxI
         bXMsTuv6Dk9fCrthkrEOPKya5Iz/xstqYnoa2jG5pSELIbte90/ohqofwNeCB8Y7rUnY
         2ns9ZDHEolNdCZb4KGmshEMFVQ3mEcr8tW+NmHsOWBc5q6rfNtiXp8zv9mdH0blhN1r6
         wTC/mW14lOAh0s5grJlerFv+ji1MK6NsMJAeBk1FMyOJunMTx88AXQ258BN9f4S4LkUd
         FLk+guhBHcyv5Gb74c9379qz8+eil+Fci/AUV59V1OaY6F69d+1RRW6XotVmZgmltMUJ
         lDpg==
X-Gm-Message-State: AOJu0YxxNt4ryb2d7VjNNiN3/61xka1UB8RBERC+QxemEmEVOe8rxciH
	tonB7thBBhzfwGVakYSfEpDAb49duI9lG2FZBKft7HUS9klYwdU32Lc67ce5rQo7BRqNiNMsjio
	7kayvQA==
X-Google-Smtp-Source: AGHT+IFkfPln23KvT4glfT5BuNhpKGvErMRlKjKsTK6NbsVcGBP6SXTTJxLb01yJQtxzHiBpgRkN93bupBc=
X-Received: from pfbfn14.prod.google.com ([2002:a05:6a00:2fce:b0:732:547c:d674])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b84:b0:730:9801:d3e2
 with SMTP id d2e1a72fcca58-742a97a2752mr21118458b3a.8.1747661825070; Mon, 19
 May 2025 06:37:05 -0700 (PDT)
Date: Mon, 19 May 2025 06:37:03 -0700
In-Reply-To: <fb0580d9-103f-4aa1-94ae-c67938460d71@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516215422.2550669-1-seanjc@google.com> <20250516215422.2550669-4-seanjc@google.com>
 <fb0580d9-103f-4aa1-94ae-c67938460d71@redhat.com>
Message-ID: <aCsz_wF7g1gku3GU@google.com>
Subject: Re: [PATCH v3 3/3] KVM: x86/mmu: Defer allocation of shadow MMU's
 hashed page list
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, May 17, 2025, Paolo Bonzini wrote:
> On 5/16/25 23:54, Sean Christopherson wrote:
> > +	/*
> > +	 * Write mmu_page_hash exactly once as there may be concurrent readers,
> > +	 * e.g. to check for shadowed PTEs in mmu_try_to_unsync_pages().  Note,
> > +	 * mmu_lock must be held for write to add (or remove) shadow pages, and
> > +	 * so readers are guaranteed to see an empty list for their current
> > +	 * mmu_lock critical section.
> > +	 */
> > +	WRITE_ONCE(kvm->arch.mmu_page_hash, h);
> 
> Use smp_store_release here (unlike READ_ONCE(), it's technically incorrect
> to use WRITE_ONCE() here!),

Can you elaborate why?  Due to my x86-centric life, my memory ordering knowledge
is woefully inadequate.

> with a remark that it pairs with kvm_get_mmu_page_hash().  That's both more
> accurate and leads to a better comment than "write exactly once".

