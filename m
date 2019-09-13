Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61B2B171A
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 03:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfIMB4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 21:56:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:2948 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbfIMB4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 21:56:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 18:56:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="336761100"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 12 Sep 2019 18:56:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v2] KVM: x86: Handle unexpected MMIO accesses using master abort semantics
Date:   Thu, 12 Sep 2019 18:56:23 -0700
Message-Id: <20190913015623.19869-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use master abort semantics, i.e. reads return all ones and writes are
dropped, to handle unexpected MMIO accesses when reading guest memory
instead of returning X86EMUL_IO_NEEDED, which in turn gets interpreted
as a guest page fault.

Emulation of certain instructions, notably VMX instructions, involves
reading or writing guest memory without going through the emulator.
These emulation flows are not equipped to handle MMIO accesses as no
sane and properly functioning guest kernel will target MMIO with such
instructions, and so simply inject a page fault in response to
X86EMUL_IO_NEEDED.

While not 100% correct, using master abort semantics is at least
sometimes correct, e.g. non-existent MMIO accesses do actually master
abort, whereas injecting a page fault is always wrong, i.e. the issue
lies in the physical address domain, not in the virtual to physical
translation.

Apply the logic to kvm_write_guest_virt_system() in addition to
replacing existing #PF logic in kvm_read_guest_virt(), as VMPTRST uses
the former, i.e. can also leak a host stack address.

Reported-by: Fuqian Huang <huangfq.daxian@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

v2: Fix the comment for kvm_read_guest_virt_helper().

 arch/x86/kvm/x86.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4cfd786d0b6..3da57f137470 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5234,16 +5234,24 @@ int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
 			       struct x86_exception *exception)
 {
 	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	int r;
+
+	r = kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access,
+				       exception);
 
 	/*
-	 * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
-	 * is returned, but our callers are not ready for that and they blindly
-	 * call kvm_inject_page_fault.  Ensure that they at least do not leak
-	 * uninitialized kernel stack memory into cr2 and error code.
+	 * FIXME: this should technically call out to userspace to handle the
+	 * MMIO access, but our callers are not ready for that, so emulate
+	 * master abort behavior instead, i.e. reads return all ones.
 	 */
-	memset(exception, 0, sizeof(*exception));
-	return kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access,
-					  exception);
+	if (r == X86EMUL_IO_NEEDED) {
+		memset(val, 0xff, bytes);
+		return 0;
+	}
+	if (r == X86EMUL_PROPAGATE_FAULT)
+		return -EFAULT;
+	WARN_ON_ONCE(r);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_virt);
 
@@ -5317,11 +5325,25 @@ static int emulator_write_std(struct x86_emulate_ctxt *ctxt, gva_t addr, void *v
 int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
 				unsigned int bytes, struct x86_exception *exception)
 {
+	int r;
+
 	/* kvm_write_guest_virt_system can pull in tons of pages. */
 	vcpu->arch.l1tf_flush_l1d = true;
 
-	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
-					   PFERR_WRITE_MASK, exception);
+	r = kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
+					PFERR_WRITE_MASK, exception);
+
+	/*
+	 * FIXME: this should technically call out to userspace to handle the
+	 * MMIO access, but our callers are not ready for that, so emulate
+	 * master abort behavior instead, i.e. writes are dropped.
+	 */
+	if (r == X86EMUL_IO_NEEDED)
+		return 0;
+	if (r == X86EMUL_PROPAGATE_FAULT)
+		return -EFAULT;
+	WARN_ON_ONCE(r);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
 
-- 
2.22.0

