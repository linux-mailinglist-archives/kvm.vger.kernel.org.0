Return-Path: <kvm+bounces-40841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1BC8A5E343
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 18:59:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BBBA189DFAB
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 17:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEE0D2580D1;
	Wed, 12 Mar 2025 17:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DOpcgpeL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA0725745C
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 17:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741802315; cv=none; b=Ss/mI9Tci2TrSO29AUm5Z/dPTpOHzrhGFU1Pwb2aWEDX6k+Tu/IfgIQBy7rZcls8tNehTIbCGBrLhDUjHiVKaMUZCzhya36xd3310oAgNeUodtr0PazEhF/QJhv5+z3fAeiDqAwDe0jOcmwXa1yD65pc3vegZw2ruhogtbVSEVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741802315; c=relaxed/simple;
	bh=3FS0AjD6bP0RaVtYsMwEFCHIRnAMnaOeO0UFnDNd6iI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LO+Ts4kLsHfx5RWRludRI9rLrd5LqC04EPxWfMlRVgvw7FHJsN8uVzAqLzyhiHr5AowY/lsUpgeak/RfDyb+MWby9JJS/KE5aUOJP88ClbCcZN2gxWXOkDvLxgkM8oXrpCkOoOaR6ngcYZonss7VXfrGBXUzHILf0vfznQIG+Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DOpcgpeL; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3912580843fso81293f8f.2
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 10:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741802312; x=1742407112; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R85+vuKuEEUS0jeCyrC0DyFve/WtnRZfc0oDmfyiJIQ=;
        b=DOpcgpeLc/qjabXaecEhFxxbGNPBf3Kqj/cuVmI2hfM+qVYqTDlR834rXLhLURpCza
         hqLhlAHxDp4tseQH144lMDonkYhjzw9dZLjjM4EtCuWHpAT+9tlEFFCcWQe23Lo9EUGh
         8/ldI7yWLHmUXR7ZpQa6nIvGef7P+y0ohNRi4yV3M0lxeH9vSOXYdKw+O2G/ZdQwK6is
         94knrSE56M1Mu8nScMnhDk+iOHS6NnC3EQLhj0oEU5Qjv62rFf6lGSGIqcH6WNaFYR7k
         X7OqiKnESutGx5c0IG6u6ZAOp+ZSrU7+uloHu0oIXbq190TDBSL/R+YHIO863oB/iLi+
         9Omw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741802312; x=1742407112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R85+vuKuEEUS0jeCyrC0DyFve/WtnRZfc0oDmfyiJIQ=;
        b=YlYbQUrxzmnKVNFxYUKNH783H9DHNzNOyJChyRK3S52lRRlHKsVbRvnDwJWby3E2D5
         Lyj/kA2R3NhwMcdj/KvRDGH6gXq/QtUAiuoDi8hBwgEgZL8ER1WdB7pSxxl85iOsgCd7
         wWLCmJ/I/cLZwpt20EUjjRq9dtYwdwGx3WWcjhRhOoYYO10o3lJGuQVx1HdeklArJJjJ
         wTzhS3xWHBIVf4JUuigGLBqvoJ7CEb9eYlwdfY4P7v4HQIHS3KBX1TCwoQ7fvgbDK/+L
         jf9wx4V9zFP6Pw38h48bKIf0hoizge580T+knxTgh5A94H3fR8n8qTe5MD7NqTneU//R
         q8pg==
X-Gm-Message-State: AOJu0YxXEd47vREfr5Rlcpbs+1C2JgWPNOBI8qVjvMxWcWtIoWQL61tu
	WnJhjTq3ZLkJXngpghaZL/OSPjsw9i58GL5b88lcu65jJmjYZdGCKoLMlEJIEbpbczsws4fPTCT
	+NN/hU7aQs35E4jiX1PCvTrxdFc61COUucK2YXqhjPMogq2xcQR3jlcxLUK+DYSmzf4eUpyYFpd
	2gjMlNOxiK108NtE6jlC7iZx8=
X-Google-Smtp-Source: AGHT+IEjA25qbz56/ZivYmOA/8CzIw+8OnvV/Ld9F8g5Xe1iEl9v0x7DnaQxJbHqJscC5/DJshWP+7a2dg==
X-Received: from wrbgx5.prod.google.com ([2002:a05:6000:4705:b0:391:3c12:d0cb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:178c:b0:391:3768:f448
 with SMTP id ffacd0b85a97d-3926c5a51cemr8018324f8f.49.1741802311548; Wed, 12
 Mar 2025 10:58:31 -0700 (PDT)
Date: Wed, 12 Mar 2025 17:58:16 +0000
In-Reply-To: <20250312175824.1809636-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250312175824.1809636-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250312175824.1809636-4-tabba@google.com>
Subject: [PATCH v6 03/10] KVM: guest_memfd: Handle kvm_gmem_handle_folio_put()
 for KVM as a module
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
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
	jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

In some architectures, KVM could be defined as a module. If there is a
pending folio_put() while KVM is unloaded, the system could crash. By
having a helper check for that and call the function only if it's
available, we are able to handle that case more gracefully.

Signed-off-by: Fuad Tabba <tabba@google.com>

---

This patch could be squashed with the previous one of the maintainers
think it would be better.
---
 include/linux/kvm_host.h |  5 +----
 mm/swap.c                | 20 +++++++++++++++++++-
 virt/kvm/guest_memfd.c   |  8 ++++++++
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7788e3625f6d..3ad0719bfc4f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2572,10 +2572,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 #endif
 
 #ifdef CONFIG_KVM_GMEM_SHARED_MEM
-static inline void kvm_gmem_handle_folio_put(struct folio *folio)
-{
-	WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
-}
+void kvm_gmem_handle_folio_put(struct folio *folio);
 #endif
 
 #endif
diff --git a/mm/swap.c b/mm/swap.c
index 241880a46358..27dfd75536c8 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -98,6 +98,24 @@ static void page_cache_release(struct folio *folio)
 		unlock_page_lruvec_irqrestore(lruvec, flags);
 }
 
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+static void gmem_folio_put(struct folio *folio)
+{
+#if IS_MODULE(CONFIG_KVM)
+	void (*fn)(struct folio *folio);
+
+	fn = symbol_get(kvm_gmem_handle_folio_put);
+	if (WARN_ON_ONCE(!fn))
+		return;
+
+	fn(folio);
+	symbol_put(kvm_gmem_handle_folio_put);
+#else
+	kvm_gmem_handle_folio_put(folio);
+#endif
+}
+#endif
+
 static void free_typed_folio(struct folio *folio)
 {
 	switch (folio_get_type(folio)) {
@@ -108,7 +126,7 @@ static void free_typed_folio(struct folio *folio)
 #endif
 #ifdef CONFIG_KVM_GMEM_SHARED_MEM
 	case PGTY_guestmem:
-		kvm_gmem_handle_folio_put(folio);
+		gmem_folio_put(folio);
 		return;
 #endif
 	default:
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b2aa6bf24d3a..5fc414becae5 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -13,6 +13,14 @@ struct kvm_gmem {
 	struct list_head entry;
 };
 
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+void kvm_gmem_handle_folio_put(struct folio *folio)
+{
+	WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_handle_folio_put);
+#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
+
 /**
  * folio_file_pfn - like folio_file_page, but return a pfn.
  * @folio: The folio which contains this index.
-- 
2.49.0.rc0.332.g42c0ae87b1-goog


