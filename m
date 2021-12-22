Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F19F47D27E
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 13:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244956AbhLVMxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 07:53:09 -0500
Received: from mga14.intel.com ([192.55.52.115]:12200 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241182AbhLVMxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 07:53:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640177589; x=1671713589;
  h=from:to:cc:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding:subject;
  bh=CRblG/uJuSa2RjtNeb5fcVVK7eFtHsKZdKlRSrPIjKU=;
  b=SnZR/QSGvINU4YB9HpNv5zAs5MOoEV6O0qDKjxWWlX4ovJX+BqHLf8Em
   TDMa1XtVS4qdEht3BB/rgPvZaiH+pD9AmA+arakvzT41XaYYBD2t0rW0j
   wbRW7vzoxkwiL6aJpAiTlxs6XYDQeXS1NYlytsWehCFzICUhiqwp1v0Hk
   if3sYoLSbvaz4G4kByArnVmJDG1XBtPGqDb9fYmtAbYxY8FK8t6KUy70q
   d51AG6ifKMzCW6/lgXmvkjMgHYnDeKo5TiBrKTeCuxkmdOaC2UoKjjFFQ
   eEl192bowv91Nd95aofmeHc9em4iIP1Andg78CKqbTZFfBwU6/nA9Sqeq
   w==;
Subject: [WARNING: UNSCANNABLE EXTRACTION FAILED][PATCH v2 1/3] selftest: kvm: Reorder vcpu_load_state steps for AMX
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240834730"
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="240834730"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 04:52:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="549315011"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga001.jf.intel.com with ESMTP; 22 Dec 2021 04:52:18 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, yang.zhong@intel.com
Date:   Wed, 22 Dec 2021 16:47:29 -0500
Message-Id: <20211222214731.2912361-2-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211222214731.2912361-1-yang.zhong@intel.com>
References: <20211222214731.2912361-1-yang.zhong@intel.com>
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
