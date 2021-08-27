Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAD33F94BA
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 09:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244234AbhH0HDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 03:03:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:6103 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232463AbhH0HDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 03:03:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="205045865"
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="205045865"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 00:03:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="495552994"
Received: from lxy-dell.sh.intel.com ([10.239.159.31])
  by fmsmga008.fm.intel.com with ESMTP; 27 Aug 2021 00:02:59 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] KVM: VMX: PT (processor trace) optimization cleanup and fixes
Date:   Fri, 27 Aug 2021 15:02:42 +0800
Message-Id: <20210827070249.924633-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1-3 are optimization and cleanup. 

Patch 4-7 are fixes for PT. Patch 4 and 5 fix the virtulazation of PT to
provide architectual consistent behavior for guest. Patch 6 fix the case
that malicious userspace can exploit PT to cause vm-entry failure or #GP
in KVM. Patch 7 fix the potential MSR access #GP if some PT MSRs not
available on hardware.

Patch 3 and patch 7 are added in v2.

Xiaoyao Li (7):
  KVM: VMX: Restore host's MSR_IA32_RTIT_CTL when it's not zero
  KVM: VMX: Use precomputed vmx->pt_desc.addr_range
  KVM: VMX: Rename pt_desc.addr_range to pt_desc.nr_addr_range
  KVM: VMX: RTIT_CTL_BRANCH_EN has no dependency on other CPUID bit
  KVM: VMX: Disallow PT MSRs accessing if PT is not exposed to guest
  KVM: VMX: Check Intel PT related CPUID leaves
  KVM: VMX: Only context switch some PT MSRs when they exist

 arch/x86/kvm/cpuid.c   |  25 ++++++++++
 arch/x86/kvm/vmx/vmx.c | 110 ++++++++++++++++++++++++++---------------
 arch/x86/kvm/vmx/vmx.h |   2 +-
 3 files changed, 95 insertions(+), 42 deletions(-)

-- 
2.27.0

