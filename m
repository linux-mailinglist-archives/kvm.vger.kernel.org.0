Return-Path: <kvm+bounces-52005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AFE86AFF59B
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 02:20:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B45B17DE9C
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 00:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D75E2DF49;
	Thu, 10 Jul 2025 00:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tefMRiOA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D678F66
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 00:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752106829; cv=none; b=qmpOM1frLZl2yvUpyN5oARDzSae0qnYikOTVWnN8zL97pGBmSv/h3gLDG9HMGLprdfrFvEVvoLJTW2DKlzH3bDvCQvH7FHn/hPeRUKbOUq920tsUTXziSayOf2nR+Kptq/Ej5sJyNL6TjXiWRaLKz/XLWuBmM7UFlQbPFGuuba4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752106829; c=relaxed/simple;
	bh=ERDmFUvZl+DHp7ZMqEbyj24/hS2CDCoVaMw2kOxKPhg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cmMnGV8sPiwMHm9aKfbPZ3f2rXXcCYiPvLNs1Y8vA8rT6P3iHjQnZpvX7+2k4WDOPRuCM/7IKGtRPUrXEFRWf5V6grc3y5MD0eHTkto/Js6EFndGfIdV/ohGfxeXiatr+KFxJbco2UAy/JlYxosyeQ/YHe7JfFArarAWpyAlkAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tefMRiOA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so643955a91.2
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 17:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752106827; x=1752711627; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dc+RqRq+W6sCtPNEa/tVWodO3UqzUt3YwAEia9IzCeQ=;
        b=tefMRiOA4fO/BwCVbcaZE9wsbbx/o+8FCcMsj/tmJQ9s9VMVNacYjtXrZ5HGIPdzSS
         g9pz21n1zmgJELne3k+vd+xMxliUf9P8a3JkoRvuJVRwoOjzYjLqGHasQBIrPAtVhHh+
         a4LSsQ7QBeITKzgxCPopgRrK50LbNOXz3JNYVaQbNiTcznni2d6q7cgkegSAcMESmeFN
         NtheSjcKf6jSSdRVsING6/ZDnQECpxZ7yvMSQjJYbC//MYA2nyZL0v9zVK9MDwhYhdb5
         RzKKu5BH1sQcTP04D4X8qfg/fwqOPnaQsU9iuRmSaR5pYK9gUab/EWgVHeaKVuQCjDGt
         HiTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752106827; x=1752711627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dc+RqRq+W6sCtPNEa/tVWodO3UqzUt3YwAEia9IzCeQ=;
        b=OJaJzi6v0oTivmNLyEuoshlk35DS4CV5B8i5WyWz3htJUiDfbkf/SiYJo1M7+xpu5l
         iWu/6YPsZJ6TKT1yyDM+hoXGxR6eWtOZRlc45KFO3mkZ0TnHO/coURGC0MS2NNa0d9wS
         37wc85p0+NZkh6Gdp044aMcryXRps9QmT0ok852K2cnvNq9wjTVTMDVV9jtgPYNP/5CQ
         bcVhKS3tbSh8XTt6lQt1iTHT9rjXs60+5rBBs1YD6qErhQBszWqoM/vhHWB9WqmAzC7p
         4hxTftC63yhKe9tMI4eCPM9JIkYWOuO8P7B5t3SYOJ9FTTWuGpuh4BhDNuqAWH1cS2hL
         yWMg==
X-Gm-Message-State: AOJu0YzS0Q63eSuy+TSQoYoOOYtoiQlDUm7DC/Tk76O8zGFYmTtHsgw+
	TnmKp7VQU5On1o1Pgavx3uVxY9R1P4hTX3DTXhha7dK41ky1lkqo7Y7X61Bcg0xUpNJrMMYORvh
	esR8cDQ==
X-Google-Smtp-Source: AGHT+IG0GxjloovxJcYgMFXWq5yLXp3npn9Ujx5nQOTSIQhv0jOvc/gWF8I+wEWsfveSljef5y7J1NorZPc=
X-Received: from pjtu13.prod.google.com ([2002:a17:90a:c88d:b0:313:2d44:397b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28cb:b0:312:eaea:afa1
 with SMTP id 98e67ed59e1d1-31c3f05249dmr924623a91.29.1752106827053; Wed, 09
 Jul 2025 17:20:27 -0700 (PDT)
Date: Wed, 9 Jul 2025 17:20:25 -0700
In-Reply-To: <20250606235619.1841595-2-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com> <20250606235619.1841595-2-vipinsh@google.com>
Message-ID: <aG8HSc_yj6O69Uu1@google.com>
Subject: Re: [PATCH v2 01/15] KVM: selftest: Create KVM selftest runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Vipin Sharma wrote:
> +    parser.add_argument("--test-files",
> +                        nargs="*",
> +                        default=[],
> +                        help="Test files to run. Provide the space separated test file paths")
> +
> +    parser.add_argument("--test-dirs",
> +                        nargs="*",
> +                        default=[],
> +                        help="Run tests in the given directory and all of its sub directories. Provide the space separated paths to add multiple directories.")

Almost forgot.  My vote would be to make these easier to reference, e.g.

 -t/--testcases
 -d/--dirs

or if folks like the --test-{files,dirs} names, just add the single char shorthand?

