Return-Path: <kvm+bounces-42721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95E91A7C456
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7911A189AB79
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFC6E22F386;
	Fri,  4 Apr 2025 19:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3xG6Nmqk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3168722E3E7
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795650; cv=none; b=pQvFWxqFv9Iqve0cre/gkcW9VORorAc8gZNAiQbqp3FWFpoNLED3CAVagaM76OMOSvWweN5eyp/fBX7J6nItb6VuY7GUyqGx8HynyPfLLcxd/aMP4lW70TRrJtrSs6AMe0lwq+ochshL6qDf5O/GakLYISxOOFUohNkAwcm3uII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795650; c=relaxed/simple;
	bh=IzCJp621ChpF3CQ8d6txaWCGos/Pxg81tWUUPEDnhso=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TM/5OWUOLmJJ7Ubnqp11AiEHqIMN5QGFUh1kVUUpHhNEQE//yzeRPCF/oIQbyJBxZPInsjztAmioag0Mk46UJgU2Esop+UJZvRlHOmFW9Kx6baOyeQNcrCEZQRNnUQWJNzMmO6j4L4IJP36x2i7HtVXC6EYZ5KnrgDDKQQ5OvyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3xG6Nmqk; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-af972dd0cd6so1649024a12.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795647; x=1744400447; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KYDMvc/wv5loDVXS9Aa0v44uXiIbogLzadPCYMuhYAo=;
        b=3xG6Nmqk78M9AzuOJ84gJPfIrCZLuI66N1ff2VqpwIamutnGdCwQXFgchYlnOC4NpX
         j/+mtg6U7dSmjRMpnN69JGGe0v84VufjIrtxDhhIzoPzW4r5tLFLW3oOXqyuaSSekHJS
         fssa/owanQ9Ws/tZBt77rtURM1oCttbFMbMs7WO8HLlBUfSJELGJM8kBI43uH/rG0vPi
         AUHK4IAyhap4o0hrNazfGL9VW/fM9dqVH30Uy5UV4BuVmjfhla8TJ8Qv6QN/nN2UxzRI
         gvagR20jugrjFM0FGY6o/pRK1qQyaicNcTZPAbjcpjX0GEsQDdnWn3Eu6xJYXGgLam3h
         a3pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795647; x=1744400447;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KYDMvc/wv5loDVXS9Aa0v44uXiIbogLzadPCYMuhYAo=;
        b=ABteTtEcpWU1ExljJwdFMPercu/6ldaNvhbo5PYNPHP05RioNtzyzVpVm8q6CScTPM
         IhMVELt3qp6GXOcUmZfPSrmfACv22iacS4YRLp8SboZNy90Itf8baf5w/ZFFJHLKrTUP
         /EYrma66xbmRyrHd3f23YCHoOpJGzYzRDvmijhBsys8QVuEuJJxXFjwWtk7NMYZ+5G/r
         TD8LmTcreV2FxK6LL6v2jCU6Z/lQpXLnqo4w84vjOQ5b1ZJn0Pr+ZmV8GD2o1HfjCrZ3
         uC6kjtKWMXffRdrPatMzSy0DewfPVhAKEst7666zUnpx4+gNW0I6PyZqgxVxDkDCDNzS
         8sVw==
X-Gm-Message-State: AOJu0YzXaUOoMoXE59I3xvdvjxT6Nw6gfRJxAc4iW42X9aalC5Jirjcn
	PmMVwg6B7/mNNamsf1nxb9Y4aUQBD4d9UroRnDN+68Pt03Fz0JHIAYw/PKLn4889rR7uax34V5M
	A6A==
X-Google-Smtp-Source: AGHT+IErXqsvd0WDpARxVffQQIxJmZ1gHBUNSi2cCsl6CNRLxY8uKCXZMQn+YonfMwuOH2OZCDTOEAintT4=
X-Received: from pfbay40.prod.google.com ([2002:a05:6a00:3028:b0:730:7b0c:592c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3102:b0:1f5:80eb:846d
 with SMTP id adf61e73a8af0-20107efed2bmr5565765637.10.1743795647339; Fri, 04
 Apr 2025 12:40:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:50 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-36-seanjc@google.com>
Subject: [PATCH 35/67] KVM: SVM: Clean up return handling in avic_pi_update_irte()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Clean up the return paths for avic_pi_update_irte() now that the
refactoring dust has settled.

Opportunistically drop the pr_err() on IRTE update failures.  Logging that
a failure occurred without _any_ context is quite useless.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index dcfe908f5b98..4382ab2eaea6 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -817,8 +817,6 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			struct kvm_kernel_irq_routing_entry *new,
 			struct kvm_vcpu *vcpu, u32 vector)
 {
-	int ret = 0;
-
 	/*
 	 * If the IRQ was affined to a different vCPU, remove the IRTE metadata
 	 * from the *previous* vCPU's list.
@@ -848,8 +846,11 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			.is_guest_mode = true,
 			.vcpu_data = &vcpu_info,
 		};
+		int ret;
 
 		ret = irq_set_vcpu_affinity(host_irq, &pi);
+		if (ret)
+			return ret;
 
 		/**
 		 * Here, we successfully setting up vcpu affinity in
@@ -858,20 +859,9 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		 * we can reference to them directly when we update vcpu
 		 * scheduling information in IOMMU irte.
 		 */
-		if (!ret)
-			ret = svm_ir_list_add(to_svm(vcpu), irqfd, &pi);
-	} else {
-		ret = irq_set_vcpu_affinity(host_irq, NULL);
+		return svm_ir_list_add(to_svm(vcpu), irqfd, &pi);
 	}
-
-	if (ret < 0) {
-		pr_err("%s: failed to update PI IRTE\n", __func__);
-		goto out;
-	}
-
-	ret = 0;
-out:
-	return ret;
+	return irq_set_vcpu_affinity(host_irq, NULL);
 }
 
 static inline int
-- 
2.49.0.504.g3bcea36a83-goog


