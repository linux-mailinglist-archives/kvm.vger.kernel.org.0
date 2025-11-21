Return-Path: <kvm+bounces-64253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 780ADC7BAC3
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 21:50:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31B503A703C
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 20:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21BAF3093DD;
	Fri, 21 Nov 2025 20:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q6uK37Op"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B42306B15
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 20:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763758119; cv=none; b=EtzbMKYo3QtYQepoKBMJhWxzMD3CCVGWDkAOFhF5JYWfuAV1PTlfGW0rmsNpOWQERB+sUz3D45vVn+0LvFCzoJfqukVZZAosE2c7TNRh5MVphuBrol+mSj09ej6CfbKSVWWSQ9Vi3y581P54VkrrBgV5GVpyk7w0QzBEkeCKfDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763758119; c=relaxed/simple;
	bh=qyre18cpOKvxwwzmBDasMYxqf6NTszu6HKVwU/jZ7cA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r6Zn+GBCic1A0KDqCvqnu6D7FSP3NP+TpzXH2Z3FDdr9Fiiaw150LbMkzh7p/XioFL0azuM8Dn22EQq7sZw9jcbQQxyAIBugu981gW5msBAvtiZs8L+aqRagrY+a/4C2vEeI26P3i3z/Oq1qjAbjdE700b8E2dIHTpMHd5nmt3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q6uK37Op; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763758105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zkkn6Am/KVdd3EYkVVX2Yi8kvfVxaybnM5xNkbH18cY=;
	b=Q6uK37OpHpOSOOKSRCWoblfsRJKUjwFg6wdRp2Na9VLglN51zpwTOpoUSDR4kc9wzkKIz+
	WDyE2bJP7pWvwJP0zHOhQL18UNtrtLT9I1MRelu8KDU13tgjhiNAo3HomzII3mjlZcsSG7
	T5aQWFbddAC3tk3YoV9r7ML0zwi+oUg=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 0/4] KVM: SVM: GIF and EFER.SVME are independent
Date: Fri, 21 Nov 2025 20:47:59 +0000
Message-ID: <20251121204803.991707-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Clearing EFER.SVME is not architected to set GIF, so GIF may be clear
even when EFER.SVME is clear.

This is covered in the discussion at [1].

v2 -> v3:
- Keep setting GIF when force-leaving nested (Sean).
- Moved the relevant selftests patches from the series at [2] here
  (Sean).

v2: https://lore.kernel.org/kvm/20251009223153.3344555-1-jmattson@google.com/

[1]https://lore.kernel.org/all/5b8787b8-16e9-13dc-7fca-0dc441d673f9@citrix.com/
[2]https://lore.kernel.org/kvm/20251021074736.1324328-1-yosry.ahmed@linux.dev/

Jim Mattson (2):
  KVM: SVM: Allow KVM_SET_NESTED_STATE to clear GIF when SVME==0
  KVM: SVM: Don't set GIF when clearing EFER.SVME

Yosry Ahmed (2):
  KVM: selftests: Use TEST_ASSERT_EQ() in test_vmx_nested_state()
  KVM: selftests: Extend vmx_set_nested_state_test to cover SVM

 arch/x86/kvm/svm/nested.c                     |   6 +-
 arch/x86/kvm/svm/svm.c                        |   1 -
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +-
 ...d_state_test.c => nested_set_state_test.c} | 128 ++++++++++++++++--
 4 files changed, 120 insertions(+), 17 deletions(-)
 rename tools/testing/selftests/kvm/x86/{vmx_set_nested_state_test.c => nested_set_state_test.c} (70%)


base-commit: 115d5de2eef32ac5cd488404b44b38789362dbe6
-- 
2.52.0.rc2.455.g230fcf2819-goog


