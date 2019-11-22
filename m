Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3056F107AB5
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfKVWkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:40:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:61229 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726931AbfKVWkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:40:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:40:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409029691"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:40:04 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/13] KVM: x86: Move kvm_emulate.h into KVM's private directory
Date:   Fri, 22 Nov 2019 14:39:55 -0800
Message-Id: <20191122223959.13545-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122223959.13545-1-sean.j.christopherson@intel.com>
References: <20191122223959.13545-1-sean.j.christopherson@intel.com>
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
index eab45340eb2f..9ed14b11063c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -175,7 +175,10 @@ enum {
 	VCPU_SREG_LDTR,
 };
 
-#include <asm/kvm_emulate.h>
+struct x86_emulate_ctxt;
+struct x86_exception;
+enum x86_intercept;
+enum x86_intercept_stage;
 
 #define KVM_NR_MEM_OBJS 40
 
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 596fa52e5ecb..95b07b92f884 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -20,7 +20,7 @@
 
 #include <linux/kvm_host.h>
 #include "kvm_cache_regs.h"
-#include <asm/kvm_emulate.h>
+#include "kvm_emulate.h"
 #include <linux/stringify.h>
 #include <asm/debugreg.h>
 #include <asm/nospec-branch.h>
diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
similarity index 100%
rename from arch/x86/include/asm/kvm_emulate.h
rename to arch/x86/kvm/kvm_emulate.h
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f92b40d798c..9ab2f9c07f35 100644
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
index 9092990d57ad..548cf3b659f5 100644
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
index 84649ec1b7f5..3f425b601257 100644
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
2.24.0

