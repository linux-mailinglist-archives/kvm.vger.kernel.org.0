Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2109B46407E
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 22:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344358AbhK3Vq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 16:46:29 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:56206 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344462AbhK3VqV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 16:46:21 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msAtY-000610-Vz; Tue, 30 Nov 2021 22:42:37 +0100
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
Subject: [PATCH v6 09/29] KVM: s390: Use "new" memslot instead of userspace memory region
Date:   Tue, 30 Nov 2021 22:41:22 +0100
Message-Id: <89d293d50ae4ce7b4d41f1576cf1cb310f5074c3.1638304316.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638304315.git.maciej.szmigiero@oracle.com>
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Get the gfn, size, and hva from the new memslot instead of the userspace
memory region when preparing/committing memory region changes.  This will
allow a future commit to drop the @mem param.

Note, this has a subtle functional change as KVM would previously reject
DELETE if userspace provided a garbage userspace_addr or guest_phys_addr,
whereas KVM zeros those fields in the "new" memslot when deleting an
existing memslot.  Arguably the old behavior is more correct, but there's
zero benefit into requiring userspace to provide sane values for hva and
gfn.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/s390/kvm/kvm-s390.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 3d943c78a770..6947edf3da60 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5012,18 +5012,20 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
+	gpa_t size = new->npages * PAGE_SIZE;
+
 	/* A few sanity checks. We can have memory slots which have to be
 	   located/ended at a segment boundary (1MB). The memory in userland is
 	   ok to be fragmented into various different vmas. It is okay to mmap()
 	   and munmap() stuff in this slot after doing this call at any time */
 
-	if (mem->userspace_addr & 0xffffful)
+	if (new->userspace_addr & 0xffffful)
 		return -EINVAL;
 
-	if (mem->memory_size & 0xffffful)
+	if (size & 0xffffful)
 		return -EINVAL;
 
-	if (mem->guest_phys_addr + mem->memory_size > kvm->arch.mem_limit)
+	if ((new->base_gfn * PAGE_SIZE) + size > kvm->arch.mem_limit)
 		return -EINVAL;
 
 	/* When we are protected, we should not change the memory slots */
@@ -5052,8 +5054,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 			break;
 		fallthrough;
 	case KVM_MR_CREATE:
-		rc = gmap_map_segment(kvm->arch.gmap, mem->userspace_addr,
-				      mem->guest_phys_addr, mem->memory_size);
+		rc = gmap_map_segment(kvm->arch.gmap, new->userspace_addr,
+				      new->base_gfn * PAGE_SIZE,
+				      new->npages * PAGE_SIZE);
 		break;
 	case KVM_MR_FLAGS_ONLY:
 		break;
