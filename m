Return-Path: <kvm+bounces-52759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BF269B091C0
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 18:28:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED30E1C4444D
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B562FE313;
	Thu, 17 Jul 2025 16:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qXdeYptI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE482FCFC9
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 16:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769662; cv=none; b=i+2L8FSW95DzuOezCI8HFuJmZe00/FIkTaPELuqdb42e3nSZ0A2GzGWRg1tuqNv2WFyG2t7/Pd+5qF346sedgJvBXxhdXACP+yo/2zokxvxzfSezCPKCBO7P6XgW6TzwPdBKg436OlgayEaYsif7E3iz9hlTFfw+u/0RB3JKp6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769662; c=relaxed/simple;
	bh=eCkEMmkV7zuOHj76xDUG2iiUIlXUTmKzU3RtBkBbfBQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RXejRlSW33ypK7qvkqCLZLl2euqaZLPVQ90/RgPMZBoAnAjyouBUT0w+7oJdk+i2xUdfN05QzeaBvFeeBEQ+DVsEnWY92Tv1ZKv1fMvZzgk+y0nPcPXS5dzk3Q0gD9JK4v+gV/JljfJxikV7dJOgd4EU5EeGicawQGZGWCo29gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qXdeYptI; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-455f7b86aeeso5374465e9.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769659; x=1753374459; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EsHZSymGf6YpoJB6CYjmGKtG3qfnN0nRO5q9kqA6+Ic=;
        b=qXdeYptI7GOiQSVBHY4N9zoBHMdDGbKzMIuNMhJtlCBBTfjEnJ0Wxdud1mz19Hinhx
         4+GnF5aM3/I4zUqe5pyjOrxeayMHy38WdUnoryO8mY7v9n54O92wPHJ+jGMvOVVJOmvd
         8vBRLOV5QQGAF3TSQzN3SRd4cRQnO2dOEnKIsBE9qxGjBPFxm7ol6zsbEwbMzMxdOUFd
         43A5AuiMsff2CMqz2ORgrfET15r5VX3VZXQbLLqBC546J2+hPGYLq7uX33AMZr7xwTcp
         n+ltdrQdeAbYhms4IgWU90xJAuRWxGkUO9D1O1x4+gfI71TJg/d4Tys8aKc55K7o29s0
         lJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769659; x=1753374459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EsHZSymGf6YpoJB6CYjmGKtG3qfnN0nRO5q9kqA6+Ic=;
        b=VjYN7ihYAz2jQcO+0oHsSDJ90iOr2C5ogrFWi+GWjw+MZTx98eIbZbQGelYHsazFBr
         aKYabdpsksn7pry+PEfLGipJNT3Yeg1NSiaOCOUuL0IZc74i0fpqaN8Mh59EgtX49J1y
         xlwSoHO5PEwb7XBcRiurKlSrv+Ubvtez/gr/zFQPDoPbEKbz9ZZ9ZD4AAWMfCzWmNKqe
         XIhdRpKjHKO3/WnPd/Vh+Ldxv0Qaa31Hl+kziZd+t9mUo3pjlBVwW+BS25CdSI/8mooU
         QZhsVPPT+U89zBxFJKXaM95GRLnBgeNfYjeAPmBEdWkMwXBPAqb+xxAip1+3CcRXcAWL
         4u1g==
X-Gm-Message-State: AOJu0YwRFKJ+ueXYMMj2DFniqPwUKFRdt7O7Zzx5OP7DIMvGmycT9nMB
	9/GAq9Guf9sFQNu77HVBznxo22wMvsIr8870owXET+vlFcKvqIwE6+Pgd9uHChoUI7YzcmJHd0U
	pQJ1qTLcqzyB0c8UyD6P92QY0eE1wu8qnMPy0Fs5ABg7ZrswPD8OThtYVCsxkOScAqUyJO3x3bT
	ummTzrf0kS14TB7kRvSiITrcjthlY=
X-Google-Smtp-Source: AGHT+IHF5lWSGh9WVYXpPoz50NAiXW+TxYfluQK9b17X5f+I+q79c8QlWYxgL++Ahdcq7iS1BIfk280OVw==
X-Received: from wmby19.prod.google.com ([2002:a05:600c:c053:b0:456:1b6f:c878])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4ed3:b0:43c:fe5e:f03b
 with SMTP id 5b1f17b1804b1-4562e3cac86mr80404015e9.30.1752769658462; Thu, 17
 Jul 2025 09:27:38 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:16 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-7-tabba@google.com>
Subject: [PATCH v15 06/21] KVM: Fix comments that refer to slots_lock
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

Fix comments so that they refer to slots_lock instead of slots_locks
(remove trailing s).

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ed00c2b40e4b..9c654dfb6dce 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -870,7 +870,7 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	/* Protected by slots_locks (for writes) and RCU (for reads) */
+	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 162e2a69cc49..46bddac1dacd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -331,7 +331,7 @@ void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
 	 * All current use cases for flushing the TLBs for a specific memslot
 	 * are related to dirty logging, and many do the TLB flush out of
 	 * mmu_lock. The interaction between the various operations on memslot
-	 * must be serialized by slots_locks to ensure the TLB flush from one
+	 * must be serialized by slots_lock to ensure the TLB flush from one
 	 * operation is observed by any other operation on the same memslot.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-- 
2.50.0.727.gbf7dc18ff4-goog


