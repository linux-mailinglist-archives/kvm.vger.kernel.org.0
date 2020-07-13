Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10B521976B
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 06:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgGIEeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 00:34:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:10037 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgGIEeb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 00:34:31 -0400
IronPort-SDR: Gj3ggboWHNZSWnv8pg+XXRCNCpFh4iQeOuD3sxXAzoiJonQoyML6bsyAN46uWl6QIVKD52MVIL
 ynmX0WHudFUw==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="147011556"
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="147011556"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 21:34:30 -0700
IronPort-SDR: ekUZALqdUvV1jJuznU5aco34cHuYOTYFD60rr7O6jG2ufY3GB3FktmuLqvaODwL00QGujbarF2
 HYPmkHnL+xDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="297942856"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga002.jf.intel.com with ESMTP; 08 Jul 2020 21:34:27 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v4 0/5] Refactor handling flow of KVM_SET_CPUID*
Date:   Thu,  9 Jul 2020 12:34:21 +0800
Message-Id: <20200709043426.92712-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

4 Patches of v3 has been queued into kvm/queue branch. This v4 contains
the rest to refactor the flow of KVM_SET_CPUID* as:

1. cpuid check: check if userspace provides legal CPUID settings;

2. cpuid update: Update userspace provided CPUID settings. It currently
   only contains kvm_update_cpuid_runtime, which updates special CPUID
   bits based on the vcpu state, e.g., OSXSAVE, OSPKE. In the future, we
   can re-introduce kvm_update_cpuid() if KVM needs to force on/off some
   bits.

3. update vcpu states: Update vcpu states/settings based on the final updated
   CPUID settings. 

v4:
 - remove 4 queued patches
 - rebased to kvm/queue: c16ced9cc67a "x86/kvm/vmx: Use native read/write_cr2()"
 - fix one bug in v3 to call kvfree(cpuid_entries) in kvm_vcpu_ioctl_set_cpuid()
 - rename "update_vcpu_model" to "vcpu_after_set_cpuid" [Paolo]	
 - Add a new patch to extrace kvm_update_cpuid_runtime()

v3:
https://lkml.kernel.org/r/20200708065054.19713-1-xiaoyao.li@intel.com
 - Add a note in KVM api doc to state the previous CPUID configuration
   is not reliable if current KVM_SET_CPUID* fails [Jim]
 - Adjust Patch 2 to reduce code churn [Sean]
 - Commit message refine to add more justification [Sean]
 - Add a new patch 7

v2:
https://lkml.kernel.org/r/20200623115816.24132-1-xiaoyao.li@intel.com
 - rebase to kvm/queue: a037ff353ba6 ("Merge branch 'kvm-master' into HEAD")
 - change the name of kvm_update_state_based_on_cpuid() to
   kvm_update_vcpu_model() [Sean]
 - Add patch 5 to rename kvm_x86_ops.cpuid_date() to
   kvm_x86_ops.update_vcpu_model()

v1:
https://lkml.kernel.org/r/20200529085545.29242-1-xiaoyao.li@intel.com

Xiaoyao Li (5):
  KVM: x86: Introduce kvm_check_cpuid()
  KVM: x86: Extract kvm_update_cpuid_runtime() from kvm_update_cpuid()
  KVM: x86: Rename kvm_update_cpuid() to kvm_vcpu_after_set_cpuid()
  KVM: x86: Rename cpuid_update() callback to vcpu_after_set_cpuid()
  KVM: x86: Move kvm_x86_ops.vcpu_after_set_cpuid() into
    kvm_vcpu_after_set_cpuid()

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/cpuid.c            | 99 +++++++++++++++++++++------------
 arch/x86/kvm/cpuid.h            |  2 +-
 arch/x86/kvm/lapic.c            |  2 +-
 arch/x86/kvm/svm/svm.c          |  4 +-
 arch/x86/kvm/vmx/nested.c       |  3 +-
 arch/x86/kvm/vmx/vmx.c          |  4 +-
 arch/x86/kvm/x86.c              | 10 ++--
 8 files changed, 76 insertions(+), 50 deletions(-)

-- 
2.18.4

