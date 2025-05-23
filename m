Return-Path: <kvm+bounces-47500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CEE1AC1969
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:14:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A52021C05FF6
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:14:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8871D2DFA24;
	Fri, 23 May 2025 01:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZnwnUHdS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027432D8DA0
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962096; cv=none; b=Opgle5+C+r2FXVAa74qGlh72xThaMk1MN2bjR2uKT7XoVXzJtUOf4T2ss7xtykVdFQlsX1ICBqAuqXEsu1l3ew4OTxt8jmk/HGOGBY2PmxypXvOx+aDels4BcMhdnUXc1F4W0xy3bKYo8v/w9aJm4PUvZPuLCfOH+gjtznYJCgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962096; c=relaxed/simple;
	bh=WVXURqeG3/UNWGnPr4lCT0UQc8N7VixIfadV+aR9WaQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nu9j0NfX5pdW4UuEwDMsvKs/c9ZUj0qv0rnhlNUWpv5jXpUC6Ic6bMPyDX47u8R9gT+E0ObXm9zofm9EbdMRpaKu4xdI8MhLBZdhzt7s5nQMJ1zvH/7yM2bw5MlZk35ssdnL+5PugqD6TK2ZhYr7kq8SRllIspMnML/OnI8175k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZnwnUHdS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e895056f0so9232144a91.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962094; x=1748566894; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cN9xzWmJm1SC3MYFl35NGHuTlOxpMSXq5/uxL1rDnZU=;
        b=ZnwnUHdSYOTeFZUfySr8NnzGRb4mgH6SojtAPcPQSmFU0k16bwxdGGUEaCxghBN9+N
         f2C/AY3Ldw/O4SrPcPLltKhL/vW5t7r0jb5WjkRhIHp8WenEqSmFmPvLied7ztUm3VdA
         WAj5lhXP1HC386y0k3ld+kEsgchqEtmjxN2Y1ZPGxkWrOVqJvpETWLinAJhNVuOqhiBh
         v0IJDA9+cIYWlMuJaVVKEEyG8N1sv758C3uHiRSjVjwtQ8ojsq1tGdVCUB1j0aJLjace
         kCMMOsphCYZ+i+wRYDqoUPvIEO55Net2irl0O908GpO0QUPY8B/d2IISjciyBeKb6ehi
         N2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962094; x=1748566894;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cN9xzWmJm1SC3MYFl35NGHuTlOxpMSXq5/uxL1rDnZU=;
        b=HEKJYePPxxp7u8vTRW4HAmOUoDbC3UYoSi7A0kcjs4sAeOeiSGNIbzVuL0H1ZnX8no
         or5CC7GhpI8lkwX/mWWJzWxe35+6tfS7i5ZvRGV+DCf6TUvNat5p5Zp7+gl4b8sbqzvK
         m4q8ssD20t3f7TXw25MABfT9RFemrZ4pG8YWMniMP19G5w/yRatrQcjmpFzIk6599BG7
         DEzoxpgFUvg/jSjVmcHZ4itmWGCBZWkmRFK2WJ8N7s6YbJPCUZFwX88dZaqsDz0SKf55
         fLZYDX/CXS0vGN5FaOxOVJagAbgXde71OHaYgG1qUn3ec74JRzLb7J/IQA4svHs2oS1U
         PODQ==
X-Gm-Message-State: AOJu0YyYffKPoMjLCbl4jbUWUHBiQufqX2PTj9YEYfkcB2HVbzIQVXK9
	fqqGQf2kMDArcv/erHpXlYIuroFoMqIwY9Tk2cDiIMq2bive9b1pGt8diUH7ritzQ2HntJ9dqF2
	7XH1gew==
X-Google-Smtp-Source: AGHT+IFprTymTRANY7N/PSfhfS9BlgTEeP5l7IBzmCyjwM1JbIF1IL97OX8WDdXl0zNwJCd+TJHfF3OvfiE=
X-Received: from pjbnc5.prod.google.com ([2002:a17:90b:37c5:b0:30e:5bd5:880d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3bc8:b0:2ee:c291:765a
 with SMTP id 98e67ed59e1d1-310e96c5a47mr1898327a91.8.1747962094614; Thu, 22
 May 2025 18:01:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:55 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-51-seanjc@google.com>
Subject: [PATCH v2 50/59] KVM: SVM: WARN if ir_list is non-empty at vCPU free
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that AVIC IRTE tracking is in a mostly sane state, WARN if a vCPU is
freed with ir_list entries, i.e. if KVM leaves a dangling IRTE.

Initialize the per-vCPU interrupt remapping list and its lock even if AVIC
is disabled so that the WARN doesn't hit false positives (and so that KVM
doesn't need to call into AVIC code for a simple sanity check).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 5 +++--
 arch/x86/kvm/svm/svm.c  | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index d1f7b35c1b02..c55cbb0610b4 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -704,6 +704,9 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 	int ret;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
+	INIT_LIST_HEAD(&svm->ir_list);
+	spin_lock_init(&svm->ir_list_lock);
+
 	if (!enable_apicv || !irqchip_in_kernel(vcpu->kvm))
 		return 0;
 
@@ -711,8 +714,6 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 	if (ret)
 		return ret;
 
-	INIT_LIST_HEAD(&svm->ir_list);
-	spin_lock_init(&svm->ir_list_lock);
 	svm->dfr_reg = APIC_DFR_FLAT;
 
 	return ret;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 56d11f7b4bef..2cd991062acb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1497,6 +1497,8 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	WARN_ON_ONCE(!list_empty(&svm->ir_list));
+
 	svm_leave_nested(vcpu);
 	svm_free_nested(svm);
 
-- 
2.49.0.1151.ga128411c76-goog


