Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF7B25E6C
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 09:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbfEVHCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 03:02:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:31984 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728603AbfEVHCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 03:02:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 00:01:59 -0700
X-ExtLoop1: 1
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2019 00:01:58 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yu-cheng.yu@intel.com
Cc:     weijiang.yang@intel.com
Subject: [PATCH v5 3/8] KVM: x86: Fix XSAVE size calculation issue
Date:   Wed, 22 May 2019 15:00:56 +0800
Message-Id: <20190522070101.7636-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190522070101.7636-1-weijiang.yang@intel.com>
References: <20190522070101.7636-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the SDM, Vol 2, CPUID(EAX=0xD,ECX=1) reports the
XSAVE size containing all states enabled by XCR0|IA32_MSR_XSS.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b9fc967fe55a..7be16ef0ea4a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -123,7 +123,8 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
 	if (best && (best->eax & (F(XSAVES) | F(XSAVEC))))
-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
+			    kvm_supported_xss(), true);
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
-- 
2.17.2

