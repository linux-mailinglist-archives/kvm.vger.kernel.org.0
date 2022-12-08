Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87073647A0D
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiLHXfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiLHXfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:35:53 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403146BC84;
        Thu,  8 Dec 2022 15:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670542552; x=1702078552;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7pIEJnY9UvfuYn0eYdPGB1fUeHfaRJaIgclZ7QRSooM=;
  b=io707IISBSMIqHyBweV7NBrjrJ177IvS93uELk6CHHuqVjF9p0TfYptA
   xiS9F83FJ9vnKR7UZ8xlEApq2WxsobA3bBmW/ESNRDyuLxGKLHsRk4BmJ
   /Gs9WGK97qZdj4w5un6P6T4lRLjzDHM1pc9Q1bws6z2oBbfWAPo3r4uQs
   5qnkfPC90G2iptoGU3RkmGIvVq5Wz5zX198DFmah2e26OLlv1kBHA277L
   Haci69M58a0hKfSAvxVLHfIinKrsK7QgjS1s1YRCnmSKBRBcMPXhIM3LW
   z+XAHl6ByAv1XstmwwZe1UbYMojegE6hR6GqaC3M0poT+afk9IFQ/VAJr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="403586472"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="403586472"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="677950866"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="677950866"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:51 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v2 00/15] KVM TDX: TDP MMU: large page support
Date:   Thu,  8 Dec 2022 15:35:35 -0800
Message-Id: <cover.1670541736.git.isaku.yamahata@intel.com>
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

Changes from v1:
- implemented page merging path
- rebased to UPM v10
- rebased to TDX KVM v10
- rebased to kvm.git queue + v6.1-rc8

---
This patch series is based on "v10 KVM TDX: basic feature support".  It
implements large page support for TDP MMU by allowing populating of the large
page and splitting it when necessary.

Feedback for options to merge sub-pages into a large page are welcome.

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
* It's not implemented to merge pages into a large page.


Mergihng small pages into a large page if possible
==================================================
On normal EPT violation, check whether pages can be merged into a large page
after mapping it.
Missing part is as follows
* Make nx recovery thread useTDH.MEM.RANGE.BLOCK instead of zapping EPT entry.
* Record that the entry is blocked by introducing a bit in spte.  On EPT
  violation, check if the entry is blocked or not.  If the EPT violation is
  caused by a blocked Secure-EPT entry, trigger the page merge logic.


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

Isaku Yamahata (3):
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
 arch/x86/kvm/mmu/mmu.c             |  50 +++++--
 arch/x86/kvm/mmu/mmu_internal.h    |  10 ++
 arch/x86/kvm/mmu/tdp_mmu.c         | 225 +++++++++++++++++++++++++---
 arch/x86/kvm/vmx/common.h          |   6 +-
 arch/x86/kvm/vmx/tdx.c             | 227 ++++++++++++++++++++++-------
 arch/x86/kvm/vmx/tdx_arch.h        |  21 +++
 arch/x86/kvm/vmx/tdx_errno.h       |   2 +
 arch/x86/kvm/vmx/tdx_ops.h         |  50 +++++--
 arch/x86/kvm/vmx/vmx.c             |   2 +-
 11 files changed, 505 insertions(+), 101 deletions(-)

-- 
2.25.1

