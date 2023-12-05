Return-Path: <kvm+bounces-3484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7132D805088
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:37:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2A011C20DE6
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C565A0F7;
	Tue,  5 Dec 2023 10:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U1AHQ8m8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15E11BCA
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kdJQIK/+g+xKaB9MKhkMkYDpvDrDg4/0EhcxqeADwKI=;
	b=U1AHQ8m8038jHQV+bys1NGGUBxlFKe76JooJSP2lYwN6BdXCZYFhBc0LVTKoIKndqYdbyH
	uN6Xhj+HyIlnu14hbm3RDqlxdw8C5SnOOVaZmhzidWYRw6Up2wVlwRL/BpuxfmCbqE817l
	W4MIh1tgA3Q9+dBIPXU9sZGuZ+dnqvI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-180-HWnxHCnjPNO2A_yU4SvCIA-1; Tue,
 05 Dec 2023 05:36:34 -0500
X-MC-Unique: HWnxHCnjPNO2A_yU4SvCIA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D51328EC11E;
	Tue,  5 Dec 2023 10:36:34 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 894362026D66;
	Tue,  5 Dec 2023 10:36:33 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 02/16] KVM: x86: hyper-v: Move Hyper-V partition assist page out of Hyper-V emulation context
Date: Tue,  5 Dec 2023 11:36:16 +0100
Message-ID: <20231205103630.1391318-3-vkuznets@redhat.com>
In-Reply-To: <20231205103630.1391318-1-vkuznets@redhat.com>
References: <20231205103630.1391318-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Hyper-V partition assist page is used when KVM runs on top of Hyper-V and
is not used for Windows/Hyper-V guests on KVM, this means that 'hv_pa_pg'
placement in 'struct kvm_hv' is unfortunate. As a preparation to making
Hyper-V emulation optional, move 'hv_pa_pg' to 'struct kvm_arch' and put it
under CONFIG_HYPERV.

While on it, introduce hv_get_partition_assist_page() helper to allocate
partition assist page. Move the comment explaining why we use a single page
for all vCPUs from VMX and expand it a bit.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/kvm_onhyperv.h     | 20 ++++++++++++++++++++
 arch/x86/kvm/svm/svm_onhyperv.c | 10 +++-------
 arch/x86/kvm/vmx/vmx.c          | 14 +++-----------
 arch/x86/kvm/x86.c              |  4 +++-
 5 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ecf11b963382..9dab2f7de495 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1125,7 +1125,6 @@ struct kvm_hv {
 	 */
 	unsigned int synic_auto_eoi_used;
 
-	struct hv_partition_assist_pg *hv_pa_pg;
 	struct kvm_hv_syndbg hv_syndbg;
 };
 
@@ -1447,6 +1446,7 @@ struct kvm_arch {
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
+	struct hv_partition_assist_pg *hv_pa_pg;
 #endif
 	/*
 	 * VM-scope maximum vCPU ID. Used to determine the size of structures
diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
index f9ca3e7432b2..eefab3dc8498 100644
--- a/arch/x86/kvm/kvm_onhyperv.h
+++ b/arch/x86/kvm/kvm_onhyperv.h
@@ -10,6 +10,26 @@
 int hv_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, gfn_t nr_pages);
 int hv_flush_remote_tlbs(struct kvm *kvm);
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
+static inline hpa_t hv_get_partition_assist_page(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Partition assist page is something which Hyper-V running in L0
+	 * requires from KVM running in L1 before direct TLB flush for L2
+	 * guests can be enabled. KVM doesn't currently use the page but to
+	 * comply with TLFS it still needs to be allocated. For now, this
+	 * is a single page shared among all vCPUs.
+	 */
+	struct hv_partition_assist_pg **p_hv_pa_pg =
+		&vcpu->kvm->arch.hv_pa_pg;
+
+	if (!*p_hv_pa_pg)
+		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
+
+	if (!*p_hv_pa_pg)
+		return INVALID_PAGE;
+
+	return __pa(*p_hv_pa_pg);
+}
 #else /* !CONFIG_HYPERV */
 static inline int hv_flush_remote_tlbs(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 7af8422d3382..3971b3ea5d04 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -18,18 +18,14 @@
 int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	struct hv_vmcb_enlightenments *hve;
-	struct hv_partition_assist_pg **p_hv_pa_pg =
-			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
+	hpa_t partition_assist_page = hv_get_partition_assist_page(vcpu);
 
-	if (!*p_hv_pa_pg)
-		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL);
-
-	if (!*p_hv_pa_pg)
+	if (partition_assist_page == INVALID_PAGE)
 		return -ENOMEM;
 
 	hve = &to_svm(vcpu)->vmcb->control.hv_enlightenments;
 
-	hve->partition_assist_page = __pa(*p_hv_pa_pg);
+	hve->partition_assist_page = partition_assist_page;
 	hve->hv_vm_id = (unsigned long)vcpu->kvm;
 	if (!hve->hv_enlightenments_control.nested_flush_hypercall) {
 		hve->hv_enlightenments_control.nested_flush_hypercall = 1;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40e3780d73ae..cf19a3346639 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -523,22 +523,14 @@ module_param(enlightened_vmcs, bool, 0444);
 static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	struct hv_enlightened_vmcs *evmcs;
-	struct hv_partition_assist_pg **p_hv_pa_pg =
-			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
-	/*
-	 * Synthetic VM-Exit is not enabled in current code and so All
-	 * evmcs in singe VM shares same assist page.
-	 */
-	if (!*p_hv_pa_pg)
-		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
+	hpa_t partition_assist_page = hv_get_partition_assist_page(vcpu);
 
-	if (!*p_hv_pa_pg)
+	if (partition_assist_page == INVALID_PAGE)
 		return -ENOMEM;
 
 	evmcs = (struct hv_enlightened_vmcs *)to_vmx(vcpu)->loaded_vmcs->vmcs;
 
-	evmcs->partition_assist_page =
-		__pa(*p_hv_pa_pg);
+	evmcs->partition_assist_page = partition_assist_page;
 	evmcs->hv_vm_id = (unsigned long)vcpu->kvm;
 	evmcs->hv_enlightenments_control.nested_flush_hypercall = 1;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6d0772b47041..81224b9676d9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12438,7 +12438,9 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 
 void kvm_arch_free_vm(struct kvm *kvm)
 {
-	kfree(to_kvm_hv(kvm)->hv_pa_pg);
+#if IS_ENABLED(CONFIG_HYPERV)
+	kfree(kvm->arch.hv_pa_pg);
+#endif
 	__kvm_arch_free_vm(kvm);
 }
 
-- 
2.43.0


