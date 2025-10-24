Return-Path: <kvm+bounces-61066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E48E1C07F73
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 21:51:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F516404992
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 19:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4AFE2DE701;
	Fri, 24 Oct 2025 19:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="krINLBuj"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CFF2D949F
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 19:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761335392; cv=none; b=lGeNdQwXxWIEhp1sH5yb7Qd9VZ/u4ep50xu9HP9zAc9Zd5EcGhM5gRT67K7Anf2nlC8mZYbmv9ZmwJbvjka8TlmUMqkQtUwznamYBr4XQw10oE+xUvbT3I4fm2ov4WX/5U3rRrA7SAI/2kWzyZQGEcp9e7XSf0bq99AUjCEpgIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761335392; c=relaxed/simple;
	bh=0YY0+byixgPTOxUuwNhZ2WaLXRHmYynDes+aMFzWqrw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UaNXnPkS32coiOkSuSPCtFCXCjbERb1BAG4dANtI2KYqFG1Fj2N/2V5/LyFonR7gRtoAQwaIdsZlXFplis+iHA1k0vKrUNK7ckLRuoWRaZ12WXCxIMts7HhlDVmnRdNPtAzNs+pOeG8dFFiDkuWnIXEF7Kfv6j3QWi4CfXRMReo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=krINLBuj; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761335378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vllfWIu9vuciLFHNcZvUb5oqxGmTyqYKUXBTT9jzeUk=;
	b=krINLBujvM+taXhIbCRtxLXCoA73uyjXP5V39MBrq24SEzsLyCIjZgi71+7E/ZbGyakiZe
	QQCH7x0DmgNhvaZ96/WYfatgQDq0YiT8l+LjM0MjVk6vqyjavpKobdiOEaP7Qx+4zrz43c
	fLltXB4F9oUm2m6+XrnJwbWLWcBnOmI=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [kvm-unit-tests 0/7] More tests for selective CR0 intercept
Date: Fri, 24 Oct 2025 19:49:18 +0000
Message-ID: <20251024194925.3201933-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Yosry Ahmed <yosryahmed@google.com>

Add more test cases for the selective CR0 write intercept, covering bugs
fixed by
https://lore.kernel.org/kvm/20251024192918.3191141-1-yosry.ahmed@linux.dev/.

Patches 1-5 are cleanups and prep work. Patch 6 generalizes the existing
test to make it easy to extend, and patch 7 adds the actual tests.

Yosry Ahmed (7):
  x86/svm: Cleanup selective cr0 write intercept test
  x86/svm: Move CR0 selective write intercept test near CR3 intercept
  x86/svm: Add FEP helpers for SVM tests
  x86/svm: Report unsupported SVM tests
  x86/svm: Move report_svm_guest() to the top of svm_tests.c
  x86/svm: Generalize and improve selective CR0 write intercept test
  x86/svm: Add more selective CR0 write and LMSW test cases

 lib/x86/desc.h  |   8 +++
 x86/svm.c       |   9 ++-
 x86/svm.h       |   1 +
 x86/svm_tests.c | 178 ++++++++++++++++++++++++++++++++++--------------
 4 files changed, 144 insertions(+), 52 deletions(-)

-- 
2.51.1.821.gb6fe4d2222-goog


