Return-Path: <kvm+bounces-31922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D5159CDBDF
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 10:53:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE916B22F30
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 09:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF3BC193091;
	Fri, 15 Nov 2024 09:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NWbZM0Hr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4B51922DD;
	Fri, 15 Nov 2024 09:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731664375; cv=none; b=qe+KPtToyRaYOaLoqRnWt9PKkHDxkgi/g2sydGVeQX/GOaGUBZ+UGjLrZ9O5nu0S1maqC/Be6gZEX+C6EIHBXkAfLUd2cN7TJSqljTkU/w4k71APeoF2uM5jXF+4L5CxnZxQryU/Yg5geceW+6wy8hZpWkez4niRAMKqA9fef4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731664375; c=relaxed/simple;
	bh=7ypu5yuMidhfBNvxf1zazpCItsdfIxjQvFiIK+i7tCs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p9atXXrZL+0AxZUXK8oo0YatqXrJ0j2avgAW0URsFNIM2hlwgeZWsXfAuW6I6vWjWEOVj53WcSoEYvEV9cdCGBBQlLJUTUb1Hhymqgo1nHlzMlDy0OvRiHYPXWmoWdV9XHLHGkz8JIrXH5MMXROkIJcjDGCPvtYH6Wr9cblUuxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NWbZM0Hr; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731664373; x=1763200373;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7ypu5yuMidhfBNvxf1zazpCItsdfIxjQvFiIK+i7tCs=;
  b=NWbZM0HrqgB/oqOnmstIX3WJXmMMcVOimeeB8WWdc7QSf2Xew2ToEbV/
   XsExBSUGXsnW1LNhEMVIWo3/IKeHhdPD/7kCCWBNCQz4vDS+No+nBT9jf
   zvPX0LbQ8pd0xYqW//tVu2+BCk3xhFiHYj0Z5r8PVLAufoNtSLWUaVxoQ
   /Lb3loVVMvyvUVWfrxo803ybeZKBQGJcMyzjNb9q/+Yy/oQ+kRzKufvxE
   QQ0IwfNNxjGoFTv2hi4i5JUPGOLqRUxNJ8h/27PTYS73/fmbwyjy2BFq9
   y9EaN6pKBBCxtNh/wUW6bWW04AuYD8PXiSGS30YPTP3GjT7UBz3itrpE7
   g==;
X-CSE-ConnectionGUID: e6PhLl3iQj6bd3K9YLfjhA==
X-CSE-MsgGUID: iJadlhSiRSGi61Z7Z3zI0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11256"; a="31584831"
X-IronPort-AV: E=Sophos;i="6.12,156,1728975600"; 
   d="scan'208";a="31584831"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 01:52:53 -0800
X-CSE-ConnectionGUID: Op9abnZSRNaWGW70azLpLg==
X-CSE-MsgGUID: /H631+coRmuJHiXDYSCCCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,156,1728975600"; 
   d="scan'208";a="93584303"
Received: from kinlongk-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.135])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 01:52:50 -0800
From: Kai Huang <kai.huang@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	reinette.chatre@intel.com,
	binbin.wu@linux.intel.com,
	xiaoyao.li@intel.com,
	yan.y.zhao@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com,
	kristen@linux.intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] KVM: VMX: Initialize TDX when loading KVM module
Date: Fri, 15 Nov 2024 22:52:38 +1300
Message-ID: <cover.1731664295.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Paolo/Sean,

This series contains patches to initialize TDX when loading KVM module.
The main purpose of sending this out is to have a review and for the
integration to kvm-coco-queue, but this series can also be applied to
kvm/queue cleanly.

v1 -> v2:
 - Add KVM_INTEL_TDX to guide KVM TDX code. (Sean)
 - Distinguish "TDX cannot be supported" vs "TDX fail to enable due to
   unexpected failure", and handle them differently. (Sean)
 - Update changelog accordingly
 - Remove useless comments around tdx_enable() and tdx_cpu_enable()
   (Sean).
 - Add SPDX-License-Identifier tag to vmx/tdx.h

Btw:

I kept the name tdx_bringup(), tdx_cleanup() but didn't change them to
tdx_module_init() and tdx_module_exit() cause I feel KVM does more than
"module" init/exit.  We can change that if needed.

v1: https://lore.kernel.org/kvm/cover.1730120881.git.kai.huang@intel.com/T/


Kai Huang (3):
  KVM: VMX: Refactor VMX module init/exit functions
  KVM: Export hardware virtualization enabling/disabling functions
  KVM: VMX: Initialize TDX during KVM module load

 arch/x86/kvm/Kconfig     |  10 +++
 arch/x86/kvm/Makefile    |   1 +
 arch/x86/kvm/vmx/main.c  |  41 +++++++++++
 arch/x86/kvm/vmx/tdx.c   | 153 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h   |  13 ++++
 arch/x86/kvm/vmx/vmx.c   |  23 +-----
 arch/x86/kvm/vmx/vmx.h   |   3 +
 include/linux/kvm_host.h |   8 ++
 virt/kvm/kvm_main.c      |  18 +----
 9 files changed, 235 insertions(+), 35 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.c
 create mode 100644 arch/x86/kvm/vmx/tdx.h


base-commit: b1e0320c5a9fe875f56039ea43e183c59974d38a
-- 
2.46.2


