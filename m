Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C94C6C0001
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 09:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjCSIWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 04:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCSIWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 04:22:36 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10CD22C92
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 01:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679214155; x=1710750155;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GnHfYMJxpoME59pqrjeevaBLkPPNLkWjl7Vykxc5gJQ=;
  b=Rh79/fMvo3+CJyntp0/eslDFHlZCyxvclYZMyiGZQ/oTEZ5HGoyh+K4T
   7XCVcGud3yIF0UTsuQsVFmzTC3KDteMgzZlPkMtqmMV0qJnPDeSK/+wQu
   xcENeEWbUTy4zzMfpRt02VXorx3qZ0q5dQZTPYnQ9q6w6+sW2x5Ebb7o+
   ROi8unBTV6WtqfiOpTBAph90gvVlxsnLEWeVfCSmACnFlb5rH6ViVK74L
   6cfWB99o7EQwJqN5u4iXC5jX2GzQjTrx9Z9bCh8LCXCbbeOgpmcYre0Vu
   L3NxN52fPJzBZVe/e9xur5L6KzvYUpCsNxQgBA+MgFGiYaAbRGqfcSB8t
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="340849317"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="340849317"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:22:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="749741042"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="749741042"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.209.111])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:22:33 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     chao.gao@intel.com, robert.hu@linux.intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v2 0/4] x86: Add test cases for LAM
Date:   Sun, 19 Mar 2023 16:22:21 +0800
Message-Id: <20230319082225.14302-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel Linear-address masking (LAM) [1], modifies the checking that is applied to
*64-bit* linear addresses, allowing software to use of the untranslated address
bits for metadata.

The patch series add test cases for LAM:

Patch 1 makes change to HOST_CR3 tests in vmx.
If LAM is supported, VM entry allows CR3.LAM_U48 (bit 62) and CR3.LAM_U57
(bit 61) to be set in CR3 field. Change the test result expectations when
setting CR3.LAM_U48 or CR3.LAM_U57 on vmlaunch tests when LAM is supported.

Patch 2~4 add test cases for LAM supervisor mode and user mode, including:
- For supervisor mode
  CR4.LAM_SUP toggle
  Memory/MMIO access with tagged pointer
  INVLPG
  INVPCID
  INVVPID (also used to cover VMX instruction vmexit path)
- For user mode
  CR3 LAM bits toggle 
  Memory/MMIO access with tagged pointer

[1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
    Chapter Linear Address Masking (LAM)

---
Changelog
v1 --> v2:
Add cases to test INVLPG, INVPCID, INVVPID with LAM_SUP
Add cases to test LAM_{U48,U57}

Binbin Wu (3):
  x86: Allow setting of CR3 LAM bits if LAM supported
  x86: Add test cases for LAM_{U48,U57}
  x86: Add test case for INVVPID with LAM

Robert Hoo (1):
  x86: Add test case for LAM_SUP

 lib/x86/processor.h |   7 +
 x86/Makefile.x86_64 |   1 +
 x86/lam.c           | 340 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  10 ++
 x86/vmx_tests.c     |  79 +++++++++-
 5 files changed, 436 insertions(+), 1 deletion(-)
 create mode 100644 x86/lam.c


base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6
-- 
2.25.1

