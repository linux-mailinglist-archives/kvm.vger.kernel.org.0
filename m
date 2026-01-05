Return-Path: <kvm+bounces-67008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 849F2CF219C
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 07:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EBCC330169B4
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 06:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF7C2BF3E2;
	Mon,  5 Jan 2026 06:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nz+OIe8f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5FE221290;
	Mon,  5 Jan 2026 06:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767596048; cv=none; b=I/CvHi5sgBU9HQKSrEjyTxH+oxr2LFgYh9aRp4JIkhCEgriplctT3G/HByFVUavOPgN4rW4ycPGVA5F7pVePXwrnY4ZM+eWsKRFgePZt5ofMbbhE3JErk1Aienb+h3g1ajH2mIAN5S2751rjb5ngbqxdTtHZxn3IlojCMbAhR0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767596048; c=relaxed/simple;
	bh=DEctsADH880App+VadckP3y49LYgnibRgqXhRiKIws4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=icAkPpFW//DHOjB+djwwDHejqrvPy5qyZrjuuOgqFx2ezlIppKpk7PVGjJDC49k5P79cU8dNH/K8AYEpmZCV7HzrGaw/ZXRM8/YMsAVhsT3M0FGcVtL05OQPi7H2apj/abP+Z4I/xxdKZkZ8GdtmZBk2baO26BapcfFsqXvbo28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nz+OIe8f; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767596047; x=1799132047;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DEctsADH880App+VadckP3y49LYgnibRgqXhRiKIws4=;
  b=nz+OIe8fP0BHN90ebunpg4PhyTUgfz3/6eSduAfMgUFH9ubV7ZqS5le6
   HPm9T0k+qe9Pi/h3q59qnsZvjNg5IXt6wVwTidyc8k4JnP1XDjsvGOGg7
   a28apqLsHG0JjqQEmBCAVOMohy/8J7WLl4a2eEJw2wKCBYpzMkAYXRIOn
   W9NswUuR2t+5MchsmAeg5g7GfLZ8c5GhhLFQu3ZZh4XAvN7wYo0gjIfSH
   srcPA7VRva/cs4q3e4HApXKYH3l6SpDC0b0fGx/J38XIkNHn2QRyAP7Br
   olk9chDvAD+1NF0vdN9dKqh0ET5tlKDintux3CH8F4o8zIE7sSMfaKFm4
   A==;
X-CSE-ConnectionGUID: 7pFrGle3TpOoCkHCrPEoUg==
X-CSE-MsgGUID: rXeLxl9WQ5S1kFXbBIuWxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11661"; a="68865037"
X-IronPort-AV: E=Sophos;i="6.21,203,1763452800"; 
   d="scan'208";a="68865037"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2026 22:54:04 -0800
X-CSE-ConnectionGUID: xzsjVdQHQdyoSPig5MamUQ==
X-CSE-MsgGUID: GtCRKxYzTqu5qyF5Pbc/HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,203,1763452800"; 
   d="scan'208";a="206868612"
Received: from ubuntu.bj.intel.com ([10.238.152.35])
  by orviesa004.jf.intel.com with ESMTP; 04 Jan 2026 22:54:02 -0800
From: Jun Miao <jun.miao@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: tglx@linutronix.de,
	dave.hansen@linux.intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jun.miao@intel.com
Subject: [PATCH] KVM: x86: align the code with kvm_x86_call()
Date: Mon,  5 Jan 2026 14:54:23 +0800
Message-Id: <20260105065423.1870622-1-jun.miao@intel.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The use of static_call_cond() is essentially the same as static_call() on
x86 (e.g. static_call() now handles a NULL pointer as a NOP), and then the
kvm_x86_call() is added to improve code readability and maintainability
for keeping consistent code style.

Link: https://lore.kernel.org/all/3916caa1dcd114301a49beafa5030eca396745c1.1679456900.git.jpoimboe@kernel.org/
Link: https://lore.kernel.org/r/20240507133103.15052-3-wei.w.wang@intel.com
Fixes 8d032b683c29 ("KVM: TDX: create/destroy VM structure")
Signed-off-by: Jun Miao <jun.miao@intel.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff8812f3a129..b66c441187ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13307,7 +13307,7 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 #endif
 
 	kvm_mmu_pre_destroy_vm(kvm);
-	static_call_cond(kvm_x86_vm_pre_destroy)(kvm);
+	kvm_x86_call(vm_pre_destroy)(kvm);
 }
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
-- 
2.32.0


