Return-Path: <kvm+bounces-6584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4B9183796A
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:38:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53732B28ADD
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84FD853E11;
	Mon, 22 Jan 2024 23:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QwMsDutY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA05350A95;
	Mon, 22 Jan 2024 23:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967701; cv=none; b=ojquF5wtIgI1iAoWvmztDXipx5Ewf8lST3fPIOUk4lIqvcIUFDqtNrA4qN3T2WIYr9QSnNMHGnZA2V3RudNyITQEggAbx5ic3PA1wIweP8qBqhNF5/P8V4/5XEwf3esbyA5WFYUw3GQedyc28RGZH0E1Z4V+FXc5yNiX8CX7pOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967701; c=relaxed/simple;
	bh=gZq/xU5HPMr+7bL2m3UNHQGfAGkvgf+PBtN9vzhZEYs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dqMq44yt0iuKWYlnwpYjT5wWHlU5Nn5Z2lRR2Tuyc23R1LhXEGxuFirS3Rsn8DqRKzf4lDRlm/rwX7M2Dx81Qa3V33SgnOjpWdwJA2aH6WW1ipye9xYKVC26tc8vfMIw88GQ5NFKZm8j05cC25PdjIwP/ylMI4rIDsCQ9WF5VRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QwMsDutY; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967700; x=1737503700;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gZq/xU5HPMr+7bL2m3UNHQGfAGkvgf+PBtN9vzhZEYs=;
  b=QwMsDutYtFy1AGpgl8+ry9Foa94ITLYwQp6MP6d+EjjYtsQeNu+j7tjX
   LdN9yMsQ7gkpt+2+/8vwloDSGu8nohl7ERP+tnGuskL0y8Z7ft4xc/qqZ
   Q7wwFyhhIJQFs913BsIPcjR/KHmA2G7ImXMoqOhs4wahnjmm2aDQV2vdh
   3pBhw02Um4Sbuj0uxFvEhYOTsHlxekZwxX8sLAf14LjWy9J6MlIOB3Ew6
   UPEUAtJf2tgOfnWOEFLuHHfNZoONFQL5qs1ta8LfFqKnfrI1iC9ciVadb
   P7kM3x30M6Sc/70BAm5+YL45njGynTP28SPo14WQijzubv1p7Bzom/z3V
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1217845"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1217845"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1350150"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:59 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v18 011/121] [MARKER] The start of TDX KVM patch series: TDX architectural definitions
Date: Mon, 22 Jan 2024 15:52:47 -0800
Message-Id: <0ac6ba1543267e08feef524e1e85de5087002070.1705965634.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of TDX architectural
definitions.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/index.rst              |  2 ++
 .../virt/kvm/intel-tdx-layer-status.rst       | 29 +++++++++++++++++++
 2 files changed, 31 insertions(+)
 create mode 100644 Documentation/virt/kvm/intel-tdx-layer-status.rst

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index ad13ec55ddfe..ccff56dca2b1 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -19,3 +19,5 @@ KVM
    vcpu-requests
    halt-polling
    review-checklist
+
+   intel-tdx-layer-status
diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
new file mode 100644
index 000000000000..f11ea701dc19
--- /dev/null
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -0,0 +1,29 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+Intel Trust Dodmain Extensions(TDX)
+===================================
+
+Layer status
+============
+What qemu can do
+----------------
+- TDX VM TYPE is exposed to Qemu.
+- Qemu can try to create VM of TDX VM type and then fails.
+
+Patch Layer status
+------------------
+  Patch layer                          Status
+
+* TDX, VMX coexistence:                 Applied
+* TDX architectural definitions:        Applying
+* TD VM creation/destruction:           Not yet
+* TD vcpu creation/destruction:         Not yet
+* TDX EPT violation:                    Not yet
+* TD finalization:                      Not yet
+* TD vcpu enter/exit:                   Not yet
+* TD vcpu interrupts/exit/hypercall:    Not yet
+
+* KVM MMU GPA shared bits:              Not yet
+* KVM TDP refactoring for TDX:          Not yet
+* KVM TDP MMU hooks:                    Not yet
-- 
2.25.1


