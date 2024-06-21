Return-Path: <kvm+bounces-20276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F2A9126AF
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 15:29:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 661FBB26E87
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 13:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C80155C9F;
	Fri, 21 Jun 2024 13:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FlD2+Fjc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D79515531E
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 13:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718976565; cv=none; b=HPT13O9Ri91FA2ZXChyCYsyYMIQH2nkvi4h2lULGhqkWYPpabb4QuHQ7TviXSc8AT4co/70WKjehQSxXEchStCt9Z1nvOWPdJ+Tb9nMOlMjUHiEm+dZb/rBiyU/0JjUaHj7ZVoZEDKWTH45RKRrrAr7+ccVm8KUx6Zo9yi9wtZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718976565; c=relaxed/simple;
	bh=UzVghqgEGA9GkAQsGs/OsLYhTpGa7r4egkoUmXeko58=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=py1znrj0xVxgkAnD/Sr9SBryVGjf3AIknsfWUZ6efzwtxbJyM33vel1YhgrFgOv5hHJZxEQ7oXd9HEF6IWWf+dyQ3OOU1XxX6MeI20Ev/h2No02clOY7BdxCgtFKmIThjLc+RHF4zi193NE9NFUCRGYmlj7PQHXY6N4jJkbOO6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FlD2+Fjc; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-681907af573so1997060a12.1
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 06:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718976564; x=1719581364; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z1tzi1HGvlKyTxyNgscHTVZCffC1Y+zqLYJb1tDrlvE=;
        b=FlD2+FjcluJ/bdv5UblNzbYkQIrWaCivqLhatdUEeo6OnfZO6QwpWkidnzLJlJ3rdN
         SvaSGrpx2FI+6iesSlQepbjsoaGxOjtJMZY9UcA7arbgAz2EJVwcPvuWlKJAm1MBEZSk
         ocCd6zQgK2h0NcNggbeQ0YeZpqWOatnKbXxctaYGSoHeCrDENYhB7aiqMllwAKsvAl0f
         Wb7n9Tt2tvddz4LM7BJt/IvzbJ5g/7G7eGwSyf5OJsb7ZV67oJ7y7WXy4O3SREx0nNeL
         OzNAPLOOnTmAQ5dWymCTQSOCSjnVGxsR8JWWL2NnttHmM0EvjI/1O6FCMENO146t+Og+
         MRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718976564; x=1719581364;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z1tzi1HGvlKyTxyNgscHTVZCffC1Y+zqLYJb1tDrlvE=;
        b=kaT+pDAFcQFUajq/H/QFzBJFiuTgBF/H2mipQH+U7ETvc2TlMkdULjyAA7m8KakZ0n
         Q37gXzsRE9LPf8iJrZWUzZSK4i1gZFCUReXtVxqHZkqA6rn1h/nfbs7UF/LsaLCPe1HI
         1uRjgw6DTopy7CL4TcfBZ5v/2sbqFdOhhNQMJIisKz7V3imItttfUFs0HFixefk/jH1x
         wTxV0iUNs3JR1fbPjQEKyt4V3J9O2QUAhRl9hSYjWyvxwZTKoIQ62Uzppa9q0MSqW7nP
         Z7l8ooC7EeWAU2R8IJB6vijuGfVUZnxO/XyJlQNpDW++qRQKGNYIGYXEZSLC52K9BZjs
         rKig==
X-Forwarded-Encrypted: i=1; AJvYcCVRBE50HVERWD37UmWw7Dc8qLHbVFxal4rjWyoRI3kvpG62HiHPPWKVpOYBMvHXlar0wqsBeYNSaQl0GpM4NMWu2DJf
X-Gm-Message-State: AOJu0YwKUoqZpA+w4lcA8ALjkvK1Br9pDHjh+pdRMq7JpPRGDIgFZuN4
	ohhAT7jzOGxF4UcQ1FzgS+nC1GXkKI7FVHGJnCX2qdsRQNdvtP1w7zWdZeJJCXy8b6Vj0/X9nqr
	kng==
X-Google-Smtp-Source: AGHT+IF/Dd11Mv3D+BwjEAp2u3EMUSdUzQQM4OvgaAAWSPA62KblqJDqDlW4P9AIrCNZiwOhM/Lzdw0kU4c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2242:0:b0:6f1:a391:ba15 with SMTP id
 41be03b00d2f7-710b5539915mr19962a12.5.1718976563596; Fri, 21 Jun 2024
 06:29:23 -0700 (PDT)
Date: Fri, 21 Jun 2024 06:29:22 -0700
In-Reply-To: <ee06d465-b84b-4c75-9155-3fa5db9f3325@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240619182128.4131355-1-dapeng1.mi@linux.intel.com>
 <20240619182128.4131355-3-dapeng1.mi@linux.intel.com> <ZnRxQSG_wnZma3H9@google.com>
 <ee06d465-b84b-4c75-9155-3fa5db9f3325@linux.intel.com>
Message-ID: <ZnWAMqimqze1a12H@google.com>
Subject: Re: [PATCH 2/2] selftests: kvm: Reduce verbosity of "Random seed" messages
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 21, 2024, Dapeng Mi wrote:
> > --
> > From: Sean Christopherson <seanjc@google.com>
> > Date: Thu, 20 Jun 2024 10:29:53 -0700
> > Subject: [PATCH] KVM: selftests: Print the seed for the guest pRNG iff it has
> >  changed
> 
> s/iff/if/

"iff" is shorthand for "if and only if".  I try to write out the full "if and only
if" when possible, but use "iff" in shortlogs when I want to squeeze in more words.

