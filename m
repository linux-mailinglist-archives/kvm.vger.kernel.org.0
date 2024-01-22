Return-Path: <kvm+bounces-6605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 62FCF837966
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:38:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1096B275EB
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11CAC5D913;
	Mon, 22 Jan 2024 23:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NrUKnLb8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD515C910;
	Mon, 22 Jan 2024 23:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967722; cv=none; b=U64Lez8qgwBzB/ZKHrE8JD+JXmPoeN3gY4dTZ2dmjfqA5KJg2z07kNYW2nHI6Q5v5lwKCXxuG/u0n7bwsQNLouGS7gkwr2mi8HAus9AzFuhGo7H1nqCtoF79oFOe+ekNll0KeFEuFUMz09vo0mJj+mkM4Zc2GQ4l4K07X3xH8PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967722; c=relaxed/simple;
	bh=58r13hz9Q8PXtEaJkIprmmmCqD+4hrpSLs4D34qBkgs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KnuUr52L4cgSz98liQxhYAeusPzj8mYjK1BPlizln+0//pJ4N0fDvGKTJsNv7kAQ7XLzzSy10JjCT5MD0uCu+ba6kH57LurpLWoEvndKYhEDNGT/zJpRm/TUAqxvRuo/y4L9NOY5kJ5IZpmVo4V7nUqjK6bXIj4NbxjTmxFBDQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NrUKnLb8; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967721; x=1737503721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=58r13hz9Q8PXtEaJkIprmmmCqD+4hrpSLs4D34qBkgs=;
  b=NrUKnLb8z3ZfH4tA8Oht/fiO2Y5w9Jd4SDydiyfegzfYEOM2Tw3AgG1N
   UCbM1atVOcH/Fh5Rjl42qCTOYFcu/fcntJhOvL1kc4o//O9XVeVTgDHt3
   aK0T85atoesJjvZoEsTwFEDQ6uba9trR16juI69TYYn1kIBF39qK77j1B
   t5CMFaACu2skMNTEBVyGO7CIRD5N1julNjEYcICnCDwFNgYi85yamZ4qt
   /uKvcjN50xd7kC4sweHuL2eivNFxKqvWabVImC22WqyjHVZcmTp6joUgz
   yS0Jihwv4IOdd19O/GbWspXJ8ASnklw9ToLsRlliObJBpDPzF+Cpawlf4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1243852"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1243852"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="819888611"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="819888611"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:19 -0800
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
Subject: [PATCH v18 032/121] KVM: x86/mmu: introduce config for PRIVATE KVM MMU
Date: Mon, 22 Jan 2024 15:53:08 -0800
Message-Id: <591420ca62f0a9ac2478c2715181201c23f8acf0.1705965635.git.isaku.yamahata@intel.com>
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

To keep the case of non TDX intact, introduce a new config option for
private KVM MMU support.  At the moment, this is synonym for
CONFIG_INTEL_TDX_HOST && CONFIG_KVM_INTEL.  The config makes it clear
that the config is only for x86 KVM MMU.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index cd3de7b9a665..fa00abb9ab39 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -189,4 +189,8 @@ config KVM_MAX_NR_VCPUS
 	  the memory footprint of each KVM guest, regardless of how many vCPUs are
 	  created for a given VM.
 
+config KVM_MMU_PRIVATE
+	def_bool y
+	depends on INTEL_TDX_HOST && KVM_INTEL
+
 endif # VIRTUALIZATION
-- 
2.25.1


