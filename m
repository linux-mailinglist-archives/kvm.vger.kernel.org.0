Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1279858A738
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 09:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239916AbiHEHg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 03:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiHEHg6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 03:36:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD1B11D310
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 00:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659685015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SxUSY64d5VjHvPCwi4IFil12hzsa3qnkO5a0AH4ypwA=;
        b=BXVgsRo3qHkyOheOnr1M5ISK+2T9JCKWXrtdSbgqmFvolxoG48Rj148CejdWb+ThuJuHm9
        7BhLb0Mh006kGz9ya2saDbIKljb+69M+EVsqttrek0tEsiEA7hlvu64kZKEEsVCYZ1+sCk
        b5x76YPPeBn9llhAv6px5alpO9LCztg=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-XXrqV1ZBM4KoU8KbBGIt1A-1; Fri, 05 Aug 2022 03:36:54 -0400
X-MC-Unique: XXrqV1ZBM4KoU8KbBGIt1A-1
Received: by mail-vs1-f69.google.com with SMTP id c5-20020a671c05000000b0037cd76d09bcso151702vsc.12
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 00:36:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SxUSY64d5VjHvPCwi4IFil12hzsa3qnkO5a0AH4ypwA=;
        b=sXmo8KkuHwdNpE+0OubyXzJ+mmvEgXEMYi5Syf3LXEC2jYjwasjy2hhatxmPJyFJz0
         MZaOnXORoSSSiDH/0r2D9G8E3hnIPLhNzLwkU/hjfKPo2E2pYhEmG4ru55eaMV5EY4gm
         tc8uWG2IN8Dc6evxl1gw8Qr8m5d3W8tMrF2cm474oRrPqb59rBZnw55SCjgZHb8O+bWo
         d7OeEpR0Z5ENizuH9fSi/wyBbGNk1K76FTvmeH6up6x8KXXbazfCWFBJKzryLIyd9u0d
         Ca1CkXA86wCNA5NNa2BSd+sX7vCd/7ws9cIXCs0V858U6Fn9swPc2QAFr9m239sq7NDO
         C5dg==
X-Gm-Message-State: ACgBeo2abuGwkAD70BOgFu4RUV+/q13k6IqZ0gJSeKuJ2uvDHevspzaG
        RKqDYAF/ysWfUpUZiu6n+6/Ai6nLoG48tKsykm3Hzod9BdKNcCrHXNU7WTaEyUYJUPxls6WQhY/
        8PrwdzZ7kaIMI
X-Received: by 2002:a67:edcc:0:b0:358:c252:3f37 with SMTP id e12-20020a67edcc000000b00358c2523f37mr2360871vsp.5.1659685013625;
        Fri, 05 Aug 2022 00:36:53 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6vPdzxueEhfNPMjgvsRW1bNZlXWzWSuYJ+LQrvIdiz6jinpt12Keng3EjTfZ2Mx0yQD/ieJw==
X-Received: by 2002:a67:edcc:0:b0:358:c252:3f37 with SMTP id e12-20020a67edcc000000b00358c2523f37mr2360863vsp.5.1659685013374;
        Fri, 05 Aug 2022 00:36:53 -0700 (PDT)
Received: from LeoBras.redhat.com ([2804:1b3:a800:5713:6880:fd74:a3e5:2086])
        by smtp.gmail.com with ESMTPSA id f16-20020ab074d0000000b00384cb279757sm2906641uaq.33.2022.08.05.00.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 00:36:52 -0700 (PDT)
From:   Leonardo Bras <leobras@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>
Cc:     Leonardo Bras <leobras@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/1] kvm: Use a new spinlock to avoid atomic operations in kvm_get_dirty_log_protect
Date:   Fri,  5 Aug 2022 04:35:45 -0300
Message-Id: <20220805073544.555261-1-leobras@redhat.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

<The objective is to get feedback on the idea, before trying to get a
 proper version. Please provide feedback! >

kvm_get_dirty_log_protect is very slow, and it takes a while to get the
dirty bitmap when 'manual_dirty_log_protect' is not being used.
Current working is something like:
- Memset the 'second_dirty_bitmap' with zeros
- Get KVM_MMU_LOCK to scan the whole bitmap for dirty-bits
  - If there is long with a dirty-bit, xchg() it into second_dirty_bitmap
  - Reprotect the related memory pages,
- Flush remote tlbs,
- Copy the dirty-bitmap to the user, and return.

The proposal is to remove the memset and the atomics part by using the
second_dirty_bitmap as a real dirty-bitmap, instead of a simple buffer:
- When kvm_get_dirty_log_protect runs, before copying anything, switches
  to the other dirty-bitmap (primary->secondary or secondary->primary).
- (After that, mark_page_dirty_in_slot() will start writing dirty-bits to
  the other bitmap, so there will be no one using it, and it's fine to
  modify it without atomics),
- Then, copy the current bitmap to userspace,
- Then get the KVM_MMU_LOCK, scan the bitmap copied, and both protect the
  page and clean the dirty bits in the same loop.
- Flush remote tlbs, and return.

The bitmap switch (primary <-> secondary) is protected by a spinlock,
which is also added into mark_page_dirty_in_slot() to make sure it does
not write to the wrong bitmap. Since this spinlock protects just a few
instructios, it's should not introduce a lot of delay.

Results:
1 - Average clock count spent in kvm_get_dirty_log_protect() goes from
    13608798 to 6734244, representing around 50% less clock cycles.
2 - Average clock count spent in mark_page_dirty_in_slot() goes from
    462 to 471, representing around 2% increase, but since this means
    just a few cycles, it can be an imprecise measure.

Known limitations:
0 - It's preliminary. It has been tested but there are a lot of bad stuff
that needs to be fixed, if the idea is interesting.

1 - Spin-Locking in mark_page_dirty_in_slot():
I understand this function happens a lot in the guest and should probably
be as fast as possible, so introducing a lock here seems
counter-productive, but to be fair, I could not see it any slower than a
couple cycles in my current setup (x86_64 machine).

2 - Qemu will use the 'manual_dirty_log_protect'
I understand that more recent versions qemu will use
'manual_dirty_log_protect' when available, so this approach will not
benefit this use case, which is quite common.
A counter argument would be: there are other hypervisors that could benefit
from it, and that is also applicable for older qemu versions.

3 - On top of that, the overhead in (1) will be unnecessary for (2) case
That could be removed by testing for 'manual_dirty_log_protect' in
'mark_page_dirty_in_slot()', and skipping the spinlock, but this was not
added just to keep the rfc simpler.

Performance tests were doing using:
- x86_64 VM with 32 vcpus and 16GB RAM
- Systemtap probes in function enter and function return, measuring the
  number of clock cycles spent between those two, and printing the average.
- Synthetic VM load, that keeps dirtying memory at fixed rate of 8Gbps.
- VM Migration between hosts.

Further info:
- I am also trying to think on improvements for the
  'manual_dirty_log_protect' use case, which seems to be very hard to
  improve. For starters, using the same approach to remove the atomics
  does not seem to cause any relevant speedup.

Signed-off-by: Leonardo Bras <leobras@redhat.com>
---
 include/linux/kvm_host.h |  3 ++
 virt/kvm/kvm_main.c      | 75 ++++++++++++++++++++++++++--------------
 2 files changed, 52 insertions(+), 26 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 90a45ef7203bd..bee3809e85e93 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -571,6 +571,9 @@ struct kvm_memory_slot {
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long *dirty_bitmap;
+	/* Protects use_secondary, which tells which bitmap to use */
+	spinlock_t bm_switch_lock;
+	bool use_secondary;
 	struct kvm_arch_memory_slot arch;
 	unsigned long userspace_addr;
 	u32 flags;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a49df8988cd6a..5ea543d8cfec2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1560,6 +1560,9 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
 
 	r = kvm_arch_prepare_memory_region(kvm, old, new, change);
 
+	if (new)
+		spin_lock_init(&new->bm_switch_lock);
+
 	/* Free the bitmap on failure if it was allocated above. */
 	if (r && new && new->dirty_bitmap && (!old || !old->dirty_bitmap))
 		kvm_destroy_dirty_bitmap(new);
@@ -2053,7 +2056,6 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	int i, as_id, id;
 	unsigned long n;
 	unsigned long *dirty_bitmap;
-	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
 	/* Dirty ring tracking is exclusive to dirty log tracking */
@@ -2070,12 +2072,11 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	if (!memslot || !memslot->dirty_bitmap)
 		return -ENOENT;
 
-	dirty_bitmap = memslot->dirty_bitmap;
-
 	kvm_arch_sync_dirty_log(kvm, memslot);
 
 	n = kvm_dirty_bitmap_bytes(memslot);
 	flush = false;
+
 	if (kvm->manual_dirty_log_protect) {
 		/*
 		 * Unlike kvm_get_dirty_log, we always return false in *flush,
@@ -2085,35 +2086,49 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 		 * transition to kvm_get_dirty_log_protect and kvm_get_dirty_log
 		 * can be eliminated.
 		 */
-		dirty_bitmap_buffer = dirty_bitmap;
-	} else {
-		dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
-		memset(dirty_bitmap_buffer, 0, n);
+		if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
+			return -EFAULT;
 
-		KVM_MMU_LOCK(kvm);
-		for (i = 0; i < n / sizeof(long); i++) {
-			unsigned long mask;
-			gfn_t offset;
+		return 0;
+	}
 
-			if (!dirty_bitmap[i])
-				continue;
+	/*
+	 * Switches between primary and secondary dirty_bitmap.
+	 * After unlocking, all new dirty bits are written to an empty bitmap.
+	 */
+	spin_lock(&memslot->bm_switch_lock);
+	if (memslot->use_secondary)
+		dirty_bitmap = kvm_second_dirty_bitmap(memslot);
+	else
+		dirty_bitmap = memslot->dirty_bitmap;
 
-			flush = true;
-			mask = xchg(&dirty_bitmap[i], 0);
-			dirty_bitmap_buffer[i] = mask;
+	memslot->use_secondary = !memslot->use_secondary;
+	spin_unlock(&memslot->bm_switch_lock);
 
-			offset = i * BITS_PER_LONG;
-			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
-								offset, mask);
-		}
-		KVM_MMU_UNLOCK(kvm);
+	if (copy_to_user(log->dirty_bitmap, dirty_bitmap, n))
+		return -EFAULT;
+
+	KVM_MMU_LOCK(kvm);
+	for (i = 0; i < n / sizeof(long); i++) {
+		unsigned long mask;
+		gfn_t offset;
+
+		if (!dirty_bitmap[i])
+			continue;
+
+		flush = true;
+		mask = dirty_bitmap[i];
+		dirty_bitmap[i] = 0;
+
+		offset = i * BITS_PER_LONG;
+		kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
+							offset, mask);
 	}
+	KVM_MMU_UNLOCK(kvm);
 
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 
-	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
-		return -EFAULT;
 	return 0;
 }
 
@@ -3203,11 +3218,19 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-		if (kvm->dirty_ring_size)
+		if (kvm->dirty_ring_size) {
 			kvm_dirty_ring_push(&vcpu->dirty_ring,
 					    slot, rel_gfn);
-		else
-			set_bit_le(rel_gfn, memslot->dirty_bitmap);
+		} else {
+			spin_lock(&memslot->bm_switch_lock);
+			if (memslot->use_secondary)
+				set_bit_le(rel_gfn,
+					   kvm_second_dirty_bitmap(memslot));
+			else
+				set_bit_le(rel_gfn, memslot->dirty_bitmap);
+
+			spin_unlock(&memslot->bm_switch_lock);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
-- 
2.37.1

