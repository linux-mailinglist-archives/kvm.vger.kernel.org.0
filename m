Return-Path: <kvm+bounces-27631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EC6E2988873
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 17:43:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56A91B21E01
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 15:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCC21C1743;
	Fri, 27 Sep 2024 15:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cajIMzwC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A507B18A959
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 15:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727451811; cv=none; b=a6PAcNX5c8iTxYdz7KxTQk2ETOtPXNHRobA+wip3/nFSCz8XbMRbqgPDRVSC+pq3hfk8gsn26O9kuwYV+lUmdQ3jJ/+O9gGCP1D1wG0QL9PADbN33ikYgekl/VgI/bDghpsyb9WvNHVt1PjFLK/B6UABMCrb8fxdCF1JV6EIod4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727451811; c=relaxed/simple;
	bh=wao8Y2iW8OXKF85bDNowoj/oRJn4i4qa0dhaPyUbYNY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ocx9EEthfdTu8GoZw3UXuzbjKhtYZBt8x/VV2e5A0cc4vV7TjtMDHpuvyxBNjVZczNZg4hcrI7Pw4W1eudiMNJQBHHGlVfzfuxQZRpcJUEbf/dN3N2RcBBj/sEDOn+Ig5DlCBPgXDNZxB5GxJIXEONN7i250Cs5HSa5pge3Q1dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cajIMzwC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727451808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nouy7uz2QZ2+HaiysQwlHSVDj7tghdV0IDOXlpVmzA4=;
	b=cajIMzwCZoEP/qT2xoR03VZc0sySFANgbbdPiLNoQZJWLbvv7vhpIRkESRCcgl9SLiiIkc
	4N6mNkCKgBctUA7gVsaJUUv+1wDe1m3ee9lQ3LWXvcE+ipNerGvY1UKuHf1GdsRUZyIK1M
	VcFWoVcPzfLGL9QrOFWpvNXfQXFL6PY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-l7epGVqNOMeVHMgMev7hNA-1; Fri, 27 Sep 2024 11:43:27 -0400
X-MC-Unique: l7epGVqNOMeVHMgMev7hNA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37cd1fb9497so954602f8f.1
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 08:43:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727451806; x=1728056606;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nouy7uz2QZ2+HaiysQwlHSVDj7tghdV0IDOXlpVmzA4=;
        b=W4hEyvq0qHN+S108Mw4cpaATBO6ibS9LFWbjupvDFKUYb81zwv+IkOpE1PsKSNZx7h
         DxtYyBX+XpnJIsaUl1reoJRqRGoSa/PisBUabHP7CLoYMuVsKGk2NsbawXJUfzcKTSHF
         Om5H6PtANQ8GFa0CuT9kGX0G9k6n5BkmJRgGDVS0NJzQ/WniXUAd8LiErDWZO8Muf1mJ
         QovWIcbNEWTKR97ddQ4Ojc5VpEN/sfZD4HdW5GPNFdXIwhh4nTRP5+7sweXkYFnxkds5
         tjOUfnwPwSTkI2qx9ZY92G5LH0Z9XRGEb8gW38HHwfWq6EKeDnf2LRU6ijwukf6q9euv
         X/Wg==
X-Gm-Message-State: AOJu0YykYi4y9i+CKJ/P0f81Elzdp1CRWWngw8D8KdHXP8DDq+hDRM84
	J5TrIPOCIlXHd5i9o+lVy+c2J0VcAzt1+Z0Couw/5vU/Cc/aDa6Tn6wudtu6mzIp6AIM8D5s5QH
	/ynxj2B9Nc6HwKzWsPtycqBTtU7J2cx4xLJSALrwPd5iIr6VVGw==
X-Received: by 2002:a5d:56ca:0:b0:374:c878:21f7 with SMTP id ffacd0b85a97d-37ccdb1bbb7mr4376510f8f.10.1727451805789;
        Fri, 27 Sep 2024 08:43:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVqcYDstIgaqNgteUNW6DY2/9r4otwnCXEY/6PGRPWd6daoj6Q1+FJy4cgu/qVmW0nz5LssA==
X-Received: by 2002:a5d:56ca:0:b0:374:c878:21f7 with SMTP id ffacd0b85a97d-37ccdb1bbb7mr4376497f8f.10.1727451805372;
        Fri, 27 Sep 2024 08:43:25 -0700 (PDT)
Received: from [192.168.1.174] ([151.64.88.92])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42e969ffc11sm78291925e9.24.2024.09.27.08.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2024 08:43:24 -0700 (PDT)
Message-ID: <de586a25-1ede-482a-8317-cb700be697b4@redhat.com>
Date: Fri, 27 Sep 2024 17:43:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/4] KVM: x86: Revert SLOT_ZAP_ALL quirk
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>
References: <20240927001635.501418-1-seanjc@google.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240927001635.501418-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On Fri, Sep 27, 2024 at 2:18 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Revert the entire KVM_X86_QUIRK_SLOT_ZAP_ALL series, as the code is buggy
> for shadow MMUs, and I'm not convinced a quirk is actually the right way
> forward.  I'm not totally opposed to it (obviously, given that I suggested
> it at one point), but I would prefer to give ourselves ample time to sort
> out exactly how we want to move forward, i.e. not rush something in to
> unhose v6.12.

Yeah, the code is buggy but I think it's safe enough to use code like the
one you wrote back in 2019; untested patch follows:

------------------------------- 8< ------------------------
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 27 Sep 2024 06:25:35 -0400
Subject: [PATCH] KVM: x86/mmu: fix KVM_X86_QUIRK_SLOT_ZAP_ALL for shadow MMU

As was tried in commit 4e103134b862 ("KVM: x86/mmu: Zap only the relevant
pages when removing a memslot"), all shadow pages, i.e. non-leaf SPTEs,
need to be zapped.  All of the accounting for a shadow page is tied to the
memslot, i.e. the shadow page holds a reference to the memslot, for all
intents and purposes.  Deleting the memslot without removing all relevant
shadow pages, as is done when KVM_X86_QUIRK_SLOT_ZAP_ALL is disabled,
results in NULL pointer derefs when tearing down the VM.

Reintroduce from that commit the code that walks the whole memslot when
there are active shadow MMU pages.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e081f785fb23..6843535905fb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7049,14 +7049,42 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
  	kvm_mmu_zap_all(kvm);
  }
  
-/*
- * Zapping leaf SPTEs with memslot range when a memslot is moved/deleted.
- *
- * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
- * case scenario we'll have unused shadow pages lying around until they
- * are recycled due to age or when the VM is destroyed.
- */
-static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *slot)
+static void kvm_mmu_zap_memslot_pages_and_flush(struct kvm *kvm,
+						struct kvm_memory_slot *slot,
+						bool flush)
+{
+	LIST_HEAD(invalid_list);
+	unsigned long i;
+
+	if (list_empty(&kvm->arch.active_mmu_pages))
+		goto out_flush;
+
+	/*
+	 * Since accounting information is stored in struct kvm_arch_memory_slot,
+	 * deleting shadow pages (e.g. in unaccount_shadowed()) requires that all
+	 * gfns with a shadow page have a corresponding memslot.  Do so before
+	 * the memslot goes away.
+	 */
+	for (i = 0; i < slot->npages; i++) {
+		struct kvm_mmu_page *sp;
+		gfn_t gfn = slot->base_gfn + i;
+
+		for_each_gfn_valid_sp_with_gptes(kvm, sp, gfn)
+			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+
+		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
+			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
+			flush = false;
+			cond_resched_rwlock_write(&kvm->mmu_lock);
+		}
+	}
+
+out_flush:
+	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
+}
+
+static void kvm_mmu_zap_memslot(struct kvm *kvm,
+				struct kvm_memory_slot *slot)
  {
  	struct kvm_gfn_range range = {
  		.slot = slot,
@@ -7064,11 +7097,11 @@ static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *s
  		.end = slot->base_gfn + slot->npages,
  		.may_block = true,
  	};
+	bool flush;
  
  	write_lock(&kvm->mmu_lock);
-	if (kvm_unmap_gfn_range(kvm, &range))
-		kvm_flush_remote_tlbs_memslot(kvm, slot);
-
+	flush = kvm_unmap_gfn_range(kvm, &range);
+	kvm_mmu_zap_memslot_pages_and_flush(kvm, slot, flush);
  	write_unlock(&kvm->mmu_lock);
  }
  
@@ -7084,7 +7117,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
  	if (kvm_memslot_flush_zap_all(kvm))
  		kvm_mmu_zap_all_fast(kvm);
  	else
-		kvm_mmu_zap_memslot_leafs(kvm, slot);
+		kvm_mmu_zap_memslot(kvm, slot);
  }
  
  void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
--------------------------------------------------

(Not too sure about using the sp_has_gptes() test, which is why I haven't
posted this yet).

With respect to the choice of API, the quirk is at least good for
testing; this was already proven, I guess.

Also I think it's safe to enable it for SEV/SEV-ES VM types: they
pretty much depend on NPT (see sev_hardware_setup), and with the
TDP MMU it should always be better to kill the PTEs for the memslot
(even if invalidating the whole MMU is cheap) to avoid having to
fault all the remainder of the memory back in.  So I think the current
version of kvm_memslot_flush_zap_all() is better than using e.g.
kvm_arch_has_private_mem().

The only straggler is software-protected VMs, which I don't care
too much about; but if anything it's better to make them closer to
SNP and TDX VM types.

For now I think I'll send the existing kvm/next to Linus and we
can sort it out next week, as the weekend (and the closure of the
merge window) is impending...

Paolo


