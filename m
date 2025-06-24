Return-Path: <kvm+bounces-50537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 487A5AE6FC5
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2F9218870F0
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC6792E8889;
	Tue, 24 Jun 2025 19:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZKQGWjrj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DAC2E6D23
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750793810; cv=none; b=qxxQa/Tfh38CsCb8GFLZ9sIFMT+GJkt4LyIImoSDJM5Y0sixFeP1x5hO6a849tf3Z12mLEDelJ6iiLpA9NvGzQHGvMqZuj38aXY13v/iMNQBl9/T1IEOouwlgj00PrjKzGLJ1pIYe9ZtvZZi2kB3k4FiqNETwmsqdkFyoDaOr4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750793810; c=relaxed/simple;
	bh=VcRy3+qgDcj5jlMA8aspokLMV/NW3nglxYgdE7+pfKo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ePqvx6g4mJZ4eVf8l8Z1uA9LgfqfMqymNj4KXB7c+jINdb1qEGN39yIH7QxPpCYSlCpddg0KfzgAs85ed8juqW/XntnZLFC3UKZS2/bIuYBKGEDKi8ykf058owI1dj9gvQbNdYA3u2hIpbBYeAUkoKd8KbfeUd70XkIueP+0FKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZKQGWjrj; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3139c0001b5so4970593a91.2
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750793808; x=1751398608; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gIPN5QE4nVCmnvt/bgGiImfzJSC2l0VEKxxjN+qLd8w=;
        b=ZKQGWjrj4jTevWIsqtuPEpDC37aklfxAgR/shXqL7leA+60xxBY7EO+Xm5WEoQx/sv
         QCiswwFKE/6+KKup1BihLJ+krywKOeEi2QdRBqKxc+6Ha0xeZ2mh94dyC1J2nYOEogoi
         a3kq9NN24raWmTCjvaf4agdA1EBIJTNHzQPxse8jUB5WTZ9F+5PAkn40qBQSbiMPrvwi
         YaxtIXZ7itFJhOoStq1+B489jtkWOuzqTrE5HDP+xDjYmqEfzRnkRc2q//QUdgpMDB33
         3AprZPf4daHMlcYSa1r42i+mpSBq3P9dmw7g5hPOo2T30khCE69bt1DRfNjlXaTi/tb4
         SK5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750793808; x=1751398608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gIPN5QE4nVCmnvt/bgGiImfzJSC2l0VEKxxjN+qLd8w=;
        b=uWW0GrbykVjZeb/HanZEBhZHjtRrtwxAoltYjYIJyr3hfdddHh/4ks+vGX9aohcPku
         pkICrXyCqTeBXu8AwIYlgkkjOAhTE+UlyUSwe2JXls/tZ3BsrHUDCRC+EZO94UE6W7jI
         I/bQECW30l5z6A01TACM83hn3s4xtGMuJhXK/CUKSv6TGQvyykZXOiwtnc2Hu/9btcrw
         gs243tHmIDb5Uy2TL7bbF7QGchIQH0cHiUbb0WnUZl98gWfePkYxTojum62j/Q08r/eF
         SwumpNGtu6MAs3Ss4qF0e9SxnevM9sxAZya1HCmVia1OAEgLDA5WgKafTUlv2vnfNl+L
         rxiQ==
X-Gm-Message-State: AOJu0YzeNfNg1V6g8q2hNjLjVfxIopmw4C6Pso62u6a+XQvB2k4xiI3e
	kCA9qNJj9M9tkd4SiNCWJ2dFN5evhhE1+407IZCjzLNW6sh6FGrmepgQBJk+7iph9o5gQ/wheJt
	OaO9PHg==
X-Google-Smtp-Source: AGHT+IE3K+R02gXUOmvPAyWInTm2IKLFLQlBc/V2I8P60s8vbzR56VHCiRZI3O+ibJmWDR79ts2sUApeIes=
X-Received: from pjboj4.prod.google.com ([2002:a17:90b:4d84:b0:315:b7f8:7ff])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c81:b0:311:e8cc:4264
 with SMTP id 98e67ed59e1d1-315f2619698mr180503a91.12.1750793807795; Tue, 24
 Jun 2025 12:36:47 -0700 (PDT)
Date: Tue, 24 Jun 2025 12:36:24 -0700
In-Reply-To: <20250516213540.2546077-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516213540.2546077-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <175079222519.514976.885736874981212717.b4-ty@google.com>
Subject: Re: [PATCH v3 0/6] KVM: Dirty ring fixes and cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	James Houghton <jthoughton@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 16 May 2025 14:35:34 -0700, Sean Christopherson wrote:
> Fix issues with dirty ring harvesting where KVM doesn't bound the processing
> of entries in any way, which allows userspace to keep KVM in a tight loop
> indefinitely.
> 
> E.g.
> 
>         struct kvm_dirty_gfn *dirty_gfns = vcpu_map_dirty_ring(vcpu);
> 
> [...]

Applied to kvm-x86 dirty_ring, thanks!

[1/6] KVM: Bound the number of dirty ring entries in a single reset at INT_MAX
      https://github.com/kvm-x86/linux/commit/530a8ba71b4c
[2/6] KVM: Bail from the dirty ring reset flow if a signal is pending
      https://github.com/kvm-x86/linux/commit/49005a2a3d2a
[3/6] KVM: Conditionally reschedule when resetting the dirty ring
      https://github.com/kvm-x86/linux/commit/1333c35c4eea
[4/6] KVM: Check for empty mask of harvested dirty ring entries in caller
      https://github.com/kvm-x86/linux/commit/ee188dea1677
[5/6] KVM: Use mask of harvested dirty ring entries to coalesce dirty ring resets
      https://github.com/kvm-x86/linux/commit/e46ad851150f
[6/6] KVM: Assert that slots_lock is held when resetting per-vCPU dirty rings
      https://github.com/kvm-x86/linux/commit/614fb9d1479b

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

