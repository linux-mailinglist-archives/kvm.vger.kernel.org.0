Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBD547DED7
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 06:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346501AbhLWF7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 00:59:07 -0500
Received: from mga18.intel.com ([134.134.136.126]:19252 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346494AbhLWF7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 00:59:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640239146; x=1671775146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VxDpOme2W7FFC3RPaxxkGjtFTG/F3gONdvctMdGAoRQ=;
  b=A8T4WPXPTznC36liPeZWs6Y0eFoZNUDWVLpwSJwJz9Qwkxpf+gKNaupr
   yib84Zm3ittlieiMJbpFn5LTBQ/ejSa3B6JviO6hb/rB1DvdP3FTlYzxc
   h2B+qXC6LzF0TybzRUO2mtG8G2YKfCJgGrNV/4SDltf1RAfwFi1VfSPyt
   xIGq9l9R4NN8BnepDjwsj+dRqlBiwgtqx+NkyUiFsWWgKf+MvjrmuXnWp
   f6ouoVX4u3KzzP7q6QqeIgqDH50E6q+OijRG7VzAJSnzVIH4rwKX3fKPJ
   lUkWiDI9RIzzCNerMHtWeDf9TIpIUK4YNuIonfAFWKFCzSD9T00yA8Gcg
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="227608845"
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="227608845"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 21:59:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="468423777"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga006.jf.intel.com with ESMTP; 22 Dec 2021 21:59:04 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH v3 2/3] selftest: kvm: Move struct kvm_x86_state to header
Date:   Thu, 23 Dec 2021 09:53:21 -0500
Message-Id: <20211223145322.2914028-3-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211223145322.2914028-1-yang.zhong@intel.com>
References: <20211223145322.2914028-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Those changes can avoid dereferencing pointer compile issue
when amx_test.c reference state->xsave.

Move struct kvm_x86_state definition to processor.h.

Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 .../selftests/kvm/include/x86_64/processor.h     | 16 +++++++++++++++-
 .../testing/selftests/kvm/lib/x86_64/processor.c | 15 ---------------
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 58633e51960f..e94ba0fc67d8 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -94,6 +94,21 @@ struct desc_ptr {
 	uint64_t address;
 } __attribute__((packed));
 
+struct kvm_x86_state {
+	struct kvm_xsave *xsave;
+	struct kvm_vcpu_events events;
+	struct kvm_mp_state mp_state;
+	struct kvm_regs regs;
+	struct kvm_xcrs xcrs;
+	struct kvm_sregs sregs;
+	struct kvm_debugregs debugregs;
+	union {
+		struct kvm_nested_state nested;
+		char nested_[16384];
+	};
+	struct kvm_msrs msrs;
+};
+
 static inline uint64_t get_desc64_base(const struct desc64 *desc)
 {
 	return ((uint64_t)desc->base3 << 32) |
@@ -350,7 +365,6 @@ static inline unsigned long get_xmm(int n)
 
 bool is_intel_cpu(void);
 
-struct kvm_x86_state;
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
 		     struct kvm_x86_state *state);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 93264424aee5..babb0f28575c 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1056,21 +1056,6 @@ void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 	sregs_dump(stream, &sregs, indent + 4);
 }
 
-struct kvm_x86_state {
-	struct kvm_xsave *xsave;
-	struct kvm_vcpu_events events;
-	struct kvm_mp_state mp_state;
-	struct kvm_regs regs;
-	struct kvm_xcrs xcrs;
-	struct kvm_sregs sregs;
-	struct kvm_debugregs debugregs;
-	union {
-		struct kvm_nested_state nested;
-		char nested_[16384];
-	};
-	struct kvm_msrs msrs;
-};
-
 static int kvm_get_num_msrs_fd(int kvm_fd)
 {
 	struct kvm_msr_list nmsrs;
