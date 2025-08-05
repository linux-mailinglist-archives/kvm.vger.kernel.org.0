Return-Path: <kvm+bounces-53994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F066AB1B4C8
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:21:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6DA97B23A3
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DA3274FEF;
	Tue,  5 Aug 2025 13:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QFkpxDe6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BE02737F8
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 13:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399737; cv=none; b=WrjEQgdnYdsIlRo6Pj/G85EMXMwOK5o5m2VrpRBCkBbRxHMYk6BK/dSHEpyZyArsI1fqJn5oSxtiy9OEmNxwTGF3mtoXMaNUSHI8/IFmZUwxot2M8P33gcj55TARzskLixfqrprYunb0JuAdMzx0ooR7MF6HnL2KYxDJlVNcv1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399737; c=relaxed/simple;
	bh=+qO3PB9bP+33YrM4AWmEKTR1mfjqtXnwr+VkBAhMJaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SOLFnJ9eYUP36Smv9X9QcHdpYi8er+82Hl6IPwQam59eucK2L/ID9iC6spt7bG17zjS+yzKxAeQd1XCjTD8MGVC+rmvOAKuWkc8578diApsHVRSV0g8hteL36yUCAz5bOwauprQvPbSvZMh9nDMR2B/paP8x7nBesGb8kR3HIUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QFkpxDe6; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-605b9488c28so9883785a12.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1754399733; x=1755004533; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IeApHAiG6oQ+gXTtDO1UmH6ll3A+3GlaXtGicO+VwBo=;
        b=QFkpxDe6jDqfks+mATZndwDLqzLlMKLglswGPE1I3UznEGzKLfH0ZdFVxUKuSpA3S0
         aD7AcAS4y2gvEPuYiIbWaT0gUDC6+OytnQTg4B8FMQhZ9dlez5OftB3GUYUakl+wUOPh
         XGI6ckvH9Iun3kmZvZGiNsBtcKHvPhw7rjPLQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754399733; x=1755004533;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IeApHAiG6oQ+gXTtDO1UmH6ll3A+3GlaXtGicO+VwBo=;
        b=xGmUab4cAHVV1FcJHc2FV5ERMt6FwaV8wAJIzFIEZBiQ2tx5Jm4gk8L2blXlmxtUEx
         0y1aDuC6MSXzpn80SsuKg4RhEWNrgXK+8dIjG1W4supXGLdrBQaReResua9nGIm4Pe1S
         ubipE9nycF/1XcXsoJC1/1+1L4qN+O86URAfnjKX03ipNWreZ3FujArUkfzv3toMXfgX
         8vjXegFNDQnjFYiPI9XDsHXHw6hUryhQl81hQjJDEtWHoZwxT8l+DrTGvLaY3v235Gq/
         Ww5ymoWbhdcXnWYwYfLxN7YxZnE8tNV5BNNf4xPkGFDDzVlIvfT84swN5ExThv6DoYyY
         ND6w==
X-Forwarded-Encrypted: i=1; AJvYcCXk/GDh5MiXJ1ATE75zPd/TIRKYDHTkhKeUpA+Kukc30bW5SvTRo54j/MuQVQW4zvc39r4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZDn3p1/gawcEXckvhAAVMaO/GvV3w+6f0A4LAaq7g1/mbVaYb
	75B1d4oeGybI5Csi/W849CN4l6BgJVRkIQ1DRWwmzHiqmXGJ2RystqT92I6Zx5GhyNGGyg3kshE
	lWMWBoK+XFg==
X-Gm-Gg: ASbGnctHdXeVWUfeNXVLizRN/O6M3Uz/nbJi+g04cxQtC8FSmpFBw4f/XS8fjLlArPZ
	g3Oq8d13Usxde//J2LH8JK97IKH+Zs3xuvnTSi4envDEAo6K4uvSUvVAdPW/IwgptTPg7G7dvgJ
	8O37e/kvhu1gFU7B01w8eBhhd4g4p/lbY+257jwzmvyUZ5rfbmbYkAhX+4KYxeREUwkEUdPWEHe
	ZJ1n5tn+Q2SRubVaff0P67g/x6tNmE/8lvJA89C1U9JPu6ob+nRknrQNq5jjd5tR78QbJPGB7Rv
	PqniqUbmVlZHR521x+LBsaW7bxwZBsP8E2ju6NpA6v2+7M72pOGxs+UfV2UheIh7A8KO5eSX9+J
	vCcpOcK1wOJnprBSGWEcg0dYI2dApHRxA35cnBJu6Q2AFxHsewgPy4kN54ck5PpiZqpgk+cgF
X-Google-Smtp-Source: AGHT+IGv27NSuD8+mbKttlCC9476+RsfnPD5eHMk7uEyVLRlckbj576JMYBC3SxC4wcs9a9OM7Ykwg==
X-Received: by 2002:a05:6402:1e91:b0:606:ebd5:9444 with SMTP id 4fb4d7f45d1cf-615e6eb5ab4mr12100306a12.2.1754399733132;
        Tue, 05 Aug 2025 06:15:33 -0700 (PDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8fe7a20sm8436126a12.34.2025.08.05.06.15.32
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 06:15:32 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-605b9488c28so9883702a12.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:15:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXf26wN8MpAM2ReEKytC37ljnRFGGCGg4c2V4FyjLOGgJX6Vllk3qd9+q/upQ2IFF/0rlw=@vger.kernel.org
X-Received: by 2002:a05:6402:510b:b0:608:6501:6a1f with SMTP id
 4fb4d7f45d1cf-615e6eb5b94mr11310388a12.1.1754399731827; Tue, 05 Aug 2025
 06:15:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com> <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <20250805114908.GE184255@nvidia.com> <9b447a66-7dcb-442b-9d45-f0b14688aa8c@redhat.com>
 <20250805123858.GJ184255@nvidia.com> <db30f547-ba98-490c-aaf7-6b141bb1b52a@redhat.com>
 <20250805125643.GK184255@nvidia.com> <a18a9b55-b3f0-466f-abc8-39b231c04bb1@redhat.com>
In-Reply-To: <a18a9b55-b3f0-466f-abc8-39b231c04bb1@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Aug 2025 16:15:15 +0300
X-Gmail-Original-Message-ID: <CAHk-=wiQ=9g=+A8LPWhPj9yRXFzf=tJKw1Cy-wpj1N9FKu-65w@mail.gmail.com>
X-Gm-Features: Ac12FXwrAL_htKZpJKiw_Db3QzCJ14QwInGEA0oKHNUPYerZIQYMEL6CgT5QlJY
Message-ID: <CAHk-=wiQ=9g=+A8LPWhPj9yRXFzf=tJKw1Cy-wpj1N9FKu-65w@mail.gmail.com>
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson <alex.williamson@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Aug 2025 at 16:05, David Hildenbrand <david@redhat.com> wrote:
>
> So I don't like the idea of micro-optimizing num_pages_contiguous() by
> adding weird tweaks to the core for that.

Seriously - take a look at that suggested sequence I posted, and tell
me that it isn't *MORE* obvious than the horror that is nth_page().

Honestly, if anybody thinks nth_page() is obvious and good, I think
they have some bad case of Stockholm syndrome.

This isn't about micro-optimizing. This is about not writing complete
garbage code that makes no sense.

nth_page() is a disgusting thing that is designed to look up
known-contiguous pages. That code mis-used it for *testing* for being
contiguous. It may have _worked_, but it was the wrong thing to do.

nth_page() in general should just not exist. I don't actually believe
there is any valid reason for it. I do not believe we should actually
have valid consecutive allocations of pages across sections.

So please work on removing that eldritch horror, not adding new worse
versions of it.

           Linus

