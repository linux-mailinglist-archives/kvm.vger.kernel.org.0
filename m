Return-Path: <kvm+bounces-21722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F4BE932C74
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 17:55:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05C0B1F245EA
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 15:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 413ED19F49D;
	Tue, 16 Jul 2024 15:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T7+uLY78"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84F119E7FF
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 15:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145314; cv=none; b=snTmw+yTPw5/QaY/dKmy+tEEwEwXJ0M4rFsh7puTAqLkzwtmbYt0ItMzOGBtOpRtejyIuMGCPlmvxh0/NsEqO4s9LzODPsdSPY1qHSiIrUQAjFUQE07nJNj+DtOXyMlwf4A1RspSItmj80h1nu3Sskr+7T+eXEo/i8jwvFeLtP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145314; c=relaxed/simple;
	bh=B5vJZl3GqGpi4ZMN7bXhTOBiKFTJgl07sNS3UgXe2sI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dE7+1gSBWuWJwj/+g+kDXoyGaeGWw7RonRqZUxmx9HG3ykc5o6VKyxNpUWwjsBlEA63FgZqA87RuIY50rPlbXcur1c8FCUODsW/Yi/A+DwFz4jgRVBIyqb9bPsdoVhCqPT8oDZxZgQZ1q6LS1t2rlVATdXF+i5SxiiRW958gCLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T7+uLY78; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721145313; x=1752681313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B5vJZl3GqGpi4ZMN7bXhTOBiKFTJgl07sNS3UgXe2sI=;
  b=T7+uLY78iFXlRz7bouukX61XrFQQruMUW7FZzYj7Rx5OQhqvKF2tbZ9S
   yJeM6/SZG5bnYcWLlW9LrAZ5s91QSSbnOyBLvPepDTVORg7zbTuLqumDJ
   On3OGw5zqd2Byk3IO+phi0Ex7LjB+vvFlAEmPlNxV0Ypd97YHYDv+dO21
   Z+q6IVhy6zRo3USJzl6UBrVxGa00KmSLaitcfvKOiP4SsIPplOdleBIQn
   sZhKNyNUT4v6vlcHPRaGoRK2VLy6nK79YtFiMDGrqg7LCuWWqztj7cJcy
   h3Dvsp7jpMbI/V6257W4WBLSagVANrtwxv7FmDAvSYHdnqxeaNQmz4McQ
   Q==;
X-CSE-ConnectionGUID: b92K6GB3SG+IRV3oJMowJQ==
X-CSE-MsgGUID: QyCwz7JzRHyR/YF2So5q9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18743740"
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="18743740"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 08:55:01 -0700
X-CSE-ConnectionGUID: 2Us6OEw8Rd6FZEhJVEzsuw==
X-CSE-MsgGUID: 5U/udOlBQVeQubgAu3I7zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="50788355"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 16 Jul 2024 08:54:58 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 5/9] target/i386/kvm: Drop workaround for KVM_X86_DISABLE_EXITS_HTL typo
Date: Wed, 17 Jul 2024 00:10:11 +0800
Message-Id: <20240716161015.263031-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240716161015.263031-1-zhao1.liu@intel.com>
References: <20240716161015.263031-1-zhao1.liu@intel.com>
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
---
 target/i386/kvm/kvm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 64e54beac7b3..4aae4ffc9ccd 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2728,10 +2728,6 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
 
     if (enable_cpu_pm) {
         int disable_exits = kvm_check_extension(s, KVM_CAP_X86_DISABLE_EXITS);
-/* Work around for kernel header with a typo. TODO: fix header and drop. */
-#if defined(KVM_X86_DISABLE_EXITS_HTL) && !defined(KVM_X86_DISABLE_EXITS_HLT)
-#define KVM_X86_DISABLE_EXITS_HLT KVM_X86_DISABLE_EXITS_HTL
-#endif
         if (disable_exits) {
             disable_exits &= (KVM_X86_DISABLE_EXITS_MWAIT |
                               KVM_X86_DISABLE_EXITS_HLT |
-- 
2.34.1


