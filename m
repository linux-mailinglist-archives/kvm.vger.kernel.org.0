Return-Path: <kvm+bounces-42726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33520A7C439
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:54:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01D361B620BD
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4A272356A7;
	Fri,  4 Apr 2025 19:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d39jnbMn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236A9230D11
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795657; cv=none; b=MwaxKlTjMz9G2JRv8qcCrMWYjFyaB8d+p6/O30mp/qdsEM9VetAbx1BbbGtwlEQEmmd70Qhb0XWuIEE0Xv4uI5n2Zw7PTM17GwuqcPPLFu+xL7KtMcThuWDnaukEd9dmbgKLXNyPh2TCHgmAOBpqsg7Xf5Dp0li1+DLAKhBvY10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795657; c=relaxed/simple;
	bh=rAx4qAmD55M9tfIGXl5YoCVA83RQWFiazrLX3izC4S0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wtw/InzoAT0wZDmeS7S0GdOPXnqEKYynbWMMp6VC1aFoOif3QHcvL0HpU+OS3Y4k23sD3brzrERBcrQMTUnThoLG/ogYtkjJokHHUJMfEbEqg9phWlSmoZHR4a9Ch1T/1b5ATpOr3vscML1Zehr5fDbYw0wvFWqiFxIBvucSuVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d39jnbMn; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-af51d92201fso2724505a12.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795655; x=1744400455; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bZC+Ik33WL0W2RRbulovk+dibdQdMDMKKv8TRtkvhyw=;
        b=d39jnbMnmHb2v/Qoz4d4/kycFUFsD2IYWQW6J/HgRN2IpucxpZH5ptv1UMmxKqv825
         nggjK6zAGDNBzuS5wbE9gp2fC/X/NvTvV9dcroek82ZXsTOymkCdhqwPmVHO5b5XQqIK
         tOe3VYlpZs8hdycNJso6FwnFY2dTh9Eeif3GhdiiL9oTx1KsPTNR/JyJuUxujcQFzb1C
         E8kiTVm2JwnixZsU1vDSVGQRlpkmONz5Db6EP4Xy/fnlAcKO+hjE/+5SmVmQs9+2Ojbb
         clJ2H0YZhigDWwJa9lcOxfe705u++sPOxS1qXJIANZvm+Z7FbA1N0vqLEZCq0jmnoxSo
         ncVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795655; x=1744400455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bZC+Ik33WL0W2RRbulovk+dibdQdMDMKKv8TRtkvhyw=;
        b=cHikoFY+0UkTg9hwIOr7V0C5kxMzUhCt24KHilBhqVPLAHzT/jJ+k+pgBAIbkdTF6F
         QOTdOCY8IQHmscNOFfFypMPyy53ervAZhYY/P8549c0bB9r6h+xwsjpG6uhDkx98Dcxm
         UUQHjjQ+qKxd1L+i+uRmgGVLx99lNQ/ecgrkA0Je1UiccgSmB6QFmv03HMLq0GxZu2ul
         CL12CP2ulWdyTtS3MCk8fJl2PAXk1+Nap3D4mb5PKd5Xx4GK1CR9nqrlX3GC66dtM0T4
         sYLyCZ2bJm9P979UtPNXrHkV8YoSMOrEIVNqILD2J4y59FiryQS+/heAlicv8u1Sae9P
         X2BQ==
X-Gm-Message-State: AOJu0Yz2MzU8gUQ8k/lLulvQ8Us4bQHrAqvLn8u+zqMrKobwHoctBaiV
	wdz1icvBgmZ8m/dq2NoORO7m0o+HxA0n+H4RgNj+nbbHwDz/6oL3XQgNOF0noe8YbSGDtoGQGjg
	Iyw==
X-Google-Smtp-Source: AGHT+IFQWL9LigLNP0a/K8uREP9gQEOYzG81Hr4sts6sxEYIr+yeo+mdbybE7LvF1mbotb2pbsREFg7UZT0=
X-Received: from pgc1.prod.google.com ([2002:a05:6a02:2f81:b0:af9:553c:ea73])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c78e:b0:1f5:7007:9ea5
 with SMTP id adf61e73a8af0-20113c0964bmr1123119637.2.1743795655565; Fri, 04
 Apr 2025 12:40:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:55 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-41-seanjc@google.com>
Subject: [PATCH 40/67] KVM: x86: Skip IOMMU IRTE updates if there's no old or
 new vCPU being targeted
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't "reconfigure" an IRTE into host controlled mode when it's already in
the state, i.e. if KVM's GSI routing changes but the IRQ wasn't and still
isn't being posted to a vCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0d9bd8535f61..8325a908fa25 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13602,6 +13602,9 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 			vcpu = NULL;
 	}
 
+	if (!irqfd->irq_bypass_vcpu && !vcpu)
+		return 0;
+
 	r = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, host_irq, irqfd->gsi,
 					 new, vcpu, irq.vector);
 	if (r) {
-- 
2.49.0.504.g3bcea36a83-goog


