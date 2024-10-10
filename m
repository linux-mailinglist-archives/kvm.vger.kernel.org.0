Return-Path: <kvm+bounces-28534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D6390999100
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A50B1F21E39
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9293B208229;
	Thu, 10 Oct 2024 18:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XJ5G74vA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BF41CDFD9
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584816; cv=none; b=C4J04NpSfFSe02vPTS0d/9/g0T2TTgysStzAO6xZUEcB3yd6IQxLjLGvgU+PQeu9VVDzjMJKrTOw6XQY9QDdDQJeo1TqGYI3/04eRzE/HXEkS/hPBA9t9N1hKgDIchQvx7m9VhWAMiD94XwqKH3WQsweE1Eg2mvY7Ik7J6UYJr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584816; c=relaxed/simple;
	bh=tUWxw/XFi5Jjw4MLGoQx4yzkrGK2c3j8OG0Ux9/pXvk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YSEZQ3TeJUwhlIk89XYp1FnJ+Yv7obOqEhsShzO1A1KA/I6kphGcxSLN1SySVHxfUzXCfM1UteHzPgshqNL4IhwM/PuvSausmVpF8gL2H690xbP8jv5KBrfiP9h34Mu5Z25BG3711/EKSqLKwMIYzOkjbwK5kx9DHUpXYzZ0Msw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XJ5G74vA; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e2e4874925so21257137b3.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584814; x=1729189614; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9PLNR7J7/StxhsadOj2FvapRbIqIfrDfQ6nFmhEUvk8=;
        b=XJ5G74vA5iAj8/LHLvdWEOyxWm1sfVqNq+jfgoUcBvu61bKrqTg0Rh5GOJLcTJf+Aq
         TL7FokBfV0aZSwz/KOejArh1F3p2bP0Yd44s9m4WX/lwCfKaHYxqgq5J8q0UCN1NNYda
         BH05WWr+Tayqa620VrfEhx9mjQLJkXQDcrwZGDsqxDGFZyd04Umi094470nxsXBb69Ur
         klYor8P+lwqKm5AFy3yGOCs8lPPDqjyRxQmoDgihuPO+cs/d0BqSVSdu7FrlZ3DPLEyd
         IdLqIfUnIN/c1Gy68qnUPzDojMCUIhUQknpkbfu0TTJvkhlb2kRKb2OlFqBihneknzCP
         bOKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584814; x=1729189614;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9PLNR7J7/StxhsadOj2FvapRbIqIfrDfQ6nFmhEUvk8=;
        b=nHIg+GQfoA5gD6yZfUCw2SdSrNQ/vrhn8iGYAjh90mRUKZ3K4agoZmd1xiO8Ah0Z12
         yHaknr1ryGpZvx0u18G8TCsNBpCZXB3iUsRrp7i1+hxYQCeY2D6bTFkOd52w4fBSnD3Y
         aVEj1azkIzYpjg9R7VGVvd3Yl5zQOMnj20kPNxTJUBaJ8mj6mk7MzYyj1BI0kpN87xK/
         WkDZrJcOkurvozPQ17BvlEOaWeUVhOT8QL1qZ08D0XSyC77Afxl+U9gWXAjCOgmicvo3
         wIHohadLgtwLLWuDFApmMnjDP7jnZNvFosxdO5lwggdsiTiY6Rhx2n2UYwhf/EzmrDyR
         7A7A==
X-Gm-Message-State: AOJu0YytgkdUhFpTQPua8LDvajZ9ZZ5S/VwLGntMvI1kRBpituDjpfQe
	StBLFXWsOG5IEo8ODrSKtHrn7VMVP7caxcX7WOMcZtzmZnx4oFKSYIrYtSjoJX1xtUbe4UYAoxT
	A5Q==
X-Google-Smtp-Source: AGHT+IFTz5/NgoL1lG2XSkf5pquU6CJl4M8l3x57mh4U7FbzzS84rW+oHIk+OXb87gKu92fZB4cgNqwOitE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:46c3:b0:6e3:21cf:a67f with SMTP id
 00721157ae682-6e32242fb5emr1006557b3.7.1728584814138; Thu, 10 Oct 2024
 11:26:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:59 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-58-seanjc@google.com>
Subject: [PATCH v13 57/85] KVM: RISC-V: Mark "struct page" pfns dirty iff a
 stage-2 PTE is installed
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

Don't mark pages dirty if KVM bails from the page fault handler without
installing a stage-2 mapping, i.e. if the page is guaranteed to not be
written by the guest.

In addition to being a (very) minor fix, this paves the way for converting
RISC-V to use kvm_release_faultin_page().

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Acked-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/riscv/kvm/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index b63650f9b966..06aa5a0d056d 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -669,7 +669,6 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		goto out_unlock;
 
 	if (writable) {
-		kvm_set_pfn_dirty(hfn);
 		mark_page_dirty(kvm, gfn);
 		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
 				      vma_pagesize, false, true);
@@ -682,6 +681,9 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		kvm_err("Failed to map in G-stage\n");
 
 out_unlock:
+	if ((!ret || ret == -EEXIST) && writable)
+		kvm_set_pfn_dirty(hfn);
+
 	spin_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(hfn);
 	kvm_release_pfn_clean(hfn);
-- 
2.47.0.rc1.288.g06298d1525-goog


