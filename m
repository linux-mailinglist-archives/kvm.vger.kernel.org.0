Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E27C7E07E
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 18:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbfHAQqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 12:46:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:14400 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbfHAQqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 12:46:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 09:46:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,334,1559545200"; 
   d="scan'208";a="201357081"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 01 Aug 2019 09:46:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Unconditionally call x86 ops that are always implemented
Date:   Thu,  1 Aug 2019 09:46:06 -0700
Message-Id: <20190801164606.20777-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove two stale checks for non-NULL ops now that they're implemented by
both VMX and SVM.

Fixes: 74f169090b6f ("kvm/svm: Setup MCG_CAP on AMD properly")
Fixes: b31c114b82b2 ("KVM: X86: Provide a capability to disable PAUSE intercepts")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 01e18caac825..2c25a19d436f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3506,8 +3506,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 	for (bank = 0; bank < bank_num; bank++)
 		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
 
-	if (kvm_x86_ops->setup_mce)
-		kvm_x86_ops->setup_mce(vcpu);
+	kvm_x86_ops->setup_mce(vcpu);
 out:
 	return r;
 }
@@ -9313,10 +9312,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_page_track_init(kvm);
 	kvm_mmu_init_vm(kvm);
 
-	if (kvm_x86_ops->vm_init)
-		return kvm_x86_ops->vm_init(kvm);
-
-	return 0;
+	return kvm_x86_ops->vm_init(kvm);
 }
 
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
-- 
2.22.0

