Return-Path: <kvm+bounces-17016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A2D68BFFAB
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 16:01:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A8981C20A00
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 14:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 032308528D;
	Wed,  8 May 2024 14:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K9z3sYqm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D301B84DE4
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 14:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715176893; cv=none; b=s/tAE+0SR17AOq9cf0w9zhQlAoiEywx6xWQvOC0GgEZC9lJn3JTACKBbDcKnKkJSMdKSglvXH+DapyfPeRfluD1Dd+T1PZ/hX1zl1OD6saAjm9tofKYYjY2IIPRBaxgl20isxUViQfapt/3sCw3jt2jJkLg96A3UZwg+e844ypU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715176893; c=relaxed/simple;
	bh=fKHtQmZwtVbaMapGWWdAwFR8INwOLeokQNWFm78CXHo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kcgMpbpf1oOocEXq4S7AmlItUqxunbH9yqruBzNG0XKIGYDzdy3ZVacHzALFOqhzpKyuswhq9tQhoEEI+oVPSa0AePTXO6CHSs96s2nXyz9jYYQ5w7rv7k52ORyomwz8ArXsLGI5Y2B9RSI021UcEI4GuUhxSb4CesuMtVVTvtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K9z3sYqm; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de604d35ec0so8145832276.3
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 07:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715176891; x=1715781691; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GRuBCygsQV/Xuf9mbwBl3CtdhKC/i9RdJrSQbVnsUa8=;
        b=K9z3sYqmIAcHmmqwZ8w2pCGQNSHewbBZJPfo57Brqx64hGrDQTetoK56WpzAqxuDXT
         ICNgkMVGre1i31bqMBcdbeEM+iIyUJ4BUAC31Vmv9MYR28qCUBJJV7QnSUWminXbjdCP
         VpJ/Yhm9F8BVIbT4JpQj4WYeF2E7gHft+8lRSPOLf8dzN1QJJVEOIN5uMTYKiVuWze7J
         xrptcS4kS8SDK96VpenkBl3M+2nP1ARUdc9r7BJOlWdXTG9nI1qftm4fwOF5bvKxGox7
         e9q+QITdjKs8AIKVG6h1uBRiBQwOfUfvuvhOTQYOZfJVNwEueFMDr+ydQ5cNrZBVuYad
         mBWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715176891; x=1715781691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GRuBCygsQV/Xuf9mbwBl3CtdhKC/i9RdJrSQbVnsUa8=;
        b=dNElx6R85aHcyuOIDd70vLsBvB1rRxIrJ+NjALsHf8IWu9O2okWG71MIZ8itFXpKiu
         H6JNQI1fs+W/LibjaOBMD8q8o6mCDQPadMPlDFrm7Og0Hqu53YpKvyP/om+449W65ctx
         JuZ5oI6wzyu47OgUkBK2BKKzdEqeD9xUHbK8iFQJYubZcWYaAzdzYr8s1bBf5bWJG7xA
         hDSFFWbtAI9TRu9IsfAblBIF+YQ0QleR5f4nGD1NJyYQfOhCdtQhkpaaI+noezZp7d+7
         OWZbnvgcbLqp0PZ7laBy8wHIvs80ZQthRZkSENx0wvtyuo8AqK2ety/wa4O/BCFFdNjC
         811g==
X-Forwarded-Encrypted: i=1; AJvYcCU3EYQRD8P53Bz+CX9JF4UQzsgaJ5Dcu/gyGDU3UpySW3gxmUzKoF0j6btrKdAPouz4tUCKMTsHmKs1v/WgR10MMWA5
X-Gm-Message-State: AOJu0YwrtneyLf32fLheOEQGtii6/vx/nUl08BVw1u0ftydB4qnspuWw
	abGQdhAH8Iir0EJHXvKNYRydmAemTY3wfeBsLIrtZohGVY5vzyyMhEmSe6fpMb22XdQDrBf36Z/
	onw==
X-Google-Smtp-Source: AGHT+IEotoxzTcL61fPNPOF1oe83dNOozsClwiQuDb983+6Yt1pcsrrUNKpJf1CMRJIa/y7GeGGj8edECOo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1109:b0:dcd:875:4c40 with SMTP id
 3f1490d57ef6-debb9e3dc10mr825460276.10.1715176891034; Wed, 08 May 2024
 07:01:31 -0700 (PDT)
Date: Wed, 8 May 2024 07:01:29 -0700
In-Reply-To: <ZjsZVUdmDXZOn10l@LeoBras>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <3b2c222b-9ef7-43e2-8ab3-653a5ee824d4@paulmck-laptop>
 <ZjprKm5jG3JYsgGB@google.com> <663a659d-3a6f-4bec-a84b-4dd5fd16c3c1@paulmck-laptop>
 <ZjqWXPFuoYWWcxP3@google.com> <0e239143-65ed-445a-9782-e905527ea572@paulmck-laptop>
 <Zjq9okodmvkywz82@google.com> <ZjrClk4Lqw_cLO5A@google.com>
 <Zjroo8OsYcVJLsYO@LeoBras> <b44962dd-7b8a-4201-90b7-4c39ba20e28d@paulmck-laptop>
 <ZjsZVUdmDXZOn10l@LeoBras>
Message-ID: <ZjuFuZHKUy7n6-sG@google.com>
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
From: Sean Christopherson <seanjc@google.com>
To: Leonardo Bras <leobras@redhat.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <quic_neeraju@quicinc.com>, 
	Joel Fernandes <joel@joelfernandes.org>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang1211@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, May 08, 2024, Leonardo Bras wrote:
> Something just hit me, and maybe I need to propose something more generic.

Yes.  This is what I was trying to get across with my complaints about keying off
of the last VM-Exit time.  It's effectively a broad stroke "this task will likely
be quiescent soon" and so the core concept/functionality belongs in common code,
not KVM.

