Return-Path: <kvm+bounces-50575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39800AE7167
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 23:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DA6717BAAF
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC37B259CB5;
	Tue, 24 Jun 2025 21:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="15V4Ho6V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6B62571AD
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 21:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750799543; cv=none; b=JEJVGMC2qXg5KvTfropBv1jlT7hDJST7lQx+L8hD40TJo8P3SFtcJXlzlY+aioODAleyaf8dayudOnkp8qbomJ1v5Cdkt2mTCXfvk33DO+r80g36xCpM3U3trXuJK7688wNCnMTAY9qj91447tu212gVXfuRk1LSzeMIFIoAZMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750799543; c=relaxed/simple;
	bh=tKgZTGJic7DDJClRHNSXNJlldhKESGMCLrDVwPwAWAM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fbpy5ZDckFQGXeNF4kg+tIMjdfGbytayPBohQGAkFeC6szxdcp1QGzZ9LYQaAd/rsa2hYqN5FajwU2pxN1Fkv8eG4mVu6jgIA5BfI9a9JkmIS/a/03mPeilohY6OkhzlZKaU78cqE31rvuBRsgOVHIoHGc4lflhcw/ksaM7wx30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=15V4Ho6V; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313d6d671ffso859652a91.2
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 14:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750799541; x=1751404341; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LTblawYKlK658c7iR1xjS+JeBZm0UmD7xykgCWSyAGo=;
        b=15V4Ho6VsiK1FEDI0GyAoR0N+bUjmjVOn9coY6HLbu6GqTsSIP3lRAHIjzpDMAMGbm
         dZxHtHr8cuu3eePi2fZfYtJ5d5YVhbd1qA4y3dg9q5AKTQUpK8ReaWd6DrG8AzGEYeV9
         NXItbnsNY+Y6VZKHeBRIqNAVTVpw+Rk+wocOLvA0fgemgJRMUxrzHzASWj+VeN6ldMVK
         mRieGDZZUkqH2fIGI4woiQaPVG/9dE1xErTvBuJDTxNCNsEDznAneRywvg5yBABXIk4m
         ZBP3z2F9XKx7kpUwPfxUYAi/j3GfnL5Iif32jWizGjypKXHHb7MUt59tyN843F17sspN
         xGYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750799541; x=1751404341;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LTblawYKlK658c7iR1xjS+JeBZm0UmD7xykgCWSyAGo=;
        b=WrOmxrOfR5+fpXJFoOaZQGWLOUtK1AzaFOJWwwDDYwep4vqNBsLTIrZiO0HBEOMbW1
         RURHp8td3IfBkfL4LLTzJNtP4Pngn/R41iNgC+1Ed+IbVsTmYZuhngFehnNgpGecP+4D
         ZrZ3uGF27812aTh0bo8nFJiZ4xJ/qIDfh00Udbocy+0ErdOndepe5xO49av7w491O+PK
         7T2s+/anZ4IdjLFaJ7z5sX8wd6D/J7pKkKKncD370jlv6tOOG3eZQG/PvOEDmaDI+XNa
         xyU/Wa4WW/B4jRid2tjHYIOqu7zs5k58CO/TfcbC81Qy90MS39eadtHBCStkvvmPqu5N
         uf8A==
X-Gm-Message-State: AOJu0YzN/Fs8+MzpLutDUoVdYZKj1JRiH89Tt6eNI3ajyCRwxf4jXSg/
	FY89nR0nh6yOTuYnFWJlQ9R6tAxjwMHxaTate3oKigyQ1KZ8Tg4MA+QNWB9Wq/NiSBaQWfLfjTG
	8JdPn5A==
X-Google-Smtp-Source: AGHT+IG3IEr0w/PsVAotqZXpqEv9ETF+5RNDU0VZntM9BNZHedOz9L53IuqKEuQ+lV0drKkHvATIIHQsaZ0=
X-Received: from pjbpt7.prod.google.com ([2002:a17:90b:3d07:b0:312:4274:c4ce])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51c3:b0:301:9f62:a944
 with SMTP id 98e67ed59e1d1-315f26b8549mr576978a91.33.1750799540905; Tue, 24
 Jun 2025 14:12:20 -0700 (PDT)
Date: Tue, 24 Jun 2025 14:12:19 -0700
In-Reply-To: <175079268655.517596.11530108670607154610.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523001138.3182794-1-seanjc@google.com> <175079268655.517596.11530108670607154610.b4-ty@google.com>
Message-ID: <aFsUs7-cRCWJ_xc3@google.com>
Subject: Re: [PATCH v4 0/4] KVM: x86: Dynamically allocate hashed page list
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 24, 2025, Sean Christopherson wrote:
> On Thu, 22 May 2025 17:11:34 -0700, Sean Christopherson wrote:
> > Allocate the hashed list of shadow pages dynamically (separate from
> > struct kvm), and on-demand.  The hashed list is 32KiB, i.e. absolutely
> > belongs in a separate allocation, and is worth skipping if KVM isn't
> > shadowing guest PTEs for the VM.
> > 
> > I double checked that padding kvm_arch with a 4KiB array trips the assert,
> > but padding with 2KiB does not.  So knock on wood, I finally got the assert
> > right.  Maybe.
> > 
> > [...]
> 
> Applied to kvm-x86 mmu, thanks!
> 
> [1/4] KVM: TDX: Move TDX hardware setup from main.c to tdx.c
>       https://github.com/kvm-x86/linux/commit/1f287a4e7b90
> [2/4] KVM: x86/mmu: Dynamically allocate shadow MMU's hashed page list
>       https://github.com/kvm-x86/linux/commit/02c6bea57d0d
> [3/4] KVM: x86: Use kvzalloc() to allocate VM struct
>       https://github.com/kvm-x86/linux/commit/97ad7dd0e53d
> [4/4] KVM: x86/mmu: Defer allocation of shadow MMU's hashed page list
>       https://github.com/kvm-x86/linux/commit/59ce4bd2996b

New hashes after a force push to fixup the typeof() oddity:

[1/4] KVM: TDX: Move TDX hardware setup from main.c to tdx.c
      https://github.com/kvm-x86/linux/commit/1f287a4e7b90
[2/4] KVM: x86/mmu: Dynamically allocate shadow MMU's hashed page list
      https://github.com/kvm-x86/linux/commit/039ef33e2f93
[3/4] KVM: x86: Use kvzalloc() to allocate VM struct
      https://github.com/kvm-x86/linux/commit/ac777fbf064f
[4/4] KVM: x86/mmu: Defer allocation of shadow MMU's hashed page list
      https://github.com/kvm-x86/linux/commit/9c4fe6d1509b

