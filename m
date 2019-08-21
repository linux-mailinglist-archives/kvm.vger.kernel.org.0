Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C92697EFD
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 17:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbfHUPha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 11:37:30 -0400
Received: from foss.arm.com ([217.140.110.172]:60436 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730157AbfHUPh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 11:37:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00745337;
        Wed, 21 Aug 2019 08:37:27 -0700 (PDT)
Received: from e112269-lin.arm.com (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F26D63F718;
        Wed, 21 Aug 2019 08:37:24 -0700 (PDT)
From:   Steven Price <steven.price@arm.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 06/10] KVM: Allow kvm_device_ops to be const
Date:   Wed, 21 Aug 2019 16:36:52 +0100
Message-Id: <20190821153656.33429-7-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190821153656.33429-1-steven.price@arm.com>
References: <20190821153656.33429-1-steven.price@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently a kvm_device_ops structure cannot be const without triggering
compiler warnings. However the structure doesn't need to be written to
and, by marking it const, it can be read-only in memory. Add some more
const keywords to allow this.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 include/linux/kvm_host.h | 4 ++--
 virt/kvm/kvm_main.c      | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e154a1897e20..c5c1a923f21b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1262,7 +1262,7 @@ extern unsigned int halt_poll_ns_grow_start;
 extern unsigned int halt_poll_ns_shrink;
 
 struct kvm_device {
-	struct kvm_device_ops *ops;
+	const struct kvm_device_ops *ops;
 	struct kvm *kvm;
 	void *private;
 	struct list_head vm_node;
@@ -1315,7 +1315,7 @@ struct kvm_device_ops {
 void kvm_device_get(struct kvm_device *dev);
 void kvm_device_put(struct kvm_device *dev);
 struct kvm_device *kvm_device_from_filp(struct file *filp);
-int kvm_register_device_ops(struct kvm_device_ops *ops, u32 type);
+int kvm_register_device_ops(const struct kvm_device_ops *ops, u32 type);
 void kvm_unregister_device_ops(u32 type);
 
 extern struct kvm_device_ops kvm_mpic_ops;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c6a91b044d8d..75488ebb87c9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3046,14 +3046,14 @@ struct kvm_device *kvm_device_from_filp(struct file *filp)
 	return filp->private_data;
 }
 
-static struct kvm_device_ops *kvm_device_ops_table[KVM_DEV_TYPE_MAX] = {
+static const struct kvm_device_ops *kvm_device_ops_table[KVM_DEV_TYPE_MAX] = {
 #ifdef CONFIG_KVM_MPIC
 	[KVM_DEV_TYPE_FSL_MPIC_20]	= &kvm_mpic_ops,
 	[KVM_DEV_TYPE_FSL_MPIC_42]	= &kvm_mpic_ops,
 #endif
 };
 
-int kvm_register_device_ops(struct kvm_device_ops *ops, u32 type)
+int kvm_register_device_ops(const struct kvm_device_ops *ops, u32 type)
 {
 	if (type >= ARRAY_SIZE(kvm_device_ops_table))
 		return -ENOSPC;
@@ -3074,7 +3074,7 @@ void kvm_unregister_device_ops(u32 type)
 static int kvm_ioctl_create_device(struct kvm *kvm,
 				   struct kvm_create_device *cd)
 {
-	struct kvm_device_ops *ops = NULL;
+	const struct kvm_device_ops *ops = NULL;
 	struct kvm_device *dev;
 	bool test = cd->flags & KVM_CREATE_DEVICE_TEST;
 	int type;
-- 
2.20.1

