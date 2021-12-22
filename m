Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FA847D27C
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 13:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241254AbhLVMwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 07:52:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:12132 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241182AbhLVMwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 07:52:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640177543; x=1671713543;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G8+GljVPQYkhG9byV77rtnpiNqoo4o/wJjsmdfvW0pg=;
  b=WRjGnEME2aEaQlIRPS1ZbXkmIkgiAJXs1zujpHd872aFBRYDv+/gxgZe
   lZ/dWh5imj0u9aQd84auiB7u2kuPZIQUM9Z5fGedjbu+gs4DmRj3CY8LO
   lDDj7DdVlHpnEPo84kH4U7p+CX9PfoyBtMs4/fcfLbIlO1fNSpzw6v99+
   +8ggUwZ8FBFRpoUE88xaNs6lAtll/qYllq9ECLq6QORHnfqkOxb5rKUWZ
   AjIRDjPjZjqoXVaS3GlRD1CzyyAC7ePkBchT6sqGJm4HnFMpBSFcXBTq9
   A4iAAOXS2sx4SLbC1Bs3u0g7DHXaueDxamX6cSE1AL0ABoF/l8sDsFE0p
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240834736"
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="240834736"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 04:52:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="549315024"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga001.jf.intel.com with ESMTP; 22 Dec 2021 04:52:21 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH v2 2/3] selftest: kvm: Move struct kvm_x86_state to header
Date:   Wed, 22 Dec 2021 16:47:30 -0500
Message-Id: <20211222214731.2912361-3-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211222214731.2912361-1-yang.zhong@intel.com>
References: <20211222214731.2912361-1-yang.zhong@intel.com>
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
index 0546173ab628..28f8fa78a47b 100644
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
index 9b5abf488211..126f8e743bc2 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1036,21 +1036,6 @@ void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
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
