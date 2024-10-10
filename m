Return-Path: <kvm+bounces-28432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 250329989EF
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 16:41:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD6F428BC70
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 14:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC921E47A7;
	Thu, 10 Oct 2024 14:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FgMv0YEA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FCC1CBE92
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 14:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728570659; cv=none; b=nm0S8RzamwEp2bfPTBS/YeUGKF5HB6OXcQKwv4SHRcZgTVhj4pxiaKky9GfxnYMV+nOw9v/IccaK0FPJfxM7YDYyYcbIgK+Sc5C6wUUnAYX7HdNn7B+seYyNJ1TOJSR5zCFOqhwUHfbbeYB1vXYEMRTIh7ZJk54fTrEVg2zLHCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728570659; c=relaxed/simple;
	bh=zrDzY2dC9iSZ41dUJpIYESK9yIOH/UXXFppYEx3jWLc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ex/fFftLKX/VUgDfucZ7lKz6nJrnJnt0qFiqDg+vfEIttkEkmbv23E4DxpIJkwj3I6B2oAsDJFhiAuCRybyPBwes8nBHv6Xt6E2TLlRTCJsQ/0KhfadKKBnYy0W52gSAvOM+sLlRf//EAG75WtfdFmICFgUB/9gSxeFb8qxazhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FgMv0YEA; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43111d23e29so217415e9.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 07:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728570656; x=1729175456; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tE+Wl4+E4rs/M8GYD9TIuj2GI6hWuRwK8xeePMM9tf0=;
        b=FgMv0YEABCAaevKNVXok2eJYOXzO6UtqBz36z6LP+ptkqsudvvJ/gAi2vsn3S0Texq
         0v+Lb+B/FOLfuS/HZwPfw/nIi4bqvrFkv3zasjtGOyWUluc72frOWD5SwyuVeb+AXnsB
         ChUpPKUjjUcf9RzGYqbR6bfzs4brifZ83zR+pKtHmlc8kYugiYFPRUVd1fjX4cQRSM/9
         5T4dse81kK7FLgPMNZUJVA/BYN5LaNQoqxKDiBvvcCaEiu72gJVFOZMcTgK88Lhxjx+0
         oGm4yPnawylUpR7SQreIgjfIy+9cYIWnqvvpZqI9eHFNK3qkKVCNV1T/wexjSmvnl0CF
         5O5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728570656; x=1729175456;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tE+Wl4+E4rs/M8GYD9TIuj2GI6hWuRwK8xeePMM9tf0=;
        b=CDnc0Nl1FhSvSi5f/Kxd9D5BhdL6W83pBmFbu4nRs8NH7ZkrHZlrHnoPvYdgRtc5C4
         9DzdoESxIYQBUrlTFAGktoL8aIfUcDl6UOIENjKTCtmSellzxppGAKJ9o7nCRVlEHRfz
         wNhsKOy2Nqih8b7cAxIswFEe+qOJrIpcXkBU8QB2Q6le8PRORnjxDAqtE++OkdYjxqt5
         5swivvQcEcsxjpEcPbVb7V52AcuUxL78I70MG7cQq/bJWRnKRmkyi4JcB8/G05ClHAMn
         4Oo4MZmYdyCVvxmlUMR/fO40Y7S4Ufx3wqeg65zz/R9AuyoHyFXdUmEPDzc84uYCOqsx
         Gsbw==
X-Forwarded-Encrypted: i=1; AJvYcCUinG76I6wguws1fflG1KIa3sQ61PuPyBQdv8uZgSQ7BT99ZYfNCeAY859n62FiHvq8Aos=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5eZL4+7XdS/HxAcQr/hsAGCUeTgExFFS0cvcTBEVbrMAeohyD
	87zSZN6KzNdfstNwu5wAfGpXt8eYpQyH5EiCCVjNn4g6+klh7452X0TcpcII0LVAsA6pGLk+7v7
	CahmR9SPgXvJnrYMgyS4BiebFEti+06FpIQnL
X-Google-Smtp-Source: AGHT+IFZ//sRKtEd8nP9cG7ZiBnAUvA3uv+jgKyMrB0Rf8gpUxj92jmXXT+xZGnywK8RS1924DhZ8SBfhAM/Buv+Mno=
X-Received: by 2002:a05:600c:1f06:b0:42c:abae:2ed5 with SMTP id
 5b1f17b1804b1-43116e07766mr3773495e9.3.1728570655808; Thu, 10 Oct 2024
 07:30:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
In-Reply-To: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 10 Oct 2024 15:30:18 +0100
Message-ID: <CA+EHjTx_OumyOk1zZrUh1uwkBncsXZxMKD6Z_j4WjZrd+2LVLw@mail.gmail.com>
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
To: David Hildenbrand <david@redhat.com>
Cc: linux-coco@lists.linux.dev, KVM <kvm@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 10 Oct 2024 at 14:41, David Hildenbrand <david@redhat.com> wrote:
>
> Ahoihoi,
>
> while talking to a bunch of folks at LPC about guest_memfd, it was
> raised that there isn't really a place for people to discuss the
> development of guest_memfd on a regular basis.
>
> There is a KVM upstream call, but guest_memfd is on its way of not being
> guest_memfd specific ("library") and there is the bi-weekly MM alignment
> call, but we're not going to hijack that meeting completely + a lot of
> guest_memfd stuff doesn't need all the MM experts ;)
>
> So my proposal would be to have a bi-weekly meeting, to discuss ongoing
> development of guest_memfd, in particular:
>
> (1) Organize development: (do we need 3 different implementation
>      of mmap() support ? ;) )
> (2) Discuss current progress and challenges
> (3) Cover future ideas and directions
> (4) Whatever else makes sense
>
> Topic-wise it's relatively clear: guest_memfd extensions were one of the
> hot topics at LPC ;)
>
> I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7),
> starting Thursday next week (2024-10-17).
>
> We would be using Google Meet.
>
>
> Thoughts?

That works for me, thanks!

One thing to note, we're coming up to the period where the US/Europe
move away from daylight savings, but not at the same time. Just
something to keep in mind :)

Cheers,
/fuad

> --
> Cheers,
>
> David / dhildenb
>
>

