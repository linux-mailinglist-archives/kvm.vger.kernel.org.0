Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1421F1EA4
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 20:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbgFHSCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 14:02:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:63692 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbgFHSCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 14:02:20 -0400
IronPort-SDR: BWsp7jq2/P+QY63eZe+zpDk52wUN52prRwfnxpkthowefhEU+Vg2JazxY9zHvJhe/01NRq0J/U
 TNRud+cg5gdw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 11:02:19 -0700
IronPort-SDR: CqJczIq6TqtAxKiVtFFGKyTnFMmMbjgc7uBzNNMGRdMFzfBQSdcjC9UbzbWaspO1jIh2GpMHJv
 YbwDq50K1bAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,487,1583222400"; 
   d="scan'208";a="305910978"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jun 2020 11:02:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86: Unexport x86_fpu_cache and make it static
Date:   Mon,  8 Jun 2020 11:02:18 -0700
Message-Id: <20200608180218.20946-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
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

v2: Rebased to kvm/queue, commit fb7333dfd812 ("KVM: SVM: fix calls ...").

 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/x86.c              | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1da5858501ca..7030f2221259 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1306,7 +1306,6 @@ struct kvm_arch_async_pf {
 extern u64 __read_mostly host_efer;
 
 extern struct kvm_x86_ops kvm_x86_ops;
-extern struct kmem_cache *x86_fpu_cache;
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c26dd1363151..e19f7c486d64 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -239,8 +239,7 @@ u64 __read_mostly host_xcr0;
 u64 __read_mostly supported_xcr0;
 EXPORT_SYMBOL_GPL(supported_xcr0);
 
-struct kmem_cache *x86_fpu_cache;
-EXPORT_SYMBOL_GPL(x86_fpu_cache);
+static struct kmem_cache *x86_fpu_cache;
 
 static struct kmem_cache *x86_emulator_cache;
 
-- 
2.26.0

