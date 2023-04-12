Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D7F6DECFB
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 09:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjDLHvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 03:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjDLHvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 03:51:45 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB10B61A9
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 00:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681285904; x=1712821904;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UYv7BwzRSfACtoewCgvghpGquIOeP9CbWV1k3aM/RJY=;
  b=Zm5mbXYRPFp6PysngGuPqJ+/iUOHPblR5M1JKnulBav8mpK51otZXT0R
   dDrjh1739oXwGkYuSJEMf0qqLLNvPt6/asCLB+ETG3bYEHYe3uT/wKqOV
   Efy0Lclwq0YRC9UQwRTY8FuBTYqeOl+mq6+A9zY0FzhTayDK7P2xrum8l
   zSqnHcCNmhvOYOfy/sxn5CgpOoPrz1erfFcxssOq0dOW91I135O52b9o0
   SrujDDz1CFdEIID7vKCiRZVV/t9ZC3qB7L0JheTiXAvexLzFxcag7oi9U
   dr2xeuQ5+Z8b8QlZPFAGzI3T5IqLRK6fjF0ZMQfe2MY4GZrv2JVICN3qG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="345623246"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="345623246"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 00:51:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="812893649"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="812893649"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.8.125])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 00:51:42 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     binbin.wu@linux.intel.com, chao.gao@intel.com,
        robert.hu@linux.intel.com
Subject: [kvm-unit-tests v3 0/4] x86: Add test cases for LAM
Date:   Wed, 12 Apr 2023 15:51:30 +0800
Message-Id: <20230412075134.21240-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

 lib/x86/processor.h |   7 +
 x86/Makefile.x86_64 |   1 +
 x86/lam.c           | 315 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  10 ++
 x86/vmx_tests.c     |  66 +++++++++-
 5 files changed, 398 insertions(+), 1 deletion(-)
 create mode 100644 x86/lam.c

-- 
2.25.1

