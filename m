Return-Path: <kvm+bounces-8962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BC83E858F23
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 12:40:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5DD92B21324
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 11:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46F9C69E1D;
	Sat, 17 Feb 2024 11:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Bp8fTIv8"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311C06519E
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 11:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708170026; cv=none; b=igycFk+lAHCJEVHO8U9iL8l7ja1QYwkULRXOX7oh3wy+c3Zmkywyv/OuEG/2NapOUFnMjlrpFBSqSiK6b2fqkWmzH9U6sfJaVkHQOL6b37lKC94pZrVvNjmNkr3BkMI9pXcSvcBHX7fzpuZvkTcwGB63UPbm9g6HW3EH6yPqigs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708170026; c=relaxed/simple;
	bh=LvY0Ry8TCWIIsbpj0ROhUqljLsZm4vsg9Oo8hsMWXdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=en0cHFyRPCQ0B0999xJscWmyi1SCCANMHKaciFSlFQJsRi6Se1FMyFM2EoJbISGjfnqDoXF7wBoaPj9X0sThKTGvR51KpQpwxki+fc4JiSrPTBVW024rD8ZU2X6euVUXTD1RjgeVOZieU0K9Tfye2Dkv9BVsCqzZiB4gbs8Voso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Bp8fTIv8; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8XejwVT26HDeY7wuOb6N63+FEk7ZLmyz+REELGIhboI=; b=Bp8fTIv8UYtnqU9Fpkt6g2DH1Y
	+nsPxn2zr3KGC+s80PSrUBf/tQb0rjy/BXmq7J+Ma2b87dXBL7aiMuqUl88uYhx5McfmAW0wctsQA
	3cy/5MZ3Ky3rdXptbtHoftfwAKuY/hw7/zqDTkJ/mqa+6MzwfoOYG/Bx5CCmM0n4cVktNQKsDEC8k
	3ZHwKScm9jp5FTybbRmuhNXYN0Zehiz/YtumX50sPv19zWDDJKa1TF3qvc7csdlMvcopAhpXEE1cE
	9CO9zd2fug0yg+lJBziYLti+QXaeZaS0ej2HpgtrqopAyMEG9fAGGr4M/aHt43KRAr2nNoTOaR9XN
	kkC/Ss2A==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbJ3M-00000000Kvj-42np;
	Sat, 17 Feb 2024 11:40:21 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbJ3L-0000000034E-3ct4;
	Sat, 17 Feb 2024 11:40:19 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 3/6] KVM: x86/xen: remove WARN_ON_ONCE() with false positives in evtchn delivery
Date: Sat, 17 Feb 2024 11:27:01 +0000
Message-ID: <20240217114017.11551-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240217114017.11551-1-dwmw2@infradead.org>
References: <20240217114017.11551-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

The kvm_xen_inject_vcpu_vector() function has a comment saying "the fast
version will always work for physical unicast", justifying its use of
kvm_irq_delivery_to_apic_fast() and the WARN_ON_ONCE() when that fails.

In fact that assumption isn't true if X2APIC isn't in use by the guest
and there is (8-bit x)APIC ID aliasing. A single "unicast" destination
APIC ID *may* then be delivered to multiple vCPUs. Remove the warning,
and in fact it might as well just call kvm_irq_delivery_to_apic().

Reported-by: Michal Luczaj <mhal@rbox.co>
Fixes: fde0451be8fb3 ("KVM: x86/xen: Support per-vCPU event channel upcall via local APIC")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 847d9e75df6d..e6c7353e5315 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -10,7 +10,7 @@
 #include "x86.h"
 #include "xen.h"
 #include "hyperv.h"
-#include "lapic.h"
+#include "irq.h"
 
 #include <linux/eventfd.h>
 #include <linux/kvm_host.h>
@@ -571,7 +571,6 @@ void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
 void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
 {
 	struct kvm_lapic_irq irq = { };
-	int r;
 
 	irq.dest_id = v->vcpu_id;
 	irq.vector = v->arch.xen.upcall_vector;
@@ -580,8 +579,7 @@ void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
 	irq.delivery_mode = APIC_DM_FIXED;
 	irq.level = 1;
 
-	/* The fast version will always work for physical unicast */
-	WARN_ON_ONCE(!kvm_irq_delivery_to_apic_fast(v->kvm, NULL, &irq, &r, NULL));
+	kvm_irq_delivery_to_apic(v->kvm, NULL, &irq, NULL);
 }
 
 /*
-- 
2.43.0


