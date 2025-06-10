Return-Path: <kvm+bounces-48886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD270AD462F
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:58:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A55B16C1B5
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 22:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D67692874E8;
	Tue, 10 Jun 2025 22:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QsoJWD4K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8698328C2DD
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596267; cv=none; b=ruT52T5hge0oj1ww7tRaJ6R7OWwWf+28kWKYfGO6aryHRw0uhwjtp7LpAufIIms6ELwVtAtCx6h0kvzUcujRIO0gMp2dWGksf8JFfMS5w8+sKhDoUMIY39+5Hgbo46iIXUep/vx9lYMoJPuPzV+q+ji8yvnluXGosQUbPmRiP2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596267; c=relaxed/simple;
	bh=Sl7RMVG1Smug1Zt7BIT/fBDHqqAV5fqrOgEX8eS3zlY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rt8/mX4Zzk+IDDJAtYHvSL4K0uRqlQwQBYornn0k9BJ/NmemKVNnFl3QEiXQWMxnwNm1uzyoI6h3h+t73GiqHLz1UYSuDwH3NGgeIdv6Ki9X90xXGdCtO5AXFngUSSFqQtD+VTtGezy0R3/d2TG5uOByD2fqw37fGNYyr7pMa20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QsoJWD4K; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31327b2f8e4so5439079a91.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596265; x=1750201065; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=C2MqcAD9SEyvsvm0pt69BHrzaupG3Xug+UbyYJUQj98=;
        b=QsoJWD4KOnJQssKXqxRQqNMyOHhIREOPqJcIiedoaJyrupjye8AmC6qrC/UpVaLu/g
         NvQAFqwJGzXDqKRdiGz2ntog+MmVjOCiqaK7zv1TIAFgaOT8KyNv3bHYOct3PstoFckI
         FGardfr5dKUuHnkGRqNe9kA40QbwLSyonWzPLEeu9c0Mt4AZ3mwpGNqW4a8rujiQmWm3
         9sM5tM2yhNp+F7IDpsWX4shsYxXZhQwfdq4eoKDOkcIuPlL6Ks7jnV/uZIKfGQoE60kF
         qa4GKd3EIfyrjdPC5PFPAJRYbFMMYS2vJFStVIAla66MrO0TW4xBgq5dVvmaRhevU6Ls
         HohQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596265; x=1750201065;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C2MqcAD9SEyvsvm0pt69BHrzaupG3Xug+UbyYJUQj98=;
        b=u5cPkmpyjyb3JKVWQspYInPXzaD2WPhdf/+H9RqmEcJg/O1dfimZA6TSeQTFmEWavu
         6WY7yG+Ii9EVkCmwzmwYtI1q7Z2Gj2AZi4pJoVa2G+kylxjfaaUQzYc+4+VEupWJoso9
         CDvH6rgEh+DW+NHe5np0IBUj6L+KnKJz17nLYy5DD+LSQKibVgwOkmPDvrqqaBO+9ZgH
         F+xc8DExSVQiECbgGq0utKU6TTwygG2gzIt+Dql0aWyHwHZkdgfinXzaPZhleoD1mN6W
         2pH1apx2p6hq2U7Js7gVYaO/wkfi+nzGgtkbVtvDFzmkEjoBGbbdq9HozyKz7fz7n+hA
         5uWA==
X-Gm-Message-State: AOJu0YzIWv5jwK13RMvjIOYp+W2dNQZVwBh1KrjojAsAcvZAAay2zPGK
	xi0UPI+3MAMZMYp8g747a+CorF/Da76F0/iGWXsAZDfCYMX7EWi+9wWfFpPlUj6xV72YXD94UaR
	gHcmuvw==
X-Google-Smtp-Source: AGHT+IEsKlnetXx2xFWIoFZib3Nzc35PtGs1gAdAOfo2EicjORiTp+qxdwZfJwoZ740t92RDBf5DoDOkGCc=
X-Received: from pjv13.prod.google.com ([2002:a17:90b:564d:b0:313:2ad9:17ec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ec4:b0:311:9c9a:58d7
 with SMTP id 98e67ed59e1d1-313b1fbe6admr572991a91.19.1749596264797; Tue, 10
 Jun 2025 15:57:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:07 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-3-seanjc@google.com>
Subject: [PATCH v2 02/32] KVM: SVM: Allocate IOPM pages after initial setup in svm_hardware_setup()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Allocate pages for the IOPM after initial setup has been completed in
svm_hardware_setup(), so that sanity checks can be added in the setup flow
without needing to free the IOPM pages.  The IOPM is only referenced (via
iopm_base) in init_vmcb() and svm_hardware_unsetup(), so there's no need
to allocate it early on.

No functional change intended (beyond the obvious ordering differences,
e.g. if the allocation fails).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 21e745acebc3..262eae46a396 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5505,15 +5505,6 @@ static __init int svm_hardware_setup(void)
 	}
 	kvm_enable_efer_bits(EFER_NX);
 
-	iopm_pages = alloc_pages(GFP_KERNEL, order);
-
-	if (!iopm_pages)
-		return -ENOMEM;
-
-	iopm_va = page_address(iopm_pages);
-	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
-	iopm_base = __sme_page_pa(iopm_pages);
-
 	init_msrpm_offsets();
 
 	kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
@@ -5580,6 +5571,15 @@ static __init int svm_hardware_setup(void)
 		else
 			pr_info("LBR virtualization supported\n");
 	}
+
+	iopm_pages = alloc_pages(GFP_KERNEL, order);
+	if (!iopm_pages)
+		return -ENOMEM;
+
+	iopm_va = page_address(iopm_pages);
+	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
+	iopm_base = __sme_page_pa(iopm_pages);
+
 	/*
 	 * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
 	 * may be modified by svm_adjust_mmio_mask()), as well as nrips.
-- 
2.50.0.rc0.642.g800a2b2222-goog


