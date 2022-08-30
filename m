Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E62E5A650C
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiH3Nib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiH3NiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:38:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06A9F72D3
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GI0F/z6HYXFcKCvY3bdnL7mnFBLdvVIvPxsQq6nQylE=;
        b=Gp0Gcnlxvw/o6Wmeh8zsGyUPTUwxnD9o1Ue+Zw7qHTLjTMP28dPNMT6yRHaHmwONlQcFtj
        GW67iDTpLIgqImysQs8NN800ek9rXIoVzjqQmMCATEQLrE6t6m83IPSIaXcAs77HqaNYwe
        +eUpmfrSyfx1MTZnuCZIledw4nmdCtY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-g6RkMMAIOfKgtWgQVwjCVg-1; Tue, 30 Aug 2022 09:37:53 -0400
X-MC-Unique: g6RkMMAIOfKgtWgQVwjCVg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 542C51020BA2;
        Tue, 30 Aug 2022 13:37:52 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECADA2166B26;
        Tue, 30 Aug 2022 13:37:49 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 05/33] KVM: x86: Report error when setting CPUID if Hyper-V allocation fails
Date:   Tue, 30 Aug 2022 15:37:09 +0200
Message-Id: <20220830133737.1539624-6-vkuznets@redhat.com>
In-Reply-To: <20220830133737.1539624-1-vkuznets@redhat.com>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Return -ENOMEM back to userspace if allocating the Hyper-V vCPU struct
fails when enabling Hyper-V in guest CPUID.  Silently ignoring failure
means that KVM will not have an up-to-date CPUID cache if allocating the
struct succeeds later on, e.g. when activating SynIC.

Rejecting the CPUID operation also guarantess that vcpu->arch.hyperv is
non-NULL if hyperv_enabled is true, which will allow for additional
cleanup, e.g. in the eVMCS code.

Note, the initialization needs to be done before CPUID is set, and more
subtly before kvm_check_cpuid(), which potentially enables dynamic
XFEATURES.  Sadly, there's no easy way to avoid exposing Hyper-V details
to CPUID or vice versa.  Expose kvm_hv_vcpu_init() and the Hyper-V CPUID
signature to CPUID instead of exposing cpuid_entry2_find() outside of
CPUID code.  It's hard to envision kvm_hv_vcpu_init() being misused,
whereas cpuid_entry2_find() absolutely shouldn't be used outside of core
CPUID code.

Fixes: 10d7bf1e46dc ("KVM: x86: hyper-v: Cache guest CPUID leaves determining features availability")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/cpuid.c  | 18 +++++++++++++++++-
 arch/x86/kvm/hyperv.c | 30 ++++++++++++++----------------
 arch/x86/kvm/hyperv.h |  6 +++++-
 3 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 75dcf7a72605..ffdc28684cb7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -311,6 +311,15 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
+static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
+{
+	struct kvm_cpuid_entry2 *entry;
+
+	entry = cpuid_entry2_find(entries, nent, HYPERV_CPUID_INTERFACE,
+				  KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+	return entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX;
+}
+
 static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -341,7 +350,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr4_guest_rsvd_bits =
 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
 
-	kvm_hv_set_cpuid(vcpu);
+	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu->arch.cpuid_entries,
+						    vcpu->arch.cpuid_nent));
 
 	/* Invoke the vendor callback only after the above state is updated. */
 	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
@@ -404,6 +414,12 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 		return 0;
 	}
 
+	if (kvm_cpuid_has_hyperv(e2, nent)) {
+		r = kvm_hv_vcpu_init(vcpu);
+		if (r)
+			return r;
+	}
+
 	r = kvm_check_cpuid(vcpu, e2, nent);
 	if (r)
 		return r;
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 8aadd31ed058..bf4729e8cc80 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -38,9 +38,6 @@
 #include "irq.h"
 #include "fpu.h"
 
-/* "Hv#1" signature */
-#define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
-
 #define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 64)
 
 static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
@@ -934,7 +931,7 @@ static void stimer_init(struct kvm_vcpu_hv_stimer *stimer, int timer_index)
 	stimer_prepare_msg(stimer);
 }
 
-static int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
+int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	int i;
@@ -1984,26 +1981,27 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	return HV_STATUS_SUCCESS;
 }
 
-void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
+void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu, bool hyperv_enabled)
 {
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct kvm_cpuid_entry2 *entry;
-	struct kvm_vcpu_hv *hv_vcpu;
 
-	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_INTERFACE);
-	if (entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX) {
-		vcpu->arch.hyperv_enabled = true;
-	} else {
-		vcpu->arch.hyperv_enabled = false;
-		return;
-	}
+	vcpu->arch.hyperv_enabled = hyperv_enabled;
 
-	if (kvm_hv_vcpu_init(vcpu))
+	if (!hv_vcpu) {
+		/*
+		 * KVM should have already allocated kvm_vcpu_hv if Hyper-V is
+		 * enabled in CPUID.
+		 */
+		WARN_ON_ONCE(vcpu->arch.hyperv_enabled);
 		return;
-
-	hv_vcpu = to_hv_vcpu(vcpu);
+	}
 
 	memset(&hv_vcpu->cpuid_cache, 0, sizeof(hv_vcpu->cpuid_cache));
 
+	if (!vcpu->arch.hyperv_enabled)
+		return;
+
 	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES);
 	if (entry) {
 		hv_vcpu->cpuid_cache.features_eax = entry->eax;
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index da2737f2a956..1030b1b50552 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -23,6 +23,9 @@
 
 #include <linux/kvm_host.h>
 
+/* "Hv#1" signature */
+#define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
+
 /*
  * The #defines related to the synthetic debugger are required by KDNet, but
  * they are not documented in the Hyper-V TLFS because the synthetic debugger
@@ -141,7 +144,8 @@ void kvm_hv_request_tsc_page_update(struct kvm *kvm);
 
 void kvm_hv_init_vm(struct kvm *kvm);
 void kvm_hv_destroy_vm(struct kvm *kvm);
-void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu);
+int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu);
+void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu, bool hyperv_enabled);
 int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce);
 int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
 int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
-- 
2.37.2

