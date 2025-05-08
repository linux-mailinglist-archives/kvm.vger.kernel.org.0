Return-Path: <kvm+bounces-45942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A838AAFEAB
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:13:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86A7F98020E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7ABC2874ED;
	Thu,  8 May 2025 15:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UQDQJGZ0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8497A286D67
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716817; cv=none; b=fYZtFykrsYFtnszKSS11BCmquUj+8XYEl5oBKFh3bebWSnie3H68mDsuV43qkmNp0Z6RDdB7CEc8YF//xnWwAhrGatjB82iQtVpabOuEkOybIJRl+xdsrCksxI+sPXTNvnF8JCWGEdQYfp7+HQO2iHB/+NNjd/L8Y3w4j6sXvS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716817; c=relaxed/simple;
	bh=1qnlOprVK3MdQoixP1szQxSRRb7y8B3B7r4pINMCmiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIhxl3pXKukydED3IBHRvN2Hn4rkAN8IoobLteLeLTV/nX/boUsYAILGn5ocH7wuH9w7fzEU8RMoqN5XdVqdo4f3aKiUPrNGCrjy5WGO8rfuLF2ddFbU56eGHre87Y99XqhynziZd/hpiIy4F6WIICPjTlzwOjwiBAMOvrKw6Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UQDQJGZ0; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716815; x=1778252815;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1qnlOprVK3MdQoixP1szQxSRRb7y8B3B7r4pINMCmiY=;
  b=UQDQJGZ046kBgWTIcku3QWqtXyFcethc+YPUPhCj1TycqDwyhxvsO2hr
   kAzEdDBfrHBNN1AU/csShoB2kga4vIyMNLBfl5epoMXiRuly+/sEeAR4N
   o5tfBFWom0194JhmQoKktitQBtcvXkFIDPIpi6h3aZwfUP3kHyZq58Y7s
   uvMfUUKPGds5xA4LHlJU+m68/fUsBl4w724HlCog3OXnLvWND/kDmNVym
   0EWUmqih0VeexgZGRWSJbzDahZ+UienSU+JN7d6xB0ZajIdIj/KIFXdIn
   0E9dEmSE2r91B0Fa4iW3kUNrHgYRZd1RTiaCBXnSQsulbM9Fw+8fuRDcY
   Q==;
X-CSE-ConnectionGUID: sOdVwSpiSJC+NpMMLAAtew==
X-CSE-MsgGUID: 0sgvTXhLSh+BG69VUJZ2Lg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888372"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888372"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:55 -0700
X-CSE-ConnectionGUID: YX9p/xJ5SACZvsGSzrgqJQ==
X-CSE-MsgGUID: 913C9maRSu2fhQ3hgBQgnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440323"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:52 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 39/55] i386/tdx: Don't synchronize guest tsc for TDs
Date: Thu,  8 May 2025 10:59:45 -0400
Message-ID: <20250508150002.689633-40-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TSC of TDs is not accessible and KVM doesn't allow access of
MSR_IA32_TSC for TDs. To avoid the assert() in kvm_get_tsc, make
kvm_synchronize_all_tsc() noop for TDs,

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 741b50181ed9..ead1d0263385 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -327,7 +327,7 @@ void kvm_synchronize_all_tsc(void)
 {
     CPUState *cpu;
 
-    if (kvm_enabled()) {
+    if (kvm_enabled() && !is_tdx_vm()) {
         CPU_FOREACH(cpu) {
             run_on_cpu(cpu, do_kvm_synchronize_tsc, RUN_ON_CPU_NULL);
         }
-- 
2.43.0


