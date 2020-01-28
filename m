Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FDA14C3C9
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 00:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgA1X4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 18:56:18 -0500
Received: from mga07.intel.com ([134.134.136.100]:16527 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgA1X4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 18:56:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jan 2020 15:53:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,375,1574150400"; 
   d="scan'208";a="427801068"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jan 2020 15:53:46 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Mark CR4.UMIP as reserved based on associated CPUID bit
Date:   Tue, 28 Jan 2020 15:53:44 -0800
Message-Id: <20200128235344.29581-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-add code to mark CR4.UMIP as reserved if UMIP is not supported by the
host.  The UMIP handling was unintentionally dropped during a recent
refactoring.

Not flagging CR4.UMIP allows the guest to set its CR4.UMIP regardless of
host support or userspace desires.  On CPUs with UMIP support, including
emulated UMIP, this allows the guest to enable UMIP against the wishes
of the userspace VMM.  On CPUs without any form of UMIP, this results in
a failed VM-Enter due to invalid guest state.

Fixes: 345599f9a2928 ("KVM: x86: Add macro to ensure reserved cr4 bits checks stay in sync")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7e3f1d937224..e70d1215638a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -898,6 +898,8 @@ EXPORT_SYMBOL_GPL(kvm_set_xcr);
 		__reserved_bits |= X86_CR4_PKE;		\
 	if (!__cpu_has(__c, X86_FEATURE_LA57))		\
 		__reserved_bits |= X86_CR4_LA57;	\
+	if (!__cpu_has(__c, X86_FEATURE_UMIP))		\
+		__reserved_bits |= X86_CR4_UMIP;	\
 	__reserved_bits;				\
 })
 
-- 
2.24.1

