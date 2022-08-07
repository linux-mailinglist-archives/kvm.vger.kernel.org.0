Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0341258BDDF
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242302AbiHGWb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242162AbiHGWbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:31:37 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FCF17E21;
        Sun,  7 Aug 2022 15:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659910728; x=1691446728;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qOGpO5cIeXubBrJsMlEwitkZ6Kq01lMoaTC4paN5KMw=;
  b=j/yWsI482zbpXY7pk300rInAKNcqi7bwoNanOXd+taVUfA2gmejTzteH
   PoOs0mj3uOuRE2WiuldqSQ1g3iy+Am5ImLDZSli3GkadaM8/cs3X2NA4r
   jhRAE4Xf1u96MHxL7kouBZesZcbK9zKPUP7TgfMzhGzrdmE0pxYduVEHT
   1R8wAQizhr4U494hvZkmq1281lugOGLKHB3jPgDI6t/PqB9w2AqvdE6zb
   dvN8zi52HOUb62On/GD+P0X4xNBxia5PKX/3m5JaLjs/GtzPOTbe6FKvK
   dI+Xv4VvJe8JaBRyXwf4n15JFKJu6FaxsFAZjZzcBjGYBx0uJUdmp/yym
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="352192026"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="352192026"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:47 -0700
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="580109237"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:47 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH 00/13] KVM TDX: TDP MMU: large page support
Date:   Sun,  7 Aug 2022 15:18:33 -0700
Message-Id: <cover.1659854957.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This patch series is based on "v8 KVM TDX: basic feature support".  It
implements large page support for TDP MMU by allowing populating of the large
page and splitting it when necessary.  It's not supported to merge 4K/2M pages
into 2M/1G pages.

Feedback for options to merge sub-pages into a large page are welcome.

Options for merging sub-pages into a large page
===============================================
A) Merge pages into a large page on scanning by NX page recovery daemon actively.
   + implementation would be simple
   - inefficient as implementation because it always scans subpages.
   - inefficient because it merges unused pages.
B) On normal EPT violation, check whether pages can be merged into a large page
   after mapping it.
   + scanning part isn't needed.
   - inefficient to add more logic to a fast path
C) Use TDH.MEM.RANGE.BLOCK instead of zapping EPT entry.  And record that the
   entry is blocked.  On EPT violation, check if the entry is blocked or not.
   If the EPT violation is caused by a blocked Secure-EPT entry, trigger the
   page merge logic.
   + reuse scanning logic (NX recovery daemon)
   + take advantage of EPT violation
   - would be complex
     Block instead of zap, track blocked Secure-EPT entry, and unblock it on the
     EPT violation and then page merge logic.


The current implementation (splitting large pages when necessary)
=================================================================
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


Discussion for merging pages into large page
============================================
The live migration support for TDX is planned.  It means dirty page logging will
be supported and a large page will be split on enabling dirty page logging.
After disabling it, the pages should be merged into large pages for performance.

The current implementation for the conventional EPT is
* THP or NX page recovery zaps EPT entries. This step doesn't directly map a
  large page.
* On the next EPT violation, when a large page is possible, map it as a large
  page.

This is because
* To avoid unnecessary page merging for cold SPTE by mapping large pages on EPT
  violation.  This is desirable for the TDX case to avoid unnecessary Secure-EPT
  operation.
* Reuse KVM page fault path.
  For TDX, the new logic is needed to merge sub-pages into a large page.

TDX operation
-------------
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

Chao Peng (1):
  KVM: Update lpage info when private/shared memory are mixed

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
  KVM: MMU: Pass desired page level in err code for page fault handler
  KVM: TDP_MMU: Split the large page when zap leaf
  KVM: TDX: Split a large page when 4KB page within it converted to
    shared
  KVM: x86: remove struct kvm_arch.tdp_max_page_level

 arch/x86/include/asm/kvm_host.h |  14 ++-
 arch/x86/kvm/mmu/mmu.c          | 158 ++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/mmu_internal.h |   4 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  31 +++++-
 arch/x86/kvm/vmx/common.h       |   6 +-
 arch/x86/kvm/vmx/tdx.c          | 174 +++++++++++++++++++++-----------
 arch/x86/kvm/vmx/tdx_arch.h     |  20 ++++
 arch/x86/kvm/vmx/tdx_ops.h      |  46 ++++++---
 arch/x86/kvm/vmx/vmx.c          |   2 +-
 include/linux/kvm_host.h        |  10 ++
 virt/kvm/kvm_main.c             |   9 +-
 11 files changed, 390 insertions(+), 84 deletions(-)

-- 
2.25.1

