Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC23D155DD4
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgBGSSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:18:48 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40612 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726951AbgBGSQm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:42 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id BD006305D48D;
        Fri,  7 Feb 2020 20:16:38 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 81CBE3052068;
        Fri,  7 Feb 2020 20:16:38 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 05/78] KVM: add kvm_get_max_gfn()
Date:   Fri,  7 Feb 2020 20:15:23 +0200
Message-Id: <20200207181636.1065-6-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
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
 virt/kvm/kvm_main.c      | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2fb276655cc2..e826e874b998 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -769,6 +769,7 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
+gfn_t kvm_get_max_gfn(struct kvm *kvm);
 
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ab66d5a08581..20ffc86fd8d1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1178,6 +1178,29 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 	return kvm_set_memory_region(kvm, mem);
 }
 
+gfn_t kvm_get_max_gfn(struct kvm *kvm)
+{
+	struct kvm_memory_slot *memslot;
+	struct kvm_memslots *slots;
+	gfn_t max_gfn = 0;
+	int i, idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(memslot, slots)
+			max_gfn = max(max_gfn, memslot->base_gfn
+						+ memslot->npages);
+	}
+
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return max_gfn;
+}
+
 int kvm_get_dirty_log(struct kvm *kvm,
 			struct kvm_dirty_log *log, int *is_dirty)
 {
