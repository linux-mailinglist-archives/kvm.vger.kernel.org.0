Return-Path: <kvm+bounces-57453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 34FBDB55A0B
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:26:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 887861CC5EBE
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62CE2D29D0;
	Fri, 12 Sep 2025 23:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0iF/PjD9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD062D23A4
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719425; cv=none; b=pPQJ+RGaaz6dW3a9PqKSAlh32aS2432eGozJTFJ6fievUdc9XSfPJt+dFZR+Y0WyLKxFgvhkLXV7nbH1qZ2DacnlP3xLO95AnHjcYFtAWhXURFZsOMisJ94/AXANNIOuSZC4C1+kweEKVNRrCQQ3mttHY16JLi9fWACkaU+jZd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719425; c=relaxed/simple;
	bh=7/QfmUh94cpKnRYcIs/AdmMBk2eIOUXj9qsTocROstw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ttXVVteURJy5GESzx9se5my5c0mkWNNeSdRBBC/BApCUjoNYdxxM0nmn3ch6RIKcaAgOWe+yuh/2fU7HAPJA/0+we8Z2MXNzjagAFC/YUZIMR7I8TTvG3tESf3NVO+/LX12h91BbdivZmCE9tfl1DdFzRKf74spAWyQovhErLB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0iF/PjD9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-329b750757aso2132352a91.1
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719423; x=1758324223; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=f+rSSX++v1qgnsGhpIx8DklxJ9wJTs1Gj78GbeI9Rw8=;
        b=0iF/PjD95vLy/LkAWHsSqQbYARSoOs+rvzEC7tcCVSoShoXnbko19mzDa1b01IuscM
         K++z00mCKi3vmXRf/EX7O0waRa1mgwzrwFvZiRfDbSa4X93+dK6laUFAOAfqEZ/XHs3C
         WqvAKZRH+DLaWpMt6IOGQi3Tbt7D7ToFhNvg9nChSogiGAwvcZOrfsqhvVBFs9+zktZw
         krYytDA1PVYXawf68NYJzGof9YbUZOuWyNg06VEggXA9zXM3kpBmDxwtz8NnmvmnwO58
         zlgBn1pLnH8DYE7fy/OZXka5BVacDzw1qbfhYkjw/8jR7zRWtE2hHMo0mzCFtT4S2eue
         L9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719423; x=1758324223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f+rSSX++v1qgnsGhpIx8DklxJ9wJTs1Gj78GbeI9Rw8=;
        b=nGRSnMjm/COCN/4a7k0yD/mzY0jpdj67acJQxibY+3xZlzH6WuuFiDH3q6F5Hoq9X4
         yd5o+CUJ6n+ps3S+Fx2vIEGkeY4+Ypc7gjWsKuuSEb1Y+g5XUxMZkljpUohClAwE2+jL
         JqAk2cCPyMMdUDeYq/w7j0wB6lKBJ7Y+Sq6d97NuCiebNM+2Wqmz9SPxbIJrQVlbuhQk
         ZHLzlhjzXuKyzK1eq+QLqY7wZmfjrbcnbSjoqsxfVwl4oeGBQ4mz1taa/iC/Qijnkc9j
         eQl6W5RK5OMaqAJoxMM6Y1yQXqQafmwxj5occUlSNWeIzbg/HuvZtRMP8QvJ7l2rjRZ/
         kk6g==
X-Gm-Message-State: AOJu0YzbuyD3RBsOkkYEMFQljlvQm70rOFpWTqtsu4jBXHc/Q4sIeED0
	ILK4os8AYH60fSG+Ab37KMUR0gJQXRERWEGQVXokqd2RIfcxGHAVLZNhPczNvvymganF277FhFd
	WqPcYIQ==
X-Google-Smtp-Source: AGHT+IH1eNU2hQP1gvDQaW9z3NfGk3O72hFIvwJ884+L0C1h8IQkwA5/mG7MdJMxGMHC4seZBdGAjvKVpos=
X-Received: from pjm14.prod.google.com ([2002:a17:90b:2fce:b0:325:7c49:9cce])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec83:b0:32b:9506:1773
 with SMTP id 98e67ed59e1d1-32de4fc1430mr5296039a91.33.1757719423002; Fri, 12
 Sep 2025 16:23:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:48 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-11-seanjc@google.com>
Subject: [PATCH v15 10/41] KVM: x86: Add fault checks for guest CR4.CET setting
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Check potential faults for CR4.CET setting per Intel SDM requirements.
CET can be enabled if and only if CR0.WP == 1, i.e. setting CR4.CET ==
1 faults if CR0.WP == 0 and setting CR0.WP == 0 fails if CR4.CET == 1.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a95ca2fbd3a9..5653ddfe124e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1176,6 +1176,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
 		return 1;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_is_cr4_bit_set(vcpu, X86_CR4_CET))
+		return 1;
+
 	kvm_x86_call(set_cr0)(vcpu, cr0);
 
 	kvm_post_set_cr0(vcpu, old_cr0, cr0);
@@ -1376,6 +1379,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && !kvm_is_cr0_bit_set(vcpu, X86_CR0_WP))
+		return 1;
+
 	kvm_x86_call(set_cr4)(vcpu, cr4);
 
 	kvm_post_set_cr4(vcpu, old_cr4, cr4);
-- 
2.51.0.384.g4c02a37b29-goog


