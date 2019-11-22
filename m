Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1B9107AA7
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfKVWkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:40:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:61220 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbfKVWkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:40:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:40:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409029655"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:40:02 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/13] KVM: x86: Refactor R/W page helper to take the emulation context
Date:   Fri, 22 Nov 2019 14:39:50 -0800
Message-Id: <20191122223959.13545-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122223959.13545-1-sean.j.christopherson@intel.com>
References: <20191122223959.13545-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Invert the vcpu->context derivation in emulator_read_write_onepage() in
preparation for dynamically allocating the emulation context.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c3992ed1568a..a0e87f13af82 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5648,14 +5648,14 @@ static const struct read_write_emulator_ops write_emultor = {
 static int emulator_read_write_onepage(unsigned long addr, void *val,
 				       unsigned int bytes,
 				       struct x86_exception *exception,
-				       struct kvm_vcpu *vcpu,
+				       struct x86_emulate_ctxt *ctxt,
 				       const struct read_write_emulator_ops *ops)
 {
 	gpa_t gpa;
 	int handled, ret;
 	bool write = ops->write;
 	struct kvm_mmio_fragment *frag;
-	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 
 	/*
 	 * If the exit was due to a NPF we may already have a GPA.
@@ -5719,7 +5719,7 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 
 		now = -addr & ~PAGE_MASK;
 		rc = emulator_read_write_onepage(addr, val, now, exception,
-						 vcpu, ops);
+						 ctxt, ops);
 
 		if (rc != X86EMUL_CONTINUE)
 			return rc;
@@ -5731,7 +5731,7 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 	}
 
 	rc = emulator_read_write_onepage(addr, val, bytes, exception,
-					 vcpu, ops);
+					 ctxt, ops);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-- 
2.24.0

