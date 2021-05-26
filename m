Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08485391323
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 10:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhEZI60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 04:58:26 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:18814 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbhEZI60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 04:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1622019416; x=1653555416;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=NiiybY9pJbKggcwpnUusmuYGMawbxUPAkBWGqcaKsJs=;
  b=V2RZDzzvFUkQR/iI0xeq/ubBraUNEqxMbLg2v4ERBRtIIj0u0BjzediU
   nyNu0Fl5QbF2aikrcy7ZxBHPQyDLwOmdTVg7jkbvSd6g9hyFzTQGjZRAt
   65DyOFNZJzyYF0c9rCOoiXJxy7I1KKpGBd3MbXsZG1JA5ZjuGoC0v81IF
   c=;
X-IronPort-AV: E=Sophos;i="5.82,331,1613433600"; 
   d="scan'208";a="114700068"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 26 May 2021 08:56:45 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id E64F6220081;
        Wed, 26 May 2021 08:56:42 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.97) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 26 May 2021 08:56:34 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH v4 0/4] Add support for XMM fast hypercalls
Date:   Wed, 26 May 2021 10:56:07 +0200
Message-ID: <cover.1622019133.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.97]
X-ClientProxiedBy: EX13D34UWA003.ant.amazon.com (10.43.160.69) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V supports the use of XMM registers to perform fast hypercalls.
This allows guests to take advantage of the improved performance of the
fast hypercall interface even though a hypercall may require more than
(the current maximum of) two general purpose registers.

The XMM fast hypercall interface uses an additional six XMM registers
(XMM0 to XMM5) to allow the caller to pass an input parameter block of
up to 112 bytes. Hyper-V can also return data back to the guest in the
remaining XMM registers that are not used by the current hypercall.

Although the Hyper-v TLFS mentions that a guest cannot use this feature
unless the hypervisor advertises support for it, some hypercalls which
we plan on upstreaming in future uses them anyway. This patchset adds
necessary infrastructure for handling input/output via XMM registers and
patches kvm_hv_flush_tlb() to use xmm input arguments.

~ Sid.

v3 -> v4:
  - Rebase to latest master
  - Remove unused loop variable j

v2 -> v3:
  - Remove inline for kvm_hv_hypercall_{read,write}_xmm()
  - Fix typo: s/ouput/output/
  - Remove sse128_t from kvm_emulate.h
  - Reword comment to match TLFS wording
  - Move num XMM registers macro to hyperv-tlfs.h
  - Stop advertising HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE

v1 -> v2:
  - Add hc.fast to is_xmm_fast_hypercall() check
  - Split CPUID feature bits for input and output

Siddharth Chandrasekaran (4):
  KVM: x86: Move FPU register accessors into fpu.h
  KVM: hyper-v: Collect hypercall params into struct
  KVM: x86: kvm_hv_flush_tlb use inputs from XMM registers
  KVM: hyper-v: Advertise support for fast XMM hypercalls

 arch/x86/include/asm/hyperv-tlfs.h |  10 +-
 arch/x86/kvm/emulate.c             | 137 +++---------------
 arch/x86/kvm/fpu.h                 | 140 ++++++++++++++++++
 arch/x86/kvm/hyperv.c              | 222 +++++++++++++++++++----------
 arch/x86/kvm/kvm_emulate.h         |   3 +-
 5 files changed, 310 insertions(+), 202 deletions(-)
 create mode 100644 arch/x86/kvm/fpu.h

-- 
2.17.1



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



