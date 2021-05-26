Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BBD391F6A
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 20:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbhEZSrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 14:47:03 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:29632 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbhEZSrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 14:47:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622054731; x=1653590731;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=VjHKWOUbi6AsBQGrFu6LwnjmojKTzUmMLMOu456RPpE=;
  b=ExDzAdAwX2JQgAmJu5JalElie5QEiO0s+vBVDazarZ5u8NeFf+6C7iNU
   61eRybBwe8Ul0nE8Kh9xnRWZMaO2BWITLDkAc+YfL/ZvZxPpSJGYYw60K
   3+JE6tX6qTiP/nkUelnvteY6wRaGczd+fMXKZlOXktFnWfep6FfZ9g9G1
   U=;
X-IronPort-AV: E=Sophos;i="5.82,331,1613433600"; 
   d="scan'208";a="110382147"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 26 May 2021 18:45:22 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id 97ABFA18BD;
        Wed, 26 May 2021 18:45:21 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:45:21 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 18:45:21 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 26 May 2021 18:45:19 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v4 00/11] KVM: Implement nested TSC scaling
Date:   Wed, 26 May 2021 19:44:07 +0100
Message-ID: <20210526184418.28881-1-ilstam@amazon.com>
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

Only patch 9 needs reviewing at this point, but I am re-sending the
whole series as I also applied nitpicks suggested to some of the other
pathces.

v4:
  - Added vendor callbacks for writing the TSC multiplier
  - Moved the VMCS multiplier writes from the VMCS load path to common
    code that only gets called on TSC ratio changes
  - Merged together patches 10 and 11 of v3
  - Applied all nitpick-feedback of the previous versions

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

Ilias Stamatis (11):
  math64.h: Add mul_s64_u64_shr()
  KVM: X86: Store L1's TSC scaling ratio in 'struct kvm_vcpu_arch'
  KVM: X86: Rename kvm_compute_tsc_offset() to
    kvm_compute_l1_tsc_offset()
  KVM: X86: Add a ratio parameter to kvm_scale_tsc()
  KVM: nVMX: Add a TSC multiplier field in VMCS12
  KVM: X86: Add functions for retrieving L2 TSC fields from common code
  KVM: X86: Add functions that calculate the nested TSC fields
  KVM: X86: Move write_l1_tsc_offset() logic to common code and rename
    it
  KVM: X86: Add vendor callbacks for writing the TSC multiplier
  KVM: nVMX: Enable nested TSC scaling
  KVM: selftests: x86: Add vmx_nested_tsc_scaling_test

 arch/x86/include/asm/kvm-x86-ops.h            |   5 +-
 arch/x86/include/asm/kvm_host.h               |  15 +-
 arch/x86/kvm/svm/svm.c                        |  35 ++-
 arch/x86/kvm/vmx/nested.c                     |  33 ++-
 arch/x86/kvm/vmx/vmcs12.c                     |   1 +
 arch/x86/kvm/vmx/vmcs12.h                     |   4 +-
 arch/x86/kvm/vmx/vmx.c                        |  55 ++--
 arch/x86/kvm/vmx/vmx.h                        |  11 +-
 arch/x86/kvm/x86.c                            | 114 +++++++--
 include/linux/math64.h                        |  19 ++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  | 242 ++++++++++++++++++
 13 files changed, 451 insertions(+), 85 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c

-- 
2.17.1

