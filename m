Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB38149DEE
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 01:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgA0ANd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jan 2020 19:13:33 -0500
Received: from mga05.intel.com ([192.55.52.43]:22801 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbgA0ANc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jan 2020 19:13:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jan 2020 16:13:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,367,1574150400"; 
   d="scan'208";a="231218374"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 26 Jan 2020 16:13:32 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Unexport x86_fpu_cache and make it static
Date:   Sun, 26 Jan 2020 16:13:30 -0800
Message-Id: <20200127001330.27741-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make x86_fpu_cache static now that FPU allocation and destruction is
handled entirely by common x86 code.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Pretty sure I meant to include this in the vCPU creation cleanup, but
completely forgot about it.

 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/x86.c              | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 77d206a93658..f300a250ab51 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1266,7 +1266,6 @@ struct kvm_arch_async_pf {
 };
 
 extern struct kvm_x86_ops *kvm_x86_ops;
-extern struct kmem_cache *x86_fpu_cache;
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7e3f1d937224..78b7e1f08845 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -227,8 +227,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 
 u64 __read_mostly host_xcr0;
 
-struct kmem_cache *x86_fpu_cache;
-EXPORT_SYMBOL_GPL(x86_fpu_cache);
+static struct kmem_cache *x86_fpu_cache;
 
 static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt);
 
-- 
2.24.1

