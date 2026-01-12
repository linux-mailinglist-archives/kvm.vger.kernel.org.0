Return-Path: <kvm+bounces-67813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A469D14793
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:46:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0A0D23068DDC
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C50F37F0E6;
	Mon, 12 Jan 2026 17:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pUtsNEbF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D4730F7F9
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239944; cv=none; b=e/NHAPrbNEA+nksCEHLMp8rpDu/p0oO9dZrR3W1maYJAiWpFHJM9tukE0hbvgVmygHejI7EJbX/czVblTGnus2MycESaAOQDJb/k+kcH8ucSm7pxhdHy/T8N4oUE098IuPXD4aNmxUbZ9ZrDfuMyMrUSGdF0ilkRG1X0DURdp6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239944; c=relaxed/simple;
	bh=0Zgeqk6nvVnJdWqLW28/Asgqjv9ht3++oXRwRVKQXu4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dD7lmJJmZwA8zl7i/EESG75c8v4UiM+fFsdYwlyZEI8Ox5t4cf6lZ6aXJAy2u2qS32XVUDxzRTNHuwuSv8DbTGFVZac02y8rztoDP0kEaUxfF5AMiHwHJ0RDKdwjKgqwgYFJMSbDV03zRBQCSFP0IwV/WRfAtcfZn/m5FSTlw5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pUtsNEbF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c6e05af3bso7279319a91.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239940; x=1768844740; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b6BFne1S4FgseBSOPk1COHyA5nUIkO8P89zUv5Rb2gM=;
        b=pUtsNEbFFpX24X7JVxEzUD3T6giafgRqWmHi1yrjtkllEi/Gnw3imJrUc15tFEWvgt
         zfnj1ItNFAp8nH0GDuZHi9W++ektz9/cRm16QHpYl6WNMwNkxp/Hzv08feRVhnPd8RtF
         6NaxOCXrMROh7JSQ79grjTxrqB1rwgRqBowkSuN6l/kIj08UTjXkFH3NA7jHV4Lakd2R
         yAwh/1epb3NHu779gQmINrHgxBjTYWb0dGz8B1JwXUw9XWF5GfGR1D0FLGdpBH1HJYhI
         8baXWMV+hGWaY3VjjJt19hyBL02jC+dCu1wukTCgxhxZ+q14jijfKsu7ODYuIDhWxc+V
         GfSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239940; x=1768844740;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b6BFne1S4FgseBSOPk1COHyA5nUIkO8P89zUv5Rb2gM=;
        b=Cp7JTtPrNMuWoZjIhshrVtWVd7PBBBvr5RkPnZCBMe9U3AxFfGyu5k4zMFdJPBaQc/
         4sATrVVffWb6GSVpldjMcEGzgHgIfZ0h9WuKl8YRQ8hSyu9v+hvr9DViD8rXK8U4ZTBN
         tubkDLM0lueKMZrzH0GDWAFTJOB27SXqrZaOl3aWLualpQYm0hz/D4LhAgT+VVaUnrU/
         Vp8Mcj6sVunL24WgWwsbEEuOzbWgb2bS8vOFyLDi65OdHvb2m+9d12WU6Xv/BWaVsjMw
         F2ohMGw/05/v+RWathHPvNvfN6GH6F066n8qYmsMWfQV5iV17UuHv80IIVyspqweUKBd
         HUmA==
X-Gm-Message-State: AOJu0Yz60IFJk8BFwAmSGuKtIfEaFNk3mv/2q250od1i8zBnJ5YQJmAA
	yL//QptJuP+DeG+LesZ6GNAQiMdTv0BXLHUyZ+8uqC9189tqQ4AXpJ00Ie2XNCaoR/luHM/GULT
	pe+FNsKgCuP5etA==
X-Google-Smtp-Source: AGHT+IEsI2icbYhsaK4X1KyC1zLSu2ju/1AzRiF/TSEOp8nhrtSL0A6azxOTDtPe8zbtUddJYq620VW3jnuqkQ==
X-Received: from pjbiq12.prod.google.com ([2002:a17:90a:fb4c:b0:34e:9b4f:a5a6])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1b08:b0:34c:75d1:6f90 with SMTP id 98e67ed59e1d1-34f68c0018dmr18551214a91.17.1768239940511;
 Mon, 12 Jan 2026 09:45:40 -0800 (PST)
Date: Mon, 12 Jan 2026 17:45:31 +0000
In-Reply-To: <20260112174535.3132800-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112174535.3132800-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260112174535.3132800-2-chengkev@google.com>
Subject: [PATCH V2 1/5] KVM: SVM: Move STGI and CLGI intercept handling
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

Similar to VMLOAD/VMSAVE intercept handling, move the STGI/CLGI
intercept handling to svm_recalc_instruction_intercepts().
---
 arch/x86/kvm/svm/svm.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 24d59ccfa40d9..6373a25d85479 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1010,6 +1010,11 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
 			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
+
+		if (vgif) {
+			svm_clr_intercept(svm, INTERCEPT_STGI);
+			svm_clr_intercept(svm, INTERCEPT_CLGI);
+		}
 	}
 }
 
@@ -1147,11 +1152,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 	if (vnmi)
 		svm->vmcb->control.int_ctl |= V_NMI_ENABLE_MASK;
 
-	if (vgif) {
-		svm_clr_intercept(svm, INTERCEPT_STGI);
-		svm_clr_intercept(svm, INTERCEPT_CLGI);
+	if (vgif)
 		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
-	}
 
 	if (vcpu->kvm->arch.bus_lock_detection_enabled)
 		svm_set_intercept(svm, INTERCEPT_BUSLOCK);
-- 
2.52.0.457.g6b5491de43-goog


