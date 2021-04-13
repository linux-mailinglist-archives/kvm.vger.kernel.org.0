Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBFF35E1A7
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 16:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343970AbhDMOex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 10:34:53 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:49800 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346543AbhDMOec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 10:34:32 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1lWJkc-0003zn-HB; Tue, 13 Apr 2021 16:10:46 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
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
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/8] KVM: s390: Introduce kvm_s390_get_gfn_end()
Date:   Tue, 13 Apr 2021 16:10:11 +0200
Message-Id: <f21f0456741049af31fb4620cc1a56865c287cae.1618322004.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1618322001.git.maciej.szmigiero@oracle.com>
References: <cover.1618322001.git.maciej.szmigiero@oracle.com>
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
---
 arch/s390/kvm/kvm-s390.c |  2 +-
 arch/s390/kvm/kvm-s390.h | 12 ++++++++++++
 arch/s390/kvm/pv.c       |  4 +---
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 62491ec003d8..4445c99eb00e 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1977,7 +1977,7 @@ static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 	if (!ms)
 		return 0;
 	next_gfn = kvm_s390_next_dirty_cmma(slots, cur_gfn + 1);
-	mem_end = slots->memslots[0].base_gfn + slots->memslots[0].npages;
+	mem_end = kvm_s390_get_gfn_end(slots);
 
 	while (args->count < bufsize) {
 		hva = gfn_to_hva(kvm, cur_gfn);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 79dcd647b378..96537370ce8c 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -208,6 +208,18 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
 	return kvm->arch.user_cpu_state_ctrl != 0;
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
index 813b6e93dc83..6bf42cdf4013 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -117,7 +117,6 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	unsigned long base = uv_info.guest_base_stor_len;
 	unsigned long virt = uv_info.guest_virt_var_stor_len;
 	unsigned long npages = 0, vlen = 0;
-	struct kvm_memory_slot *memslot;
 
 	kvm->arch.pv.stor_var = NULL;
 	kvm->arch.pv.stor_base = __get_free_pages(GFP_KERNEL_ACCOUNT, get_order(base));
@@ -131,8 +130,7 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	 * Slots are sorted by GFN
 	 */
 	mutex_lock(&kvm->slots_lock);
-	memslot = kvm_memslots(kvm)->memslots;
-	npages = memslot->base_gfn + memslot->npages;
+	npages = kvm_s390_get_gfn_end(kvm_memslots(kvm));
 	mutex_unlock(&kvm->slots_lock);
 
 	kvm->arch.pv.guest_len = npages * PAGE_SIZE;
