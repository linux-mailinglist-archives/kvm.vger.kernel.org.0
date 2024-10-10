Return-Path: <kvm+bounces-28540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D17C7999111
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:46:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81410282593
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B3920B1E3;
	Thu, 10 Oct 2024 18:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ooDlC/pc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B1320ADD0
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584827; cv=none; b=fgIN75Js3S/3Esh1cQozoSe4/UUuLlPIWzp0W96YcaWIeGXxKsAGphuZDNmCQuQylsbjnLtDH0+uIL/ZqiMBHNRt2acGVmwehVd0x+CV/SZlJwTnGcW8ThDVQv4VsZ0ZFz/NzCDpLOV2keFCbxthoFEXU3WxkOyVug3ynIOhJMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584827; c=relaxed/simple;
	bh=PLrYiBlw82beEM6tLfodLLTPBglt9VZ+TVoJtuJPFlg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oUAP0sW2jZ4Ldb5IpKHai+wGAYcY3x42BIlESZPay3j3B3K0JF0oiwyjBKehBz7+hPPHplX9CCx2F+9QZ9IcP2DD0ZBbeaaCeot+jAv0+XNIQppIBNxHQ+9Df8zs9cGnPzY3S3jUDUqdD9zl4kovP3r28fr0JluR7dJDsTFy9FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ooDlC/pc; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7e6af43d0c5so1109390a12.3
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584826; x=1729189626; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=I+2gp5vLlKRJWMtv7YF+IvP9h9YjJXEpCIK4AMigCis=;
        b=ooDlC/pcgIiD9tsIsdI/XR8hhjsKnl/ubOYfWwqTcVLjG/9/GB7swjVJDrSqoLoWOw
         7vkXEltPbHGSo6eNQSnfEV9KrL1bmyzVtt77RGsOKB4v9yqQdHB78U1BuZ/hIDzG2FZx
         cpC29Q8dE35bdHWwfpE6KKYut07InE+/YOzDqpcW4mYYCpTnffL1vL41QmzJeXlv5JSV
         Vy6UxPe1LGdKUb6imMlvnN/L7ACFiPOGAu0qVfgVxbFsbFAK29wlRNmnvUlIrLTo62bY
         1kZmPlVjpXSazX1NzmqGpjSByYskWop3ZgGxIZFVYyv/jRa6XYdaRoFScRBxFJa6oghl
         JhXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584826; x=1729189626;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I+2gp5vLlKRJWMtv7YF+IvP9h9YjJXEpCIK4AMigCis=;
        b=XeOTltGQRtHvEkGAoTNmE6w2xsM3eOG2HnIb/pCyaj4u02BPT/O7MRISSTzIkKiJdI
         BtnhkISbcgqvQQLpDKPAF88d9BrQBdIzrGBp9NZrabKniCqW4CqOKCJSDD/XLAY0aYZR
         FjaN9U5cKhpkRNJX54p0QkLGxP0hRjp7x2wO9aXegrvypjKZY6h1fE2qwfjURiw/p1G6
         vZ3Q5qCuxkXl57LhOsFmD/atW35i2PsYHVmAyus8CL1rpnYuy0PluKkkXsE9YksoW+oK
         uM8EL3q3kHmpDp7eYKq3AzthGOVRMUVJ0r+fwKC/AxAV/xVYRBd3eB8Ce/l0yP0SYM/s
         Cebw==
X-Gm-Message-State: AOJu0Yy9QE5ha4DTH2O7z0rUX8m67ZjP7q1oclzL2PISeETQTSZGwK7V
	gsgt/dyom2lrwLS/iaDByOsdXcxE/e4EKtSZByEq88eh12RuINGDrJbYeqJsM0tNsm7jnr7r230
	y2Q==
X-Google-Smtp-Source: AGHT+IEBzxfSdV5URAWtipQSxApJSdWqJAcjcFibIBQs32g4G2eVPMYjVJgo5zFwBPuTEySHq4oumcdrCOE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:e546:0:b0:684:6543:719 with SMTP id
 41be03b00d2f7-7ea535307afmr40a12.4.1728584825522; Thu, 10 Oct 2024 11:27:05
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:05 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-64-seanjc@google.com>
Subject: [PATCH v13 63/85] KVM: PPC: Book3S: Mark "struct page" pfns
 dirty/accessed after installing PTE
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

Mark pages/folios dirty/accessed after installing a PTE, and more
specifically after acquiring mmu_lock and checking for an mmu_notifier
invalidation.  Marking a page/folio dirty after it has been written back
can make some filesystems unhappy (backing KVM guests will such filesystem
files is uncommon, and the race is minuscule, hence the lack of complaints).
See the link below for details.

This will also allow converting Book3S to kvm_release_faultin_page(),
which requires that mmu_lock be held (for the aforementioned reason).

Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_64_mmu_host.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_host.c b/arch/powerpc/kvm/book3s_64_mmu_host.c
index bc6a381b5346..d0e4f7bbdc3d 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_host.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_host.c
@@ -121,13 +121,10 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 
 	vpn = hpt_vpn(orig_pte->eaddr, map->host_vsid, MMU_SEGSIZE_256M);
 
-	kvm_set_pfn_accessed(pfn);
 	if (!orig_pte->may_write || !writable)
 		rflags |= PP_RXRX;
-	else {
+	else
 		mark_page_dirty(vcpu->kvm, gfn);
-		kvm_set_pfn_dirty(pfn);
-	}
 
 	if (!orig_pte->may_execute)
 		rflags |= HPTE_R_N;
@@ -202,8 +199,11 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 	}
 
 out_unlock:
+	if (!orig_pte->may_write || !writable)
+		kvm_release_pfn_clean(pfn);
+	else
+		kvm_release_pfn_dirty(pfn);
 	spin_unlock(&kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
 	if (cpte)
 		kvmppc_mmu_hpte_cache_free(cpte);
 
-- 
2.47.0.rc1.288.g06298d1525-goog


