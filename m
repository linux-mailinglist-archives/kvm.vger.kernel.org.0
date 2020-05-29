Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003D81E78DA
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 10:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgE2Izv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 04:55:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:46106 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgE2Izv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 04:55:51 -0400
IronPort-SDR: 8ex6SwceJnB4TZAx47LIO3i7So8Ew13I3c4EPKDOHuRfoiDV2fe5ZBejuVqhAYnskElO/3nv1G
 vXYHLawXBtPA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 01:55:49 -0700
IronPort-SDR: Ul+ulAZFCXjFc9vftd+oM/y7uubCSqC0boFt6Dw0DI5xn9ovGP/gPLoIO7WZSRmYp1K1M7EiUS
 zmAvp/1lpnzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,448,1583222400"; 
   d="scan'208";a="311188287"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by FMSMGA003.fm.intel.com with ESMTP; 29 May 2020 01:55:47 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 0/6] Refactor handling flow of SET_CPUID*
Date:   Fri, 29 May 2020 16:55:39 +0800
Message-Id: <20200529085545.29242-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This serial is the extended version of
https://lkml.kernel.org/r/20200528151927.14346-1-xiaoyao.li@intel.com

First two patches are bug fixing, and the other aim to refactor the flow
of SET_CPUID* as:
1. cpuid check: check if userspace provides legal CPUID settings;

2. cpuid update: Update some special CPUID bits based on current vcpu
                 state, e.g., OSXSAVE, OSPKE, ...

3. update KVM state: Update KVM states based on the final CPUID
                     settings. 

Xiaoyao Li (6):
  KVM: X86: Reset vcpu->arch.cpuid_nent to 0 if SET_CPUID fails
  KVM: X86: Go on updating other CPUID leaves when leaf 1 is absent
  KVM: X86: Introduce kvm_check_cpuid()
  KVM: X86: Split kvm_update_cpuid()
  KVM: X86: Move kvm_x86_ops.cpuid_update() into
    kvm_update_state_based_on_cpuid()
  KVM: X86: Move kvm_apic_set_version() to
    kvm_update_state_based_on_cpuid()

 arch/x86/kvm/cpuid.c | 107 +++++++++++++++++++++++++++----------------
 arch/x86/kvm/cpuid.h |   3 +-
 arch/x86/kvm/x86.c   |   1 +
 3 files changed, 70 insertions(+), 41 deletions(-)

-- 
2.18.2

