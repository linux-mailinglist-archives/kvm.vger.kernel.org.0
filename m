Return-Path: <kvm+bounces-4145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C4DD80E440
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 07:28:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 028C01F22096
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 06:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1421D16413;
	Tue, 12 Dec 2023 06:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sp8mYO1r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887C1BF
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 22:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702362466; x=1733898466;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R3uQn7RWFIRS7j7rVEHyAULr79vVZu67SrpObluFe6I=;
  b=Sp8mYO1rcZ+uTz5Ouy+vK50qMH6WnMYJ8/0qkToNsKHwMbLcS6ZbZyC9
   8vdIuFjtoYRy2fE68CiE7KLVoHBo6yI1vq7SkHDsOQz/Uwm9ege2TZ1XC
   Gs8lZyFQOziS+ALdnbKx8djcE3ukCqVQJv85PKvHnsZG5Nyq4ivewmlw5
   vcZFEWyR4dKb6sI/9gp0dHaC/kGSMuUhVkLfCf7mP8vvOnhuARgJ1BY+C
   g7x5mK7mkYnbfdcz7hIDOu1wlqFNdOWjFp9fO0mpU9uXZZ7TDvieUSUiz
   lf0Et6u7h5gPX0/vgZIS3s+e170IJzQwR0XX8P2bkAUXFgJYYpce3sSPL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="8128896"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="8128896"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 22:27:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="723109021"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="723109021"
Received: from spr-bkc-pc.jf.intel.com ([10.165.56.234])
  by orsmga003.jf.intel.com with ESMTP; 11 Dec 2023 22:27:46 -0800
From: Dan Wu <dan1.wu@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	dan1.wu@intel.com
Subject: [kvm-unit-tests PATCH v1 1/3] x86: Add a common header asyncpf.h
Date: Tue, 12 Dec 2023 14:27:06 +0800
Message-Id: <20231212062708.16509-2-dan1.wu@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231212062708.16509-1-dan1.wu@intel.com>
References: <20231212062708.16509-1-dan1.wu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Grab the ASYNC PF related bit definitions from asyncpf.c and put them
into asyncpf.h. Add some new definitions and they are going to be used
by asyncpf-int test which will be added later.

Signed-off-by: Dan Wu <dan1.wu@intel.com>
---
 x86/asyncpf.c |  9 +--------
 x86/asyncpf.h | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 8 deletions(-)
 create mode 100644 x86/asyncpf.h

diff --git a/x86/asyncpf.c b/x86/asyncpf.c
index bc515be9..a0bdefcf 100644
--- a/x86/asyncpf.c
+++ b/x86/asyncpf.c
@@ -27,14 +27,7 @@
 #include "libcflat.h"
 #include "vmalloc.h"
 #include <stdint.h>
-
-#define KVM_PV_REASON_PAGE_NOT_PRESENT 1
-#define KVM_PV_REASON_PAGE_READY 2
-
-#define MSR_KVM_ASYNC_PF_EN 0x4b564d02
-
-#define KVM_ASYNC_PF_ENABLED                    (1 << 0)
-#define KVM_ASYNC_PF_SEND_ALWAYS                (1 << 1)
+#include "asyncpf.h"
 
 volatile uint32_t apf_reason __attribute__((aligned(64)));
 char *buf;
diff --git a/x86/asyncpf.h b/x86/asyncpf.h
new file mode 100644
index 00000000..8e4a133e
--- /dev/null
+++ b/x86/asyncpf.h
@@ -0,0 +1,23 @@
+#define KVM_PV_REASON_PAGE_NOT_PRESENT 	1
+#define KVM_PV_REASON_PAGE_READY 2
+
+#define MSR_KVM_ASYNC_PF_EN 	0x4b564d02
+#define MSR_KVM_ASYNC_PF_INT    0x4b564d06
+#define MSR_KVM_ASYNC_PF_ACK    0x4b564d07
+
+#define KVM_ASYNC_PF_ENABLED                    (1 << 0)
+#define KVM_ASYNC_PF_SEND_ALWAYS                (1 << 1)
+#define KVM_ASYNC_PF_DELIVERY_AS_INT            (1 << 3)
+
+#define HYPERVISOR_CALLBACK_VECTOR	0xf3
+
+struct kvm_vcpu_pv_apf_data {
+      /* Used for 'page not present' events delivered via #PF */
+      uint32_t  flags;
+
+      /* Used for 'page ready' events delivered via interrupt notification */
+      uint32_t  token;
+
+      uint8_t  pad[56];
+      uint32_t  enabled;
+} __attribute__((aligned(64)));
-- 
2.39.3


