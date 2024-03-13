Return-Path: <kvm+bounces-11768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 313F787B346
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 22:12:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 636CD1C22BEC
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 21:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F339555C35;
	Wed, 13 Mar 2024 21:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IyFptiMZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D7254BF4
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 21:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710364323; cv=none; b=TAxW2G92iQAw1JNU6U0vUM7BvUvBjk6AgXzdL/lwdp4/Gz9PU/rQKzJtqf2YSJs8PjAeCTj0BOW8VDgd0bvA+4cTvCb4ol5qXRO88N712BOU9lWU2pjuPZ5S8Qze/E4+RIyNw/7gmSwZwN4DvOpTuZ8/3IsOoR5E93j9YJJBe1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710364323; c=relaxed/simple;
	bh=qiT72c9JTz/mIY2biql9EBUdBUvC+l9mx9EAksC0Flc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SL5b4AfEDnO3HgPxRn0+danUL1BqvRxmn3Nh1ESVIT+dTJnNA7BJl1WbAi3q+sk3fD/6h9BFgtp8bSpzoX/pTAAlwKQolG7kJjBFWmefXTAMurviuTkJTSfT9Q9doF3JigDPLIby8xuuKyq6jhnVoytuB8vnHm4a3I0gAkNESQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IyFptiMZ; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-609fe434210so5141507b3.1
        for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 14:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710364321; x=1710969121; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AFldDYFYoZJVu+X/7qJi9Dh0UTrOOknI+KaE9Y/cruY=;
        b=IyFptiMZc2cMqGVZlnJtDqXqZv6XavWxqAHqYDCdsUN4XCqsk/3ufj8GAsDyOYBOwB
         coHk9All0ZGxL3bzlcqAPWNR5R3ikZGr0f2OgfayYqOq8DElz07vy5oZ2Pre8TovxuIY
         hFka1wG4p1fBGOu0dITLMEm1Ui86YBMsgdqAEbfhpmYH13hwDY/FjAalr9X5rGKSg4lT
         Uxwp00v7jN9cXIvoQDmNulvPx+pQzBClbiLGp9XECH3CrrcWICCGncZbKPIEOFHmeOga
         fGX+OtsA5D8Gc1dTb6M3ybIqHd3J9Kz82y33eNkxNatXn6+cfCZZXPsoboW1dhLQv8ye
         CbXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710364321; x=1710969121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AFldDYFYoZJVu+X/7qJi9Dh0UTrOOknI+KaE9Y/cruY=;
        b=QisoSi4qD2jotUhnrD50sLobONC4Kcx2MgIOaPpVBYPPl7FJuXU2gounZHri2He6Xc
         XXpLTBE0gXG4hBe+TYfCQPmhQj1Db62ZRxDyoKtQw7Syg83LGSPya2+7qHVIx6uSgGka
         7k0729PZelaLAhWgdYUejirYxRLd13PhHgogdAjqkPFrZF6Z3gC5LkWWOo8YChuyTlai
         CkR6aVv9jebDjQoVF/KGklkgN4D6Z1NdAd3EwkeJ22mcgXmoVUOgGa8drUC+roHfYMNy
         wDCm6bN0OZn4/DIwsEbgzt6Bodr8/zbRM71toWRYLpBS8NlQU2NoJjvAFJFBdEwJb7qX
         sHhQ==
X-Gm-Message-State: AOJu0YyW3I1hUwC7a7Utgrdm6QqEmqbBRUUJmhf4yk6gyNyT/3Z3LDof
	RR5PRFZ017NIZ2L1TwGWn7WM88SMuquwQdd6dyXM5ATdOdrE101UZwh7wy+HvZ/8RjbytoxeFoF
	xDw==
X-Google-Smtp-Source: AGHT+IG7ZnlWrbgu/ly+F89sgb5mQBbUUJEyVYuKM782fY5hVU8Int08JPvlCwJXLXABPZ6VjEEzriKV4K0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:95c:b0:60a:574b:b37b with SMTP id
 cc28-20020a05690c095c00b0060a574bb37bmr748933ywb.0.1710364320848; Wed, 13 Mar
 2024 14:12:00 -0700 (PDT)
Date: Wed, 13 Mar 2024 14:11:59 -0700
In-Reply-To: <a5fd2f03c453962bd54db81ae18d3c2b8b7cf7b1.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240312173334.2484335-1-rick.p.edgecombe@intel.com>
 <ZfIElEiqYxfq2Gz4@google.com> <a5fd2f03c453962bd54db81ae18d3c2b8b7cf7b1.camel@intel.com>
Message-ID: <ZfIWnykN1XG-8TlC@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: x86: Don't overflow lpage_info when
 checking attributes
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"hao.p.peng@linux.intel.com" <hao.p.peng@linux.intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 13, 2024, Rick P Edgecombe wrote:
> 2. lpage_info doesn't need to keep track of unaligned heads and tails
> because the unaligned part can never be huge. lpage_info_slot() can
> skip checking the array based on the slot, GFN and page size which it
> already has. Allocating kvm_lpage_info's for those and then carefully
> making sure they are always disabled adds complexity (especially with
> KVM_LPAGE_MIXED_FLAG in the mix) and uses extra memory. Whether it's a
> tiny bit faster that a conditional in a helper, I don't know.

I wouldn't prioritize speed, I would prioritize overall complexity.  And my gut
reaction is that the overall complexity would go up because we'd need to make
multiple paths aware that lpage_info could be NULL.  There are other side effects
to making something conditionally valid too, e.g. in the unlikely scenario where
we mucked up the allocation, KVM would silently fall back to 4KiB mappings, versus
today KVM would explode (bad for production, but good for development).

