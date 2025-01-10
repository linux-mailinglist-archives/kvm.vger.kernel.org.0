Return-Path: <kvm+bounces-34973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 25853A084A6
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 02:16:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E282B188B99C
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 01:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FFD11E1A3B;
	Fri, 10 Jan 2025 01:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s3Ds735x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D5819D07A
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 01:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736471715; cv=none; b=f0Ix5V9VZPfGpsBNkfQz/a/RHO1hRUG50ojjbo/00ZQk8+9v+HtpiDzBtFIRAP+4p9S5xkXOY9lMjqA+cplJV6oY2GPcKd453BppW6TwbEeWPDQ5xGczhIPB71dkAgx3xObrQo9Og1xBQJJnZaZhgBdhIEYKog5IBzdnrtsdmvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736471715; c=relaxed/simple;
	bh=ZSi0AyJ/RHt8qURQBIV0l6kjFCICQc7I9ltkvIwEkCQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DKQFMHevoiEcNoruY7QcK19TM4l+6rNvU8UnYRoyy+51DZA3zGKNp52Wi7pJdFwLdVvTjLVXsavk+hITjXKHbydVbIF9yGb6Tapv6mGEQDzLiFF4060tTefbobu+4mBeVf+Kmd3uPYxvW1oHDQ4ZmmBN8Gb04e0EpGvRpo2t6fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s3Ds735x; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee5616e986so3918443a91.2
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 17:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736471712; x=1737076512; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7VwFFFatQRWj4k7jYl4E+a9CzYdFY2Mg+JsqSac4RoA=;
        b=s3Ds735xEiu1vo0EMSbqW0Uw0ayG3MyjTajIZZ3ztn3ZHMrH8Klpoz+Xb9irKJNmia
         80fGW3S2+k/pnDJw7OdLAs8Ea/WN1ZfQ/nO46lUC+wXlKNkb0DFNbZH4l2czxg5hhY7M
         xBksseA+TERp1F1ByeNtEhAq6pdtSKYgRY2tX86RgEpBW1SxhMkc6Mh+DJPw9wxNyY35
         7q2ni+e4NsEyM/4hofAuzERuGU0McCyd4PqqbHOZk1d9OznGN5gl7y+MVUA15bKBc4U0
         9twFCoTXv/Njgq8Xqz+YyPHGSnBFcSxYrSD7/4IVWcM3HmWbjErI22toRmV6nppkEQAS
         b6jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736471712; x=1737076512;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7VwFFFatQRWj4k7jYl4E+a9CzYdFY2Mg+JsqSac4RoA=;
        b=vOQtfjHVbqozNUKUj1n6QEcniFUJgg/Z02ZjSyML9q5Oy0s3d3iUAR3cSXFjdlJVtv
         QJxPqCS42j7NMd/UvDQkoDW9Cq/zTj8rNmrYtllvS35gSB0JVRn8n0l6uOFq6QZgBp+H
         FwOqIh7tVwwiQFS+Zw+PSugfhOjY+L4YNUEx6l21VgKGiCZk4s9I51A3nkQfZ8IpnhRW
         zcwu9IWLcf6IMgdmVzcJASLpgCJx7j9d3YDvH414Ez+sIrSD4XTNRHG50qUr1dCDOzZ2
         /116XO3zQJBPO8Q9PTbfhD7Xat6g8OHDQOcwRDs41R9s/fAyGHq+f27vgyWJ6bXhHeZ+
         prjw==
X-Forwarded-Encrypted: i=1; AJvYcCUhJwJuBaYT+JCvdUvuR9vSLV9vXfN95RM6WvJNcbHpjlR1jXQ+B5C/Ze0LbsYJ8lARrCE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt1xuuBzAN+pNdv5pSvMFerUrcn7HJkB6CBWDnhZUphWBoFYAG
	pZ/W6RvhxIcZheSVRlIjnOFmHJ/QCCHSw3Z9+1LZboF3NGRobBD8gimoag4TpbkHK5JKauBvdcN
	qwA==
X-Google-Smtp-Source: AGHT+IHAhOQ1hNL+2ODVngM4YtoUZlDh3MWUPi4xjwAS/ekbAexZ0ECdQPoeafSTa9dwqEUdAQpSzA4aRUA=
X-Received: from pfiu8.prod.google.com ([2002:a05:6a00:1248:b0:72d:35ed:213f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:e83:b0:725:b7dd:e668
 with SMTP id d2e1a72fcca58-72d2201700cmr11665849b3a.17.1736471711800; Thu, 09
 Jan 2025 17:15:11 -0800 (PST)
Date: Thu, 9 Jan 2025 17:15:04 -0800
In-Reply-To: <173645122896.885867.13450184481916964756.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241220013906.3518334-1-seanjc@google.com> <173645122896.885867.13450184481916964756.b4-ty@google.com>
Message-ID: <Z4B0mJOwH6xGjuZ6@google.com>
Subject: Re: [PATCH 0/8] KVM: selftests: Binary stats fixes and infra updates
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 09, 2025, Sean Christopherson wrote:
> On Thu, 19 Dec 2024 17:38:58 -0800, Sean Christopherson wrote:
> > Fix a handful of bugs in the binary stats infrastructure, expand support
> > to vCPU-scoped stats, enumerate all KVM stats in selftests, and use the
> > enumerated stats to assert at compile-time that {vm,vcpu}_get_stat() is
> > getting a stat that actually exists.
> > 
> > Most of the bugs are benign, and AFAICT, none actually cause problems in
> > the current code base.  The worst of the bugs is lack of validation that
> > the requested stat actually exists, which is quite annoying if someone
> > fat fingers a stat name, tries to get a vCPU stat on a VM FD, etc.
> > 
> > [...]
> 
> Applied 1-7 to kvm-x86 selftests (x86 wants to build tests on the vCPU-scoped
> stats infrastructure).  
> 
> I'll hold off on the compile-time assertions stuff until there's consensus that
> we want to go that route for all architectures (not at all urgent).
> 
> [1/8] KVM: selftests: Fix mostly theoretical leak of VM's binary stats FD
>       https://github.com/kvm-x86/linux/commit/b68ec5b6869f
> [2/8] KVM: selftests: Close VM's binary stats FD when releasing VM
>       https://github.com/kvm-x86/linux/commit/a59768d6cb64
> [3/8] KVM: selftests: Assert that __vm_get_stat() actually finds a stat
>       https://github.com/kvm-x86/linux/commit/52ef723593fe
> [4/8] KVM: selftests: Macrofy vm_get_stat() to auto-generate stat name string
>       https://github.com/kvm-x86/linux/commit/7884da344973
> [5/8] KVM: selftests: Add struct and helpers to wrap binary stats cache
>       https://github.com/kvm-x86/linux/commit/384544c026f6
> [6/8] KVM: selftests: Get VM's binary stats FD when opening VM
>       https://github.com/kvm-x86/linux/commit/6d22ccb1c309
> [7/8] KVM: selftests: Add infrastructure for getting vCPU binary stats
>       https://github.com/kvm-x86/linux/commit/60d432517838

Argh, apparently I only tested this series on platforms with high RLIMIT_NOFILE
values.  Creating the stats fd for all vCPUs causes kvm_create_max_vcpus to fail
on some of my systems due to doubling the number of fds needed.

One option would be to figure out a clean way to avoid creating the stats fds
for barebones VMs, but x86's recalc_apic_map_test also fails.  That test creates
512 (max "supported" by selftests) using vm_create_with_vcpus().

Doubling the rlimit from 1024+100 to 2048+100 for the max test doesn't seem insane,
so my plan is to move the rlimit twiddling into common code, and then account for
the vCPU stats fds.

I'll drop the above commits and post a v2.

