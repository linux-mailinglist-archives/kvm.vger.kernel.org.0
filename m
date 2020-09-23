Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF02275DE7
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 18:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgIWQvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 12:51:08 -0400
Received: from mga06.intel.com ([134.134.136.31]:17994 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgIWQut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 12:50:49 -0400
IronPort-SDR: cAtwwTepbPSHsdCY3SV8hJC373gLA2yReXYPI+xqCpnpGcO9+uHRR4ZS1b+TE2C3ReA/zlQ3WQ
 9s8Dr6WylfiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="222529024"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="222529024"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 09:50:48 -0700
IronPort-SDR: S2ARUoPugkAvYLcEzjtZ6EXsuKeT46j6cDERXO6JItuC4CUm78wsMf1d3MVyMcMv+q/piNmTau
 pZYZ/TkcOVmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="454985293"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga004.jf.intel.com with ESMTP; 23 Sep 2020 09:50:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] KVM: VMX: Add helper+macros to do sec exec adjustment
Date:   Wed, 23 Sep 2020 09:50:44 -0700
Message-Id: <20200923165048.20486-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper function and macro wrappers to consolidate code for adjusting
secondary execution controls based on guest CPUID.  The adjustments are
effectively 10+ lines of copy+paste for each control, with slight tweaks
to account for annoying differences, e.g. XSAVES has additional checks.

Patches 1-3 are prep work to make INVPCID and RDTSCP align with the
"standard" nomenclature so that they don't require special casing.

Sean Christopherson (4):
  KVM: VMX: Rename vmx_*_supported() helpers to cpu_has_vmx_*()
  KVM: VMX: Unconditionally clear CPUID.INVPCID if !CPUID.PCID
  KVM: VMX: Rename RDTSCP secondary exec control name to insert "ENABLE"
  KVM: VMX: Add a helper and macros to reduce boilerplate for sec exec
    ctls

 arch/x86/include/asm/vmx.h                    |   2 +-
 arch/x86/kvm/vmx/capabilities.h               |  10 +-
 arch/x86/kvm/vmx/nested.c                     |   4 +-
 arch/x86/kvm/vmx/vmx.c                        | 150 +++++++-----------
 .../selftests/kvm/include/x86_64/vmx.h        |   2 +-
 5 files changed, 64 insertions(+), 104 deletions(-)

-- 
2.28.0

