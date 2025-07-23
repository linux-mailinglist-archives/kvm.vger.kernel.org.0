Return-Path: <kvm+bounces-53316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7713BB0FBD9
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 22:44:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 178F91C8038D
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 20:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B1D5235044;
	Wed, 23 Jul 2025 20:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vnt8ubY+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7748921D3F5
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 20:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753303476; cv=none; b=qQHbaOu4iLXP526FGTpnkZZ3cnl+wwqwMapX875hKoJZYqYiqIynsJ8Anc/6tMWTeFVr/WKcbJIdza6jPwuZTQnORsLnblSede2ZxtSmeoqW34BLv/lOPa41XUJsEIZMbY9hzwW0b2dsoB5bKF1yXOIZZPsMXke6vhYuZDwp7pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753303476; c=relaxed/simple;
	bh=lNNzNnEQaIAibD96dk3AqwFlfgMHlcvq1eJJsHRiKAc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CgDeP5O3Sn2sN1E1ZGAa+sadYzEzEGBxxHcE2MkP6ZpCMb0GIJVAe/G8fmQlHqL+NQzIb2eWVtvMeGJq9YT3smFVeoOxGrWddrzCCqZVxaD0LSZOZXPAkEJ6to1RsRj1fmHkpa1cVYm/tFWnRkD/16obWSxUGSfyVRMup7jvFNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vnt8ubY+; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7492da755a1so217382b3a.1
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 13:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753303474; x=1753908274; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EulshNrvV1py+eBqD1w3s7WQKqFPO8/zm/4h+Qzztr4=;
        b=Vnt8ubY+nJfEZgf9qP3+hOVy0jdnwSH4a4vDDslsvQ+uBexlMt8+QnTmoq79qW84UN
         fUeEldjKc+ghwG+2wDKjiorUi3lCKJdj9/5apQBj4uVy97z0a+ptliUaGB/veV6Rm37j
         98vO1+M/6cMVmm63SSwVQNDbd5qrR0h5Mh/ho5Rg/1Idf9fESMbQ5NLGtcWqnslm29EZ
         w0ct0SIYu59YB2GnOOKPMfu338sgkzthSwl6N90apnSeK+ouh3AjWj8YHpMTcmfJeE46
         ZHXrQo+FflO/D0+R0uZmfc9v0hor7xsvL76vIEhYP+2ptD14RC+S51cFGafIdKAnoAbH
         KMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753303474; x=1753908274;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EulshNrvV1py+eBqD1w3s7WQKqFPO8/zm/4h+Qzztr4=;
        b=cGfMQt/Qab9GsFbWUEnJSYT+n42FGMAFCv4XElU+LIs9Jn0D6jio/LRJjAngewEZTx
         XVSz15NwncNEJ4XU1tZuYEJNCJ012/Pq+jw0x7tHHoFHW6edDoiQUMIse9vsVw4gx2Dn
         mWXP9IIJRsAFi07P01lV1ot1XExyYEMJ/B4Zvkuw7NtkRYV8b6+F+cmZN+kSLy8O6JUx
         WcmDNPlJ9t3eKa+OFf27FDePlUjaNuKwOCb2TnnEg4OFdb3864e1vTICLPhJylZRcgrF
         HlWTtkxDBv80BGTbocO07tUG+ExtnPodZM2gZw5mxJmxrcvkKj6a9JjnUCATFjh6KsHV
         AKXQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7liffQJTFAjInh8gccFjbX4r7Jkl+IEEmYXNOkasq6ZSpxLwn3iitaYSVt7D1EzJplcU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRopjEtgGjxms+U82zswUaWhIq9b3jpOdZo3iOcLDyMpiKeLat
	vNgKyYCkj+ze7EP224bzfOqwGQcEkcsaDbvsBwBQkPdqLKaZhPJF9j/OFC1KB7jR5s08Gv4yALy
	i9K7Wbw==
X-Google-Smtp-Source: AGHT+IEdfsVNIkzfaXrM5ULBiujsbhZiIAIlg4AOA4DGSLcSfkO7jtSls6y2nD57ngnLPPXa+VOtThQnGoo=
X-Received: from pgbfq28.prod.google.com ([2002:a05:6a02:299c:b0:b31:c9e0:b48])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3944:b0:21d:1fbf:c71a
 with SMTP id adf61e73a8af0-23d48fe3845mr7492290637.4.1753303473831; Wed, 23
 Jul 2025 13:44:33 -0700 (PDT)
Date: Wed, 23 Jul 2025 13:44:32 -0700
In-Reply-To: <20250707224720.4016504-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
Message-ID: <aIFJsLFjyngleQ7S@google.com>
Subject: Re: [PATCH v5 0/7] KVM: x86/mmu: Run TDP MMU NX huge page recovery
 under MMU read lock
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 07, 2025, James Houghton wrote:
> David Matlack (1):
>   KVM: selftests: Introduce a selftest to measure execution performance
> 
> James Houghton (3):
>   KVM: x86/mmu: Only grab RCU lock for nx hugepage recovery for TDP MMU
>   KVM: selftests: Provide extra mmap flags in vm_mem_add()
>   KVM: selftests: Add an NX huge pages jitter test
> 
> Vipin Sharma (3):
>   KVM: x86/mmu: Track TDP MMU NX huge pages separately
>   KVM: x86/mmu: Rename kvm_tdp_mmu_zap_sp() to better indicate its
>     purpose
>   KVM: x86/mmu: Recover TDP MMU NX huge pages using MMU read lock

The KVM changes look good, no need for a v5 on that front (I'll do minor fixup
when applying, which will be a few weeks from now, after 6.17-rc1) .  Still
working through the selftests.

