Return-Path: <kvm+bounces-49162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6078AD6321
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:53:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 386B23AD03F
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323F72D29AC;
	Wed, 11 Jun 2025 22:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3L+ZvM74"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454E02D1F5E
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682046; cv=none; b=a0zSMDC+0QOCPe+v6mqEE71bwsGEBq9p9ttqxqU9vlwRPi0MMhqXBXBKqOrJwp8lHzH0LPGqGUP/0a/TrysA24uuHI5HBpv2KhOyiVXKkDXZ2IS96Km28QCxj7E1ljem+rbzE3qHYnNwUNhWGvnFKWcExM/aJxqhqAckyX/T/bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682046; c=relaxed/simple;
	bh=42cURYzNOSYVDWBQ0v/mU/h1dxNifaKTdnd5p1g+eHQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ADVakcxCwWH35iMsCO46C7WxY8kBWO6snL105F31Xggh+mIpbnJEsIgM6ltpvRrBvBDsgp+c1H/IYAHeGP53Vljd+sBI6v/KoM2AcFHghGdhbZ7Ir3ofYgrQ2KlDuoJV1b38XunJYzCyTWU+KACFmPbNxVlmEAzdS7EVLlVEYXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3L+ZvM74; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31366819969so290314a91.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682044; x=1750286844; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zSDDoR+RslpHc3sFyno+iStW5FaTxNYMSfnwl+S1QGs=;
        b=3L+ZvM749m4I6hiPNhdHQEiysSIYKYW2Uk7ddsRhyF2vE7WCWWx/arnF4F5W5NjuLp
         7Zg8UF4xg+hsviblz7PTa98qCbk+EBO6vKIQnHNzTlomST7n3d9TAffyAL3oPQAcrJ95
         EjKkG1AZIxMdXUFb9OBSVjiKz4ko3w9gDhw8me6PIBNIWOzHMWc2sRkqvjv5qWYVemyR
         m9guDNuwFMMa8RODlzrBj/D2TX2Vu4cH1Q1ISw1dFNBT7Z+GZ1SO6ZgOU4E+TLwubZWw
         mwZ/gl14V1/OreJWuabvWzCZKSiQ3QXTrmBKcNSZrfRSsCgsQAwS3ZVUqP+QoVwRzNEF
         sJcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682044; x=1750286844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zSDDoR+RslpHc3sFyno+iStW5FaTxNYMSfnwl+S1QGs=;
        b=SqV2T+VdUUTvIiRTG51w+Sb4gMfeuIHD2wdxxMzcZhb1VSdyx6d6eBwmDD3OSywfnt
         N+kCwJlp0RIMZ4zyzS8fWZkc3ycSRUOvZZRu6DZeJsz/gVgexWwOLO5qOYh5lbAZ0KWu
         rc4ChPzHBObcowlR0F462b44laoIKafGjevUKfH9VKm5GJTSv1hOxqi/pHhQWd6mTbli
         bpIPIJG3Z3ykTIQfksf7zaOLj/9SfzQSfdOAl+pf1kOgxmxNGJEtKDgNaJ0gqvXjzyhc
         2ENGDUK6xVXkyDxIZUNmBbTFp4tIBQHYvTK/yb21aLTeZwHKshr4J4dgWMHIzZvmY+NM
         zybQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGHR4VMQbgPSVFr07MxDY0U8dPTdZFGajItQK2E3zldTpn6z3Uo5Q8W8gAySuZzVo+zmY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yypf3yZOtF0BemwNtxjC5BWmEbVUEXRyEb8MjdsgkXkrP3cYXLw
	JpF629tmeA3iI6KA/RCzMr6HneZO1ryOt0QC7Ufq4L7EuHEmjEUHenERLBh1nZv3tWCDLutyD1a
	4h6nrOA==
X-Google-Smtp-Source: AGHT+IFW1CnJBjbF7Aa/vCphsUpZawH1JrjgBFuOplZJCnRAXG3kKQQQygDZU5VinjflvWeeW7y2BmvVPI0=
X-Received: from pjbsq7.prod.google.com ([2002:a17:90b:5307:b0:313:2d44:397b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2642:b0:313:2f45:2fc8
 with SMTP id 98e67ed59e1d1-313af1b2399mr7734150a91.18.1749682043833; Wed, 11
 Jun 2025 15:47:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:19 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-18-seanjc@google.com>
Subject: [PATCH v3 16/62] KVM: VMX: Move enable_ipiv knob to common x86
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

Move enable_ipiv to common x86 so that it can be reused by SVM to control
IPI virtualization when AVIC is enabled.  SVM doesn't actually provide a
way to truly disable IPI virtualization, but KVM can get close enough by
skipping the necessary table programming.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/capabilities.h | 1 -
 arch/x86/kvm/vmx/vmx.c          | 2 --
 arch/x86/kvm/x86.c              | 3 +++
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a9b709db7c59..cba82d7a701d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1950,6 +1950,7 @@ struct kvm_arch_async_pf {
 extern u32 __read_mostly kvm_nr_uret_msrs;
 extern bool __read_mostly allow_smaller_maxphyaddr;
 extern bool __read_mostly enable_apicv;
+extern bool __read_mostly enable_ipiv;
 extern bool __read_mostly enable_device_posted_irqs;
 extern struct kvm_x86_ops kvm_x86_ops;
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index cb6588238f46..5316c27f6099 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -15,7 +15,6 @@ extern bool __read_mostly enable_ept;
 extern bool __read_mostly enable_unrestricted_guest;
 extern bool __read_mostly enable_ept_ad_bits;
 extern bool __read_mostly enable_pml;
-extern bool __read_mostly enable_ipiv;
 extern int __read_mostly pt_mode;
 
 #define PT_MODE_SYSTEM		0
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9ff00ae9f05a..f79604bc0127 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -112,8 +112,6 @@ static bool __read_mostly fasteoi = 1;
 module_param(fasteoi, bool, 0444);
 
 module_param(enable_apicv, bool, 0444);
-
-bool __read_mostly enable_ipiv = true;
 module_param(enable_ipiv, bool, 0444);
 
 module_param(enable_device_posted_irqs, bool, 0444);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 93711a5ef272..f1b0dbce9a8b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -226,6 +226,9 @@ EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
 bool __read_mostly enable_apicv = true;
 EXPORT_SYMBOL_GPL(enable_apicv);
 
+bool __read_mostly enable_ipiv = true;
+EXPORT_SYMBOL_GPL(enable_ipiv);
+
 bool __read_mostly enable_device_posted_irqs = true;
 EXPORT_SYMBOL_GPL(enable_device_posted_irqs);
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog


