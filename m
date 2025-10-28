Return-Path: <kvm+bounces-61350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 58DC0C1727F
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 23:15:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20D6A1C27692
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0ECC3570CC;
	Tue, 28 Oct 2025 22:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pXaYqF7A"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60623570AB
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 22:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761689564; cv=none; b=Wk6qx81dnQHCgrSJqQ5ggAJW6SIIs9U2zal+vqQJmAfV9u142+U6zsVmDkyHAz1BZ02GoS1mP3RLN31gDjOi0oB4WMdxoqFTr7ZkZTHphTrOzPI7NXubiYl9nuH/YUxMJBnOcW9DnXSB0KBDsooJkEjUgYGRH/mgnLMTyZS3Q/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761689564; c=relaxed/simple;
	bh=l2PQw5Hv2eOE5O363SYubMk7NbCSY5T7zULwb/ikJPI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hi8BtvTav1obixTHo7jL9ac/zDjwsfAnt1UGcQJOxAACjmU2vz15WTk/uMn1aH/uwT+MitpJEgwIW9Wzr58UlChuEBkpKp9aXX/6/lHKtrfKi3VKpaB1D44XzzhonQHc3EQ9WwOfYv98CVt+NtkxrcKyBr79CmwEPH56G/uqb94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pXaYqF7A; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761689559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9NxYqxq//cG7DUHVJ627vLUFqaJqYlS/x/rr2zF0eAk=;
	b=pXaYqF7AtVd7UPKeM072PB600qibhD7sgAvW+OFN6NsoRYrA9p6Vh3Nb3H6xtvKtjEQao4
	aanXlJMN5r75mWVmGrwjPo8BXgz6fclvvpzvgEPwvL8T6pUdNtQ44p6UmpgF5Ks/iUDnLN
	fw/qIJwVD1bMU8ZkAMfyDRgiUOHPmhY=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [kvm-unit-tests v2 0/8] More tests for selective CR0 intercept
Date: Tue, 28 Oct 2025 22:12:05 +0000
Message-ID: <20251028221213.1937120-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add more test cases for the selective CR0 write intercept, covering bugs
fixed by
https://lore.kernel.org/kvm/20251024192918.3191141-1-yosry.ahmed@linux.dev/.

Patches 1-6 are cleanups and prep work. Patch 7 generalizes the existing
test to make it easy to extend, and patch 8 adds the actual tests.

v1 -> v2:
- Fixed author and Signed-off-by.
- Added fix for skip return codes.

Yosry Ahmed (8):
  scripts: Always return '2' when skipping tests
  x86/svm: Cleanup selective cr0 write intercept test
  x86/svm: Move CR0 selective write intercept test near CR3 intercept
  x86/svm: Add FEP helpers for SVM tests
  x86/svm: Report unsupported SVM tests
  x86/svm: Move report_svm_guest() to the top of svm_tests.c
  x86/svm: Generalize and improve selective CR0 write intercept test
  x86/svm: Add more selective CR0 write and LMSW test cases

 lib/x86/desc.h       |   8 ++
 scripts/runtime.bash |   4 +-
 x86/svm.c            |   9 ++-
 x86/svm.h            |   1 +
 x86/svm_tests.c      | 178 ++++++++++++++++++++++++++++++-------------
 5 files changed, 146 insertions(+), 54 deletions(-)

-- 
2.51.1.851.g4ebd6896fd-goog


