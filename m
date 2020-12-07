Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA052D1AE8
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgLGUqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:46:53 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:41884 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726766AbgLGUqx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:46:53 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4B7FA305D4FB;
        Mon,  7 Dec 2020 22:46:12 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 26D253072785;
        Mon,  7 Dec 2020 22:46:12 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 03/81] KVM: add kvm_get_max_gfn()
Date:   Mon,  7 Dec 2020 22:45:04 +0200
Message-Id: <20201207204622.15258-4-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

This function is needed for the KVMI_VM_GET_MAX_GFN command.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1bbb07b87d1a..cd6ac3a43c9a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -807,6 +807,7 @@ bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
 void mark_page_dirty_in_slot(struct kvm *kvm, struct kvm_memory_slot *memslot, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
+gfn_t kvm_get_max_gfn(struct kvm *kvm);
 
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 069668b8afc2..e19dd6f92709 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1410,6 +1410,31 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
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
+		   (memslot->flags & skip_mask) == 0 &&
+		   memslot->npages)
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
