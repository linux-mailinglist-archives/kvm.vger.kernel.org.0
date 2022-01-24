Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F894977A5
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 04:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240682AbiAXDRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jan 2022 22:17:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:28189 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235794AbiAXDRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jan 2022 22:17:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642994258; x=1674530258;
  h=from:to:cc:subject:date:message-id;
  bh=GTUFV4Gf50PTLcV2XSb0vYu0Hwar2nGAI3fEmHuIdoc=;
  b=nps+zAHY+lH0uWTyFgwCR1cQp+dQ4M7a+bHphzNXh8q+jQHT/36VBPcS
   dw69CakcQQQxdC40IIG7in9v+7hP+4oQPodO4FosPx11Bl4qM+XbjVKHk
   vRRB6RpdG33hWghXGIvB/1Y3/0PS9VUi9QNbpXn5nZ8c/S0H5r1dL+GIg
   qs0OQRac69pDVMau5KvzfMoNnHpAtvGQWP3gLhZAj+A5OZCb4uqpG1AI1
   Hza/sZS0IdW1tJmz7XrUFdvBdhd8GSX5tua1xqYtI2mgI1KuEO1Z2fdFN
   1Iu51nhtt6KuMTQtfCdo11RshQrty7fDiKg/2R4Amn6FSrsjWnLOnjUQT
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="245899693"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="245899693"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 19:17:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="627337858"
Received: from junming.sh.intel.com ([10.239.48.26])
  by orsmga004.jf.intel.com with ESMTP; 23 Jan 2022 19:17:37 -0800
From:   Junming Liu <junming.liu@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     Junming Liu <junming.liu@intel.com>
Subject: [kvm-unit-tests PATCH] x86: Align incw instruction to avoid split lock
Date:   Mon, 24 Jan 2022 11:14:44 +0000
Message-Id: <20220124111444.12548-1-junming.liu@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A split lock is any atomic operation whose operand crosses two cache
lines. Since the operand spans two cache lines and the operation must
be atomic, the system locks the bus while the CPU accesses the two cache
lines. The bus lock operation is heavy weight and can cause
severe performance degradation.

Here's the log when run x86 test cases:
[ 3572.765921] x86/split lock detection: #AC: qemu-system-x86/24383
took a split_lock trap at address: 0x400306

Root caused 'cpu_online_count' spans two cache lines,
"lock incw cpu_online_count" instruction causes split lock.
'cpu_online_count' is the type of word(two bytes) and
therefore it needs to be aligned to 2 bytes to avoid split lock.

Signed-off-by: Junming Liu <junming.liu@intel.com>
---
 x86/cstart.S   | 1 +
 x86/cstart64.S | 1 +
 2 files changed, 2 insertions(+)

diff --git a/x86/cstart.S b/x86/cstart.S
index 2c0eec7..6db6a38 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -143,6 +143,7 @@ ap_init:
 online_cpus:
 	.fill (max_cpus + 7) / 8, 1, 0
 
+.align 2
 cpu_online_count:	.word 1
 
 .code16
diff --git a/x86/cstart64.S b/x86/cstart64.S
index ff79ae7..7272452 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -256,4 +256,5 @@ ap_init:
 	jne 1b
 	ret
 
+.align 2
 cpu_online_count:	.word 1
-- 
2.17.1

