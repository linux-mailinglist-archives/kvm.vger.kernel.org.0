Return-Path: <kvm+bounces-42693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5BA6A7C447
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 172FF3BD8E0
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6EE02222DA;
	Fri,  4 Apr 2025 19:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d7OZnnuy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA5421D5B5
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795600; cv=none; b=qa7ehtXd8JvEBKjzenLE0H8cdsmCPF3PfMTG+fIref/6QroQ5FOFsWi/w1gs8uPVoj3wxzfnhU5fgcWcmDk/DmvJsd3ypraFAClG10zQGCEnBvcTXLdcUrWoXbsCsIvWOcurVrQNjS7npsRimnBfNS56WCKUdJFhU7VIoftvr9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795600; c=relaxed/simple;
	bh=yOm0l7runQh/bqd/+NGHUK/eIjFj2umaZ1UvQPY4G08=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uE39UtmJK3lmm8o/+oMHkfekZimH3VnFKfqoODtEO2VfH6BHaJMjJjzoTbNT5wKo1csS7ORKzYg7lYhmzsrxuNqQSyzvBLB8xlnzBnSrW1Lt1G9h2ND+kgk/YMUNnOCodgDj+E+iZbuEm27Hhyub/DEVwJC7hK3dplCqOm42kJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d7OZnnuy; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736cd27d51fso2260354b3a.2
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795599; x=1744400399; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ksKzicOEYbjGpeVOLeT0G0MNe2BKT96MICWw9wdEzS4=;
        b=d7OZnnuyLEPoirHra3BvFwZao73wMFB0i/1Mq+wBjhZTxLODaZIe0YVwG/sxt+RKky
         n/QXIDFQsJyLjBO12rGLABUN5UGzy7Xt0ZwKO2VvJgBKSBOERH9pXgu28n0d0EAtd+Cr
         PB69H7c84AcDo/ZZ96qFarFF22aJf+8gLUPgsFHTsFMfUwiOVOv3GjGNdDDHcCGZdtuj
         1H3oCP/Of1CbQba2hyjI2gUJlgJ80o3cRJIeyflTkYrBeMxPYOF5olwHGsApBNnFWUNP
         RGN5g1+cw9hbJL0Vy/2QmcHETI3wLGEnQA5CPwG5I2b3IyAm4uZD54NzEVE6BxO/gH7Y
         t05Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795599; x=1744400399;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ksKzicOEYbjGpeVOLeT0G0MNe2BKT96MICWw9wdEzS4=;
        b=uT5ggY5POCu8GfnFgOObx9VFe8/ZCA/RETF1nwyGu6J8AZ/M/um6QJmiRW+GZ/RvPN
         5246dkWPAc4TS8ZvBQP3ViKxpifdaP0+Q1qP4YH9KssPU+TGxZ1eO5zlcKYM6B0ldW1J
         zEAnFLI903lFO48DhhcCnBoAlWnOh/vf1/meDAeiiKds3cYGKjLapIP+9swX6NwKpKdh
         ztYuXbOYrNRd4EgfB71GNpBwLyr995ujY/OpZMazLiWZObB+NryI2FytrMs9/dm5RQUe
         60biKlQO/2Te5rUrPZmc6f65VclzY/izqNeCoB2Vw3GwwFvKa8hVj2oKUzYaxua3dcb7
         ibDA==
X-Gm-Message-State: AOJu0Yy/F37UToSJiWva/26/3TI/E3FnBwXnChkdWyEL6cnQwvCWcsSf
	9JNPfLhDnVVpObsUR7INO4Wiw+8lUKjbqdn02npRzwlb87SevkcRNJWGalsgtaZ6tqzeX/3SN6+
	n3w==
X-Google-Smtp-Source: AGHT+IHgQd8TSnrl1N62387tBCrXt8b1iTBjftjzhSHwCWE5Yo+RGmXWAwjPpFA1Fbz5oNevpz0/JHGX4zg=
X-Received: from pfax3.prod.google.com ([2002:aa7:9183:0:b0:736:47b8:9b88])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e9d:b0:736:5f75:4a3b
 with SMTP id d2e1a72fcca58-739e6fdb4bemr5249939b3a.7.1743795598917; Fri, 04
 Apr 2025 12:39:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:22 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-8-seanjc@google.com>
Subject: [PATCH 07/67] KVM: SVM: WARN if an invalid posted interrupt IRTE
 entry is added
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that the AMD IOMMU doesn't signal success incorrectly, WARN if KVM
attempts to track an AMD IRTE entry without metadata.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ef08356fdb1c..1708ea55125a 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -796,12 +796,15 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
 	struct amd_svm_iommu_ir *ir;
 	u64 entry;
 
+	if (WARN_ON_ONCE(!pi->ir_data))
+		return -EINVAL;
+
 	/**
 	 * In some cases, the existing irte is updated and re-set,
 	 * so we need to check here if it's already been * added
 	 * to the ir_list.
 	 */
-	if (pi->ir_data && (pi->prev_ga_tag != 0)) {
+	if (pi->prev_ga_tag) {
 		struct kvm *kvm = svm->vcpu.kvm;
 		u32 vcpu_id = AVIC_GATAG_TO_VCPUID(pi->prev_ga_tag);
 		struct kvm_vcpu *prev_vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
-- 
2.49.0.504.g3bcea36a83-goog


