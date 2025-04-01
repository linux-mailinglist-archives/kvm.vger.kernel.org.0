Return-Path: <kvm+bounces-42368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0661AA78061
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:29:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8E323B147D
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D5621D594;
	Tue,  1 Apr 2025 16:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ecIcKzhu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366EB21CA0E
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743524291; cv=none; b=SGBN62OW91TE78EJQi3p78qNwOqepD81rx+adgyWj6joyF4P4FXb6Ib720BPddPiJ6bbJ07nPY0eOPfW5ZYqIOkzQHXDJf+7A5Lxj5lFZbCRwDvfuLCa51zKgxVrdg3V6juv8l/gqZTHm0vpAH7WaKwXRVx3K/Z24bLoDPpbRDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743524291; c=relaxed/simple;
	bh=ZlxjQIsKWBnCn4azAPaeZp9DWgj/64K0rqQe0dmeggs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oH7mhormAKveFidttrdUNtIgjBecqWl95Mk/15Jvh6DYDdvtjIB5Z/F+WwO7POnsEC8/f5Gb9EmpuFM1HjI5uJu7Sn+mwTaafZZjI4JYU8abrzJupZKP+xkvGn9r58/BeYApmoblTemBL8Z5eRXSgfxGQ9ZBRcZiAg/lk/UOnqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ecIcKzhu; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2262051205aso82978175ad.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743524289; x=1744129089; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bqWYbif5v+Yux+dM7N5z+opj8vbiyTpqkOl2VaFaASM=;
        b=ecIcKzhuHkx8Y8993aWfZyVZeVHbR5WfCSOWJWb2Tj2Qw+sAu3TDQQJmSH3bSZsO+T
         lq4SF+cFmcvZwoDZ/CllHj+uLyPytkesMLm0+fT8A2QhMOax0olEG/0lApy8ypWsDPWb
         JpQqc7Q5TSUCeTne3PwnUk8kphlivvrQvGAe83pOwn0drMkOI6Dz5zbVs5MTvaCXyCQU
         jZWs1qQuTHtwCpdbK5t3cEUbkxoICEMa6GUZ865oNbKkjARyJb62Ji+OpyGV8WNMtmEz
         fA/+cYVEY2Ia3erb93znXH3Ppr+aWBo+otq54+WMaLDkiaGXfNkjCAAzfgsSYcttNIjN
         Ur9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743524289; x=1744129089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bqWYbif5v+Yux+dM7N5z+opj8vbiyTpqkOl2VaFaASM=;
        b=ZS9u79g7OHIZ0E7nu6hpM0+jNVkzl+xm7hX64++jQ4Zsb8kU4Zdyli3kgMRDekYHN/
         p3hngpRFNedhgHlCbk1ifRyh+HwgihV6Zt/fOsKeEmC5hNYCZToQ8uxyvDcNAL/vpDIT
         S82DvKPX4v7JC/sAXdy77XiZLADnIM0NH64i6JXlqOQHAG/i+GPZ+q/CGr7pZKIPvQhr
         l9DOp0ayvO9t6LEWU12W88e9hLNkMJCpPLtuLCkN/PlzynvPRbXeoisa8v+DEuSjGPdy
         6fNEndAoBhMlU6W1Q/MLLQ0a6SwfhS1xnc6SYRxOhWz/J28mylLB5bdb0v8GZh/ZWmcv
         YRTQ==
X-Gm-Message-State: AOJu0YxXqyXDay9oawK8kywRpLKdBZSuYs6n+xqM1jntBUFMXNFCcMj5
	PyJQGcmVtTwC91QZDFODFBYhfbsnGgM3PkMj5tL/M8R199xs6WYKnS/ueS1AwQBSMsYHJpMKdCV
	EpA==
X-Google-Smtp-Source: AGHT+IFBjQl9T5sWawUBkQ+04s8CWsMBMWzhJzaFZdNq/LILgQj/lKKMYLjUW8g9R/4M43HyO/qeuo/exXs=
X-Received: from pfgt25.prod.google.com ([2002:a05:6a00:1399:b0:736:4ad6:1803])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4609:b0:736:46b4:beef
 with SMTP id d2e1a72fcca58-73980350385mr18816589b3a.3.1743524289597; Tue, 01
 Apr 2025 09:18:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 09:18:03 -0700
In-Reply-To: <20250401161804.842968-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401161804.842968-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401161804.842968-3-seanjc@google.com>
Subject: [PATCH v3 2/3] KVM: SVM: Don't update IRTEs if APICv/AVIC is disabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Skip IRTE updates if AVIC is disabled/unsupported, as forcing the IRTE
into remapped mode (kvm_vcpu_apicv_active() will never be true) is
unnecessary and wasteful.  The IOMMU driver is responsible for putting
IRTEs into remapped mode when an IRQ is allocated by a device, long before
that device is assigned to a VM.  I.e. the kernel as a whole has major
issues if the IRTE isn't already in remapped mode.

Opportunsitically kvm_arch_has_irq_bypass() to query for APICv/AVIC, so
so that all checks in KVM x86 incorporate the same information.

Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 65fd245a9953..901d8d2dc169 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -898,8 +898,7 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 	struct kvm_irq_routing_table *irq_rt;
 	int idx, ret = 0;
 
-	if (!kvm_arch_has_assigned_device(kvm) ||
-	    !irq_remapping_cap(IRQ_POSTING_CAP))
+	if (!kvm_arch_has_assigned_device(kvm) || !kvm_arch_has_irq_bypass())
 		return 0;
 
 	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
-- 
2.49.0.472.ge94155a9ec-goog


