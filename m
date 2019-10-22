Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F471DFB08
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387461AbfJVB7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 21:59:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:61583 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387437AbfJVB7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293799"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/45] KVM: PPC: Book3S PR: Allocate book3s and shadow vcpu after common init
Date:   Mon, 21 Oct 2019 18:58:53 -0700
Message-Id: <20191022015925.31916-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Call kvm_vcpu_init() in kvmppc_core_vcpu_create_pr() prior to allocating
the book3s and shadow_vcpu objects in preparation of moving said call to
common PPC code.  Although kvm_vcpu_init() has an arch callback, the
callback is empty for Book3S PR, i.e. barring unseen black magic, moving
the allocation has no real functional impact.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/powerpc/kvm/book3s_pr.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 1e6b83908668..a933ba60bc7c 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1712,12 +1712,18 @@ static int kvmppc_core_vcpu_create_pr(struct kvm *kvm, struct kvm_vcpu *vcpu,
 				      unsigned int id)
 {
 	struct kvmppc_vcpu_book3s *vcpu_book3s;
-	int err = -ENOMEM;
 	unsigned long p;
+	int err;
+
+	err = kvm_vcpu_init(vcpu, kvm, id);
+	if (err)
+		return err;
+
+	err = -ENOMEM;
 
 	vcpu_book3s = vzalloc(sizeof(struct kvmppc_vcpu_book3s));
 	if (!vcpu_book3s)
-		goto out;
+		goto uninit_vcpu;
 	vcpu->arch.book3s = vcpu_book3s;
 
 #ifdef CONFIG_KVM_BOOK3S_32_HANDLER
@@ -1727,14 +1733,9 @@ static int kvmppc_core_vcpu_create_pr(struct kvm *kvm, struct kvm_vcpu *vcpu,
 		goto free_vcpu3s;
 #endif
 
-	err = kvm_vcpu_init(vcpu, kvm, id);
-	if (err)
-		goto free_shadow_vcpu;
-
-	err = -ENOMEM;
 	p = __get_free_page(GFP_KERNEL|__GFP_ZERO);
 	if (!p)
-		goto uninit_vcpu;
+		goto free_shadow_vcpu;
 	vcpu->arch.shared = (void *)p;
 #ifdef CONFIG_PPC_BOOK3S_64
 	/* Always start the shared struct in native endian mode */
@@ -1770,15 +1771,14 @@ static int kvmppc_core_vcpu_create_pr(struct kvm *kvm, struct kvm_vcpu *vcpu,
 
 free_shared_page:
 	free_page((unsigned long)vcpu->arch.shared);
-uninit_vcpu:
-	kvm_vcpu_uninit(vcpu);
 free_shadow_vcpu:
 #ifdef CONFIG_KVM_BOOK3S_32_HANDLER
 	kfree(vcpu->arch.shadow_vcpu);
 free_vcpu3s:
 #endif
 	vfree(vcpu_book3s);
-out:
+uninit_vcpu:
+	kvm_vcpu_uninit(vcpu);
 	return err;
 }
 
-- 
2.22.0

