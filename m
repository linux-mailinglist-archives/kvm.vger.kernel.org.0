Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BA238C4A5
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 12:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhEUK10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 06:27:26 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:16433 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhEUK1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 06:27:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1621592760; x=1653128760;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=wV3mx+KiN93nFf95g5wLV9GqflmeS2boHHU+j8TIZC8=;
  b=EGmwpNcJ5hA+wkWm+nTOFNDt+y/CWL8WT8EPDQy/sctd+TNFMthRf2ZK
   kn6WVwNFJBPP0bdb44ZYP1j8MB4IYSBeVvVS0Xhu1HiVWBN+tFFAUwOwv
   yMXNrGv/ezaUXR2uMCLOF0wKCLu9fBSIk0J2dvEfmGrnv+pLzX2aQswR1
   Q=;
X-IronPort-AV: E=Sophos;i="5.82,313,1613433600"; 
   d="scan'208";a="136174583"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 21 May 2021 10:25:53 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com (Postfix) with ESMTPS id 17AB1C02EA;
        Fri, 21 May 2021 10:25:52 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 10:25:51 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 10:25:51 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.83.24) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Fri, 21 May 2021 10:25:49 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v3 00/12] KVM: Implement nested TSC scaling
Date:   Fri, 21 May 2021 11:24:37 +0100
Message-ID: <20210521102449.21505-1-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM currently supports hardware-assisted TSC scaling but only for L1;
the feature is not exposed to nested guests. This patch series adds
support for nested TSC scaling and allows both L1 and L2 to be scaled
with different scaling factors. That is achieved by "merging" the 01 and
02 values together.

Most of the logic in this series is implemented in common code (by doing
the necessary restructurings), however the patches add support for VMX
only. Adding support for SVM should be easy at this point and Maxim
Levitsky has volunteered to do this (thanks!).

Changelog:
v3:
  - Applied Sean's feedback
  - Refactored patches 7 to 10

v2:
  - Applied all of Maxim's feedback
  - Added a mul_s64_u64_shr function in math64.h
  - Added a separate kvm_scale_tsc_l1 function instead of passing an
    argument to kvm_scale_tsc
  - Implemented the 02 fields calculations in common code
  - Moved all of write_l1_tsc_offset's logic to common code
  - Added a check for whether the TSC is stable in patch 10
  - Used a random L1 factor and a negative offset in patch 10

Ilias Stamatis (12):
  math64.h: Add mul_s64_u64_shr()
  KVM: X86: Store L1's TSC scaling ratio in 'struct kvm_vcpu_arch'
  KVM: X86: Rename kvm_compute_tsc_offset() to
    kvm_compute_tsc_offset_l1()
  KVM: X86: Add a ratio parameter to kvm_scale_tsc()
  KVM: VMX: Add a TSC multiplier field in VMCS12
  KVM: X86: Add functions for retrieving L2 TSC fields from common code
  KVM: X86: Add functions that calculate L2's TSC offset and multiplier
  KVM: X86: Move write_l1_tsc_offset() logic to common code and rename
    it
  KVM: VMX: Remove vmx->current_tsc_ratio and decache_tsc_multiplier()
  KVM: VMX: Set the TSC offset and multiplier on nested entry and exit
  KVM: VMX: Expose TSC scaling to L2
  KVM: selftests: x86: Add vmx_nested_tsc_scaling_test

 arch/x86/include/asm/kvm-x86-ops.h            |   4 +-
 arch/x86/include/asm/kvm_host.h               |  14 +-
 arch/x86/kvm/svm/svm.c                        |  29 ++-
 arch/x86/kvm/vmx/nested.c                     |  33 ++-
 arch/x86/kvm/vmx/vmcs12.c                     |   1 +
 arch/x86/kvm/vmx/vmcs12.h                     |   4 +-
 arch/x86/kvm/vmx/vmx.c                        |  49 ++--
 arch/x86/kvm/vmx/vmx.h                        |  11 +-
 arch/x86/kvm/x86.c                            |  91 +++++--
 include/linux/math64.h                        |  19 ++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  | 242 ++++++++++++++++++
 13 files changed, 417 insertions(+), 82 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c

--
2.17.1

