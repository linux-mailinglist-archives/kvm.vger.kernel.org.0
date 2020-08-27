Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35414254AB3
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 18:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgH0Q1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 12:27:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54530 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726820AbgH0Q1t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Aug 2020 12:27:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598545667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gDA1nnu33h9EoCIllQ/S4lYLXEMFrnx+yFYTlg2I2Kk=;
        b=eJxzUleX1idhSmVyOPAcDwnxX5BmmUOmB1asOBaxIKq41VCFb0yz24DVzqNhxTCYMa0Vxg
        VVkVMvMAGGIrg+eW58nQBv1o8ccdKk5s2J7xubkiUm6m4Zia0z2yLx+rFJRBFBK5MEoKl8
        ClaYZ0m45yVvkAXymz2VXhcVRVA0x+8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-XVyJHn2IPc-cIosfpYpRQA-1; Thu, 27 Aug 2020 12:27:44 -0400
X-MC-Unique: XVyJHn2IPc-cIosfpYpRQA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDDB864080;
        Thu, 27 Aug 2020 16:27:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86D825C1DA;
        Thu, 27 Aug 2020 16:27:39 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/3] KVM: nSVM: more strict SMM checks when returning to nested guest
Date:   Thu, 27 Aug 2020 19:27:20 +0300
Message-Id: <20200827162720.278690-4-mlevitsk@redhat.com>
In-Reply-To: <20200827162720.278690-1-mlevitsk@redhat.com>
References: <20200827162720.278690-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* check that guest is 64 bit guest, otherwise the SVM related fields
  in the smm state area are not defined

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
index 03dd7bac80348..0cfb8c08e744e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3900,21 +3900,28 @@ static int svm_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *nested_vmcb;
 	struct kvm_host_map map;
-	u64 guest;
-	u64 vmcb;
 	int ret = 0;
 
-	guest = GET_SMSTATE(u64, smstate, 0x7ed8);
-	vmcb = GET_SMSTATE(u64, smstate, 0x7ee0);
+	if (guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
+		u64 saved_efer = GET_SMSTATE(u64, smstate, 0x7ed0);
+		u64 guest = GET_SMSTATE(u64, smstate, 0x7ed8);
+		u64 vmcb = GET_SMSTATE(u64, smstate, 0x7ee0);
 
-	if (guest) {
-		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb), &map) == -EINVAL)
-			return 1;
-		nested_vmcb = map.hva;
-		ret = enter_svm_guest_mode(svm, vmcb, nested_vmcb);
-		kvm_vcpu_unmap(&svm->vcpu, &map, true);
+		if (guest) {
+			if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
+				return 1;
+
+			if (!(saved_efer && EFER_SVME))
+				return 1;
+
+			if (kvm_vcpu_map(&svm->vcpu,
+					 gpa_to_gfn(vmcb), &map) == -EINVAL)
+				return 1;
+
+			ret = enter_svm_guest_mode(svm, vmcb, map.hva);
+			kvm_vcpu_unmap(&svm->vcpu, &map, true);
+		}
 	}
 
 	return ret;
-- 
2.26.2

