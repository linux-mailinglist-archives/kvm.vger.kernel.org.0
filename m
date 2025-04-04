Return-Path: <kvm+bounces-42698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DD37AA7C467
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 376481897F25
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B31022425B;
	Fri,  4 Apr 2025 19:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hiJvr4Vq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65442223706
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795610; cv=none; b=a6Oh4TUeprzk1r/sj1DvQu/qICS0nITHsIjR6J51/FQo5CD/UVbjxu5ajJOJoaBiBgrWBXoXACV76Gh74kcjHUTHeiFTgUOd6ouSY1LD+jR7s7V3b4LK9tdxmwawRTxiLcnGVMDOXs6cg2lpB2oRFK6DhR3rMHaSw6sqer5BoIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795610; c=relaxed/simple;
	bh=uzlVEbR4BTmFkBjn23KnqXJ/yIeZSAO1hkc8JxEHwWA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VVj7EcZH93dsBFFuL6avO0A6ETH6V0U8f8Vvuu+kNsvUme341b2eVl575pUvm+OHsstAOt3RiPFfd/5enbf6PWyqmvV621vzrNsG6ku0MAB/pDw4QiqKHG+jVN4SS+m7rMh8g8k0Md90acPff49ysr+QpEWs2A3ccgKmyf2Wd4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hiJvr4Vq; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7377139d8b1so1924111b3a.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795607; x=1744400407; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8U7fbiDc3fD3nWCIa5Kamzu6n5Z7wqEoDo9I5vrK7FA=;
        b=hiJvr4VqkVJiCmGOi2ey/1zoe8cBlUvks4xmjkFjPojsk7j91i3R5p7uRlne8h7Fc1
         EcKfh1e8+f2X7IhbrasqqaO9UqwOYJXX+Dk2YfzFoFiXZhfTpkwL5e+YHEA7n1Sp2u5i
         G1VrBntKN9uBzIHuheyEgTTZHj6CyogUHblyygA7UypBqHE3QtaqsiUG6MjhkQHfwmbe
         dMVVVvwlsXlnaNaHbYm1TNi60gvHpSyH8kJVVKCaTBUMN3Xl+4rzWj8LGmaq+hs5fLIA
         ee+EyRS4Dcqb2RcybrB9fYPTuri967AaXQRGW04yeTuTK536U1MAF+zKdlSn2DANSOm9
         QSNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795607; x=1744400407;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8U7fbiDc3fD3nWCIa5Kamzu6n5Z7wqEoDo9I5vrK7FA=;
        b=RZJzEw9h25FTHwdufV9j2UZQerFrNrcgx7v8JRXDBqMeCA+zLTdmEFkS90gpX2tHLr
         T9U78D7DbGOQZ6EUMBdpfhV2ay1tJj2N5Qj9d0S3LzW5GcfQGCAzpaojYhPrfGMNpfcj
         vpAZi6kuOQ8GAO1+Y5A8j0pRdxxdEUt7g0G3mjGQFDzZrst6mz9vptVQ95WFmT6GU/SW
         rz/Qe5Ri8Sja3GJ5mraC8mgccBwOqiUWuOyixaGd/6bMRGMCJP/3CLRLTHaG1Cg53too
         ONCZ42IZIvZVVWy3X4xskRKfdZezPRIgbgofZ2fAK7vqNRd5M6ghTo3fTibYfBQRQ58q
         Vu+w==
X-Gm-Message-State: AOJu0YzFOGmO2fRTXnvR452j1q6IqAsu316WXSJQXOOfy5RJkb79MysM
	Sz4HQ5p+9UFM9oHrJcomDCyBz0cr84wpIRc9BjsBn3lzJc3OyVkSNndJZhHD6GrsIEKkA3dby8T
	O9w==
X-Google-Smtp-Source: AGHT+IH1FWkdivy4S+bLPUdZ+zOkMlZOgSIPe0C8D80kAIF34VnktZoafbX6YO039dybyFyARTj7CbbGk/k=
X-Received: from pfxa1.prod.google.com ([2002:a05:6a00:1d01:b0:730:90b2:dab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:561a:b0:1f5:9330:2a18
 with SMTP id adf61e73a8af0-2010801c42emr4738241637.23.1743795607614; Fri, 04
 Apr 2025 12:40:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:27 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-13-seanjc@google.com>
Subject: [PATCH 12/67] KVM: SVM: Drop pointless masking of default APIC base
 when setting V_APIC_BAR
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop VMCB_AVIC_APIC_BAR_MASK, it's just a regurgitation of the maximum
theoretical 4KiB-aligned physical address, i.e. is not novel in any way,
and its only usage is to mask the default APIC base, which is 4KiB aligned
and (obviously) a legal physical address.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/svm.h | 2 --
 arch/x86/kvm/svm/avic.c    | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 9b7fa99ae951..9d3f17732ab4 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -254,8 +254,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 
 #define AVIC_DOORBELL_PHYSICAL_ID_MASK			GENMASK_ULL(11, 0)
 
-#define VMCB_AVIC_APIC_BAR_MASK				0xFFFFFFFFFF000ULL
-
 #define AVIC_UNACCEL_ACCESS_WRITE_MASK		1
 #define AVIC_UNACCEL_ACCESS_OFFSET_MASK		0xFF0
 #define AVIC_UNACCEL_ACCESS_VECTOR_MASK		0xFFFFFFFF
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e9ded2488a0b..69bf82fc7890 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -253,7 +253,7 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
-	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
+	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
 		avic_activate_vmcb(svm);
-- 
2.49.0.504.g3bcea36a83-goog


