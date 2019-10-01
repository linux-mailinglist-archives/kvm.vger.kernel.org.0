Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496B8C3A5B
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 18:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389916AbfJAQVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 12:21:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:54870 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389776AbfJAQVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 12:21:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 09:21:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,571,1559545200"; 
   d="scan'208";a="221059554"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 01 Oct 2019 09:21:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [PATCH] KVM: nVMX: Fix consistency check on injected exception error code
Date:   Tue,  1 Oct 2019 09:21:23 -0700
Message-Id: <20191001162123.26992-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current versions of Intel's SDM incorrectly state that "bits 31:15 of
the VM-Entry exception error-code field" must be zero.  In reality, bits
31:16 must be zero, i.e. error codes are 16-bit values.

The bogus error code check manifests as an unexpected VM-Entry failure
due to an invalid code field (error number 7) in L1, e.g. when injecting
a #GP with error_code=0x9f00.

Nadav previously reported the bug[*], both to KVM and Intel, and fixed
the associated kvm-unit-test.

[*] https://patchwork.kernel.org/patch/11124749/

Reported-by: Nadav Amit <namit@vmware.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 41abc62c9a8a..e76eb4f07f6c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2610,7 +2610,7 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 
 		/* VM-entry exception error code */
 		if (CC(has_error_code &&
-		       vmcs12->vm_entry_exception_error_code & GENMASK(31, 15)))
+		       vmcs12->vm_entry_exception_error_code & GENMASK(31, 16)))
 			return -EINVAL;
 
 		/* VM-entry interruption-info field: reserved bits */
-- 
2.22.0

