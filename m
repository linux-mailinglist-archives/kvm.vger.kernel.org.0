Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E1846A653
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 20:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349512AbhLFUA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 15:00:58 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:50562 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349363AbhLFUAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 15:00:47 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1muK6Y-00011O-Oy; Mon, 06 Dec 2021 20:56:54 +0100
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
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 25/29] KVM: Call kvm_arch_flush_shadow_memslot() on the old slot in kvm_invalidate_memslot()
Date:   Mon,  6 Dec 2021 20:54:31 +0100
Message-Id: <813595ecc193d6ae39a87709899d4251523b05f8.1638817641.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638817637.git.maciej.szmigiero@oracle.com>
References: <cover.1638817637.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

kvm_invalidate_memslot() calls kvm_arch_flush_shadow_memslot() on the
active, but KVM_MEMSLOT_INVALID slot.
Do it on the inactive (but valid) old slot instead since arch code really
should not get passed such invalid slot.

Note that this means that the "arch" field of the slot provided to
kvm_arch_flush_shadow_memslot() may have stale data since this function
is called with slots_arch_lock released.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c57748ee41e8..086f18969bc3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1632,7 +1632,7 @@ static void kvm_invalidate_memslot(struct kvm *kvm,
 	 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
 	 *	- kvm_is_visible_gfn (mmu_check_root)
 	 */
-	kvm_arch_flush_shadow_memslot(kvm, working_slot);
+	kvm_arch_flush_shadow_memslot(kvm, old);
 
 	/* Was released by kvm_swap_active_memslots, reacquire. */
 	mutex_lock(&kvm->slots_arch_lock);
