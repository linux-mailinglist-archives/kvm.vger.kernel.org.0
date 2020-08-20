Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2205624BEE6
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 15:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbgHTNex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 09:34:53 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56817 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729887AbgHTNeJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 09:34:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597930447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8RVL/FGn7EfjF6wq4vBRCX/EgGnhsTqNVSZCe4zwMu4=;
        b=hcmqYA2gECps7hE4OHvDTAw3/FPzHh+swDIX1ehIgoxSi+Y7P71Q2aiDYV67UzOhyZYEjv
        KgUqW2bm2EkGb/NU98tZVRiXkxWl3doXAEWzWP+jjs6fXGodsF0WXzGtb/taUsEvCCCmcn
        NpL5d9PsT84Vlfg6YY43SHemgXJkNRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-sa-2u1F9MuWGCADoCo9BLQ-1; Thu, 20 Aug 2020 09:34:05 -0400
X-MC-Unique: sa-2u1F9MuWGCADoCo9BLQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA08685B683;
        Thu, 20 Aug 2020 13:34:03 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42C0616E21;
        Thu, 20 Aug 2020 13:34:00 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 5/7] KVM: nSVM: more strict smm checks
Date:   Thu, 20 Aug 2020 16:33:37 +0300
Message-Id: <20200820133339.372823-6-mlevitsk@redhat.com>
In-Reply-To: <20200820133339.372823-1-mlevitsk@redhat.com>
References: <20200820133339.372823-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* check that guest is 64 bit guest, otherwise the fields in the smm
  state area are not defined

* If the SMM area indicates that SMM interrupted a running guest,
  check that EFER.SVME which is also saved in this area is set, otherwise
  the guest might have tampered with SMM save area, and so indicate
  emulation failure which should triple fault the guest.

* Check that that guest CPUID supports SVM (due to the same issue as above)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f4569899361f..2ac13420055d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3902,22 +3902,29 @@ static int svm_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *nested_vmcb;
 	struct kvm_host_map map;
-	u64 guest;
-	u64 vmcb12_gpa;
 	int ret = 0;
 
-	guest = GET_SMSTATE(u64, smstate, 0x7ed8);
-	vmcb12_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
+	if (guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
+		u64 saved_efer = GET_SMSTATE(u64, smstate, 0x7ed0);
+		u64 guest = GET_SMSTATE(u64, smstate, 0x7ed8);
+		u64 vmcb12_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
 
-	if (guest) {
-		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
-			return 1;
+		if (guest) {
 
-		nested_vmcb = map.hva;
-		ret = enter_svm_guest_mode(svm, vmcb12_gpa, nested_vmcb);
-		kvm_vcpu_unmap(&svm->vcpu, &map, true);
+			if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
+				return 1;
+
+			if (!(saved_efer && EFER_SVME))
+				return 1;
+
+			if (kvm_vcpu_map(&svm->vcpu,
+					 gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
+				return 1;
+
+			ret = enter_svm_guest_mode(svm, vmcb12_gpa, map.hva);
+			kvm_vcpu_unmap(&svm->vcpu, &map, true);
+		}
 	}
 
 	return ret;
-- 
2.26.2

