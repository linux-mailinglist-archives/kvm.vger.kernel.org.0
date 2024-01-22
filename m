Return-Path: <kvm+bounces-6649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3901D83782D
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:08:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E205E1F29586
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 677D4679EE;
	Mon, 22 Jan 2024 23:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H6J5P52M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5822865BBA;
	Mon, 22 Jan 2024 23:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967755; cv=none; b=eIM+NflmZXpZUxVdHK4qf4CiI9wcZCKkv32JSPtzjeUSt2NjJTPND06I7ADlHah61LaHYZQZNT6R9xI8V2/J7SPw0eaHGUJNu0cgG7ITAUHtGRebnSriH9920enogXmqiqGl8E47bEKd8bU7cbw22o9IOfAB+FnN/I+e7kH+PDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967755; c=relaxed/simple;
	bh=TZ+z91imsScQD0p1/VsSa1GqbET/iM4ZKqAoChx+Rzg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PtV+p53iOs754vxf1+ES21cVb8RMX6pvtdHRqZhapFy34O3qnZezar8sZBUzydpA6iJ0dwFjfDsZBIFxD9FTp5awq+MUWN+pJVLkLQzlrQ4jubcljXcJDjv7kej1g4JBKbPFplfUCN8cBxL1Rp1P1F3TEtmIlnbo3ZfAbAN2n8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H6J5P52M; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967754; x=1737503754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TZ+z91imsScQD0p1/VsSa1GqbET/iM4ZKqAoChx+Rzg=;
  b=H6J5P52M84GAo4nou4OgRTcsh2lzcmc3HndTZ3QMv29Tq9TKFY2qeNq1
   V2TF/nCUD/C+KEhYtofy1viAqhxaiV4nhyY4XPVoy0NsWusc26eDpnSo0
   dHqHUDsAUB5JWBIem8K2Ww0dN1pVg5HopfAzbOZL4L+Cqy+F7m37qhkGo
   nRib4bCo3Thyqry7WjlQjpk9Upd50KzEgY+lWnFEkMlESzH92Yz3+sFfm
   YkHN1tyIAq/J5tyZxkc9WBeAPfrgyVXTsZgN4mWkWGidlQd6vQ74aiqHm
   6S4R4jwfr9l1w3co0sWl25G+BpV2M7z+C21RTnLhJYP/4B1vAk2FUhprX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016482"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016482"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468212"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:37 -0800
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
Subject: [PATCH v18 062/121] [MARKER] The start of TDX KVM patch series: TD finalization
Date: Mon, 22 Jan 2024 15:53:38 -0800
Message-Id: <84a0b8e41a134345b273fc3299eedcad267ac5c9.1705965635.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the start of patch series of TD finalization.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index c4d67dd9ddf8..46ae049b6b85 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -11,6 +11,7 @@ What qemu can do
 - TDX VM TYPE is exposed to Qemu.
 - Qemu can create/destroy guest of TDX vm type.
 - Qemu can create/destroy vcpu of TDX vm type.
+- Qemu can populate initial guest memory image.
 
 Patch Layer status
 ------------------
@@ -20,8 +21,8 @@ Patch Layer status
 * TDX architectural definitions:        Applied
 * TD VM creation/destruction:           Applied
 * TD vcpu creation/destruction:         Applied
-* TDX EPT violation:                    Applying
-* TD finalization:                      Not yet
+* TDX EPT violation:                    Applied
+* TD finalization:                      Applying
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
-- 
2.25.1


