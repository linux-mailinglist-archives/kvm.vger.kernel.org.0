Return-Path: <kvm+bounces-40278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA11BA55988
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:18:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F03F1898ED2
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 22:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8FD227602D;
	Thu,  6 Mar 2025 22:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XT/Z/UJH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15B0205AC0
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 22:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741299474; cv=none; b=jt/pU4pLs/s4lIxYrqPzaZJ0AuTFO8OMcps1f8qkVh9sn6ls+nLc7AUo+WuTwIc0/m5EN72qEGwvhfNDqvLopPPXhj/hAgELyahJOWdWa0tLRq2rkQBeOvF8IgaPfq+n/lXwh0YSsQxVXuwrElIaekpde1bLAPKyJ495qgnTUU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741299474; c=relaxed/simple;
	bh=/FZ+fFNm+64U8nsHdUxFHPg8V089nq1ZzC25VJ9QFGI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VJqlAkhUYt0Od+CtQXqRfh2PcgNAFgcvBMZZLToDr+REHt+sry66EUxD0ttshPcac9VAA6iuWe2tOtYBIfW11MOP2dAxPrFHQXj6RUJ5Ssi4z2e3qRSqx0FBXAlJwIylKyf1Hp/a1cFCNmUzUxSU+HnYVjyrEFLUzYSnu/Btbww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XT/Z/UJH; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22379c2e96aso35020095ad.1
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 14:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741299472; x=1741904272; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1fVM2KE3EoOsuu2EWcqC1HC9DuBoPNNqkucuTCqqHCw=;
        b=XT/Z/UJHnag0xM5GhlEDJJG59PYGwk4Cu+Ebge8VogjBfB/M3qol2wvhDAp3XIdgFg
         kym2981BrpCkiYxuTb2hE7OMIJfXWeAt/uwDyNjmfX7/hJIx08Aq3OacKV+Qq6ayhMEJ
         DipXh0hEVUiDAwAlOQxY41nVwmBhpCnlXILsxwl6qeEqtOfvBWceUFU+c5ijBkEYugh+
         I8lD2fvf8VdqGkDJhymBN+fQYAqSVeUhVgpf05Y6xGxgMj/RnrzdIcrhVfX4wR7iHQIj
         O4lHZqafiA+pIOmo8g2fPkyZMTHLCxgJlzvANgXZrufiIWuUfTd/CEeo3LivyRoA+82s
         8enA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741299472; x=1741904272;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1fVM2KE3EoOsuu2EWcqC1HC9DuBoPNNqkucuTCqqHCw=;
        b=MwFLSh4bXAiZQkH0uqkpnuAxAUN42iJG/0laNcLNPlcEjl0qDy4GtlyalFQ+/AO3QS
         0/T8xHjX7b15IziNFcsBWZe9T9qJXymfklLFRQ/APrF61SBpaxU5h7hpIOUdEVX57/Ki
         K4zfOL6de+vC88F3hm1Rah7hd6Z6RXDci55JHjJMvuQ6f+zT3EUIxtsrzjMNL9VhN4iQ
         Ybr/fWAzssezuUbh9Bng5+vZYe+ZRyA0XVqI32hkervb+ho+8ObfOi9FIo20HkFstYGT
         Wp7lVcXPn4DcUdc7+rMiPa+Pd5jpAgW/sjjOU8zpEq+9C7Xo+YkBLLBJr9GsJZbBiG+T
         4KLw==
X-Forwarded-Encrypted: i=1; AJvYcCXpICTTc7b5AD6kysbeyoV7t8m7UE+bC/oDY1tt49IF/ghuyENuQe5zAMz7Aiyaip6cJ88=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuaxvFflVKnPt0tTwTuXu6TBiT7zIoqgJQg0wqutWSGub1Rqer
	1M6L3OlhKQbY+tp/wwZk96qVBJu8M+Tjdc2uqSxota8BDERrgMqkst2TWYBz1f1ueCCUGDur5b2
	eIw==
X-Google-Smtp-Source: AGHT+IHj9hf+RSGnxoRCsNAWfapX74dbG0cv1fVCIplmAgCoqTHkKkEEOlwzNxPnN2S64GQaJbv4Oc/F+lY=
X-Received: from pfjg21.prod.google.com ([2002:a05:6a00:b95:b0:736:415f:3d45])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4b4a:b0:736:a8db:93b8
 with SMTP id d2e1a72fcca58-736aa9b3970mr1923671b3a.3.1741299471981; Thu, 06
 Mar 2025 14:17:51 -0800 (PST)
Date: Thu, 6 Mar 2025 14:17:50 -0800
In-Reply-To: <a10378eb-4bff-488c-86f7-b4fec20feb6a@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250222014526.2302653-1-seanjc@google.com> <a10378eb-4bff-488c-86f7-b4fec20feb6a@redhat.com>
Message-ID: <Z8ofDmVbhjfLVwQD@google.com>
Subject: Re: [RFC kvm-unit-tests PATCH] lib: Use __ASSEMBLER__ instead of __ASSEMBLY__
From: Sean Christopherson <seanjc@google.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, Laurent Vivier <lvivier@redhat.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 06, 2025, Thomas Huth wrote:
> On 22/02/2025 02.45, Sean Christopherson wrote:
> > Convert all non-x86 #ifdefs from __ASSEMBLY__ to __ASSEMBLER__, and remove
> > all manual __ASSEMBLY__ #defines.  __ASSEMBLY_ was inherited blindly from
> > the Linux kernel, and must be manually defined, e.g. through build rules
> > or with the aforementioned explicit #defines in assembly code.
> > 
> > __ASSEMBLER__ on the other hand is automatically defined by the compiler
> > when preprocessing assembly, i.e. doesn't require manually #defines for
> > the code to function correctly.
> > 
> > Ignore x86, as x86 doesn't actually rely on __ASSEMBLY__ at the moment,
> > and is undergoing a parallel cleanup.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> > 
> > Completely untested.  This is essentially a "rage" patch after spending
> > way, way too much time trying to understand why I couldn't include some
> > __ASSEMBLY__ protected headers in x86 assembly files.
> 
> Thanks, applied (after fixing the spot that Andrew mentioned and another one
> that has been merged in between)!
> 
> BTW, do you happen to know why the kernel uses __ASSEMBLY__ and not
> __ASSEMBLER__? Just grown historically, or is there a real reason?

AFAICT, it's purely historical.

