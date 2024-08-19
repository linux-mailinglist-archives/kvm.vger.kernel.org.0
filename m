Return-Path: <kvm+bounces-24529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74B8F956D05
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 16:19:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32CC128136F
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 14:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9144D16CD30;
	Mon, 19 Aug 2024 14:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hBTjOdyn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE81165EFD
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 14:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724077149; cv=none; b=tfb4ScxnXpOyzbBc30Y7eNUVESBLny2ETsKjdbyzJ7Yi+BmLbRULEMH9F0u0gvbQV47pizNdPHXyRL4vHGfW73NaqPR4206ULF88HyD0wQz/2RZfjb1euBHsrue/iKr+dzHKPHmrh1GiQxjC7CM8k1ZnPTxVRIqZE6zKU2l8VmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724077149; c=relaxed/simple;
	bh=dhekefwMTSVQuGOPKfOzV1PmMypiOTQ84mIKdh7dtrA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c/XXBam11qe7un37Zilf561/QH8p/vT+5UwqiLC2NSj/lltse2AhmKtpLX5wI88CMh+O+v/WzpHxExh6sMxJaTXN3HXsu/wa2PyKyqZJ0Lpj/CqJwTZINwaeYvmYSGcQ07DGnl5rzfXucEXtS3ggHja5JWFqa6+OUmcmLMBH0sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hBTjOdyn; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d3d45c308fso3768639a91.1
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 07:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724077148; x=1724681948; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9hLxUPog6ZfK1tAJoowXx9bJNhMgN4jUhRQI7FjOx9Y=;
        b=hBTjOdynVn7olIuOORHzxjJbto6ZGN4x5k//tw+4Llmuae3ha4zD4NWfluh5UFZep5
         pZWFg52bF8hHhleMxVCViPJl3pUMK5UVzESTda8DrtJ0mQtxh6ofJjZARHcq3eN+mkEM
         5rz2bUocFTe75jwtCvzj6uoHkJdFZQq0S7AgL23eMJojt7G5TCkuzNAuZ0/qKDvgmyP7
         sWhlnw2KRY25OmVqfruz3/w4YWLmmuDmMqrJfFHbl/y3I7QOef9RmTvGi8Sub8cKFiE9
         qjSndVRKlFPWDRix9l1JhB6KwBQfXDwFsbf4e//JNlAav6oHHuAF8h7HoTgbuK3hhEzJ
         YhsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724077148; x=1724681948;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9hLxUPog6ZfK1tAJoowXx9bJNhMgN4jUhRQI7FjOx9Y=;
        b=Z8xGr28T8M/d/Q2J1KyYiHTNviZsvo1vbEn9nKkrFlmqM84GUUqH0y94PuXFbqalhh
         qxykZA34AhmEShcIUrUo5GwG6lmOLnMSdihpo9UnqVnTo2uGrPKJv3wTjTreSucFfSsA
         mnOb7DulTpbrXmYJUQIPTCEx6PN7AFDfT9rU3qo0KGacSeMc1koARWRF+3UP37dOCGdU
         RVejzm9xstNqUnH+lYCl4hGj0VnAxf1YNh4jzw3QDRCl/qN5ghIL03IVJC3MG8UbLJLO
         iLVeOnnGVAKl+7VQaPibRb9N6vm8IxoRcNCjvxVSB5P4i6ZP+0m6Sd5mmsyBQ2HsL6UI
         3nlg==
X-Forwarded-Encrypted: i=1; AJvYcCVt1iKElKCIqYi1AY/7qwIc5ooT4PLO74asSFXmufLhy8kVdFz7HIooY4ozeHp+lxg5RwnphXzwQHVs2ebrRZpLzTvr
X-Gm-Message-State: AOJu0YwWp9y8yI7SXqZ5uQaeEYsBgtdzShhY9W5flDDbsaixJ/4Knv7z
	tg1X1rlS1bvCWKh0g4J6fhuk+FisDo9nlHAhdxnwwTic6zVcfmy3v7PIt8fPrUHPNoZ7sSVIDWY
	PZw==
X-Google-Smtp-Source: AGHT+IEiVhcjMIh5HUWd1g2HbFSvaK6Ja8HiHcoC9dIXWYuIbXgLvSwXqZaaLQxebIQg4YAxeY37LXgLQ40=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d817:b0:2d3:cfe1:3205 with SMTP id
 98e67ed59e1d1-2d3e041dd44mr104680a91.7.1724077147516; Mon, 19 Aug 2024
 07:19:07 -0700 (PDT)
Date: Mon, 19 Aug 2024 07:19:07 -0700
In-Reply-To: <20240819121926.GG2032816@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809160909.1023470-1-peterx@redhat.com> <20240809160909.1023470-7-peterx@redhat.com>
 <b103edb7-c41b-4a5b-9d9f-9690c5b25eb7@redhat.com> <ZrZJqd8FBLU_GqFH@x1n>
 <d9d1b682-cf3c-4808-ba50-56c75a406dae@redhat.com> <20240814130525.GH2032816@nvidia.com>
 <81080764-7c94-463f-80d3-e3b2968ddf5f@redhat.com> <Zr9gXek8ScalQs33@x1n>
 <d311645d-9677-44ca-9d86-6d37f971082c@redhat.com> <20240819121926.GG2032816@nvidia.com>
Message-ID: <ZsNS86OE_sGzwZW2@google.com>
Subject: Re: [PATCH 06/19] mm/pagewalk: Check pfnmap early for folio_walk_start()
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, 
	Axel Rasmussen <axelrasmussen@google.com>, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Alistair Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>, 
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 19, 2024, Jason Gunthorpe wrote:
> On Fri, Aug 16, 2024 at 07:56:30PM +0200, David Hildenbrand wrote:
> 
> > I think KVM does something nasty: if it something with a "struct page", and
> > it's not PageReserved, it would take a reference (if I get
> > kvm_pfn_to_refcounted_page()) independent if it's a "normal" or "not normal"
> > page -- it essentially ignores the vm_normal_page() information in the page
> > tables ...
> 
> Oh that's nasty. Nothing should be upgrading the output of the follow
> functions to refcounted. That's what GUP is for.
> 
> And PFNMAP pages, even if they have struct pages for some reason,
> should *NEVER* be refcounted because they are in a PFNMAP VMA. That is
> completely against the whole point :\ If they could be safely
> refcounted then it would be a MIXEDMAP.

Yeah yeah, I'm working on it.

https://lore.kernel.org/all/20240726235234.228822-1-seanjc@google.com

