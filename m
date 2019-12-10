Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A32E119E6D
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 23:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbfLJWoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 17:44:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:9124 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728448AbfLJWoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 17:44:21 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 14:44:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="413279330"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Dec 2019 14:44:19 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jun Nakajima <jun.nakajima@intel.com>
Subject: [PATCH 2/4] KVM: x86: Ensure all logical CPUs have consistent reserved cr4 bits
Date:   Tue, 10 Dec 2019 14:44:14 -0800
Message-Id: <20191210224416.10757-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210224416.10757-1-sean.j.christopherson@intel.com>
References: <20191210224416.10757-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check the current CPU's reserved cr4 bits against the mask calculated
for the boot CPU to ensure consistent behavior across all CPUs.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

I'm on the fence as to whether this is gratuitous or useful, which is
why it's a separate patch and not tagged for stable.

 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 321eecb4cffd..ab3a4104febf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9415,6 +9415,13 @@ void kvm_arch_hardware_unsetup(void)
 
 int kvm_arch_check_processor_compat(void)
 {
+	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+
+	WARN_ON(!irqs_disabled());
+
+	if (kvm_host_cr4_reserved_bits(c) != cr4_reserved_bits)
+		return -EIO;
+
 	return kvm_x86_ops->check_processor_compatibility();
 }
 
-- 
2.24.0

