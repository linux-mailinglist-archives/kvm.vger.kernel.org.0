Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8839047C15A
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 15:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238409AbhLUOUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 09:20:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:4778 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238390AbhLUOUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 09:20:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640096414; x=1671632414;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G8+GljVPQYkhG9byV77rtnpiNqoo4o/wJjsmdfvW0pg=;
  b=CmHk1gVyyZZB9nEWEBAL5QQNnCBSIs17uGKbnv1gIFlKQJd6myeYukys
   Vvn3j132xK9w8y/A5IJ5SjLYuR0zdu7cK1NUh96fWx1gcxlqZCWw3jMRY
   h89PscasZHVsbEgqZprfQxP0Kakila08bCNDd/2ZZNYJfu177zhw2T9/Z
   4Loste9yjAPakxTZqtqjQNfVLMMnfogn9MloN6MTdObWCro6YESakvc0F
   0VUDaWBdkJddK24mYT9qW9+dqQou9iWGsUbAwUx70zqAGE1VlSkQKuzJ4
   QaFX+9Ce9AAwHiui7GzoyanVD5Zcnjkx81rK4yG3lKL+NZLxizVRyo7Ce
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="227693658"
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="227693658"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 06:20:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="466312350"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 21 Dec 2021 06:20:11 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH 2/3] selftest: Move struct kvm_x86_state to header
Date:   Tue, 21 Dec 2021 18:15:06 -0500
Message-Id: <20211221231507.2910889-3-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211221231507.2910889-1-yang.zhong@intel.com>
References: <20211221231507.2910889-1-yang.zhong@intel.com>
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
