Return-Path: <kvm+bounces-62650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C230C49C06
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:29:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99B513AE2B7
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8DD033CE84;
	Mon, 10 Nov 2025 23:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sE4rMjGL"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D1C31281B
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817235; cv=none; b=H3vUQld6FMvx4tuzbhl6Q3HF8dV4mmBrtEs+l3V0U4+uuLipU4uZM+0ZeMlvYEGozDZbYGjQibxJvNqricMre7h0KSqPpR3ondv6NICiNASJJK0NN+HyiD5o90ZcTVsbdfXKeRCPxzd/4XRD0caMmmwUcnP4MP4rvLtV5XEi85I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817235; c=relaxed/simple;
	bh=/9UG0LzYBSu5uJGvcQElIGzsedcqBP/QxZPWBQzj3No=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hBPh7OAWCDWnTu6K2kmwOaf2d4A7BY9W3y2EvPHCl6gqjaQ6P0W9KtaOuYEvoMl6r2u7C1Lzd8AkcdD2l6RwHeVrJfZCclBGtfS798+7BEtr8coEgU+GbywPDaThig+t0GtxIzBBrh+6UvoANGsqFsIHxoBcrBDJLalLezmKSTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sE4rMjGL; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762817220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dmoWcwjZhu5uEPgclztVaT4/J/i5TtOnZ6ghcyqjVsQ=;
	b=sE4rMjGLyJeozhD7Y3Prf1Jlo++YUFg+nNWgIVVTy2yyH7xZhUWYtARf45dWgB2YAjQD3g
	Dl+ml1rf/2xTYRVlo0e2HD4u3o3PcZnQTgbvcrLTlVcgN9KZhaG8sN4VAoh3wlcdiyDOBq
	RsUK2NIHUkYVP0iVzef77+SkGp3edU0=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 00/14] Improvements for (nested) SVM testing
Date: Mon, 10 Nov 2025 23:26:28 +0000
Message-ID: <20251110232642.633672-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This is a combined v2/v3 of the patch series in [1] and [2], with a
couple of extra changes.

The series mostly includes fixups and cleanups, and more importantly new
tests for selective CR0  write intercepts and LBRV, which cover bugs
recently fixed by [3] and [4].

Patches 1-2 are unrelated fixups outside of SVM that I just included
here instead of submitting separately out of pure laziness.

Patches 3-8 are cleanups and refactoring.

Patch 9 deflakes svm_tsc_scale_test in a not-so-sophisticated way.

Patches 10-11 generalize the existing selective CR0 intercept tests and
extend them with new test cases.

Patches 12-13 cleanup the existing LBRV tests and extend them with new
test cases.

Patch 14 is a rename to some of VMCB fields to match recent renames in
KVM [5]. This is the last patch is in the series also due to laziness.

I realize that the patch ordering is a mess, and I can rebase and
reorder if it actually matters to anyone.

[1]https://lore.kernel.org/kvm/20251028221213.1937120-1-yosry.ahmed@linux.dev/
[2]https://lore.kernel.org/kvm/20251104193016.3408754-1-yosry.ahmed@linux.dev/
[3]https://lore.kernel.org/kvm/20251024192918.3191141-1-yosry.ahmed@linux.dev/
[4]https://lore.kernel.org/kvm/20251108004524.1600006-1-yosry.ahmed@linux.dev/
[5]https://lore.kernel.org/kvm/20251110222922.613224-1-yosry.ahmed@linux.dev/

Yosry Ahmed (14):
  scripts: Always return '2' when skipping tests
  x86/vmx: Skip vmx_pf_exception_test_fep early if FEP is not available
  x86/svm: Cleanup selective cr0 write intercept test
  x86/svm: Move CR0 selective write intercept test near CR3 intercept
  x86/svm: Add FEP helpers for SVM tests
  x86/svm: Report unsupported SVM tests
  x86/svm: Move report_svm_guest() to the top of svm_tests.c
  x86/svm: Print SVM test names before running tests
  x86/svm: Deflake svm_tsc_scale_test
  x86/svm: Generalize and improve selective CR0 write intercept test
  x86/svm: Add more selective CR0 write and LMSW test cases
  x86/svm: Cleanup LBRV tests
  x86/svm: Add more LBRV test cases
  x86/svm: Rename VMCB fields to match KVM

 lib/x86/desc.h       |   8 +
 scripts/runtime.bash |   4 +-
 x86/svm.c            |  12 +-
 x86/svm.h            |   7 +-
 x86/svm_tests.c      | 402 +++++++++++++++++++++++++++++--------------
 x86/vmx_tests.c      |   5 +-
 6 files changed, 303 insertions(+), 135 deletions(-)

-- 
2.51.2.1041.gc1ab5b90ca-goog


