Return-Path: <kvm+bounces-18228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 441E38D2254
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 19:20:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7542F1C22D8D
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 17:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA51174ECD;
	Tue, 28 May 2024 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fP7mfKkd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFA5172791
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 17:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716916844; cv=none; b=AkS7AAwG5mrZlBAXxgKQdahjQtWhn1LOaEA5rxPpym/LWgvUCdRO2cgI7SdBzXsEJYojDPRgaW8ALpg2fggisgB4smmqFINHQl836q95ehh4GPG6bw9FP9xEscH38mSyEXaunMInKTjzdUp1WMhPO60RKPEJay5NqxLEAZI8WNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716916844; c=relaxed/simple;
	bh=dDYC97Td061WUI8ezos3IQIWa3Zqeedt1t0yL+iUhF0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mVjK1BlRPSHYrjOmvj/3+JTEkI271nwPUD5CI8j920oiHwQT/kZbqSALAPwU30h3LWyEBJZL5YAgMl8PysfYOF59Uq+1l7Ce90Mx5Q4zH7o690zFXHfvbvkRTvIdPxLLgsv7yHBUJ5WDxjMjCaA7gZmpKhVmYQXw+IqDMA+Ttf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fP7mfKkd; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62a1e9807c0so367167b3.0
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 10:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716916842; x=1717521642; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zdjf+Oso2zYeF2PeKJeu2LDUmFwWwvMWQeLwzdtyzdA=;
        b=fP7mfKkd3Tko2HIBIhB1hqx+ilT/lqmdKt4Fu++1hZ2tVIGnpHiifbIztFvuEy92AV
         7PUCWs+y3N4oqd97Qqf13KlJ/sll5zAxxCtApI0rLpgsnOHkEOUj/wsIYmUtT/DC7NR4
         5wGJL6rv9B+elFUdJEtzSI8xGraWr5P5VqQz0zT6brrM4wGlLPoiSjZursJ8BBohHgdr
         vEn1sQTk0aomHjWh3QKLPEdpM3yrh6dc5lFk3J40ZXAs0abAORWbktjEyU6YS4/nfbDD
         0aRjsQ8pOY5K6TPA2H0OlGpsyrYKn7DpmqksQ5V7lcWJufqWQiFkIFX8M2jcN2pbgkhS
         lDdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716916842; x=1717521642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zdjf+Oso2zYeF2PeKJeu2LDUmFwWwvMWQeLwzdtyzdA=;
        b=jf0bWi26oF0WYdlzfOa82QXMEImW5mWQqX0en/F2b253F7of9qASaD8xXknX9Iwmrb
         RWonKR/fSXsV/CNg06lUBzM/rB8Usub/jxOkAr7OOWY6WiKU1ijFDKW4T5FCxeq2dX7Y
         Erqu9h7qDtO5AQkoaopIeN+rCcNSp1oPj59v7t74nna5nq5gh11TIdQkOK22PpjQspON
         /2nV9AaN2ZMMf2CQ4YBQ4LqLye4QlCdyCvltZNpGOyRx5a0fxS1sZfyRoZhdlSvDrLUk
         hxITCAOvcPNShPUU/wxsRNjhxTe9qKX3FsEUMzbmGUsTUJxpacZp+yOxX9lhvLNv1QJO
         Tk1A==
X-Gm-Message-State: AOJu0YzQlEAcYvmeluR/mZpDpnLEY193Md0E64XZc6eNxzbOa4wcLigH
	5MRzwtsQwS3c1FbKOJ9cYp2Wr41whmxmJRqpvMa8cCM0b2NnzkLE+TVsNd6+/5BkSIgcyOSkO+z
	f1Q==
X-Google-Smtp-Source: AGHT+IGyObRR3eB9tl2o8vJjV9M0MJA3mbgnFb0Hxd6EwyJVem/xg2La75HbR3IlKxgE33PcRAEX5whkViI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:450c:b0:618:5009:cb71 with SMTP id
 00721157ae682-62a07647b4amr34639717b3.5.1716916842572; Tue, 28 May 2024
 10:20:42 -0700 (PDT)
Date: Tue, 28 May 2024 10:20:41 -0700
In-Reply-To: <bug-218739-28872-qwpXtkuBFd@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-218739-28872@https.bugzilla.kernel.org/> <bug-218739-28872-qwpXtkuBFd@https.bugzilla.kernel.org/>
Message-ID: <ZlYSaSsQ_7y9J6r0@google.com>
Subject: Re: [Bug 218739] pmu_counters_test kvm-selftest fails with (count != NUM_INSNS_RETIRED)
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, May 27, 2024, bugzilla-daemon@kernel.org wrote:
> I also see this test fail sometimes (once per hour or so of continuous running)
>  and in my case it fails because 'count != 0' assert on
> INTEL_ARCH_LLC_MISSES_INDEX event and only for this event.
> 
> The reason is IMHO, is that it is possible  to have 0 LLC misses if the cache
> is large enough and code was run for enough iterations.

The test does CLFUSH{,OPT} on its future code sequence after enabling the counter.
In theory, that's should guarantee an LLC Miss.

Hmm, but this SDM blurb about speculative loads makes me think past me was wrong.

  (that is, data can be speculatively loaded into a cache line just before, during,
   or after the execution of a CLFLUSH instruction that references the cache line).

