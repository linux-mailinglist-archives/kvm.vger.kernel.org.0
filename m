Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A1A638AA2
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiKYM6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiKYM6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:58:38 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7D127903;
        Fri, 25 Nov 2022 04:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669381117; x=1700917117;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xP1nfhyQ8FOkPUPmd5LvYYecrF3SJgmtl4GzeuHjbw8=;
  b=K7rmQtJ+UFh8Oq49zTHoeazt5MgGdXhwM3ss1q1fhbTq0Eus9RBIIzF7
   iEDC/RkRz/jB+ytnad6Q7Rdq+csKrrCphO5m5Ij+FhU9QX/oiBk0UWB3g
   1FI1MYAvEOV2VCxRz1pV8bEmcDvBW2m/TrPNhAKGK88rDCdZFbCBHAPfv
   83LFerGesxLEmfCFVVtNGpQPOerVLFVdxZW+BsI3UGw7a/z1FYyYMyL13
   Tq365YB1lSB4hM4U4IteDNixWDv2D57ij13XWqP7wb7oLH29VJDeuMzfQ
   E3hJEg1U95c1D6zCZ4EseEdo3pfQlDSWGUmC5ukl05JK/DMLB1CYp/Lg/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="314513166"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="314513166"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:58:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="706061194"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="706061194"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by fmsmga008.fm.intel.com with ESMTP; 25 Nov 2022 04:58:32 -0800
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
Subject: [PATCH v5 0/8] x86: KVM: Advertise CPUID of new Intel platform instructions to user space
Date:   Fri, 25 Nov 2022 20:58:37 +0800
Message-Id: <20221125125845.1182922-1-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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

These features bits are on two CPUID leafs: CPUID_7_1_EAX and
CPUID_7_1_EDX. CPUID_7_1_EAX is an expected-dense leaf and some of its
bits have kernel usages, therefore give bits on this leaf an X86_FEATURE
definition in kernel. However, CPUID_7_1_EDX is dense and none of its
bits have truly kernel usages for the moment. Given that, move
CPUID_7_1_EDX to be a KVM-only leaf and plus an x86_FEATURE definition
for bits on this leaf to direct them to the KVM entry.

This patch series advertises KVM support of these CPUIDs to host
userspace. For all of these features, there are no new VMX controls or
additional host enabling required for guests to use them.

[1] Intel ISE: https://cdrdv2.intel.com/v1/dl/getContent/671368

v5:
 - Modify some inaccurate descriptions in the changelogs.
 - Address some naming-confusing problems for adding KVM-only leaves,
   including renaming function and adding comments. 

v4:
https://lore.kernel.org/kvm/20221118141509.489359-1-jiaxi.chen@linux.intel.com/
 - Put CPUID_7_1_EAX back to cpuid_leaf[], considering more bits will be
   defined in the future for this leaf.

v3:
https://lore.kernel.org/kvm/20221110015252.202566-1-jiaxi.chen@linux.intel.com/
 - Remain CPUID_8000_001F_EAX in the last leaf of cpuid_leaf[]
 - Replace CPUID_7_1_EAX with CPUID_LNX_5, waiting for future new CPUIDs

v2:
https://lore.kernel.org/kvm/20221103025030.78371-1-jiaxi.chen@linux.intel.com/
 - Remove vague descriptions in the changelogs, including pronouns and
   "this patch" kind of things.
 - Move the two CPUIDs of cpuid_leaf[12] CPUID_7_1_EAX to KVM-only
   subleaves.
 - Replace cpuid_leaf[12] CPUID_7_1_EAX with the last leaf
   CPUID_8000_001F_EAX to shorten array length.
 - Change the newly-added CPUID leaf [CPUID_7_1_EDX] in v1 into KVM-only
   subleaves. 
 
v1:
https://lore.kernel.org/kvm/20221019084734.3590760-1-jiaxi.chen@linux.intel.com/

Chang S. Bae (1):
  x86: KVM: Advertise AMX-FP16 CPUID to user space

Jiaxi Chen (5):
  x86: KVM: Advertise CMPccXADD CPUID to user space
  x86: KVM: Advertise AVX-IFMA CPUID to user space
  KVM: x86: Advertise AVX-VNNI-INT8 CPUID to user space
  KVM: x86: Advertise AVX-NE-CONVERT CPUID to user space
  KVM: x86: Advertise PREFETCHIT0/1 CPUID to user space

Sean Christopherson (2):
  KVM: x86: Add BUILD_BUG_ON() to detect bad usage of "scattered" flags
  KVM: x86: Update KVM-only leaf handling to allow for 100% KVM-only
    leafs

 arch/x86/include/asm/cpufeatures.h |  3 +++
 arch/x86/kvm/cpuid.c               | 25 ++++++++++++++++++-------
 arch/x86/kvm/reverse_cpuid.h       | 25 ++++++++++++++++++++++---
 3 files changed, 43 insertions(+), 10 deletions(-)


base-commit: 094226ad94f471a9f19e8f8e7140a09c2625abaa
-- 
2.27.0

