Return-Path: <kvm+bounces-60981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29312C04878
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A55C93BA653
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57D5D277C98;
	Fri, 24 Oct 2025 06:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GyeUTwBt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A9E23F422
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 06:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287760; cv=none; b=P9Hi5Dsdt6ndmR6aS/QF+0NwJMfT6EVT3TtXAJ4J1xFI7JRJhUdVRNLjFYVnHSxPxZUGNhwGvNUrnEHKDMZpSzEQayrRObufyWDm6k0YdQ6RVMBq0n9xecTkq61JdCG6pcTVeHp993CWxhyWV2YzH/Tc815oXgZ76TOtOYdErSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287760; c=relaxed/simple;
	bh=lvXbWhX2/gbG5ptIM2y2HLMUjmWF0PjSAkFcXZ7TvjU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ahmCORsJCYXmthVf2S1GH0F5l9XUKVkv4TyBZKdvyuiZxizx+N2hBl9YHtGOWYhCMJC5kjRTFccLLV8vBTVq38vFHJR8u2Hz4A3RcyWa5HNezQyTV+gsf/X9Hihq4VVYl8BcmbABz0L0Rh9kMw4i51X8+H6PgJrdnqgY5CGhmzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GyeUTwBt; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761287759; x=1792823759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lvXbWhX2/gbG5ptIM2y2HLMUjmWF0PjSAkFcXZ7TvjU=;
  b=GyeUTwBtw+v5goORDgYK+fOQbkFg7kzRDE1BIZfQli7qUnSSLNFUT2gG
   3VS+g3R38ZyQoDnRWx61EhIXmTlrNQXLfRIxn6Xzz3omUWvD711W255lU
   SlcxNwus23yN3FddfOaxrmnK+yg/NOrprkRCH5v1g/rHf+ifYhnGZGFna
   vrs3ymVJuP2WQjBSDjXVvW1Zu3OqmzCiMsKQyVS6JdepqPIb3Tn3O6orX
   plNeIQN3ClM804wN1MjF5dzSwOUYT+cj4dsd5jgcnNrMZlnOp+VcWZAah
   Q4nvQeogLi1iw4jmMnofYucEJAI2gy1lGNBZ2jL4qlfjiK0xD5pM5+jzP
   g==;
X-CSE-ConnectionGUID: EgAeQwOpTLGdaXRRok3A6w==
X-CSE-MsgGUID: Aw2xV89MT/u3dhc0JY/DTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="67332692"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="67332692"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 23:35:58 -0700
X-CSE-ConnectionGUID: gOpFmPulTYawoqbWtdGs6Q==
X-CSE-MsgGUID: CoV1hSAoSN+SYf2/kQ6vuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="184276197"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 23 Oct 2025 23:35:52 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v3 20/20] i386/tdx: Add CET SHSTK/IBT into the supported CPUID by XFAM
Date: Fri, 24 Oct 2025 14:56:32 +0800
Message-Id: <20251024065632.1448606-21-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251024065632.1448606-1-zhao1.liu@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chenyi Qiang <chenyi.qiang@intel.com>

So that it can be configured in TD guest.

And considerring cet-u and cet-s have the same dependencies, it's enough
to only list cet-u in tdx_xfam_deps[].

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/tdx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index a3444623657f..01619857685b 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -526,6 +526,8 @@ TdxXFAMDep tdx_xfam_deps[] = {
     { XSTATE_OPMASK_BIT,    { FEAT_7_0_EDX, CPUID_7_0_EDX_AVX512_FP16 } },
     { XSTATE_PT_BIT,        { FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT } },
     { XSTATE_PKRU_BIT,      { FEAT_7_0_ECX, CPUID_7_0_ECX_PKU } },
+    { XSTATE_CET_U_BIT,     { FEAT_7_0_ECX, CPUID_7_0_ECX_CET_SHSTK } },
+    { XSTATE_CET_U_BIT,     { FEAT_7_0_EDX, CPUID_7_0_EDX_CET_IBT } },
     { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_BF16 } },
     { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_TILE } },
     { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_INT8 } },
-- 
2.34.1


