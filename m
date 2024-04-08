Return-Path: <kvm+bounces-13893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FEDD89C565
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 15:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CDA91C22B0E
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 13:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B867C089;
	Mon,  8 Apr 2024 13:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NHI6vsau"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E793B7BB1A
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 13:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584590; cv=none; b=U9UMe3dFxIG6h/rG5gPWVelymF0JGJMR9vgUHg9IDSXLD+UBNi9NZ3L9EcrVxw3EQ4X1TSK7QJbTUnjW9HOx32DBuNP73ON475hMsxY5uM88MNp7TceWYL+SyJodT4hEW7/n+PT2x68n6C9n6KbYzDuguQSItEWXWxme4J8CeFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584590; c=relaxed/simple;
	bh=Sv1lonJMRVR+UVuirFpH2YmZNDikOQMGGjjjY3UJLc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vA7xbJvkpIpAnP57xB0N/2jGtAudVK6B1v05fAeDo35LGZA9JMkhI4DEA5t/xZFuCfyLd+DRL4AvyjeypBPO18m5jG0LBmDhJFprnQ6HWVJsULKLr2VVYvV3a/KhReZjZiya/weZPdN7BwO/Ix3EeAxpDPj0qgszy4QW2vv9WG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NHI6vsau; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712584587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rmNJpHW5Hyb1elegWpLMoq/S1yVvTDK8DJLj5yKd5mI=;
	b=NHI6vsaufjkxY3p91hcNMoc6KF6VIBovGIlmprHI61ILY3k+3h0jgU4tQD6b83VuqrmG9R
	WtEsJZRSM0B5DlvHE5Cpr2YHfgZxzGOVsKPYwHou2hsFwrn4EIELYXh50AcnGJY3cXN67z
	ossLzxq4nXqf8TiyvTczi5C7G6FmNbg=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-EtWKrTR2MY-dHRwe9do_sA-1; Mon, 08 Apr 2024 09:56:24 -0400
X-MC-Unique: EtWKrTR2MY-dHRwe9do_sA-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6ea20a966b0so46677a34.0
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 06:56:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712584584; x=1713189384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rmNJpHW5Hyb1elegWpLMoq/S1yVvTDK8DJLj5yKd5mI=;
        b=E47mSIC1u/aARDSpWKq16I0wFzkcYd4s9sYVUPuG1Vvj4TsglEVm4kNqy2j6SmxgAi
         iQKuoqwYGHFXAmXYK33H30Kd4HnfJyB6hXCivMEX642loigJ2hikwWhJYYJvXdWlhVhq
         RIej7qoLOlx7jnG3oBiAqIl3gU2oBELdK8+XEg5AGtLiGHlJ0EblWGbvhFJ1oU+QkVGh
         10mikd3psHocnfTMGr9RbdLXICBUg+9fl8ZV6BS0vIlDuoWIU48BNBClLpmidLnKPbv+
         Kf29sF0+c2IpqERSxD+4R336bE+0iPRBvb1dXwEH19KvcHCFeQaw8IFF4wQQp9Oc3TTr
         gdOQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5FAPys7KfQVF5dY1t50hETkFRGsjTY1sbg3I0RN4jaV+dS0JSxoDP7Q4l+4DIhuu43vA/Jn3xLwh84URMy/kNLmLh
X-Gm-Message-State: AOJu0Yy4iRnwI6XGf1jNSDGUT8JwOoRc0Qh8Nv7dk8xA722WDbYZ/LbK
	Z8I6l27PkuzcYXInczFRzAIIlSaD0UlaPdHXgklWTwKEe6u2t8cp12OXDg/Jo+B17WBurBadZwm
	er5tl47b9z2CMFzN2rEww2WNyLSDXzVZdAIS75xdLpKLwmfRzPQ==
X-Received: by 2002:a05:6830:a5a:b0:6e7:592:87ab with SMTP id g26-20020a0568300a5a00b006e7059287abmr9702511otu.2.1712584583697;
        Mon, 08 Apr 2024 06:56:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/6cZVOu40ZE5XkeceEvB5GWIk5ESL9MdZGK/RmwIM5NG0Lyufyd1ejET8K1FRMeVweFzXgg==
X-Received: by 2002:a05:6830:a5a:b0:6e7:592:87ab with SMTP id g26-20020a0568300a5a00b006e7059287abmr9702473otu.2.1712584583118;
        Mon, 08 Apr 2024 06:56:23 -0700 (PDT)
Received: from x1n ([99.254.121.117])
        by smtp.gmail.com with ESMTPSA id vw25-20020a05620a565900b0078d63baf516sm1301217qkn.129.2024.04.08.06.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 06:56:22 -0700 (PDT)
Date: Mon, 8 Apr 2024 09:56:20 -0400
From: Peter Xu <peterx@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Sean Christopherson <seanjc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 1/4] KVM: delete .change_pte MMU notifier callback
Message-ID: <ZhP3hDhe2Qwo9oCL@x1n>
References: <20240405115815.3226315-1-pbonzini@redhat.com>
 <20240405115815.3226315-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240405115815.3226315-2-pbonzini@redhat.com>

On Fri, Apr 05, 2024 at 07:58:12AM -0400, Paolo Bonzini wrote:
> The .change_pte() MMU notifier callback was intended as an
> optimization. The original point of it was that KSM could tell KVM to flip
> its secondary PTE to a new location without having to first zap it. At
> the time there was also an .invalidate_page() callback; both of them were
> *not* bracketed by calls to mmu_notifier_invalidate_range_{start,end}(),
> and .invalidate_page() also doubled as a fallback implementation of
> .change_pte().
> 
> Later on, however, both callbacks were changed to occur within an
> invalidate_range_start/end() block.
> 
> In the case of .change_pte(), commit 6bdb913f0a70 ("mm: wrap calls to
> set_pte_at_notify with invalidate_range_start and invalidate_range_end",
> 2012-10-09) did so to remove the fallback from .invalidate_page() to
> .change_pte() and allow sleepable .invalidate_page() hooks.
> 
> This however made KVM's usage of the .change_pte() callback completely
> moot, because KVM unmaps the sPTEs during .invalidate_range_start()
> and therefore .change_pte() has no hope of finding a sPTE to change.
> Drop the generic KVM code that dispatches to kvm_set_spte_gfn(), as
> well as all the architecture specific implementations.

Paolo,

I may miss a bunch of details here (as I still remember some change_pte
patches previously on the list..), however not sure whether we considered
enable it?  Asked because I remember Andrea used to have a custom tree
maintaining that part:

https://github.com/aagit/aa/commit/c761078df7a77d13ddfaeebe56a0f4bc128b1968

Maybe it can't be enabled for some reason that I overlooked in the current
tree, or we just decided to not to?

Thanks,

-- 
Peter Xu


