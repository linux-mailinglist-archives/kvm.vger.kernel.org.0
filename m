Return-Path: <kvm+bounces-53041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD02BB0CD46
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 00:26:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E388542963
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 22:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 416A3242925;
	Mon, 21 Jul 2025 22:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cmt1uubr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E9B23C8D3
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 22:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753136770; cv=none; b=QRXzJH/VhJt81BQKg7OgA8QU1XFcSZb5VIzOlAVMlzXDzWansdYrehYgYzmz2lvADFLM18dlV3TypO1Bb+Ei/Rx/hyO8w7669J0/Sf5NupsQJRTkmop6nqnDnHMpSvLIYN4syHZ4gsH3F6K0YrXXFrHUtkjNfNz/QDVQnTsYDZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753136770; c=relaxed/simple;
	bh=IyvP8QHlTa2QpWvqlFYR9SEvyFxbF/ATcjcrXYbVJ2I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qTsLXStQQ7FdFsoVFftXSLyEFFvIdkhBRF555xAvn8zQtdzGaJ238pTgQ38HRrYdNvCT4FMOds2JUbNYIUP5Fakdwp3RWdr2YuJKp478YBvtvlHKZcwYDDG6u7PbQz55LXvxuri3FlBzWuMrrXVrArNvsE48fGWWmgCOV/Avfw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cmt1uubr; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b38ec062983so3228452a12.3
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 15:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753136768; x=1753741568; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LL2cGKuHaaPjxufWOQkCjzE9tdmYpzd1lzvFg8IW6fY=;
        b=Cmt1uubrOI27eeR6IElR2/K8H5Ao8oLkbwmkpeqXg0yb/32x9R8xWovsN7eo4mtTLE
         4zSlf7BIESO3R3eOiyQrwraWES4zD2vS515QGrwV20KsZuxjB13ywDIxjnsRLGooapmj
         mfGBHdRmtA7WcLk/YsvZuFfqKqbpdItENgw6YQuuznM2/rRYL+qR9TSfUSsjd/3E83TC
         Ue3/Ui4A+rbt+2k8fS2EypynZhKNTOKfTSJBJCG1IcFDV8+zIzZcy4zL8c3+8fVrV4lj
         dOOR35+2o4sq7jEC1Gh2eLRt3t9SlmMgB5oy+Or09UtKW1OUiY608+dUk7Yu7jO2TXP0
         biDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753136768; x=1753741568;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LL2cGKuHaaPjxufWOQkCjzE9tdmYpzd1lzvFg8IW6fY=;
        b=iX5Ila2GEB07RnyI4EC+cnbf26WCSGpTNef2syaCfyYpTcpKKzXWmy26HTXVa2V6D7
         toKnUlLEiGdVs/5s0UqOQMEJrpk1PCGH3M8Nwq7MB8mqJ+rcUWjQ3/WtXJOwmsxWCpUV
         b9+jKiQfCRQGn/SFQQQn1nCes34gkl39+l4leKuouBu7g3zGyfnIhPO3Ae+/guJS4P2o
         Skm4KtLyOzJT3cuA4H+zknhVO80xyG39NUyaJbNtWHFQccPnvhvSKZNuyXUy2NHGCv9T
         UUPhM48ZMrIGTBCy0aODn+t4kIR7POV3DOjqAWn3dZz64MZg4lDGyktwBnbfDrW5R19K
         /iPA==
X-Gm-Message-State: AOJu0YzfrmYvRaRx0i6YPjWVvNhglGh1Ucz+cH/K5gnfeSnx9vBl57IN
	zbQ/BzcDME8YFFQCJUfBGlPbpDDv1zvHaQdsWl/xyf50mo7wnqFC6Cf3I7e+VZhtLRlnQvuyCUP
	onlFaMw==
X-Google-Smtp-Source: AGHT+IFOEfi1TplIejvNZRr/1MbPEFH8m6+GDazbtftWiE+uc1xJ4NSswHFa4ynpaZqg1Tm3n/YWoEjzkPQ=
X-Received: from pjwx13.prod.google.com ([2002:a17:90a:c2cd:b0:313:230:89ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:50ce:b0:313:5d2f:54fc
 with SMTP id 98e67ed59e1d1-31cc25429b9mr22489997a91.10.1753136768428; Mon, 21
 Jul 2025 15:26:08 -0700 (PDT)
Date: Mon, 21 Jul 2025 15:26:07 -0700
In-Reply-To: <7t5qpdpc7cvkyvgj7i2fes56pvpfvrqcpbbdqqrhu3vgqgtjw2@6mpuc4ljmiey>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1740036492.git.naveen@kernel.org> <330d10700c1172982bcb7947a37c0351f7b50958.1740036492.git.naveen@kernel.org>
 <aFngeQ5x6QiP7SsK@google.com> <6dl4vsf3k7qhx2aunc5vdhvtxpnwqp45lilpdsp4jksxtgdu6t@kubfenz4bdey>
 <aHpZD6sKamnPv9BG@google.com> <7t5qpdpc7cvkyvgj7i2fes56pvpfvrqcpbbdqqrhu3vgqgtjw2@6mpuc4ljmiey>
Message-ID: <aH6-f1xOMU7dQLsX@google.com>
Subject: Re: [PATCH v3 1/2] KVM: SVM: Increase X2AVIC limit to 4096 vcpus
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 21, 2025, Naveen N Rao wrote:
> On Fri, Jul 18, 2025 at 07:24:15AM -0700, Sean Christopherson wrote:
> > If there wasn't already an "x2AVIC enabled" print, I would probably lean toward
> > doing nothing.  But since pr_info("x2AVIC enabled\n") already exists, and has
> > plently of free space for adding extra information, there's basically zero downside
> > to printing out the number of supported CPUs.  And it's not just a binary yes/no,
> > e.g. I would wager most people couldn't state the number of vCPUs supported by
> > the "old" x2AVIC.
> 
> Ok, this is what I have now. Let me know if you prefer different 
> wording:
> 
> 	/* AVIC is a prerequisite for x2AVIC. */
>         x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
> -       if (x2avic_enabled)
> -               pr_info("x2AVIC enabled\n");
> +       if (x2avic_enabled) {
> +               if (cpu_feature_enabled(X86_FEATURE_X2AVIC_EXT))
> +                       x2avic_max_physical_id = X2AVIC_4K_MAX_PHYSICAL_ID;

I actually like the approach you initially posted, where KVM explicitly sets
x2avic_max_physical_id for both paths.  KVM could obviously rely on global
initialization to set X2AVIC_MAX_PHYSICAL_ID, but it's not like this code is
performance critical, and have all paths in one place makes it easy to understand
what the "default" value is.

		if (cpu_feature_enabled(X86_FEATURE_X2AVIC_EXT))
			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID_4K;
		else
			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID;

> +               pr_info("x2AVIC enabled (upto %lld vCPUs)\n", x2avic_max_physical_id + 1);

Maybe s/upto/max?

> +       }
> 
> 
> - Naveen

