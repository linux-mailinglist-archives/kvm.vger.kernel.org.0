Return-Path: <kvm+bounces-6615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA322837937
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:33:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84A1428F8DE
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D84F65BACE;
	Mon, 22 Jan 2024 23:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lopcWviP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7674F1EF;
	Mon, 22 Jan 2024 23:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967734; cv=none; b=BNf9HGJsZ2GeTD7tDRoQH5NmyFSMc82WF4MQICD43hgJ3iZ6qew3x8TYlkvJjZkqxVCmyggvwCycexUUxWGTuRuLTsxxIkWno8Pr6VPG7iBwuWZLk+CVxDud5ybt840mARYURQRTD1YUOQf8cdJiC/0OJd3ByV51T7iJRcOHsTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967734; c=relaxed/simple;
	bh=WkpnJmQUuLJFyL2brOxfTQdsOI1DqG1Lui1rEGPKdd4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z8HvBLEI04HNn2nguMXHrc8GQlT4ND7sxEq0tfcETo/Pbm2N0DXG031YXILPEJ1CtPdSnl9nEVqwN35KQUfifDDPGsb6g+G8NMLyN1xhQKsHoLCZzPR1yML35dVCbx0k7F7quWp3qs7IUxZ9pqhmfX26t36QJV2SQu89m7BTD+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lopcWviP; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967733; x=1737503733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WkpnJmQUuLJFyL2brOxfTQdsOI1DqG1Lui1rEGPKdd4=;
  b=lopcWviP7bq9LO10y7EfR87+WaafaefHPVWt+WrDyinFcRiLp3graRDP
   FuwajjdtDy/6Mu8wcHvR/XHAcd209gOwkZfh/EbslZ76RejUxB0Z02cyR
   mQHDbTLDU124i9kiTYTbCIRq4U6AyntmhJaWT/7MBcqB5B0N7JdnsWArr
   XKYMGcJDfRrUsztlCXaFXl+Pf6Sj9TZBnK5QJjA4cIWqpTgScJ+3RFilY
   p+l+m9uJyx4jU2ymFV1P8zWT3Y47oQoH9EaNDduZqUVlEVtpXBEVuKaor
   DRsaZG9QAo/7JfL9sN8G1LlgBk6lAcSUhEbtnX6th3V46RILetINbnM3X
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016366"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016366"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468090"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:29 -0800
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
Subject: [PATCH v18 043/121] [MARKER] The start of TDX KVM patch series: KVM TDP MMU hooks
Date: Mon, 22 Jan 2024 15:53:19 -0800
Message-Id: <1a7fac99007b1b92231ff74d3c2b281a10c722fd.1705965635.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the start of patch series of KVM TDP MMU
hooks.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index e893a3d714c7..7903473abad1 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -26,5 +26,5 @@ Patch Layer status
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA shared bits:              Applied
-* KVM TDP refactoring for TDX:          Applying
-* KVM TDP MMU hooks:                    Not yet
+* KVM TDP refactoring for TDX:          Applied
+* KVM TDP MMU hooks:                    Applying
-- 
2.25.1


