Return-Path: <kvm+bounces-42740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1ABA7C410
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:48:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06C033B4C73
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 875DE2459D5;
	Fri,  4 Apr 2025 19:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BXoF0jPd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10693244186
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795682; cv=none; b=OnlixEKyMA9axium/dpDomkwIY9O5YZ4gFPgG8NhfkKnDHpQ0HV6KQOmQrstGhrKpOA5eGew4yppfwaOSFK7iboWeb4pxhuDp4dHvWcytV6SWEkIBVfmbPDKzpN2U6r7EJqLeIQRnV6oaXVmYqA8etgzxqyqVzoRZyYVXvOTEaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795682; c=relaxed/simple;
	bh=J9UHey9VIc8H5csAImsrOgY9HzHt7VovS5PXam2uYYc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Na/x1GVcArgV0RzD/XRwnVS/TzeSrLvnDOG55P/9hLzEthwm61d8VuaHbk5WyNyMKGja3VmALe0QvW6vvaRUmYzVipR7JumdAopB+ituiahUH5ePAzHsYEz11SjrPu9PsMcmaEpQLLek/CpfrZ3j5NOdDXYCbXpSWxZCfYCWUPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BXoF0jPd; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-73917303082so1720461b3a.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795680; x=1744400480; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IDnMFjaPTKzyH9hORg6vpYe0KsdQWNftCfPGoTAAZqo=;
        b=BXoF0jPdCKtBR6Zo6Zp3U5xfdlFDmX+FCrw6bIIRH8TXm4t4EGMfgwxanXRRSz1cjY
         U70zMZIHKvbNUM8jM+icL51CJIw5Ev/zfg7VjhWNXKBYZ2IBzKz+euL8L6q6L+92+B3m
         kk+d+xSd17t4KSfOzoHu38d4u/VApxwHN5UqOM2/Pg+MyxbObyWmUvLpUgVCHww0fCFl
         D4HuIA/0H7AZaxiWfZ0mzQCbHxyC+QKVp+UvumgRBTdY7KoPWRVwb7dY9OmJycCSMzeM
         sdjSjCmRoTp9V68oYzi+DEkRi4i4QTdw0YItMfwTXWgagUvRJu71kgzLRz6LZzDzzC0/
         sC8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795680; x=1744400480;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IDnMFjaPTKzyH9hORg6vpYe0KsdQWNftCfPGoTAAZqo=;
        b=f1M4PQtDj/b/JQSeQTLcPkoOfvX/WSwz8iqM9WI0AxR49wPxJmKJR6H3H4olSOvrSf
         z1fg0SoXsJ5/1geAbgZO9Htl8X4TxVFtjwCibVzh6KucetWy+wKMieo17jcpnFXg2zHR
         OsFu4d3vUah51BU/qjG5L85OBv5YQ3tsxJBu8jcYTXHi6TeMLxQ5c5iffcKw7lPyBynt
         CSu/KjcSxPUsKU/CHttURHZ65SBIQ0TSfjWz9ADbyLDnmU16jZRxYDRRBDpMokcRkg7r
         wbI0I0QX0Jen+0hePXrzVAniDKSl1E0AHsBsS6au/jbvxkiu2M73yaBgc/AlWgbXuH1p
         u95A==
X-Gm-Message-State: AOJu0Yzf/wC5dcYknX6iGBtWpAr5eVlXD+u1NTwHv7WzGDlsGsyWi3sM
	PBVFdYGSDkvI68o+7wRnJeG0/pN/ebMpRoWZ1Fl53STFru93ypUXSdyNk6jeDf82NIrBRvJPXI8
	W9g==
X-Google-Smtp-Source: AGHT+IFagPC1G+waMHkD10dBI62GEqlh5wfS6CoEd/HxTrdq6pLQQhec1FekF/zXyYVkQR5iehzlh0kK5pU=
X-Received: from pfbhw1.prod.google.com ([2002:a05:6a00:8901:b0:736:7da2:53ab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1148:b0:736:a682:deb8
 with SMTP id d2e1a72fcca58-739e493138dmr7548244b3a.8.1743795680602; Fri, 04
 Apr 2025 12:41:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:09 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-55-seanjc@google.com>
Subject: [PATCH 54/67] KVM: x86: WARN if IRQ bypass isn't supported in kvm_pi_update_irte()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN if kvm_pi_update_irte() is reached without IRQ bypass support, as the
code is only reachable if the VM already has an IRQ bypass producer (see
kvm_irq_routing_update()), or from kvm_arch_irq_bypass_{add,del}_producer(),
which, stating the obvious, are called if and only if KVM enables its IRQ
bypass hooks.

Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 513307952089..d05bffef88b7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13577,7 +13577,7 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 	struct kvm_lapic_irq irq;
 	int r;
 
-	if (!irqchip_in_kernel(kvm) || !kvm_arch_has_irq_bypass())
+	if (!irqchip_in_kernel(kvm) || WARN_ON_ONCE(!kvm_arch_has_irq_bypass()))
 		return 0;
 
 	if (new && new->type == KVM_IRQ_ROUTING_MSI) {
-- 
2.49.0.504.g3bcea36a83-goog


