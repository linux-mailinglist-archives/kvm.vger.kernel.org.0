Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5D58F20E
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 19:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731772AbfHORWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 13:22:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:19173 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729931AbfHORWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 13:22:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 10:22:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,389,1559545200"; 
   d="scan'208";a="179427792"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 15 Aug 2019 10:22:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paul Mackerras <paulus@ozlabs.org>, Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: Assert that struct kvm_vcpu is always as offset zero
Date:   Thu, 15 Aug 2019 10:22:37 -0700
Message-Id: <20190815172237.10464-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM implementations that wrap struct kvm_vcpu with a vendor specific
struct, e.g. struct vcpu_vmx, must place the vcpu member at offset 0,
otherwise the usercopy region intended to encompass struct kvm_vcpu_arch
will instead overlap random chunks of the vendor specific struct.
E.g. padding a large number of bytes before struct kvm_vcpu triggers
a usercopy warn when running with CONFIG_HARDENED_USERCOPY=y.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Note, the PowerPC change is completely untested.

 arch/powerpc/kvm/e500.c | 3 +++
 arch/x86/kvm/svm.c      | 3 +++
 arch/x86/kvm/vmx/vmx.c  | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
index b5a848a55504..00649ca5fa9a 100644
--- a/arch/powerpc/kvm/e500.c
+++ b/arch/powerpc/kvm/e500.c
@@ -440,6 +440,9 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_e500(struct kvm *kvm,
 	struct kvm_vcpu *vcpu;
 	int err;
 
+	BUILD_BUG_ON_MSG(offsetof(struct kvmppc_vcpu_e500, vcpu) != 0,
+		"struct kvm_vcpu must be at offset 0 for arch usercopy region");
+
 	vcpu_e500 = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
 	if (!vcpu_e500) {
 		err = -ENOMEM;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d685491fce4d..70015ae5fc19 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2137,6 +2137,9 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	struct page *nested_msrpm_pages;
 	int err;
 
+	BUILD_BUG_ON_MSG(offsetof(struct vcpu_svm, vcpu) != 0,
+		"struct kvm_vcpu must be at offset 0 for arch usercopy region");
+
 	svm = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
 	if (!svm) {
 		err = -ENOMEM;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42ed3faa6af8..402cf2fe5cdd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6615,6 +6615,9 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	unsigned long *msr_bitmap;
 	int cpu;
 
+	BUILD_BUG_ON_MSG(offsetof(struct vcpu_vmx, vcpu) != 0,
+		"struct kvm_vcpu must be at offset 0 for arch usercopy region");
+
 	vmx = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
 	if (!vmx)
 		return ERR_PTR(-ENOMEM);
-- 
2.22.0

