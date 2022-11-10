Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C60623956
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbiKJBzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbiKJByt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:54:49 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A00A27B35;
        Wed,  9 Nov 2022 17:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668045288; x=1699581288;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uiULuwZpOSthgGSoIhQHAYKYU4Q0iMPtiXNcMYxg49s=;
  b=ZyjJcCYu5J0aqzYCoUfQIw/C65GEiDTxoJNfukp9jNZwbwu3+dMmrrOd
   m38pOdqdV9got21bbefjoE3255aXGvkUds4toIc4k1dXdgvs/ZjmKwjzW
   lQgbHjKphLO0M453rN2Uvh7B4p/gb2wCdq8SV2VAypVhDyKP1ZuKsXHr5
   ro+nuvw+P/XXaYn/J5DrtkgKqxfi61YmbqdnBpPpmdovRhUBS1zSlL3zA
   UpfNtql2X78zMG7yeSeH9fVZ3I7cm3MtLEc7mOIYxbHSWprMO8uA/puRa
   HQmlqBM/d1Q7lK/QHZtXOdh+ayunSf+T7RHR4TrZt4BcbNqNqQXm6L2Xv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="290899829"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="290899829"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 17:52:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="762099752"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="762099752"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by orsmga004.jf.intel.com with ESMTP; 09 Nov 2022 17:52:47 -0800
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
Subject: [PATCH v3 0/7] x86: KVM: Advertise CPUID of new Intel platform
Date:   Thu, 10 Nov 2022 09:52:45 +0800
Message-Id: <20221110015252.202566-1-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
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

v3:
 - Remain CPUID_8000_001F_EAX in the last leaf of cpuid_leaf[]
 - Replace CPUID_7_1_EAX with CPUID_LNX_5, waiting for future new CPUIDs

v2:
https://lore.kernel.org/all/20221103025030.78371-1-jiaxi.chen@linux.intel.com/
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

Jiaxi Chen (7):
  x86: KVM: Move existing x86 CPUID leaf [CPUID_7_1_EAX] to kvm-only
    leaf
  x86: KVM: Advertise CMPccXADD CPUID to user space
  x86: KVM: Advertise AMX-FP16 CPUID to user space
  x86: KVM: Advertise AVX-IFMA CPUID to user space
  x86: KVM: Advertise AVX-VNNI-INT8 CPUID to user space
  x86: KVM: Advertise AVX-NE-CONVERT CPUID to user space
  x86: KVM: Advertise PREFETCHIT0/1 CPUID to user space

 arch/x86/include/asm/cpufeature.h  |  2 +-
 arch/x86/include/asm/cpufeatures.h |  4 +---
 arch/x86/kernel/cpu/common.c       |  6 ------
 arch/x86/kernel/cpu/cpuid-deps.c   |  1 -
 arch/x86/kvm/cpuid.c               | 11 ++++++++---
 arch/x86/kvm/reverse_cpuid.h       | 15 +++++++++++++++
 6 files changed, 25 insertions(+), 14 deletions(-)


base-commit: 30a0b95b1335e12efef89dd78518ed3e4a71a763
-- 
2.27.0

