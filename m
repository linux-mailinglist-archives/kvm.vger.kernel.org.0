Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A2962F6EF
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 15:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242172AbiKROPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 09:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235346AbiKROPI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 09:15:08 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F33B86D;
        Fri, 18 Nov 2022 06:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668780906; x=1700316906;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kgwfj666Hn/jjwJkiJmYAna/GTOF1Zq042PLDZl4GNI=;
  b=efmHJ8uHuunNRUK8pJMyeVlHcIfQ89uDG4liUDdJygkPHYvPajm0dlj7
   +vBkBl2zCcaH8yy3eq77Y5/Fd1CWQfu4JlOg9ooT6TL5hc9WIRdYqLJmu
   ZLg6tvFaTl9eXDZR23bL6U/Dja4Fu5NE22m5ltyA3ofAE86ZNoM0FEpqV
   wFtyQn8Rrm2jnWMac1UOojV5caq6QGme/jeFaDHq7pAJtOufF2OWdjpyo
   eFUhSgRuMwoRnZ0DF/pNIZGmnf05F84tZvHsqKRBM+TZr7EKHZblwPR7x
   QzB0olG2d/2Wr32b5KGLWKhRq8RUkXkoI9r73J0+tc2gsDLB5cr4uc2Vc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="375274220"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="375274220"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 06:15:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="673204414"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="673204414"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by orsmga001.jf.intel.com with ESMTP; 18 Nov 2022 06:15:00 -0800
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
Subject: [PATCH v4 0/6] x86: KVM: Advertise CPUID of new Intel platform instructions to user space
Date:   Fri, 18 Nov 2022 22:15:03 +0800
Message-Id: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
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

v4:
 - Put CPUID_7_1_EAX back to cpuid_leaf[], considering more bits will be
   defined in the future for this leaf.

v3:
https://lore.kernel.org/lkml/20221110015252.202566-1-jiaxi.chen@linux.intel.com/
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
 
v1: https://lore.kernel.org/all/20221019084734.3590760-1-jiaxi.chen@linux.intel.com/

Chang S. Bae (1):
  x86: KVM: Advertise AMX-FP16 CPUID to user space

Jiaxi Chen (5):
  x86: KVM: Advertise CMPccXADD CPUID to user space
  x86: KVM: Advertise AVX-IFMA CPUID to user space
  x86: KVM: Advertise AVX-VNNI-INT8 CPUID to user space
  x86: KVM: Advertise AVX-NE-CONVERT CPUID to user space
  x86: KVM: Advertise PREFETCHIT0/1 CPUID to user space

 arch/x86/include/asm/cpufeatures.h | 3 +++
 arch/x86/kvm/cpuid.c               | 8 ++++++--
 arch/x86/kvm/reverse_cpuid.h       | 7 +++++++
 3 files changed, 16 insertions(+), 2 deletions(-)


base-commit: f0c4d9fc9cc9462659728d168387191387e903cc
-- 
2.27.0

