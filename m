Return-Path: <kvm+bounces-25609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AB54966D71
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:23:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC5EE2830A5
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A8431CF8B;
	Sat, 31 Aug 2024 00:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W9t+a01r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343F91BF2A
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063687; cv=none; b=MnN5KP90p4Sm3IdMn0ETKaqWanx104yT2yca4NFvZQgAOgbkXrAWzwggxZES5DMKBY7F3MZdlSdPMbNYLFK1BHayri2G4dKqMamEie0o+/StRcCwouvHbXLrUIk4lI9ePakDMZQGibyHkFCIoEyKRjs+UAY5MGMAZ3zR+qjLkGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063687; c=relaxed/simple;
	bh=x2GfjdTUrqQNNZTYyxOqZafxJbVEP+ZCGKEu+YphMRM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sFLn+1gZ/OfdoJzepQyAnc5smjnfUVDz5lb3ChtnlVGuqwxu4vyVlopRU+LGbMVuF+lSRtzxulvttyjzd97jbzwSviSoL95Ho+4tdRf1d1TZi1SoQgFofjbdd7tHjbDhXZiR5OQOP1a4yxOcy08Hp5cXcwB3XGOI+seLYIaog9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W9t+a01r; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1a8de19f7aso528012276.3
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063685; x=1725668485; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=96HY44+FHUuViWLDbF4F4IXwjBoW3zIk9LKTSFfViJs=;
        b=W9t+a01r2nE46g2i7UVV2BCiV6hxbTIYtONZZV9nIjv5rK5EfhpPhSz3yNxQTr9Tzq
         SaqJYcGpeGSGyuIcT6Au07cas+JDFCwwJkdWYLAHrhmKHMMqYDBWgQnokkTrglrauNqV
         5N4oRTQGnRjoj7G31aVC5RsnbImCwRK9bxxe7A8HtaU2Vtv6to//8mAQU2wq+ovViGvA
         vIPeWVRoqypTV7d/hRWukqHW2VMMnd1+dgbfJENP5tL2zAmSP035Dy/tg8jAQ+Zpwzso
         JCawea53dAQejFlJyJVagDpduo9ACElwyn2JwnMpXlnGumcGZiJdjTWF6lriZIEMyFN2
         hntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063685; x=1725668485;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=96HY44+FHUuViWLDbF4F4IXwjBoW3zIk9LKTSFfViJs=;
        b=T/27Z2vvbiUAFxflJvc1CVpOIy0rx2FyYcmB5jMvvQGxJppThuaeexAuxkpgZUpD5Y
         wOjO4/mK3PaiCtgXXhwLN3TRDsrZuAT1YO3WrKA5ggnwbt6Vnlfy/6LfrXWWTU8DE8sg
         0qK7ezRQEcSYhY2fGkMdU/Pf1rdXCRYQ+Mx3S4aZ6KD5Q2xWjz95vlgKhQAq15JiPGBP
         GTHoP6p0PJmBV0hyvCJRQGDRb3TPJkN3etxMhmF941Ezehbn+avcXNApll8gskSTa6d6
         T9DyaP6syW+xRcE4BgOY31PdT7xE39s9LS062zpmvhyQlaWX36d42ONAYXHc8zP4E5tS
         4bkQ==
X-Gm-Message-State: AOJu0YxYkY4XaVgrH2BSP6UPtFEPeNs+K6zSUY3qeedT1g7aZMG9Uijg
	xS8D8rRVYRTCN7Bv+tpmY/ctOUAe/PhGP8jqyG4NR02/4OAgTU5G1AgnHOwhhMACBDe0QKs9Qhk
	+9w==
X-Google-Smtp-Source: AGHT+IFuc+FP8iCjpxSVNR2gPPVNwYBTJhtp9Vu2kSmM1/ib6tPIjU36yNItiGMsIM1ALifr5Owxkxr7Om0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7e46:0:b0:e0b:ea2e:7b00 with SMTP id
 3f1490d57ef6-e1a7a032862mr19163276.5.1725063684874; Fri, 30 Aug 2024 17:21:24
 -0700 (PDT)
Date: Fri, 30 Aug 2024 17:20:53 -0700
In-Reply-To: <20240802195120.325560-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802195120.325560-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <172506359625.339073.2989659682393219819.b4-ty@google.com>
Subject: Re: [PATCH 0/5] KVM: x86: Fastpath cleanup, fix, and enhancement
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 02 Aug 2024 12:51:15 -0700, Sean Christopherson wrote:
> This series was prompted by observations of HLT-exiting when debugging
> a throughput issue related to posted interrupts.  When KVM is running in
> a nested scenario, a rather surprising number of HLT exits occur with an
> unmasked interrupt already pending.  I didn't debug too deeply into the
> guest side of things, but I suspect what is happening is that it's fairly
> easy for L2 to be interrupted (by L1 or L0) between checking if it (the
> CPU) should enter an idle state and actually executing STI;HLT.
> 
> [...]

Applied to kvm-x86 misc, I gave myself enough confidence the fastpath fix is
correct with a selftest update[*] (which I'll get applied next week).

[*] https://lore.kernel.org/all/20240830044448.130449-1-seanjc@google.com

[1/5] KVM: x86: Re-enter guest if WRMSR(X2APIC_ICR) fastpath is successful
      https://github.com/kvm-x86/linux/commit/0dd45f2cd8cc
[2/5] KVM: x86: Dedup fastpath MSR post-handling logic
      https://github.com/kvm-x86/linux/commit/ea60229af7fb
[3/5] KVM: x86: Exit to userspace if fastpath triggers one on instruction skip
      https://github.com/kvm-x86/linux/commit/f7f39c50edb9
[4/5] KVM: x86: Reorganize code in x86.c to co-locate vCPU blocking/running helpers
      https://github.com/kvm-x86/linux/commit/70cdd2385106
[5/5] KVM: x86: Add fastpath handling of HLT VM-Exits
      https://github.com/kvm-x86/linux/commit/1876dd69dfe8

--
https://github.com/kvm-x86/linux/tree/next

