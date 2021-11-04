Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2350444C23
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhKDA3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbhKDA2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:28:40 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCC8C061205
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:26:03 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id e6-20020a637446000000b002993ba24bbaso2380475pgn.12
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uUiF2cCeyvLcomA71gNb8UtnumiDOcYwDfMiXjWen6E=;
        b=oTQ7zxZOtJdIWwrRYuqPf1zjANoRXpGs4d18yx/1uFcULOqfGSPv/eGnnTHt2OaFXl
         Fw2Ja9jpx42JTWA+4xQHXaSDJzaLjB39qn72mpFaq/+8Pgyy1WE+Sui5ukzf7K0T1tch
         WQUzSIOcUqQ4RYGuYqINyp9t2Du3YpUpxuubgXkNzI9EfzqleZjWAUTMgOc4YeGCZQie
         KXx3n4rodQ4x96mmNgtB9r6T1WA9dTicsSrUIx+if+mPJuWUWAF+djp3CD78xEHLczgf
         /8ph947YIr/9EVIDN0A2sn1MabQLXDCtd3nrNdsi57mxIxM3VfxgHreQqgiovSN/aw02
         N1Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uUiF2cCeyvLcomA71gNb8UtnumiDOcYwDfMiXjWen6E=;
        b=jERzYMwU0vjwsdqcfSWbtHiY5o1wWjKtIXUDzQ+B5+fwxm70X5N3ylZ4XI5UAnjWmy
         UMHP43DP+61+w2SOfEzhYftOnQhf2Dlxc1x957hKeb4Zk/MNlf/aXu2IRr/UuOXx/3ze
         pWdX9F3FuqYadv1w7NNsmDvIhhZmqeyTO6hvo914fXwAlmRqAfAYbRzikiAYZpporTV1
         SXwX143AuDpJMtSEpiuh/zyv+tS78nmyYnTiRmOLv6LbzRGMpPBSn8SfLeTCk9yAqm+C
         7WeiCf1sHOzH9JC5TI8maGnuCjTRGAF1oXvPfo57QfWwFMYynOFQr891jMvhWOivxVxa
         rnsQ==
X-Gm-Message-State: AOAM532MAyjTAZHSUG4GlSMoBwYlcLQoc/rZDcGAbYF9Kn2MjlbHe/fx
        nyT5LjaMS0MSzg349n6J6aXnB/aJW4Y=
X-Google-Smtp-Source: ABdhPJzS1sKm1vihVbRPixin8ADPxwIwiRu+sSSO0iFE9jTmdDmiJb4scGZK4H9WqPr37m1ISOQPandeoog=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2181:b0:44c:f4bc:2f74 with SMTP id
 h1-20020a056a00218100b0044cf4bc2f74mr47622932pfi.68.1635985562987; Wed, 03
 Nov 2021 17:26:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:04 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-4-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 03/30] KVM: Require total number of memslot pages to fit
 in an unsigned long
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
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 60a35d9fe259..d8e92d4a78d8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -551,6 +551,7 @@ struct kvm {
 	 */
 	struct mutex slots_arch_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
+	unsigned long nr_memslot_pages;
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 83287730389f..264c4b16520b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1623,6 +1623,15 @@ static int kvm_set_memslot(struct kvm *kvm,
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
@@ -1653,6 +1662,9 @@ static int kvm_delete_memslot(struct kvm *kvm,
 	if (!old->npages)
 		return -EINVAL;
 
+	if (WARN_ON_ONCE(kvm->nr_memslot_pages < old->npages))
+		return -EIO;
+
 	memset(&new, 0, sizeof(new));
 	new.id = old->id;
 	/*
@@ -1736,6 +1748,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
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
-- 
2.33.1.1089.g2158813163f-goog

