Return-Path: <kvm+bounces-48036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CA4FAC8512
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:40:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76AC91BC39FD
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F6702550D0;
	Thu, 29 May 2025 23:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3Tb6UnoM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13302522B5
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562022; cv=none; b=YUrrDg7dK1M4sOzps9k7WWWwdKWICL35DysBgdB7dkSyowkRhGam2XPdB17kLEznxHKT7lW4g6P7UY5gX/9d3zBQ5SCn1kLvOUkD2lcnmu1gSHyl1rRy/oeJ2WjEa9PfQBymQropDWiOE9BSCuFRMTZDydsn1gTlwJVLdf0na+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562022; c=relaxed/simple;
	bh=U/vnhsbhBOR3k5uzXGTAfxXyl26OU5KIOSFsBImEIys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BhXHfFkxUie5QivJCoWUnBORK7b+yYSU4mP/9/0NfgRhml4V924vq0NKmP/zGEymSDaJgPl70OTLU1P2bwclLWq2cLtB0gYImzZBkxr0qRsXiq6qcMhQVNYuUfiIsZySexQpuKirq/Wnb65vvmZEE4HqIyEMnifggBhnxu5posk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3Tb6UnoM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311d067b3faso2048158a91.1
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562019; x=1749166819; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WOXO0V2L8rQ7JjdVAp3b4RGjNKGfCgDRi8jurzt1lTM=;
        b=3Tb6UnoM3evqboBeCZPG+9MokuzgUzb7j62Ntboyo8zzAeJyLMWiVMqIQdtJzz1gJx
         Wi9s3NZLToxyCwjTw0jJD3LXLbX7BzfQ8BMZRZQoXaTmIPdMV8qvgP3AWnfMZk4U9jiZ
         J4TE8EOjTG/iWncqv0taHyVm8EHEQRet47FH3lDEhpj7jVrDffvEY21a3XkJ8CCNocG7
         RN4vmQ63mqvj1bHlLy/d1qXBzctgBz3+5pflDK0+q7gCl7rLG1VSE0u1wr0d6MdeazXr
         Lar5uyWHqHdIMeGuMEx50Lbn8RFhboSXtJDpUTpSiKhpJBg8+aqejQoEpEP5j407/80f
         dAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562019; x=1749166819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WOXO0V2L8rQ7JjdVAp3b4RGjNKGfCgDRi8jurzt1lTM=;
        b=H6AhomWosB+uX1YC2ScqJNKmxD7IiYNIrgxwRQTUWNFHXNb5jBHut85TgORUPswGlN
         DV5OLIjeRkAfi4N6IsI+S2VxIyOcZWtIWyRC4uJ5y6iP3mYY/IQPu00/Pubz9UiBFovg
         fkjsmP+NE3uJVPw0UthGQl6FCp0p17Rir2D27v66HFatG9wejCQazfB/2QYQDFKoRaFx
         QPYydPCruytrs+NkIqK5e487VqwA7Tf1CUPl1IAqF0Ba7z3eTF2qgxI7uaTJSN+hYHaE
         QWS4CI3rQwKiziQ7hES+AMd49HsAnWnRbQrbnMIiSN29npOK+sSeWfTdkRocoybgnfnV
         t1mw==
X-Gm-Message-State: AOJu0YxyoPDmUribVEzevSahH28P26O+AsVP7BmePOsI9nMFIZFGsR9o
	/98g8Eui5UcY0zeDr+6ms8rm2vFUZ/vsO7rDvSU5RJmom2cI0Ue4mBuoU7AotsRQOHsn6gL6Q1v
	2x+E2UQ==
X-Google-Smtp-Source: AGHT+IHYgGGlZHfS9w2vU3f5cVhL5YvwatjHQcXfI3teFmKUtgx7d2TkS7E4UOVFLFDpezgccvXUQXQ3Ay0=
X-Received: from pjbse6.prod.google.com ([2002:a17:90b:5186:b0:30a:7da4:f075])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e0f:b0:308:7270:d6ea
 with SMTP id 98e67ed59e1d1-31241a803bfmr1863216a91.30.1748562018988; Thu, 29
 May 2025 16:40:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:39:46 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-2-seanjc@google.com>
Subject: [PATCH 01/28] KVM: SVM: Don't BUG if setting up the MSR intercept
 bitmaps fails
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

WARN and reject module loading if there is a problem with KVM's MSR
interception bitmaps.  Panicking the host in this situation is inexcusable
since it is trivially easy to propagate the error up the stack.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0ad1a6d4fb6d..bd75ff8e4f20 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -945,7 +945,7 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void add_msr_offset(u32 offset)
+static int add_msr_offset(u32 offset)
 {
 	int i;
 
@@ -953,7 +953,7 @@ static void add_msr_offset(u32 offset)
 
 		/* Offset already in list? */
 		if (msrpm_offsets[i] == offset)
-			return;
+			return 0;
 
 		/* Slot used by another offset? */
 		if (msrpm_offsets[i] != MSR_INVALID)
@@ -962,17 +962,13 @@ static void add_msr_offset(u32 offset)
 		/* Add offset to list */
 		msrpm_offsets[i] = offset;
 
-		return;
+		return 0;
 	}
 
-	/*
-	 * If this BUG triggers the msrpm_offsets table has an overflow. Just
-	 * increase MSRPM_OFFSETS in this case.
-	 */
-	BUG();
+	return -EIO;
 }
 
-static void init_msrpm_offsets(void)
+static int init_msrpm_offsets(void)
 {
 	int i;
 
@@ -982,10 +978,13 @@ static void init_msrpm_offsets(void)
 		u32 offset;
 
 		offset = svm_msrpm_offset(direct_access_msrs[i].index);
-		BUG_ON(offset == MSR_INVALID);
+		if (WARN_ON(offset == MSR_INVALID))
+			return -EIO;
 
-		add_msr_offset(offset);
+		if (WARN_ON_ONCE(add_msr_offset(offset)))
+			return -EIO;
 	}
+	return 0;
 }
 
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
@@ -5511,7 +5510,11 @@ static __init int svm_hardware_setup(void)
 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
 	iopm_base = __sme_page_pa(iopm_pages);
 
-	init_msrpm_offsets();
+	r = init_msrpm_offsets();
+	if (r) {
+		__free_pages(__sme_pa_to_page(iopm_base), get_order(IOPM_SIZE));
+		return r;
+	}
 
 	kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
 				     XFEATURE_MASK_BNDCSR);
-- 
2.49.0.1204.g71687c7c1d-goog


