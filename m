Return-Path: <kvm+bounces-9400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C897685FDB7
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:11:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 558011F23215
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 056D4153510;
	Thu, 22 Feb 2024 16:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cCW49TC8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7C81534FD
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618263; cv=none; b=nUzOtJcCWeHGaSV6/Dpq6jBacIUkxxhDE4HQnbq6cSGHrnif4rgZebddVmvwI/8BOKd/uvG2AZTRjNGhpj+5qI8/QkQzRnTLNqz8abrHQgDWD1wEUc/11LZqiPHGgnf7v+P/3x6AODHDI2fb3mth0QH6Dos3qgGapTTOg3+Ji80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618263; c=relaxed/simple;
	bh=X9b1S6yNSBLD+mqNBTikNYnbyUMFTya7TpTup5Rt/FI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bPg1Wwbiwub9fTxfI4FJmfliCcvI9ISsO6KJPpObLzfOjr1zESbBs3KB9IePaE/GRrvXWNQJ0ZSM7mvLh3FdYX39cpo+fAwTORYAmbiHYiTdJphiaSHDg+g3tXBxXKeDcUUNHSTnVnSwtveHqHaLOAjXM+rBgeDbgk8I6VGYM/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cCW49TC8; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-608a1a2723cso8054237b3.0
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618260; x=1709223060; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s0Rj06sprumtF573AfEP0GeSqajU1zMKKEjxpZroPas=;
        b=cCW49TC8GNpbq2ahSG0M0hGEATSf7iIb/OP5GbDxu5NGPmi1KDvCYMbzfqLfS13fQt
         DutT2dVdtzcSBFskR12qV6KWi68lyUPlyrPsjNCsmikSku/8Nhz7EEVKRgyZVMuK28d3
         oF2eGKUhaCL/t+jr3UyDONa5pQrmPwJ1sBpeXs2b8bGNk+BO+rh1qZsF6zH+qVMexdZ7
         V3un8BmErThl0wSFqgdzGzwa9bL3D4LBCL7Db+aHDrV6zCEnHR4+HNbW8q1MdcOFWhqr
         MTd38/CApa7KbTL52dekIJ528vTfumLdOOdhHHToF8ltT5NmTrGuk5XgMhgSW+3WQbba
         iJAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618260; x=1709223060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s0Rj06sprumtF573AfEP0GeSqajU1zMKKEjxpZroPas=;
        b=KHx0a1kqyulgOy5E/PsVcgD9cl27aGa7s31pvsIlRWLCWw4M4Oc1G+FV0IadSvbFs5
         u1ejte1sj/Fe1Xb4VJNZyVyniCPiJA5igITp6SaayeRUWEYAe8myo0eUeQxlYdLN+WFB
         eGePU1vUErbxjXzO5SsXkhwMS7d/Ko0FEhbhgmkvPtMOKFjU/0niLrUkdM8QaiDh13AZ
         aSsdlkO/YtVzz/7o6UeO5j0h5XLVrpWYbdIYBgyDKumcPm+FAw1CGeqPDKDDi5BwcqFv
         IEzVdNa6vmUgzuat7i+tubceFVle5w9yMO2XOYwA2nDZ7LBCpBFXTGLUEzkCFZFesdKD
         551Q==
X-Gm-Message-State: AOJu0Yxd0spj4tpZ0VnzauMUHzFCAXHXL4XiEux75BKg+SjTdszTeyQp
	9vWsFkkfdkucVehUfHJd6dDkh5tWtWjqYUG7fwzqttXMVdI13SHKr4CVMQ9R7qpfQsDPizeNCK+
	Uxsy634hFbghEAsRbnZwVeiUko01NvSviP+eF/SqjphBhh5aQHOprXPFfSjfHh4oHY+tDGEUcCW
	7MAMmRWcWnKHTzNVPUd/SaqHQ=
X-Google-Smtp-Source: AGHT+IFWb1sqSDVpFuZ3W8sqoZxZFPSTBJOjR01PwIQfs5Me2aRJCpsMpzSOCXlcfJYvEs2Ca8Gd5XNO5w==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:a014:0:b0:608:a89e:be89 with SMTP id
 x20-20020a81a014000000b00608a89ebe89mr174469ywg.3.1708618260297; Thu, 22 Feb
 2024 08:11:00 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:25 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-5-tabba@google.com>
Subject: [RFC PATCH v1 04/26] KVM: Don't allow private attribute to be set if
 mapped by host
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Guest private memory should never be mapped by the host.
Therefore, do not allow setting the private attribute to guest
memory if that memory is mapped by the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h |  7 ++++++
 virt/kvm/kvm_main.c      | 51 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fad296baa84e..f52d5503ddef 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2408,11 +2408,18 @@ static inline bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn)
 	return !(kvm_get_memory_attributes(kvm, gfn) &
 		 KVM_MEMORY_ATTRIBUTE_NOT_MAPPABLE);
 }
+
+bool kvm_is_gmem_mapped(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 #else
 static inline bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
 }
+
+static inline bool kvm_is_gmem_mapped(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
+{
+	return false;
+}
 #endif /* CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE */
 
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fba4dc6e4107..9f6ff314bda3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2516,6 +2516,48 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 		KVM_MMU_UNLOCK(kvm);
 }
 
+#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE
+bool kvm_is_gmem_mapped(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
+{
+	struct kvm_memslot_iter iter;
+
+	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), gfn_start, gfn_end) {
+		struct kvm_memory_slot *memslot = iter.slot;
+		gfn_t start, end, i;
+
+		start = max(gfn_start, memslot->base_gfn);
+		end = min(gfn_end, memslot->base_gfn + memslot->npages);
+		if (WARN_ON_ONCE(start >= end))
+			continue;
+
+		for (i = start; i < end; i++) {
+			struct page *page;
+			bool is_mapped;
+			kvm_pfn_t pfn;
+			int ret;
+
+			/*
+			 * Check the page_mapcount with the page lock held to
+			 * avoid racing with kvm_gmem_fault().
+			 */
+			ret = kvm_gmem_get_pfn_locked(kvm, memslot, i, &pfn, NULL);
+			if (WARN_ON_ONCE(ret))
+				continue;
+
+			page = pfn_to_page(pfn);
+			is_mapped = page_mapcount(page);
+			unlock_page(page);
+			put_page(page);
+
+			if (is_mapped)
+				return true;
+		}
+	}
+
+	return false;
+}
+#endif /* CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE */
+
 static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
 					  struct kvm_gfn_range *range)
 {
@@ -2565,6 +2607,15 @@ static int __kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	if (kvm_range_has_memory_attributes(kvm, start, end, attributes))
 		goto out_unlock;
 
+	if (IS_ENABLED(CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE) && userspace) {
+		/* Host-mapped memory cannot be private. */
+		if ((attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE) &&
+		    kvm_is_gmem_mapped(kvm, start, end)) {
+			r = -EPERM;
+			goto out_unlock;
+		}
+	}
+
 	/*
 	 * Reserve memory ahead of time to avoid having to deal with failures
 	 * partway through setting the new attributes.
-- 
2.44.0.rc1.240.g4c46232300-goog


