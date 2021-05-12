Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F11837C30C
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 17:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhELPRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 11:17:07 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:48577 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbhELPMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 11:12:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620832299; x=1652368299;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=HKr3J8IhS0dTtfoFa0Dujjg1idj5c2M2ekOtri5Eo0A=;
  b=tbCPyRd4dLXIVPbrObtI2l5kCXm8YwcJyqCXMyYk5pPrjjuFIZ7TVvfE
   tUlrfLeSTSN5cPNVfBBe6Crgo1UegGlgAoEq8bSEx1aejtUwK5TAjNHUZ
   psvPHZSm9gsWKAbCPWsjU/dgOm2t17DyGnQZbpKc76LwssxWi6TCIC6dr
   o=;
X-IronPort-AV: E=Sophos;i="5.82,293,1613433600"; 
   d="scan'208";a="111783246"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 12 May 2021 15:11:31 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 5B57FA1C13;
        Wed, 12 May 2021 15:11:27 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:11:26 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:11:26 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 12 May 2021 15:11:24 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v2 00/10] KVM: Implement nested TSC scaling
Date:   Wed, 12 May 2021 16:09:35 +0100
Message-ID: <20210512150945.4591-1-ilstam@amazon.com>
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
v2:
  - Applied most (all?) of Maxim's feedback
  - Added a mul_s64_u64_shr function in math64.h
  - Added a separate kvm_scale_tsc_l1 function instead of passing an
    argument to kvm_scale_tsc
  - Implemented the 02 fields calculations in common code
  - Moved all of write_l1_tsc_offset's logic to common code
  - Added a check for whether the TSC is stable in patch 10
  - Used a random L1 factor and a negative offset in patch 10

Ilias Stamatis (10):
  math64.h: Add mul_s64_u64_shr()
  KVM: X86: Store L1's TSC scaling ratio in 'struct kvm_vcpu_arch'
  KVM: X86: Add kvm_scale_tsc_l1() and kvm_compute_tsc_offset_l1()
  KVM: VMX: Add a TSC multiplier field in VMCS12
  KVM: X86: Add functions for retrieving L2 TSC fields from common code
  KVM: X86: Add functions that calculate the 02 TSC offset and
    multiplier
  KVM: X86: Move write_l1_tsc_offset() logic to common code and rename
    it
  KVM: VMX: Set the TSC offset and multiplier on nested entry and exit
  KVM: VMX: Expose TSC scaling to L2
  KVM: selftests: x86: Add vmx_nested_tsc_scaling_test

 arch/x86/include/asm/kvm-x86-ops.h            |   4 +-
 arch/x86/include/asm/kvm_host.h               |  13 +-
 arch/x86/kvm/svm/svm.c                        |  29 ++-
 arch/x86/kvm/vmx/nested.c                     |  19 +-
 arch/x86/kvm/vmx/vmcs12.c                     |   1 +
 arch/x86/kvm/vmx/vmcs12.h                     |   4 +-
 arch/x86/kvm/vmx/vmx.c                        |  42 +--
 arch/x86/kvm/x86.c                            |  93 +++++--
 include/linux/math64.h                        |  19 ++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  | 242 ++++++++++++++++++
 12 files changed, 409 insertions(+), 59 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c

-- 
2.17.1

