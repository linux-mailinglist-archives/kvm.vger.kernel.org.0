Return-Path: <kvm+bounces-52477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FD61B05684
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:35:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0F1C3AA9C0
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 580292D97BC;
	Tue, 15 Jul 2025 09:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="amOVj5do"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32232D94A9
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572054; cv=none; b=KRVmtoYwCSCnAFw/pHstDH7Dtp7en8BbcDDQh0YNKQb9BrOu9udRbUaa6K8mBmPPXvAFuubw17cUHE2DmCyLWOKTAXAEuH7Q56rRqqA7grk6ixDR7qCH6vihh7FeH3QmJ377ECBbfWXqpxNWqCyXxjFQcXSqoIF5lkePM4fRAkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572054; c=relaxed/simple;
	bh=rwFpQdz+xqsV9TRx7fn+9BFSSTMO137zIdaSVB+FJjM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X5RG9khEN8mLSZVO+bOQhMBnI4+xtJUHqxKzjoGUDNFTJrFAQBN7l6962blnrHEYBUGNu3r1+dXlEcUW9/KUkWxeKstqCZCpmbXaHbIhTllhZt9xbVGYxqPiWmiqlfpVlmEPgmuzw/epwkmoLrxMbxDAU+L+w1mkOK3TKK2VVtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=amOVj5do; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4560b81ff9eso18482625e9.1
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 02:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572051; x=1753176851; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HKm1OPddzPOCVybWQJf7fIOws1hHLUPbnC0KechHFr4=;
        b=amOVj5doke0jR5KbSOkqnIedeIeCu+k7cCqhFHGXnmfHP4KNkN9YayNLbFW0DRiHJx
         ilGYaWYpunrYyjaTEdwjZQOo9hc89LrLNfaHNuIIaPJa3sbbWpHUO7TpmSrkNt70GwbI
         jlYQBeCCQNDY1MrIBqApay60uOvHuCdxtbREL34YR4nh+ElLSl9FxWKfxW164jhpkHif
         d9owtLsUm1L8qQbnI2hIqhXvptzrbRX9ttXd0KaTReLI3qaMpmAg3Uhg//C06ubyhEzC
         6Sp3STE7JwT5tv9y43Rrg2EgrYHhkTQ5xYHlcl8iTw2K9NjGsI+jpir5ZU5m2r/ypIFV
         ekaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572051; x=1753176851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HKm1OPddzPOCVybWQJf7fIOws1hHLUPbnC0KechHFr4=;
        b=S8jSuBd1ne90UPFMtnwmF63xVesD7pLS4k9qoWxj6OUp0g33P644k0Vnhn3P/e2W3z
         he15bC9t0EGWAYwPiJq9DdJ4fELqJDuhdrdixiV7sCQcgkfZrTT7ySmvdh41gk3Oj6Qe
         kl7kVyBS6ysiM2l4eCxde9l1VvxrKCONuDMmJEzooYDP55gOX3mPGU7QwMiy7PyouiF1
         fTTamCGrb3LgqHfrqX6bkz3W6QjqB+CD47gfXP/Rt1s4wGRX9HNJBFng4uy+YZ4bLdRy
         XA6i2RTxdTL/ONJiHbXNNl85INziHyETSmwlP0sPGI+/oRZFeECLbq/MX/OMUBXapSzc
         Jt+A==
X-Gm-Message-State: AOJu0Yzrznm2dg42O2MZpxWf2WdegBgJFpoe1YblUmb49vpW9CaDBZ7n
	UQMbnNK96m5GD6Mb41f1GjNlvMIaQ3mEnLNknXWIn+huOo8LeFrQkrWMswCeb8MaWIOmLdU9ymh
	beMMYmprlW+uU4Az4yzT5FEjKDx4MG0fEW+m/rh3k7BssWaBQv9lPIgIK/Usmo7EiL4pmI2P9AW
	t44X9b/Ltf4m1JYvRTSfXEvE2BtLs=
X-Google-Smtp-Source: AGHT+IFb2OSH7lEKwhbKN8+t42ZlOCnkfwV4bEknRLarq2YT9adSgiVMvCqHjEbxvfjY3zoBqSDXrJRWaQ==
X-Received: from wrpf9.prod.google.com ([2002:adf:f449:0:b0:3b2:5edb:a37b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2086:b0:3a5:67d5:a400
 with SMTP id ffacd0b85a97d-3b5f18b3eaemr14590340f8f.33.1752572050760; Tue, 15
 Jul 2025 02:34:10 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:38 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-10-tabba@google.com>
Subject: [PATCH v14 09/21] KVM: guest_memfd: Track guest_memfd mmap support in memslot
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Add a new internal flag, KVM_MEMSLOT_GMEM_ONLY, to the top half of
memslot->flags. This flag tracks when a guest_memfd-backed memory slot
supports host userspace mmap operations. It's strictly for KVM's
internal use.

This optimization avoids repeatedly checking the underlying guest_memfd
file for mmap support, which would otherwise require taking and
releasing a reference on the file for each check. By caching this
information directly in the memslot, we reduce overhead and simplify the
logic involved in handling guest_memfd-backed pages for host mappings.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 11 ++++++++++-
 virt/kvm/guest_memfd.c   |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9ac21985f3b5..d2218ec57ceb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -54,7 +54,8 @@
  * used in kvm, other bits are visible for userspace which are defined in
  * include/uapi/linux/kvm.h.
  */
-#define KVM_MEMSLOT_INVALID	(1UL << 16)
+#define KVM_MEMSLOT_INVALID			(1UL << 16)
+#define KVM_MEMSLOT_GMEM_ONLY			(1UL << 17)
 
 /*
  * Bit 63 of the memslot generation number is an "update in-progress flag",
@@ -2536,6 +2537,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
+static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
+{
+	if (!IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP))
+		return false;
+
+	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
+}
+
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 07a4b165471d..2b00f8796a15 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -592,6 +592,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 */
 	WRITE_ONCE(slot->gmem.file, file);
 	slot->gmem.pgoff = start;
+	if (kvm_gmem_supports_mmap(inode))
+		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
 	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
 	filemap_invalidate_unlock(inode->i_mapping);
-- 
2.50.0.727.gbf7dc18ff4-goog


