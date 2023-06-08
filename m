Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32DC0727AC6
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 11:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbjFHJFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 05:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235760AbjFHJE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 05:04:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921AF10EA
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 02:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686215049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dagrqDiq3A7dkc7gq9vL9zi12EhyXb6jT5d9cSUCfXk=;
        b=WrcqJyWAIrlTwT1sirJjucATkzRCXMJXZtdZUBieTiaohhX+reXVcrGfvdWXTays5JkI+A
        lxuNt8bggBQYI5OslIALaZgUiQgP4DEWc8Ng9rSotBdlNRqnpnI6rHK45UCYu2bjMa5iVc
        TR3RLY4O2UGWNuzSAqS9fCJeUKnipxA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-uYlwIiBtPiGpmZWNBjNLZA-1; Thu, 08 Jun 2023 05:04:06 -0400
X-MC-Unique: uYlwIiBtPiGpmZWNBjNLZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 079FF185A78E;
        Thu,  8 Jun 2023 09:04:06 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-168.bne.redhat.com [10.64.54.168])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C3DC40D1B66;
        Thu,  8 Jun 2023 09:04:02 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, oliver.upton@linux.dev,
        maz@kernel.org, hshuai@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com
Subject: [PATCH] KVM: Avoid illegal stage2 mapping on invalid memory slot
Date:   Thu,  8 Jun 2023 19:03:48 +1000
Message-Id: <20230608090348.414990-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We run into guest hang in edk2 firmware when KSM is kept as running
on the host. The edk2 firmware is waiting for status 0x80 from QEMU's
pflash device (TYPE_PFLASH_CFI01) during the operation for sector
erasing or buffered write. The status is returned by reading the
memory region of the pflash device and the read request should
have been forwarded to QEMU and emulated by it. Unfortunately, the
read request is covered by an illegal stage2 mapping when the guest
hang issue occurs. The read request is completed with QEMU bypassed and
wrong status is fetched.

The illegal stage2 mapping is populated due to same page mering by
KSM at (C) even the associated memory slot has been marked as invalid
at (B).

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
  same page merging by KSM
  kvm_mmu_notifier_change_pte
  kvm_handle_hva_range
  __kvm_handle_hva_range       (C)

Fix the issue by skipping the invalid memory slot at (C) to avoid the
illegal stage2 mapping. Without the illegal stage2 mapping, the read
request for the pflash's status is forwarded to QEMU and emulated by
it. The correct pflash's status can be returned from QEMU to break
the infinite wait in edk2 firmware.

Cc: stable@vger.kernel.org # v5.13+
Fixes: 3039bcc74498 ("KVM: Move x86's MMU notifier memslot walkers to generic code")
Reported-by: Shuai Hu <hshuai@redhat.com>
Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 virt/kvm/kvm_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 479802a892d4..7f81a3a209b6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -598,6 +598,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			unsigned long hva_start, hva_end;
 
 			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
+			if (slot->flags & KVM_MEMSLOT_INVALID)
+				continue;
+
 			hva_start = max(range->start, slot->userspace_addr);
 			hva_end = min(range->end, slot->userspace_addr +
 						  (slot->npages << PAGE_SHIFT));
-- 
2.23.0

