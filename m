Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3FC6F67B5
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 10:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjEDIr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 04:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjEDIr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 04:47:56 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67608197
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 01:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683190075; x=1714726075;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=h9hTaTGBdfxo+SIY8JyTFvo8SIUwW+7Fa3KQrxfYXBU=;
  b=foE4tavVlptkl9AuL2M3/GtnOsqZVnMvKfoxKb8Sjn7QqKhgVj9XCvfI
   7H5YltPckGpK8R6mOfiy1c9gWz4dmD06YKj3dgwB0141QVTajQragfl05
   P0hswQ/l5QegnK+btznoT2Rj29sAvbceDfPSozEr6IEydeW2ftyAtn5mJ
   PiVvdKYxPEYQvZi8/DzgTlwAaetnhgSFEIDU4/XWpTMKs7fGwusLUKt+6
   d6c0nZze/cJRxCGiXbuZJYq4z6YCdm7vVo2IZ88IhOTMNYPbx3WGD414Z
   6Z4GgY4QhGLRKJ9LggKsX5/0U1moGSNTVKycsTCPqmvMNql0KyQzWJLb4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="435178169"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="435178169"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 01:47:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="766480448"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="766480448"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.1.46])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 01:47:53 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        robert.hu@linux.intel.com, binbin.wu@linux.intel.com
Subject: [kvm-unit-tests v4 0/4] x86: Add test cases for LAM
Date:   Thu,  4 May 2023 16:47:47 +0800
Message-Id: <20230504084751.968-1-binbin.wu@linux.intel.com>
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
v3 --> v4:
Remove an extra space in patch 1.
Remove an unnecessary local variable in patch 2.
Add some comments about the linear address used for LAM tests in patch 2 and patch 3.
Add a static assert to check the physical address range for LAM user mode tests in patch 3.
Remove the unnecessary identical mapping code in patch 3.
Move common definitions and helper function to header file in patch 2.
LAM test of INVVPID is tested only when individual-address invalidation is supported in patch 4.
Add reviewed-by from Chao Gao in patch 2~4.

v2 --> v3:
Simplify the implementation of set_metadata() (Suggested by Chao Gao)
Move definition of X86_FEATURE_LAM to patch 1.
Remove strcpy case and unify memory & MMIO address access using MOV instruction.
Some code cleanups.
Add reviewed-by from Chao Gao in patch 1. 

v1 --> v2:
Add cases to test INVLPG, INVPCID, INVVPID with LAM_SUP
Add cases to test LAM_{U48,U57}

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
 x86/vmx_tests.c     |  58 +++++++-
 5 files changed, 401 insertions(+), 2 deletions(-)
 create mode 100644 x86/lam.c


base-commit: 02d8befe99f8205d4caea402d8b0800354255681
-- 
2.25.1

