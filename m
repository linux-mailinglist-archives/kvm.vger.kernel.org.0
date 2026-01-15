Return-Path: <kvm+bounces-68253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DE221D28A3C
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 22:08:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9A97E304A8DF
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 21:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0119F326D4B;
	Thu, 15 Jan 2026 21:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wq7FRGiQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A769322B83
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 21:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768511273; cv=none; b=QWeHLsDABQDsKrqgrblvhY94315bML0SHkkHC9t4gdETHjrcL9a0dKX/VvbJkxP1qts4mDCt9/+RNfoMjSTo6Y/bCdY6z5zSya8HGYub14g6e28yMsJl2++hJV0WU0Jn/f6emk0TwERB0L8uqPgwBqgvYYtH90DrMMdANSR5BSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768511273; c=relaxed/simple;
	bh=RMi5gX9RXeXwJzPuAbDfslFEC8LCMJRoHS6UE4uQmWg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pLMLgKBGoPLK92HGrmqeaupLQ7WztnXdvgPTCLZs5vRxoYwCUB9/oi77bJ5cmOy5lVXeUKqGcN4MdPNOr5IINhZRlaEQGZ2RZPauiiBBuLU7pG0Yrfj74qT2FZygrvhuw+g70ZWSxGa8Ja9JVFIT24XLoyiwG4cntLnk50Hc3+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wq7FRGiQ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29f1450189eso10776925ad.1
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 13:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768511270; x=1769116070; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+q0zy3rt0+W46s/KLmj4uNeydBrbpj2ej0hXrXM1xwo=;
        b=Wq7FRGiQyatW9xDsVCSLJ0LUtQ9DJWswfTjmJwU7bKw4qu+uGxB/RRpYnwueQEYHIS
         X5lC8qNJ5XOQxLebBr4MoL7fCe5Q1dMwsDWPtGUNnEWegVgA5cTecYloMn3dXRp4A3iZ
         jM+FlCjxTxJv1blLxC0QdSUzxifU0OzE5bH40rwz4pEpZt9dmxItxO1Iq7mFWiKIBzIJ
         qfBzYKdAd0O32cBF5M9C1lb5DYb1zLNpLc8WKDkpsWlI18YudjIUwyUV13+rXw6QdGa7
         7Q3bw8n/vCrW4PzDrO3kmC9J8vbK+yG7iMabZskqe0yARcYMC5x3i1NdimKOtPELtCI9
         6POA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768511270; x=1769116070;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+q0zy3rt0+W46s/KLmj4uNeydBrbpj2ej0hXrXM1xwo=;
        b=R3rNs0DhBDCFJvDf7+GUrjs3fNRxj+5mby13sQnN0JYsXrrRV8XXp17j6BnPluZI/C
         HqW79rEsFiSEhST7Fj+V2Aw6TeKzWQcrme0X8LS7G7ILWa1lHNeNyzKqrpBb8St7Qwsv
         hOAt4ZgSQrgKHrJ7Yd0CGwiyefUEUE8tc4FazylNwJuMPZ8/+9qc0s9/pebf2ENcN3S+
         E21kcEPYOHjY8925IKJfsx8+E8s3xnXngWKeAOzRh0vYrmfSq/iDWL6y0PspWbDb3zxD
         5TQv4TzKuCwDhhR7pTOp3K+waFxwgZ8Ozt3/p3a59du3j0+ZSMuI9n8vVpZ9I6HtrhZF
         xk8w==
X-Gm-Message-State: AOJu0Yw1aArAksSwFu9gqO3AnIYXLI99wzgEmXX1VRbNn1j1MTgYK0xb
	YenTvkEdUe9EIuIbE2RB2sA3ax4PeQ2ue0vfk8WBUQ8Jf7ZoB6XbDOaJqSU5A56e52ioGV5dDJF
	Jp9HhFa8c+ClnKkhI5Kp3iwvW8YPcpBzCzAJOuxE6OOjy/PJNdMqncbnxnjzJ5cj1EYyxEFbfxf
	fQRGYBcwqAiyeMQKwLI5uD77/KJqO7fKrf
X-Received: from plch3.prod.google.com ([2002:a17:902:f2c3:b0:2a3:e3b:89b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2c08:b0:2a0:c92e:a378
 with SMTP id d9443c01a7336-2a71756b899mr7431015ad.7.1768511269740; Thu, 15
 Jan 2026 13:07:49 -0800 (PST)
Date: Thu, 15 Jan 2026 13:07:47 -0800
In-Reply-To: <176849903000.720660.2401438098975748028.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260108214622.1084057-1-michael.roth@amd.com> <176849903000.720660.2401438098975748028.b4-ty@google.com>
Message-ID: <aWlXI3F6AyokM23l@google.com>
Subject: Re: [PATCH v3 0/6] KVM: guest_memfd: Rework preparation/population
 flows in prep for in-place conversion
From: Sean Christopherson <seanjc@google.com>
To: kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	vbabka@suse.cz, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	vannapurve@google.com, ackerleytng@google.com, aik@amd.com, 
	ira.weiny@intel.com, yan.y.zhao@intel.com, pankaj.gupta@amd.com, 
	David Hildenbrand <david@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 15, 2026, Sean Christopherson wrote:
> On Thu, 08 Jan 2026 15:46:16 -0600, Michael Roth wrote:
> > This patchset is also available at:
> > 
> >   https://github.com/AMDESE/linux/tree/gmem-populate-rework-v3
> > 
> > and is based on top of kvm/next (0499add8efd7)
> > 
> > 
> > [...]
> 
> Applied to kvm-x86 gmem, with the tweaked logic I suggested.  Thanks!
> 
> [1/6] KVM: SVM: Fix a missing kunmap_local() in sev_gmem_post_populate()
>       https://github.com/kvm-x86/linux/commit/60b590de8b30
> [2/6] KVM: guest_memfd: Remove partial hugepage handling from kvm_gmem_populate()
>       https://github.com/kvm-x86/linux/commit/0726d3e164f1
> [3/6] KVM: guest_memfd: Remove preparation tracking
>       https://github.com/kvm-x86/linux/commit/188349ceb0f0
> [4/6] KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
>       https://github.com/kvm-x86/linux/commit/b2e648758038
> [5/6] KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
>       https://github.com/kvm-x86/linux/commit/894c3cc35b89
> [6/6] KVM: guest_memfd: GUP source pages prior to populating guest memory
>       https://github.com/kvm-x86/linux/commit/ba375af3d04d

New hashes after fixing the IS_ERR() goof:

[1/6] KVM: SVM: Fix a missing kunmap_local() in sev_gmem_post_populate()
      https://github.com/kvm-x86/linux/commit/60b590de8b30
[2/6] KVM: guest_memfd: Remove partial hugepage handling from kvm_gmem_populate()
      https://github.com/kvm-x86/linux/commit/6538b6221cc2
[3/6] KVM: guest_memfd: Remove preparation tracking
      https://github.com/kvm-x86/linux/commit/8622ef05709f
[4/6] KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
      https://github.com/kvm-x86/linux/commit/dcbcc2323c80
[5/6] KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
      https://github.com/kvm-x86/linux/commit/189fd1b059a9
[6/6] KVM: guest_memfd: GUP source pages prior to populating guest memory
      https://github.com/kvm-x86/linux/commit/2a62345b3052

