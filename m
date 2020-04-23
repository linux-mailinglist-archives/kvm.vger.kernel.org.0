Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D744C1B621F
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 19:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbgDWRjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 13:39:10 -0400
Received: from foss.arm.com ([217.140.110.172]:44794 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730006AbgDWRjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 13:39:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F346D11B3;
        Thu, 23 Apr 2020 10:39:08 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E9A53F68F;
        Thu, 23 Apr 2020 10:39:07 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Raphael Gault <raphael.gault@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH kvmtool v4 4/5] memslot: Add support for READONLY mappings
Date:   Thu, 23 Apr 2020 18:38:43 +0100
Message-Id: <20200423173844.24220-5-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200423173844.24220-1-andre.przywara@arm.com>
References: <20200423173844.24220-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A KVM memslot has a flags field, which allows to mark a region as
read-only.
Add another memory type bit to allow kvmtool-internal users to map a
write-protected region. Write access would trap and can be handled by
the MMIO emulation, which should register on the same guest address
region.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/kvm.h | 12 ++++++++----
 kvm.c             |  5 +++++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 9428f57a..53373b08 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -40,10 +40,12 @@ enum kvm_mem_type {
 	KVM_MEM_TYPE_RAM	= 1 << 0,
 	KVM_MEM_TYPE_DEVICE	= 1 << 1,
 	KVM_MEM_TYPE_RESERVED	= 1 << 2,
+	KVM_MEM_TYPE_READONLY	= 1 << 3,
 
 	KVM_MEM_TYPE_ALL	= KVM_MEM_TYPE_RAM
 				| KVM_MEM_TYPE_DEVICE
 				| KVM_MEM_TYPE_RESERVED
+				| KVM_MEM_TYPE_READONLY
 };
 
 struct kvm_ext {
@@ -158,17 +160,19 @@ u64 host_to_guest_flat(struct kvm *kvm, void *ptr);
 bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 				 const char *kernel_cmdline);
 
+#define add_read_only(type, str)					\
+	(((type) & KVM_MEM_TYPE_READONLY) ? str " (read-only)" : str)
 static inline const char *kvm_mem_type_to_string(enum kvm_mem_type type)
 {
-	switch (type) {
+	switch (type & ~KVM_MEM_TYPE_READONLY) {
 	case KVM_MEM_TYPE_ALL:
 		return "(all)";
 	case KVM_MEM_TYPE_RAM:
-		return "RAM";
+		return add_read_only(type, "RAM");
 	case KVM_MEM_TYPE_DEVICE:
-		return "device";
+		return add_read_only(type, "device");
 	case KVM_MEM_TYPE_RESERVED:
-		return "reserved";
+		return add_read_only(type, "reserved");
 	}
 
 	return "???";
diff --git a/kvm.c b/kvm.c
index 26f6b9bc..e327541d 100644
--- a/kvm.c
+++ b/kvm.c
@@ -242,6 +242,7 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 	struct kvm_mem_bank *bank;
 	struct list_head *prev_entry;
 	u32 slot;
+	u32 flags = 0;
 	int ret;
 
 	mutex_lock(&kvm->mem_banks_lock);
@@ -313,9 +314,13 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 	bank->type			= type;
 	bank->slot			= slot;
 
+	if (type & KVM_MEM_TYPE_READONLY)
+		flags |= KVM_MEM_READONLY;
+
 	if (type != KVM_MEM_TYPE_RESERVED) {
 		mem = (struct kvm_userspace_memory_region) {
 			.slot			= slot,
+			.flags			= flags,
 			.guest_phys_addr	= guest_phys,
 			.memory_size		= size,
 			.userspace_addr		= (unsigned long)userspace_addr,
-- 
2.17.1

