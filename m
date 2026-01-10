Return-Path: <kvm+bounces-67647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AE44DD0CA54
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 01:49:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0A6263026AAC
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 00:48:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06FF41F37D4;
	Sat, 10 Jan 2026 00:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uu4r54eR"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A2041C62
	for <kvm@vger.kernel.org>; Sat, 10 Jan 2026 00:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768006125; cv=none; b=tsDH1Y16gg6mhRt1mw3IfW1C6etf07b9HfrKtIGQLlZtmoWq6TFbQnhDQuUlyqTyXu3ZdOJ2177JVnjg2o7PTSsOWGsm/UtlkyV4nXYEaN+rHrJvXjJegySqHG0uGvpLIwQwPLK97pU8qhS2xltC3bYyZB9jqiBsQxfcUcsXqSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768006125; c=relaxed/simple;
	bh=lG8dW8PIr0m2yCiTqjfQSbBUxLhSe6xTy+qzKr9px4A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=twnxD/ZNqlsEGC1ArK6vFGdxPcJcgKjTaca51lL2OaI+POJsOwxHS86zll3ukNcYGM/KZ6YBRTNvJ04IDUu8cJ5E2OAkLpUDtGYf5XNYxoT3nKjrAdRNZ1Rp9xg7yerT6gmaIK0B2GSetZh5P0bCw10LEa4K1U/B42WUdee2bmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uu4r54eR; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768006121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GM4LB/x+7ag1lds0sM/ImZ1OlQOTfGEECkRo4fRqTDA=;
	b=uu4r54eRMCbmKZHAbpaSlHDKSRS9H6nQamzQaBfIgdksM7E9exSx91mi9jM8/Kzz2YwmpP
	o+G+Z/trnNiB6jezrLYliB4Nq1NVkzmNzMcJNTiNI20b6k3opGtPeQ7Z5C+amSQj2JVX5+
	mWqXSAd7FdOPmJJYWIqzkjoggTLYgv0=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 0/4] KVM: nSVM: nested VMSAVE/VMLOAD fixes
Date: Sat, 10 Jan 2026 00:48:17 +0000
Message-ID: <20260110004821.3411245-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A couple of fixes for nested VMLOAD/VMSAVE and a selftest that verifies
correct behavior. The test fails without patch 1.

Patch 4 is a proposed added WARNING, I am not sure if such warnings are
generally acceptable and if that's the correct place for it (hence RFC),
but I think it's useful to WARN if VMSAVE/VMLOAD are neither intercepted
nor virtualized by the CPU, because it means that the guest is directly
accessing host memory with them, a massive security hole.

The warning doesn't fire with or without the fixes, but at some point I
thought there might be such a security bug, and having a warning will
give me some peace of mind.

Yosry Ahmed (4):
  KVM: nSVM: Always use vmcb01 in VMLOAD/VMSAVE emulation
  KVM: SVM: Stop toggling virtual VMSAVE/VMLOAD on intercept recalc
  KVM: selftests: Add a selftests for nested VMLOAD/VMSAVE
  RFC: KVM: SVM: WARN if VMSAVE/VMLOAD are not intercepted or
    virtualized

 arch/x86/kvm/svm/svm.c                        |  23 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/include/x86/processor.h     |   1 +
 .../kvm/x86/nested_vmsave_vmload_test.c       | 197 ++++++++++++++++++
 4 files changed, 218 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c

-- 
2.52.0.457.g6b5491de43-goog


