Return-Path: <kvm+bounces-10084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0679886904A
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 13:22:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 383521C219BF
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 12:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC4B13A868;
	Tue, 27 Feb 2024 12:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D+czIVKD"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061711386D3
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 12:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709036390; cv=none; b=YFoYCZTLZrQ4PnktoNxVjpVPtwhJTuUuXt7rNgxApSiDfjYCrHRoBv6d2Bt0+3zkHXfl0Jdf57GmBWlpGLC6TsUKfKd5xfdw0jb/n2cZ7bEdtr0M3cqzhdOfSgVTMrYKR8T808FCMCNGx67iolfREif2SutaMt+4H+4ZSaTjKQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709036390; c=relaxed/simple;
	bh=cK4ZYPeNuqSd4KDdQmrAG2cSPx+DFJ+DIf7eKq+TO1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcamX8t50LeuGoielU9Pqu4yQKrCRbZw/f28vvxCTOOhhVby7akiAqWU+y9SjVFFw0FErJfqjzm+YrmvGk88XgmsBkPJoQzi7x7tR9CnDS9EkaQTDDNU/Y0J56xb7PCEUcUq/Zr+49KuUGcBsDMysIURBi8rNIKeLzgjsM/L7pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D+czIVKD; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XNBfqYR7DvaesoFseEK2MShJiW1gZ9BnBHd/r+Q+vG4=; b=D+czIVKDgheRW8/qaguCkQf2MO
	vmQSWll4utFGPoNi74xzHgAdQZ9V6UEd32MzBtsisxivTyKPTa6M9DnB4GJer8W4Dly4IcD7K2He3
	Da+eWqEBMOksciF2V1H1BQuFfAImCnmO7r3/yq+wt9yByqT8ADA8/8VOHo20zsjRTOZeihuoHExlV
	FDq7xiDCrSwOm2ck+8mAAKxfFvGjLTe5AlJmTaE2SgqkMI8+XhfE1/24Wa0Sa15c8H3XKzIOVecM3
	Rb05FPJK+3UWzsA0EdYSEl/LaCuKCm71HPcmzRMxBhUVfUmvXxikq+fW7GQDbLWGUHjBHexUG3kKa
	D8y61lZQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rew4p-00000002JfN-3INx;
	Tue, 27 Feb 2024 11:56:51 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rew4n-000000000wU-3r3j;
	Tue, 27 Feb 2024 11:56:49 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH v2 3/8] KVM: x86/xen: remove WARN_ON_ONCE() with false positives in evtchn delivery
Date: Tue, 27 Feb 2024 11:49:17 +0000
Message-ID: <20240227115648.3104-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240227115648.3104-1-dwmw2@infradead.org>
References: <20240227115648.3104-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

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
Reviewed-by: Paul Durrant <paul@xen.org>
---
 arch/x86/kvm/xen.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 06904696759c..54a4bdb63b17 100644
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


