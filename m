Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B493AF126
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 18:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhFURBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 13:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbhFURAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 13:00:55 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC68C0A3BDB
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 09:31:33 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 124-20020a6217820000b02902feebfd791eso6816325pfx.19
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 09:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bTUKqBPqapF288kZZi/PG/V7rZyTt+OxkKa+oulHbRk=;
        b=N6SvcbUbTlGHC4fDyS3Y27KAdwUBrHccHb0ywPUY1xzkr7R4zKjiiKT7RA22AKwt8U
         UZIKNCKeVCNGypfCE1wX6RtdvgQmvxipBORstRpTN1Xm/HbQmr/PuDo1ucGS5meXygL4
         UQ47xrEknBtaHVW3NZqz92wMeKSlOjUZn0rJ0iVvEqCzm7qLzOZMLHf4ETcdrqQ3NqPc
         aKRj2Vc7hYJAdVny7pvfzXaA/pg1cTzyzxeFqbyjfYXDaPdLEQH47ocUUr5Qn7p0QWBg
         KyNrrfiJTZ++Xg1YvPecYsjdgaRl4IqsxxhEfrK1/twSwoG2LpepDSBGefH4+Q2lMG8I
         yyRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bTUKqBPqapF288kZZi/PG/V7rZyTt+OxkKa+oulHbRk=;
        b=VK5jk/b5j9JsrDbTyy+uYjaF6/aoF0jB6foxz+nuIgw9M0LcyFbOOPE9h2MAiiHluW
         QTKZ6MGEehq2gwGSJlVRrEwXK47r095ucLSedFFR3rMy3M8gzoWUNFqKer7QMRfnEVWa
         O3sn/3Qqp+gp2TxsasMwhZTWZuZfodTfoa70ROujvqD8tDtVz6oRz09MQERAnsGxoRm/
         UXvsK24CWxAj/S5hFI2ZfE/rEfJWjvGgKr59Fe2+XrTkAl9gU+8IJMglaXICqTeTgYIx
         O65X3pEdlMidtCPVgRo6CFemjNHoAvbP+VpG4UC4BuyxLzciOLZpl/3Gx2Ec4AlY+Me4
         eTxg==
X-Gm-Message-State: AOAM531RYIwflrX6zRwmxlAVltqt1errYRFNMP5KPCEe9eh3hlVLCUqD
        NanXC34mVpqdW6E4i89j68NkYOG8SO03dt4Mvka8vdiA6BlEQE8/buMMnUIbHr6tPkvXCU5+AEy
        hfEJpG2TcklObwUZquzCYrbQuXP0Q4vZHAb0atGByA5XuEoA7q59NTfRVaw==
X-Google-Smtp-Source: ABdhPJyeUJ48/anYVTyxeIzXXEjJkQLKxlKEo7hCXi78i1LHj83QtlKWNDNyNwU12joDcL00D/tVx5RaM/Y=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:2742:338c:f077:6d85])
 (user=pgonda job=sendgmr) by 2002:a63:490a:: with SMTP id w10mr24676791pga.286.1624293092751;
 Mon, 21 Jun 2021 09:31:32 -0700 (PDT)
Date:   Mon, 21 Jun 2021 09:31:17 -0700
In-Reply-To: <20210621163118.1040170-1-pgonda@google.com>
Message-Id: <20210621163118.1040170-3-pgonda@google.com>
Mime-Version: 1.0
References: <20210621163118.1040170-1-pgonda@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 2/3] KVM, SEV: Add support for SEV local migration
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Lars Bull <larsbull@google.com>,
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

For SEV to work with local migration, contents of the SEV info struct
such as the ASID (used to index the encryption key in the AMD SP) and
the list
of memory regions need to be transferred to the target VM. Adds
commands for sending and receiving the sev info.

To avoid exposing this internal state to userspace and prevent other
processes from importing state they shouldn't have access to, the send
returns a token to userspace that is handed off to the target VM. The
target passes in this token to receive the sent state. The token is only
valid for one-time use. Functionality on the source becomes limited
after
send has been performed. If the source is destroyed before the target
has
received, the token becomes invalid.

The target is expected to be initialized (sev_guest_init), but not
launched
state (sev_launch_start) when performing receive. Once the target has
received, it will be in a launched state and will not need to perform
the
typical SEV launch commands.

Co-developed-by: Lars Bull <larsbull@google.com>
Signed-off-by: Lars Bull <larsbull@google.com>
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
 .../virt/kvm/amd-memory-encryption.rst        |  43 +++
 arch/x86/kvm/svm/sev.c                        | 270 +++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 include/uapi/linux/kvm.h                      |  12 +
 4 files changed, 317 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 5ec8a1902e15..0f9030e3dcfe 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -427,6 +427,49 @@ issued by the hypervisor to make the guest ready for execution.
 
 Returns: 0 on success, -negative on error
 
+10. KVM_SEV_LOCAL_SEND
+----------------------------------
+
+The KVM_SEV_LOCAL_SEND command is used to stage the VM's SEV info
+for the purposes of migrating memory to a new local VM while using the same SEV
+key. If the source VM is destroyed before the staged info has been received by
+the target, the info is lost. Once the info has been staged, only commands
+KVM_SEV_DBG_DECRYPT, and KVM_SEV_DBG_ENCRYPT
+can be used by the source.
+
+Parameters (out): struct kvm_sev_local_send
+
+Returns: 0 on success, -negative on error
+
+::
+
+    struct kvm_sev_local_send {
+        __u64 info_token;    /* token referencing the staged info */
+    };
+
+11. KVM_SEV_LOCAL_RECEIVE
+-------------------------------------
+
+The KVM_SEV_LOCAL_RECEIVE command is used to transfer staged SEV
+info to a target VM from some source VM. SEV on the target VM should be active
+when receive is performed, but not yet launched and without any pinned memory.
+The launch commands should be skipped after receive because they should have
+already been performed on the source.
+
+Parameters (in/out): struct kvm_sev_local_receive
+
+Returns: 0 on success, -negative on error
+
+::
+
+    struct kvm_sev_local_receive {
+        __u64 info_token;    /* token referencing the staged info */
+        __u32 handle;        /* guest handle */
+    };
+
+On success, the 'handle' field contains the handle for this SEV guest.
+
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5af46ff6ec48..7c33ad2b910d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -14,6 +14,7 @@
 #include <linux/psp-sev.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/random.h>
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
@@ -57,6 +58,8 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #define sev_es_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
+#define MAX_RAND_RETRY    3
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -74,6 +77,22 @@ struct enc_region {
 	unsigned long size;
 };
 
+struct sev_info_migration_node {
+	struct hlist_node hnode;
+	u64 token;
+	bool valid;
+
+	unsigned int asid;
+	unsigned int handle;
+	unsigned long pages_locked;
+	struct list_head regions_list;
+	struct misc_cg *misc_cg;
+};
+
+#define SEV_INFO_MIGRATION_HASH_BITS    7
+static DEFINE_HASHTABLE(sev_info_migration_hash, SEV_INFO_MIGRATION_HASH_BITS);
+static DEFINE_SPINLOCK(sev_info_migration_hash_lock);
+
 /* Called with the sev_bitmap_lock held, or on shutdown  */
 static int sev_flush_asids(int min_asid, int max_asid)
 {
@@ -1094,6 +1113,185 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static struct sev_info_migration_node *find_migration_info(unsigned long token)
+{
+	struct sev_info_migration_node *entry;
+
+	hash_for_each_possible(sev_info_migration_hash, entry, hnode, token) {
+		if (entry->token == token)
+			return entry;
+	}
+
+	return NULL;
+}
+
+/*
+ * Places @entry into the |sev_info_migration_hash|. Returns 0 if successful
+ * and ownership of @entry is transferred to the hashmap.
+ */
+static int place_migration_node(struct sev_info_migration_node *entry)
+{
+	u64 token = 0;
+	unsigned int retries;
+	int ret = -EFAULT;
+
+	/*
+	 * Generate a token associated with this VM's SEV info that userspace
+	 * can use to import on the other side. We use 0 to indicate a not-
+	 * present token. The token cannot collide with other existing ones, so
+	 * reroll a few times until we get a valid token. In the unlikely event
+	 * we're having trouble generating a unique token, give up and let
+	 * userspace retry if it needs to.
+	 */
+	spin_lock(&sev_info_migration_hash_lock);
+	for (retries = 0; retries < MAX_RAND_RETRY; retries++)  {
+		get_random_bytes((void *)&token, sizeof(token));
+
+		if (find_migration_info(token))
+			continue;
+
+		entry->token = token;
+		entry->valid = true;
+
+		hash_add(sev_info_migration_hash, &entry->hnode, token);
+		ret = 0;
+		goto out;
+	}
+
+out:
+	spin_unlock(&sev_info_migration_hash_lock);
+	return ret;
+}
+
+static int sev_local_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_info_migration_node *entry;
+	struct kvm_sev_local_send params;
+	u64 token;
+	int ret = -EFAULT;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	if (sev->es_active)
+		return -EPERM;
+
+	if (sev->info_token != 0)
+		return -EEXIST;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			   sizeof(params)))
+		return -EFAULT;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	entry->asid = sev->asid;
+	entry->handle = sev->handle;
+	entry->pages_locked = sev->pages_locked;
+	entry->misc_cg = sev->misc_cg;
+
+	INIT_LIST_HEAD(&entry->regions_list);
+	list_replace_init(&sev->regions_list, &entry->regions_list);
+
+	if (place_migration_node(entry))
+		goto e_listdel;
+
+	token = entry->token;
+
+	params.info_token = token;
+	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
+			 sizeof(params)))
+		goto e_hashdel;
+
+	sev->info_token = token;
+
+	return 0;
+
+e_hashdel:
+	spin_lock(&sev_info_migration_hash_lock);
+	hash_del(&entry->hnode);
+	spin_unlock(&sev_info_migration_hash_lock);
+
+e_listdel:
+	list_replace_init(&entry->regions_list, &sev->regions_list);
+
+	kfree(entry);
+
+	return ret;
+}
+
+static int sev_local_receive(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_info_migration_node *entry;
+	struct kvm_sev_local_receive params;
+	struct kvm_sev_info old_info;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	if (sev->es_active)
+		return -EPERM;
+
+	if (sev->handle != 0)
+		return -EPERM;
+
+	if (!list_empty(&sev->regions_list))
+		return -EPERM;
+
+	if (copy_from_user(&params,
+			   (void __user *)(uintptr_t)argp->data,
+			   sizeof(params)))
+		return -EFAULT;
+
+	spin_lock(&sev_info_migration_hash_lock);
+	entry = find_migration_info(params.info_token);
+	if (!entry || !entry->valid)
+		goto err_unlock;
+
+	memcpy(&old_info, sev, sizeof(old_info));
+
+	/*
+	 * The source VM always frees @entry On the target we simply
+	 * mark the token as invalid to notify the source the sev info
+	 * has been moved successfully.
+	 */
+	entry->valid = false;
+	sev->active = true;
+	sev->asid = entry->asid;
+	sev->handle = entry->handle;
+	sev->pages_locked = entry->pages_locked;
+	sev->misc_cg = entry->misc_cg;
+
+	INIT_LIST_HEAD(&sev->regions_list);
+	list_replace_init(&entry->regions_list, &sev->regions_list);
+
+	spin_unlock(&sev_info_migration_hash_lock);
+
+	params.handle = sev->handle;
+
+	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
+			 sizeof(params)))
+		goto err_unwind;
+
+	sev_asid_free(&old_info);
+	return 0;
+
+err_unwind:
+	spin_lock(&sev_info_migration_hash_lock);
+	list_replace_init(&sev->regions_list, &entry->regions_list);
+	entry->valid = true;
+	memcpy(sev, &old_info, sizeof(*sev));
+
+err_unlock:
+	spin_unlock(&sev_info_migration_hash_lock);
+
+	return -EFAULT;
+}
+
 /* Userspace wants to query session length. */
 static int
 __sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
@@ -1513,6 +1711,18 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 		goto out;
 	}
 
+	/*
+	 * If this VM has started exporting its SEV contents to another VM,
+	 * it's not allowed to do any more SEV operations that may modify the
+	 * SEV state.
+	 */
+	if (to_kvm_svm(kvm)->sev_info.info_token &&
+	    sev_cmd.id != KVM_SEV_DBG_ENCRYPT &&
+	    sev_cmd.id != KVM_SEV_DBG_DECRYPT) {
+		r = -EPERM;
+		goto out;
+	}
+
 	switch (sev_cmd.id) {
 	case KVM_SEV_ES_INIT:
 		if (!sev_es_enabled) {
@@ -1553,6 +1763,12 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_GET_ATTESTATION_REPORT:
 		r = sev_get_attestation_report(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_LOCAL_SEND:
+		r = sev_local_send(kvm, &sev_cmd);
+		break;
+	case KVM_SEV_LOCAL_RECEIVE:
+		r = sev_local_receive(kvm, &sev_cmd);
+		break;
 	case KVM_SEV_SEND_START:
 		r = sev_send_start(kvm, &sev_cmd);
 		break;
@@ -1786,6 +2002,8 @@ static void __unregister_region_list_locked(struct kvm *kvm,
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_info_migration_node *entry = NULL;
+	bool info_migrated = false;
 
 	if (!sev_guest(kvm))
 		return;
@@ -1796,25 +2014,59 @@ void sev_vm_destroy(struct kvm *kvm)
 		return;
 	}
 
+	/*
+	 * If userspace has requested that we migrate the SEV info to a new VM,
+	 * then we own and must remove an entry node in the tracking data
+	 * structure. Whether we clean up the data in our SEV info struct and
+	 * entry node depends on whether userspace has done the migration,
+	 * which transfers ownership to a new VM. We can identify that
+	 * migration has occurred by checking if the node is marked invalid.
+	 */
+	if (sev->info_token != 0) {
+		spin_lock(&sev_info_migration_hash_lock);
+		entry = find_migration_info(sev->info_token);
+		if (entry) {
+			info_migrated = !entry->valid;
+			hash_del(&entry->hnode);
+		} else
+			WARN(1,
+			     "SEV VM was marked for export, but does not have associated export node.\n");
+		spin_unlock(&sev_info_migration_hash_lock);
+	}
+
 	mutex_lock(&kvm->lock);
 
 	/*
-	 * Ensure that all guest tagged cache entries are flushed before
-	 * releasing the pages back to the system for use. CLFLUSH will
-	 * not do this, so issue a WBINVD.
+	 * Adding memory regions after a local send has started
+	 * is dangerous.
 	 */
-	wbinvd_on_all_cpus();
+	if (sev->info_token != 0 && !list_empty(&sev->regions_list)) {
+		WARN(1,
+		     "Source SEV regions list non-empty after export request. List is not expected to be modified after export request.\n");
+		__unregister_region_list_locked(kvm, &sev->regions_list);
+	}
 
 	/*
-	 * if userspace was terminated before unregistering the memory regions
-	 * then lets unpin all the registered memory.
+	 * If userspace was terminated before unregistering the memory
+	 * regions then lets unpin all the registered memory.
 	 */
-	__unregister_region_list_locked(kvm, &sev->regions_list);
+	if (entry)
+		__unregister_region_list_locked(kvm, &entry->regions_list);
 
 	mutex_unlock(&kvm->lock);
 
-	sev_unbind_asid(kvm, sev->handle);
-	sev_asid_free(sev);
+	/*
+	 * Ensure that all guest tagged cache entries are flushed before
+	 * releasing the pages back to the system for use. CLFLUSH will
+	 * not do this, so issue a WBINVD.
+	 */
+	wbinvd_on_all_cpus();
+	if (!info_migrated) {
+		sev_unbind_asid(kvm, sev->handle);
+		sev_asid_free(sev);
+	}
+
+	kfree(entry);
 }
 
 void __init sev_set_cpu_caps(void)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 70419e417c0d..1ae8fe623c70 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -65,6 +65,7 @@ struct kvm_sev_info {
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
+	u64 info_token; /* Token for SEV info local migration */
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 79d9c44d1ad7..b317d4b2507d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1678,6 +1678,9 @@ enum sev_cmd_id {
 	KVM_SEV_GET_ATTESTATION_REPORT,
 	/* Guest Migration Extension */
 	KVM_SEV_SEND_CANCEL,
+	/* Local migration commands */
+	KVM_SEV_LOCAL_SEND,
+	KVM_SEV_LOCAL_RECEIVE,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1775,6 +1778,15 @@ struct kvm_sev_receive_update_data {
 	__u32 trans_len;
 };
 
+struct kvm_sev_local_send {
+	__u64 info_token;
+};
+
+struct kvm_sev_local_receive {
+	__u64 info_token;
+	__u32 handle;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.32.0.288.g62a8d224e6-goog

