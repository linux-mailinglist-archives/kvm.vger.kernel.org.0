Return-Path: <kvm+bounces-34968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD9A6A08304
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 23:56:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FC2A188ABC6
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 22:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBE24205E22;
	Thu,  9 Jan 2025 22:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mk+/AiHG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E85C4A1A
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 22:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736463353; cv=none; b=AiV7THgEDNYCqw1i5OBEciQ8AAPMM5PEHh8rQTwuJBmZ+Lu9w2bIaC1zK5MtPXA/w/mwnlYLxFZvkcR0/d0CR5qMHc1WYjajBL7auIse0fTHtBmyN0kJIWatHDSf6k849qDnZ2vmplvvYT9E5KW2TwpkMgu/0jMR48e35hG9uUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736463353; c=relaxed/simple;
	bh=W0EseXR27uaH+2rvnliUPd4fCcSkw5GgQuEBIx6U3zU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DV32mDH85HAKBK0IZwKT/cSt0yItieEjgYYWTi0/U6shVSoLk9USpoxauO9fhKCyHt+NQEY5jJ3j9QT7IYybxrTPIWHnPYXm1W1ex5kUf8bLvouQmaP3lGoqS6b2cIjjmY+y4jiKRfA55XHp/LWVCEO+s5Pj4gOE9w2gZn2WnNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mk+/AiHG; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-84cdae60616so120532239f.3
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 14:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736463351; x=1737068151; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Bg7OFBM7Iyaw8rDI2YVgCZ6Mugo0msQNybpcVxWKPAk=;
        b=Mk+/AiHGr9+KJIhMHEGDY38scxPYGrcVUpYUGefjeNRYbar5IPKaxtyO1NaUvQS+z1
         Q5PCfgscxtvwVS4Qc61FqzYVtrsdGcIf/Nl7gfMvmSLqT5lmyXEHp7APbCz1FeiDDuwP
         elRnIxG5ZnRbaO+qctWEBg5bnmUoSwyIDrpa15PmCgFXM/kXFE/hv9H7M6Ekl5V8tBRO
         N2MGG+kuGJVR6PSbHvDaZHGOjKxw+wxFZUkGKyiL1DUBFBPt8yFZjLx4sCykX5JibEnA
         dMQsr8leVCCIRZQvgc+30q24XBEJ57YTr23of5CH3lcX8g0isdPcvLFSmlQoo6XkxJXy
         Lx9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736463351; x=1737068151;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bg7OFBM7Iyaw8rDI2YVgCZ6Mugo0msQNybpcVxWKPAk=;
        b=oFg/vwmmzEAJnnbD/MPMJ9+rBHxSzJnourFabWF0NYnusL7lKDoxHhe3F7iFSU2qpZ
         Zo1DaH87zT7t314175Re4IIfPMB5EqFC2VxvoGBy3lAZAJ02X62lTCEcy24qF5aCnmiS
         TdEKJ4HaoMaxiJhk0JWd2NA/gsZJj7kTF9mMOkVu7qJSerRQdexfrR8Jya8TPIik+tOI
         Jg2wr5FBqvmrZF77YVGwUg5vemhIMPN7+QvEMvEtZ66N4laLkcZsOz/5VpaVZxFh91dC
         nQbDxpjlqKF8Y9MHTNm1AJdFNXQwvnVvBOolDllHt5Axt75QuwJF0jQD+1Tmi2VMvRVT
         FsEw==
X-Forwarded-Encrypted: i=1; AJvYcCWVm/rNX9vL0wen/MwngrlCHUtifPKG7/0gObcuu/LjCMd0kwvX2PhliK9F0m+uT9QwP8U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLYwtho62KXFqJmaALAtGRoRbRNNql+8QMLE8E4bCRP4stVKyd
	TS3TlLSxdHljzDCPOM1rVuucGiVKp+0KvP8jLTccgo1FoJbkDyqpW9D/yMAF/CRZGBIVIzn61ln
	mw8oKCLCCqFqJRwMn5mj8vy6YaSZ1hg==
X-Google-Smtp-Source: AGHT+IH6TwFJV+BPqg6h8Oejd7g1Ev34mvyO1X35nslxu87ElQQW1f6+tkLEnW4PrqmqE5yOxXQe7iLwl7b7G2zh6NZr
X-Received: from iobee12.prod.google.com ([2002:a05:6602:488c:b0:83a:b10a:a59a])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:2c07:b0:84c:ea14:9315 with SMTP id ca18e2360f4ac-84cea14982amr563273639f.12.1736463351528;
 Thu, 09 Jan 2025 14:55:51 -0800 (PST)
Date: Thu,  9 Jan 2025 22:55:31 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250109225533.1841097-1-kevinloughlin@google.com>
Subject: [PATCH v2 0/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
From: Kevin Loughlin <kevinloughlin@google.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	pbonzini@redhat.com, kevinloughlin@google.com, 
	kirill.shutemov@linux.intel.com, kai.huang@intel.com, ubizjak@gmail.com, 
	dave.jiang@intel.com, jgross@suse.com, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, pgonda@google.com, sidtelang@google.com, 
	mizhang@google.com, rientjes@google.com, szy0127@sjtu.edu.cn
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

Changelog
---
v2: rebase to tip @ dffeaed35cef, drop unnecessary Xen changes, reword.
---
Kevin Loughlin (2):
  x86, lib: Add WBNOINVD helper functions
  KVM: SEV: Prefer WBNOINVD over WBINVD for cache maintenance efficiency

 arch/x86/include/asm/smp.h           |  7 ++++++
 arch/x86/include/asm/special_insns.h |  7 +++++-
 arch/x86/kvm/svm/sev.c               | 35 +++++++++++++++++-----------
 arch/x86/lib/cache-smp.c             | 12 ++++++++++
 4 files changed, 47 insertions(+), 14 deletions(-)

-- 
2.47.1.688.g23fc6f90ad-goog


