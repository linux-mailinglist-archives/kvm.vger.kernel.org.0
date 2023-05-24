Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851EC70EDBE
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 08:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239236AbjEXGRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 02:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238372AbjEXGQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 02:16:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634A6184;
        Tue, 23 May 2023 23:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684909016; x=1716445016;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pmlnhEwlLJ82wU3OOOEr2W6zri3/mEqlLsG47OGicj0=;
  b=cy7BpqLam0SquWxxrRxyAX1T9fZTaaxOrG6bhHn6GNBngYiV0VxjwREw
   55nJuQlIwBNX2yIIZQ+cBv8tWn45f6brxVbq3Dp47+Jw4nZ2TfzKi16F2
   XIyQ0X80vESIZ/3W0ZIY2dHcbaV0Cvz+Zg9gJREhnjzREnFyhVYvJAEKX
   AKRpafnmLnSpCPt2n6BLpLCEMTuuQuLU2iJ6aEDr/xazy/PAubIr3gLbz
   HfAuBzKWVlmxMGN2Ef2cjlv4KY/6H9FRDBb6qG1ePNzsJffpDpkuZSX5C
   E225bPdfxcquiox+qMqyEzEuLrGhrzBh6PZqPD9iEgclD5QUYg2qfw3cG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="356695040"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="356695040"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 23:16:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="704212331"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="704212331"
Received: from spr.sh.intel.com ([10.239.53.106])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 23:16:49 -0700
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     xiaoyao.li@intel.com, Chao Gao <chao.gao@intel.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Kim Phillips <kim.phillips@amd.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 0/3] MSR_IA32_ARCH_CAPABILITIES cleanups
Date:   Wed, 24 May 2023 14:16:30 +0800
Message-Id: <20230524061634.54141-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do some cleanups about MSR_IA32_ARCH_CAPABILITIES in KVM e.g, fix stale
comments, elimite open-coded MSR reads, track features that can be exposed to
guests to avoid computing them runtime. They are found when reading the code.

No functional change intented.

Changes from v1 -> v2:
1. toggle ARCH_CAP_SKIP_VMENTRY_L1DFLUSH bit when l1tf mitigation state is
   changed by module param. [Xiaoyao, Sean]
2. add more cleanups (patch 2/3)


Chao Gao (3):
  KVM: x86: Track supported ARCH_CAPABILITIES in kvm_caps
  KVM: x86: Correct the name for skipping VMENTER l1d flush
  x86/cpu, KVM: Use helper function to read MSR_IA32_ARCH_CAPABILITIES

 arch/x86/kernel/cpu/common.c |  1 +
 arch/x86/kvm/vmx/vmx.c       | 44 +++++++++++++++++++++++-------------
 arch/x86/kvm/x86.c           | 16 +++++--------
 arch/x86/kvm/x86.h           |  1 +
 4 files changed, 36 insertions(+), 26 deletions(-)


base-commit: b9846a698c9aff4eb2214a06ac83638ad098f33f
-- 
2.40.0

