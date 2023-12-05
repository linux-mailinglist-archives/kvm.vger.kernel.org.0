Return-Path: <kvm+bounces-3621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2490805D0E
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 19:17:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E38431C20B3E
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D434068B84;
	Tue,  5 Dec 2023 18:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mwf+nhQP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4956122
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 10:16:51 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5cf4696e202so88051267b3.2
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 10:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701800211; x=1702405011; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eg+zRvLLL22iipHmiYBZTQnXBnTz5hfAeH9ofLslpF4=;
        b=Mwf+nhQPg0PrfFg9LlkG64LR/hkSmBZuP2JK/vA4uaOzj6Qv2p2vaO6zyBv0lgmQxR
         TdQuaIb7dNq/F3RhB2jQtaIMmVnZzVCYke2bfDdTDWr7PrxglAfgC+uskVh9tCHKw9SL
         4weNnqI83PEXUIrGCXiUQX6bqQhSS91inCzmE1/PuBBquW2B22VLK98Xv1oa7BZZ6T8Y
         8dAXSv4IYqBxl7sZCtuuzn53S8CX0nLJemtIB2WcrAYTYtJoeoh2oRIeDJ2WsNCGu+Jm
         eW2Za4XoZsfM8hXKnX712MQDJgiyHJUiarCzDjOk+nYjdfBFmBLczmqNHutoalmYSE0k
         iTcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701800211; x=1702405011;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eg+zRvLLL22iipHmiYBZTQnXBnTz5hfAeH9ofLslpF4=;
        b=ptgrecJCK7l3rh3cfGEdKijwG77cUNPCCOLE/GBLvTu3M1Pw9Melc2S2XOUiFQ1amI
         fDDa4qTpwMQiqHq+pFG9G3efsTqoAC+22jAwDYbPewu0qI8/cDeZLGIVlHjv5L95heph
         MQVKGOS99EKq8STzTO5CKJkf2nB8odvrUGu/n/PpkbT+UL/p6fS0oEiekJt4NU6+j6qm
         hS3KWYQz+G6kkgXtMV63n3aK7uao1jYpPERPHIA0Zur3s7xEzjYI/cqk+1BfZZIkx8GY
         9UYh48CBtVCJ3awq3GekJd9rSiVQT2DlU10rLtyExR7XEcee5vG8Wk+bkiCE4E5ZuLrl
         mj5Q==
X-Gm-Message-State: AOJu0YzOIypaRJ29hBZxrz8w8kUoVtYi5MRQ64dGPBJkuhk7GJbZxRBb
	fiXcyWPNJYM/IKsAe87h/uiMFXRwNhXUBQ==
X-Google-Smtp-Source: AGHT+IH3uQMuuWQgr5LXhkX0+GViTb5rXsqTr3MPYqE79pjKgU2CiL61lLNOnRmS137Xo4avpHybX1qnKlayrw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:ac17:0:b0:5d3:edb7:8470 with SMTP id
 k23-20020a81ac17000000b005d3edb78470mr324238ywh.7.1701800211044; Tue, 05 Dec
 2023 10:16:51 -0800 (PST)
Date: Tue,  5 Dec 2023 10:16:45 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231205181645.482037-1-dmatlack@google.com>
Subject: [PATCH] KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG to avoid
blocking other threads (e.g. vCPUs taking page faults) for too long.

Specifically, change kvm_clear_dirty_log_protect() to acquire/release
mmu_lock only when calling kvm_arch_mmu_enable_log_dirty_pt_masked(),
rather than around the entire for loop. This ensures that KVM will only
hold mmu_lock for the time it takes the architecture-specific code to
process up to 64 pages, rather than holding mmu_lock for log->num_pages,
which is controllable by userspace. This also avoids holding mmu_lock
when processing parts of the dirty_bitmap that are zero (i.e. when there
is nothing to clear).

Moving the acquire/release points for mmu_lock should be safe since
dirty_bitmap_buffer is already protected by slots_lock, and dirty_bitmap
is already accessed with atomic_long_fetch_andnot(). And at least on x86
holding mmu_lock doesn't even serialize access to the memslot dirty
bitmap, as vCPUs can call mark_page_dirty_in_slot() without holding
mmu_lock.

This change eliminates dips in guest performance during live migration
in a 160 vCPU VM when userspace is issuing CLEAR ioctls (tested with
1GiB and 8GiB CLEARs). Userspace could issue finer-grained CLEARs, which
would also reduce contention on mmu_lock, but doing so will increase the
rate of remote TLB flushing. And there's really no reason to punt this
problem to userspace since KVM can just drop and reacquire mmu_lock more
frequently.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Anup Patel <anup@brainfault.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Sean Christopherson <seanjc@google.com>

Signed-off-by: David Matlack <dmatlack@google.com>
---
NOTE: This patch was originally sent as part of another series [1].

[1] https://lore.kernel.org/kvm/170137684236.660121.11958959609300046312.b4-ty@google.com/

 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b..afa61a2309d2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2297,7 +2297,6 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
 		return -EFAULT;
 
-	KVM_MMU_LOCK(kvm);
 	for (offset = log->first_page, i = offset / BITS_PER_LONG,
 		 n = DIV_ROUND_UP(log->num_pages, BITS_PER_LONG); n--;
 	     i++, offset += BITS_PER_LONG) {
@@ -2316,11 +2315,12 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 		*/
 		if (mask) {
 			flush = true;
+			KVM_MMU_LOCK(kvm);
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
 								offset, mask);
+			KVM_MMU_UNLOCK(kvm);
 		}
 	}
-	KVM_MMU_UNLOCK(kvm);
 
 	if (flush)
 		kvm_flush_remote_tlbs_memslot(kvm, memslot);

base-commit: 45b890f7689eb0aba454fc5831d2d79763781677
-- 
2.43.0.rc2.451.g8631bc7472-goog


