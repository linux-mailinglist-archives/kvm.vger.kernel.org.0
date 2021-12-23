Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EA347DED6
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 06:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346496AbhLWF7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 00:59:05 -0500
Received: from mga18.intel.com ([134.134.136.126]:19252 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346494AbhLWF7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 00:59:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640239144; x=1671775144;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X0S9msgJ4VobPTdOYte8GBqeg2W3JfU84vkQbI5DWEc=;
  b=AyXQAOZYd8v2HXuNUvEH4bL+/szOAFJkLh4PwFwoIhgigFXwdPesPQkE
   J6CaZ8sCi7pAQFMg9yDsfF1F48lBzKPWS+CdDdtgMoSRDjJTyci1tqhw1
   trklMs1HC6FPwIQ/GoCB/wqhOEOxrQOIRRZou9hQEaDzMfCSsK2a6zJde
   swc91uTV4SFtlnwOpdlaPeQ+B5YBvuZlgPwk8Fhu33KWNbEbFhuqZpAeV
   q67Dh23Fhsx2Tchup582cMBoXgavD3XrSxDE+euWJrGmVEvYkLE1KbuxJ
   TBwtScG7SizSRSFOoUwrvr0JgAyVXhP6zSY7agj6VyTK9pzIfruTyiZUC
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="227608834"
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="227608834"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 21:59:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="468423754"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga006.jf.intel.com with ESMTP; 22 Dec 2021 21:59:02 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH v3 1/3] selftest: kvm: Reorder vcpu_load_state steps for AMX
Date:   Thu, 23 Dec 2021 09:53:20 -0500
Message-Id: <20211223145322.2914028-2-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211223145322.2914028-1-yang.zhong@intel.com>
References: <20211223145322.2914028-1-yang.zhong@intel.com>
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
 .../selftests/kvm/lib/x86_64/processor.c        | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index f19d6d201977..93264424aee5 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1212,24 +1212,25 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int r;
 
-	r = ioctl(vcpu->fd, KVM_SET_XSAVE, state->xsave);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i",
+	r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i",
                 r);
 
+	r = ioctl(vcpu->fd, KVM_SET_MSRS, &state->msrs);
+	TEST_ASSERT(r == state->msrs.nmsrs,
+		"Unexpected result from KVM_SET_MSRS, r: %i (failed at %x)",
+		r, r == state->msrs.nmsrs ? -1 : state->msrs.entries[r].index);
+
 	if (kvm_check_cap(KVM_CAP_XCRS)) {
 		r = ioctl(vcpu->fd, KVM_SET_XCRS, &state->xcrs);
 		TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XCRS, r: %i",
 			    r);
 	}
 
-	r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i",
+	r = ioctl(vcpu->fd, KVM_SET_XSAVE, state->xsave);
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i",
                 r);
 
-	r = ioctl(vcpu->fd, KVM_SET_MSRS, &state->msrs);
-        TEST_ASSERT(r == state->msrs.nmsrs, "Unexpected result from KVM_SET_MSRS, r: %i (failed at %x)",
-                r, r == state->msrs.nmsrs ? -1 : state->msrs.entries[r].index);
-
 	r = ioctl(vcpu->fd, KVM_SET_VCPU_EVENTS, &state->events);
         TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_VCPU_EVENTS, r: %i",
                 r);
