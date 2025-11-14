Return-Path: <kvm+bounces-63256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F119C5F467
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:51:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A563135815D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62CF82FB085;
	Fri, 14 Nov 2025 20:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0M4Kl8ni"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C16284672
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153465; cv=none; b=IgEMKe6adj43+62AyTPwEcvIBc8Yvnd6aahjVK0eemApggnFBHMbcWR1wh3XnRMpQacYMQih5UuBkSIVdPGpisD/Ljh75PpZgymZLMaQyyCX5xW/igdQ9+z8h/AR2+a3gXpnqs0EvTLu9bhXyG0znm2/TC/p0n1/0NUHAusXq9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153465; c=relaxed/simple;
	bh=T9zCbeD4FXGJxdXRNwqWKxMYTZnzHwninRauZfvT9Ak=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZyyfusQEGZ1huLHWnPNfaBDHHEUIptVraVbbblN3fQ1erZazz+odKyndPjB5mwWCb6MH9WVwCS1Ot0a8oD5jQFbmFGOEZ2D/lceW5vqrFyEn2r4lpbinYFhVETbdiI8j3E4KcgDzf5bq3v8nzQef3qCnnmgzR3eUDR+QP7mJpD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0M4Kl8ni; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34188ba5990so7196468a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153463; x=1763758263; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OwcqZZiSCWMezOvkD2QzPvNzAZVx+Txt4XQWYyyOg50=;
        b=0M4Kl8nijesRDh3v43ajUCf7kAUhPjb7G7+Y1hANRuyGwqdkGnW/uMJqQ0AFGX4YeF
         vCb28m42iepVmfHSSvRLc28kmE3iUjaEPOgaFja37EZiyq/oRmvy2ONITWMZotXGOzN0
         ARiQOOjHSaNKRo5QtrL1COy5t7FdRtLqpBiu+m6iy7hmmoZ1NkPp+DQ/mC4kA0E++zo4
         PfYCaLEW5wMU3TDjUzoNYhdH/lsFe6f3qd9F9ygDsOTi/NrBMVKnZAJ2F2A5PlbqMK+F
         hdXHx9Hwy7or6whOgY9aeUjeNrLG8hdvaQWI3aQMDxbpBjcLqY1d8A+BvTxUZ7qSs8NZ
         M7AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153463; x=1763758263;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OwcqZZiSCWMezOvkD2QzPvNzAZVx+Txt4XQWYyyOg50=;
        b=oR681PcqHwUA9kLcSpczqJeFHAVFXP90/a9Mb63mKrBMk0WmrIfQbwIOiaEebSIuY5
         0z1GZ5333ruCJCFEJ8/n2lKPnqakV30NZDxN4PNzQusRu0nigB0ZLbSHrGRN3DMoWjdt
         cuSavS7aQePpbf3udGIALIXgmpSHqYBxoOETeY6NTN5X8tiDYkiWLA9JF9UDHyqPUQSr
         Au7VAjZ425tdvUk1zmlv/pFodbEakNJ7MGVnSkPX16T+9jjbSA3vfQnSE7BiUwQtBtOR
         T4drNGZpzUv8DxFHCCVExZTe0hA3yZujbJuGBlU+sG+KaQ4Nr3AdAHfHLVC2QlDSzor1
         dNMg==
X-Gm-Message-State: AOJu0YxlbNDJxWNsciWdOKklhUFJ9miHVF9RWtVInDX0riiD7By5PsM8
	ypDy3L+m0ubQBrfp/u14A1K7IHzo/z6rNgI6dECkVXUdyF2uEDrUY+2o3CZFm/FBdmNAI9gB3T9
	Aa7O8ug==
X-Google-Smtp-Source: AGHT+IEjcupoA806dlTzATNPmOzInpNgXNgHvLgtyTrQyvFkT5DgtnA+oJjXZt5sMVHntXrkr+p5hG6QhWc=
X-Received: from pjps16.prod.google.com ([2002:a17:90a:a110:b0:341:2141:d814])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c06:b0:341:ae23:85fd
 with SMTP id 98e67ed59e1d1-343f9ea58damr5616937a91.11.1763153463407; Fri, 14
 Nov 2025 12:51:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:42 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 00/18] x86: Improve CET tests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Hopefully the last version of this particular CET series.  Mathias, I owe you
like five beers for root causing and fixing all the gnarly edge cases.

v4:
 - Fixup the argumentes for the vmx_cet_test. [Mathias]
 - Drop "_test" from the vmx_cet config to match the other VMX testcases.
 - Enable NOTRACK instead of dodging jmp tables in exception_mnemonic() [Mathias].
 - Reset IBT state after (intentional) #CP. [Mathias]
 - Fix a changelog typo. [Mathias]
 - Document that ljmpq isn't supported on AMD. [Mathias]
 - Use ljmpl to make the 32-bit JMP FAR more obvious. [Mathias]

v3:
 - https://lore.kernel.org/all/20251114001258.1717007-1-seanjc@google.com
 - Run the test if only one of SHSTK or IBT is supported (e.g. to test
   SHSTK on AMD).
 - Rename the test from "intel_cet" to just "cet".
 - Add an endbr64 in the user_mode trampoline (the test was getting false
   passes without ever reaching cet_shstk_far_ret() due to getting the
   expected #CP).
 - Add testcases to verify KVM rejects emulation as expected.
 - Add a comment explaining the SHSTK PTE magic (I forgot about the magic
   and spent a long time trying to figure out how the user_mode trampoline
   was succeeding if the SHSTK wasn't writable, *sigh*)


Chao Gao (7):
  x86: cet: Remove unnecessary memory zeroing for shadow stack
  x86: cet: Directly check for #CP exception in run_in_user()
  x86: cet: Validate #CP error code
  x86: cet: Use report_skip()
  x86: cet: Drop unnecessary casting
  x86: cet: Validate writing unaligned values to SSP MSR causes #GP
  x86: cet: Validate CET states during VMX transitions

Mathias Krause (5):
  x86: cet: Make shadow stack less fragile
  x86: cet: Simplify IBT test
  x86: cet: Use symbolic values for the #CP error codes
  x86: cet: Test far returns too
  x86: Avoid top-most page for vmalloc on x86-64

Sean Christopherson (5):
  x86: cet: Run SHSTK and IBT tests as appropriate if either feature is
    supported
  x86: cet: Drop the "intel_" prefix from the CET testcase
  x86: cet: Enable NOTRACK handling for IBT tests
  x86: cet: Reset IBT tracker state on #CP violations
  x86: cet: Add testcases to verify KVM rejects emulation of CET
    instructions

Yang Weijiang (1):
  x86: cet: Pass virtual addresses to invlpg

 lib/x86/msr.h      |   1 +
 lib/x86/usermode.c |  16 ++-
 lib/x86/usermode.h |  13 +-
 lib/x86/vm.c       |   2 +
 x86/cet.c          | 308 ++++++++++++++++++++++++++++++++++++---------
 x86/lam.c          |  10 +-
 x86/unittests.cfg  |  10 +-
 x86/vmx.h          |   8 +-
 x86/vmx_tests.c    |  81 ++++++++++++
 9 files changed, 375 insertions(+), 74 deletions(-)


base-commit: c885c94f523eb4518dc30408fb5199fd23d4aa0a
-- 
2.52.0.rc1.455.g30608eb744-goog


