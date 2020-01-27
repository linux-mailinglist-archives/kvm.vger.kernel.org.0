Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE50149E06
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 01:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgA0AlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jan 2020 19:41:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:63120 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbgA0AlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jan 2020 19:41:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jan 2020 16:41:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,367,1574150400"; 
   d="scan'208";a="223116777"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jan 2020 16:41:15 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86: Gracefully handle __vmalloc() failure during VM allocation
Date:   Sun, 26 Jan 2020 16:41:11 -0800
Message-Id: <20200127004113.25615-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127004113.25615-1-sean.j.christopherson@intel.com>
References: <20200127004113.25615-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check the result of __vmalloc() to avoid dereferencing a NULL pointer in
the event that allocation failres.

Fixes: 40bbb9d03f05d ("KVM: VMX: add struct kvm_vmx to hold VMX specific KVM vars")
Fixes: 81811c162d4da ("KVM: SVM: add struct kvm_svm to hold SVM specific KVM vars")
Fixes: d1e5b0e98ea27 ("kvm: Make VM ioctl do valloc for some archs")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c     | 4 ++++
 arch/x86/kvm/vmx/vmx.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bf0556588ad0..6565257dea39 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1951,6 +1951,10 @@ static struct kvm *svm_vm_alloc(void)
 	struct kvm_svm *kvm_svm = __vmalloc(sizeof(struct kvm_svm),
 					    GFP_KERNEL_ACCOUNT | __GFP_ZERO,
 					    PAGE_KERNEL);
+
+	if (!kvm_svm)
+		return NULL;
+
 	return &kvm_svm->kvm;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1419c53aed16..45f3f215e9df 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6662,6 +6662,10 @@ static struct kvm *vmx_vm_alloc(void)
 	struct kvm_vmx *kvm_vmx = __vmalloc(sizeof(struct kvm_vmx),
 					    GFP_KERNEL_ACCOUNT | __GFP_ZERO,
 					    PAGE_KERNEL);
+
+	if (!kvm_vmx)
+		return NULL;
+
 	return &kvm_vmx->kvm;
 }
 
-- 
2.24.1

