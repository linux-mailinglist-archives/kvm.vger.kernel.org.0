Return-Path: <kvm+bounces-66407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 08F89CD1776
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 19:52:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5D4B7303369D
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2AFB340285;
	Fri, 19 Dec 2025 18:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UYwA+CCz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6EE33D4E5
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 18:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766169885; cv=none; b=j6V5WmEzUedLYgljqErDPHLhM0LEiYJsaPU98AfSRXTx1JE13XR9k4J9e59TmcTZzZmMzD6rdSZzLdtimBTGkEeSDgKS4v7T1q/gX7XcrshHA1oymIHHLtYsbC7/DGfl909mR+a3cmlrsJPRGR+kHdyunVY4j8Q5KZi4xPzRfRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766169885; c=relaxed/simple;
	bh=T7PgNWe7WIcbNCdJgtEOfb6G1F5bRaZ4cfpWvQtQcEk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fHhzKLnzpHkjqkNYlbKwu61hUcDYXrB7CHRF5jci+wFTPhCdNWp/HwcqQTx+RyUOcjZWSzNh3Yra0vfFHFKttNo4mkFq17EGQKp+ku7nKTTxYXym9CiIjIf0k2GcTl1vmSIr5VSqh9zRT87G8gjF84A9gcgnjK6ml/JHhddIax4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UYwA+CCz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c314af2d4so2079631a91.3
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 10:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766169880; x=1766774680; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dHk4Dje/IrczzVG/OScb1GrSLQR3okXaBQfyidQU1hY=;
        b=UYwA+CCzZHRqCXEvXDRZcIfTUhhegYDS59lkVti/Ft5/kblw72n1YhWrB110I1XxrX
         vGeF4eLwpmFxthGvmO4SohT3za3gsRvnGgfkXYhWptm845vb1oDLwZ+dCwdyB6NAMot7
         0IUgVdD/Tbc5ql59cNO3k/MHPiqZS/2yUDDZM6tZ4Www5w5Ydx4I4ilenyowfVhm0WYq
         Ay9fZPMcunNZ0BmrouPbDeJmwujsJWl/C8tE90iMW/xp0o/X74hAn1WitaBqyLnPen3w
         w7NdpLl4WJmGih6gbHdZx6op15jNOBOcNed6FuXbWi3eBS4eppPUSJ2pSZlKpV601Vyf
         BCaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766169880; x=1766774680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dHk4Dje/IrczzVG/OScb1GrSLQR3okXaBQfyidQU1hY=;
        b=nsnoy4m9ajU1ySiCO1i6z//aiMgGBrOvk22aqCiBJ3KKZLbbz4os9kitZlBpJO7JEQ
         3g2UMwJ64yqI1MhUQY5DwUCQe7Kcqml0H65bZ5NOaawLeQFaXJyX/Pk1Y7nLQopn3iH8
         0m16TroFbKJitlcqT398Yof1iKyrj4tKsbNAPa/al6FxMfImXcwWv+X66wmN0+DpcpWI
         FygwUt/9XrpSauN1J02I3mYZmJFtQqfksTiyUQUVmyCFcE0DrlGjgqaTMc4QcfLVqlAy
         8KFLZWkiyB+b0fpAPI7PiQeK/Ux29kXdz/9rN9dCnyiWlt8BkLZQFSglCERqgxIrEmG5
         8mGw==
X-Forwarded-Encrypted: i=1; AJvYcCXsAJTIoBOhPZX5TUivDl57DDEk0oLuU0jVywTdKwDxuQPQqvAx4YU5tjEzNHY7fzxtH7g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRlmuz7C8yPbM7P/iKJisA4ujwSVhBT4hUQRXGHzBLS7jtLQTd
	e5TZ5qAtgvAK/WmaAe8GGcfWlRTbz/ofgzllEYhwaLu20G/9JJo3QJusEKUu9u60QDow3KkQLFs
	DGAAQFg==
X-Google-Smtp-Source: AGHT+IEBfwdTCyV9lDXSTGBCT9ylQHUMnLiUhvWY+bUIUL9QME+aK59AXivqQnR1K1YNGKzQdT9ZJpe0Dbc=
X-Received: from pjbqe11.prod.google.com ([2002:a17:90b:4f8b:b0:34a:9e02:ffa0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d4b:b0:34c:97ea:e4d
 with SMTP id 98e67ed59e1d1-34e921df30cmr2932381a91.28.1766169880003; Fri, 19
 Dec 2025 10:44:40 -0800 (PST)
Date: Fri, 19 Dec 2025 10:44:38 -0800
In-Reply-To: <CAKiXHKdbs_+yFZGKkKYsHKwAwCZSTzeVdLJXk1amKzm7fGcPNg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAKiXHKdbs_+yFZGKkKYsHKwAwCZSTzeVdLJXk1amKzm7fGcPNg@mail.gmail.com>
Message-ID: <aUWdFmtzhcOKUzIu@google.com>
Subject: Re: Status of "Drop nested support for CPUs without NRIPS" patch
From: Sean Christopherson <seanjc@google.com>
To: Alessandro Ratti <alessandro@0x65c.net>
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sun, Dec 14, 2025, Alessandro Ratti wrote:
> Hi,
> 
> I was investigating the TODO in svm_check_intercept() about advertising
> NRIPS unconditionally, and found an old patch by Sean Christopherson
> (with Maciej S. Szmigiero's sign-off) that simply requires NRIPS for
> nested virtualization rather than trying to emulate it.
> 
> Link: https://lore.kernel.org/kvm/f0302382cf45d7a9527b4aebbfe694bbcfa7aff5.1651440202.git.maciej.szmigiero@oracle.com/
> 
> Is there a reason this approach wasn't taken? Was there pushback on
> dropping support for pre-2009 CPUs, or did it just fall through the
> cracks?

Both Maxim[1] and Maciej lightly objected[2], and in the end dropping support
for CPUs without NRIPS barely moves the needle in terms of complexity. 

[1] https://lore.kernel.org/kvm/2327614a18d60a5e1b0d9d3aed754cccebce3117.camel@redhat.com
[2] https://lore.kernel.org/kvm/656aaf33-8c70-8b06-2cdc-fd2685a1348b@maciej.szmigiero.name

> If the approach is still acceptable, I'd be happy to refresh and test
> the patch.

Let's just leave things as-is for now.  Dealing with NRIPS=0 CPUs was annoying
when fixing the soft-int reinjection issues, but it hasn't meaningfully impacted
maintenance in the ~3 years since (which isn't suprising give how little code is
saved by ripping it out).

Thank you for the offer though!

