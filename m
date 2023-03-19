Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832126C000C
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 09:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjCSIhl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 04:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCSIhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 04:37:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D48823C51
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 01:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679215059; x=1710751059;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GnHfYMJxpoME59pqrjeevaBLkPPNLkWjl7Vykxc5gJQ=;
  b=Nmvp7bbPK+A6HREY40Yn6L4WgUfdWJeBkz9upkV/V+gy4wBWaadilzPQ
   6GayfCKkHUJMKHxlhAJdoJhuw//mGXjZztAdTT3rt9sjFpyYC/2cqv/3S
   gqDN0nesJMIdhcmWHN8eJb8kqG6nC74ceOc4Cvcp/TQZ5IZ9At+plIiTN
   tg7+yno9BjByXtOZWUZAI/PmwIuiDXIHHEPJh3SWR9Rnx1PAEUNCS9eY8
   RAoQxN6VNDs/Xq7ScfWLsOAp1B8BPVk1YCQxc25g4PnsXo+8TpFS/xPzV
   ABrhF+jAvk5G3kVRt0LH4gksZqWKC8QIZ5BxvMe5fjaZvIRpLPX3QW0Fm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="424767121"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="424767121"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:37:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="769853306"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="769853306"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.209.111])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:37:36 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     chao.gao@intel.com, robert.hu@linux.intel.com,
        binbin.wu@linux.intel.com
Subject: [kvm-unit-tests PATCH v2 0/4] x86: Add test cases for LAM
Date:   Sun, 19 Mar 2023 16:37:28 +0800
Message-Id: <20230319083732.29458-1-binbin.wu@linux.intel.com>
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

