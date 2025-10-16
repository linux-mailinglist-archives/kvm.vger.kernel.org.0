Return-Path: <kvm+bounces-60219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D7BE2BE52C8
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 21:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C6B744F26F2
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C292561C2;
	Thu, 16 Oct 2025 19:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QqTGUXj6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715B3239E65
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 19:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760641616; cv=none; b=Jypruq9GLDWwZ3FFA/+n5JrkOQl1vqPK8I4aZJiulNpBBSrbmu6FfLHJZt2mWCB8SphcDsnn2Sv7XDfJj7rCmFn0KxcfRAxe+AwCgNEXM4Lpx8HMNbe+BZZyIWvVTfcKrP72LhsbteU8ZLogOwZNdJsJrObGWaG56sXJqsZAKnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760641616; c=relaxed/simple;
	bh=YBxESa1CpdXRaPWaeva+4lHFBA8rLlw/72FIwmffHyI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MDzsb4yZTXy2JW7EG5m5a6tFeNsqQwvgxS0++/OdYQUT2EkpGpaD0MsHFQdHr5Juz80pGL0roXLa6jC3agdCRH34Eh1GSNOyekrfK5Qs6uz0XQ8si+OHJHTvEWEWWyjMIJadcmYRTBlfdOKp4n62DmGLtXXZ11j8Qks3lmFMSgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QqTGUXj6; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-27c62320f16so12527255ad.1
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 12:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760641614; x=1761246414; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LABRqD9aUZpUjVf9UfWBC/peaZw13rHiQXEQ8T+Co+c=;
        b=QqTGUXj6Kvo5pGOCVucnTuR7nVHE+jW+cRQeqvEumQcV7kKPBEjpBX9r3exbpjJuoQ
         se/cu+I0639UX7lOKB4Zh/eMJpGUTtIbbSUiVELLNnI2RcmXiBrMWarrh0ErzDSllVV/
         vJTOm4lMMjwZJbDtcoy4kpu9vhH1TuxhrCk/uXt3lZ/HaFbL9DYgePOnkbiZvPJQ2Hs5
         P/8TollonBRepGzsqHqSw5uTYxf7d7NizJBodNuASBrBEBNFi8a7M8ORJnSmn0609Bm6
         iRTZLwhtL7DFkwxXVGeh/ktnnNMHsaXTQ9k1kewNTPdJPpI1pn/9JoETIkAJynv3L4hh
         0BaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760641614; x=1761246414;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LABRqD9aUZpUjVf9UfWBC/peaZw13rHiQXEQ8T+Co+c=;
        b=RAhr6bWQ4FQCGV3Bkn++LtKz2Mf116ZA75pZ3fWvBSACSuURpy/T25CQGNAULilfVc
         acVGYWJ//kEeNJnBo3SEsT9fyJbSYKRQEYUG6xnB+S5ZEZ/ZK7nBGoS0lHsWcZnzNFSl
         cvqieP8soZQSaog5TruB5UyiMvOJpwKsKntbFKO5okNfEqTA1JF36ioPibCpnLLkGN+r
         tNdfuB5agsZajMWm+s+BzWR0P4it1MTj5/UIGd8OQuCPGnccyDeuNp7hPadGM6bUTQCn
         YwnoBhHcrnRP4b1lu7NV4eLMXgaLIs1iptns6IGWoo+vC2LyEHiJX9CuCsvb3q17Zlko
         8b/w==
X-Gm-Message-State: AOJu0YyT3yL72pa3XBLW45U2kGpX7Z2ZuujowLk5fCT3pguh4KuKlbow
	wmvDe7zf+A6e6o4f7uSy+a/23yT3oOa+j7vnOJFEpf4vIAIeAj+quiKQk5zb2pnuVC+/26lij2B
	aPt144Q==
X-Google-Smtp-Source: AGHT+IHNkssHfRpTSPJv5vfJ0hG/avsJSbtPbn9niGhmFXN0nZWxcs3w1T94tFkiYA6sCa29Eo7CxIho5sU=
X-Received: from pjbge12.prod.google.com ([2002:a17:90b:e0c:b0:332:a4e1:42ec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e5c8:b0:27d:6777:2833
 with SMTP id d9443c01a7336-290cb18415emr11317135ad.47.1760641613662; Thu, 16
 Oct 2025 12:06:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 12:06:43 -0700
In-Reply-To: <20251016190643.80529-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016190643.80529-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016190643.80529-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: SVM: Make avic_ga_log_notifier() local to avic.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

Make amd_iommu_register_ga_log_notifier() a local symbol now that it's
defined and used purely within avic.c.

No functional change intended.

Fixes: 4bdec12aa8d6 ("KVM: SVM: Detect X2APIC virtualization (x2AVIC) support")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 2 +-
 arch/x86/kvm/svm/svm.h  | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3ab74f2bd584..89864fee6e83 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -216,7 +216,7 @@ static void avic_deactivate_vmcb(struct vcpu_svm *svm)
  * This function is called from IOMMU driver to notify
  * SVM to schedule in a particular vCPU of a particular VM.
  */
-int avic_ga_log_notifier(u32 ga_tag)
+static int avic_ga_log_notifier(u32 ga_tag)
 {
 	unsigned long flags;
 	struct kvm_svm *kvm_svm;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b0fe40c21728..8c36ee0d67ef 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -806,7 +806,6 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 bool __init avic_hardware_setup(void);
 void avic_hardware_unsetup(void);
-int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
 void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb);
-- 
2.51.0.858.gf9c4a03a3a-goog


