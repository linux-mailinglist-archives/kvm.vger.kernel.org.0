Return-Path: <kvm+bounces-40105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6C59A4F339
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 02:06:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10B3D3AAC46
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 01:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25877152E12;
	Wed,  5 Mar 2025 01:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vTBHuufH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0114013B7AE
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 01:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741136748; cv=none; b=RMF42Lz6rj1wQgc+9RfiTFlKPVY7FFjrXxAds62SOF551OuzoZNV0BFW2TypyVgtSLaauVoDz8RAIWSB1JSBbXtuNXumpejPS877Nx+F4I8fP50qnhRR0w42CTWH91hJ7eEru0zVyZMnDGIy1C5zl0DHi1OczG8yAZdj34/ETxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741136748; c=relaxed/simple;
	bh=+MuQymkPvSHXZsgm1lXYQi7Jvrv7xbuEriYb3Z+IedU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DIDkA1oZa/+WAr4D4560edLbmR5NYc0MbqnN30zIQe6fKozMX3zCMp5t2GJ8g0LeFS7WAvt0LYhwswoDmAim35NHB5dugewIETyXTHYqi5z65oMS556gGa3UMbKMehBfNMZIdj5NJ1LYQD6wyHLHIGQVLkUHeToYy9LqtfQCpMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vTBHuufH; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fe870bc003so652514a91.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 17:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741136746; x=1741741546; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NNX6vH12pYMK3VyoT3q3MRD9hVixADS4zVQV9SN8avY=;
        b=vTBHuufHoDkxBi+/JeiCfMhqKI75H46nIcGPMxi+Ku1QURbUPerdG4DoT/1cv+ZY4L
         /oyTOgWmfqBRk8S0ydjbBTBymhWvB3yFsKkNPNoBz4v9/CRJK9q1J2DJ2uAd5EN+m/pp
         NpQC9pJdkriCZMhQftU6WCzpmfw8qiyJ256m6MSfpjPHHFUvSCNCB+nnFeaHDN03hWGo
         ioIfeiunLXCunkFl1g2wb1o1DTSiTRz/SzA75xFj4PdqXtk0aSCqpsXDyeneK0T+iNjv
         /dILGDQjPl+H5p7fTQvpSX183rF/LoUGcK0iFnhOSqDcfA52XhLmgg+Tk/kFb/ZQgekz
         kA0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741136746; x=1741741546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NNX6vH12pYMK3VyoT3q3MRD9hVixADS4zVQV9SN8avY=;
        b=Q7oMwqPy4bhaYyPbrJYfatksIx2rIgYIqbdoMhrpf4dlKK/a/DXmw4H2dt/Z7xkcHk
         c21IqGjqeOKPwDJnzsUxxvSDA6MJNdc+h4ez0qobBh623OGydsjV8MSCnQlohUNAlCSQ
         Ixpgalc4xMTbZ3SDTJ7g+DXnNfXtOGzVuVllOFATT2fugE8lfpNtlsJILx1cJQjHF7hL
         tni+910mjgKr9TZh9p/iCEJ/o5n3a4pHmizgwmzdot2rvZn4TY8HizBseC/U6e7rc3pN
         Zv5+YvYSjVSU2d5AgetV/K/HIX7+/VQuzu9MvStCoC6qmImPprKUdgdkv+gISAwsf83o
         6I/Q==
X-Gm-Message-State: AOJu0Yz+h+paqnBHnKXZxgqxxpUcXagpkLlQ5aPLLFvX54wtj7J7Fwbk
	p6BSgvaAzb3mlKBy+EqNStOmzBQ6ZdsaBETIThY1JaDRRIEx09ctqMaSB7B67lq6bJTjT9DFbUs
	VIQ==
X-Google-Smtp-Source: AGHT+IEQQzqVhfJxOgHOkMbN4KViM02emhSFsqxk/o7BP+xd9QQa4Wlrdd5/eK4O2MhvjeCbxbYdiDp43lE=
X-Received: from pjbph16.prod.google.com ([2002:a17:90b:3bd0:b0:2f9:e05f:187f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5684:b0:2fb:fe21:4841
 with SMTP id 98e67ed59e1d1-2ff33b937f1mr9676522a91.8.1741136746296; Tue, 04
 Mar 2025 17:05:46 -0800 (PST)
Date: Tue,  4 Mar 2025 17:05:14 -0800
In-Reply-To: <20250224174156.2362059-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250224174156.2362059-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174078620474.3857606.12481651463517277322.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Always set mp_state to RUNNABLE on wakeup from HLT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 24 Feb 2025 09:41:56 -0800, Sean Christopherson wrote:
> When emulating HLT and a wake event is already pending, explicitly mark
> the vCPU RUNNABLE (via kvm_set_mp_state()) instead of assuming the vCPU is
> already in the appropriate state.  Barring a KVM bug, it should be
> impossible for the vCPU to be in a non-RUNNABLE state, but there is no
> advantage to relying on that to hold true, and ensuring the vCPU is made
> RUNNABLE avoids non-deterministic behavior with respect to pv_unhalted.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Always set mp_state to RUNNABLE on wakeup from HLT
      https://github.com/kvm-x86/linux/commit/2a289aed3fcd

--
https://github.com/kvm-x86/linux/tree/next

