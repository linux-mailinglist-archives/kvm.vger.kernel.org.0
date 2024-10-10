Return-Path: <kvm+bounces-28542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C7A999118
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:46:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 250F82833CB
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7A4720C474;
	Thu, 10 Oct 2024 18:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SNuiX9KG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52750208212
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584831; cv=none; b=FsfTE07aMVza1eRZafDV/m43EEETVz/AuusnIrUbC8J1YvWEm27ccCi77iFHbLthL1QMkGI0isYhtb2LnyzJi7Jl0Mk0hx8TAf+HCvimhIcTn3y1XMUv6p2ZKWgWb09GG3sg7MNpMAknuEEnwoJBj7oX0FWPq9JDJIl9xIroeMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584831; c=relaxed/simple;
	bh=ffJ+Y8PQp+slQQo0S2lzOgDI6zSQ/cN8IdVD7ZeuwkM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WkwvcP2eNh7t3B3wVFxHm91r2l/yg5xQZc3mrWjzjHrj7OvJc1q63kSi0eEJxUWCZEOeI7UKZKbKpi6U1Z94iwe36uQwXa5u4Befnwm2ePFbjk8hfmAijsflZZHd479IujQJrJi7uDhXTRSdZ9EbR3aaIYii208v2lHP5zspU2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SNuiX9KG; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6c8f99fef10so1638333a12.3
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584829; x=1729189629; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0kIT1cNFK/xt59MDB/Io88ATgyMybLemEwY+DfOgUM8=;
        b=SNuiX9KGV9gd57zGcX+khtxMQ/WZyfcI8IOEqbUSxhtcMIlWJDhUZzOYw3O/Jtp5tp
         1NWu+kxo5Hi64N0d8Vocbim1DEDIN7pKYEMAT7CmUIRPux5M5gBhtwooiZa036V75h+k
         Ychu0Yrt+CY1DTpdXIkHOsKY0bGLGDYVFrglD82TfIlMDlvD77LbhWwQE2/GuTcCLoye
         BlO64+wQ9ljMZU5XEby944HMtp4M+bmKjEJdM7giaFb7OEfLYmaZJu6Xf8a4cSqRhdfW
         SsOXG0o6p9nmOEvzhsK039Qzqg4ApQUtgbICzcD04kyCCbohbJE5YCYQwAAz1ROtSzRt
         QapA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584829; x=1729189629;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0kIT1cNFK/xt59MDB/Io88ATgyMybLemEwY+DfOgUM8=;
        b=l4DPWiuWzQEQTLRjFy+IPZyWZ+v98e9pKJijv5JqfKzIOzjH7bsGP7w6hzCXhYB3VE
         nE/tqFk07DoIcTXGs5abJUOrG1n1vD1+z/ClTpwQZ1XdWE1ieTrdFARLlYEUYlWvO9t1
         PoKQ5s0+1VbgXKim+hJZ/PdNnt3FQULx03AGhZIYal7KKEhLvMJvf251XGmtdq+t5ekN
         /HUoYrl4dF4A2npPMaDYgalvS682BLUh/7Czt3M8lMDHkCs0+sD6qLiGogekSXtTDpKc
         414jptj822MZxoTznyReJLQ5eaxBnnjpptaUlGhBHut0AG23hdkqhT4Qx2zZw1yQGicN
         dX5Q==
X-Gm-Message-State: AOJu0YyT3kCXHefVhDSahiXXLZ//00nRnSUgQoAwlVPNPED5N8DB2g1u
	1+1c7f8XrM1NvLCxf7Hz8BQSRFiOJ7K0ikcCq2kim+0uzWlvhiWGe+1YQzjcsOSc7ueXF/8MMN/
	g3A==
X-Google-Smtp-Source: AGHT+IEVjHGN/ZoxQo+Z413816spxD1Vig97FmVkGQ57WYZx6k/7CY2I8TFVs2SPVm+Oq4UkGx7TgXf3+Fw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:903:192:b0:20b:bd8d:427a with SMTP id
 d9443c01a7336-20c6377ab7bmr1062205ad.5.1728584829203; Thu, 10 Oct 2024
 11:27:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:07 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-66-seanjc@google.com>
Subject: [PATCH v13 65/85] KVM: LoongArch: Mark "struct page" pfns dirty only
 in "slow" page fault path
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"

Mark pages/folios dirty only the slow page fault path, i.e. only when
mmu_lock is held and the operation is mmu_notifier-protected, as marking a
page/folio dirty after it has been written back can make some filesystems
unhappy (backing KVM guests will such filesystem files is uncommon, and
the race is minuscule, hence the lack of complaints).

See the link below for details.

Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/loongarch/kvm/mmu.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 28681dfb4b85..cc2a5f289b14 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -608,13 +608,13 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
 		if (kvm_pte_young(changed))
 			kvm_set_pfn_accessed(pfn);
 
-		if (kvm_pte_dirty(changed)) {
-			mark_page_dirty(kvm, gfn);
-			kvm_set_pfn_dirty(pfn);
-		}
 		if (page)
 			put_page(page);
 	}
+
+	if (kvm_pte_dirty(changed))
+		mark_page_dirty(kvm, gfn);
+
 	return ret;
 out:
 	spin_unlock(&kvm->mmu_lock);
@@ -915,12 +915,14 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 	else
 		++kvm->stat.pages;
 	kvm_set_pte(ptep, new_pte);
-	spin_unlock(&kvm->mmu_lock);
 
-	if (prot_bits & _PAGE_DIRTY) {
-		mark_page_dirty_in_slot(kvm, memslot, gfn);
+	if (writeable)
 		kvm_set_pfn_dirty(pfn);
-	}
+
+	spin_unlock(&kvm->mmu_lock);
+
+	if (prot_bits & _PAGE_DIRTY)
+		mark_page_dirty_in_slot(kvm, memslot, gfn);
 
 	kvm_release_pfn_clean(pfn);
 out:
-- 
2.47.0.rc1.288.g06298d1525-goog


