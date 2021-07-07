Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DAA3BE85D
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 14:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhGGMyN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 08:54:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57667 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231838AbhGGMyI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 08:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625662288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7DSEkQs371TUA5T9ZiBAor43JbG2Jq1QBzMR0wgSBuY=;
        b=QxbMD6zvuWHyuKrtZ6fu+O9y7mt9uFSLTYJxedGNVCERljkKPs23aWrzKbuRANMcW4ulgW
        9ViXDgeWOo5INqZgGi7miefHkh5v+c90xqb9Rh+4B8FlQxKOFwAz/JvIumG9nNVjzB2Nlv
        QAd4bmSdvsmeSIZo0QxmSdo2dXfp0Go=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-TH6GPMgNPkCSrR-i3NqNCQ-1; Wed, 07 Jul 2021 08:51:24 -0400
X-MC-Unique: TH6GPMgNPkCSrR-i3NqNCQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F593802E61;
        Wed,  7 Jul 2021 12:51:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FE2B19C45;
        Wed,  7 Jul 2021 12:51:18 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/3] KVM: SVM: add module param to control the #SMI interception
Date:   Wed,  7 Jul 2021 15:51:00 +0300
Message-Id: <20210707125100.677203-4-mlevitsk@redhat.com>
In-Reply-To: <20210707125100.677203-1-mlevitsk@redhat.com>
References: <20210707125100.677203-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In theory there are no side effects of not intercepting #SMI,
because then #SMI becomes transparent to the OS and the KVM.

Plus an observation on recent Zen2 CPUs reveals that these
CPUs ignore #SMI interception and never deliver #SMI VMexits.

This is also useful to test nested KVM to see that L1
handles #SMIs correctly in case when L1 doesn't intercept #SMI.

Finally the default remains the same, the SMI are intercepted
by default thus this patch doesn't have any effect unless
non default module param value is used.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c |  4 ++++
 arch/x86/kvm/svm/svm.c    | 10 +++++++++-
 arch/x86/kvm/svm/svm.h    |  1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 21d03e3a5dfd..2884c54a72bb 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -154,6 +154,10 @@ void recalc_intercepts(struct vcpu_svm *svm)
 
 	for (i = 0; i < MAX_INTERCEPT; i++)
 		c->intercepts[i] |= g->intercepts[i];
+
+	/* If SMI is not intercepted, ignore guest SMI intercept as well  */
+	if (!intercept_smi)
+		vmcb_clr_intercept(c, INTERCEPT_SMI);
 }
 
 static void copy_vmcb_control_area(struct vmcb_control_area *dst,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a3aad97fa427..9f95e77d5ce1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -198,6 +198,11 @@ module_param(avic, bool, 0444);
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
+
+bool intercept_smi = true;
+module_param(intercept_smi, bool, 0444);
+
+
 static bool svm_gp_erratum_intercept = true;
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
@@ -1206,7 +1211,10 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 
 	svm_set_intercept(svm, INTERCEPT_INTR);
 	svm_set_intercept(svm, INTERCEPT_NMI);
-	svm_set_intercept(svm, INTERCEPT_SMI);
+
+	if (intercept_smi)
+		svm_set_intercept(svm, INTERCEPT_SMI);
+
 	svm_set_intercept(svm, INTERCEPT_SELECTIVE_CR0);
 	svm_set_intercept(svm, INTERCEPT_RDPMC);
 	svm_set_intercept(svm, INTERCEPT_CPUID);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f89b623bb591..8cb3bd59c5ea 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -31,6 +31,7 @@
 #define MSRPM_OFFSETS	16
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
+extern bool intercept_smi;
 
 /*
  * Clean bits in VMCB.
-- 
2.26.3

