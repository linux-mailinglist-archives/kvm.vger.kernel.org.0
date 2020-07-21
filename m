Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EBC228AE2
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731508AbgGUVRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:17:52 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37792 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731274AbgGUVQF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:05 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 6CB08305D7D0;
        Wed, 22 Jul 2020 00:09:19 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 4DE02303F1B1;
        Wed, 22 Jul 2020 00:09:19 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 04/84] KVM: add kvm_get_max_gfn()
Date:   Wed, 22 Jul 2020 00:08:02 +0300
Message-Id: <20200721210922.7646-5-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

This function is needed for the KVMI_VM_GET_MAX_GFN command.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 92490279d65a..a4249fc88fc2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -776,6 +776,7 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
+gfn_t kvm_get_max_gfn(struct kvm *kvm);
 
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4d965913d347..8c4bccf33c8c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1347,6 +1347,30 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 	return kvm_set_memory_region(kvm, mem);
 }
 
+gfn_t kvm_get_max_gfn(struct kvm *kvm)
+{
+	u32 skip_mask = KVM_MEM_READONLY | KVM_MEMSLOT_INVALID;
+	struct kvm_memory_slot *memslot;
+	struct kvm_memslots *slots;
+	gfn_t max_gfn = 0;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+
+	slots = kvm_memslots(kvm);
+	kvm_for_each_memslot(memslot, slots)
+		if (memslot->id < KVM_USER_MEM_SLOTS &&
+		   (memslot->flags & skip_mask) == 0)
+			max_gfn = max(max_gfn, memslot->base_gfn
+						+ memslot->npages);
+
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return max_gfn;
+}
+
 #ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 /**
  * kvm_get_dirty_log - get a snapshot of dirty pages
