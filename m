Return-Path: <kvm+bounces-53655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F76B15242
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 19:44:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6EBB3BC6F4
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 17:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58A4429B22D;
	Tue, 29 Jul 2025 17:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="guImVWIq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBC829A9FE
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 17:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753810972; cv=none; b=hxJYjuceS+WH3SBueGiNQh28cs4Kk3KSkOOCjUqTdrRDHKsC6cobBOwC+77gcIIBju9PrK8wcdDa5EoWVNT2jIKmqs7oZJ2Tnb9XY5PiuX0dL9Jmq0qSn5lfbJ6wpWDmJxQLKSHUJoBMuSB2u74oDE4sxeVOxmGdO+8XMCrNQLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753810972; c=relaxed/simple;
	bh=UYBEIMyzSrNEBgHDKHOOrkv/8nq3K58nn32I5bNBWRA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V+Avk6b4X8lobrui+Za+EWyApjmLUf4SdX8uC7krCWjRsSZzYAPdqWLodjlD8AYFlOXy+5A+1J6OFQhpjmqILJHpZfah50u/TnxoIodHTxkm6u3LDzu3i7YKGP5uIFlAB0KdYKVbLe9mRCkyA5PYKAe3mOtVmdMPWFgL6kLYo3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=guImVWIq; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f4d0f60caso471128a91.1
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 10:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753810968; x=1754415768; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0cDIK6qF6nWwCr2NoTbZWaYG+2Frltnz2b6AbcPAKOQ=;
        b=guImVWIqe5AfaMLgQxuFjCHp3UkCsbDbgz4JIpmlH73MNctb4SV4UrxXGPP5dW8Gae
         9kx4SGgdNDtb8tGA1PiVxQ2FaYR7kuUDc+Hpm+rE+ivQuYY9NL4h4i1Jmo2XxTrioWqK
         7BCjCONvZ0k02qVQgOjZbumXqtjSr3Ww/uqTr+UGLaX3vq6r/JALGaNFrE6y/408FryT
         iP4V4dBgWm0sS06RYJwSre0VY865W5nXUwNs/xvaPz4XgF4Q5xxenFNHBm8/WBWyREDk
         CDAtEkfyZaVVq0bVLNFsrHvWEe7OdERLpvT+zpjRjVWvJNA/gVNbvOaIO6M4vZEhT+4h
         ruJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753810968; x=1754415768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0cDIK6qF6nWwCr2NoTbZWaYG+2Frltnz2b6AbcPAKOQ=;
        b=v0m0HRGde0oRmSPEF+zj3PYhlhiEyDDpOfE9EA/gmI8ccUurHxXuwxjmITWME1xGlf
         fynravP/yMm+3UGzAHAekSaSFhNOPOk55Ak7e7KXV1U1svUqo4wINXPfa0gKhPTJGrwP
         PZrqQvwTR9zduMIcfO9cYLF5batdWjXXZazdClYa9QSk2uok2+RNYwN3mctzzixqSAGz
         pydmJNVgfD3GwLaBMSqex2FSEK3JcCoIviu34EJfGettGQcFb73xaQbuxTIfLTScSues
         4Ij015Y4OlRXnnuVqohQsFlZ3GfBZOqZAJUV2vqgiBAcRaJVxIw3WeVrnZGmGJ+MrfGd
         Qatg==
X-Forwarded-Encrypted: i=1; AJvYcCUrbQ52b5Ui5XRQ7obtLeL/FTQP3DzIK4UMCy8EG9VyQoFcEYB1VfI0He7+FRVZ9qK4FqM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywks6xtlAL3Ba45eQ0yCGa51HuHLre3Y13X8kp7HFORXZcMKee8
	AqnCSDxMQD0bD5WUTmy/red6wGrIdjiUgNOVzYqT0PEAZkbhztyhVHJZhKUzGfkNFuSNC5ZTpxq
	Y4eaBDA==
X-Google-Smtp-Source: AGHT+IEy2tKRxEDM0MA44Vkr5JiteWyEFEnQvVSVGFQxO5N3upFR7JMnSmnNBB5kB8Ubw1uZp7pGKyP+A6w=
X-Received: from pjsc24.prod.google.com ([2002:a17:90a:bf18:b0:31f:3029:884a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:47:b0:31f:42cd:690d
 with SMTP id 98e67ed59e1d1-31f5dd9e0d8mr540145a91.13.1753810968559; Tue, 29
 Jul 2025 10:42:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 10:42:36 -0700
In-Reply-To: <20250729174238.593070-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729174238.593070-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729174238.593070-5-seanjc@google.com>
Subject: [PATCH 4/6] KVM: x86: Drop pointless exports of kvm_arch_xxx() hooks
From: Sean Christopherson <seanjc@google.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Tony Krowiak <akrowiak@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, 
	Jason Herne <jjherne@linux.ibm.com>, Harald Freudenberger <freude@linux.ibm.com>, 
	Holger Dengler <dengler@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-sgx@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Drop the exporting of several kvm_arch_xxx() hooks that are only called
from arch-neutral code, i.e. that are only called from kvm.ko.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..14c0e03b48ae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13492,14 +13492,12 @@ void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
 	if (atomic_inc_return(&kvm->arch.noncoherent_dma_count) == 1)
 		kvm_noncoherent_dma_assignment_start_or_stop(kvm);
 }
-EXPORT_SYMBOL_GPL(kvm_arch_register_noncoherent_dma);
 
 void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm)
 {
 	if (!atomic_dec_return(&kvm->arch.noncoherent_dma_count))
 		kvm_noncoherent_dma_assignment_start_or_stop(kvm);
 }
-EXPORT_SYMBOL_GPL(kvm_arch_unregister_noncoherent_dma);
 
 bool kvm_arch_has_noncoherent_dma(struct kvm *kvm)
 {
@@ -13516,7 +13514,6 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 {
 	return (vcpu->arch.msr_kvm_poll_control & 1) == 0;
 }
-EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
-- 
2.50.1.552.g942d659e1b-goog


