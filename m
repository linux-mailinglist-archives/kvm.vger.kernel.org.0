Return-Path: <kvm+bounces-49191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7118FAD6366
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:03:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C91E3A39D1
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E42C32EA492;
	Wed, 11 Jun 2025 22:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NM7FSFpZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799562550AD
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682096; cv=none; b=N4X0I0WhHUqahkWRH13n8fx37krmY1IK6nr02cGC7rMHS51j29hzcndoqyjsO3wf6APDfvdnjGCN077+paazrXTlwHys2PUmh8Mh77q23JxewsImsOvSSwnjHY1HtD9SaK43zq/ZF0nL2sJtRqrsyeQdm7lYlZlIjd0DK2t0D5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682096; c=relaxed/simple;
	bh=yZZtRbcWnuqwQyat4VhI1SVpbjBljsz8F13Q0oWxmXQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VRLPPxpfMZJ289F7CIi0y6qJsfmJ8gaaNyl/gtn7HsIMDxpR7lD06QKxosv72umYUgeOW7Sr59A4q1SNrGqTSCrZ+iGPhk5jaqjnFcUHdX5LNl3hn4uRheUJ9w8Ku+0fMPk0RbIcwjbbfyEIcDNYhdhN2dptAVmn1cewwPVEUJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NM7FSFpZ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26cdc70befso148894a12.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682092; x=1750286892; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mEZsLhf6SxJ64ydA6t/wQOktcm5LeFVwzcPjAJ4nCGM=;
        b=NM7FSFpZACrG9/GxFQXCLHBdXshvzL6X91spdB9znvOj4Tn3YdJp3h8NPfhzhvt+fr
         +DgbY3XYSwdtZKtMwL92STSTLFqFP0TjwzSMzYoJC0nzQ5MvjH3Nj5f9VL6W9RpccUft
         alYluvITlj/dx0ADOSiy4xgz4bLn7z7whzfypwN1nvCORH+jdLM5HBc50NYY9AqKXA0G
         ySvJlzPBtgI9vbmUXTw4tR9xnZ5uqfMPnvMyQN1yaOw9Yfg+F9aakmQgDSRNnPFzFw4q
         FbnvZyKR+bTqFbZ5oIe22bSGPtAxPnZjZgomniu7Sk4bN3a7qnclQmGeS2jibHR0RJfT
         Pckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682092; x=1750286892;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mEZsLhf6SxJ64ydA6t/wQOktcm5LeFVwzcPjAJ4nCGM=;
        b=aij7NiGWPczF5DF25B+f5jAoF3AzSsUBhkacbkGQKuMI4vF9pNtAMQNiXBfYb+lAlT
         Sjo9WD7yNaaGw+VT5EofJ4omQqNocsFpvQQFt5k8WT21auKJG6HGo/VzqrjyNFnPvhBh
         KCItqU6jO2TG2+x2mWtNMDWbwZ95glM/RXyYe3I4NIwixB0j0BirAf55oC1lcBtBIJXe
         TvBsdycDBJffmwRh41PKlm2UZamjavH8RvDAjjPap4RCAEKuE+bOdAgaSBRX2FR4jaCT
         ftU9AYld5HjBB1TjKMNsVLsvqqUgf4gM8VjUZ9/O9aQMTrKxoJNoQG1FnwFnGRJDYxcW
         AkAw==
X-Forwarded-Encrypted: i=1; AJvYcCWqziXGZyseS7oXyaWDHt4zwWHFldlBY7luLnvJ+TilR9rhQuRdtVW5lagvcIdYgjOVUyA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+TY+MKfGykAdh+YvbSG3GBbg5rBMlhrXNrsn8TBnMt+ueARO9
	Skf3CfTcC1NG7Jr2KTUt8s1r5RzFOnt6j1V+y0GnxLUnPuuqhWfn3CuEXhciQzpM+mtgsaWphSM
	7hcajPQ==
X-Google-Smtp-Source: AGHT+IFg24zPNL3KiBl4z/DNOHqd2KhvvGrjl3yLgrTD6GwXkCuqSf7mQ8rAwENd7T74FPlQ31IQOCRlfVY=
X-Received: from pjwx3.prod.google.com ([2002:a17:90a:c2c3:b0:2fc:c98:ea47])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c2d0:b0:312:def0:e2dc
 with SMTP id 98e67ed59e1d1-313c068d18amr1292249a91.7.1749682091962; Wed, 11
 Jun 2025 15:48:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:47 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-46-seanjc@google.com>
Subject: [PATCH v3 44/62] KVM: SVM: Don't check for assigned device(s) when
 updating affinity
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
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
2.50.0.rc1.591.g9c95f17f64-goog


