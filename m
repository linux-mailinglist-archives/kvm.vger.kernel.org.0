Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516DB3524D8
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 02:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbhDBA5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 20:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234422AbhDBA5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 20:57:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB5FC0613E6
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 17:57:19 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 71so4560115ybl.0
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 17:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=0/ecd8NmYTmeaiIYnkr6nuUXDKg3hRMT4+OQ0nyX4DE=;
        b=oYFGYSyo5B35UKJnfDl/ptvTjCVW8KNCbB5+juLbSKFFyhdI1o15HSF2gl9NbqxKmR
         WTeg8loXzFmw7sYPBcDz9SnE1ep/TQ8R11Jo0v6/+BXHFnVXD5GetugNTwD0b5Bqt1L/
         mx+Wv2fDdgWFKAi4FQThRwTMjWA7vs3uA/I3KI9C+xT2UVJEymjeiJxY9WdDCMtNY1Gh
         GqU4Bg7UboHpTTQPVmttgw2eCvKNRYVbBfciANMUqXXzeQ8x+WKQOPRt9i/fgo0c9Wxl
         r3IbL0WnEuE8LcmbAeXvX6nCRCfN/9RtrNuT+vA3q5p7oxMFeV4Y6S1fLZYoQC3OglWL
         5a1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=0/ecd8NmYTmeaiIYnkr6nuUXDKg3hRMT4+OQ0nyX4DE=;
        b=jsTU04vN+0/aGsFETO53sgRSXox2XsdjbnyyE7iu2oq7eRpB8URBFT/62ohyLvlmtF
         KIEkClsdo0wjm0pOjpA1THWcL1hkyrKuJTPaoAdO0bJgW8PazbptYEYpEEbCP6b5NGkI
         J9pA8bbgC48NC0/6EynaWZJ/9xw80Qr0eJGqCzplkQmNQ0gaHahuuT327+2ACD9ixdO3
         z1CzUUkrdO3PxFhuXRKcxuwzlR/sb5UERl444jsEEH4bNL22MTB+X22T9xkQn46rkEkB
         Yt2rL5hC92pPn8z4bqgkVivXJg055UPEUijdaIY2/WXOHCgfIkH+i5Mz7Z4CjK7Rsd0t
         BwnA==
X-Gm-Message-State: AOAM53012m0QigVugMlQmLDEZkEDDbSBGmudxXCdHwQgv064dZ8LhO6w
        OG6WRBCHpXe+RSmpUpJK6kf79AU/uKo=
X-Google-Smtp-Source: ABdhPJzt4o9P3PY2HrRiNrmz7rdm15sQ6vGfWjEexZR+eCJ9LN9XguP8ZdUR1MsXg+JiybkoEf+aAjrbxig=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:c0b4:8b8:bb34:6a56])
 (user=seanjc job=sendgmr) by 2002:a25:74d2:: with SMTP id p201mr16375842ybc.406.1617325038741;
 Thu, 01 Apr 2021 17:57:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Apr 2021 17:56:56 -0700
In-Reply-To: <20210402005658.3024832-1-seanjc@google.com>
Message-Id: <20210402005658.3024832-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210402005658.3024832-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 08/10] KVM: Take mmu_lock when handling MMU notifier iff
 the hva hits a memslot
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Defer acquiring mmu_lock in the MMU notifier paths until a "hit" has been
detected in the memslots, i.e. don't take the lock for notifications that
don't affect the guest.

For small VMs, spurious locking is a minor annoyance.  And for "volatile"
setups where the majority of notifications _are_ relevant, this barely
qualifies as an optimization.

But, for large VMs (hundreds of threads) with static setups, e.g. no
page migration, no swapping, etc..., the vast majority of MMU notifier
callbacks will be unrelated to the guest, e.g. will often be in response
to the userspace VMM adjusting its own virtual address space.  In such
large VMs, acquiring mmu_lock can be painful as it blocks vCPUs from
handling page faults.  In some scenarios it can even be "fatal" in the
sense that it causes unacceptable brownouts, e.g. when rebuilding huge
pages after live migration, a significant percentage of vCPUs will be
attempting to handle page faults.

x86's TDP MMU implementation is especially susceptible to spurious
locking due it taking mmu_lock for read when handling page faults.
Because rwlock is fair, a single writer will stall future readers, while
the writer is itself stalled waiting for in-progress readers to complete.
This is exacerbated by the MMU notifiers often firing multiple times in
quick succession, e.g. moving a page will (always?) invoke three separate
notifiers: .invalidate_range_start(), invalidate_range_end(), and
.change_pte().  Unnecessarily taking mmu_lock each time means even a
single spurious sequence can be problematic.

Note, this optimizes only the unpaired callbacks.  Optimizing the
.invalidate_range_{start,end}() pairs is more complex and will be done in
a future patch.

Suggested-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 25ecb5235e17..f6697ad741ed 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -482,10 +482,10 @@ static void kvm_null_fn(void)
 static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 						  const struct kvm_hva_range *range)
 {
+	bool ret = false, locked = false;
 	struct kvm_gfn_range gfn_range;
 	struct kvm_memory_slot *slot;
 	struct kvm_memslots *slots;
-	bool ret = false;
 	int i, idx;
 
 	/* A null handler is allowed if and only if on_lock() is provided. */
@@ -493,11 +493,13 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			 IS_KVM_NULL_FN(range->handler)))
 		return 0;
 
-	KVM_MMU_LOCK(kvm);
-
 	idx = srcu_read_lock(&kvm->srcu);
 
+	/* The on_lock() path does not yet support lock elision. */
 	if (!IS_KVM_NULL_FN(range->on_lock)) {
+		locked = true;
+		KVM_MMU_LOCK(kvm);
+
 		range->on_lock(kvm, range->start, range->end);
 
 		if (IS_KVM_NULL_FN(range->handler))
@@ -532,6 +534,10 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
 			gfn_range.slot = slot;
 
+			if (!locked) {
+				locked = true;
+				KVM_MMU_LOCK(kvm);
+			}
 			ret |= range->handler(kvm, &gfn_range);
 		}
 	}
@@ -540,7 +546,8 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 		kvm_flush_remote_tlbs(kvm);
 
 out_unlock:
-	KVM_MMU_UNLOCK(kvm);
+	if (locked)
+		KVM_MMU_UNLOCK(kvm);
 
 	srcu_read_unlock(&kvm->srcu, idx);
 
-- 
2.31.0.208.g409f899ff0-goog

