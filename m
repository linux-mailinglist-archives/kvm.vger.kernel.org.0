Return-Path: <kvm+bounces-24458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1241C9553C5
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 01:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E90BB2247F
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 23:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E0FD147C71;
	Fri, 16 Aug 2024 23:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L/n06B5l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D731143C6F
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 23:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723850955; cv=none; b=rNE9yzbb0WivtrGQ6ZXhEU+QJguDlGcZU3t1kMu0qTFwX1g4r0i8/3/AnovfPyXD7W6TiAhW3O/rB+gDEvArcK3dALtgJK/yMHX6BRbfX/JQ9dT8NzprCv/PIYaPgZ7gmHO4Tme9Dl3hF9MoB61J3zkQjNKX4cvYOpBIlDZ8RhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723850955; c=relaxed/simple;
	bh=Bt0YMJRmw8MNOul/135L3smUMgVwn4BpfnuHVrP+vwU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OIOaq8V5dYUZ6UBlWXNschpPs3o8A8EzKusOfS3TQv9OdzmVUebbRnoRFdAcvxJUI/VrOhYiLuwoaWoqk58w50t3XO9zr4tLqip8cFW3nfIh8iiVOHiyepihOSTlLFATxYQ/K3lmzTzsoc6W4bxg4uc+qQJnB8eCInvzCe1U88Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L/n06B5l; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0be2c7c34dso3757790276.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 16:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723850953; x=1724455753; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TUfZiEZ/zWC4oS/2guG5kwxGPBzTqwm8IwXvGlxoeJo=;
        b=L/n06B5lKScocWuqQM0nJLuKcoLCPjNhJDVxgQGzR4xh9ZP7E2jnE2RPcTVUUxjrEX
         eL88UFKQg6Xpa51R1Bfz1emZCfJiP4dqkTp8UfEfSW3oPKQSDokLgOgmYWKIRep7pULk
         rGqML1UU0YurNzRFH09eqeP1prtO3v7QdOHUWd0goM8JntHNuNY9vR04E8VsWFhGgY9u
         wU9bEJjk9mr0Qlxhz+gHnpvgedP8+L8kZ54tmMo6gRKYYktInCkMJGs1iwTx+o50MPxh
         QRXYhOeDJ2rZLAKxrhp78ucjPqWiOrShsKGd9h6SAK72nL1pzcJfUicJtzggoTyyoByE
         1ggA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723850953; x=1724455753;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TUfZiEZ/zWC4oS/2guG5kwxGPBzTqwm8IwXvGlxoeJo=;
        b=T5YKlwgfhbZ18u9Mnz1+HbFWekse+KSex9Hb/iWtoe3+HejDm60f1UT5+l8Mzai+fr
         DfNhbTDqTn+lhNgy9bj73RnR6GxRpKbR1rE3e7Lmv+VwenK05r/U/uU+KszJo05upfSl
         dCeeEBb9rDCjFOuQCqaIi2faTTEpUSHr9U4sB2oQVFF8Mc5jMfFal16UEu2/AxnWBqGr
         xQydbfcHKtt3SVDBPkYc4GxpvOAjnb6A5BK+OE8RcVuIN5zRvDFUc1g5Zi0a0vbyHEXf
         oBT3v9i4bNJrcMFmNEDRHSnj7n1Z9E0y5tDNjszY+JKgTA7NpK3xhB7ESSFTITuclrMj
         OwDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAnNldYzrwAJFxjfKrOa8VbhCz4bgH+FgoyWjrPNN35vWiTTATPVf0/BqIUNGVocLw+qFXpGAOfesWP5RX6ndoyJVx
X-Gm-Message-State: AOJu0YxJZSeP7gi/3u1O3mtS+F9OxIXEOsLpJohNgnCVoyFYDb9WeTka
	XmC467ZuuJeNOqMtXRkIwdnJM70sfF7Pja9aZR3fL3L1oKIrJPD7JUXioHXVfzNj2TSj7rnZcvH
	zZQ==
X-Google-Smtp-Source: AGHT+IEWb94aAO5u4fTb/3R3D/23R8YCTqJ4nqrJFUMcRxNYZoeVejVsFCkWl54WRQZOieysZmSQkPHXweQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:c4b:0:b0:e11:ade7:ba56 with SMTP id
 3f1490d57ef6-e11ade7bf1dmr63773276.7.1723850953027; Fri, 16 Aug 2024 16:29:13
 -0700 (PDT)
Date: Fri, 16 Aug 2024 16:29:11 -0700
In-Reply-To: <20240812171341.1763297-2-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240812171341.1763297-1-vipinsh@google.com> <20240812171341.1763297-2-vipinsh@google.com>
Message-ID: <Zr_gx1Xi1TAyYkqb@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Split NX hugepage recovery flow into
 TDP and non-TDP flow
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 12, 2024, Vipin Sharma wrote:
> -static void kvm_recover_nx_huge_pages(struct kvm *kvm)
> +/*
> + * Get the first shadow mmu page of desired type from the NX huge pages list.
> + * Return NULL if list doesn't have the needed page with in the first max pages.
> + */
> +struct kvm_mmu_page *kvm_mmu_possible_nx_huge_page(struct kvm *kvm, bool tdp_mmu,
> +						   ulong max)

My preference is "unsigned long" over "unlong".  Line lengths be damned, for this
case ;-).

>  {
> -	unsigned long nx_lpage_splits = kvm->stat.nx_lpage_splits;
> -	struct kvm_memory_slot *slot;
> -	int rcu_idx;
> -	struct kvm_mmu_page *sp;
> -	unsigned int ratio;
> -	LIST_HEAD(invalid_list);
> -	bool flush = false;
> -	ulong to_zap;
> +	struct kvm_mmu_page *sp = NULL;
> +	ulong i = 0;
>  
> -	rcu_idx = srcu_read_lock(&kvm->srcu);
> -	write_lock(&kvm->mmu_lock);
> +	/*
> +	 * We use a separate list instead of just using active_mmu_pages because
> +	 * the number of shadow pages that be replaced with an NX huge page is
> +	 * expected to be relatively small compared to the total number of shadow
> +	 * pages. And because the TDP MMU doesn't use active_mmu_pages.
> +	 */
> +	list_for_each_entry(sp, &kvm->arch.possible_nx_huge_pages, possible_nx_huge_page_link) {
> +		if (i++ >= max)
> +			break;
> +		if (is_tdp_mmu_page(sp) == tdp_mmu)
> +			return sp;
> +	}

This is silly and wasteful.  E.g. in the (unlikely) case there's one TDP MMU
page amongst hundreds/thousands of shadow MMU pages, this will walk the list
until @max, and then move on to the shadow MMU.

Why not just use separate lists?

