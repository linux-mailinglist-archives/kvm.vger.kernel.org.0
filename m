Return-Path: <kvm+bounces-994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F6C37E42C5
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:08:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CED7A28240B
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 102CE3A28E;
	Tue,  7 Nov 2023 15:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YLzHxig1"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9F4374E4
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:05:05 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642D35BAA;
	Tue,  7 Nov 2023 07:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369318; x=1730905318;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QAe1Pf3HMvabh61TT4YGev7+3vG8xv04wgXNNcptr6k=;
  b=YLzHxig1h8H6GpZ6DLxqR/e4fUgLiN1wpQ21/MRourV68aXCyG4pQSPD
   EkMEaf92YHS0FRLqA/daoPoznojiwE2Jn2DlEHb0OF4Fvgm6M2IhrOWVI
   be4eNpn1c0UnMlu246w7hZcmH0PFzaEtm9TJpRZ2sbNHhEkOMU+WlEijS
   zUEUNezVU2ShcnIt/qp6+V0vHGyuMs0T6ugH+DQLeKyqOQq1SDwnXNYkw
   tjknU245ywiviBWNTpFbnzB66sugEYXYSNSJZ30oW308Tm/NORJeQPYf/
   etHkdkCk6sV5CdCZn2KBoxi16JW1+j9ghXVi7D5b3JJNH/q7JHtWv6tqG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="388397481"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="388397481"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:00:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10446453"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:00:49 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v6 00/16] KVM TDX: TDP MMU: large page support
Date: Tue,  7 Nov 2023 07:00:27 -0800
Message-Id: <cover.1699368363.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

This patch series is based on "v17 KVM TDX: basic feature support".  It
implements large page support for TDP MMU by allowing populating of the large
page and splitting it when necessary.

Feedback for options to merge sub-pages into a large page are welcome.

Remaining TODOs
===============
* 1GB huge page support. This is out of scope of this patch series. It will
  be addressed as follow up.

Splitting large pages when necessary
====================================
* It already tracking whether GFN is private or shared.  When it's changed,
  update lpage_info to prevent a large page.
* TDX provides page level on Secure EPT violation.  Pass around the page level
  that the lower level functions needs.
* Even if the page is the large page in the host, at the EPT level, only some
  sub-pages are mapped.  In such cases abandon to map large pages and step into
  the sub-page level, unlike the conventional EPT.
* When zapping spte and the spte is for a large page, split and zap it unlike
  the conventional EPT because otherwise the protected page contents will be
  lost.

Merging small pages into a large page if possible
=================================================
On normal EPT violation, check whether pages can be merged into a large page
after mapping it.

TDX operation
=============
The following describes what TDX operations procedures.

* EPT violation trick
Such track (zapping the EPT entry to trigger EPT violation) doesn't work for
TDX.  For TDX, it will lose the contents of the protected page to zap a page
because the protected guest page is un-associated from the guest TD.  Instead,
TDX provides a different way to trigger EPT violation without losing the page
contents so that VMM can detect guest TD activity by blocking/unblocking
Secure-EPT entry.  TDH.MEM.RANGE.BLOCK and TDH.MEM.RANGE.UNBLOCK.  They
correspond to clearing/setting a present bit in an EPT entry with page contents
still kept.  By TDH.MEM.RANGE.BLOCK and TLB shoot down, VMM can cause guest TD
to trigger EPT violation.  After that, VMM can unblock it by
TDH.MEM.RANGE.UNBLOCK and resume guest TD execution.  The procedure is as
follows.

  - Block Secure-EPT entry by TDH.MEM.RANGE.BLOCK.
  - TLB shoot down.
  - Wait for guest TD to trigger EPT violation.
  - Unblock Secure-EPT entry by TDH.MEM.RANGE.UNBLOCK to resume the guest TD.

* merging sub-pages into a large page
The following steps are needed.
- Ensure that all sub-pages are mapped.
- TLB shoot down.
- Merge sub-pages into a large page (TDH.MEM.PAGE.PROMOTE).
  This requires all sub-pages are mapped.
- Cache flush Secure EPT page used to map subpages.

Thanks,
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
  KVM: x86/tdp_mmu: TDX: Implement merge pages into a large page
  KVM: x86/mmu: Make kvm fault handler aware of large page of private
    memslot

Xiaoyao Li (12):
  KVM: TDP_MMU: Go to next level if smaller private mapping exists
  KVM: TDX: Pass page level to cache flush before TDX SEAMCALL
  KVM: TDX: Pass KVM page level to tdh_mem_page_add() and
    tdh_mem_page_aug()
  KVM: TDX: Pass size to tdx_measure_page()
  KVM: TDX: Pass size to reclaim_page()
  KVM: TDX: Update tdx_sept_{set,drop}_private_spte() to support large
    page
  KVM: MMU: Introduce level info in PFERR code
  KVM: TDX: Pin pages via get_page() right before ADD/AUG'ed to TDs
  KVM: TDX: Pass desired page level in err code for page fault handler
  KVM: x86/tdp_mmu: Split the large page when zap leaf
  KVM: x86/tdp_mmu, TDX: Split a large page when 4KB page within it
    converted to shared
  KVM: TDX: Allow 2MB large page for TD GUEST

 arch/x86/include/asm/kvm-x86-ops.h |   3 +
 arch/x86/include/asm/kvm_host.h    |  11 ++
 arch/x86/kvm/Kconfig               |   1 +
 arch/x86/kvm/mmu/mmu.c             |  45 +++--
 arch/x86/kvm/mmu/mmu_internal.h    |  35 +++-
 arch/x86/kvm/mmu/tdp_iter.c        |  37 +++-
 arch/x86/kvm/mmu/tdp_iter.h        |   2 +
 arch/x86/kvm/mmu/tdp_mmu.c         | 283 +++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/common.h          |   6 +-
 arch/x86/kvm/vmx/tdx.c             | 230 +++++++++++++++++------
 arch/x86/kvm/vmx/tdx_arch.h        |  21 +++
 arch/x86/kvm/vmx/tdx_errno.h       |   2 +
 arch/x86/kvm/vmx/tdx_ops.h         |  50 +++--
 arch/x86/kvm/vmx/vmx.c             |   2 +-
 14 files changed, 609 insertions(+), 119 deletions(-)

-- 
2.25.1


