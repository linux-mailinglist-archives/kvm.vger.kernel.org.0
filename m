Return-Path: <kvm+bounces-47161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7928ABE114
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 18:48:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16F578C39E9
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 16:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 214BF2798E1;
	Tue, 20 May 2025 16:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MAL9HM2n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96E821D3F3
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 16:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747759706; cv=none; b=oTjLRAVf81Xsd66P98g0DWuNWquLEwup8BSlvNK3xD3xm94sGEq0bIATpn3T27Fj9EaYv9MmrLIwYmf4esz4SShfNZtA6L88KWqPPtnm48TzUZCRPGgZEWL1yHaxir4v6lGzP0/tT7oq1P/npZTIYNqhBBeEYeLNvriHZ5TiJ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747759706; c=relaxed/simple;
	bh=VKOLyd+fTgXxi0xSU7seE7QvEy9DHjhT9JyUqMZjDXk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Yja5wjFqCsZwdeClRvdAVIF3d9w/0d9S9OaSz5uYTsibzNVb1Td25HhGT+eqqNMcwqczk5EuiNFiE6KYh2K7FeqyNq8ovpOSRPZ04zzo7ker3cCdhPt0eLgzSIRnwTREGNrkn3Ulwf+d1wZdf8fdDUjDXsSceoHb3hx/s9TLG74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MAL9HM2n; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30ed6bd1b4cso3881697a91.0
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 09:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747759704; x=1748364504; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wcl6TqUwD54tFkNVg+Ri/3Cun2a33c9FWRAhj6V56jQ=;
        b=MAL9HM2nG1K00TOdPGQrZMeQdy+sdujtHwdyk8bwp0aI9KalteiNX67XmAIs4Osnnv
         kGHhYbzi+jamSyQHP+eJ6Rzoc/RMGbmcSw3r2BoTrXHVRvI+IWi42BVnVTHEC1/OKRjK
         NW1XeGs2QNp73agFaMJtZ2Qru3L2QYP5n3pR70PevR+yW38HV682xxBaYg8q/dhaTj3L
         uEeFl/I4p7gq/FewAVotkSETtLS87Zho26NA5PfOd36hOuAr73jHQdyz4i6PQGvraYnF
         FzI/zlktwm8WGshF3G0q9ByYjQVvvNsixDomALSjMCxjtR7JdwbksLdrV4OsLid0RcEh
         pbZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747759704; x=1748364504;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wcl6TqUwD54tFkNVg+Ri/3Cun2a33c9FWRAhj6V56jQ=;
        b=EYx49aC6tjAJ3nK97NdU6FdukD+hh4kzKK0c+mSTJ68aFhNR9ufbEe3ELtyBn6OEcr
         moo1Xqp8lU7h/kQ3wiLgtgTpDGk+sT6wjDbD5n8pK5nPcfEjgnjO+kODjT82jls7aO6o
         CrvjMFxxhwJknxzC4DZT//B3UriKn7HmIwNKkXvl456wsOQj7i/YXM+XduAVJ5Llrktn
         A7RxWn1bvQK91NQ9EPO1/iWSNj4H24bfMBAaC7nb3XSqkOO/D7k1mHMzzA6Xmolq7XYq
         uLcEuWu9404eU7i3pKolgCP29mJIF18NjqJv7wRQB0VfLf4Qr9Vaq63d4qoFHuZlCMb2
         an+A==
X-Forwarded-Encrypted: i=1; AJvYcCW+QRzAVs4seghRKSEIuSC+drn//liw8rHGLRq1x1VhqnfzH8Tbh3GU0eibsfYMXxfLFnw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPnWGo5X4A8v6IGMmIaeENhl/8kazmcFQn3ZhRHojZHUbf+VXu
	NKqcUu0ByveWIailo9Wd6nJNBwaJotXZuNZK5fzjGKm+yf5El0+xZZaLWKMHRAhywfkPrpghdhA
	Rvk8u8A==
X-Google-Smtp-Source: AGHT+IHWuapVqe0x+t6XHz6AnLhy46gF3CLB1xUoma8BHmFx0DTfNmTB/vRYZiHtoCJbxgU+GsCHbokk230=
X-Received: from pjbee16.prod.google.com ([2002:a17:90a:fc50:b0:2fa:15aa:4d1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:33c2:b0:2ff:58b8:5c46
 with SMTP id 98e67ed59e1d1-30e830f7b18mr26615931a91.8.1747759704142; Tue, 20
 May 2025 09:48:24 -0700 (PDT)
Date: Tue, 20 May 2025 09:48:06 -0700
In-Reply-To: <20250508184649.2576210-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250508184649.2576210-1-jthoughton@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <174767770635.2666521.3146495513676301743.b4-ty@google.com>
Subject: Re: [PATCH v4 0/7] KVM: selftests: access_tracking_perf_test fixes
 for NUMA balancing and MGLRU
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Yu Zhao <yuzhao@google.com>, 
	David Matlack <dmatlack@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 08 May 2025 18:46:41 +0000, James Houghton wrote:
> This series fixes some issues with access_tracking_perf_test when MGLRU
> or NUMA balancing are in use.
> 
> With MGLRU, touching a page doesn't necessarily clear the Idle flag.
> This has come up in the past, and the recommendation was to use MGLRU
> generation numbers[1], which this series does.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/7] KVM: selftests: Extract guts of THP accessor to standalone sysfs helpers
      https://github.com/kvm-x86/linux/commit/d761c14d902e
[2/7] KVM: selftests: access_tracking_perf_test: Add option to skip the sanity check
      https://github.com/kvm-x86/linux/commit/26dcdfa01c33
[3/7] cgroup: selftests: Move memcontrol specific helpers out of common cgroup_util.c
      https://github.com/kvm-x86/linux/commit/3a7f9e518c6a
[4/7] cgroup: selftests: Move cgroup_util into its own library
      https://github.com/kvm-x86/linux/commit/2c754a84ff16
[5/7] cgroup: selftests: Add API to find root of specific controller
      https://github.com/kvm-x86/linux/commit/38e1dd578142
[6/7] KVM: selftests: Build and link selftests/cgroup/lib into KVM selftests
      https://github.com/kvm-x86/linux/commit/b11fcb51e2b2
[7/7] KVM: selftests: access_tracking_perf_test: Use MGLRU for access tracking
      https://github.com/kvm-x86/linux/commit/d166453ebd29

--
https://github.com/kvm-x86/linux/tree/next

