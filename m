Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7B1603C9E
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 10:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiJSIui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 04:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbiJSIuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 04:50:14 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9766E391;
        Wed, 19 Oct 2022 01:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666169327; x=1697705327;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bke7pt/L5leJggylT7vFGl+uEMcqyFQEdIPltWZFGKA=;
  b=Xu6Xu43ExYiG7toCdIlX9dm7H69ikqz/XaV8AXRE19ksRRNwR8VJFkCS
   4CGxULOgPNH7XN6P9/gBkBH3B+vTojinLA34yqbkjeDWJP/phu4EsVXJx
   GYiTHv+eMS/dYY7rNqilnpr3iOeiRvU/tyUX3YdmRPQf7yy/Q8Pxg62XR
   wnVhXzXWjkdfb/dputd+NItTvXzGiiY2A4F9AZ50MXaIH3JrE2hYbqV1P
   AOe2vYyxj4MFy+7v9DhltthXoE7bcNgcvpbgIkG7tGupQ6oyN9Ewzp00g
   ZmmZ+LwyWyuRcFW0PgjlSzqI7x2avTzhkWDtnF6EcXBllrU7ikfyLvlUZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="289665536"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="289665536"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 01:47:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="804195807"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="804195807"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by orsmga005.jf.intel.com with ESMTP; 19 Oct 2022 01:47:34 -0700
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jiaxi.chen@linux.intel.com, jpoimboe@kernel.org,
        chang.seok.bae@intel.com, pawan.kumar.gupta@linux.intel.com,
        babu.moger@amd.com, jmattson@google.com, sandipan.das@amd.com,
        tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        fenghua.yu@intel.com, keescook@chromium.org,
        jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] x86: KVM: Expose CPUID to guest for new Intel platform instructions
Date:   Wed, 19 Oct 2022 16:47:28 +0800
Message-Id: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

This series enables related CPUID bit in the kernel feature bits and
expose them to KVM guest OS.

[1] Intel ISE: https://cdrdv2.intel.com/v1/dl/getContent/671368

Chang S. Bae (1):
  x86: KVM: Enable AMX-FP16 CPUID and expose it to guest

Jiaxi Chen (5):
  x86: KVM: Enable CMPccXADD CPUID and expose it to guest
  x86: KVM: Enable AVX-IFMA CPUID and expose it to guest
  x86: KVM: Enable AVX-VNNI-INT8 CPUID and expose it to guest
  x86: KVM: Enable AVX-NE-CONVERT CPUID and expose it to guest
  x86: KVM: Enable PREFETCHIT0/1 CPUID and expose it to guest

 arch/x86/include/asm/cpufeature.h        |  7 +++++--
 arch/x86/include/asm/cpufeatures.h       | 10 +++++++++-
 arch/x86/include/asm/disabled-features.h |  3 ++-
 arch/x86/include/asm/required-features.h |  3 ++-
 arch/x86/kernel/cpu/common.c             |  1 +
 arch/x86/kvm/cpuid.c                     |  8 ++++++--
 arch/x86/kvm/reverse_cpuid.h             |  1 +
 7 files changed, 26 insertions(+), 7 deletions(-)


base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
-- 
2.27.0

