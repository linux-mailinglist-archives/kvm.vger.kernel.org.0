Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A0B217FD3
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 08:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgGHGvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 02:51:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:5284 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgGHGvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 02:51:00 -0400
IronPort-SDR: TVXUIb7JUTtyAv+TRK7wXFPgHS6zpxPivp6jZ0KgICRMvpw7m6bsMZA6nYn2gw2/X6LwnsphAD
 BjepTfUrqSGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="145852056"
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="145852056"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 23:50:59 -0700
IronPort-SDR: 2+VAslrMs72o338mVcRjdbGXU7ZUvJXZN3C3gdeN3BJfNTru2r5LOp56K5pPFLImHz98RHPVUb
 3Tp6FdFQ09uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="457399062"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga005.jf.intel.com with ESMTP; 07 Jul 2020 23:50:57 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v3 0/8] Refactor handling flow of KVM_SET_CPUID*
Date:   Wed,  8 Jul 2020 14:50:46 +0800
Message-Id: <20200708065054.19713-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This serial is the extended version of
https://lkml.kernel.org/r/20200528151927.14346-1-xiaoyao.li@intel.com

First two patches are bug fixing, and the others aim to refactor the flow
of SET_CPUID* as:

1. cpuid check: check if userspace provides legal CPUID settings;

2. cpuid update: Update some special CPUID bits based on current vcpu
                 state, e.g., OSXSAVE, OSPKE, ...

3. update vcpu model: Update vcpu model (settings) based on the final CPUID
                      settings. 

v3:
 - Add a note in KVM api doc to state the previous CPUID configuration
   is not reliable if current KVM_SET_CPUID* fails [Jim]
 - Adjust Patch 2 to reduce code churn [Sean]
 - Commit message refine to add more justification [Sean]
 - Add a new patch (7)

v2:
https://lkml.kernel.org/r/20200623115816.24132-1-xiaoyao.li@intel.com
 - rebase to kvm/queue: a037ff353ba6 ("Merge branch 'kvm-master' into HEAD")
 - change the name of kvm_update_state_based_on_cpuid() to
   kvm_update_vcpu_model() [Sean]
 - Add patch 5 to rename kvm_x86_ops.cpuid_date() to
   kvm_x86_ops.update_vcpu_model()

v1:
https://lkml.kernel.org/r/20200529085545.29242-1-xiaoyao.li@intel.com

Xiaoyao Li (8):
  KVM: X86: Reset vcpu->arch.cpuid_nent to 0 if SET_CPUID* fails
  KVM: X86: Go on updating other CPUID leaves when leaf 1 is absent
  KVM: X86: Introduce kvm_check_cpuid()
  KVM: X86: Split kvm_update_cpuid()
  KVM: X86: Rename cpuid_update() to update_vcpu_model()
  KVM: X86: Move kvm_x86_ops.update_vcpu_model() into
    kvm_update_vcpu_model()
  KVM: lapic: Use guest_cpuid_has() in kvm_apic_set_version()
  KVM: X86: Move kvm_apic_set_version() to kvm_update_vcpu_model()

 Documentation/virt/kvm/api.rst  |   4 ++
 arch/x86/include/asm/kvm_host.h |   2 +-
 arch/x86/kvm/cpuid.c            | 107 ++++++++++++++++++++------------
 arch/x86/kvm/cpuid.h            |   3 +-
 arch/x86/kvm/lapic.c            |   4 +-
 arch/x86/kvm/svm/svm.c          |   4 +-
 arch/x86/kvm/vmx/nested.c       |   2 +-
 arch/x86/kvm/vmx/vmx.c          |   4 +-
 arch/x86/kvm/x86.c              |   1 +
 9 files changed, 81 insertions(+), 50 deletions(-)

-- 
2.18.4

