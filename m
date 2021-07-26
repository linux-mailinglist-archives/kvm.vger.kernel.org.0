Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB613D67B4
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 21:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhGZTKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 15:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhGZTJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 15:09:59 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0629C0613CF
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 12:50:26 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id t11-20020a17090ae50bb02901757bad7139so867273pjy.0
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 12:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Q4reftQaT04dhcm4aCoEszxsGfniImdy4xbElZWV4Es=;
        b=XFvU9ykjLoZSWpP7GWMBISaqlOdhy0rE/Eiu8iTogZtcg1hKvn2CiSLmVE6nFDL+XO
         kT1PDlYAsk7CSiqp7Xu43WpHsEYz7J4d210Nm70dL3SnExbb1xWvOe6Nx2X1PWuXQE7B
         OJ6wDU376iY6buCKnJqP8mZ4RbL9mNehUTTXuHCdbR9SZf9hQaFJUtFH3b8le1z99q3s
         D0jOjLgW+GeCh/4OuPub8+TzKhOz6hBUEQYEJbYfaFTpuWQQqu4mduFvDkH5BYHpcd5R
         zDcUYUI3fMy+jRppf4oycWm/0CvzUkogAro4eCu9ix67yb20CpRM6YwpFXnCuEQ7FkN7
         wzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Q4reftQaT04dhcm4aCoEszxsGfniImdy4xbElZWV4Es=;
        b=tmvAhDanZ4lkxTdtNeDZxABddMn6Z4m5vuCv5t0OPi+wbi9/OO6h4y53IDGCHn9rYp
         Tpoq/mvBYvkmx+g0CHDP2LjZ+uon0dz49gBVogB7E7x/xVpSM5jG15MApxnGsGki3Tpv
         n74jit9apG6z2yuOFufodV68s/ml2IW5KzscyQaTWbyIwHAmYUFXDP/SdcVpwxMtBYLQ
         BuY1k2TjlmvxHOCY9PsZZq6HstM8SzxN5K7oHiX7sMMUQ1pTmapLxbIU6OYErYjb/nUx
         oIqXJbn/rU7mj5GIt+7dW10Wrbx1Z3D3rwn8u1WhnKmEHy+Ywlkmhkh5Cc/p4MBWR/Xs
         +83A==
X-Gm-Message-State: AOAM533xt0oQXcR7SMbTNslTqWBWW9jBiQbrUFi0sELKsI4xwAYXLzpq
        Q9+KSbt8TrU0qOZBenczSn2E2CIKvan5AP0V+kMn+QKqEsIvvYCHHH9pBQ7nlMM1h5L/lGg7NGH
        1q0RvIc4+5zL05fQBcxJYaSXqnkq0tuXcUlo/LsiRlImIhy3Kkt5QquXfAQ==
X-Google-Smtp-Source: ABdhPJwtz6zjU1Rm/J1NJM1PY1Sv0edahHdAl25EjFfivTaaP0RDokALz2skc/pZBPcGpZ+Rg8ID281K5Mw=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:f4a:330f:115:e2d4])
 (user=pgonda job=sendgmr) by 2002:a17:903:308b:b029:12b:c7ec:998d with SMTP
 id u11-20020a170903308bb029012bc7ec998dmr13454516plc.78.1627329026145; Mon,
 26 Jul 2021 12:50:26 -0700 (PDT)
Date:   Mon, 26 Jul 2021 12:50:15 -0700
In-Reply-To: <20210726195015.2106033-1-pgonda@google.com>
Message-Id: <20210726195015.2106033-4-pgonda@google.com>
Mime-Version: 1.0
References: <20210726195015.2106033-1-pgonda@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH 3/3 V3] KVM, SEV: Add support for SEV-ES intra host migration
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For SEV-ES to work with intra host migration the VMSAs, GHCB metadata,
and other SEV-ES info needs to be preserved along with the guest's
memory.

Signed-off-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
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
 arch/x86/kvm/svm/sev.c | 145 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 135 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 082255b18840..4f8186b3507f 100644
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
@@ -1157,6 +1175,87 @@ static int place_migration_node(struct sev_info_migration_node *entry)
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
+
+	INIT_LIST_HEAD(&entry->vmsa_list);
+	for (i = 0; i < num_vcpus; ++i) {
+		node = kzalloc(sizeof(*node), GFP_KERNEL);
+		if (!node)
+			goto e_freelist;
+
+		vcpu = kvm->vcpus[i];
+		if (!vcpu->arch.guest_state_protected) {
+			kfree(node);
+			goto e_freelist;
+		}
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
@@ -1167,9 +1266,6 @@ static int sev_intra_host_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
-	if (sev->es_active)
-		return -EPERM;
-
 	if (sev->handle == 0)
 		return -EPERM;
 
@@ -1196,13 +1292,28 @@ static int sev_intra_host_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	INIT_LIST_HEAD(&entry->regions_list);
 	list_replace_init(&sev->regions_list, &entry->regions_list);
 
+	if (sev_es_guest(kvm)) {
+		/*
+		 * If this is an ES guest, we need to move each VMCB's VMSA
+		 * into a list for migration.
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
 
@@ -1223,9 +1334,6 @@ static int sev_intra_host_receive(struct kvm *kvm,
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
-	if (sev->es_active)
-		return -EPERM;
-
 	if (sev->handle != 0)
 		return -EPERM;
 
@@ -1242,6 +1350,13 @@ static int sev_intra_host_receive(struct kvm *kvm,
 
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
@@ -2034,8 +2149,16 @@ void sev_vm_destroy(struct kvm *kvm)
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
 
@@ -2227,9 +2350,11 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 
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
2.32.0.432.gabb21c7263-goog

