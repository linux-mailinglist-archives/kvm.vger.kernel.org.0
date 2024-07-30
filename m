Return-Path: <kvm+bounces-22704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFCD4942166
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 22:15:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFD002828D9
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 20:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4536B18DF9C;
	Tue, 30 Jul 2024 20:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d6MXcOz1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC0018DF81
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 20:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722370504; cv=none; b=MNYjzKv9ElHry0mInLqkR5THYbZsgNT4TjMRpIbnh5unewP5L+W987h7Qb+6JZvB+XHaLEurzYWlFBI0apVphjXyYiLTGvTrkLeuaKRQgKXKBOD2bp4ozqx1fVCSkz+j2aen93b1HPuvQ40Th3FjEetJhb/op+wxCxexYD32n2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722370504; c=relaxed/simple;
	bh=Xb56Rjm9GNT0X5C07vjpbr8J+7v+LjPM+oZnEZ2ZEvY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tQ0bho7Q3qCFhs8vTqAEeU44veu++koYBh+RLtzPQYZL/yWwyyEUOxsvzL614BSitQ7fiHZdApUUcgmZSAy+ObWYFdUJDibEK6O5DuKkI41aU6wELowEeDngv6qVZFsaegN9AutbtWiRfJgWUUE/AyRrAbGHwhhccSxy6GXfG70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d6MXcOz1; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc47634e3dso37014305ad.0
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 13:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722370502; x=1722975302; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C8yo2cbMxRjf1SYFGiWaoP3WEwWP/CuFq0W0aGvMAlc=;
        b=d6MXcOz1tgDeHF4TniUA4DKimIFjESe8uaXgwGfUWPmDejTN65ZaUJs15ckwEIqmam
         5ExxSlY1Xt0GJb+Yd2GSTYHf0oR/7dOIhNyLabAPi2DQVr9KPSlp1JnxpaYXGlzudCe+
         EphQ8jwINw5aDFShNUbhB4FBaK36i+1UYPNxCv8nnw3nBqY+qNYvLKS6j3BzDpjhIDTs
         wSyMtqdtwQaMWi91fghNT24kl7DbwbxXvZkplCELrcd9GkrWoDbE4uBh7KBE4h1D8BKx
         /JkA2iMAIZTagcoiSUv+mjduquruEunjebx77hZGipXKKq4X6mf+xNCs9PMUw1D6OvVH
         qXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722370502; x=1722975302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C8yo2cbMxRjf1SYFGiWaoP3WEwWP/CuFq0W0aGvMAlc=;
        b=dLJAOd0xvGQXeMB2stLmVcfwfrG1c1dWz5hIPd3c1M/dPbR8jTsFqf4cJ+2O4dNEzh
         jm9tpcdpFVw6050wBhNvfSlvJwyhxU5lmn2MelLKQEwp63zpaQ8vRCaomsJUgQ/BmQWd
         IaaKmLb5bqmX3Q/zmY1IBD16tiwsr9w1jN+RAFNv0UehI+No1GZLbuoVCOOWyAOczk3x
         bvWlGnEKhxS6VhfNW50vlTjqGqciBBaDSOsoSg9tsDcYB9HuGba8STl+d0JFobzmGYPL
         P1UJkWYn7BMrVRL+NauUh44nIgg9oMf3CoV+2JO30je+FDmlmxSaq4fAdU1prnCjBu28
         +j+Q==
X-Forwarded-Encrypted: i=1; AJvYcCW6vwBBkzIkobDfOAgOCXM4LeFpPTtzgtnjYu7y7vQNKiVlpP75mJUbDXfJ/xhDjykt7uJHp5HQq1zsO+RXr9tFF2do
X-Gm-Message-State: AOJu0YxeWSQf7KSJlWhJDar8cUzOk3BA2ey8GJthYD/QmL3IOwGJPbyu
	o7wjWlHtGmNBgFGWjYDn/16spP6+ufS6gRzwT+xH3RNCPpcUx5M16UqPh+EtSZS7mzBM//cc6Jp
	rPw==
X-Google-Smtp-Source: AGHT+IH9iITYoLB/ZN9Oi4VKGOQu9lhx7HYkDR9WKhrc/jsriwfmp+7ZOuZAysZ686xisdvdjIEEvamlnSs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea01:b0:1fb:54d9:ebb3 with SMTP id
 d9443c01a7336-1ff04828eb3mr5974125ad.6.1722370502109; Tue, 30 Jul 2024
 13:15:02 -0700 (PDT)
Date: Tue, 30 Jul 2024 13:15:00 -0700
In-Reply-To: <63c41e25-2523-4397-96b4-557394281443@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-35-seanjc@google.com>
 <63c41e25-2523-4397-96b4-557394281443@redhat.com>
Message-ID: <ZqlJxJyOdsR206Zc@google.com>
Subject: Re: [PATCH v12 34/84] KVM: Add a helper to lookup a pfn without
 grabbing a reference
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 30, 2024, Paolo Bonzini wrote:
> On 7/27/24 01:51, Sean Christopherson wrote:
> > Add a kvm_follow_pfn() wrapper, kvm_lookup_pfn(), to allow looking up a
> > gfn=>pfn mapping without the caller getting a reference to any underlying
> > page.  The API will be used in flows that want to know if a gfn points at
> > a valid pfn, but don't actually need to do anything with the pfn.
> 
> Can you rename the function kvm_gfn_has_pfn(), or kvm_gfn_can_be_mapped(),
> and make it return a bool?

Heh, sure.  I initially planned on having it return a bool, but I couldn't figure
out a name, mainly because the kernel's pfn_valid() makes things like
kvm_gfn_has_valid_pfn() confusing/misleading :-(

> (As an aside, I wonder if reexecute_instruction() could just use
> kvm_is_error_hva(kvm_vcpu_gfn_to_hva(vcpu, gpa_to_gfn(gpa)) instead of going
> all the way to a pfn.  But it's ok to be more restrictive).

Heh #2, I wondered the same thing.  I think it would work?  Verifying that there's
a usable pfn also protects against retrying an access that hit -EHWPOISON, but I'm
prety sure that would require a rare race, and I don't think it could result in
the guest being put into an infinite loop.

