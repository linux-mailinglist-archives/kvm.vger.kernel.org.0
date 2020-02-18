Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 743F2163738
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgBRXa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:30:27 -0500
Received: from mga04.intel.com ([192.55.52.120]:38638 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbgBRX35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:29:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:29:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="282936677"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2020 15:29:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/13] KVM: x86: Move kvm_emulate.h into KVM's private directory
Date:   Tue, 18 Feb 2020 15:29:49 -0800
Message-Id: <20200218232953.5724-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218232953.5724-1-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the emulation context is dynamically allocated and not embedded
in struct kvm_vcpu, move its header, kvm_emulate.h, out of the public
asm directory and into KVM's private x86 directory.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h             | 5 ++++-
 arch/x86/kvm/emulate.c                      | 2 +-
 arch/x86/{include/asm => kvm}/kvm_emulate.h | 0
 arch/x86/kvm/mmu/mmu.c                      | 1 +
 arch/x86/kvm/x86.c                          | 1 +
 arch/x86/kvm/x86.h                          | 1 +
 6 files changed, 8 insertions(+), 2 deletions(-)
 rename arch/x86/{include/asm => kvm}/kvm_emulate.h (100%)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e069f71667b1..0dfe11f30d7f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -182,7 +182,10 @@ enum exit_fastpath_completion {
 	EXIT_FASTPATH_SKIP_EMUL_INS,
 };
 
-#include <asm/kvm_emulate.h>
+struct x86_emulate_ctxt;
+struct x86_exception;
+enum x86_intercept;
+enum x86_intercept_stage;
 
 #define KVM_NR_MEM_OBJS 40
 
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 1e394cb190ce..0bceb3f71220 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -20,7 +20,7 @@
 
 #include <linux/kvm_host.h>
 #include "kvm_cache_regs.h"
-#include <asm/kvm_emulate.h>
+#include "kvm_emulate.h"
 #include <linux/stringify.h>
 #include <asm/fpu/api.h>
 #include <asm/debugreg.h>
diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
similarity index 100%
rename from arch/x86/include/asm/kvm_emulate.h
rename to arch/x86/kvm/kvm_emulate.h
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7011a4e54866..d9064be28089 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -19,6 +19,7 @@
 #include "mmu.h"
 #include "x86.h"
 #include "kvm_cache_regs.h"
+#include "kvm_emulate.h"
 #include "cpuid.h"
 
 #include <linux/kvm_host.h>
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5ab7d4283185..370af9fe0f5b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -22,6 +22,7 @@
 #include "i8254.h"
 #include "tss.h"
 #include "kvm_cache_regs.h"
+#include "kvm_emulate.h"
 #include "x86.h"
 #include "cpuid.h"
 #include "pmu.h"
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 8409842a25d9..f3c6e55eb5d9 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -5,6 +5,7 @@
 #include <linux/kvm_host.h>
 #include <asm/pvclock.h>
 #include "kvm_cache_regs.h"
+#include "kvm_emulate.h"
 
 #define KVM_DEFAULT_PLE_GAP		128
 #define KVM_VMX_DEFAULT_PLE_WINDOW	4096
-- 
2.24.1

