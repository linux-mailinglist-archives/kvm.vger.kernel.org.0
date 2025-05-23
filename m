Return-Path: <kvm+bounces-47492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 09E08AC196A
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:14:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73B7D7BDE20
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5D321B90F;
	Fri, 23 May 2025 01:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PPeaDPIV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B41D29616B
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962083; cv=none; b=m9NYQ07zNJBCVhqYPbPjksbYpEJbd9BSGIVtiKyxXr8XQi274+nSD4H+psRTqd2UDMA7pLfclCtxMRaGDghAbHbe0MljTEDU0cH1/dJ7CuMvU/INOjiwmhuW6yPXQrj55eaYYikrI77IjVNQbSiuAWlOIr7FhXLhPiiGGoHkiak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962083; c=relaxed/simple;
	bh=hkXL8tIOvSpgs8BbYZ/kSqxwAWQJTMH+qltnqmcm2m0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j0oz47avMNGIDL1njZpk7LQMZFLX7JL0LQVMDD8dUMPe8fUSYRfNK0xmf4x7Krkwj7bp3QK+tYlMUaSQoLARZ/QeRQWswTqGGDBxlb9ellzqvAjv6vshiFvyMlCgJ7YgBC9LfEbvGKvCWc7OxKB9MIAQJlUF859DMxqRU+GrWeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PPeaDPIV; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26e6b84a31so5196164a12.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962081; x=1748566881; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YWgBZPn6hQ/WyvsMJWVblHWlgsDadk9OyN3hzX+dlyw=;
        b=PPeaDPIVlGUV/NvxJHrMkfgXuoHJgyNaLy7bOFtD5RVaDwqObS1zFpGoHXDIJT+LYe
         WVOBIo/NFHwSBVzDfz4pAlfIKnafDxmgDjOEwxU3/+J/XKp/wTuYA0srL0UsLtdSXWON
         2Y1LTBpCKUdofauX7ae+b1cujL4Rnzb7JAvWJt3uOHmFnUxBdioLqp6Uw/TFzO8xPat2
         RYjoWDSHa7iZOc49mvicX3jXgcUyUkmfZjflVND4T3XRSx+9uKWKqsR1uF8BaMMi5PDU
         cGFH6GJTqHSWKL+BNH9aLFsKHGqjgJQreP3i3mR8nh3E93mEgkQnCVLP7MzZsuvq3dSS
         ypoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962081; x=1748566881;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YWgBZPn6hQ/WyvsMJWVblHWlgsDadk9OyN3hzX+dlyw=;
        b=PGm5MBfKy7Cgpi/yb5MjYwvr0RUfSKkpxkw4CdUPeAas6T33pNJCO7a4RPCCV+gBId
         Qnu4vuKDr8uyF4prHThxxzFl40EotRhUWatIx84AOFaTSkXeJieDot5RakBiv1dDv49O
         jKfTEQK3Y2QPtJhztMVjWKJJHAp1TwN62Yrqs+D7eDmJGPaAkOPpOUEeZnlNAOhfT6Gl
         86N/bDuYFhUZbCK8Q/+ihJD3an6Kkg7GxY3MPnz8ZG/XvL8MKkEhewNVKejTAATVDPfF
         U2Sx+wxhPOkuFj3UCvDUnKKURsb9eYS32sIGZ5vlmnz1rbtD24jUQGODnoL5xb5ryWnm
         OdNA==
X-Gm-Message-State: AOJu0YyuFAV1LzM9oVQkO1GBAtWpY8IFtrtqfhMmB1QlT7TsCmiGXgbB
	adRz+6BrOLtvec5iPtXFsIvVtVcOKeCsZ1m9B5IOPG9qB9JQ4ba25E1a2zvlQtn4IWPypfaBHAO
	zxhBQiA==
X-Google-Smtp-Source: AGHT+IENrNvN8kjYKcc8X8f5fjuZCrY8RjRuwJA8T06sgnoEuhkTZxv+Y0xj/vx377YeaaqzuMYjIUVGtfU=
X-Received: from pjg13.prod.google.com ([2002:a17:90b:3f4d:b0:30a:133a:213f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2749:b0:2ee:f076:20f1
 with SMTP id 98e67ed59e1d1-310e95f3481mr2198254a91.0.1747962080822; Thu, 22
 May 2025 18:01:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:47 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-43-seanjc@google.com>
Subject: [PATCH v2 42/59] KVM: SVM: Don't check for assigned device(s) when
 updating affinity
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't bother checking if a VM has an assigned device when updating AVIC
vCPU affinity, querying ir_list is just as cheap and nothing prevents
racing with changes in device assignment.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 2e3a8fda0355..dadd982b03c0 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -847,9 +847,6 @@ static inline int avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu
 
 	lockdep_assert_held(&svm->ir_list_lock);
 
-	if (!kvm_arch_has_assigned_device(vcpu->kvm))
-		return 0;
-
 	/*
 	 * Here, we go through the per-vcpu ir_list to update all existing
 	 * interrupt remapping table entry targeting this vcpu.
-- 
2.49.0.1151.ga128411c76-goog


