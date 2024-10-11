Return-Path: <kvm+bounces-28643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B04899AAAB
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 19:49:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63AFD1C20EAD
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 17:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 629D81B3B2E;
	Fri, 11 Oct 2024 17:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BCCkjerF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5717F9
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 17:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728668943; cv=none; b=r3wu3ksxmtZDyjwTm8EJ/aWPrZOzG1a8aVhk2P5Wk4wn+f/5Juw49AGKqS6QzNFPNwyItLCIEkDYmorM8Sw/M8UTypweTboVADlQyCgkubkQP5wuCfmM6HOSzgzkbClfEWyuxYRj8PfktqdUKHy5ntMy6WRtJixjBfD/Q4bt6PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728668943; c=relaxed/simple;
	bh=KtVZFQ5ya2uPwpGF/Pja1NI8kHzJPyvIvSlOD5IVEwE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QwfdpqTvWNhPMnfq4/Y/P0undp/qHLn+pLmjv9vWtGgpvGdQifa1ODoMuDaEIPQKkKv5Yu4SZyoPazWFG7WZ2kDCa6dld+rTLugNkZp7dofYLbg9gCnlQiQkalMPbkymdmrMhvL7wVR0qvHYJ/6A3WJNEu6BHmULcc0Rer4VUyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BCCkjerF; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e290d41291bso3088368276.1
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 10:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728668941; x=1729273741; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O4Puqlsgo3JtkM+YPUI+9BBuYWEnXPV4jctacnOAOZE=;
        b=BCCkjerFE9Vt41Pp2heWitl0ROm6dey/XfoyzQErRVkSUIQzpKxxMnZuYRmdWQyHC/
         T+PU6MI7PgS55WP4yV1wt1uL/8yO5y/4kqvM+9Os7t7zhLHmCeE7bnfSLiO6HTrDPQn4
         jX2RIglSXImWOzgXMMKrM8Jdbd1irEqWVlPYU5DP+znzFpjoBT3N6pG1d+vHh/w8QmiD
         6YjQliRFvYbgZRCoYxCIFNaKJ4nbC4zucQXXk3WC1mf+FwwgS4ebznB27CTrA7s7GIP/
         jJYleNfMHIBsZK+/EfqsHy88IBGGmQvpq6YaLydjXyplm1BlvmEQBUA0ljN9g5WlV7bq
         2PpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728668941; x=1729273741;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O4Puqlsgo3JtkM+YPUI+9BBuYWEnXPV4jctacnOAOZE=;
        b=o1/8ffbM4KoHd03rFbfPwM8qmlaTLSGJR5AKH28bDLnXUdW+3titvm28WfJ6F9gTwZ
         jnpr7yUqLI80YDw7vzwP++c5JD6i7l89EI0DI25ZuEA8gakqGaq3Sfq1xbY0XQa7DaKR
         owXpiXy2dCZvmINduUG4qnc5cMH/i3B++y9nA2CHXncW3tMPaE6VTo0WLDX+XAvXQMtL
         IbTTGWzQYWyCL50ubjRwaz5W/Z+t2gGjaS/UdsUr60qpBwMmR2yv4nuMw3tfM0ILL+o2
         ViaP0NDpozyTHb05JaNJSzwSXov67WtV83lgMVVni2r55Hv0QVuQsNwgS4XbaudZBjl6
         PdCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnknQ3/E/Dqr+dGtIsYZqwzeTbVThQWLltdfW/bueDYaRkEQRTQFf05EM5NmURDWmYzzg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqd/q1IeyVDJps+ET7SjlERDrmtu2gh6c2fCDRon63wiGz6RJI
	6e1mko3pUZD2dYYwqsP/8aQWZen1SqS8XhWKFxmTXhsDl+gCLtfCBQgDwQdPLZxI25Sd0/tR2YE
	FNmFXyCk5KFFZTchDiOdF1Q==
X-Google-Smtp-Source: AGHT+IFKZwPT4nRs/hQvsvgdY0QnpNCfc2Cp+dGR3RRjJ02mIyKjnlinyvV7IUArewi91fk8TwEvDoo5enr7Y7PsTw==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:146:b875:ac13:a9fc])
 (user=ackerleytng job=sendgmr) by 2002:a25:74cb:0:b0:e11:5da7:337 with SMTP
 id 3f1490d57ef6-e2919d9e4e2mr6967276.3.1728668940575; Fri, 11 Oct 2024
 10:49:00 -0700 (PDT)
Date: Fri, 11 Oct 2024 17:48:59 +0000
In-Reply-To: <d54f9b64-fc9f-4b63-8212-7d59e5d5a54d@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <diqzy12vswvr.fsf@ackerleytng-ctop.c.googlers.com> <d54f9b64-fc9f-4b63-8212-7d59e5d5a54d@redhat.com>
Message-ID: <diqzv7xysf78.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
From: Ackerley Tng <ackerleytng@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

David Hildenbrand <david@redhat.com> writes:

> On 10.10.24 19:14, Ackerley Tng wrote:
>> David Hildenbrand <david@redhat.com> writes:
>> 
>>> Ahoihoi,
>>>
>>> while talking to a bunch of folks at LPC about guest_memfd, it was
>>> raised that there isn't really a place for people to discuss the
>>> development of guest_memfd on a regular basis.
>>>
>>> There is a KVM upstream call, but guest_memfd is on its way of not being
>>> guest_memfd specific ("library") and there is the bi-weekly MM alignment
>>> call, but we're not going to hijack that meeting completely + a lot of
>>> guest_memfd stuff doesn't need all the MM experts ;)
>>>
>>> So my proposal would be to have a bi-weekly meeting, to discuss ongoing
>>> development of guest_memfd, in particular:
>>>
>>> (1) Organize development: (do we need 3 different implementation
>>>       of mmap() support ? ;) )
>>> (2) Discuss current progress and challenges
>>> (3) Cover future ideas and directions
>>> (4) Whatever else makes sense
>>>
>>> Topic-wise it's relatively clear: guest_memfd extensions were one of the
>>> hot topics at LPC ;)
>>>
>>> I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7),
>>> starting Thursday next week (2024-10-17).
>> 
>> This time works for me as well, thank you!
>> 
>>>
>>> We would be using Google Meet.
>> 
>> Thanks too! Shall we use http://meet.google.com/wxp-wtju-jzw ?
>
> I assume that room cannot be joined when you are not around (e.g., using 
> it right now makes me "Ask to join"). Can that be changed?

Thanks for testing and pointing this out! My bad. I've changed the
settings to make it open to all, and tested it using my personal gmail
account.

Please let me know if it still doesn't work for anyone!

> Otherwise, I think I can provide a room (Red Hat is using Google 
> Mail/Meet etc.)
>
> Thanks!
>
> -- 
> Cheers,
>
> David / dhildenb

