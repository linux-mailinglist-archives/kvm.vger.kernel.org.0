Return-Path: <kvm+bounces-27398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8450A985090
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 03:13:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B6FAB23AB7
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 01:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95DDF139D03;
	Wed, 25 Sep 2024 01:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NUOLCo4K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF51DDA6
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 01:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727226535; cv=none; b=BosB6vgvVFiWF3nCF83cTHU/hWUminYWseZAL2Tb/pQdqi51PjjWfL4cWRliPpgsc8gOtTC4kdcuRuBYr9OBXg6fM73L92GwhUM2Gu6wgicA2HClFWmIs0KZ4WqK67egABBxYEo0qxbWXCfIpdZ8TxlWOTfar2SxfY4LK4/6ehI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727226535; c=relaxed/simple;
	bh=wFAUhxj4Kr7iOTjExUj5M2PBKlhGdBn7aCFOohPbPc8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UcHD9GQRh84dzEVyOLDg5/l3Jgt4UPM9h0RphjoWfJ9kBeaLNioYwV57w8ZJjMtJzxqkSARf3TdYEiSeHuwa4Y1Xj7SHItPZKGPUbPndh3YZISu1vu+TvRpuCgLEsfEETFuEh85A4znfyMDgmgC5jNxGw5KI4unE1N4tEa/2FUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NUOLCo4K; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a8a897bd4f1so906265566b.3
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 18:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727226532; x=1727831332; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wFAUhxj4Kr7iOTjExUj5M2PBKlhGdBn7aCFOohPbPc8=;
        b=NUOLCo4KKB5pkJWNVZuSd2NOBQJsOeVtOsR9uuGNTAEHH5yxvV9C78c0HVR8YqZP3K
         eo00qh9cGcgC2GTkbNz5XlcjsUDiU1GuU3S2szp7AnRvRnTnzYQom6l39a3PnD2FKbRS
         AeqiK7BiOxdhiYmNUBcyNH02ZdUdhEp7OaOsaAFX8d6WKkWR/qBdG+QT3aCaD0kbUJXC
         vcgdYl37DtHqfA8WpmWrdjH0BHZi6Z1x3q1OvOjCcshnUs97+UWqypcUhTIlbU8xf8BP
         Aob6oGKpzHBR67NGIc8dFKIDKsclliwhiYZIlFy7fKO2x63hZs5AwEOC78g3ihtwj8OO
         EOUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727226532; x=1727831332;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wFAUhxj4Kr7iOTjExUj5M2PBKlhGdBn7aCFOohPbPc8=;
        b=cLwqGVzOT1Ju2yD7dupPmR8/o4hkjMD1xn8hogmNOjCc/CEk7ZrWdHKlplVuo9fCHa
         sf1yrfkBuJY2KkQVvXa3yhYnjUD/OjKn+BJj+1CsBuvNtq79c39GttouHgj3qe6QQ+ic
         WxnBq739DHYO+Rk5wiwFgrCq0LiTQbxPptClVMHtdSERtzeJuD0PT5L5pdO3Cpg9B1S/
         FuMGStRu98lvhjlkTR/U0Ll/l+mZGfmf96JAHRjRiLoG5YCy+TXy90vj0JtV9246hi5D
         TrcoXr/ff1TgkNNOhy3/S2LReULeuyencJGPjRL3/N0idq7Gv4aVJRfd6d8Z+PiXDPMc
         UkcA==
X-Forwarded-Encrypted: i=1; AJvYcCV0kIyXWT7k+83Bc2pWvNB2BAiVXg+adm7DgtYYIcRAlQDSqImTtpcU2/SExFzEMxbKyW8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiL5S9RuQF95gPEA7dB+zO2cSq5cHjTJZihplrZqQDSGTVzCpH
	F+b844DPtbwDnwm91MOXMqyRDmRFD6Ggix9i5mlHyQlz/NzU+4xYkIKe8+7aouo1JPQfQqpgL9+
	xjqmbvIygGLITmzYSpEzU6dOfLvi5xP2H
X-Google-Smtp-Source: AGHT+IEIjo509tzx3eRQJC8AkaBkgUW0IgYo/PQA10yu/71sYo7VaaTNdbJJ8jeexI8JmtiSLjp03DQBUL6S4sxDKaY=
X-Received: by 2002:a17:907:709:b0:a8d:f04:b19b with SMTP id
 a640c23a62f3a-a93a0341d2cmr77597466b.2.1727226531995; Tue, 24 Sep 2024
 18:08:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240922124951.1946072-1-zhiw@nvidia.com> <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com> <ZvHwzzp2F71W8TAs@pollux.localdomain>
 <20240924164151.GJ9417@nvidia.com> <ZvMZisyZFO888N0E@cassiopeiae> <20240925005319.GP9417@nvidia.com>
In-Reply-To: <20240925005319.GP9417@nvidia.com>
From: Dave Airlie <airlied@gmail.com>
Date: Wed, 25 Sep 2024 11:08:40 +1000
Message-ID: <CAPM=9txix6tO7B+kRtsNXSVPfLGU4vbfga=pt9yqmszecuEbyw@mail.gmail.com>
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Danilo Krummrich <dakr@kernel.org>, Zhi Wang <zhiw@nvidia.com>, kvm@vger.kernel.org, 
	nouveau@lists.freedesktop.org, alex.williamson@redhat.com, 
	kevin.tian@intel.com, daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com, 
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com, 
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 25 Sept 2024 at 10:53, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Tue, Sep 24, 2024 at 09:56:58PM +0200, Danilo Krummrich wrote:
>
> > Currently - and please correct me if I'm wrong - you make it sound to me as if
> > you're not willing to respect the decisions that have been taken by Nouveau and
> > DRM maintainers.
>
> I've never said anything about your work, go do Nova, have fun.
>
> I'm just not agreeing to being forced into taking Rust dependencies in
> VFIO because Nova is participating in the Rust Experiment.
>
> I think the reasonable answer is to accept some code duplication, or
> try to consolidate around a small C core. I understad this is
> different than you may have planned so far for Nova, but all projects
> are subject to community feedback, especially when faced with new
> requirements.
>
> I think this discussion is getting a little overheated, there is lots
> of space here for everyone to do their things. Let's not get too
> excited.

How do you intend to solve the stable ABI problem caused by the GSP firmware?

If you haven't got an answer to that, that is reasonable, you can talk
about VFIO and DRM and who is in charge all you like, but it doesn't
matter.

Fundamentally the problem is the unstable API exposure isn't something
you can build a castle on top of, the nova idea is to use rust to
solve a fundamental problem with the NVIDIA driver design process
forces on us (vfio included), I'm not seeing anything constructive as
to why doing that in C would be worth the investment. Nothing has
changed from when we designed nova, this idea was on the table then,
it has all sorts of problems leaking the unstable ABI that have to be
solved, and when I see a solution for that in C that is maintainable
and doesn't leak like a sieve I might be interested, but you know keep
thinking we are using rust so we can have fun, not because we are
using it to solve maintainability problems caused by an internal
NVIDIA design decision over which we have zero influence.

Dave.

