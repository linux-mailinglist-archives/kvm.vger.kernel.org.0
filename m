Return-Path: <kvm+bounces-28467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E36E2998E25
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 19:14:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FBF71C2477A
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 17:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A54CA19C574;
	Thu, 10 Oct 2024 17:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zKaRsAgD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678E3192B9E
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 17:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728580492; cv=none; b=JxsZ2528pizD2qa2yTVY6hJoEb/jKr6cgwDiXjvWuwxEOLYkgSzI4dl8xqD+G6POP+kq8SuUVD+gToi8ek61g2dvJO6fAgXXrKLbc9gWv9HRpzy6wb3N8a7tU3UoUu07WUd7DAXmbzmpl7CKl2CHvCoKLsShwu4Iq/b3BzpZ62g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728580492; c=relaxed/simple;
	bh=7tsn2k0TTFeg3mKqWGdSj/NaY0LxEG/+X8eD7x65Idk=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=fL18SMBbLoujz2WMTitXkA8euL/a6inqhfJqu/3lGVT3lFXr41VHBUtFtIUcqdyLQ82vsZ6ZzuuKQnDENfdBUnTq/1lGuvkCFjgIsI2gkI0N0Ts2VQyPTnJuiDiwwg3jICQOLweFOVtKhCCkcGilY5WinCfpwnwog4HnvX1abYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zKaRsAgD; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e28b624bfcso18960187b3.2
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 10:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728580490; x=1729185290; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xlMcukMj6WQQSY/YNXm7ppMZ34KPgNbsj26U3em6IDA=;
        b=zKaRsAgDOaeF+Xk58ZhvuhfNQS61duzZsE2Ww0WnLlF6w7G7VUFpC8+5wikNdPn7Y1
         p27JiicTwDAD97zKtGW5r161As81XsBpim3W/ctO1yVKEUW1+hIAid/2yrLk8t6wc2ur
         CgdRSdf+dmUsJ++nroH5psD3+asnsyBrsG4E4Rgkeb11KSGiaM4qV2fbaiPY+b9EwoQc
         AtkmsFIqavNX6J36DC5FCKc1MN4pzR36HatVavwg3z0Tq6fxp6bUKachj2WU/CbrbZRQ
         5D3Iob5OkPNDjFprv+Zx0ii6GBzkHNAGpKQdMdUxN595Vh0Mi8voRi6wRJ1xgxZajLJj
         +PEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728580490; x=1729185290;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xlMcukMj6WQQSY/YNXm7ppMZ34KPgNbsj26U3em6IDA=;
        b=NuHEcO0MynIuX9mp7L0hVA2aa8BsyLanwz5SN6xSY5tT7hqLfS68AZaKW++72wP/LZ
         pQr5tAFA37MgTWxp0dO7AccUoMgDO8v9hCUFrUNBUfgTBF0NEHOBorL7cjkt0CBOwHnR
         lx6Mm1hPHvXc815eO0Sr+a9ZaxebBqn/2Jqk57H6eKY1gM50nHkGpay/G7UQ7xZEr1Wz
         ZVoo8n561cBK5d6ZyNb1fS/wBVQaLCf/9KUsGdRoIJzeYJHPwMLh5lmNcU3eX9hZQNfx
         3EZg5dPrWTqYwkQcaHd/b+2vt2n12if3+amvvq4kLLF3U6ZZTmYuKDDvvOeW1A1Y1FjS
         LZAA==
X-Forwarded-Encrypted: i=1; AJvYcCWEodAHTL2LIG4w0tN/bnm2OIIkvNWcBwVVGPr/eBpXOvukN9bVld59RXkMYpPyj3ekZZ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjH+87NybfaatFlR1D0Q4c0rjCz9nU+gFf/SFnwLr+ezFOMIYi
	HT2oJfp3oHq3FZUZzH6V9UjK/vmU+j0bkNqGbB0ftNBIIOtap2yZtDsb2rGaBmbIfmxjkx+3lV7
	HOqcHlTvU3MGBTBWkfWyDpw==
X-Google-Smtp-Source: AGHT+IEjAK98Mqp1AkrOnkNARo5lvT4BYelWvKMiToA561D+B3794r/t2SAvhVt/pAlzp4XFn73iXkzQ4iR+FcD5qg==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:146:b875:ac13:a9fc])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:1812:b0:e24:9f58:dd17 with
 SMTP id 3f1490d57ef6-e28fe32f042mr64913276.1.1728580490350; Thu, 10 Oct 2024
 10:14:50 -0700 (PDT)
Date: Thu, 10 Oct 2024 17:14:48 +0000
In-Reply-To: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com> (message from
 David Hildenbrand on Thu, 10 Oct 2024 15:39:37 +0200)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzy12vswvr.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
From: Ackerley Tng <ackerleytng@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

David Hildenbrand <david@redhat.com> writes:

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

This time works for me as well, thank you!

>
> We would be using Google Meet.

Thanks too! Shall we use http://meet.google.com/wxp-wtju-jzw ?

And here's a calendar event if you'd like notifications:
https://calendar.google.com/calendar/event?action=TEMPLATE&tmeid=NDJvYjBha3FlMWpxdHFzMGNpNnQzZDk5cjBfMjAyNDEwMTdUMTYwMDAwWiBhY2tlcmxleXRuZ0Bnb29nbGUuY29t&tmsrc=ackerleytng%40google.com&scp=ALL

>
>
> Thoughts?

