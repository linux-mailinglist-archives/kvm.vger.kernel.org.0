Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B5A47C15B
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 15:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238411AbhLUOUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 09:20:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:4783 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238395AbhLUOUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 09:20:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640096414; x=1671632414;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CRblG/uJuSa2RjtNeb5fcVVK7eFtHsKZdKlRSrPIjKU=;
  b=aPHhQxRuQwX607SFH1TiBRgWWw2dK3Oba4Vi5RoT9sZVuO35iiasyh0h
   f/bqmO/O9UtmJtBJaaja2ns3Vbh1jwBhpAmVTflQLHRlQKmJf345ofKuM
   YdSZ4hNc1AMn+zYqF1enG92txlL1NNjRueu0F0noVwOsJfe+XnB/DPP37
   f3ZURFZ9gwCzy6y7RJRfcGMD+do4dLhbNR5AVfrJ3zvUMBstk1XRLz8mW
   bwOM2n4m2cE1vi4AEXnAQ+TJoNQ5+RvOHkpwL2k2+M11v2EEyQ/Kxx+e0
   kkoStdp5qtx5Y2ivWz2LZTP2hJzQZG5XlGo+CTsd164EKbv59PyqtA1+d
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="227693653"
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="227693653"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 06:20:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="466312337"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 21 Dec 2021 06:20:09 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH 1/3] selftest: kvm: Reorder vcpu_load_state steps for AMX
Date:   Tue, 21 Dec 2021 18:15:05 -0500
Message-Id: <20211221231507.2910889-2-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211221231507.2910889-1-yang.zhong@intel.com>
References: <20211221231507.2910889-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

For AMX support it is recommended to load XCR0 after XFD, so
that KVM does not see XFD=0, XCR=1 for a save state that will
eventually be disabled (which would lead to premature allocation
of the space required for that save state).

It is also required to load XSAVE data after XCR0 and XFD, so
that KVM can trigger allocation of the extra space required to
store AMX state.

Adjust vcpu_load_state to obey these new requirements.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 29 ++++++++++---------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 00324d73c687..9b5abf488211 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1192,9 +1192,14 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int r;
 
-	r = ioctl(vcpu->fd, KVM_SET_XSAVE, &state->xsave);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i",
-                r);
+	r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i",
+		r);
+
+	r = ioctl(vcpu->fd, KVM_SET_MSRS, &state->msrs);
+	TEST_ASSERT(r == state->msrs.nmsrs,
+		"Unexpected result from KVM_SET_MSRS,r: %i (failed at %x)",
+		r, r == state->msrs.nmsrs ? -1 : state->msrs.entries[r].index);
 
 	if (kvm_check_cap(KVM_CAP_XCRS)) {
 		r = ioctl(vcpu->fd, KVM_SET_XCRS, &state->xcrs);
@@ -1202,17 +1207,13 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
 			    r);
 	}
 
-	r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i",
-                r);
-
-	r = ioctl(vcpu->fd, KVM_SET_MSRS, &state->msrs);
-        TEST_ASSERT(r == state->msrs.nmsrs, "Unexpected result from KVM_SET_MSRS, r: %i (failed at %x)",
-                r, r == state->msrs.nmsrs ? -1 : state->msrs.entries[r].index);
+	r = ioctl(vcpu->fd, KVM_SET_XSAVE, &state->xsave);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i",
+		r);
 
 	r = ioctl(vcpu->fd, KVM_SET_VCPU_EVENTS, &state->events);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_VCPU_EVENTS, r: %i",
-                r);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_VCPU_EVENTS, r: %i",
+		r);
 
 	r = ioctl(vcpu->fd, KVM_SET_MP_STATE, &state->mp_state);
         TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_MP_STATE, r: %i",
@@ -1223,8 +1224,8 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
                 r);
 
 	r = ioctl(vcpu->fd, KVM_SET_REGS, &state->regs);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_REGS, r: %i",
-                r);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_REGS, r: %i",
+		r);
 
 	if (state->nested.size) {
 		r = ioctl(vcpu->fd, KVM_SET_NESTED_STATE, &state->nested);
