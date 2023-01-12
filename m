Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9B7667C35
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 18:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbjALRJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 12:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240637AbjALRI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 12:08:57 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2051A832;
        Thu, 12 Jan 2023 08:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673542027; x=1705078027;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uTtpqbs68rShmkDSI1vyCj6yrqANpKz7x55qoU4avXo=;
  b=WFs5Ls+RbWeVF6TVF1nAFCVawxHrD7OVp9NUdNLQioz6nUVqfbA2abu0
   JB8nH6uD41QV/WMl3dDmGr12p65TLWWFZitL6K/uKDhOAQgR/nJP1o3zf
   6znD8QI2zqnJn1XRxRWTpCJWWxa4I06athiayXrxaN54t2W1ypZrrKz3p
   ZiW1ynZf8/Mzz6v4vJ+wQMyUpdcTyVcd4RQpA26F5JDIdwlqwtxBbBCI/
   MSsUIboBxiezQZi3sAvDZNETpLoOgP7acbww579tgig1v9x/qk3RPyeT2
   1Xkxadl81RBGJMU+/BTqZYsjLjffZprHTbo80Q11C9e73cClpORnBAPRV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323816269"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323816269"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="986658314"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="986658314"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:15 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v3 00/16] KVM TDX: TDP MMU: large page support
Date:   Thu, 12 Jan 2023 08:43:52 -0800
Message-Id: <cover.1673541292.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Changes from v2:
- implemented page merging path
- rebased to TDX KVM v11

Changes from v1:
- implemented page merging path
- rebased to UPM v10
- rebased to TDX KVM v10
- rebased to kvm.git queue + v6.1-rc8

---
This patch series is based on "v11 KVM TDX: basic feature support".  It
implements large page support for TDP MMU by allowing populating of the large
page and splitting it when necessary.

Feedback for options to merge sub-pages into a large page are welcome.

Remaining TODOs
===============
* Make nx recovery thread useTDH.MEM.RANGE.BLOCK instead of zapping EPT entry.
* Record that the entry is blocked by introducing a bit in spte.  On EPT
  violation, check if the entry is blocked or not.  If the EPT violation is
  caused by a blocked Secure-EPT entry, trigger the page merge logic.

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

Isaku Yamahata (4):
  KVM: x86/tdp_mmu: Allocate private page table for large page split
  KVM: x86/tdp_mmu: Try to merge pages into a large page
  KVM: x86/tdp_mmu: TDX: Implement merge pages into a large page
  KVM: x86/mmu: Make kvm fault handelr aware of large page of private
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
 arch/x86/include/asm/kvm_host.h    |  10 ++
 arch/x86/kvm/mmu/mmu.c             |  50 ++++--
 arch/x86/kvm/mmu/mmu_internal.h    |  24 +++
 arch/x86/kvm/mmu/tdp_iter.c        |  37 +++--
 arch/x86/kvm/mmu/tdp_iter.h        |   2 +
 arch/x86/kvm/mmu/tdp_mmu.c         | 252 ++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/common.h          |   6 +-
 arch/x86/kvm/vmx/tdx.c             | 226 ++++++++++++++++++++------
 arch/x86/kvm/vmx/tdx_arch.h        |  21 +++
 arch/x86/kvm/vmx/tdx_errno.h       |   2 +
 arch/x86/kvm/vmx/tdx_ops.h         |  50 ++++--
 arch/x86/kvm/vmx/vmx.c             |   2 +-
 13 files changed, 572 insertions(+), 113 deletions(-)

-- 
2.25.1

