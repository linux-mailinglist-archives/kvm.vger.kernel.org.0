Return-Path: <kvm+bounces-59307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9A7ABB0EB6
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7802E320622
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFAB930B50D;
	Wed,  1 Oct 2025 14:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WO87wqF1"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EACC309EED
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 14:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759330732; cv=none; b=f6hDoT8se1YGpXYUYuMy8nu1cK+rsYkjtAiXbPQOTg+pQrQ/LV99S9JywXKA7eqkyjASxs92KCU6sMey3xXGQTEolV74TjsNMzD/gkjvCZ/4pvhGGrN86LyIkuG1Lq1Qs6kesKuuJT/B07Z2QukedSyaNbJZk0159wTiGb+oTaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759330732; c=relaxed/simple;
	bh=JuKjkUbgJ0qnM1ZoCW/3jFKFv0+E5P7+c+tqjQRwQ08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oy4v6WtetVWLZskICYcTWgIg8JZh/wiKx4Xy2AER4PtSMB7w7jAgtoK6Dm5Lut8VXWCCnb12sGbTyPzTHFFwaThXf5mJS1agKJCho6od9UHFifdYUrZl1XYPSgzcBGr0ruyzE1mTkil42N9D3O6XQ2XukiBN7hNKgvTiWKn5nIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WO87wqF1; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759330718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/qao2gf0buAXa41pQzpibNT0JX2AC6F/MUPKWYgy5yw=;
	b=WO87wqF1mNBtl/tDc81fbjeb3RSroDMBkgmMnorxsuAbhQr2gHlEiWF6Q+LyWAwxDfMgRt
	0RX5k+A6SsKwvZmYbCPmaunDIEjIr8C9LTAJKnrbQhGnhYO+vwWDM628RCoT4BKb6Suo/6
	GOtbUlwoxYPDXdOIxohOs+83NOXCkX8=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 00/12] Extend test coverage for nested SVM
Date: Wed,  1 Oct 2025 14:58:04 +0000
Message-ID: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

There are multiple selftests exercising nested VMX that are not specific
to VMX (at least not anymore). Extend their coverage to nested SVM.

Yosry Ahmed (12):
  KVM: selftests: Minor improvements to asserts in
    test_vmx_nested_state()
  KVM: selftests: Extend vmx_set_nested_state_test to cover SVM
  KVM: selftests: Extend vmx_close_while_nested_test to cover SVM
  KVM: selftests: Extend vmx_nested_tsc_scaling_test to cover SVM
  KVM: selftests: Remove invalid CR3 test from vmx_tsc_adjust_test
  KVM: selftests: Extend vmx_tsc_adjust_test to cover SVM
  KVM: selftests: Pass the root HVA directly to nested mapping functions
  KVM: selftests: Use 'leaf' instead of hugepage to describe EPT entries
  KVM: selftests: Move all PTE accesses into nested_create_pte()
  KVM: selftests: Move EPT-specific init outside nested_create_pte()
  KVM: selftests: Refactor generic nested mapping outside VMX code
  KVM: selftests: Extend vmx_dirty_log_test to cover SVM

 tools/testing/selftests/kvm/Makefile.kvm      |  11 +-
 .../selftests/kvm/include/x86/nested_map.h    |  20 ++
 .../selftests/kvm/include/x86/svm_util.h      |  13 ++
 tools/testing/selftests/kvm/include/x86/vmx.h |  13 +-
 .../testing/selftests/kvm/lib/x86/memstress.c |   5 +-
 .../selftests/kvm/lib/x86/nested_map.c        | 150 +++++++++++++++
 tools/testing/selftests/kvm/lib/x86/svm.c     |  70 +++++++
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 180 +++---------------
 ...ested_test.c => close_while_nested_test.c} |  42 +++-
 ...rty_log_test.c => nested_dirty_log_test.c} |  95 ++++++---
 ...adjust_test.c => nested_tsc_adjust_test.c} |  79 ++++----
 ...aling_test.c => nested_tsc_scaling_test.c} |  48 ++++-
 ...d_state_test.c => set_nested_state_test.c} | 132 +++++++++++--
 13 files changed, 609 insertions(+), 249 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86/nested_map.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86/nested_map.c
 rename tools/testing/selftests/kvm/x86/{vmx_close_while_nested_test.c => close_while_nested_test.c} (64%)
 rename tools/testing/selftests/kvm/x86/{vmx_dirty_log_test.c => nested_dirty_log_test.c} (62%)
 rename tools/testing/selftests/kvm/x86/{vmx_tsc_adjust_test.c => nested_tsc_adjust_test.c} (61%)
 rename tools/testing/selftests/kvm/x86/{vmx_nested_tsc_scaling_test.c => nested_tsc_scaling_test.c} (83%)
 rename tools/testing/selftests/kvm/x86/{vmx_set_nested_state_test.c => set_nested_state_test.c} (67%)

-- 
2.51.0.618.g983fd99d29-goog


