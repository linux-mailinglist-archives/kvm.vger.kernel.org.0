Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF69B7153F5
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 04:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjE3Cov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 22:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjE3Col (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 22:44:41 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB5EC9
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 19:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685414647; x=1716950647;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=k6qBzsmG7ZCmAh1FixAE6CxTZCulv4SA9XmKgw4BuV8=;
  b=ZunA1iGwWvHwH8guTgCe2Nyh+EuIq4m4pA20Be5goB4KPI6nU3P8Drwy
   hl3BZdKF2MIu/jFY6hosddsNfTJ+W8aR8qJqJvrrsxgCphdNQBJ5yjqOz
   Cz+KVfpXEyIXZI4lkmtBDnPdq8gQTAWNWOpwi8PXkWzNjGD7ODFNbzMvH
   Rz2Hs/874vFSLbiBSww5O91ykE8QOuFQyu+uwCSZnFRC+KoIG7oLGlmvI
   73S6DOR52BSVV2j0UmaZOKw+lKIusmNphptjMSiYUxHvTUdijD0WB9oBu
   zUDNzKwP69crDGI4icLTmNNIjJKfCi+jWeY5OwtLAxgrtEE0F0tzRaz8o
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="418287000"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="418287000"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 19:44:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="656658762"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="656658762"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.208.104])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 19:44:02 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        robert.hu@linux.intel.com, binbin.wu@linux.intel.com
Subject: [PATCH v5 0/4] x86: Add test cases for LAM
Date:   Tue, 30 May 2023 10:43:52 +0800
Message-Id: <20230530024356.24870-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel Linear-address masking (LAM) [1], modifies the checking that is applied to
*64-bit* linear addresses, allowing software to use of the untranslated address
bits for metadata.

The patch series add test cases for KVM LAM:

Patch 1 makes change to allow setting of CR3 LAM bits in vmlaunch tests.
Patch 2~4 add test cases for LAM supervisor mode and user mode, including:
- For supervisor mode
  CR4.LAM_SUP toggle
  Memory/MMIO access with tagged pointer
  INVLPG
  INVPCID
  INVVPID (also used to cover VMX instruction VMExit path)
- For user mode
  CR3 LAM bits toggle 
  Memory/MMIO access with tagged pointer

[1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
    Chapter Linear Address Masking (LAM)

---
Changelog
v4 --> v5:
- LAM doesn't apply to the target linear address in the INVVPID descriptor.
  Change the test cases in patch 4 accordingly. Dropped the reviewed-by from Chao due to the change.

v3 --> v4:
- Remove an extra space in patch 1.
- Remove an unnecessary local variable in patch 2.
- Add some comments about the linear address used for LAM tests in patch 2 and patch 3.
- Add a static assert to check the physical address range for LAM user mode tests in patch 3.
- Remove the unnecessary identical mapping code in patch 3.
- Move common definitions and helper function to header file in patch 2.
- LAM test of INVVPID is tested only when individual-address invalidation is supported in patch 4.
- Add reviewed-by from Chao Gao in patch 2~4.

v2 --> v3:
- Simplify the implementation of set_metadata() (Suggested by Chao Gao)
- Move definition of X86_FEATURE_LAM to patch 1.
- Remove strcpy case and unify memory & MMIO address access using MOV instruction.
- Some code cleanups.
- Add reviewed-by from Chao Gao in patch 1. 

v1 --> v2:
- Add cases to test INVLPG, INVPCID, INVVPID with LAM_SUP
- Add cases to test LAM_{U48,U57}

Binbin Wu (3):
  x86: Allow setting of CR3 LAM bits if LAM supported
  x86: Add test cases for LAM_{U48,U57}
  x86: Add test case for INVVPID with LAM

Robert Hoo (1):
  x86: Add test case for LAM_SUP

 lib/x86/processor.h |  15 +++
 x86/Makefile.x86_64 |   1 +
 x86/lam.c           | 319 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  10 ++
 x86/vmx_tests.c     |  52 +++++++-
 5 files changed, 395 insertions(+), 2 deletions(-)
 create mode 100644 x86/lam.c


base-commit: 02d8befe99f8205d4caea402d8b0800354255681
-- 
2.25.1

