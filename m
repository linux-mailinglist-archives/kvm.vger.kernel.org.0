Return-Path: <kvm+bounces-6696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 563C8837B86
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:02:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFEEF1F28898
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D8414DB4F;
	Tue, 23 Jan 2024 00:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YytDiKb8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC611350E0;
	Tue, 23 Jan 2024 00:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969359; cv=none; b=DM/TLwK42ihWUtuk9pjpHEgWW/sLymnodxUGfJ0V2pDvWrntfMI70wz2VX9EYw/Uhestd1EBbeThbgO1p9jT4R3x/A6rmbNsU0SDTS92YMsG7K2kcycAjJpGpNhIfXghLSeDBtY6o3F1npB4v2+2fhBL14hmfv8tjNvdAMSUOq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969359; c=relaxed/simple;
	bh=OkrKYToEqMSBdgXRUW+l60iAc1MVrx4Y2qtcgh1ypAw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Vol9cEliq+7RmSQbe+dmitAp5KU4lDabuGG1bojW8NoG0DJgKu02VavmvdZQoF/vpzv6SX6ZVKnV5Ln5agi/xLbdzHQDbgQrpan8Tg2KGF6MCeYijiQXP5Yw6MixDgQJ0fZJVPrKN7ESjrYXN4ui3rP5hJgYIYsVyV3Mmaosux4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YytDiKb8; arc=none smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705969357; x=1737505357;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OkrKYToEqMSBdgXRUW+l60iAc1MVrx4Y2qtcgh1ypAw=;
  b=YytDiKb8IMnK/DFRIOqEZwOhObeYFWsnbm4v2vN1WIryXV+uMnfGGOUo
   ZM6KfmR5z0NPGBPpiqwuV74fRxGnbeIpvCbMFll959LsLXyp/5lWvgxTk
   Y3r1+d0Bevi6Kj+nF5e9/nSzdxXM8aJLdpKuJpFMDzJpGXwQ5oaIS9M7L
   I4R7h0eNr61BiZuCxSjUZUWHMmEe49EqhkHKGs3pY1kIzI6cXpTu4RN76
   xZ64wDXZAGk1H1PoGcekbVoO8IWqraY4bDdTI2Un9Sf4rQRjHtz5LEaNE
   Hvfug/xcSBfm76mpOpPIpm7G40ZUoyL5NN2DhS+oYj0NHVDvAOJaQx3me
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="405125633"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="405125633"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27825616"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:35 -0800
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
Subject: [PATCH v7 00/13] KVM TDX: TDP MMU: large page support
Date: Mon, 22 Jan 2024 16:22:15 -0800
Message-Id: <cover.1705965958.git.isaku.yamahata@intel.com>
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

Discussion on 1GB huge page support
===================================
This is out of scope of this patch series. It will be addressed as follow up.
Currently I'm thinking the following design.  Here is a rough sketch

TDH.PAGE.MEM.AUG() and TDG.MEM.PAGE.ACCEPT() support only 4KB and 2MB. not 1GB.
Because it takes too long to convert 1GB page into private .  It need to promote
from 512 2MB pages to 1GB page on host side.

* On unmapping
Break large page from 1GB/2MB to 2MB/4KB.  In some cases, break twice. 1GB ->
2MB -> 4KB.  the 2MB page is allocated and 2MB mapping is allowed by
shared/private. (no partial 4KB private/shared mix.)

* Mapping 2MB page
If some 4KB pages of 2MB are mapped, map all non-present 4KB pages and try to
promote it to 2MB. Note: promotion to 2MB may fail if the guest accepted some,
doesn't some.  If there is no partial 4KB mapping (2MB entry in 1GB EPT page is
none), map 2MB directly.

* Mapping 1GB page
When The 1GB page is allocated and 1GB mapping is alloed by shared/private, the
following sketches the operations.

** Try to map all sub 2MB pages.
   If the 2MB EPT entry has 4KB cyhild, skip the entry unless it maps the
   faulting GPA. Don't go down to map 4KB because mapping 4KB, it would take
   too logn to promote 2MB and try to promote it to 1GB.
   If the 2MB EPT entry maps the faulting GPA, fallback to 2MB case.

** If there is no 4KB mapping, i.e. the 1GB EPT entry was none or the 2MB EPT
   entry was none or leaf. (no child), try to promote only once. i.e. 2MB ->
   1GB. Don't try promote twice from 4KB to 2MB to 1GB because it takes too long
   time.

* KVM NX recovery thread trying promote 4KB/2MB pages to 2MB/1GB page.
** 2MB EPT table: scan the EPT entries and map 4KB page if not present. If all
   4KB pages are mapped, try to promote to 2MB mapping. The promotion may fail
   due to partial accept.

** 1GB EPT table: Scan the EPT entries and map 2MB page if not present. Don't go
   down to 4KB page. If all 2MB pages are mapped, try to promote to 1GB
   mapping. the promoption may fail due to partial accept.

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

 arch/x86/include/asm/kvm-x86-ops.h |   3 +
 arch/x86/include/asm/kvm_host.h    |  11 ++
 arch/x86/kvm/Kconfig               |   1 +
 arch/x86/kvm/mmu/mmu.c             |  45 +++--
 arch/x86/kvm/mmu/mmu_internal.h    |  35 +++-
 arch/x86/kvm/mmu/tdp_iter.c        |  37 +++-
 arch/x86/kvm/mmu/tdp_iter.h        |   2 +
 arch/x86/kvm/mmu/tdp_mmu.c         | 276 ++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/common.h          |   6 +-
 arch/x86/kvm/vmx/tdx.c             | 222 +++++++++++++++++------
 arch/x86/kvm/vmx/tdx_arch.h        |  21 +++
 arch/x86/kvm/vmx/tdx_errno.h       |   3 +
 arch/x86/kvm/vmx/tdx_ops.h         |  56 ++++--
 arch/x86/kvm/vmx/vmx.c             |   2 +-
 14 files changed, 608 insertions(+), 112 deletions(-)

-- 
2.25.1


