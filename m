Return-Path: <kvm+bounces-36209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D5B5A18993
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 02:35:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFAED1880861
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 01:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C3F478F43;
	Wed, 22 Jan 2025 01:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yocFZrpg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A14424B34
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 01:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737509686; cv=none; b=Peot692emSHHCut2mxtYCcQ2HZi5NlfNBVaWvUIS1D24N1YR84MqRl7Uj1eAWQLN6Fr9rIS+Qw8O5ch9+rv8MxWynRPpOj/ytcmULPlFybXafK1QHK2iu/PfH93Ty6OdM/02I77kEmVMf6o928Sg5+0T6BObKbWbr3sQYbSP0QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737509686; c=relaxed/simple;
	bh=S1axx5L2j07A2GiZx8/vk+JK9Ft4F39i4KuNpvaf0fo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ffqQfrGrRaXxshca9vmFQaAeGXaDD/BnZG8d2YLYmM4qo6U2EAtanFRAGu6L1C4biAPef7pPmNB4/NEn8btr5SaAJDT0rZvi1UkzKkYPgKeMviAYMGi3DEPlYMxYD46aBqQ7mEXQt29tvIeBgDnaBXjhsM+ramBoyfZlMX0cGO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yocFZrpg; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-3eb97b1cc12so1686690b6e.1
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 17:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737509684; x=1738114484; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dw7KrtAAbsIi6ykE6uD1Tqq6/le5e/gBzrZA2jAv2A8=;
        b=yocFZrpg9xiPtIZ2nBursJeS4gccR6oovjLDpiJRczZXdrEz5Gv/EKU8VnD8Ew5gps
         ZOdhWf+5EuK05pMewDDK/xQqs15M/4m9kmdwx4ru6e93DNIB0tCaeN8BvRXOT6adu7Si
         YHzpkj1aEs/HDCIyxO9xi54qqjVyp3wznLKBxIxGdDFj5LGSIdYpOBYCURynT9VvNKFL
         1SvMWNEos/G7KN8j0SrLBcY+JPnP7R72riThUwLe4B2yWvQKywJISxtJX5hgLsk7jTOs
         T0fFoQL5yMbM+DqmQjvu8bzif4OM2CPK+TuqvgsxuKuZinuJBjPanu2poBuILCNMuoVJ
         xN6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737509684; x=1738114484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dw7KrtAAbsIi6ykE6uD1Tqq6/le5e/gBzrZA2jAv2A8=;
        b=L+mb8VfTUN2bgjUaKy2XBwiU91mATrblwJ4v3edvdbkWD6jaiXGKID5llrHEW0x6iK
         oadL8HM935BlohF2UoARnDrHiP8PE6g/UEo6vXZQcc6+p1snMAHYZCHt7LHZQcIawn6e
         ommahlAD1RJBOHEmpkddghdApjjC07o3tMsJRP5ChVw0HPGEJOzZ/Nc4odcKyFIXTvT3
         JsqEBYOuvAxmKO5H1mL0GBw5+6u23o90idiU3fvz4Kg4IatF2leEQDpF0wbFuk9ClKnQ
         yvu2sUC5FcL1fbJHTm1SPLgwLlHe6Tp9rRedSGCj2BQeMTSuS+Bgb5vrilQtrzKK1ev2
         iv6A==
X-Forwarded-Encrypted: i=1; AJvYcCW8CpAl0wUqfyayGkKT0hz3wjlwsKWIwTv+0wf7kHwwbnc8QeMfl18diZjQIRf6wNAmIxo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGDcUx/e2OXt+bRSoco6YeHKfu3T/HNxgxCtzrvR/nsAe+wPft
	H9LrLDnaegJLAMmiQsKXAAGnkbEy+acfoyz6XW5lZ9m5D2HSqnkN/cmdXGc1PmAVSrc23JaZXsZ
	enXx+l5Z16B5D/ny2WhCVPkQ3FLbPkQ==
X-Google-Smtp-Source: AGHT+IHAbs5KfSq7nlDDTnztJvt1kLA7oPNY0pgXhYBx1zvaOWxTtkds3jPtgYGBpkOGjMeGK/XU2bezakt8J2AiVNPt
X-Received: from oilj6.prod.google.com ([2002:a05:6808:1186:b0:3eb:70dd:d3eb])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:2e44:b0:3f1:b077:5f87 with SMTP id 5614622812f47-3f1b0776183mr8171228b6e.24.1737509684228;
 Tue, 21 Jan 2025 17:34:44 -0800 (PST)
Date: Wed, 22 Jan 2025 01:34:36 +0000
In-Reply-To: <20250122001329.647970-1-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250122001329.647970-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250122013438.731416-1-kevinloughlin@google.com>
Subject: [PATCH v4 0/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
From: Kevin Loughlin <kevinloughlin@google.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	pbonzini@redhat.com, kevinloughlin@google.com, 
	kirill.shutemov@linux.intel.com, kai.huang@intel.com, ubizjak@gmail.com, 
	jgross@suse.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	pgonda@google.com, sidtelang@google.com, mizhang@google.com, 
	rientjes@google.com, manalinandan@google.com, szy0127@sjtu.edu.cn
Content-Type: text/plain; charset="UTF-8"

AMD CPUs currently execute WBINVD in the host when unregistering SEV
guest memory or when deactivating SEV guests. Such cache maintenance is
performed to prevent data corruption, wherein the encrypted (C=1)
version of a dirty cache line might otherwise only be written back
after the memory is written in a different context (ex: C=0), yielding
corruption. However, WBINVD is performance-costly, especially because
it invalidates processor caches.

Strictly-speaking, unless the SEV ASID is being recycled (meaning all
existing cache lines with the recycled ASID must be flushed), the
cache invalidation triggered by WBINVD is unnecessary; only the
writeback is needed to prevent data corruption in remaining scenarios.

To improve performance in these scenarios, use WBNOINVD when available
instead of WBINVD. WBNOINVD still writes back all dirty lines
(preventing host data corruption by SEV guests) but does *not*
invalidate processor caches.

First, provide helper functions to use WBNOINVD similar to how WBINVD
is invoked. Second, check for WBNOINVD support and execute WBNOINVD if
possible in lieu of WBINVD to avoid cache invalidations.

Note that I have *not* rebased this series atop proposed targeted
flushing optimizations [0], since the optimizations do not yet appear
to be finalized. However, I'm happy to do a rebase if that would be
helpful.

[0] https://lore.kernel.org/kvm/85frlcvjyo.fsf@amd.com/T/

Changelog
---
v4:
- add comments to wbnoinvd() for clarity on when to use and behavior
v3:
- rebase to tip @ e6609f8bea4a
- use WBINVD in wbnoinvd() if X86_FEATURE_WBNOINVD is not present
- provide sev_writeback_caches() wrapper function in anticipation of
  aforementioned [0] targeted flushing optimizations
- add Reviewed-by from Mingwei
- reword commits/comments
v2:
- rebase to tip @ dffeaed35cef
- drop unnecessary Xen changes
- reword commits/comments
---
Kevin Loughlin (2):
  x86, lib: Add WBNOINVD helper functions
  KVM: SEV: Prefer WBNOINVD over WBINVD for cache maintenance efficiency

 arch/x86/include/asm/smp.h           |  7 +++++
 arch/x86/include/asm/special_insns.h | 15 +++++++++-
 arch/x86/kvm/svm/sev.c               | 41 ++++++++++++++--------------
 arch/x86/lib/cache-smp.c             | 12 ++++++++
 4 files changed, 54 insertions(+), 21 deletions(-)

-- 
2.48.1.262.g85cc9f2d1e-goog


