Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456FC3C8849
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 18:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239900AbhGNQE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 12:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239774AbhGNQEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 12:04:55 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAADC06175F
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 09:02:02 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id jx12-20020a17090b46ccb029017365ced08eso3962584pjb.3
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 09:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=o+UhyrrpSySD0Vvbv+Bgevc37EIM5E5yFCx7HFtMyr4=;
        b=WoELpC0FThk4OY8ERAuPE4RcYN0BGpvxec05E4IvZGYguIvSBwOEv4PcndxQvL/xPC
         2+M5DTuDEfdR3xenIEbFz2yEXIU5II4B4WLC87iLRDeOrrATewu5Z6QhcaukwLLXzFT8
         003lEBkdNy4YPllugPQAA2i+DuMlIje+UNSGzbCUJfNVu+9lt7KbP50BCY7ey5DlZWym
         8+X/hb9wIb0OWGNSLiCP98CqPt+vA6YSncjmpP+Bo0RWwTPqd+7/YR4HhqFQT8krWR+o
         7WZLrKSJUz0Tgk+P+imTSDO8WYw2K7my4gQKeZ8ZVCwtUMRDNqpG4UE1TFzKzBkyifpP
         of+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=o+UhyrrpSySD0Vvbv+Bgevc37EIM5E5yFCx7HFtMyr4=;
        b=n0dn1yclCJTue+91W1TEVK1RFwVzY1ly3Hmfw40yxzfYy7oR0+eFFnYCe3tede7YCi
         /g4cA4A6AiXYbbfeP08+RzRoGC7oBLRTj8b4t0eGU3CBtw1kGXtduxnHSUxK0sJKV3E3
         NZYi0UIb//2Pz2xjkdjqkCa1T4ZSijF8Oiwh/1fhF1glx9HzYS35kCCgs6w9UBZMp8wL
         v0tWWJBfpdLoypE2+1lzj/Bnsf5KWzu36IiUIU3jHzW3y/8RZhZbT/34lS3GY5wi36v7
         cU9FlfyKjLJO3V9LBXkGBeVeUQje5h5+hYx7p2PMA3+Quxoqwwm1IpFxfgKPxLxb87hs
         ndgw==
X-Gm-Message-State: AOAM532LQr+eoEkOnbABLvWUyYEUCyef0NRM6AdDhndiqIkq1FCMPScE
        kgU8/Y0nVjyIsTl/jqJ2W2V2V14e1p0=
X-Google-Smtp-Source: ABdhPJz7B12hij211Qb8mx7tWr5PV5OXlYchLPqlSVLIddB76o0Uy77ZlBA5T/QxfrXPepIBo/ZDkgMmNaE=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:32d8:66d1:672:9aeb])
 (user=pgonda job=sendgmr) by 2002:a17:90a:4dca:: with SMTP id
 r10mr4355534pjl.94.1626278522069; Wed, 14 Jul 2021 09:02:02 -0700 (PDT)
Date:   Wed, 14 Jul 2021 09:01:42 -0700
In-Reply-To: <20210714160143.2116583-1-pgonda@google.com>
Message-Id: <20210714160143.2116583-3-pgonda@google.com>
Mime-Version: 1.0
References: <20210714160143.2116583-1-pgonda@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 2/3 V2] KVM, SEV: Add support for SEV intra host migration
From:   Peter Gonda <pgonda@google.com>
To:     pgonda@google.com
Cc:     Lars Bull <larsbull@google.com>, Marc Orr <marcorr@google.com>,
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
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For SEV to work with intra host migration, contents of the SEV info struct
such as the ASID (used to index the encryption key in the AMD SP) and
the list of memory regions need to be transferred to the target VM.
This change adds commands for sending and receiving the sev info.

To avoid exposing this internal state to userspace and prevent other
processes from importing state they shouldn't have access to, the send
returns a token to userspace that is handed off to the target VM. The
target passes in this token to receive the sent state. The token is only
valid for one-time use. Functionality on the source becomes limited
after send has been performed. If the source is destroyed before the
target has received, the token becomes invalid.

The target is expected to be initialized (sev_guest_init), but not
launched state (sev_launch_start) when performing receive. Once the
target has received, it will be in a launched state and will not
need to perform the typical SEV launch commands.

Co-developed-by: Lars Bull <larsbull@google.com>
Signed-off-by: Lars Bull <larsbull@google.com>
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
 .../virt/kvm/amd-memory-encryption.rst        |  43 +++
 arch/x86/kvm/svm/sev.c                        | 248 +++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 include/uapi/linux/kvm.h                      |  12 +
 4 files changed, 294 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 5c081c8c7164..eac5d6e2ef11 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -427,6 +427,49 @@ issued by the hypervisor to make the guest ready for execution.
 
 Returns: 0 on success, -negative on error
 
+10. KVM_SEV_INTRA_HOST_SEND
+----------------------------------
+
+The KVM_SEV_INTRA_HOST_SEND command is used to stage the VM's SEV info
+for the purposes of migrating memory to a new local VM while using the same SEV
+key. If the source VM is destroyed before the staged info has been received by
+the target, the info is lost. Once the info has been staged, only commands
+KVM_SEV_DBG_DECRYPT, and KVM_SEV_DBG_ENCRYPT
+can be used by the source.
+
+Parameters (in): struct kvm_sev_intra_host_send
+
+Returns: 0 on success, -negative on error
+
+::
+
+    struct kvm_sev_intra_host_send {
+        __u64 info_token;    /* token referencing the staged info */
+    };
+
+11. KVM_SEV_INTRA_HOST_RECEIVE
+-------------------------------------
+
+The KVM_SEV_INTRA_HOST_RECEIVE command is used to transfer staged SEV
+info to a target VM from some source VM. SEV on the target VM should be active
+when receive is performed, but not yet launched and without any pinned memory.
+The launch commands should be skipped after receive because they should have
+already been performed on the source.
+
+Parameters (in/out): struct kvm_sev_intra_host_receive
+
+Returns: 0 on success, -negative on error
+
+::
+
+    struct kvm_sev_intra_host_receive {
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
index 78fea9c4048d..03b5e690ca56 100644
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
@@ -1104,6 +1123,160 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
+	int ret = -EFAULT;
+
+	spin_lock(&sev_info_migration_hash_lock);
+	if (find_migration_info(entry->token))
+		goto out;
+
+	entry->valid = true;
+
+	hash_add(sev_info_migration_hash, &entry->hnode, entry->token);
+	ret = 0;
+
+out:
+	spin_unlock(&sev_info_migration_hash_lock);
+	return ret;
+}
+
+static int sev_intra_host_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_info_migration_node *entry;
+	struct kvm_sev_intra_host_send params;
+	int ret = -EFAULT;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	if (sev->es_active)
+		return -EPERM;
+
+	if (sev->handle == 0)
+		return -EPERM;
+
+	if (sev->info_token != 0)
+		return -EEXIST;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			   sizeof(params)))
+		return -EFAULT;
+
+	if (params.info_token == 0)
+		return -EINVAL;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	entry->asid = sev->asid;
+	entry->handle = sev->handle;
+	entry->pages_locked = sev->pages_locked;
+	entry->misc_cg = sev->misc_cg;
+	entry->token = params.info_token;
+
+	INIT_LIST_HEAD(&entry->regions_list);
+	list_replace_init(&sev->regions_list, &entry->regions_list);
+
+	if (place_migration_node(entry))
+		goto e_listdel;
+
+	sev->info_token = entry->token;
+
+	return 0;
+
+e_listdel:
+	list_replace_init(&entry->regions_list, &sev->regions_list);
+
+	kfree(entry);
+
+	return ret;
+}
+
+static int sev_intra_host_receive(struct kvm *kvm,
+					struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_info_migration_node *entry;
+	struct kvm_sev_intra_host_receive params;
+	struct kvm_sev_info old_info;
+	void __user *user_param = (void __user *)(uintptr_t)argp->data;
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
+	if (copy_from_user(&params, user_param, sizeof(params)))
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
+	if (copy_to_user(user_param, &params, sizeof(params))) {
+		list_replace_init(&sev->regions_list, &entry->regions_list);
+		entry->valid = true;
+		memcpy(sev, &old_info, sizeof(*sev));
+		return -EFAULT;
+	}
+
+	sev_asid_free(&old_info);
+	return 0;
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
@@ -1499,6 +1672,19 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, &data, &argp->error);
 }
 
+static bool is_intra_host_mig_active(struct kvm *kvm)
+{
+	return !!to_kvm_svm(kvm)->sev_info.info_token;
+}
+
+static bool cmd_allowed_during_intra_host_mig(u32 cmd_id)
+{
+	if (cmd_id == KVM_SEV_DBG_ENCRYPT || cmd_id == KVM_SEV_DBG_DECRYPT)
+		return true;
+
+	return false;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1521,6 +1707,17 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 		goto out;
 	}
 
+	/*
+	 * If this VM has started exporting its SEV contents to another VM,
+	 * it's not allowed to do any more SEV operations that may modify the
+	 * SEV state.
+	 */
+	if (is_intra_host_mig_active(kvm) &&
+	    !cmd_allowed_during_intra_host_mig(sev_cmd.id)) {
+		r = -EPERM;
+		goto out;
+	}
+
 	switch (sev_cmd.id) {
 	case KVM_SEV_ES_INIT:
 		if (!sev_es_enabled) {
@@ -1561,6 +1758,12 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_GET_ATTESTATION_REPORT:
 		r = sev_get_attestation_report(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_INTRA_HOST_SEND:
+		r = sev_intra_host_send(kvm, &sev_cmd);
+		break;
+	case KVM_SEV_INTRA_HOST_RECEIVE:
+		r = sev_intra_host_receive(kvm, &sev_cmd);
+		break;
 	case KVM_SEV_SEND_START:
 		r = sev_send_start(kvm, &sev_cmd);
 		break;
@@ -1794,6 +1997,7 @@ static void unregister_enc_regions(struct kvm *kvm,
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_info_migration_node *mig_entry;
 
 	if (!sev_guest(kvm))
 		return;
@@ -1804,25 +2008,49 @@ void sev_vm_destroy(struct kvm *kvm)
 		return;
 	}
 
-	mutex_lock(&kvm->lock);
-
 	/*
-	 * Ensure that all guest tagged cache entries are flushed before
-	 * releasing the pages back to the system for use. CLFLUSH will
-	 * not do this, so issue a WBINVD.
+	 * If userspace has requested that we migrate the SEV info to a new VM,
+	 * then we own and must remove an entry node in the tracking data
+	 * structure. Whether we clean up the data in our SEV info struct and
+	 * entry node depends on whether userspace has done the migration,
+	 * which transfers ownership to a new VM. We can identify that
+	 * migration has occurred by checking if the node is marked invalid.
 	 */
-	wbinvd_on_all_cpus();
+	if (sev->info_token != 0) {
+		spin_lock(&sev_info_migration_hash_lock);
+		mig_entry = find_migration_info(sev->info_token);
+		if (!WARN_ON(!mig_entry))
+			hash_del(&mig_entry->hnode);
+		spin_unlock(&sev_info_migration_hash_lock);
+	} else
+		mig_entry = NULL;
+
+	mutex_lock(&kvm->lock);
 
 	/*
-	 * if userspace was terminated before unregistering the memory regions
-	 * then lets unpin all the registered memory.
+	 * Adding memory regions after a intra host send has started
+	 * is dangerous.
 	 */
+	WARN_ON(sev->info_token && !list_empty(&sev->regions_list));
 	unregister_enc_regions(kvm, &sev->regions_list);
 
+	if (mig_entry)
+		unregister_enc_regions(kvm, &mig_entry->regions_list);
+
 	mutex_unlock(&kvm->lock);
 
-	sev_unbind_asid(kvm, sev->handle);
-	sev_asid_free(sev);
+	/*
+	 * Ensure that all guest tagged cache entries are flushed before
+	 * releasing the pages back to the system for use. CLFLUSH will
+	 * not do this, so issue a WBINVD.
+	 */
+	wbinvd_on_all_cpus();
+	if (!mig_entry || !mig_entry->valid) {
+		sev_unbind_asid(kvm, sev->handle);
+		sev_asid_free(sev);
+	}
+
+	kfree(mig_entry);
 }
 
 void __init sev_set_cpu_caps(void)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f89b623bb591..559ce44682a8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -79,6 +79,7 @@ struct kvm_sev_info {
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
+	u64 info_token; /* Token for SEV info intra host migration */
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 68c9e6d8bbda..01a42a7134af 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1709,6 +1709,9 @@ enum sev_cmd_id {
 	KVM_SEV_GET_ATTESTATION_REPORT,
 	/* Guest Migration Extension */
 	KVM_SEV_SEND_CANCEL,
+	/* Intra host migration commands */
+	KVM_SEV_INTRA_HOST_SEND,
+	KVM_SEV_INTRA_HOST_RECEIVE,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1806,6 +1809,15 @@ struct kvm_sev_receive_update_data {
 	__u32 trans_len;
 };
 
+struct kvm_sev_intra_host_send {
+	__u64 info_token;
+};
+
+struct kvm_sev_intra_host_receive {
+	__u64 info_token;
+	__u32 handle;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.32.0.93.g670b81a890-goog

