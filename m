Return-Path: <kvm+bounces-9755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 006C4866DC6
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:11:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E4221F25475
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910AA132495;
	Mon, 26 Feb 2024 08:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LjRXZtpN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2E012FF7B;
	Mon, 26 Feb 2024 08:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936173; cv=none; b=ofDJHKnEWG3yGyoApwl84Is1KNgVksO4SkrPRn88pLVOfRLq8CrdVTs0LlzBDaT5VfofK5FWVNAWVftMfWvJJNJBEA27y4+ZZF41XCDFkVa2o+6dRjPiTdP50Mbs/PRj9UDZRZyJI8k1z1sezFzrfjE+GyL0efikb49dT/pSf0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936173; c=relaxed/simple;
	bh=GVOigoyLBitJEz+ECLHoKZAG9SyNhRj2MUTj1qeMvcM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a1YXH/oUzZ99x5kh1Su8gi7ELJFr1s16ly6zJlYkX1jQk8SNaHkihDIat/BXqn3NSTIr9Zorq/C/YDs5NJNMnqzcdpJf9DXjOMpdOhkOKYhEUvGt6LIVFWZpF98IF/hV/eLEthy02jt1sc4iVew64qCmkOxL79tXfoO8OyQCBJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LjRXZtpN; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936172; x=1740472172;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GVOigoyLBitJEz+ECLHoKZAG9SyNhRj2MUTj1qeMvcM=;
  b=LjRXZtpNER7Gu5moCoAEn1ny0PWXDBsZZ8pSVTQWXzME3eft5DJXJDB3
   BHMwJ8cvN8ecDrhHqsvXrcuOTSh+iZWOObWaEq5Sxg6wiS8Mo6DKSiMyJ
   t1etR9nxettgHMeDr+ypOfMT8tFRcaF8BxZdYOYUQyZzENLdKuA/Ai8oV
   AwL7O6MUONRG4RjGCyIb69ogA3hGu+48dS4kP9FefJGN+NIEBgByP51gw
   ENoYdL2ARJKOK2htSLJA14A561Y7sCst0t3B9FYfrPHg4Up6SKPiwXCy6
   PDTkhBal5vQf2X90SdKh9pNKtpBu4WXgY1FN9G5BER3sQOMfecsunV6PJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751493"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751493"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735277"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:31 -0800
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
Subject: [PATCH v8 00/14] KVM TDX: TDP MMU: large page support
Date: Mon, 26 Feb 2024 00:29:14 -0800
Message-Id: <cover.1708933624.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

This patch series is based on "v19 KVM TDX: basic feature support".  It
implements large page support for TDP MMU by allowing populating of the large
page and splitting it when necessary.

No major changes from v7 instead of rebasing.

Thanks,

Changes from v7:
- Rebased to v19 TDX KVM v6.8-rc5 based patch series

Changes from v6:
- Rebased to v18 TDX KVM v6.8-rc1 based patch series
- use struct tdx_module_args
- minor improve on comment, commit message

Changes from v5:
- Switched to TDX module 1.5 base.

Chnages from v4:
- Rebased to v16 TDX KVM v6.6-rc2 base

Changes from v3:
- Rebased to v15 TDX KVM v6.5-rc1 base

Changes from v2:
- implemented page merging path
- rebased to TDX KVM v11

Changes from v1:
- implemented page merging path
- rebased to UPM v10
- rebased to TDX KVM v10
- rebased to kvm.git queue + v6.1-rc8

Isaku Yamahata (4):
  KVM: x86/tdp_mmu: Allocate private page table for large page split
  KVM: x86/tdp_mmu: Try to merge pages into a large page
  KVM: TDX: Implement merge pages into a large page
  KVM: x86/mmu: Make kvm fault handler aware of large page of private
    memslot

Sean Christopherson (1):
  KVM: Add transparent hugepage support for dedicated guest memory

Xiaoyao Li (9):
  KVM: TDX: Flush cache based on page size before TDX SEAMCALL
  KVM: TDX: Pass KVM page level to tdh_mem_page_aug()
  KVM: TDX: Pass size to reclaim_page()
  KVM: TDX: Update tdx_sept_{set,drop}_private_spte() to support large
    page
  KVM: MMU: Introduce level info in PFERR code
  KVM: TDX: Pass desired page level in err code for page fault handler
  KVM: x86/tdp_mmu: Split the large page when zap leaf
  KVM: x86/tdp_mmu, TDX: Split a large page when 4KB page within it
    converted to shared
  KVM: TDX: Allow 2MB large page for TD GUEST

 Documentation/virt/kvm/api.rst     |   7 +
 arch/x86/include/asm/kvm-x86-ops.h |   3 +
 arch/x86/include/asm/kvm_host.h    |  11 ++
 arch/x86/kvm/mmu/mmu.c             |  38 ++--
 arch/x86/kvm/mmu/mmu_internal.h    |  30 +++-
 arch/x86/kvm/mmu/tdp_iter.c        |  37 +++-
 arch/x86/kvm/mmu/tdp_iter.h        |   2 +
 arch/x86/kvm/mmu/tdp_mmu.c         | 276 ++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/common.h          |   6 +-
 arch/x86/kvm/vmx/tdx.c             | 221 +++++++++++++++++------
 arch/x86/kvm/vmx/tdx_arch.h        |  21 +++
 arch/x86/kvm/vmx/tdx_errno.h       |   3 +
 arch/x86/kvm/vmx/tdx_ops.h         |  56 ++++--
 arch/x86/kvm/vmx/vmx.c             |   2 +-
 include/uapi/linux/kvm.h           |   2 +
 virt/kvm/guest_memfd.c             |  73 +++++++-
 16 files changed, 672 insertions(+), 116 deletions(-)

-- 
2.25.1


