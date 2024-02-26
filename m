Return-Path: <kvm+bounces-9668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F18866C9E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:42:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC15B1F24B58
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E213C5336F;
	Mon, 26 Feb 2024 08:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A7igyK3A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B041B5EE75;
	Mon, 26 Feb 2024 08:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936092; cv=none; b=MCqLFRwpD61tqhX5oFYzNvpUcZgXf7k4ifESCu4xL+g44RPRS8E6fHJSgF9Ocgt9TPX4sFSzxppdNxBJTk3+p+FTx4Ze94VIOdNg4UxH1Ve5FxEuG+z16wJrhs2a1jhXLSuNHTp5T5RwaP3ryZ7yzFxIrNcSaSi24uNAth2vsGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936092; c=relaxed/simple;
	bh=ESlsFtK7TCNNodzGvNFsc1Y94K335DvZHywlXfgF6Fc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F5ZKgIpxdT4+NaZmIoiJy9LP5cQ/FHV3klWcLWoIs9hNHxaCznzLWUgkIrn8HRg1mzIzymo3gaw30OeddUbaFBQL6/vwx57bVw8mpp7ogIWfJ8gv2CKmw0dBanfCFQyltUVV2swKkzdi3U97961wgkY3ju4UadGJexB1MlV7sGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A7igyK3A; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936090; x=1740472090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ESlsFtK7TCNNodzGvNFsc1Y94K335DvZHywlXfgF6Fc=;
  b=A7igyK3AJBVHmD9O1hdK2HbcpoQ5RFi24AZV1kCsTrWtgIVDkcVZe9Az
   peHOc/cOtPZsrDppgWqPYg15nq+TxCVYYyorV2zVCPWBdMq761X/qU5xP
   6OQ6wrRk0jE/3zNzyCfp6g9nmvdyMTpDOi3mjz6G0dr3YLvp4mUG9DA7G
   L6KnNVMUkFD/EIjcCXW+NAImd1mJM9Mzs9XSom4L30DmRXBPSKingUPhS
   Egn1z6v+jvlV2cBeUzOta7swtoXBvr2Y6RtIMbA0INLAtchU9X1wgh2KI
   LcAgyybRevIYj6Rcmoiug4kCsTKKCGFCPc17JQJg4bO/8K/UEqs6QXZPF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155353"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155353"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615753"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:06 -0800
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
Subject: [PATCH v19 045/130] [MARKER] The start of TDX KVM patch series: KVM MMU GPA shared bits
Date: Mon, 26 Feb 2024 00:25:47 -0800
Message-Id: <ae2635a6156c9f3335cae41ec8d0ac57fa3d3f24.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of KVM MMU GPA
shared bits.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 25082e9c0b20..8b8186e7bfeb 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -10,6 +10,7 @@ What qemu can do
 ----------------
 - TDX VM TYPE is exposed to Qemu.
 - Qemu can create/destroy guest of TDX vm type.
+- Qemu can create/destroy vcpu of TDX vm type.
 
 Patch Layer status
 ------------------
@@ -18,12 +19,12 @@ Patch Layer status
 * TDX, VMX coexistence:                 Applied
 * TDX architectural definitions:        Applied
 * TD VM creation/destruction:           Applied
-* TD vcpu creation/destruction:         Applying
+* TD vcpu creation/destruction:         Applied
 * TDX EPT violation:                    Not yet
 * TD finalization:                      Not yet
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
-* KVM MMU GPA shared bits:              Not yet
+* KVM MMU GPA shared bits:              Applying
 * KVM TDP refactoring for TDX:          Not yet
 * KVM TDP MMU hooks:                    Not yet
-- 
2.25.1


