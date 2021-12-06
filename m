Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF23446A61D
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 20:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348844AbhLFT6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 14:58:52 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:49762 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347815AbhLFT6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 14:58:50 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1muK4U-0000kY-Nc; Mon, 06 Dec 2021 20:54:46 +0100
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
Subject: [PATCH v7 01/29] KVM: Require total number of memslot pages to fit in an unsigned long
Date:   Mon,  6 Dec 2021 20:54:07 +0100
Message-Id: <1c2c91baf8e78acccd4dad38da591002e61c013c.1638817638.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638817637.git.maciej.szmigiero@oracle.com>
References: <cover.1638817637.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Explicitly disallow creating more memslot pages than can fit in an
unsigned long, KVM doesn't correctly handle a total number of memslot
pages that doesn't fit in an unsigned long and remedying that would be a
waste of time.

For a 64-bit kernel, this is a nop as memslots are not allowed to overlap
in the gfn address space.

With a 32-bit kernel, userspace can at most address 3gb of virtual memory,
whereas wrapping the total number of pages would require 4tb+ of guest
physical memory.  Even with x86's second address space for SMM, userspace
would need to alias all of guest memory more than one _thousand_ times.
And on older x86 hardware with MAXPHYADDR < 43, the guest couldn't
actually access any of those aliases even if userspace lied about
guest.MAXPHYADDR.

On 390 and arm64, this is a nop as they don't support 32-bit hosts.

On x86, practically speaking this is simply acknowledging reality as the
existing kvm_mmu_calculate_default_mmu_pages() assumes the total number
of pages fits in an "unsigned long".

On PPC, this is likely a nop as every flavor of PPC KVM assumes gfns (and
gpas!) fit in unsigned long.  arch/powerpc/kvm/book3s_32_mmu_host.c goes
a step further and fails the build if CONFIG_PTE_64BIT=y, which
presumably means that it does't support 64-bit physical addresses.

On MIPS, this is also likely a nop as the core MMU helpers assume gpas
fit in unsigned long, e.g. see kvm_mips_##name##_pte.

And finally, RISC-V is a "don't care" as it doesn't exist in any release,
i.e. there is no established ABI to break.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a745efe389ab..a6830966f8eb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -554,6 +554,7 @@ struct kvm {
 	 */
 	struct mutex slots_arch_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
+	unsigned long nr_memslot_pages;
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
 	struct xarray vcpu_array;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 863112783ed9..4a1b484518a9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1640,6 +1640,15 @@ static int kvm_set_memslot(struct kvm *kvm,
 	update_memslots(slots, new, change);
 	slots = install_new_memslots(kvm, as_id, slots);
 
+	/*
+	 * Update the total number of memslot pages before calling the arch
+	 * hook so that architectures can consume the result directly.
+	 */
+	if (change == KVM_MR_DELETE)
+		kvm->nr_memslot_pages -= old.npages;
+	else if (change == KVM_MR_CREATE)
+		kvm->nr_memslot_pages += new->npages;
+
 	kvm_arch_commit_memory_region(kvm, mem, &old, new, change);
 
 	/* Free the old memslot's metadata.  Note, this is the full copy!!! */
@@ -1670,6 +1679,9 @@ static int kvm_delete_memslot(struct kvm *kvm,
 	if (!old->npages)
 		return -EINVAL;
 
+	if (WARN_ON_ONCE(kvm->nr_memslot_pages < old->npages))
+		return -EIO;
+
 	memset(&new, 0, sizeof(new));
 	new.id = old->id;
 	/*
@@ -1753,6 +1765,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (!old.npages) {
 		change = KVM_MR_CREATE;
 		new.dirty_bitmap = NULL;
+
+		/*
+		 * To simplify KVM internals, the total number of pages across
+		 * all memslots must fit in an unsigned long.
+		 */
+		if ((kvm->nr_memslot_pages + new.npages) < kvm->nr_memslot_pages)
+			return -EINVAL;
 	} else { /* Modify an existing slot. */
 		if ((new.userspace_addr != old.userspace_addr) ||
 		    (new.npages != old.npages) ||
