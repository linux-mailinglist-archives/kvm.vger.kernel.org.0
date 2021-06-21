Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60FE3AF128
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 18:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhFURBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 13:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbhFURA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 13:00:56 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BCAC061145
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 09:31:35 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id a12-20020ac8108c0000b029023c90fba3dcso12321500qtj.7
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 09:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sTDc/9kKVWFZ6hO1Y/wCoh3Kz/EL9+Y6sOs1hNsKjRo=;
        b=XC5Xo6xTMpDKeVOIL6dec5Gzfea5nQ0s3icAgn2IAVmt4Q4g4JmKxYdqFH/YqBmVUK
         kg3tczoXIEviY5a0BhYdgUPqFgQWkXNRyp21sVKK3K8Yr9Q7FDKxOC9i3KtipT9pgRO9
         8pYBULpRNiJezzFO+0L4dDexJ3U5nG756BnFhoBZe2lSzWkymIn5RXYqINw+anpIwBbb
         VMOb0UWZ3xXbZoWBf3NA317vQbvSt6xBF7nqBVfY7+s3+OobwOQNWF2M+2YJ/AN02Juo
         iiJwb2UDC0TacYoyIFY+1oBeN1pu8n1hYDVOiKMpR6rqThPIKwYrtfKzfSlqB2fVkIDm
         BjFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sTDc/9kKVWFZ6hO1Y/wCoh3Kz/EL9+Y6sOs1hNsKjRo=;
        b=C9LwEz8dcmeKeAhyL0bckCfnXzDiMa7lzyP2ZUp7hSB8Q2sLcOg/zHkAO21TPYtP7a
         lmfHUkoqNUyg3bIGPkewO6ASeB2Z2bODadZ0Qb4BaAbENghFjV7Did0oDZfudIPP6pxq
         1LyeVY2XgxsuAybfj2Ik0j9cfZ0sRUoCiBHSWYVLr+QTRi0W0alJmopF4aYKRhhWSOgh
         x7eJalh3dCwN238H9GQkF6n9fRhqd6z9lnI1MGr2kqdKCXA52SIplCNAv0qsShXdjKCm
         yvIVaDXLMDI47uIbto5RU6Fem/bDG3apgi+2anUL6aJIGtNCXS3wn+5sNqcFIX1zvv7d
         JBtg==
X-Gm-Message-State: AOAM533bUHiJhunJd5l9mhktgAo2+UMqkirf3wry5SVKg+P6ZrII83SJ
        Aj31VReEHjD/o5e8gQdmRnob9owOepPCA1Mhrjcr8FpR/izrdaywqRlYOP+kjCHNEmHDVe0KFLh
        9CJDvQhae5fiuULte4xaI8bTRzfABzlI87fJjsAtF/BLpF1i3Yt63RZ1geA==
X-Google-Smtp-Source: ABdhPJwm3lwYL9m3LNZBnOOsE/MWmq1zF7GnEB8bo+g0PBvbGRxctdVhkOdgYzhRfiXTQ8KYdYOcL080KHY=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:2742:338c:f077:6d85])
 (user=pgonda job=sendgmr) by 2002:a25:be89:: with SMTP id i9mr31617565ybk.300.1624293094559;
 Mon, 21 Jun 2021 09:31:34 -0700 (PDT)
Date:   Mon, 21 Jun 2021 09:31:18 -0700
In-Reply-To: <20210621163118.1040170-1-pgonda@google.com>
Message-Id: <20210621163118.1040170-4-pgonda@google.com>
Mime-Version: 1.0
References: <20210621163118.1040170-1-pgonda@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 3/3] KVM, SEV: Add support for SEV-ES local migration
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Local migration provides a low-cost mechanism for userspace VMM upgrades.
It is an alternative to traditional (i.e., remote) live migration. Whereas
remote migration handles move a guest to a new host, local migration only
handles moving a guest to a new userspace VMM within a host.

For SEV-ES to work with local migration the VMSAs, GHCB metadata,
and other SEV-ES info needs to be preserved along with the guest's
memory. KVM maintains a pointer to each vCPUs GHCB and may additionally
contain an copy of the GHCB's save area if the guest has been using it
for NAE handling. The local send and receive ioctls have been updated to
move this additional metadata required for each vCPU in SEV-ES into
hashmap for SEV local migration data.

Signed-off-by: Peter Gonda <pgonda@google.com>
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
 arch/x86/kvm/svm/sev.c | 164 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 150 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7c33ad2b910d..33df7ed08d21 100644
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
@@ -1163,6 +1181,94 @@ static int place_migration_node(struct sev_info_migration_node *entry)
 	return ret;
 }
 
+static int process_vmsa_list(struct kvm *kvm, struct list_head *vmsa_list)
+{
+	struct vmsa_node *vmsa_node, *q;
+	struct kvm_vcpu *vcpu;
+	struct vcpu_svm *svm;
+
+	lockdep_assert_held(&kvm->lock);
+
+	if (!vmsa_list)
+		return 0;
+
+	list_for_each_entry(vmsa_node, vmsa_list, list) {
+		if (!kvm_get_vcpu_by_id(kvm, vmsa_node->vcpu_id)) {
+			WARN(1,
+			     "Failed to find VCPU with ID %d despite presence in VMSA list.\n",
+			     vmsa_node->vcpu_id);
+			return -1;
+		}
+	}
+
+	/*
+	 * Move any stashed VMSAs back to their respective VMCBs and delete
+	 * those nodes.
+	 */
+	list_for_each_entry_safe(vmsa_node, q, vmsa_list, list) {
+		vcpu = kvm_get_vcpu_by_id(kvm, vmsa_node->vcpu_id);
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
+
+	return 0;
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
+		node->vcpu_id = vcpu->vcpu_id;
+
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
+	if (process_vmsa_list(kvm, &entry->vmsa_list))
+		WARN(1, "Unable to move VMSA list back to source VM. Guest is in a broken state now.");
+	return -1;
+}
+
 static int sev_local_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -1174,9 +1280,6 @@ static int sev_local_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
-	if (sev->es_active)
-		return -EPERM;
-
 	if (sev->info_token != 0)
 		return -EEXIST;
 
@@ -1196,8 +1299,19 @@ static int sev_local_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
 
 	token = entry->token;
 
@@ -1215,6 +1329,11 @@ static int sev_local_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	hash_del(&entry->hnode);
 	spin_unlock(&sev_info_migration_hash_lock);
 
+e_vmsadel:
+	if (sev_es_guest(kvm) && process_vmsa_list(kvm, &entry->vmsa_list))
+		WARN(1,
+		     "Unable to move VMSA list back to source VM. Guest is in a broken state now.");
+
 e_listdel:
 	list_replace_init(&entry->regions_list, &sev->regions_list);
 
@@ -1233,9 +1352,6 @@ static int sev_local_receive(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
-	if (sev->es_active)
-		return -EPERM;
-
 	if (sev->handle != 0)
 		return -EPERM;
 
@@ -1254,6 +1370,14 @@ static int sev_local_receive(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	memcpy(&old_info, sev, sizeof(old_info));
 
+	if (entry->es_enabled) {
+		if (process_vmsa_list(kvm, &entry->vmsa_list))
+			goto err_unlock;
+
+		sev->es_active = true;
+		sev->ap_jump_table = entry->ap_jump_table;
+	}
+
 	/*
 	 * The source VM always frees @entry On the target we simply
 	 * mark the token as invalid to notify the source the sev info
@@ -2046,12 +2170,22 @@ void sev_vm_destroy(struct kvm *kvm)
 		__unregister_region_list_locked(kvm, &sev->regions_list);
 	}
 
-	/*
-	 * If userspace was terminated before unregistering the memory
-	 * regions then lets unpin all the registered memory.
-	 */
-	if (entry)
+	if (entry) {
+		/*
+		 * If there are any saved VMSAs, restore them so they can be
+		 * destructed through the normal path.
+		 */
+		if (entry->es_enabled)
+			if (process_vmsa_list(kvm, &entry->vmsa_list))
+				WARN(1,
+				     "Unable to clean up vmsa_list");
+
+		/*
+		 * If userspace was terminated before unregistering the memory
+		 * regions then lets unpin all the registered memory.
+		 */
 		__unregister_region_list_locked(kvm, &entry->regions_list);
+	}
 
 	mutex_unlock(&kvm->lock);
 
@@ -2243,9 +2377,11 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 
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
2.32.0.288.g62a8d224e6-goog

