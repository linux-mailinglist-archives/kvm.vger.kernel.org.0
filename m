Return-Path: <kvm+bounces-59731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D17BCAF67
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 23:44:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B37621A64846
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 21:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67289280A5A;
	Thu,  9 Oct 2025 21:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rGNL5fV8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD8E27A929
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 21:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760046249; cv=none; b=iFg0yjGxWTm7hM6voyKhdGGLjEC/0ah0xZ25N6Ha9bY4PDYamK9Zr0ZBqhwl80AndXGaMRNPYZkZEYWme4zuH9dTRuSgJXdK9f0XIBXDLcPK6Q0xBMsvhh5kxsrHCVUrLIGkwMJTmd2JdpbQgqKHRITb7mBFY/lNVhB4ojSPYK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760046249; c=relaxed/simple;
	bh=QBQZ/PII2nd+INm4UhOt/3mrsSRtqFBJsjEBnrwYuhk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ehU7M2N2VE5Li2kkIEue+zuhgz7asQOtQ9fFRtCws677O+SWjK8vdP1tmH4ILOtxBieugQE1GZtKAAGyrT3NPHR6itgbg+dyQMZSgb45r5q8cT8iga22Cmh1zScRAkG9OelUywDhyCty9Ykehb1DBJnzm2SQw20P1JEyoJUE9Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rGNL5fV8; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-28e8112143fso30312055ad.2
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 14:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760046247; x=1760651047; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BDlvwYPz97Xgh+aeVzA9ej1JjFbOizVBMxc/gGXHNu8=;
        b=rGNL5fV8HGFemdW0DNxhihVeGWcu3KegmIK19ub6iGFTlIxRvf7enkmsVmsp+T7hc6
         SdJcFF7oIF1738G/Cy4mLpAOJifSDFFNnsPA5rGWyv5sK5Yo1b0ap0MsmQiVYsT97xSX
         hRSoYwgthfM63LPNildG0CBls20U506bMy4y3Tp3Cui3VYp+XLVD8KHSKEQ0j7nm6Mws
         MBEIdNnK9CElx2wFiBKsjQmY9rhc2PoJs8blqRm6Xv6MtQq8M6G4lg8KDlO/PDPbqHv0
         /Mv3zwGe9Ft0lCC87gWi9ukJK5UvxfzG9gT88Wzxqde5LRuTwbxCbibt/XkwwCuFd8Bn
         e1TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760046247; x=1760651047;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BDlvwYPz97Xgh+aeVzA9ej1JjFbOizVBMxc/gGXHNu8=;
        b=XuouNb2b+URxdI/XosUaUM4m31q5i+Xr8Enw1mtQj77c3uUzm+sNPYvG0YwM1tSP2s
         s6GBPVh0iS+dijfj9bflVML9h3u7y1ZOkVDgbdxq1GqDlMHjpH6GM8vvxzNLFIQ4s0qa
         xGIdgBj3jUz18OngcJrE7wjK5w7WITNs1wtLA34uPoaqTmeuC8r6u4qs1qOtUD1uBsJ7
         A3arrr9DZw6KA3G7xXmY8ckR1drcRtPQB4Qg6Ag0tZLdY/9mPcCRZzApLUf+6N44sEEB
         kETqRDCJcujUk0RjX56GOrEEUmqyHAM+NxEkDH3WYnpPDiVqk5mJx7+VThAh8EK9AjR5
         8C1w==
X-Forwarded-Encrypted: i=1; AJvYcCUkcsEX3xafl4oZ3melYPGAUOw0Yo9RhNAfsqC2ye0G/RYuxrJfOh78/M7zqD3BlfXZ6nA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHfeqZ+6fMFI3k5Cz7NGAWPVgHiAJILOZmtVNRwu2iWKnYKYE3
	aJkFwj4w0f9VwvjxJFO9JS3deQnnz4yQ+3WUPh18iunwfL1J/oL2v0NLGd4wo6VebvfAuy69nyw
	pFuc2yz2KH2OJpI4CuYLwu30lsg==
X-Google-Smtp-Source: AGHT+IFQjHCm6wm7SAnAbDplPBJVQjkKsdlYJBsa6mhJlfSzzwa6PeU2oGKlk2TkpKhjDbxnR+qB7/kozxjMndhM2A==
X-Received: from plnx24.prod.google.com ([2002:a17:902:8218:b0:24c:af07:f077])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:8cc:b0:267:e3af:ae67 with SMTP id d9443c01a7336-29027238ef6mr108267505ad.14.1760046247397;
 Thu, 09 Oct 2025 14:44:07 -0700 (PDT)
Date: Thu, 09 Oct 2025 14:44:06 -0700
In-Reply-To: <20251007221420.344669-7-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-7-seanjc@google.com>
Message-ID: <diqzqzvbhhsp.fsf@google.com>
Subject: Re: [PATCH v12 06/12] KVM: selftests: Define wrappers for common
 syscalls to assert success
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Add kvm_<sycall> wrappers for munmap(), close(), fallocate(), and
> ftruncate() to cut down on boilerplate code when a sycall is expected
> to succeed, and to make it easier for developers to remember to assert
> success.
>
> Implement and use a macro framework similar to the kernel's SYSCALL_DEFINE
> infrastructure to further cut down on boilerplate code, and to drastically
> reduce the probability of typos as the kernel's syscall definitions can be
> copy+paste almost verbatim.
>
> Provide macros to build the raw <sycall>() wrappers as well, e.g. to
> replace hand-coded wrappers (NUMA) or pure open-coded calls.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>

> ---
>  tools/testing/selftests/kvm/arm64/vgic_irq.c  |  2 +-
>  .../selftests/kvm/include/kvm_syscalls.h      | 81 +++++++++++++++++++
>  .../testing/selftests/kvm/include/kvm_util.h  | 29 +------
>  .../selftests/kvm/kvm_binary_stats_test.c     |  4 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 31 ++-----
>  .../kvm/x86/private_mem_conversions_test.c    |  9 +--
>  6 files changed, 96 insertions(+), 60 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/kvm_syscalls.h
>
> 
> [...snip...]
> 

