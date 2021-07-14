Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A853C884C
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 18:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239928AbhGNQE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 12:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239893AbhGNQE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 12:04:56 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB514C06175F
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 09:02:04 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id ca6-20020ad456060000b02902ea7953f97fso1914396qvb.22
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 09:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JjgFF2xccQjA8NSa1haK0ZpvnZTx+cXrKwja+zwbD+8=;
        b=VZ4eLQxc9WsQtHSs9nAPbQ4WWAQ68Xc+oqNX2V2LcPyrD07Og/3pguPChB7Afy6f2f
         V79Da29qg80NUqhOsg7KZr7ADWlm7hHuezzmVL34gA/Hlqc9pgjM1ZHkhL4CvZWMt+CH
         HwOLp/vQB5HBJBcOavbR1Dy87QMA7TsvbZraenAzxSWjDXarS5wfZKd/dGUngdfuF91R
         EIRzcSkqYfUvowZb0gaFOE0PRr1cDnfgEbvzafIr8vZXtqFdHz1XgKNMZ4Zm8G0syhM1
         KsCZyd+1TwiOtpUQggLFL8BUTiuK5NUludVBt5ny2GfDGoVBPi3WVL8sdTrxyJWL6F7S
         Vsxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JjgFF2xccQjA8NSa1haK0ZpvnZTx+cXrKwja+zwbD+8=;
        b=au6Rn7Q35aMEGyFQzgVaBev/KjODagGtY1syUxSSOnzv5kJv5Qc5tByE4/FV98U6Jr
         /eDoLAIdzPPEGnwcHDou0ILT96Z0lR7T8F6POXoRAGfLRtLfS/H4bPhuczvlj4p3A3ZW
         M0reZwsLI6s7qktz3rJ13tD+1rjvv8wFqZJRUX237fAcZB9t81l0aw6xXeTmLuARDbMk
         4Bxtj+4hQ446MzAD0U529U/YVwA3QqBWHsTxDTxTfo4ziy1PfCQsPR5f6kfQMn9wH0FH
         nnpeFrv27w8QO0I0x9PgjK0p2v6shdEmwHqfPKuMWVwRPTg8wV+GpdghfrLZStvwQ2+C
         6xdg==
X-Gm-Message-State: AOAM530yyvn3daeXdGPWPzlnj2oUl98TNTjCFoDUIh6mPVvxzWqg3uZ7
        DgL7REgZpNN5jSVeCJZDqGs4ELz7+E8=
X-Google-Smtp-Source: ABdhPJycW/3lEBmguA2i6tVw74RLkxKg8MAeeTraU+axSOG8QIbrB2Kfh9m0YTntcHf64Y0xsqMSeuOjB9U=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:32d8:66d1:672:9aeb])
 (user=pgonda job=sendgmr) by 2002:ad4:5386:: with SMTP id i6mr11441177qvv.2.1626278523852;
 Wed, 14 Jul 2021 09:02:03 -0700 (PDT)
Date:   Wed, 14 Jul 2021 09:01:43 -0700
In-Reply-To: <20210714160143.2116583-1-pgonda@google.com>
Message-Id: <20210714160143.2116583-4-pgonda@google.com>
Mime-Version: 1.0
References: <20210714160143.2116583-1-pgonda@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 3/3 V2] KVM, SEV: Add support for SEV-ES intra host migration
From:   Peter Gonda <pgonda@google.com>
To:     pgonda@google.com
Cc:     Marc Orr <marcorr@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For SEV-ES to work with intra host migration the VMSAs, GHCB metadata,
and other SEV-ES info needs to be preserved along with the guest's
memory.

Signed-off-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/kvm/svm/sev.c | 142 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 132 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 03b5e690ca56..e292e2cd7c99 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -77,6 +77,19 @@ struct enc_region {
 	unsigned long size;
 };
 
+struct vmsa_node {
+	struct list_head list;
+	int vcpu_id;
+	struct vmcb_save_area *vmsa;
+	struct ghcb *ghcb;
+	u64 ghcb_gpa;
+
+	void *ghcb_sa;
+	u64 ghcb_sa_len;
+	bool ghcb_sa_sync;
+	bool ghcb_sa_free;
+};
+
 struct sev_info_migration_node {
 	struct hlist_node hnode;
 	u64 token;
@@ -87,6 +100,11 @@ struct sev_info_migration_node {
 	unsigned long pages_locked;
 	struct list_head regions_list;
 	struct misc_cg *misc_cg;
+
+	/* The following fields are for SEV-ES guests */
+	bool es_enabled;
+	struct list_head vmsa_list;
+	u64 ap_jump_table;
 };
 
 #define SEV_INFO_MIGRATION_HASH_BITS    7
@@ -1157,6 +1175,84 @@ static int place_migration_node(struct sev_info_migration_node *entry)
 	return ret;
 }
 
+static void process_vmsa_list(struct kvm *kvm, struct list_head *vmsa_list)
+{
+	struct vmsa_node *vmsa_node, *q;
+	struct kvm_vcpu *vcpu;
+	struct vcpu_svm *svm;
+
+	lockdep_assert_held(&kvm->lock);
+
+	/*
+	 * Move any stashed VMSAs back to their respective VMCBs and delete
+	 * those nodes.
+	 */
+	list_for_each_entry_safe(vmsa_node, q, vmsa_list, list) {
+		vcpu = kvm_get_vcpu_by_id(kvm, vmsa_node->vcpu_id);
+		if (WARN_ON(!vcpu))
+			continue;
+
+		svm = to_svm(vcpu);
+		svm->vmsa = vmsa_node->vmsa;
+		svm->ghcb = vmsa_node->ghcb;
+		svm->vmcb->control.ghcb_gpa = vmsa_node->ghcb_gpa;
+		svm->vcpu.arch.guest_state_protected = true;
+		svm->vmcb->control.vmsa_pa = __pa(svm->vmsa);
+		svm->ghcb_sa = vmsa_node->ghcb_sa;
+		svm->ghcb_sa_len = vmsa_node->ghcb_sa_len;
+		svm->ghcb_sa_sync = vmsa_node->ghcb_sa_sync;
+		svm->ghcb_sa_free = vmsa_node->ghcb_sa_free;
+
+		list_del(&vmsa_node->list);
+		kfree(vmsa_node);
+	}
+}
+
+static int create_vmsa_list(struct kvm *kvm,
+			    struct sev_info_migration_node *entry)
+{
+	int i;
+	const int num_vcpus = atomic_read(&kvm->online_vcpus);
+	struct vmsa_node *node;
+	struct kvm_vcpu *vcpu;
+	struct vcpu_svm *svm;
+
+	INIT_LIST_HEAD(&entry->vmsa_list);
+	for (i = 0; i < num_vcpus; ++i) {
+		node = kzalloc(sizeof(*node), GFP_KERNEL);
+		if (!node)
+			goto e_freelist;
+
+		vcpu = kvm->vcpus[i];
+		if (!vcpu->arch.guest_state_protected)
+			goto e_freelist;
+
+		node->vcpu_id = vcpu->vcpu_id;
+		svm = to_svm(vcpu);
+		node->vmsa = svm->vmsa;
+		svm->vmsa = NULL;
+		node->ghcb = svm->ghcb;
+		svm->ghcb = NULL;
+		node->ghcb_gpa = svm->vmcb->control.ghcb_gpa;
+		node->ghcb_sa = svm->ghcb_sa;
+		svm->ghcb_sa = NULL;
+		node->ghcb_sa_len = svm->ghcb_sa_len;
+		svm->ghcb_sa_len = 0;
+		node->ghcb_sa_sync = svm->ghcb_sa_sync;
+		svm->ghcb_sa_sync = false;
+		node->ghcb_sa_free = svm->ghcb_sa_free;
+		svm->ghcb_sa_free = false;
+
+		list_add_tail(&node->list, &entry->vmsa_list);
+	}
+
+	return 0;
+
+e_freelist:
+	process_vmsa_list(kvm, &entry->vmsa_list);
+	return -1;
+}
+
 static int sev_intra_host_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -1167,9 +1263,6 @@ static int sev_intra_host_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
-	if (sev->es_active)
-		return -EPERM;
-
 	if (sev->handle == 0)
 		return -EPERM;
 
@@ -1196,13 +1289,28 @@ static int sev_intra_host_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	INIT_LIST_HEAD(&entry->regions_list);
 	list_replace_init(&sev->regions_list, &entry->regions_list);
 
+	if (sev_es_guest(kvm)) {
+		/*
+		 * If this is an ES guest, we need to move each VMCB's VMSA into a
+		 * list for migration.
+		 */
+		entry->es_enabled = true;
+		entry->ap_jump_table = sev->ap_jump_table;
+		if (create_vmsa_list(kvm, entry))
+			goto e_listdel;
+	}
+
 	if (place_migration_node(entry))
-		goto e_listdel;
+		goto e_vmsadel;
 
 	sev->info_token = entry->token;
 
 	return 0;
 
+e_vmsadel:
+	if (sev_es_guest(kvm))
+		process_vmsa_list(kvm, &entry->vmsa_list);
+
 e_listdel:
 	list_replace_init(&entry->regions_list, &sev->regions_list);
 
@@ -1223,9 +1331,6 @@ static int sev_intra_host_receive(struct kvm *kvm,
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
-	if (sev->es_active)
-		return -EPERM;
-
 	if (sev->handle != 0)
 		return -EPERM;
 
@@ -1242,6 +1347,13 @@ static int sev_intra_host_receive(struct kvm *kvm,
 
 	memcpy(&old_info, sev, sizeof(old_info));
 
+	if (entry->es_enabled) {
+		process_vmsa_list(kvm, &entry->vmsa_list);
+
+		sev->es_active = true;
+		sev->ap_jump_table = entry->ap_jump_table;
+	}
+
 	/*
 	 * The source VM always frees @entry On the target we simply
 	 * mark the token as invalid to notify the source the sev info
@@ -2034,8 +2146,16 @@ void sev_vm_destroy(struct kvm *kvm)
 	WARN_ON(sev->info_token && !list_empty(&sev->regions_list));
 	unregister_enc_regions(kvm, &sev->regions_list);
 
-	if (mig_entry)
+	if (mig_entry) {
+		/*
+		 * If there are any saved VMSAs, restore them so they can be
+		 * destructed through the normal path.
+		 */
+		if (mig_entry->es_enabled)
+			process_vmsa_list(kvm, &mig_entry->vmsa_list);
+
 		unregister_enc_regions(kvm, &mig_entry->regions_list);
+	}
 
 	mutex_unlock(&kvm->lock);
 
@@ -2222,9 +2342,11 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 
 	svm = to_svm(vcpu);
 
-	if (vcpu->arch.guest_state_protected)
+	if (svm->ghcb && vcpu->arch.guest_state_protected)
 		sev_flush_guest_memory(svm, svm->vmsa, PAGE_SIZE);
-	__free_page(virt_to_page(svm->vmsa));
+
+	if (svm->vmsa)
+		__free_page(virt_to_page(svm->vmsa));
 
 	if (svm->ghcb_sa_free)
 		kfree(svm->ghcb_sa);
-- 
2.32.0.93.g670b81a890-goog

