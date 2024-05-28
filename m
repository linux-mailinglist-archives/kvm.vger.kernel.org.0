Return-Path: <kvm+bounces-18205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA638D1881
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 12:25:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 728FA287EBA
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 10:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43FB816B732;
	Tue, 28 May 2024 10:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IstFOatD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BF316ABFD
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 10:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716891884; cv=none; b=joTcvKdrorwcTxjIQp4tPDKmoS31wht4/iORfX9bT1WHpYyK9bXlYJJA0Qpz+aQoU8VLqD4jZnYUVOpgzJNCmt+KegUaqiPFEyEc+SYUNOEXQtfNEOtciOkuMWpfJf9B0Mt105CX9FYJVx0lefVsuiWSBr7DZvbOw1mTb9vsa3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716891884; c=relaxed/simple;
	bh=YjJ0k+pOAS44d5nj8lm5HLkettkpCAfbZHsZZjd9+Ek=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YnkxUERg/2HHbkVg+r6XIOc2OIAIBq2tSNxwBwGgqvtDVlext6jhp6X03LbNPeLc0c3snU2Ulk7hk/GoQSBfFxZMwAP0i2b/b5BIkOs4W+XxxWIwSsgHEqvIqBzjrWUg07iVwdj9wWKMUtzTdT9u4bkRRbkgcJ9GPfjjNBjBzWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IstFOatD; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716891883; x=1748427883;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YjJ0k+pOAS44d5nj8lm5HLkettkpCAfbZHsZZjd9+Ek=;
  b=IstFOatDDJee9T7Q0yxSRcHUGE2s9sda5ZiCK4DwJsRAOmV09asnBp+K
   jBg0qFXQlcCilB1pV13GB9kxKd1D1Cjrd5Fb+Og+6RiTv5poAczFD66ki
   0+nPppjtYWdabb7L1AFWH0YsQ+y/UiVMyAKJz5280BzbGh7uImctshQQl
   1xSovVQyaEYzXfA7mxD5IwtDFcZDSHbbtN3jIH0cPs5K2NnREagouZzHV
   1UKH4HeEQcp8vq7rIC0LyOZ7NAIjF5SFSA95s2fzR/oc9fnyQmPbLtOve
   DD2YxHH+iMmM8Uy8Y8OB6CeAsPL5H+f7XPw9+sPjw/udLfLJ1xvJLgAMM
   A==;
X-CSE-ConnectionGUID: VmRBeMW3Tte94aHcPM1/wA==
X-CSE-MsgGUID: WMxEwsMsRIOfL51meqNDFg==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="24643325"
X-IronPort-AV: E=Sophos;i="6.08,195,1712646000"; 
   d="scan'208";a="24643325"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 03:24:42 -0700
X-CSE-ConnectionGUID: JuXG3OPlTQGyf3S3nN74Bw==
X-CSE-MsgGUID: 2LWP5zEQQmiHzrW0zQhURQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,195,1712646000"; 
   d="scan'208";a="35644895"
Received: from unknown (HELO st-server.bj.intel.com) ([10.240.193.102])
  by orviesa007.jf.intel.com with ESMTP; 28 May 2024 03:24:40 -0700
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	xiaoyao.li@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH] KVM: x86/mmu: Don't save mmu_invalidate_seq after checking private attr
Date: Tue, 28 May 2024 18:22:34 +0800
Message-Id: <20240528102234.2162763-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop the second snapshot of mmu_invalidate_seq in kvm_faultin_pfn().
Before checking the mismatch of private vs. shared, mmu_invalidate_seq is
saved to fault->mmu_seq, which can be used to detect an invalidation
related to the gfn occurred, i.e. KVM will not install a mapping in page
table if fault->mmu_seq != mmu_invalidate_seq.

Currently there is a second snapshot of mmu_invalidate_seq, which may not
be same as the first snapshot in kvm_faultin_pfn(), i.e. the gfn attribute
may be changed between the two snapshots, but the gfn may be mapped in
page table without hindrance. Therefore, drop the second snapshot as it
has no obvious benefits.

Fixes: f6adeae81f35 ("KVM: x86/mmu: Handle no-slot faults at the beginning of kvm_faultin_pfn()")
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 662f62dfb2aa..4372df109aff 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4400,9 +4400,6 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			return RET_PF_EMULATE;
 	}
 
-	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
-	smp_rmb();
-
 	/*
 	 * Check for a relevant mmu_notifier invalidation event before getting
 	 * the pfn from the primary MMU, and before acquiring mmu_lock.

base-commit: 2bfcfd584ff5ccc8bb7acde19b42570414bf880b
-- 
2.34.1


