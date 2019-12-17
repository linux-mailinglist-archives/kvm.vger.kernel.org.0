Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8821238B9
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 22:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbfLQVco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 16:32:44 -0500
Received: from mga04.intel.com ([192.55.52.120]:17437 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbfLQVco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 16:32:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 13:32:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; 
   d="scan'208";a="227639443"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 17 Dec 2019 13:32:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] KVM: x86: X86_FEATURE bit() cleanup
Date:   Tue, 17 Dec 2019 13:32:37 -0800
Message-Id: <20191217213242.11712-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small series to add build-time protections on reverse CPUID lookup (and
other usages of bit()), and to rename the misleading-generic bit() helper
to something that better conveys its purpose.

I don't love emulator changes in patch 1 as adding one-off helpers is a
bit silly, but IMO it's the lesser of two evils, e.g. adding dedicated
helpers is arguably less error prone than manually encoding a CPUID
lookup, and the helpers approach avoids having to include cpuid.h in the
emulator code.

v2:
  - Rework the assertions to use the reverse_cpuid table instead of
    using the last cpufeatures word (which was not at all intuitive).

Sean Christopherson (5):
  KVM: x86: Add dedicated emulator helpers for querying CPUID features
  KVM: x86: Move bit() helper to cpuid.h
  KVM: x86: Add CPUID_7_1_EAX to the reverse CPUID table
  KVM: x86: Expand build-time assertion on reverse CPUID usage
  KVM: x86: Refactor and rename bit() to feature_bit() macro

 arch/x86/include/asm/kvm_emulate.h |  4 +++
 arch/x86/kvm/cpuid.c               |  5 ++--
 arch/x86/kvm/cpuid.h               | 41 +++++++++++++++++++++++++----
 arch/x86/kvm/emulate.c             | 21 +++------------
 arch/x86/kvm/svm.c                 |  4 +--
 arch/x86/kvm/vmx/vmx.c             | 42 +++++++++++++++---------------
 arch/x86/kvm/x86.c                 | 18 +++++++++++++
 arch/x86/kvm/x86.h                 |  5 ----
 8 files changed, 87 insertions(+), 53 deletions(-)

-- 
2.24.1

