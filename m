Return-Path: <kvm+bounces-60256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B97D2BE5F12
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 02:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8FE154FC411
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 00:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B30521ADCB;
	Fri, 17 Oct 2025 00:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z+TNYbQG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4981628B407
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 00:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661195; cv=none; b=LQPnblOBqT5a9eazfNiYUmAW8zf+wOrfboEByGiAvbnv37ctkxvcSvoo1Hn2GTR+GCEBYW6ThtOrRE/XC+9su1Wu5QkGrP9eF6Z5tq4CiQv9N1DZxMmRXD2h/LzLV0L5TNQouwQlO7WOH8UgqSEt4W0q/bXtGVZF3uITvFvI3hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661195; c=relaxed/simple;
	bh=3YQMVIXe/PWDNcoPwZMoZ+T0ntV4ZtND1X6btyfkyHo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ct/DtC7vKjUiD6omfAR/vS9EH2xEHTv0oDXR5XOPpZuCMJ1o1/Rs3dmS2Wg5RIBWgmK1lVCQtRQMSt8nDz5ypqVuvK3UBnxL76XvZY51JJPvcooA27zUe29tqxGSr9Elme0Pmd6hHSURyRTXM6oyLikv9GYSfmK5Vp4HDB4cQMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z+TNYbQG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb18b5500so2174589a91.2
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661193; x=1761265993; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yGJSKqxu0aNpKU4CMPi7Ju9DUaCLFSD0JC8SLGhbfdI=;
        b=Z+TNYbQG2H1cly4Y0BEjtql8btk8zR56Sa6JfdkTCLqFr29mP+NpN1lUv86b8pXFci
         gVIkvkdZ0Mu/vDz0lTv0yMq38ojLQzZzQopvIM/pxwdL3bcw3be8cqBtkim0dYllW3xI
         YqfNVDYW9/LfaJvjbndtWsnLe3joPJ5Ahm9mWGQOQst2rF0F55YX4k77TDL0TS3A5p3f
         EJUb+XNJDTZC1tauas/7VPA0DG2bGKlmLghalUKpnaiHG+xqjiJkLzM60B5mzFhgbf/q
         S9FU8nkjwTrTomiAaFeUhjhxdtp8RS9SPdOOaKPprqnTWSFZ6Ql2rMUHW0kKQl2M26R3
         yyTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661193; x=1761265993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yGJSKqxu0aNpKU4CMPi7Ju9DUaCLFSD0JC8SLGhbfdI=;
        b=LajdJ9+UasnuHuZuOxXiP31eLkNzjf2e0dTh3XpBaiWUbmYyl2vHIydMYcGCpt5dcD
         aVs1C1OtP5RJSKYxZ94GVB/iFcgTOKhZeLFFlQmVXjTdyYC45lO7GGh3udpnzyVh9WzB
         yJNC47M2NjSoGYeaSTY8eitSIzyhZ2EdGBs6lP3+g4NLpwRYHpOvRKj4b97sjikMnlei
         FdbF1QLi5qkSH68jVdD4wWuH+SeQtJuoJWhiE/3iVTMZTZ0O+VVb2r5pAEZuEf/B2AWv
         fMr8c4JVJPTVBOqnXqcYj3siie6vJNJcXAfMaay/jUY9PVH33vi5RxrL5K4KW8VBe/1Z
         18Xg==
X-Forwarded-Encrypted: i=1; AJvYcCXZ2nR10QM02vBbfRUNqwhqBluEDNmDhQYhR5tsNpRQGJy27aHJVSU0w3uKAa3w0DPkLJI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrulQdmeHNGFX/JCrPHOUFvF5rGfF8MDKNL75hm5lUuxuxdU/v
	nrnlxrljTQVWiSdMbhz+hejLlldwPaBMoi8R95eJtDuCTP05YaXhspHVF2W0N9en/uctMaqODd0
	O9oiZiQ==
X-Google-Smtp-Source: AGHT+IHjaZ2dKb3gnqjzbrezKxoV9F/Lq4sC9R35D07gH2vTOnVl3FqHgnrEtTPEkkZOYMNEYP5euQorQsk=
X-Received: from pjtu8.prod.google.com ([2002:a17:90a:c888:b0:32b:58d1:a610])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c05:b0:339:ec9c:b275
 with SMTP id 98e67ed59e1d1-33bcf84e181mr2234528a91.6.1760661192796; Thu, 16
 Oct 2025 17:33:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:32 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-15-seanjc@google.com>
Subject: [PATCH v3 14/25] KVM: TDX: Bug the VM if extended the initial
 measurement fails
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

WARN and terminate the VM if TDH_MR_EXTEND fails, as extending the
measurement should fail if and only if there is a KVM bug, or if the S-EPT
mapping is invalid, and it should be impossible for the S-EPT mappings to
be removed between kvm_tdp_mmu_map_private_pfn() and tdh_mr_extend().

Holding slots_lock prevents zaps due to memslot updates,
filemap_invalidate_lock() prevents zaps due to guest_memfd PUNCH_HOLE,
and all usage of kvm_zap_gfn_range() is mutually exclusive with S-EPT
entries that can be used for the initial image.  The call from sev.c is
obviously mutually exclusive, TDX disallows KVM_X86_QUIRK_IGNORE_GUEST_PAT
so same goes for kvm_noncoherent_dma_assignment_start_or_stop, and while
__kvm_set_or_clear_apicv_inhibit() can likely be tripped while building the
image, the APIC page has its own non-guest_memfd memslot and so can't be
used for the initial image, which means that too is mutually exclusive.

Opportunistically switch to "goto" to jump around the measurement code,
partly to make it clear that KVM needs to bail entirely if extending the
measurement fails, partly in anticipation of reworking how and when
TDH_MEM_PAGE_ADD is done.

Fixes: d789fa6efac9 ("KVM: TDX: Handle vCPU dissociation")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c37591730cc5..f4bab75d3ffb 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3151,14 +3151,22 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 
 	KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm);
 
-	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
-		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
-			err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry,
-					    &level_state);
-			if (err) {
-				ret = -EIO;
-				break;
-			}
+	if (!(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
+		goto out;
+
+	/*
+	 * Note, MR.EXTEND can fail if the S-EPT mapping is somehow removed
+	 * between mapping the pfn and now, but slots_lock prevents memslot
+	 * updates, filemap_invalidate_lock() prevents guest_memfd updates,
+	 * mmu_notifier events can't reach S-EPT entries, and KVM's internal
+	 * zapping flows are mutually exclusive with S-EPT mappings.
+	 */
+	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
+		err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry, &level_state);
+		if (KVM_BUG_ON(err, kvm)) {
+			pr_tdx_error_2(TDH_MR_EXTEND, err, entry, level_state);
+			ret = -EIO;
+			goto out;
 		}
 	}
 
-- 
2.51.0.858.gf9c4a03a3a-goog


