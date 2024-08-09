Return-Path: <kvm+bounces-23798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ADF5394D7B6
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:51:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 597411F21571
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA5FC168493;
	Fri,  9 Aug 2024 19:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gDUa+LhR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com [209.85.222.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783BC168487
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723233006; cv=none; b=kHGvyIqQXG2MxX3liwqAaO+58XwOqZ8qCvDz75uY9QECzIyU02V23prt6SYnNgb/md97YOX+H3n/Q66kkjHmHBQGOIz1NsGE55QL+jBhvg9TUf3kc9uR4GI83OWV8rNkR4HAZ/VL4OwEGsnefxAe2dIR4Rz/fSH84z80+SFeDGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723233006; c=relaxed/simple;
	bh=3xSCN07is/d7+9qa5tb05xLdmkaS8Uh8BYF+HVNaYMo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N/LU2wrByjNf7Ns0UCavkDtTuH0MPfqqTMlQUVEFvDxfk1qFOGJyWMlNfyIA4QviKCquu18VAjCZKNxeLGrGy/f53awVQS2OkHG9ri93RnDbMBXKaot7eMY4BNC55S/u06hb1y7bHwvWgksBwD3o7LsBIxlDq/ZVgEmn2pmMyU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gDUa+LhR; arc=none smtp.client-ip=209.85.222.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-qk1-f201.google.com with SMTP id af79cd13be357-7a1d71b96c4so291395185a.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723233003; x=1723837803; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C/Kjdpw4GZGWgN0ZxVg8kngRskxTTrucp/2D4JfCR5g=;
        b=gDUa+LhRd+dlWZY5BBv6+kvl4gNb5yOeGvj1k0Om3jIN08z8k+iFlaJ8JNnmFoiSeV
         DOGlvR/N21/BYPKpwUALRB6sTs4usz6grYzWchQA/1gxeqLHeVAmfDEucouIPBY06yaV
         5Dol41TUCL0cq/COjQ4rPMD0Hvcy+kHISBLUnMTQSZztFL8wg87hzwjsTotbrMtqIHbh
         z4CxWHHIhobLoDA/pmVphyPE5vO8bPpVcpICJTdWB2nqnUh+xXnel9zJ5kIDm6FLg8FH
         tTJ+xf+hHHrAGJYSn7YZgnThUDw1gENJ9Q6eRZHjFMJ6rMJYUH1cVCqtKKZ1WwpeXS4n
         dNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723233003; x=1723837803;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C/Kjdpw4GZGWgN0ZxVg8kngRskxTTrucp/2D4JfCR5g=;
        b=JsdYzrajUOBPZW3+SG0IubX316Ko9KwK+Ay+tOnO6/CYBgaivYO6gyO3gOK/1dEtAS
         OGQe9GN8ZvSh5pNADgE4RPog6UBZZsk2bp9XY0uTpMkmDHBhdKvq7CThBtJ+9GBLc9OB
         j+0S7MPmhxvGulc1PwHfo3IMmm2PewykUMAoGGHTfTgRd05UDCYdytlLdstji9Mmdzdq
         TrTcMEo6Q0jJgbAwJpb0ee8cTzs5acj8Bu5aJJASvoKJwJGTHAFfrIAAnjNkGi6wl5A5
         AxM/Iv3M7D91clbzDSHaz/7DzKaDSX26qe2TgkOLOnZoXhE2N2VgrAvLTYBISu9zbCYz
         QOVQ==
X-Gm-Message-State: AOJu0YxwPm6GQ+9gTLkXwoHBfKsUY4m3LeLlBjzKRtKWf2+OZqiglafS
	nZF6jxlPaRY5YkgIDVLTg0e3KTBNesUDffw7n4m5At76lBY1UCPEGVbUMC2j8KR1FuEFHbu2EjB
	bnQ==
X-Google-Smtp-Source: AGHT+IHlnphgTRNzeVdx0O31fPI0LuneFaWMABXGnKSnF6B8xUcCs6tohBFzlE1Hi/BkKbGcyYXHhyb9HbY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d507:b0:1fc:2ee3:d46c with SMTP id
 d9443c01a7336-200ae2549b2mr2179795ad.0.1723232644737; Fri, 09 Aug 2024
 12:44:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:43:25 -0700
In-Reply-To: <20240809194335.1726916-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809194335.1726916-14-seanjc@google.com>
Subject: [PATCH 13/22] KVM: x86/mmu: Honor NEED_RESCHED when zapping rmaps and
 blocking is allowed
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Convert kvm_unmap_gfn_range(), which is the helper that zaps rmap SPTEs in
response to an mmu_notifier invalidation, to use __kvm_rmap_zap_gfn_range()
and feed in range->may_block.  In other words, honor NEED_RESCHED by way of
cond_resched() when zapping rmaps.  This fixes a long-standing issue where
KVM could process an absurd number of rmap entries without ever yielding,
e.g. if an mmu_notifier fired on a PUD (or larger) range.

Opportunistically rename __kvm_zap_rmap() to kvm_zap_rmap(), and drop the
old kvm_zap_rmap().  Ideally, the shuffling would be done in a different
patch, but that just makes the compiler unhappy, e.g.

  arch/x86/kvm/mmu/mmu.c:1462:13: error: =E2=80=98kvm_zap_rmap=E2=80=99 def=
ined but not used

Reported-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4016f63d03e8..0a33857d668a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1453,16 +1453,10 @@ static bool kvm_vcpu_write_protect_gfn(struct kvm_v=
cpu *vcpu, u64 gfn)
 	return kvm_mmu_slot_gfn_write_protect(vcpu->kvm, slot, gfn, PG_LEVEL_4K);
 }
=20
-static bool __kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_hea=
d,
-			   const struct kvm_memory_slot *slot)
-{
-	return kvm_zap_all_rmap_sptes(kvm, rmap_head);
-}
-
 static bool kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			 struct kvm_memory_slot *slot, gfn_t gfn, int level)
+			 const struct kvm_memory_slot *slot)
 {
-	return __kvm_zap_rmap(kvm, rmap_head, slot);
+	return kvm_zap_all_rmap_sptes(kvm, rmap_head);
 }
=20
 struct slot_rmap_walk_iterator {
@@ -1597,7 +1591,7 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
 				     gfn_t start, gfn_t end, bool can_yield,
 				     bool flush)
 {
-	return __walk_slot_rmaps(kvm, slot, __kvm_zap_rmap,
+	return __walk_slot_rmaps(kvm, slot, kvm_zap_rmap,
 				 PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL,
 				 start, end - 1, can_yield, true, flush);
 }
@@ -1626,7 +1620,9 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_=
gfn_range *range)
 	bool flush =3D false;
=20
 	if (kvm_memslots_have_rmaps(kvm))
-		flush =3D kvm_handle_gfn_range(kvm, range, kvm_zap_rmap);
+		flush =3D __kvm_rmap_zap_gfn_range(kvm, range->slot,
+						 range->start, range->end,
+						 range->may_block, flush);
=20
 	if (tdp_mmu_enabled)
 		flush =3D kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
--=20
2.46.0.76.ge559c4bf1a-goog


