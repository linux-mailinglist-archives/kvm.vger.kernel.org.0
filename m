Return-Path: <kvm+bounces-6623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 906B38377EB
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:02:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F764B23F59
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:02:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7456E60BA6;
	Mon, 22 Jan 2024 23:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BIAYmYn6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C8A605DA;
	Mon, 22 Jan 2024 23:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967741; cv=none; b=SCtAzrb4DTarqa9Ol579KXL0VNvhpq6YOLKKirfez4NjzVTckRCYngoGLxkDbvXJYDVGe8tzssjCzFHKR9rDo3GGoB////FO+spJlrSTh89C7LqK7chHn4rGrtW+63pdhZvhcnjxqa4CezQOWwAyWj00YMwwbtAhVssVtorJlk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967741; c=relaxed/simple;
	bh=VWeErb8XXD2SBqMy8L7JRBcxtOCdpKU+Rt6/TTjVA8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I+xOZ68U40HFOtWhTdfC5mzZ4E4nQkWieZdx03egfdhPYrLI8zx1gemc9ISl5ot4GWPF65wdWPMmzMBXltMKh0p1Nyvw/q2BZysAaB1v+70ufxtm1ZFkqXxIH6Ao/V4PhpedTmjZiApc+zGcyuso1oMebQV0xGq4LaNbcyA6VQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BIAYmYn6; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967740; x=1737503740;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VWeErb8XXD2SBqMy8L7JRBcxtOCdpKU+Rt6/TTjVA8Q=;
  b=BIAYmYn6lvojYHUo6W/OZSPD4zp/DrZt+AUAMk/O27pxXYWOR5DxiMT2
   0P18RDIA3Dr2Mo/hxcnTVoeIkXgHcw4Lg1chP+5wilS3gtRLITQSovV3F
   wx2PqqX3Z92Z4p3le1uQD+KlQ+cXimks1ESyfHkP4r0mQa/+13PHG393R
   lRDxBzoexfBvvrb/8wiEel1nz9ANBWzWBsMQBx168UZ6lKxdXKzCY0AMr
   pPvMLAnX9vbU43TQL6x2CRSAwkvI6txTW5ALrkcyPwYpu9R2rmHiTc82i
   Z7dkvR/iuyDFB5NyvPfU+e1Bny3OlZsegpkBApXxtXSOS3VYEw5IUWhK1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016405"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016405"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468147"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:33 -0800
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
Subject: [PATCH v18 052/121] [MARKER] The start of TDX KVM patch series: TDX EPT violation
Date: Mon, 22 Jan 2024 15:53:28 -0800
Message-Id: <847fa95344ea13eb1f11c4378d77ee56b1fafa1d.1705965635.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the start of patch series of TDX EPT
violation.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 7903473abad1..c4d67dd9ddf8 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -20,11 +20,11 @@ Patch Layer status
 * TDX architectural definitions:        Applied
 * TD VM creation/destruction:           Applied
 * TD vcpu creation/destruction:         Applied
-* TDX EPT violation:                    Not yet
+* TDX EPT violation:                    Applying
 * TD finalization:                      Not yet
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA shared bits:              Applied
 * KVM TDP refactoring for TDX:          Applied
-* KVM TDP MMU hooks:                    Applying
+* KVM TDP MMU hooks:                    Applied
-- 
2.25.1


