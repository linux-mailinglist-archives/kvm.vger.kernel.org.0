Return-Path: <kvm+bounces-8071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AF3984ACDC
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 04:29:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96A001C22878
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 03:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DCC9745CF;
	Tue,  6 Feb 2024 03:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TOoi/NnZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB8F6E2AD
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 03:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707190176; cv=none; b=tx5MUp1P1Y4xPCefzDhBlBIwK5GSkdrG28qb767aKG3oOjbi/ih3pIwUeyD7cwYvjIsrnr/R0tddq7DD2UGdXC8OdAIsq4pFDcsTOaXcVm1bLQu+cS755iByGVdj3nU1FvFb7dZvzx5ncvfHxhr7RBMz5RvOzIlpkFqYKhzoAWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707190176; c=relaxed/simple;
	bh=K47t6Qn8VX9LZd2vOHxHLV0Ys/CaGLr5+PC1CzGP2TU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tCEHbEVQthxdgQR9x9qQTOEBv7gfai2XCiW/V6n2jjcG87WXDdtAKCcHXfhCe6xac3wDyMepnmaGN8Ej/qoQzfs+3IxshNvF4gV0MrWr34iY5OZ4O9sTd7yHHQiV4oLWB5p87LPPKkCq4pFI8ahKo8BcpIonBniPCoSxAZWL5N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TOoi/NnZ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf216080f5so8480599276.1
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 19:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707190174; x=1707794974; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Tfd5OhfoKoOciQEBeRQDfj0WyGPDWpvLlZKvDtbwOk=;
        b=TOoi/NnZH+pUj3KWcAJqUOwBc0c7UoEkwSEdwf66eoWBdZcAhhPN8swGlvwOqxFDkp
         mzzYCAoip5P/yGQwTlxmz9KRuhSX2trcjL6e4e4f9gPhg44AKcksyuKB6YDPrkQ1k5v7
         hOtGz9Q0VcgWLJRJj+7SMghr9zd1nI3r0BCfx/DCHMVaYsCbx2TnwZTDtK6kGv/UpUSJ
         0chnSZ2EaLKri/8e7zGssw0b7/mLd7kqrAF4j2WtYUEaYr1sp8oLs79qbzDtlrlvdfML
         wXsoENVlptkI5EG6ELh4enZ5KSfX6Z4m/f/89PSHdVcbKk0Ar2OTfA+eIIOteJf5/swi
         DEVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707190174; x=1707794974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Tfd5OhfoKoOciQEBeRQDfj0WyGPDWpvLlZKvDtbwOk=;
        b=Eq1v1k+bZtzlctL+lSYbLtn82wrFbSVwc6szJguSyYToQrxPLpJ0JLsHM+zZbuilHR
         CWFG6vZzMTO4/aForewq7wpJPloRmNc1PyNTPKW8l7og8m/ZU5KqYfeDor561tzjduUA
         JlcHw3lVDFhfNR6DaXgKLT3XhO5mWbr+33+OKuXj2S0nW2XkYvs01xOqZ5fdwoqJpWJn
         l0xz3/TRRopgkxN/E/Jg2wmsCz+r7G4gsGSmbumd628MlwO5ak8VQ8wXD3HoQwHlrF0F
         kGuxGrcUASygDGBYUPiHKd07ifjhN7GOCNuWvHW++S/zysyp0e15p5r03nP5sPsktMHf
         mf6A==
X-Gm-Message-State: AOJu0YxtPRvNNxbjx4MAAHLBuzc0X4NhBwtyil+i8JPoYtimWa282tjq
	qgxjCXPqTgyF5qg54SnBve8+mn2bvjaBed3eohUndhwN8dzt+ETzMPQadp30UYuO06D+7lQYQ+L
	JbQ==
X-Google-Smtp-Source: AGHT+IFGKs7rwk/xOH6e9m0tOkG5KkbLAalcPqOVjHui+Z6DsE6kZ01uHKZEANcR0800iNMQT8Is5W6Gv14=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:160d:b0:dc2:1f34:fac4 with SMTP id
 bw13-20020a056902160d00b00dc21f34fac4mr139109ybb.2.1707190174210; Mon, 05 Feb
 2024 19:29:34 -0800 (PST)
Date: Mon, 5 Feb 2024 19:29:32 -0800
In-Reply-To: <ZRpiXsm7X6BFAU/y@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <ZRZeaP7W5SuereMX@infradead.org>
 <ZRb2CljPvHlUErwM@google.com> <ZRpiXsm7X6BFAU/y@infradead.org>
Message-ID: <ZcGnnIJNPG-nGAND@google.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Stevens <stevensd@chromium.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sun, Oct 01, 2023, Christoph Hellwig wrote:
> On Fri, Sep 29, 2023 at 09:06:34AM -0700, Sean Christopherson wrote:
> > With the cleanups done, playing nice with non-refcounted paged instead of outright
> > rejecting them is a wash in terms of lines of code, complexity, and ongoing
> > maintenance cost.
> 
> I tend to strongly disagree with that, though.  We can't just let these
> non-refcounted pages spread everywhere and instead need to fix their
> usage.

Sorry for the horrifically slow reply.

Is there a middle ground somewhere between allowing this willy nilly, and tainting
the kernel?  I too would love to get the TTM stuff fixed up, but every time I look
at that code I am less and less confident that it will happen anytime soon.  It's
not even clear to me what all code needs to be touched.

In other words, is there a way we can unblock David and friends, while still
providing a forcing function of some kind to motivate/heckle the TTM (or whatever
is making the allocations) to change?

