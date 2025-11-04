Return-Path: <kvm+bounces-62013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 56997C32CAD
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 20:33:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 52D1B4EEE2E
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 19:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0765A8F54;
	Tue,  4 Nov 2025 19:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f8DSTozB"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC181C5F1B
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 19:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762284675; cv=none; b=bT+AL2sYTXyNIzewu8WFsngVAl6lBVDhTvsYYCeMRwP1kA1CIS+8F7g6GazMKDdm4+DVMcQ81nN7LXebPmUqu1vrD/LMnPRDJDNOtVB+CCG2+PAH6dwOe43gLZarG1pJewLzKMQePqFTmYGnvPHnqHsn0sLQdpD5ZNZ67CHhcs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762284675; c=relaxed/simple;
	bh=sGEOviCX7dYiClvI4xLNYqTLcq5mTrhpD+YS+76yE9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h3iV9bjNO8HzHEPZKlwu+PwXuWhxMEFzcFiE7Ih+x8ouz/49odmRV/6Xu/FokOPyRgb0FWm+Xsx6aSqdPNfytdgt255El64sBPOMl8x41ejN32NG+pLHXTu6iDrCMTtWztOG6fiFHVmIU3jn75lIrqufHExoTI33e1HMg81H+/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f8DSTozB; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762284660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=W7JHzLrqhTOnxhOGNyOPD/lObWqXqiMPXLvjl24ftjQ=;
	b=f8DSTozB4RKUqDYJA8uxIaSk2SHQrT6Ze7KOwurwja2ukxz0l0bqAaOROqCMf6G8YWmiWZ
	ivKE2Uq2vQZ9l4TsvDsSZEPGa51FeXIeXS2+8M9zlER2qM7gls8uTnMcKWtMicANNzxA2C
	UIZzeQD0Jo72CZjQtVRUG4xMw+FCcBg=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [kvm-unit-tests 0/4] Misc fixups/cleanups for nested tests
Date: Tue,  4 Nov 2025 19:30:12 +0000
Message-ID: <20251104193016.3408754-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A group of misc cleanups and fixups for SVM and VMX tests.

Disclaimer for patch 3: I have no idea why #UD was used to convey
failure from the guest when report() is usable, so I might have missed
something there.

Disclaimer for patch 4: I did not look too closely into why the flake is
happening. It seemed like there was an adhoc approach to stabilize the
test (shift duration by 24 bits), so I just made the necessary
adjustment to make the test stable on Turin.

This series is based on a different SVM series to avoid conflicts:
https://lore.kernel.org/kvm/20251028221213.1937120-1-yosry.ahmed@linux.dev/

Yosry Ahmed (4):
  x86/vmx: Skip vmx_pf_exception_test_fep early if FEP is not available
  x86/svm: Print SVM test names before running tests
  x86/svm: Replace #UD on failure in LBRV tests with proper report()s
  x86/svm: Deflake svm_tsc_scale_test

 x86/svm.c       |  1 +
 x86/svm_tests.c | 19 ++++++++++---------
 x86/vmx_tests.c |  5 ++++-
 3 files changed, 15 insertions(+), 10 deletions(-)

-- 
2.51.2.1026.g39e6a42477-goog


