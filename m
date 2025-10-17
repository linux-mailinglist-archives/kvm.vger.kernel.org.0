Return-Path: <kvm+bounces-60245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BCB9BE5EAF
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 02:34:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A86AF6208D5
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 00:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D093241691;
	Fri, 17 Oct 2025 00:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vhrgDNyh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB48222A7E4
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 00:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661176; cv=none; b=KrHXqfRN+9ylyw3NVdNN740XVuGFjT/pGJ50dVNxWf6J6ww9ndF+l+9aCCmayIOzqoFO2+upigVyDvdevP8QO+5rqwYNNhhUgJsYUKSz4jhA+ToRP9kjg6AvxTDB8NeFRIOwLBL8xD7h9IfAmm8FJIarvdzHp2q5QkndoA8iujQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661176; c=relaxed/simple;
	bh=sDhYqOoM0kA/BE6wjd9QATnXbbERuSw/zd8xDCYAeAE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jCkhi9v7sqXYsk7CtJNVGZsdBvdxZEcpQ6pFQ/pBNfCNbSsM+aw3IkKqkZ54Rw+vmHaM8LQRRwMX3sxGW9qzAj+HCDsKLvi2+6X5BTm4T5a13+gCCS478cpw0ozbVS1pbh1p0A5mcZok1AO5xoHu23BTQH9f5PAE1D3zXrpx/40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vhrgDNyh; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb18b5659so1155876a91.2
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661174; x=1761265974; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ufVneY39YrbdCfRZpp0jVK1n9RSn66wnVA9SJtGGBdY=;
        b=vhrgDNyh+HntyeXmKCNtlmjQcYQuh41wFaS8THuiXv7h8VhIOYJigW7tHQFkK1qtZk
         cF3JFs/tRuYIYC0Vg+PueBh2U96Cx2/FfjcdCBaKZWBpXCLlGzWu1JTSFMs6QbL4/TYo
         CnBpwvr8/eU13IqJaQHAdPSc1OmEdbnjZorAfuzABbYHQMfaNOv2T1qxeRoFrFF/P1gd
         3Zqo2c4NEc6j/EoeRt9AIRt8FimCIY9tKuoCaRTKfXwhOEE2Aa2D6Czx7HhtiviFGDwF
         5Chq1MqvjrN7DgOliPDGnl6kP4O4qb6RZpHwUpspi6K6Nxpx7iXc4mFCKlc3D1wwB7Mj
         L0aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661174; x=1761265974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ufVneY39YrbdCfRZpp0jVK1n9RSn66wnVA9SJtGGBdY=;
        b=Z3JtQNpMMPocGLdh0IuWynh2m8y+zoELCTgNhOHoghWycU33xHw9JG8kM3rP0OrVrq
         QbXT3bYkJ/TR/ekZr5X6eNfnIEYFU1UZnA+BzKIm6cz/pq+V58Uz7Nkr7wHHWutn81rf
         7z24c9vVk/lxN0/Jt7VUS0lRggss/Iqz5dhVFGdZH5ikMrpQQT+okJt5E5meFbUYmk1P
         NMv7M5y6MSE44yaZe6J+g4blC3NNWOkEc6dL8EYn02ftYWTr5Y99VLxRSGEyJAdN+jvf
         n1kfBdkQy7te491CgIJupzV1aGeHJF3Mqbd9GicSHEPnVmUxTQMCtksv1oUyKFEHkVNb
         e2CA==
X-Forwarded-Encrypted: i=1; AJvYcCUtf05Bb1C8JPIgd6yyZ9YhIv3+hjyG48Wlt4v0Dw7tFGNb5glgAWU4hZl3u+J9lEnHBsc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcQ7zo16x9wN/4nEpaRWYybpe3tEu/2bWTJ2Hy78eYEGP0gFa6
	PZSpLXrCtJuKmNVcuKqZ9rKMvZvVyXODKf0L6utUIeXozOX/Wyk03kARLQln3K1ZqHJRzyEISvN
	CB2f1bw==
X-Google-Smtp-Source: AGHT+IGBsD40M1TCHpceHuTvrzQu31EsWCpow7sShvAnQiEKP0H9VSo9B6k/+Ftt8wsphMd8FgX3xhZLFrA=
X-Received: from pjop7.prod.google.com ([2002:a17:90a:9307:b0:33b:aa58:175c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2fd0:b0:32d:601d:f718
 with SMTP id 98e67ed59e1d1-33bcf8f9c16mr1675095a91.31.1760661173675; Thu, 16
 Oct 2025 17:32:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:21 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-4-seanjc@google.com>
Subject: [PATCH v3 03/25] KVM: TDX: Drop PROVE_MMU=y sanity check on
 to-be-populated mappings
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Drop TDX's sanity check that a mirror EPT mapping isn't zapped between
creating said mapping and doing TDH.MEM.PAGE.ADD, as the check is
simultaneously superfluous and incomplete.  Per commit 2608f1057601
("KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU"), the
justification for introducing kvm_tdp_mmu_gpa_is_mapped() was to check
that the target gfn was pre-populated, with a link that points to this
snippet:

 : > One small question:
 : >
 : > What if the memory region passed to KVM_TDX_INIT_MEM_REGION hasn't been pre-
 : > populated?  If we want to make KVM_TDX_INIT_MEM_REGION work with these regions,
 : > then we still need to do the real map.  Or we can make KVM_TDX_INIT_MEM_REGION
 : > return error when it finds the region hasn't been pre-populated?
 :
 : Return an error.  I don't love the idea of bleeding so many TDX details into
 : userspace, but I'm pretty sure that ship sailed a long, long time ago.

But that justification makes little sense for the final code, as the check
on nr_premapped after TDH.MEM.PAGE.ADD will detect and return an error if
KVM attempted to zap a S-EPT entry (tdx_sept_zap_private_spte() will fail
on TDH.MEM.RANGE.BLOCK due lack of a valid S-EPT entry).  And as evidenced
by the "is mapped?" code being guarded with CONFIG_KVM_PROVE_MMU=y, KVM is
NOT relying on the check for general correctness.

The sanity check is also incomplete in the sense that mmu_lock is dropped
between the check and TDH.MEM.PAGE.ADD, i.e. will only detect KVM bugs that
zap SPTEs in a very specific window (note, this also applies to the check
on nr_premapped).

Removing the sanity check will allow removing kvm_tdp_mmu_gpa_is_mapped(),
which has no business being exposed to vendor code, and more importantly
will pave the way for eliminating the "pre-map" approach entirely in favor
of doing TDH.MEM.PAGE.ADD under mmu_lock.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 326db9b9c567..4c3014befe9f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3181,20 +3181,6 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	if (ret < 0)
 		goto out;
 
-	/*
-	 * The private mem cannot be zapped after kvm_tdp_map_page()
-	 * because all paths are covered by slots_lock and the
-	 * filemap invalidate lock.  Check that they are indeed enough.
-	 */
-	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
-		scoped_guard(read_lock, &kvm->mmu_lock) {
-			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa), kvm)) {
-				ret = -EIO;
-				goto out;
-			}
-		}
-	}
-
 	ret = 0;
 	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
 			       src_page, &entry, &level_state);
-- 
2.51.0.858.gf9c4a03a3a-goog


