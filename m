Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03F1C13C36D
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 14:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgAONnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 08:43:31 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:54164 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgAONnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 08:43:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1579095811; x=1610631811;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=zLtXP9u67moYJgI0kcRDzsrw+pUFCjECk3TMYA8PO7Q=;
  b=hdVqDXtuC9YqOT8TFrnnXzqIu4r8A7/JXVpmr6zJJCZSeCt/CmVift5k
   JKbKuFgGtc/BLGyzxbt7/SMviAfQmDln4QQeiFFghz1+uUQr5rWoOlEvG
   DQsLtxAVdW1VW0Fs/2soa+XGtvQXEMgZJmmjelw/UCGQ4Ud3P9Onb9o29
   o=;
IronPort-SDR: idFNB6zKcAox6Oguln3DkRDqPh+AyPXgyvXqArUndaAF9gd1pjj2DpyrfaMGXpKmvtdwi6h2uq
 M/Oitf6lnuWA==
X-IronPort-AV: E=Sophos;i="5.70,322,1574121600"; 
   d="scan'208";a="18876712"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 15 Jan 2020 13:43:19 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 8C758A2BB4;
        Wed, 15 Jan 2020 13:43:17 +0000 (UTC)
Received: from EX13D27EUB004.ant.amazon.com (10.43.166.152) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 15 Jan 2020 13:43:16 +0000
Received: from uc3ce012741425f.ant.amazon.com (10.43.161.253) by
 EX13D27EUB004.ant.amazon.com (10.43.166.152) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 15 Jan 2020 13:43:13 +0000
From:   Milan Pandurov <milanpa@amazon.de>
To:     <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <graf@amazon.de>,
        <borntraeger@de.ibm.com>
Subject: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
Date:   Wed, 15 Jan 2020 14:43:03 +0100
Message-ID: <20200115134303.30668-1-milanpa@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D06UWA001.ant.amazon.com (10.43.160.220) To
 EX13D27EUB004.ant.amazon.com (10.43.166.152)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM exposes debug counters through individual debugfs files.
Monitoring these counters requires debugfs to be enabled/accessible for
the application, which might not be always the case.
Additionally, periodic monitoring multiple debugfs files from
userspace requires multiple file open/read/close + atoi conversion
operations, which is not very efficient.

Let's expose new interface to userspace for garhering these
statistics with one ioctl.

Two new ioctl methods are added:
 - KVM_GET_SUPPORTED_DEBUGFS_STAT : Returns list of available counter
 names. Names correspond to the debugfs file names
 - KVM_GET_DEBUGFS_VALUES : Returns list of u64 values each
 corresponding to a value described in KVM_GET_SUPPORTED_DEBUGFS_STAT.

Userspace application can read counter description once using
KVM_GET_SUPPORTED_DEBUGFS_STAT and periodically invoke the
KVM_GET_DEBUGFS_VALUES to get value update.

Signed-off-by: Milan Pandurov <milanpa@amazon.de>

---
Current approach returns all available counters to userspace which might
be an overkill. This can be further extended with an interface in which
userspace provides indicies of counters it is interested in counters
will be filled accordingly.

NOTE: This patch is placed on top of:
https://www.spinics.net/lists/kvm/msg202599.html
---
 include/uapi/linux/kvm.h | 21 ++++++++++++
 virt/kvm/kvm_main.c      | 70 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f0a16b4adbbd..07ad35ddc14f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1473,6 +1473,27 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
 
+#define KVM_DBG_DESCR_NAME_MAX_SIZE 30
+struct kvm_debugfs_entry_description {
+	char name[KVM_DBG_DESCR_NAME_MAX_SIZE + 1];
+};
+
+struct kvm_debugfs_entries_description {
+	__u32 nentries;
+	struct kvm_debugfs_entry_description entry[0];
+};
+
+struct kvm_debug_stats {
+	__u32 nentries;
+	__u64 values[0];
+};
+
+/* Get description of available debugfs counters */
+#define KVM_GET_SUPPORTED_DEBUGFS_STATS                                        \
+	_IOWR(KVMIO, 0xc2, struct kvm_debugfs_entries_description)
+/* Get values from debugfs */
+#define KVM_GET_DEBUGFS_VALUES _IOWR(KVMIO, 0xc3, struct kvm_debug_stats)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9eb6e081da3a..66b36b7e347e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -146,6 +146,10 @@ static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
 static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
 
+static long kvm_get_debugfs_entry_description(struct kvm *kvm,
+					      void __user *argp);
+static long kvm_get_debugfs_values(struct kvm *kvm, void __user *argp);
+
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
@@ -3452,6 +3456,12 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_CHECK_EXTENSION:
 		r = kvm_vm_ioctl_check_extension_generic(kvm, arg);
 		break;
+	case KVM_GET_SUPPORTED_DEBUGFS_STATS:
+		r = kvm_get_debugfs_entry_description(kvm, argp);
+		break;
+	case KVM_GET_DEBUGFS_VALUES:
+		r = kvm_get_debugfs_values(kvm, argp);
+		break;
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}
@@ -4202,6 +4212,66 @@ static const struct file_operations *stat_fops[] = {
 	[KVM_STAT_VM]   = &vm_stat_fops,
 };
 
+static long kvm_get_debugfs_entry_description(struct kvm *kvm,
+					      void __user *argp)
+{
+	struct kvm_debugfs_entries_description *description = argp;
+	struct kvm_stats_debugfs_item *dbgfs_item = debugfs_entries;
+	bool should_copy = true;
+	size_t name_length = 0;
+	__u32 i = 0;
+
+	for (; dbgfs_item->name != NULL; dbgfs_item++, i++) {
+		if (i >= description->nentries)
+			should_copy = false;
+
+		if (should_copy) {
+			name_length = strlen(dbgfs_item->name);
+			name_length =
+				(name_length > KVM_DBG_DESCR_NAME_MAX_SIZE) ?
+					KVM_DBG_DESCR_NAME_MAX_SIZE :
+					name_length;
+
+			copy_to_user(description->entry[i].name,
+				     dbgfs_item->name, name_length);
+			put_user('\0',
+				 description->entry[i].name + name_length);
+		}
+	}
+	put_user(i, &description->nentries);
+	return (should_copy) ? 0 : -ENOMEM;
+}
+
+static long kvm_get_debugfs_values(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_debug_stats *stats = argp;
+	struct kvm_stats_debugfs_item *dbgfs_item = debugfs_entries;
+	bool should_copy = true;
+	__u32 i = 0;
+	__u64 tmp = 0;
+
+	for (; dbgfs_item->name != NULL; dbgfs_item++, i++) {
+		if (i >= stats->nentries)
+			should_copy = false;
+
+		if (should_copy) {
+			switch (dbgfs_item->kind) {
+			case KVM_STAT_VM:
+				kvm_get_stat_per_vm(kvm, dbgfs_item->offset,
+						    &tmp);
+				break;
+			case KVM_STAT_VCPU:
+				kvm_get_stat_per_vcpu(kvm, dbgfs_item->offset,
+						      &tmp);
+				break;
+			}
+			put_user(tmp, stats->values + i);
+		}
+	}
+	put_user(i, &stats->nentries);
+	return (should_copy) ? 0 : -ENOMEM;
+}
+
 static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 {
 	struct kobj_uevent_env *env;
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



