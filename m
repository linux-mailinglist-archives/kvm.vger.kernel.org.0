Return-Path: <kvm+bounces-24463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E5E6955429
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 02:22:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58F1D1C21B8C
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 00:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E2201373;
	Sat, 17 Aug 2024 00:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SiAkUBc9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7387E1
	for <kvm@vger.kernel.org>; Sat, 17 Aug 2024 00:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723854153; cv=none; b=rKpNg8NN+QRhdfCkmdi3e4CvRAlRN5sMK+qHIibIsAo8aYlNIgb8nr5d8o38zkl3nRYDIwUip/309XGnb9dk8PyH3JRz8HJY+fGFm7re5MnLWQSqV3jLpw9VfBmov7vcYis+WeyqmiXgCGdN5kxo0e4QXjUAP3S2S9LwM/7MtnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723854153; c=relaxed/simple;
	bh=QQf1bIkol/q7MTydY3yyLcSFeGMt+1FUIHhUHoQsEAY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J/QguKInvhXs2wlfWz1EU8+IbA6rjNZDKpgItyjQYsVLkR+lVY3e/FKIji1FecdXcv4eyAhRlmLp42SMV3OdEkEyunN83kIDfXtyMHpN9b/j9jo+evJiIbEbQBd4qEyDfzCGCWLIhba/+RZMt542l3E5fFd/oGg+PmODuLZ6K0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SiAkUBc9; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-201f2de64ddso20026745ad.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 17:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723854151; x=1724458951; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wex9RE4Xv1E89xSyN/KGmWZh71FaVAljLAMHIavwNUU=;
        b=SiAkUBc9SuKRVs0rZYf06xDYam4DqxYA3AafD3sesWFy7HJJWAbuHMIQjfuXZzTw5H
         zPHQ56CO5JjTxDC0JIRyTSxSNEaWiHTnzMGP1BxGHdHmxZc8slXZwRAY/yIdMYBguzrn
         8BMZUVoLCLoVq/Z0r3au2sSH89r/4XJcCoEgfjOu+AS/Fb8l4MOrU3QqW1aTxRTgfvWc
         MMqGyfTeisRjSYCC5XNVGDqArBlKwWHLEQMcBgvYJs1gEBW2CvXAwHEwqNJy1jFwZ7sI
         3839CW0DrOoFjCrZj+Gj+ynOW3ayl7vtCWuxm05wLkqeIr9ot+5vYTOki4sDsDzcSSFK
         +yaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723854151; x=1724458951;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wex9RE4Xv1E89xSyN/KGmWZh71FaVAljLAMHIavwNUU=;
        b=CaNi6UE+kZjcouEWBRlW6LofefsQIo5zsMpNfBHnEic2NN8/IrqRIoNGCeF33dtiwG
         5i1z7+ZfEFb4xgivNTYwLAqjhQgw3XpvrBuAzZkh/fgj6HNxjVmrrj65kRJQ6Y+cv8ZQ
         UO6MSgsdtm8A+rq82taVMhtT/mbNl5zZI6JMAvzEbn6nyH3igneTOrW+TPlgh9IBky0S
         +fCMymEYPztB2reh2Ixug3r9c2fd3En4+JNzuJEjTEAnrT3VDe5BWApcrHqm1kpfH6d/
         p58VhH7i6qMq9GRE32XFEWtM6OWkPeXaIuL5yTpFVvXyIAK+nqfJucd/DzxSPuKC3mab
         nn3g==
X-Forwarded-Encrypted: i=1; AJvYcCXJ6pIi/9QsrcXn04AAnhsPt6Cb9z4e/45vQTMV16FmE3deN6XXWMNUeuGWYPfXZlVpjhuvIsfY0xkBrOGwsLmfZzGL
X-Gm-Message-State: AOJu0YyjG5tvuzI4qZ7JD0ikxDuYG+WRgoj9A5MwUT//MYXM657Zw18G
	3J2zJ/lUUgdGC7n/zLtTB2LBOiL3XTS8kBfvbqXpk869JGZgvC+OLeoXoP4CekwgFLeHP4TcSpJ
	nxA==
X-Google-Smtp-Source: AGHT+IEke3GRU3gZRtwZUbx+4xSyQKjPnn2GeuUSY1oqt/amGpCpjgjhVGozOd5C0u3GywmaetTzHTxEQCs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c40e:b0:1fd:74a8:df4a with SMTP id
 d9443c01a7336-20203e97259mr4452825ad.5.1723854151378; Fri, 16 Aug 2024
 17:22:31 -0700 (PDT)
Date: Fri, 16 Aug 2024 17:22:30 -0700
In-Reply-To: <b40f244f50ce3a14d637fd1769a9b3f709b0842e.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802114402.96669-1-stollmc@amazon.com> <b40f244f50ce3a14d637fd1769a9b3f709b0842e.camel@infradead.org>
Message-ID: <Zr_tRjKgPtk-uHjq@google.com>
Subject: Re: [PATCH] KVM: x86: Use gfn_to_pfn_cache for steal_time
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Carsten Stollmaier <stollmc@amazon.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, nh-open-source@amazon.com, Peter Xu <peterx@redhat.com>, 
	Sebastian Biemueller <sbiemue@amazon.de>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 02, 2024, David Woodhouse wrote:
> On Fri, 2024-08-02 at 11:44 +0000, Carsten Stollmaier wrote:
> > On vcpu_run, before entering the guest, the update of the steal time
> > information causes a page-fault if the page is not present. In our
> > scenario, this gets handled by do_user_addr_fault and successively
> > handle_userfault since we have the region registered to that.
> > 
> > handle_userfault uses TASK_INTERRUPTIBLE, so it is interruptible by
> > signals. do_user_addr_fault then busy-retries it if the pending signal
> > is non-fatal. This leads to contention of the mmap_lock.
> 
> The busy-loop causes so much contention on mmap_lock that post-copy
> live migration fails to make progress, and is leading to failures. Yes?
> 
> > This patch replaces the use of gfn_to_hva_cache with gfn_to_pfn_cache,
> > as gfn_to_pfn_cache ensures page presence for the memory access,
> > preventing the contention of the mmap_lock.
> > 
> > Signed-off-by: Carsten Stollmaier <stollmc@amazon.com>
> 
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> 
> I think this makes sense on its own, as it addresses the specific case
> where KVM is *likely* to be touching a userfaulted (guest) page. And it
> allows us to ditch yet another explicit asm exception handler.

At the cost of using a gpc, which has its own complexities.

But I don't understand why steal_time is special.  If the issue is essentially
with handle_userfault(), can't this happen on any KVM uaccess?

