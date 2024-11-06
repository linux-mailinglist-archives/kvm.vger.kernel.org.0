Return-Path: <kvm+bounces-30837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B9D79BDD35
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:50:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D77B2B23797
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:50:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38B3D191499;
	Wed,  6 Nov 2024 02:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dNaqAnjf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7DD18B47E
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 02:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730861409; cv=none; b=J6bDfDdSpEt9OERHJ/AnoxNxYRfyntyMj89Q+56f0KiN067RNUTiEFys8j2U7m+5KZA8hfUjMKkUiTb7L8VuzmZbuVaFoyRf8HSRoWzgGK1LLwBR9KZ58O7osUcF9xCk5Tt8yanIEMNVxqw9fiDXcVqTfV28A+9dk4Z27kMXoQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730861409; c=relaxed/simple;
	bh=M4sDt9QkECcSbT07XJdCv1wUJiDP78YRHjt03Sbegi4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L/B53XNLRa0zhTBuZxFOH9fH53Qs6QvdWz6Rl6BmW1B+C4ruJr2rpom/HNPsGtuvLxtINoB1OpcWR91T32NFyrAkMC2OjaRYR4HQzqdAXRr5GRnu7BxmNi/1AgBaTU3ruUtZv0q+QZ1v2r39D9hdWJHPyMb8lDg3FgcDtKw67gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dNaqAnjf; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730861408; x=1762397408;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M4sDt9QkECcSbT07XJdCv1wUJiDP78YRHjt03Sbegi4=;
  b=dNaqAnjfDLvwEbcynU4WrFQBWBSlcSuBCLnYfMal+3HEcZTnMyR6arom
   Mooa/3T3bfMy1KCvqOW92A2e+EEaM+kGxTyDiMk9SrvW6Tnge37Tri1r4
   WZGQXRqGH9EQGcd6D/t9kNN9+rpdhMfH1uuyGUh5OeLOQc+OIQQv5ahdf
   wR6gvSQxTBTSG6/B9FMjvm/bMYy1ElCOvqzTdhBVyKcr5j7H3ZFtjq/wc
   D2jBOhBFTkHwOQvS7K+Et9r5a8Hvp0qyNSauXxjBkKIJQIbqMZ49m2MD8
   KT5j7BeQ0A2C05fhhDp00yKqDKqNwuoke6aV2Y4h7OK1ANIPaCpJD7YWl
   w==;
X-CSE-ConnectionGUID: DDuj7ppUQSC47wOA4zFSfA==
X-CSE-MsgGUID: sdbvqcjYQvCemmBsW0V93A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30492279"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30492279"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:50:08 -0800
X-CSE-ConnectionGUID: Ynv9OBZpTo6N0P/HesUs/Q==
X-CSE-MsgGUID: +GUGd9ljSzuNoTo1fYV/8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="115078006"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 05 Nov 2024 18:50:05 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 06/11] target/i386/kvm: Drop workaround for KVM_X86_DISABLE_EXITS_HTL typo
Date: Wed,  6 Nov 2024 11:07:23 +0800
Message-Id: <20241106030728.553238-7-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241106030728.553238-1-zhao1.liu@intel.com>
References: <20241106030728.553238-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM_X86_DISABLE_EXITS_HTL typo has been fixed in commit
77d361b13c19 ("linux-headers: Update to kernel mainline commit
b357bf602").

Drop the related workaround.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
---
 target/i386/kvm/kvm.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index b175cd4a4bcb..1fb4bd19fcf7 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3085,10 +3085,7 @@ static int kvm_vm_set_tss_addr(KVMState *s, uint64_t tss_base)
 static int kvm_vm_enable_disable_exits(KVMState *s)
 {
     int disable_exits = kvm_check_extension(s, KVM_CAP_X86_DISABLE_EXITS);
-/* Work around for kernel header with a typo. TODO: fix header and drop. */
-#if defined(KVM_X86_DISABLE_EXITS_HTL) && !defined(KVM_X86_DISABLE_EXITS_HLT)
-#define KVM_X86_DISABLE_EXITS_HLT KVM_X86_DISABLE_EXITS_HTL
-#endif
+
     if (disable_exits) {
         disable_exits &= (KVM_X86_DISABLE_EXITS_MWAIT |
                           KVM_X86_DISABLE_EXITS_HLT |
-- 
2.34.1


