Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037A0444C6E
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbhKDAab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbhKDA3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:29:06 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D182FC06127A
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:26:29 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id m74-20020a633f4d000000b0029fed7e61f9so2362557pga.16
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=gefeXeMu+9xCn+OiiZbsmvywIWNyuYY1aczHxfS7F84=;
        b=q1wAaFzQivbUaLWNpD28vIW6ok97J24IWOZtjc0+hsnIoFnhMyUWsnSfQKoqN3maJ3
         KBdBMOyYnFaTKZvkOTgijuDb8a1y6dTYyIvATTjrk50gQdXgdq0sK8P9D8VXqeBwIchM
         S4752LKzCwKCElggFGcp/0gCfncZSwTidehk3QlNJHjH4YdWFX4NP2+qFH0XmXIojpE7
         shl+78ytzLoTN1+DNy2u1aXGBjCw+SMXFRKxDeT2bHggWBTmy7o/SubcktQSj4/PZQou
         hwUcODvMGvNUFZIWK9EWYU9o0oSTlOaqrHSlqsc6GHFHSECGSUQyaSoW+8/pBlFiy+YJ
         LVDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=gefeXeMu+9xCn+OiiZbsmvywIWNyuYY1aczHxfS7F84=;
        b=sVMAuYUjhxUdLfIH4TYLD0AZJnqZC1Fax/AXqrzbxQ8ASPtArASwt+KNCG2leyuYso
         DqPKLFLLLIJb1MMp2MsXuTRSxxhsKD/mT4++t6S7Wnz/uuKXdCBZkWe6Ybo5mrwnwM13
         k+jBYhJ+9tuv56D+K5BvqIavoUODUgLmLRbgEeQYBUgpyQ/OlMQ9q0Trb/y/hF99yBlG
         hWB2QA4sVZxYALvQHkFhufcwepGL3EVgb3SocT+0CBbHp+i8XiUcdNIr11DVWfb5ntqY
         MaI6EIkp5SnhFbQMABtpt2yqoG+9Ti5I0AdzhwhPRUhBV6+9ntfUR+vAayfS3NEaf1SL
         fpwg==
X-Gm-Message-State: AOAM532JNYd6xxRWiYU7cYFIpG4ThwlpxSiSmWgOuHqCZkWsMxv9MEwi
        N8ljN1pLC2M+HxROmS4Det8iGKNbdkQ=
X-Google-Smtp-Source: ABdhPJwuRHtV9T3+KFXWyLxF72TgsEexvxCX5VCcTZ2sr7WXwUborCujSIBbaHyiH9gR1LJWc7GYuxnx26s=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:740e:: with SMTP id p14mr35995604pgc.329.1635985589285;
 Wed, 03 Nov 2021 17:26:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:19 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-19-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 18/30] KVM: Don't make a full copy of the old memslot in __kvm_set_memory_region()
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stop making a full copy of the old memslot in __kvm_set_memory_region()
now that metadata updates are handled by kvm_set_memslot(), i.e. now that
the old memslot's dirty bitmap doesn't need to be referenced after the
memslot and its pointer is modified/invalidated by kvm_set_memslot().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c7bbc452dae..bbaa01afac43 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1715,8 +1715,8 @@ static int kvm_set_memslot(struct kvm *kvm,
 int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region *mem)
 {
-	struct kvm_memory_slot old, new;
-	struct kvm_memory_slot *tmp;
+	struct kvm_memory_slot *old, *tmp;
+	struct kvm_memory_slot new;
 	enum kvm_mr_change change;
 	int as_id, id;
 	int r;
@@ -1746,25 +1746,16 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 
 	/*
-	 * Make a full copy of the old memslot, the pointer will become stale
-	 * when the memslots are re-sorted by update_memslots(), and the old
-	 * memslot needs to be referenced after calling update_memslots(), e.g.
-	 * to free its resources and for arch specific behavior.
+	 * Note, the old memslot (and the pointer itself!) may be invalidated
+	 * and/or destroyed by kvm_set_memslot().
 	 */
-	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
-	if (tmp) {
-		old = *tmp;
-		tmp = NULL;
-	} else {
-		memset(&old, 0, sizeof(old));
-		old.id = id;
-	}
+	old = id_to_memslot(__kvm_memslots(kvm, as_id), id);
 
 	if (!mem->memory_size) {
-		if (!old.npages)
+		if (!old || !old->npages)
 			return -EINVAL;
 
-		if (WARN_ON_ONCE(kvm->nr_memslot_pages < old.npages))
+		if (WARN_ON_ONCE(kvm->nr_memslot_pages < old->npages))
 			return -EIO;
 
 		memset(&new, 0, sizeof(new));
@@ -1784,7 +1775,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (new.npages > KVM_MEM_MAX_NR_PAGES)
 		return -EINVAL;
 
-	if (!old.npages) {
+	if (!old || !old->npages) {
 		change = KVM_MR_CREATE;
 
 		/*
@@ -1794,14 +1785,14 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if ((kvm->nr_memslot_pages + new.npages) < kvm->nr_memslot_pages)
 			return -EINVAL;
 	} else { /* Modify an existing slot. */
-		if ((new.userspace_addr != old.userspace_addr) ||
-		    (new.npages != old.npages) ||
-		    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
+		if ((new.userspace_addr != old->userspace_addr) ||
+		    (new.npages != old->npages) ||
+		    ((new.flags ^ old->flags) & KVM_MEM_READONLY))
 			return -EINVAL;
 
-		if (new.base_gfn != old.base_gfn)
+		if (new.base_gfn != old->base_gfn)
 			change = KVM_MR_MOVE;
-		else if (new.flags != old.flags)
+		else if (new.flags != old->flags)
 			change = KVM_MR_FLAGS_ONLY;
 		else /* Nothing to change. */
 			return 0;
-- 
2.33.1.1089.g2158813163f-goog

