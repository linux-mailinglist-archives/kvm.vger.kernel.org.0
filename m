Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A994730EC0
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 07:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjFOFoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 01:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjFOFoN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 01:44:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F01D10E9
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 22:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686807807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fTVBhd2O8vf77jTBRd3Tg3ob9ZgPUk+x+oUF3261NzI=;
        b=GYfAFFHgljXlDRjMfaZcUJGYIJS5P1ifoy0FNyZE483i2QXHoR5LIvRuLE/pzauLVJWRnw
        d9Hj/GW+gUYOGYUBjoJJHXT2MB6QP/Im5B24Wlzp3TmywElOXIPqA+Z2JkhKc6xlfYHchO
        CfX4uDyrRKVyGAth9c9ccft0agLGO1E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-sfMH6exIOPqEjtPgaFe5EA-1; Thu, 15 Jun 2023 01:43:16 -0400
X-MC-Unique: sfMH6exIOPqEjtPgaFe5EA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 337541C0726C;
        Thu, 15 Jun 2023 05:43:16 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-145.bne.redhat.com [10.64.54.145])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EB9A32166B25;
        Thu, 15 Jun 2023 05:43:10 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, mtosatti@redhat.com,
        maz@kernel.org, will@kernel.org, c.dall@virtualopensystems.com,
        peterx@redhat.com, david@redhat.com, aarcange@redhat.com,
        shahuang@redhat.com, hshuai@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com
Subject: [PATCH v3] KVM: Avoid illegal stage2 mapping on invalid memory slot
Date:   Thu, 15 Jun 2023 15:42:59 +1000
Message-Id: <20230615054259.14911-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We run into guest hang in edk2 firmware when KSM is kept as running on
the host. The edk2 firmware is waiting for status 0x80 from QEMU's pflash
device (TYPE_PFLASH_CFI01) during the operation of sector erasing or
buffered write. The status is returned by reading the memory region of
the pflash device and the read request should have been forwarded to QEMU
and emulated by it. Unfortunately, the read request is covered by an
illegal stage2 mapping when the guest hang issue occurs. The read request
is completed with QEMU bypassed and wrong status is fetched. The edk2
firmware runs into an infinite loop with the wrong status.

The illegal stage2 mapping is populated due to same page sharing by KSM
at (C) even the associated memory slot has been marked as invalid at (B)
when the memory slot is requested to be deleted. It's notable that the
active and inactive memory slots can't be swapped when we're in the middle
of kvm_mmu_notifier_change_pte() because kvm->mn_active_invalidate_count
is elevated, and kvm_swap_active_memslots() will busy loop until it reaches
to zero again. Besides, the swapping from the active to the inactive memory
slots is also avoided by holding &kvm->srcu in __kvm_handle_hva_range(),
corresponding to synchronize_srcu_expedited() in kvm_swap_active_memslots().

  CPU-A                    CPU-B
  -----                    -----
                           ioctl(kvm_fd, KVM_SET_USER_MEMORY_REGION)
                           kvm_vm_ioctl_set_memory_region
                           kvm_set_memory_region
                           __kvm_set_memory_region
                           kvm_set_memslot(kvm, old, NULL, KVM_MR_DELETE)
                             kvm_invalidate_memslot
                               kvm_copy_memslot
                               kvm_replace_memslot
                               kvm_swap_active_memslots        (A)
                               kvm_arch_flush_shadow_memslot   (B)
  same page sharing by KSM
  kvm_mmu_notifier_invalidate_range_start
        :
  kvm_mmu_notifier_change_pte
    kvm_handle_hva_range
    __kvm_handle_hva_range
    kvm_set_spte_gfn            (C)
        :
  kvm_mmu_notifier_invalidate_range_end

Fix the issue by skipping the invalid memory slot at (C) to avoid the
illegal stage2 mapping so that the read request for the pflash's status
is forwarded to QEMU and emulated by it. In this way, the correct pflash's
status can be returned from QEMU to break the infinite loop in the edk2
firmware.

We tried a git-bisect and the first problematic commit is cd4c71835228 ("
KVM: arm64: Convert to the gfn-based MMU notifier callbacks"). With this,
clean_dcache_guest_page() is called after the memory slots are iterated
in kvm_mmu_notifier_change_pte(). clean_dcache_guest_page() is called
before the iteration on the memory slots before this commit. This change
literally enlarges the racy window between kvm_mmu_notifier_change_pte()
and memory slot removal so that we're able to reproduce the issue in a
practical test case. However, the issue exists since commit d5d8184d35c9
("KVM: ARM: Memory virtualization setup").

Cc: stable@vger.kernel.org # v3.9+
Fixes: d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
Reported-by: Shuai Hu <hshuai@redhat.com>
Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
v3: Skip the invalid memory slots in change_pte() MMU notifier only,
    suggested by Sean. Improved changelog to describe how the fixes
    tag is given.
---
 virt/kvm/kvm_main.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 479802a892d4..65f94f592ff8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -686,6 +686,24 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 
 	return __kvm_handle_hva_range(kvm, &range);
 }
+
+static bool kvm_change_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	/*
+	 * Skipping invalid memslots is correct if and only change_pte() is
+	 * surrounded by invalidate_range_{start,end}(), which is currently
+	 * guaranteed by the primary MMU.  If that ever changes, KVM needs to
+	 * unmap the memslot instead of skipping the memslot to ensure that KVM
+	 * doesn't hold references to the old PFN.
+	 */
+	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
+
+	if (range->slot->flags & KVM_MEMSLOT_INVALID)
+		return false;
+
+	return kvm_set_spte_gfn(kvm, range);
+}
+
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 					struct mm_struct *mm,
 					unsigned long address,
@@ -707,7 +725,7 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	if (!READ_ONCE(kvm->mmu_invalidate_in_progress))
 		return;
 
-	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
+	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_change_spte_gfn);
 }
 
 void kvm_mmu_invalidate_begin(struct kvm *kvm, unsigned long start,
-- 
2.40.1

