Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09E961746E
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 03:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiKCCun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 22:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiKCCug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 22:50:36 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904BD13EB9;
        Wed,  2 Nov 2022 19:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667443835; x=1698979835;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=umHqhN8ACTaJ0k/HEQLPWAnfJ+IKe345eO8X82qRkhM=;
  b=GoFAO1piP2/rtGgJdNB80x7J0g9PlF3Torzj2TOGivFihNDJbguAQnmn
   RPlODUYX7lMet7PTJh+Itq64HJqJIcB4kLPlTrIhQYnSbfI9ITIiymI+p
   jZYcIEFQTuu7JiGHa7MO9KYNVUugA9Y+RUbNug6TYvueur2OozD+RItUm
   wqRemChYFC9xAwj94ASCMw4RK3jQDqJJhoPGj2XYIJ70CkofSYK+N9Uvd
   kgKJPA2S8Ihaq2B82nX7wAhEeWdtGJG8/E0gRL4zJ9spnxQ8XCO6it3xh
   ro/EIBs500fHMDHqjoxiu1NZsRhXSrRY9NWXQV51LDBnXMfhtAvWCGzgn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="308289812"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="308289812"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 19:50:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="698047804"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="698047804"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2022 19:50:30 -0700
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] x86: KVM: Advertise CPUID of new Intel platform instructions to user space
Date:   Thu,  3 Nov 2022 10:50:22 +0800
Message-Id: <20221103025030.78371-1-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Latest Intel platform Granite Rapids/Sierra Forest has introduced below
new instructions and CPUIDs:

 - CMPccXADD CPUID.(EAX=7,ECX=1):EAX[bit 7]
 - AMX-FP16 CPUID.(EAX=7,ECX=1):EAX[bit 21]
 - AVX-IFMA CPUID.(EAX=7,ECX=1):EAX[bit 23]
 - AVX-VNNI-INT8 CPUID.(EAX=7,ECX=1):EDX[bit 4]
 - AVX-NE-CONVERT CPUID.(EAX=7,ECX=1):EDX[bit 5]
 - PREFETCHITI CPUID.(EAX=7,ECX=1):EDX[bit 14]

Details can be found in recent Intel ISE (Instruction Set
Extensions)[1].

This patch series advertises KVM support of these CPUIDs to host
userspace.

[1] Intel ISE: https://cdrdv2.intel.com/v1/dl/getContent/671368

v2:
 - Remove vague descriptions in the changelogs, including pronouns and
   "this patch" kind of things.
 - Move the two CPUIDs of cpuid_leaf[12] CPUID_7_1_EAX to kvm-only
   subleaves.
 - Replace cpuid_leaf[12] CPUID_7_1_EAX with the last leaf
   CPUID_8000_001F_EAX to shorten array length.
 - Change the newly-added CPUID leaf [CPUID_7_1_EDX] in v1 into kvm-only
   subleaves. 
 
v1:
https://lore.kernel.org/all/20221019084734.3590760-1-jiaxi.chen@linux.intel.com/

Jiaxi Chen (8):
  x86: KVM: Move existing x86 CPUID leaf [CPUID_7_1_EAX] to kvm-only
    leaf
  x86/cpufeatures: Replace [CPUID_DUMMY] in cpuid_leafs[] with the last
    leaf
  x86: KVM: Advertise CMPccXADD CPUID to user space
  x86: KVM: Advertise AMX-FP16 CPUID to user space
  x86: KVM: Advertise AVX-IFMA CPUID to user space
  x86: KVM: Advertise AVX-VNNI-INT8 CPUID to user space
  x86: KVM: Advertise AVX-NE-CONVERT CPUID to user space
  x86: KVM: Advertise PREFETCHIT0/1 CPUID to user space

 arch/x86/include/asm/cpufeature.h        |  9 +++------
 arch/x86/include/asm/cpufeatures.h       | 20 ++++++++------------
 arch/x86/include/asm/disabled-features.h |  3 +--
 arch/x86/include/asm/required-features.h |  3 +--
 arch/x86/kernel/cpu/common.c             |  6 ------
 arch/x86/kernel/cpu/cpuid-deps.c         |  1 -
 arch/x86/kvm/cpuid.c                     | 11 ++++++++---
 arch/x86/kvm/reverse_cpuid.h             | 15 +++++++++++++++
 8 files changed, 36 insertions(+), 32 deletions(-)


base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
-- 
2.27.0

