Return-Path: <kvm+bounces-42727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 07629A7C48A
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:06:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F26E71B620F4
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 20:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3042A2376F4;
	Fri,  4 Apr 2025 19:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qO70dyr8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2DF2343B6
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795659; cv=none; b=rhBmscZ1yplGYG+tQXg84JWI56Px+gXxXdD+tUrvy/M47l9OctMcmY7zUjpjnzmqqZp2gqHCP3U97cYEzeHbWxAo+p/0N3Scv98lB6x2ZGbYPcBqtqa//SB/4dcYmbK+QFSgXNw92r/4h0Z9t2HZNQcQ0S15I4sLjEdbD6Q4tGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795659; c=relaxed/simple;
	bh=qRJSMg/wJdVt+yvoikFVSNe2Xy3I3T24yQmnIrUC1yE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C8yC4pZXIDF6tCXwI9iS2299oWDT4r+P7r/glJIn6BfQ6GYjcUbQg5MkpAurn/THEYHHwCukWtsCA2cI40uUz4fw5t055OTmz1RhxsVuH7esxpQv2h9mPvwf6lbeZ0Tkbt3yJQ934vimxDQJdJ/OocowoB/PDiBt+WAV0dEYIy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qO70dyr8; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736cb72efd5so2196528b3a.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795657; x=1744400457; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kz4x5Upf+TkOuVEZrNth6TOEjNFtX/45/lAAaTZzYMc=;
        b=qO70dyr8qbrEFudkBQBPW17woNOmd46w9P+8oZE/ZjbgtA/9eD+bHDZFkkIgvwS8ay
         myWnqd8sUBjAdiJHcd9b489jk8qYStgsm72dOwrbI3E6jE2XxPDPLO8KgNJk8pyi/gkU
         MkP1zBkWZv6SNN61T0hqE+Eew09xWRrn1I1B0DzuweN/ehWf6QYdkD5H0a+X4tMBS3Mj
         8olPNb4B2NOx5hmDG94Elaf9rSzbiVYHwyEN9cSrOG41SZFae/XTPcc4dHoupVaHJt0g
         sEgWIb3ZyYuSLn1cOBnAn3zsE72GgUdL7SfEYTo3U0FlhLfQgWYxFeLNmD+3ro+75sTh
         l97A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795657; x=1744400457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kz4x5Upf+TkOuVEZrNth6TOEjNFtX/45/lAAaTZzYMc=;
        b=EXkxvJ6kvgztPrFZQNolUCfMVZh8jE9JOm8WPGz1lYmJViLTM4meJ3qOcniIjOUpl+
         mZwYmosk2iR5+Gay5Gu07AFdrca8AH0Rqt439KxR0yaaO9X2mz38CP0fGSYxRfZUhy3p
         SBXuJcaP2nNFZA13hou3PgeXZw8Yq7zgHQlmykvXSp/NTlnsHnrqeDzsdOEwQHsA/Uee
         qflut4GYZx5/LWsL4igfQvsTOJcqGgrkZQ/iDNdki1qW8mAc7/E2SufoJVGu4naHl+KC
         Cx//8nw2CQyL+v+MlgN37CYH9wgtFrU09POknCU+TW/VfFbm3QXMx0W+0cGoa6MGQGhh
         wC3A==
X-Gm-Message-State: AOJu0YxL1lP9dWgu3tCt3kyP/9Ir6OczTKPIqG11VJ7gFN7a+K2yudHC
	+qP6B8InvadDTKpr6QDx0xktnzkpCmK1TGcuCJF3l/gr1ATqOClv5byq8GfdYbbK8ep20Re/5AO
	viQ==
X-Google-Smtp-Source: AGHT+IHkLFUYrRFyJCAgYTx0bID7tXQUTRqySewXCzFOP3XCxELB+3z+iKZV1p70EJLDf5uCBKxj0CFwan0=
X-Received: from pfxa13.prod.google.com ([2002:a05:6a00:1d0d:b0:736:a68b:88f8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d8d:b0:1f5:93b1:6a58
 with SMTP id adf61e73a8af0-20107eacc49mr5032422637.8.1743795657302; Fri, 04
 Apr 2025 12:40:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:56 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-42-seanjc@google.com>
Subject: [PATCH 41/67] KVM: x86: Don't update IRTE entries when old and new
 routes were !MSI
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Skip the entirety of IRTE updates on a GSI routing change if neither the
old nor the new routing is for an MSI, i.e. if the neither routing setup
allows for posting to a vCPU.  If the IRTE isn't already host controlled,
KVM has bigger problems.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8325a908fa25..0dc3b45cb664 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13678,6 +13678,10 @@ void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 				   struct kvm_kernel_irq_routing_entry *old,
 				   struct kvm_kernel_irq_routing_entry *new)
 {
+	if (new->type != KVM_IRQ_ROUTING_MSI &&
+	    old->type != KVM_IRQ_ROUTING_MSI)
+		return;
+
 	if (old->type == KVM_IRQ_ROUTING_MSI &&
 	    new->type == KVM_IRQ_ROUTING_MSI &&
 	    !memcmp(&old->msi, &new->msi, sizeof(new->msi)))
-- 
2.49.0.504.g3bcea36a83-goog


