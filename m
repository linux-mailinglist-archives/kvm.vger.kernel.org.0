Return-Path: <kvm+bounces-47483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00331AC1952
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:10:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D002DA4753F
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA3DE28A73B;
	Fri, 23 May 2025 01:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vabktCzN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7A52882DD
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962068; cv=none; b=Ek1V9ABKbeTm+M2g1YxkSamCD0MkSzmA58POXwaI7Dxc91zJ4Dpbnx8twgEL5Oq3rRlBFT1ENj0HSeD0uur0xVuqL21hTr+ipZz6+moTDJ+U4GgIeH/eFWSuw0bk1jMqkmrg31gZ7Ek4Z83sK3jXuaUn++sbUXw9ZOJC1mqHqtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962068; c=relaxed/simple;
	bh=D8FN8kkLx7L8tVrUTR+61zNHHfC5qjIkeg2WDBKUnVA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i5ljl89N1mgBsbUGmfPFgBbOsP1FeL9F1xbp8h0UVWzCOT3dFBrnp9OyPKMwXC4oBb08rgxfqYYMQwe5GlTKY6pYEIm1KqfdU8Opt5AWhXlsYWhL7uOtuwbizYEnyw1EbHQWxlfEmRXo0WknSqa/VdUJMNiwDk9cl19o/pUFjU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vabktCzN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e8425926eso9531826a91.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962066; x=1748566866; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=a8iEK4WECydE0ey1yGfRxrlymXScvl+S1HRsDMKm8xs=;
        b=vabktCzN5A6ODhh1oq1YbFw6Gz4vl3FRUoeLffbuMUUFEpeBenrJWDoKpea5npxFxN
         wsdxAfPTKwHTMs7xrxMlnhCzSG4Nb/upBYH+U6Cd352f0jrm3Xd/mTzi/ez7oTW0U7ZU
         ViMxN4c6+2RJSAi98MKDdb4lgXUV/HH3vQzOdP7iKM3706roULR4Rm+fUkxM2r4hnLKH
         yQJs5gboYmUZDTP9FZCxVwhZ5ZtLSYzJ3gNZUXbdKE+IvZEWmSafoMtgkfcQMzi0fBZY
         ZNoVMgcTn2jlCFO1ORgqhEijF0aSbKIvwCxajLZBFWFMqq4dLZ6haHyPvhjv/FY81IB1
         rZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962066; x=1748566866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a8iEK4WECydE0ey1yGfRxrlymXScvl+S1HRsDMKm8xs=;
        b=QWKasBAo9SWFPcre+NR25Bl1I2IlOLm5qIw9kUgHZXcJtShdZosDG8uN81s625fL4T
         6QUywD/MCvQHLe/T4hyzT1ErBTCr+v2hgUZIbPyeFSLHMrx4W2lOBnSuneEvRk8avE0T
         871J/IK95vgomuJ3yAqlOGi0Qiom1S6VZc7/9vsMCcglcaEgfWkRfNNr4PWB1Vl/No/f
         NPpVj8ON1P6Mb34W2powcNNAQtd9aULkjBv+UUZ5GYXYuv7TsL9pD3Ut2hOtH+KXR7xg
         GoemOZZgr5LExUWZ4ZOzhFi+Q2hUY3ApS5QLYrTBxktgQpdFbSm4muJtbDUVczGVod3O
         y4Ag==
X-Gm-Message-State: AOJu0YzCaKx8U5yDNHAozxirgXivqlAYNOJ0OXtSvdgB8IHysL3zGbX+
	pSKUuNSaA+sbcbDuZsIyN/qysHO31rpJU88rm1pDgFjb5bkQXwDpep7zLxj+8HpBTGKZzBh8foX
	fQwXSYQ==
X-Google-Smtp-Source: AGHT+IHwPMZGzfvW4HHKJ8l4pKBM2HZBGdDFPBOti30bJ3R5xYNqLd2qkSG+uTsnts5TsJg7XZvkaLmeguw=
X-Received: from pjp15.prod.google.com ([2002:a17:90b:55cf:b0:2ea:5084:5297])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b8f:b0:2ff:6608:78cd
 with SMTP id 98e67ed59e1d1-30e830fbe31mr42654796a91.9.1747962065843; Thu, 22
 May 2025 18:01:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:38 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-34-seanjc@google.com>
Subject: [PATCH v2 33/59] KVM: x86: Skip IOMMU IRTE updates if there's no old
 or new vCPU being targeted
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't "reconfigure" an IRTE into host controlled mode when it's already in
the state, i.e. if KVM's GSI routing changes but the IRQ wasn't and still
isn't being posted to a vCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 3a0f28e98429..67fc8901d15f 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -542,6 +542,9 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 			vcpu = NULL;
 	}
 
+	if (!irqfd->irq_bypass_vcpu && !vcpu)
+		return 0;
+
 	r = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, host_irq, irqfd->gsi,
 					 vcpu, irq.vector);
 	if (r) {
-- 
2.49.0.1151.ga128411c76-goog


