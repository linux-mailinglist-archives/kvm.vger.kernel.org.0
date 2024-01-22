Return-Path: <kvm+bounces-6628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7812E8377F5
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:03:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A69DF1C24C5A
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B26C612E4;
	Mon, 22 Jan 2024 23:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KcyBUD4I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1617060DC7;
	Mon, 22 Jan 2024 23:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967744; cv=none; b=uCgqTWOd76d88c4YvphMxo6ydg8FU16f4cOsnXv83rfttm5CeqXqok3J7DfZ95aXJqDVbewadei/u8sMIcKtMxaBrNsy6gM60Xw5TFsIWjkH+qcXECZ5jbUWos5qihLPkcN4piEKpRy/PmZM7ap663fc93XjGZVilzBBEWSSdlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967744; c=relaxed/simple;
	bh=J0qMXx4Z1bmL0Bo7ShUuSxkVx6XY1Y4HAlOmBvk4LIo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sswqpqqr50ABfGC9LyxjCGV5bXicajSrAs4lujSlFAbwG65oZULHSgd2V6d2wJrBtpriXT4T1jdMAT1jtLeh5OnM18FLPI+Jm6vaalRJXFpxczUDSmRkyTfkO0HqJ/GCw80sfwtiOx7a9LXA3cARUNaSUdeZtEMTT3TEc0yyKcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KcyBUD4I; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967743; x=1737503743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J0qMXx4Z1bmL0Bo7ShUuSxkVx6XY1Y4HAlOmBvk4LIo=;
  b=KcyBUD4Ipq2gz+Ayx37h2WRCac0OanPtsh2MDYv/h3mIrFasTOzIyqln
   nx8c3dkO/IdnmvjL5+o98/ltAcJakL0osibwwYD8qFZr4yX91LmFBIJbc
   T6HquyPu1zUbCZcTQAe2XXFvkl3ABfe8ajpr3fM1aVXXjLRy93BiByXIP
   qkcj0vmroECc1jYqfFdx+HvP+oGFnoCTXBledYVF+gyoRaPrRX95PDaqn
   /3P0ggX9ZOY2xM0eEmJBNw712ueTKwYVm9AKupjFQfSpUsCkrpFkszeRf
   Yq87pdj9nb34TZaw5vPKN1aI75q9NWBS8TewfH8s3vnuAIT2yUv61m9Yg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217750"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217750"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27817896"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:41 -0800
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
Subject: [PATCH v18 073/121] [MARKER] The start of TDX KVM patch series: TD vcpu exits/interrupts/hypercalls
Date: Mon, 22 Jan 2024 15:53:49 -0800
Message-Id: <8cdf6e112221a950f20b2ffd96ca3b38339125ce.1705965635.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the start of patch series of TD vcpu
exits, interrupts, and hypercalls.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 33e107bcb5cf..7a16fa284b6f 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -13,6 +13,7 @@ What qemu can do
 - Qemu can create/destroy vcpu of TDX vm type.
 - Qemu can populate initial guest memory image.
 - Qemu can finalize guest TD.
+- Qemu can start to run vcpu. But vcpu can not make progress yet.
 
 Patch Layer status
 ------------------
@@ -24,7 +25,7 @@ Patch Layer status
 * TD vcpu creation/destruction:         Applied
 * TDX EPT violation:                    Applied
 * TD finalization:                      Applied
-* TD vcpu enter/exit:                   Applying
+* TD vcpu enter/exit:                   Applied
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA shared bits:              Applied
-- 
2.25.1


