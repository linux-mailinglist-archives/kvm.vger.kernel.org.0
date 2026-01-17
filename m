Return-Path: <kvm+bounces-68428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7994ED38B1A
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 02:18:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 856143018348
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 01:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D7CE238166;
	Sat, 17 Jan 2026 01:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SyTwoEL9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD8E225A38
	for <kvm@vger.kernel.org>; Sat, 17 Jan 2026 01:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768612692; cv=none; b=fs0uipxyHrOD8Io4DGzojoyq1NTBUna0dsOB/+DNQK9UjDF4ibNEDkmOAZQegsj8NItOxq+2DgMlknDanGURgdMehPz4QfBRDtBaqq8KvrhB2m1w52GrOOiKbwQuZAMyuVhmYLcQUysvlR/ftTQtbsIWE2N6+QQX/u4fgf30SgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768612692; c=relaxed/simple;
	bh=2R2pFzeaXsFhmsgZPzDgKDW8nxLi3n1LYVYLNZ0AwJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRZxe0MKgrJUPdiTebEdHi4sKIkMKuy9xDC84fvQnoRQ596CHpmqDyyCm0E/SjZmOpe2sXJsvpCB0XwLjysD8aKjteOSM2WiPS4D/9w1Wf882evYT0kjp6wJLiVdxENmi7SfVMEnczAaCFNq3C7SLsiiXOqrw57hioXhjXRRVFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SyTwoEL9; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768612691; x=1800148691;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2R2pFzeaXsFhmsgZPzDgKDW8nxLi3n1LYVYLNZ0AwJ8=;
  b=SyTwoEL9mpPQwVBH9qWXR5PZpraf9NuWdzJUQzSwNaasxq+Q+jI7WnDv
   FC/cQ9QjCuI7rR69SH8BmE2dT8oueHyF4qBEsXwKnI3DZxneyPk5qrZY9
   ZwQfmRTFd57eRlD8aIPpE2iLBO1+f1ChVp7r7KMnwXbvnD1HGCTonktg7
   SFGespBrorLHPmfpSG1J70pEmj9Fx7A2SLSqWngrCTLihYVgpM+TOTAvN
   dxlin9tvAIyqC6UsDLLQ0hh5aUczjRHUsbmYCPkEEnsLnORR7guD9wedV
   AA4pQYc6erNUYQx5wY+DrmaTq/PzcvFuEywR24sXnfIL5wLDQCl7ZLhzl
   A==;
X-CSE-ConnectionGUID: OfHR57dVSG28JAaQmLoTyQ==
X-CSE-MsgGUID: 9nZHxgHjQ6iwKJT6fmRn8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="69131171"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="69131171"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 17:18:09 -0800
X-CSE-ConnectionGUID: BTMa7AWnQjGZUDSRdc2D5Q==
X-CSE-MsgGUID: ycrDxFSbRPaAZpXUWTRNtg==
X-ExtLoop1: 1
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 17:18:09 -0800
From: Zide Chen <zide.chen@intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Cc: xiaoyao.li@intel.com,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH 6/7] target/i386: Make some PEBS features user-visible
Date: Fri, 16 Jan 2026 17:10:52 -0800
Message-ID: <20260117011053.80723-7-zide.chen@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260117011053.80723-1-zide.chen@intel.com>
References: <20260117011053.80723-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Populate selected PEBS feature names in FEAT_PERF_CAPABILITIES to make
the corresponding bits user-visible CPU feature knobs, allowing them to
be explicitly enabled or disabled via -cpu +/-<feature>.

Once named, these bits become part of the guest CPU configuration
contract.  If a VM is configured with such a feature enabled, migration
to a destination that does not support the feature may fail, as the
destination cannot honor the guest-visible CPU model.

The PEBS_FMT bits are intentionally not exposed. They are not meaningful
as user-visible features, and QEMU registers CPU features as boolean
QOM properties, which makes them unsuitable for representing and
checking numeric capabilities.

Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
---
 target/i386/cpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index f1ac98970d3e..fc6a64287415 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1618,10 +1618,10 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .type = MSR_FEATURE_WORD,
         .feat_names = {
             NULL, NULL, NULL, NULL,
+            NULL, NULL, "pebs-trap", "pebs-arch-reg"
             NULL, NULL, NULL, NULL,
-            NULL, NULL, NULL, NULL,
-            NULL, "full-width-write", NULL, NULL,
-            NULL, NULL, NULL, NULL,
+            NULL, "full-width-write", "pebs-baseline", NULL,
+            NULL, "pebs-timing-info", NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
-- 
2.52.0


