Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B986C41C0
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 05:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjCVE6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 00:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCVE6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 00:58:30 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC542A141
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 21:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679461109; x=1710997109;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Zfi1zl9jZXNj+eKulHwi//RRqH1XGMWFdIig28GKudM=;
  b=BZSS/T0gLQU7dbBWMMvIfeYXfuEIsMsJcR3jIYs7eQ16OltXD+AcckuX
   jlY1fYNRC0FNDdiZb5WLxslWxAhqOnOME+Pw1sRMT6mVd+ybzife7OpTV
   CF+JDu2mwec7GGYY/dvya6J2x41rBGaNfwgZcVRvWJsBcmichHUEECNSK
   4anQ+aHTrhQGDulIA5QpHB0JUo2Mbo33T1Ml5bi8XzChAYRX15R6gcg9I
   lpHrvAcNQR1gl54hoQH8HIPjOF10EfMPd7lEZthx7w9rRhxFGQhRUt1Uk
   WXv8j+fESDv9Fv5WPL0LaJs8JTaTGc4iFU7Lh7lz18Gx4i895vM1shR0S
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="327507186"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="327507186"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 21:58:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="750908535"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="750908535"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.8.235])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 21:58:27 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     binbin.wu@linux.intel.com, robert.hu@linux.intel.com
Subject: [PATCH 0/4] Add and use helpers to check bit set in CR0/CR4
Date:   Wed, 22 Mar 2023 12:58:20 +0800
Message-Id: <20230322045824.22970-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add two helpers
- kvm_is_cr0_bit_set()
- kvm_is_cr4_bit_set()
to do CR0/CR4 check on one specific bit and return the value in bool.
Replace kvm_read_{cr0,cr4}_bits() with kvm_is_{cr0,cr4}_bit_set() when applicable.

Also change return type of is_pae(), is_pse(), is_paging() and is_long_mode()
to bool.

No functional change intended.

The patch series is originated from cleanup code of KVM LAM enabling patchset by
Robert Hu
(https://lore.kernel.org/all/20230227084547.404871-3-robert.hu@linux.intel.com),
and suggested by Sean Christopherson during code review
(https://lore.kernel.org/all/ZAuRec2NkC3+4jvD@google.com).

Binbin Wu (4):
  KVM: x86: Add helpers to check bit set in CR0/CR4 and return in bool
  KVM: x86: Replace kvm_read_{cr0,cr4}_bits() with
    kvm_is_{cr0,cr4}_bit_set()
  KVM: SVM: Remove implicit cast from ulong to bool in
    svm_can_emulate_instruction()
  KVM: x86: Change return type of is_long_mode() to bool

 arch/x86/kvm/cpuid.c          |  4 ++--
 arch/x86/kvm/kvm_cache_regs.h | 16 ++++++++++++++++
 arch/x86/kvm/mmu.h            |  2 +-
 arch/x86/kvm/svm/svm.c        |  9 +++------
 arch/x86/kvm/vmx/nested.c     |  2 +-
 arch/x86/kvm/vmx/vmx.c        |  2 +-
 arch/x86/kvm/x86.c            | 20 ++++++++++----------
 arch/x86/kvm/x86.h            | 22 +++++++++++-----------
 8 files changed, 45 insertions(+), 32 deletions(-)

-- 
2.25.1

