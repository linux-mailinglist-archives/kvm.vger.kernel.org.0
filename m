Return-Path: <kvm+bounces-58083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15AD4B877B2
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A78DC1C24AA2
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73819247284;
	Fri, 19 Sep 2025 00:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1Muxm8NI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AACF23ED5B
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758241998; cv=none; b=my9uncWYcyTyfXJcel5MWsKLrFtIyjOouvASd4XR39ySeBFT6tNjThqK3/bxLmspOZi4NFp0GPPE7zPPAiyKPVm6gn8qUfIIF2z2NuuayjrMzJ+Nv2EKKnVhWXQ+S4rUDyhYzaWnUF6n7Fe9Zrt+XkYCOMSbKUrnU6JbhpY2Uj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758241998; c=relaxed/simple;
	bh=m6dZI+ZwLyJuMwFLGjc1a+3t+gzyy/UmgZ+fCf2theI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=idf+LKdNSN8lrTIV0U9zkWulVCBXpHjWaGMGp96pPpELMj5fjfgRCTSUwCL7jsc7QtoM2bEU8hnlJczNPSo85WlrZuMaV1JmwRwJJzDC9kfZYTSBEYsfRJkQPt1+9iW2YwuWGOTJ/6noErsgYTZ7Iy6wJNY9jD7FKLSWL6gfX+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1Muxm8NI; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32e09eaf85dso1838708a91.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758241996; x=1758846796; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tMuCCcykP7UyXODG1nuaeEehr/fAveTIKF4KZJ2JmiU=;
        b=1Muxm8NI7RHKOTd4QACW8HQP0tBNeUW3j7PCWux+Km8kSHYB9V2iinGlXfgYTJdYtG
         nKSQdbOqf+EcitVX21CghDQpulyKTRmApW4OgMHAhltzIIQnNRpLVwe7Aj1dD3RLIy/J
         zLTad9Le+Zr62TNBMwYLcO8I2P+7qZLvfA7XO8dcmmqvOhrXsnoXGkopr4HBI6We+zuv
         x/oGE6wkurO4cKWt0kwyBpyBkT9sRisF2TEAQ7LxBnifu4T3E3CbQD74ELsq1J4MX+Bl
         pZvwS6bA+SoI9+0KAhwH+GIT82Ay1dhVecNiDp+50xBf/XLvOJ8bVm2S6dv/Tbw0iJMs
         lQ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758241996; x=1758846796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tMuCCcykP7UyXODG1nuaeEehr/fAveTIKF4KZJ2JmiU=;
        b=iAydfkqCBd1/Zx0wZbJzmfZj4+aSVHtGW4uchAr4LNtl1EEFYQp1zlb4tJpqrMsEzG
         RdP22PGaAdRN5r0WCcrWPzlDqng8LKEuxYD3Tr8njnTm9kN18DO4eRc9X6N/bN0iasxW
         T/iw+qnhmHoMvhcBME3e3emcNQiz2NqFC8obm8Qpe3TFNUddES8HddBlkBAOui2X+Evk
         1GLLnZOE3wBwZ6fkkW+gSTl+BO7iiLO/+jnv/IP8YqbiZgFcRBhZq7Pdi966VPXUaV4K
         FlKgFCUr+RB43gjRt9q6WpQkStG9TfQmmK2GS5xnHE3Jjg+3ihlQic2ghvdnzOB5F74H
         0TOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlEjjitD2RMHNp++I46u4v06jXKOsGDUF8cdi3u/LvvP3eOgLYGwAQezhTIiMcFFrzgoU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUun6RsilGoOUI8qOeiaXTqvc5VLvZosmJ8ATIJrorSWKwcaxp
	clDJnWy9W3pxoqSJVQ7sVAb9yC0vY7CcnkfSsUVGN9LeCXaFUg/65R04ymE722kZOBcfXnD9gY2
	dE8mecg==
X-Google-Smtp-Source: AGHT+IFzlv5dXL7dtF1e+eMqZ1ge+J+8LQ3uyWOVWDPWtrQZD4mZKX7IbeJApn+FgKkV2SAzI1W4lLt65x4=
X-Received: from pjbok3.prod.google.com ([2002:a17:90b:1d43:b0:330:8b1f:c4e7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:bd87:b0:250:5ff5:3f4b
 with SMTP id d9443c01a7336-269ba467e97mr13530515ad.15.1758241996301; Thu, 18
 Sep 2025 17:33:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:32:59 -0700
In-Reply-To: <20250919003303.1355064-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919003303.1355064-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919003303.1355064-2-seanjc@google.com>
Subject: [PATCH v2 1/5] KVM: s390/vfio-ap: Use kvm_is_gpa_in_memslot() instead
 of open coded equivalent
From: Sean Christopherson <seanjc@google.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Tony Krowiak <akrowiak@linux.ibm.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>, 
	Harald Freudenberger <freude@linux.ibm.com>, Holger Dengler <dengler@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Use kvm_is_gpa_in_memslot() to check the validity of the notification
indicator byte address instead of open coding equivalent logic in the VFIO
AP driver.

Opportunistically use a dedicated wrapper that exists and is exported
expressly for the VFIO AP module.  kvm_is_gpa_in_memslot() is generally
unsuitable for use outside of KVM; other drivers typically shouldn't rely
on KVM's memslots, and using the API requires kvm->srcu (or slots_lock) to
be held for the entire duration of the usage, e.g. to avoid TOCTOU bugs.
handle_pqap() is a bit of a special case, as it's explicitly invoked from
KVM with kvm->srcu already held, and the VFIO AP driver is in many ways an
extension of KVM that happens to live in a separate module.

Providing a dedicated API for the VFIO AP driver will allow restricting
the vast majority of generic KVM's exports to KVM submodules (e.g. to x86's
kvm-{amd,intel}.ko vendor mdoules).

No functional change intended.

Acked-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/include/asm/kvm_host.h  | 2 ++
 arch/s390/kvm/priv.c              | 8 ++++++++
 drivers/s390/crypto/vfio_ap_ops.c | 2 +-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index f870d09515cc..ee25eeda12fd 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -722,6 +722,8 @@ extern int kvm_s390_enter_exit_sie(struct kvm_s390_sie_block *scb,
 extern int kvm_s390_gisc_register(struct kvm *kvm, u32 gisc);
 extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
 
+bool kvm_s390_is_gpa_in_memslot(struct kvm *kvm, gpa_t gpa);
+
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
 					 struct kvm_memory_slot *slot) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 9253c70897a8..9a71b6e00948 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -605,6 +605,14 @@ static int handle_io_inst(struct kvm_vcpu *vcpu)
 	}
 }
 
+#if IS_ENABLED(CONFIG_VFIO_AP)
+bool kvm_s390_is_gpa_in_memslot(struct kvm *kvm, gpa_t gpa)
+{
+	return kvm_is_gpa_in_memslot(kvm, gpa);
+}
+EXPORT_SYMBOL_FOR_MODULES(kvm_s390_is_gpa_in_memslot, "vfio_ap");
+#endif
+
 /*
  * handle_pqap: Handling pqap interception
  * @vcpu: the vcpu having issue the pqap instruction
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 766557547f83..eb5ff49f6fe7 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -354,7 +354,7 @@ static int vfio_ap_validate_nib(struct kvm_vcpu *vcpu, dma_addr_t *nib)
 
 	if (!*nib)
 		return -EINVAL;
-	if (kvm_is_error_hva(gfn_to_hva(vcpu->kvm, *nib >> PAGE_SHIFT)))
+	if (!kvm_s390_is_gpa_in_memslot(vcpu->kvm, *nib))
 		return -EINVAL;
 
 	return 0;
-- 
2.51.0.470.ga7dc726c21-goog


