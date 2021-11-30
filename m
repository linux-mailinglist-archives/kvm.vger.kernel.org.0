Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D874640AF
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 22:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344343AbhK3Vva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 16:51:30 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:56776 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232408AbhK3Vrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 16:47:41 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msAul-0006CO-HW; Tue, 30 Nov 2021 22:43:51 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 23/29] KVM: s390: Introduce kvm_s390_get_gfn_end()
Date:   Tue, 30 Nov 2021 22:41:36 +0100
Message-Id: <1798bf5732e03613d1056b9c48ef7a6cd5b451cb.1638304316.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638304315.git.maciej.szmigiero@oracle.com>
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

And use it where s390 code would just access the memslot with the highest
gfn directly.

No functional change intended.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/kvm-s390.c |  2 +-
 arch/s390/kvm/kvm-s390.h | 12 ++++++++++++
 arch/s390/kvm/pv.c       |  4 +---
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b0fa2592b4ef..5054fab23226 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2014,7 +2014,7 @@ static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 	if (!ms)
 		return 0;
 	next_gfn = kvm_s390_next_dirty_cmma(slots, cur_gfn + 1);
-	mem_end = slots->memslots[0].base_gfn + slots->memslots[0].npages;
+	mem_end = kvm_s390_get_gfn_end(slots);
 
 	while (args->count < bufsize) {
 		hva = gfn_to_hva(kvm, cur_gfn);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index b887fe7a7064..cc309cc37e96 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -217,6 +217,18 @@ static inline void kvm_s390_set_user_cpu_state_ctrl(struct kvm *kvm)
 	kvm->arch.user_cpu_state_ctrl = 1;
 }
 
+/* get the end gfn of the last (highest gfn) memslot */
+static inline unsigned long kvm_s390_get_gfn_end(struct kvm_memslots *slots)
+{
+	struct kvm_memory_slot *ms;
+
+	if (WARN_ON(!slots->used_slots))
+		return 0;
+
+	ms = slots->memslots;
+	return ms->base_gfn + ms->npages;
+}
+
 /* implemented in pv.c */
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
 int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 00d272d134c2..7f7c0d6af2ce 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -116,7 +116,6 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	unsigned long base = uv_info.guest_base_stor_len;
 	unsigned long virt = uv_info.guest_virt_var_stor_len;
 	unsigned long npages = 0, vlen = 0;
-	struct kvm_memory_slot *memslot;
 
 	kvm->arch.pv.stor_var = NULL;
 	kvm->arch.pv.stor_base = __get_free_pages(GFP_KERNEL_ACCOUNT, get_order(base));
@@ -130,8 +129,7 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	 * Slots are sorted by GFN
 	 */
 	mutex_lock(&kvm->slots_lock);
-	memslot = kvm_memslots(kvm)->memslots;
-	npages = memslot->base_gfn + memslot->npages;
+	npages = kvm_s390_get_gfn_end(kvm_memslots(kvm));
 	mutex_unlock(&kvm->slots_lock);
 
 	kvm->arch.pv.guest_len = npages * PAGE_SIZE;
