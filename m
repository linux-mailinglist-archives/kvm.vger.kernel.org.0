Return-Path: <kvm+bounces-42735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 09915A7C406
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:46:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4B121789A6
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA4823ED69;
	Fri,  4 Apr 2025 19:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="emZHNJ4B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28553221542
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795673; cv=none; b=HUQkmQHSXQATkjsd5OswXcqzQQfZZ3PJwAJUmmWvY4OPXdqOWi+w4F0X4N/fJZz8q8lZGrU4yG782LEMtVq4b+55nZuS7nnPUye0PbEA4CIuPqZq4iBX08/avxh0uHN3R0YWwyIOjQ0TXvwtIUsyW9HFbZDnaUVgttt3xg5qpxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795673; c=relaxed/simple;
	bh=KYPkJmO2WKGa6Hqkv2jcYDUkv0LZapz25ye+QSx983M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PZl20tAQJXfAtMWMCUcGK0jzFpq/r2rWKKnvkAdliOv40JyY7CyDDD9zqEFeqPNYgwQlhJakE4/zfR2y91uKE4WKGEk11PgYHjnT0cLK9B0JbZ4Beyebm0JO+ptEHT09inevHvjWGSJ4mAgu0Be2OM7A9gHmyHZsZUbxAx74bNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=emZHNJ4B; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736d30d2570so2142922b3a.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795671; x=1744400471; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BuUmn/v/nxN4sDhjuaKZdNs4Kj9VqwHUaANP0XC6c7s=;
        b=emZHNJ4Bgx+OH+ONebVt6qqPMrMZOspA40S2cgRxABBCl5kNVYE+36Xm4TnuhvHrO4
         NGhQ8eVaZKB4m8b5/MidNdMgq1OQXxfVthYmQhDoN+LJ5mx0yCaWHLof6yaMC4/T/CGr
         njlCZbdEBVWIV18/1MQKhCclAL2ntNrDNL5c055zPjkEaNqKb915HHYPuJOmMFpIsVfj
         w+ROL/kzIajjWBWBFrmLnTklHjyUEiZncCp3Nl4sL8PR6w1fOHHLhJbGmXUJQfdTSKDQ
         WJHAkVualMB/8lwGJ5Kh/xpR0PRMzBAdJw+Ntbq9+z+TVbJyk9DRsE3iRVyew8TI9mVN
         13ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795671; x=1744400471;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BuUmn/v/nxN4sDhjuaKZdNs4Kj9VqwHUaANP0XC6c7s=;
        b=MstKck3Mx/+Vt5WmqE99g6LfCUZW9gUTZKwljtZUGFZ0RDeNuPTFa8VQhACP2Exyye
         HBcSAKKlNOS/j4cmnDAjQHmNTkhDq8gHtLE0ZfSjKdFASfLQ9PUtC85V3VDmIPTKllD8
         Tv9k59TLnBO+sF/ISoFcNcZQhNPkqcux41BNbjs/RAA0qRwuzL0rdI5l/hOnC9s7vSjz
         mOUebqoAwUIv6c+diRKraxaeIUz9CsbDT/OYxIKYNJap8w1KlSS6mUs0BT8PJCuuUJAG
         XCwYW3yBBjUa0qjUaJO9ZUhQQFtXOhguBiQex0UMnPij4xC5SHXUyOjchf5880cLB0v5
         Fb3A==
X-Gm-Message-State: AOJu0Yw84TqqWfHAo9W4PduXZg8mLu3ZslvUxYVZvQS0O+AnynKA8C+3
	kfITMutwkwqOm6U7RTBOn/nwCz87I94MoMgo/1Nz00s38RFdUPf7++DGa9XsqReGylqWxJ2NW/a
	+dg==
X-Google-Smtp-Source: AGHT+IGn6VyFDYgNExRPxop+TDl4ttE1iIR8bH26Vp9Pjy1Orp1wUriDPA6oU50ESKKN1WjXv/GYXHS2yHo=
X-Received: from pfbjw34.prod.google.com ([2002:a05:6a00:92a2:b0:730:5761:84af])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4653:b0:736:a540:c9ad
 with SMTP id d2e1a72fcca58-73b6b8f82e9mr711650b3a.20.1743795671518; Fri, 04
 Apr 2025 12:41:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:04 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-50-seanjc@google.com>
Subject: [PATCH 49/67] KVM: SVM: Don't check for assigned device(s) when
 activating AVIC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't short-circuit IRTE updating when (de)activating AVIC based on the
VM having assigned devices, as nothing prevents AVIC (de)activation from
racing with device (de)assignment.  And from a performance perspective,
bailing early when there is no assigned device doesn't add much, as
ir_list_lock will never be contended if there's no assigned device.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index fc06bb9cad88..620772e07993 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -741,9 +741,6 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 	struct amd_svm_iommu_ir *ir;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (!kvm_arch_has_assigned_device(vcpu->kvm))
-		return 0;
-
 	/*
 	 * Here, we go through the per-vcpu ir_list to update all existing
 	 * interrupt remapping table entry targeting this vcpu.
-- 
2.49.0.504.g3bcea36a83-goog


