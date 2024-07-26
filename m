Return-Path: <kvm+bounces-22443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A586393DC54
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:19:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7B271C233AA
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB3A191F89;
	Fri, 26 Jul 2024 23:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cVV2c+sj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F58191497
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038126; cv=none; b=ZcjOfolEwZCdCEW7stBswkTTR6TXhjmzefCk9Lr8EaaiveXhzGynG2hJ/VDjvbVn8Q7Plrx8qnJor20l+MtxIEdt/EfAaeDsgumQbpVRdJEdC6Ay0X2lWUn9czSME/306vYoz3cJ/T+Rhnz8DBuwlnhmJgbnEh4cI8Pn5hCyXhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038126; c=relaxed/simple;
	bh=rI1deqx8R2FAT3yDZksFCzznTBxsLeNOCK4lgbhIK5U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l+oVuQz5VMvn88LzuNVp1grbmH5uPYSr2sCxAbuxjc6VkUORnic6l/eCcDB6IAg8kGCIyn8wOO27oudYnXPmc5JnokbEFmR7wzGL+iRqgaCdbPsAFDi0NEFLM/IkJ8gEBTMGCkhNntSa4xxHEmiC862XOlkY24ikQCE87X4g6lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cVV2c+sj; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-78e323b3752so1106292a12.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038124; x=1722642924; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4JkhtJX/rWB1cBzt9zuFqY6FqfPwx7EIf6/sG5QRcB4=;
        b=cVV2c+sju13r+c0vZGcTmYBht45CT+HMvoRXfThdc5QZ0nuf0wfpO5L9d352irglET
         dcAWmJeGiWCvBBekgQYJoRZgIR8JMsnIkGMcPLDZOFQVVNZsi65372160uDokuL77U/e
         UuOy8NL88Hso/BTODtSwDZHauqQgDg7YfzvvmoYHs99O1vkTEIAO/k7g7uEgcx2c2iLA
         D7fCnPSn55y8GWTVe/tWQ2uh3zjgIZEppDfyB5+BNAWbdnLfl2xGk0P5ut5UIYRUFoSC
         o6qnoWgIvZKcTSjQ3RpwEun22AZ3YqDwYQZBw+Pmurv8+EVbjXlwE1G9voJ5KKZVWDml
         Jbbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038124; x=1722642924;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4JkhtJX/rWB1cBzt9zuFqY6FqfPwx7EIf6/sG5QRcB4=;
        b=jrBVskZnnwP2YDs36PTwkaTNhWk8Pk6UzFnM+vcrULO99JhqxN3OhT0clQvhLl3Dep
         Zp4UV8MjZPIUQ2/vercB3N1B0UTZIh+x9ok0otNJSyO2pFh1xG0cT0kXaiJlShuhNnMF
         dxzDjeKjXTecmcot454ss46yvmITaApvl/fy542SGiu2uzZebjAxuhm+hP5Y/vUTyaQR
         AEUDvst+NO+EuWmGv9vYiKBTC8i54Jr+cbOsj9esblw/EQYSK+Ac5YkumCEsiQ0Xmg8x
         weFUhy8/Xcz5YJfzs/9BT1hwyp+q11ektzYuHFDVxqcJMrG3DRO5YOfM0utOLaBnueit
         up3A==
X-Gm-Message-State: AOJu0YzdyiEkclHBXdyxfCKoLfNln3nokjjx5JzOpqc9gccMm8x60rkj
	pv4ci+0CHI9EE922CSk4Szfli9w8Fk7NrHzLmHiincjO51vt/Pc9G4FVCWGUAmEjYvp3DMEcfrP
	4Ng==
X-Google-Smtp-Source: AGHT+IFPQa1UjlYj7+Kv/jUhsXC3P8YtU5HtBxuA0lRTgUmwYvAf/3a7bhqWFsOX8QFlAkrWz2XoripRfzc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea03:b0:1fb:7f2c:5652 with SMTP id
 d9443c01a7336-1ff04893401mr182655ad.7.1722038123783; Fri, 26 Jul 2024
 16:55:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:29 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-81-seanjc@google.com>
Subject: [PATCH v12 80/84] KVM: Make kvm_follow_pfn.refcounted_page a required field
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
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Now that the legacy gfn_to_pfn() APIs are gone, and all callers of
hva_to_pfn() pass in a refcounted_page pointer, make it a required field
to ensure all future usage in KVM plays nice.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5dcf3561b829..030a08d4b21d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2844,8 +2844,7 @@ static kvm_pfn_t kvm_resolve_pfn(struct kvm_follow_pfn *kfp, struct page *page,
 		pfn = page_to_pfn(page);
 	}
 
-	if (kfp->refcounted_page)
-		*kfp->refcounted_page = page;
+	*kfp->refcounted_page = page;
 
 	return pfn;
 }
@@ -3001,6 +3000,9 @@ kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *kfp)
 
 	might_sleep();
 
+	if (WARN_ON_ONCE(!kfp->refcounted_page))
+		return KVM_PFN_ERR_FAULT;
+
 	if (hva_to_pfn_fast(kfp, &pfn))
 		return pfn;
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


