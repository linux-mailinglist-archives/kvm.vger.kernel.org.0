Return-Path: <kvm+bounces-28457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3F4F998C6D
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 17:55:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 303791C24238
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 15:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE801CDFBB;
	Thu, 10 Oct 2024 15:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Te0gVPet"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71001CCEC2
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 15:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728575666; cv=none; b=TwkNI8lLCaGhMe8Zib4X9oxsvPzuH451jImpE2tmjYXHkyzOVxp28hOT6IxmQAcGheWdPYOVc/BvyQGOPGLN6GWnK7ceZOqfcNPmDm24vQ3kaoOeS5qGjCYp4mQbjluJavXSt3nL1SVfqzUwUvqpbnmt7CysbfBBQ8YXNZfugtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728575666; c=relaxed/simple;
	bh=exMIV8Nrlv5VDsW7LyILeqag4PrIbwaBSGqnuHxKDCM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oMC0wZSpUJVBiCM0mIIPswR3Zsct4M6J7ormkrxzLa84BOJ9bhPSfTTZ7AXVdhNd7zyCEGBmWRQosVx6Pkl63TkabV71uNJY68mipzkmdDIh3kQG+OZ/sB36x4syiU2h43dGMu1zv1k6CC71bu/ne8/IS8rBMrdoBsulFyBZgQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Te0gVPet; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e28fc8902e6so1504522276.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 08:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728575664; x=1729180464; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7sMwEF0t04Xf03z8JmTNU0su6EV0vlEJErGb+yyXXCE=;
        b=Te0gVPet9qAS4fshTWsr1ipo5NiATG0k2qjPQofocrdund1E03q5LLoQSdBDFsDL9s
         LtsVSmf7OhbTWSwdrWxjHIO/xanP0dcxhH45E51b8F57bWW6UyyoFFO81Iv2Jz+YBCvi
         7SpHhTUKzMwGVTeQKZvihuNroZZCdXqviY8PVNteMC5y9RLLN8XOQ9HSntwLK9KkSZL9
         H3ro0JwZgJ/GX/in8jcrUax9R7Ax//jtoz5JjYHMIrbYFDBDEe+J87n1/0MkkqGrWrTb
         wSJV9fLY/NBHY3gOr/EtsLQAAhc4nCZzUMTW+TOljPh+yz+Dc1MRGzL9SSj/06dCt1sX
         kVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728575664; x=1729180464;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7sMwEF0t04Xf03z8JmTNU0su6EV0vlEJErGb+yyXXCE=;
        b=NdHyMKp/493dMfCRvABsYQHd10gAvEUjDxyo/yHDZM4WVMh2vzKMIlmBVuJ3uAuWfa
         p+n5ua4E4e45NrnQhL2PPbrzJGfIPYCucLzPzTUtuFlaRu03ho1uue5+W3P2ifHSWSg7
         pEMRJX8LHUMt/RpE6Zyx8aXybZaJnl+/iyJTa/mKFx1cAY4Ue/gx4atR2R0WFcwHoaKk
         xbDPucNEeU9UxAiOs4LLLr2s4bzDgfww2iIRit9a9VHUY2oL9raN81QNjUEzqM0dXKOk
         FxVX1GXJzaQUl312kJWRoznXGhffz2aBF0RNCT1M2vUdnFmh5ctScPQjgG0XLVkq6cTC
         6D5w==
X-Forwarded-Encrypted: i=1; AJvYcCW5Ks9DEkKkS0LdyySoc6WBW28pnieD6CQ/tVQIo9KOnZKVFsW+K7MqWcgjy0+8Wc8uWuI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiOVZwyIHGi5lq/sXedMnil/uNJ1xq4HeQy+hrnxSB8R1wS4IS
	+aVdy+VgtCjRT3zKH56fkE4pCSfXEv6HecUwbR/3dzqrBhx+RFykZXfpuX6P5G43eCCIlIwyjqR
	gJw==
X-Google-Smtp-Source: AGHT+IFaTEQVvJEtWhp3ZxUl43YQFKv0vyHXzstBhIqqSy0TgE8/HNjhOVfOl877/xE21b5MkSaX03T1TNo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:ab51:0:b0:e28:fb8b:9155 with SMTP id
 3f1490d57ef6-e28fe41c747mr57834276.9.1728575663673; Thu, 10 Oct 2024 08:54:23
 -0700 (PDT)
Date: Thu, 10 Oct 2024 08:54:21 -0700
In-Reply-To: <cf2aabe2-7339-740a-6145-17e458302979@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009150455.1057573-1-seanjc@google.com> <20241009150455.1057573-2-seanjc@google.com>
 <cf2aabe2-7339-740a-6145-17e458302979@amd.com>
Message-ID: <Zwf4rfOFBlnMtdLQ@google.com>
Subject: Re: [PATCH 1/6] KVM: Explicitly verify target vCPU is online in kvm_get_vcpu()
From: Sean Christopherson <seanjc@google.com>
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Michal Luczaj <mhal@rbox.co>, Alexander Potapenko <glider@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 10, 2024, Pankaj Gupta wrote:
> On 10/9/2024 5:04 PM, Sean Christopherson wrote:
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index db567d26f7b9..450dd0444a92 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -969,6 +969,15 @@ static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
> >   static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
> >   {
> >   	int num_vcpus = atomic_read(&kvm->online_vcpus);
> > +
> > +	/*
> > +	 * Explicitly verify the target vCPU is online, as the anti-speculation
> > +	 * logic only limits the CPU's ability to speculate, e.g. given a "bad"
> > +	 * index, clamping the index to 0 would return vCPU0, not NULL.
> > +	 */
> > +	if (i >= num_vcpus)
> > +		return NULL;
> 
> Would sev.c needs a NULL check for?
> 
> sev_migrate_from()
> ...
> src_vcpu = kvm_get_vcpu(src_kvm, i);
> src_svm = to_svm(src_vcpu);
> ...

Nope, sev_check_source_vcpus() verifies the source and destination have the same
number of online vCPUs before calling sev_migrate_from(), and it's all done with
both VMs locked.

static int sev_check_source_vcpus(struct kvm *dst, struct kvm *src)
{
	struct kvm_vcpu *src_vcpu;
	unsigned long i;

	if (!sev_es_guest(src))
		return 0;

	if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
		return -EINVAL;

	kvm_for_each_vcpu(i, src_vcpu, src) {
		if (!src_vcpu->arch.guest_state_protected)
			return -EINVAL;
	}

	return 0;
}

