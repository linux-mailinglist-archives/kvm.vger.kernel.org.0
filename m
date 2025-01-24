Return-Path: <kvm+bounces-36520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC04A1B714
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:40:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 961F218899AE
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27AAF78F3B;
	Fri, 24 Jan 2025 13:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LarIPoa+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7D586342
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725952; cv=none; b=M+thCn4yrDCX2i688TFG8rOm5EhMUwTBK1LnaqFr791F5jADG6CA3IKaQWHQlX1TCFWDDtB7Or4/iUq7RMFCIkPj3RtXbxRj5uBymqzJJUDafdB+Hqiva338BPQdpn1ko64KW3PzaalMUTA4vCQO/toL7LI8shxforlGfsxplCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725952; c=relaxed/simple;
	bh=3htOvA2jbpLNtRYP7pYOxr4oRukBQDBcMamKFay85SU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=STPQKlUjUqZFjXveIcltPCKdMT/WspmLZasMRI1ly+tK9w3qsoNiuF0O/SPgHVleGEn45Uf9zxB5RtcktL9cPO+hWcKswvXxAA9LFK/G4IGtfpaIYNq+nLd+QE6lSQ/lof3nmsCobxJYGepxAdamxA+OwsykaIWgCK60MPgGhss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LarIPoa+; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725951; x=1769261951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3htOvA2jbpLNtRYP7pYOxr4oRukBQDBcMamKFay85SU=;
  b=LarIPoa+lZvR8k/rtBHkI6AXdEpfQtF8kxFIxjeSUaWLn7I8WiLgVO3o
   xPsDlF9ZkrEDRr8QFgOZGp1cycWLJevXtB74avTlzujbsTxuqPlgnOcMN
   AHZuxrPwxox3UsnPIU/NXGhJbOqW7aJjqVt9RYWehoo8gpq06A6wOTSbY
   N/kerJcFr5/pR/RRqd6p0sLLEPWB4cOHJKix2pVV5FCWU/ewCfOsPbYCL
   6VT/9jHFL83zQz8Nt4H6WDacZrSqA29QhgWNgGk9phEoKKnVyYAPv6lgd
   e/yLzsX+wE/1aRh1YGl+pFB/h2pIRonyiFNSX4Yh3plEmnV4mSABebgDn
   Q==;
X-CSE-ConnectionGUID: DGQi49DWSISUpGswk1H4tQ==
X-CSE-MsgGUID: 9ym7g8DJTBmINZKToIBUEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246501"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246501"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:11 -0800
X-CSE-ConnectionGUID: GBAGZD3TTzGavPdm4Wq8KA==
X-CSE-MsgGUID: GpGGeVBJSaWU8VbW4hQpRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804403"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:39:07 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 34/52] i386/tdx: Disable SMM for TDX VMs
Date: Fri, 24 Jan 2025 08:20:30 -0500
Message-Id: <20250124132048.3229049-35-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TDX doesn't support SMM and VMM cannot emulate SMM for TDX VMs because
VMM cannot manipulate TDX VM's memory.

Disable SMM for TDX VMs and error out if user requests to enable SMM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index f4d95b0a4029..10059ec8cf92 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -365,11 +365,20 @@ static Notifier tdx_machine_done_notify = {
 
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
+    MachineState *ms = MACHINE(qdev_get_machine());
+    X86MachineState *x86ms = X86_MACHINE(ms);
     TdxGuest *tdx = TDX_GUEST(cgs);
     int r = 0;
 
     kvm_mark_guest_state_protected();
 
+    if (x86ms->smm == ON_OFF_AUTO_AUTO) {
+        x86ms->smm = ON_OFF_AUTO_OFF;
+    } else if (x86ms->smm == ON_OFF_AUTO_ON) {
+        error_setg(errp, "TDX VM doesn't support SMM");
+        return -EINVAL;
+    }
+
     if (!tdx_caps) {
         r = get_tdx_capabilities(errp);
         if (r) {
-- 
2.34.1


