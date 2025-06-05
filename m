Return-Path: <kvm+bounces-48582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 781C6ACF79D
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:09:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B23B0189A285
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E7127A93D;
	Thu,  5 Jun 2025 19:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TaTHgvuL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FE018C06
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749150534; cv=none; b=ITE37Cuq/54EFkOC6qCoixNfCtSOflCFmYhh+bjPQITdY2Aq7ktzFXh6XZ+5kcyBFo5/YMaaBHrPJF0PXwFvSn7Ka/3ATdsnk91XpfpXmOyU2kbMYarn0/y01Bq6l0qWZbOqzxg8ZmB2P84QUw5ASog3UOc9z/R+hVnZ1+0OfiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749150534; c=relaxed/simple;
	bh=ZBeOPFy9ZssVI3RHyBENxTDipZ4R1O6JYJuLDyQ/Q38=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RDsBmgjZQUSZ6NQCjyJAjxtOXeVhEbeaKASxIs/+PtvVBwkcB6xePaWxT8jH4nrQxbecmQjFSq3Bh5IwycokfPO3kVZeeZ+1jkei+2r8RTgeZW4lbq8zJvCJE3qSQZDJf1z0xWACnoYVgxYcj93wswDIziO3DVwVO7uUOKbfKZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TaTHgvuL; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7398d70abbfso2187893b3a.2
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749150532; x=1749755332; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BeWEhqa//4RBh2XVVN+pTxvHfJPI4F8kG36b5WcR93U=;
        b=TaTHgvuLp1k5hDzCxBRwcOJJtD42ulqMmDrIUns8aRoHImry0Howj4TCvQKInxeImE
         hm06k9us/vSFN5Mr0I8QgBdkKUwynknuka8ae7PCAeskJulShGefqRKsaMB6iVfakIkm
         BhSURend0McCXtZivs/ZddAtbj2wzeYs7nLIK2FoQx8NE3gN9r7ddcecuqXp1mJFHt4H
         LFUoffR+S1MCkLu25cX7PEWX/0tBjhibSTa+cR9rTHiQBqGb7YYousUNShbmBCQAQUNU
         eOzy3NmkyuhKstf+E59i4esFYEtwji/iUrg9XX+dFYFsURULWxMf+QdrjLrxCxlCj5Hu
         rfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749150532; x=1749755332;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BeWEhqa//4RBh2XVVN+pTxvHfJPI4F8kG36b5WcR93U=;
        b=wf3Zt0w7XvcJENTYKkk3miK7aZgZQWYYvtP+E1w/4qHZ4eLRUJp+qZIADxQjrJCz8G
         pvTe3hm0iRuyq7BppeGD3O0FaIxKBcZOYDwSpTmoVRK1XAwyIOOCZ9hliuo47yKAfiG1
         IMGpg6s/mtr9HTHMxJagxX+lLk8qhdP0Am2DHtDMcVJfaZzKkW0UUNMYuUpnvr1qMLd9
         Ssr5+tturCl0WQN2mjKhdEQU1n9uEBpUwjd3gkbBy8jEq6WVJgj1rTczukMc8fgLw8of
         o3c+mM+UNcTQnTOEMJO69kznQlaK15dPq2hEMWiwiYWMm7mAq9VnQk2LzePVmj4uuwnN
         q1lQ==
X-Gm-Message-State: AOJu0Yx7KaGt/stVJSusQ0P9ofD4lFqrNbzeTFi651c753OhYYsu2LZK
	u3jl3m/OOA63z6yyjQEOidWKMZjoYxu/7hAiewIyfQLZQpjUCMTwzHBfb7yPc9vGOjWJ3QubH5y
	W+M15pQ==
X-Google-Smtp-Source: AGHT+IFVObcQdljYw+2KxhkNsjI9s11xx7yBSgk+AuR7WiSmhQi2SkMnuSvXjpnpL2TTGwMXub+iVGlR6so=
X-Received: from pfbbw21.prod.google.com ([2002:a05:6a00:4095:b0:746:2ae9:24a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2da1:b0:746:2ae9:fc45
 with SMTP id d2e1a72fcca58-74827f3b9ffmr1044517b3a.22.1749150532223; Thu, 05
 Jun 2025 12:08:52 -0700 (PDT)
Date: Thu, 5 Jun 2025 12:08:50 -0700
In-Reply-To: <03b2e404-afa7-4b12-bcc8-ffea92fe088b@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605152502.919385-1-liam.merwick@oracle.com>
 <20250605152502.919385-2-liam.merwick@oracle.com> <aEG-bmjRgqlxZAIR@google.com>
 <03b2e404-afa7-4b12-bcc8-ffea92fe088b@oracle.com>
Message-ID: <aEHrQpvN8CtES9je@google.com>
Subject: Re: [PATCH 1/3] KVM: Batch setting of per-page memory attributes to
 avoid soft lockup
From: Sean Christopherson <seanjc@google.com>
To: Liam Merwick <liam.merwick@oracle.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, thomas.lendacky@amd.com, 
	michael.roth@amd.com, tabba@google.com, ackerleytng@google.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 05, 2025, Liam Merwick wrote:
> On 05/06/2025 16:57, Sean Christopherson wrote:
> > On Thu, Jun 05, 2025, Liam Merwick wrote:
> > > Limit the range of memory per operation when setting the attributes to
> > > avoid holding kvm->slots_lock for too long and causing a cpu soft lockup.
> > 
> > Holding slots_lock is totally fine.  Presumably the issue is that the CPU never
> > reschedules.
> > 
> > E.g. I would expect this to make the problem go away, though it's probably not a
> > complete fix (I'm guessing kvm_range_has_memory_attributes() can be made to yell
> > too).
> 
> That indeed works. I couldn't trigger anything in
> kvm_range_has_memory_attributes() but am limited to about 2TiB.  I'll do some
> more tracing before I send a v2 to see if there any more places that might be
> close to hitting the limit.

To get kvm_range_has_memory_attributes() to fail, I _think_ you would need to do
a large query when the attributes match a non-zero value, so that it needs to
perform its slower search.

Ah, actually, I wouldn't be at all surprised if the issue is limited to insertion,
or even just to the xa_reserve() path that allocates memory.

