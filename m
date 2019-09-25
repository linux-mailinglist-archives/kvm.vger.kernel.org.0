Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2076DBDF03
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 15:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406516AbfIYNaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 09:30:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406503AbfIYNai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 09:30:38 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7747710C051A;
        Wed, 25 Sep 2019 13:30:38 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.43.2.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA9E81001B00;
        Wed, 25 Sep 2019 13:30:36 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: [PATCH v2] KVM: vmx: fix build warnings in hv_enable_direct_tlbflush() on i386
Date:   Wed, 25 Sep 2019 15:30:35 +0200
Message-Id: <20190925133035.7576-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Wed, 25 Sep 2019 13:30:38 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following was reported on i386:

  arch/x86/kvm/vmx/vmx.c: In function 'hv_enable_direct_tlbflush':
  arch/x86/kvm/vmx/vmx.c:503:10: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

pr_debugs() in this function are  more or less useless, let's just
remove them. evmcs->hv_vm_id can use 'unsigned long' instead of 'u64'.

Also, simplify the code a little bit.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a7c9922e3905..d5b978068209 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -495,23 +495,19 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 	 * Synthetic VM-Exit is not enabled in current code and so All
 	 * evmcs in singe VM shares same assist page.
 	 */
-	if (!*p_hv_pa_pg) {
+	if (!*p_hv_pa_pg)
 		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL);
-		if (!*p_hv_pa_pg)
-			return -ENOMEM;
-		pr_debug("KVM: Hyper-V: allocated PA_PG for %llx\n",
-		       (u64)&vcpu->kvm);
-	}
+
+	if (!*p_hv_pa_pg)
+		return -ENOMEM;
 
 	evmcs = (struct hv_enlightened_vmcs *)to_vmx(vcpu)->loaded_vmcs->vmcs;
 
 	evmcs->partition_assist_page =
 		__pa(*p_hv_pa_pg);
-	evmcs->hv_vm_id = (u64)vcpu->kvm;
+	evmcs->hv_vm_id = (unsigned long)vcpu->kvm;
 	evmcs->hv_enlightenments_control.nested_flush_hypercall = 1;
 
-	pr_debug("KVM: Hyper-V: enabled DIRECT flush for %llx\n",
-		 (u64)vcpu->kvm);
 	return 0;
 }
 
-- 
2.20.1

