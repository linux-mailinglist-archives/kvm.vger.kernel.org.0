Return-Path: <kvm+bounces-53696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA369B15596
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 01:00:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F125956141C
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 23:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16AA02D1301;
	Tue, 29 Jul 2025 22:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d9Ym5cDb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03BB2C327C
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829761; cv=none; b=UgNR5WJJcCdeuqVS+e0SnmWhHFWZUpSitQrR1PHOXfx3poTYezude6Sgm+RlP0cAV0DjEBnmrET9ZX0Z77R4ObR6+AX44BImmFZNz+tENme+XqnQV3g1GBq56rjrXHo3uSQTCQLGZs0jpxXvVL3mTpuFifvStFxk3O5xrI4az0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829761; c=relaxed/simple;
	bh=tSmg9vevb3jqaRkYY5Aaxyc4WM6Wx1gkdAMDVUweHc0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HpRX4xdkma0hpgN5paJ470I80IpPbTMtMX2PrC92d6RKTi80c9GGw7UH+aF9X7yaQ+N8QI0DyXvB/YqLGfPaSYZwJDxwJTERXjmraRuwYtRx1c1aAP26r8fy6FqE47WnzwpPz472D3rzKHE7wwhYvzJUs1LQ92zYTgAyyIaXgRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d9Ym5cDb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313d346dc8dso10559657a91.1
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829759; x=1754434559; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zsUJ7ZFybSscOwB+F/7yDFweXn/Ii9vNr67NR9vaee0=;
        b=d9Ym5cDbs7fWqK8y0va9sMhiJz9HWxKDpkD3oHqYVKUdzWSxLx0F21Do4mfQgy4JjG
         6WMV0w6p08tsxqf0BdwO8l4Nz4rfTxIDJAX3Kvra0PgPeAJEasRzNtzJZq87yMXHCcIc
         iBtQ9pwrHmMbE99/4YFneaH8GAIBKJbUbt+q9hA/Pc9e5FkJLXMzOSXyxwDMk/D4RVxc
         tkVlsNlPrd/GMomRvcdlU8yUtHPgCerqI9Tnou3AOoTq5C4x+9jd4SE2X/gXbQzAMrZp
         r7rGUApfxTPyH2hc9ZVvi7XF3wJSQf15dY3+1HgJwaf6/y3IRcbR9NbrKs3Tu9ZXWobL
         7OMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829759; x=1754434559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zsUJ7ZFybSscOwB+F/7yDFweXn/Ii9vNr67NR9vaee0=;
        b=txJ0fg6+MaSBRRRZLyQ0ehNAUwGy2hEI6sGBeLGEKInLy1vG7m1vXZcA+2CYhgNKSp
         TQZw+W1OmM1S0/qTS7+CQLN7Q1QX4otYajYp9U1j2NbjooSQB+YBNgIx0SkU9R473rs/
         TifEa+lamLIc3gyY/lgUxdvltnObhvE/3kAjbjhc1ilH0/0Tsu5fT8HM27MUQZGykdta
         RLrwr2GCHcis5pW+4e0q+n7r/MhWQknuD7OlQhp2yaVkMRjA7/yYLcpFI4BnaGvF1a7b
         ao7PoKab833WRt+Xm1WbyHHNPat//ziwMI+gADWAc8Oyj7frfblTBvXLCVu59IxtyRCQ
         NHcA==
X-Gm-Message-State: AOJu0YzPnMyXZJrpqTxxDDAZ0IZDeOMLLesY4TcPBDqKSZ7/T43hpmol
	vEirai+24zkAnWM9n2sNsIal60P7BkFvejS6SIIPy/HP3KLgbUB+V50/NFz5BKmGBgt/S//t6ht
	74rlA+g==
X-Google-Smtp-Source: AGHT+IEUawy8XEGsXpdKDRLNNEWp47UfSJOlj3wwR4Kg29zUXO4HT9ko5KQTWasgzc65ODEqhN4o5kIR7eM=
X-Received: from pjsk9.prod.google.com ([2002:a17:90a:62c9:b0:311:462d:cb60])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d604:b0:31f:3029:8854
 with SMTP id 98e67ed59e1d1-31f5de5561dmr1600493a91.27.1753829758931; Tue, 29
 Jul 2025 15:55:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:47 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-17-seanjc@google.com>
Subject: [PATCH v17 16/24] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Update the KVM MMU fault handler to service guest page faults
for memory slots backed by guest_memfd with mmap support. For such
slots, the MMU must always fault in pages directly from guest_memfd,
bypassing the host's userspace_addr.

This ensures that guest_memfd-backed memory is always handled through
the guest_memfd specific faulting path, regardless of whether it's for
private or non-private (shared) use cases.

Additionally, rename kvm_mmu_faultin_pfn_private() to
kvm_mmu_faultin_pfn_gmem(), as this function is now used to fault in
pages from guest_memfd for both private and non-private memory,
accommodating the new use cases.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
[sean: drop the helper]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e83d666f32ad..56c80588efa0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4561,8 +4561,8 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				 r == RET_PF_RETRY, fault->map_writable);
 }
 
-static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
-				       struct kvm_page_fault *fault)
+static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
+				    struct kvm_page_fault *fault)
 {
 	int max_order, r;
 
@@ -4589,8 +4589,8 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 {
 	unsigned int foll = fault->write ? FOLL_WRITE : 0;
 
-	if (fault->is_private)
-		return kvm_mmu_faultin_pfn_private(vcpu, fault);
+	if (fault->is_private || kvm_memslot_is_gmem_only(fault->slot))
+		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
 
 	foll |= FOLL_NOWAIT;
 	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
-- 
2.50.1.552.g942d659e1b-goog


