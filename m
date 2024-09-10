Return-Path: <kvm+bounces-26191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E43C29728B3
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 06:59:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F16B1C23E42
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 04:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E7816BE23;
	Tue, 10 Sep 2024 04:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0MA8XDLs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5795D1531EA
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 04:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725944333; cv=none; b=QsqNMc8kdZZtPRqDaXU5TnUkWOc5yrUzzz+6UC0AEa9e0g8kWzaVNlRRSMyu+aTyTC1ao646DZUeaKTjM4vPy0ifh/acnPbCKMj8MzXuyKRahiAeFNxC55ckvpiVgh+vpt/cd/g0xYzkmzFcrreqtdIPHbI/dwLK86kS2NOeIuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725944333; c=relaxed/simple;
	bh=p15sVcC8WU/sJ/qbyxJqzEuHKzK8TtU43QSoy8Wfd3o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KDy2v1YCt0HiYP8ik4HT3MMxjNkXOpAwhdRVG9G3vatM2kShX+iK2rYyyLv0ah0RWjMCRrkD/f6lGARtFYdPWtsHCemVjcSk383CbPgx7xPg/6QpjJnALj6g2al5EuMwhnItK89o0f/09wr36MNQYCE5+hXqdVHrPyVJn4jfPUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0MA8XDLs; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-205514676a6so57798665ad.3
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 21:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725944332; x=1726549132; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dK8nwxLZ16HM5IuWSS//WkrenLVqRDzLT6kk/4QHEHY=;
        b=0MA8XDLscGM+rLNC0/4s8nJdhWlEW/Wmh6Qdy29QqBzL/XJ/1P8DrSmIKODAKpj1VU
         QwlFd4QkTxLPcOazW+yO2S57MltvYb+8DPmGyKaC5jG9Auduz7nTyaZGaxbpmUeK13eP
         Vg9dV9qhImR6fZV5XQaxSXllm62rSrKc4n7ZRgoXo9BrkjrrrMakDbj0EuA6TP/4pFxp
         13QOyTmP9ZL1jIupwwCOvISz7giqA63+3Cr6CN1tHSw2P5DbVUS1OmZ4SQgzMM7NKyxq
         89r+faMBb0yyq4LwVdPtTm/hiEF4eMddokQycjW1uHmiLwDjc3T6VAYn1XsZiXd/WRz2
         Gh3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725944332; x=1726549132;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dK8nwxLZ16HM5IuWSS//WkrenLVqRDzLT6kk/4QHEHY=;
        b=ohme5YzsvdwONqtD1DRvxIqxfLSMV1RSTDZ5gQ2fOd2tnVouXebl+0xLWjv5I/GHFV
         FET/PPx95xzJUVNTzz7CQYQvDk+IG7JXRUqj00YTIETTA/TPBmnWgH11BxHvoWn5LSUa
         6+uLzZmW5LiDzT9MYwn9l8icjKPEemLCer6msrD3coyLu1M3TjXn/ZF5/RkC0ERN2H7y
         SEhvsuqo0uHptGEdb4G5hx8OnbnDZ0Pu8OI/aIU52lPhQj7HrvM32xZzMYl4soP99lAw
         q1loNmcAk9KQkIzXTiIsp4rcvut8I9z2861WmbZ7CnHCSpoQ6N1aslxeFVuBRYKZ48Wc
         tTLw==
X-Gm-Message-State: AOJu0YzcwYtgt9Eak+iNJKiBj+MAHpm6CsKTnSYMEX5QkVPaLPbns27G
	yoO5mkaR0u3/W3BCVxuh1ckYzOQqk2nTT75bxP4TD9CWtmHZGbeSHffHUnssjRWBcvNmjhBcWiW
	VKw==
X-Google-Smtp-Source: AGHT+IFOZEtgwM1ymBP96hg2Q6/9kgQzKj+b6cATx8IYk49vQkTAlGYVUQKOViwHm5yWJb9aV73YixX/wGE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d50c:b0:206:99b3:52de with SMTP id
 d9443c01a7336-206f0652a5emr9533965ad.10.1725944331606; Mon, 09 Sep 2024
 21:58:51 -0700 (PDT)
Date: Mon,  9 Sep 2024 21:56:34 -0700
In-Reply-To: <20240809194335.1726916-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <172594269289.1554136.10571942058005796176.b4-ty@google.com>
Subject: Re: [PATCH 00/22] KVM: x86/mmu: Allow yielding on mmu_notifier zap
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 09 Aug 2024 12:43:12 -0700, Sean Christopherson wrote:
> The main intent of this series is to allow yielding, i.e. cond_resched(),
> when unmapping memory in shadow MMUs in response to an mmu_notifier
> invalidation.  There is zero reason not to yield, and in fact I _thought_
> KVM did yield, but because of how KVM grew over the years, the unmap path
> got left behind.
> 
> The first half of the series is reworks max_guest_memory_test into
> mmu_stress_test, to give some confidence in the mmu_notifier-related
> changes.
> 
> [...]

Applied the KVM proper changes to kvm-x86 mmu, sans the rmap locking stuff.
I'll send a v2 for just the selftest changes, and probably put them in the
dedicated selftests branch, as there is no actual dependency between the
selftest and the mmu changes.

[10/22] KVM: x86/mmu: Move walk_slot_rmaps() up near for_each_slot_rmap_range()
        https://github.com/kvm-x86/linux/commit/0a37fffda145
[11/22] KVM: x86/mmu: Plumb a @can_yield parameter into __walk_slot_rmaps()
        https://github.com/kvm-x86/linux/commit/5b1fb116e1a6
[12/22] KVM: x86/mmu: Add a helper to walk and zap rmaps for a memslot
        https://github.com/kvm-x86/linux/commit/dd9eaad744f4
[13/22] KVM: x86/mmu: Honor NEED_RESCHED when zapping rmaps and blocking is allowed
        https://github.com/kvm-x86/linux/commit/548f87f667a3
[14/22] KVM: x86/mmu: Morph kvm_handle_gfn_range() into an aging specific helper
        https://github.com/kvm-x86/linux/commit/c17f150000f6
[15/22] KVM: x86/mmu: Fold mmu_spte_age() into kvm_rmap_age_gfn_range()
        https://github.com/kvm-x86/linux/commit/7aac9dc680da
[16/22] KVM: x86/mmu: Add KVM_RMAP_MANY to replace open coded '1' and '1ul' literals
        https://github.com/kvm-x86/linux/commit/7645829145a9

[18/22] KVM: x86/mmu: Use KVM_PAGES_PER_HPAGE() instead of an open coded equivalent
        https://github.com/kvm-x86/linux/commit/9a5bff7f5ec2

--
https://github.com/kvm-x86/linux/tree/next

