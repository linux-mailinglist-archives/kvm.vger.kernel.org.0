Return-Path: <kvm+bounces-58217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6154CB8B6E2
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:01:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6ACD0A064A7
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61DF52D9EEF;
	Fri, 19 Sep 2025 21:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SmHHQDuM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D122D876C
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758319185; cv=none; b=FhiB6XK9A/DT9pT6q74DvuwcsREtRXia3f6Ps2fhpazYMu8HpwmvUv3KjVR5O9Yc1xPu5zPeVnnW6oRqPnaxJR+kc787yNHp1tncIaAAv4ioWyrpAo29uT9yPvu1WC04Ra4PACOKLt/WTU2U6Wlwo4w3h87aUBfH5Rlt5jVyzq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758319185; c=relaxed/simple;
	bh=8Jh+RI6Z0xaRv6Bb+PoIGgkgyg1mrSStf2DaNKWybYg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GEVVdKgIPzbRp6vK+N15oDyUVJQLv74C7K5EtXutGakDcVCJD3iygj+Zw17RC9gf6sRZilbfRjzEuvqEFt4Vd0lr1mj4G7RSolRow+JTw83W8ez2XKOgfAHSYqVxuj7OmzadC0D6SaEyw709q+dXd43gLSc8XbBn9OSVi1NBu/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SmHHQDuM; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77e7d9ed351so1030230b3a.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758319183; x=1758923983; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yXRUhKdqv7QBOXS5IW8XSsDl2lr8xkj1Xx7fRC9K9rI=;
        b=SmHHQDuMt+D9C36RFhuBKeQUcqMd/3JmEj0l9dxLvzWxIyT6vOlSX0/FTIqsfL4kk+
         ZGGRuGX1Z6k9/EY+6OS83RYdLIIzNqO7TJlYy0tT32g+ZCJPDhWLYB8SZu00WXQSpapH
         fd2SrNY3i0ikd77u1/EupUJhpBPZ3J3DJ8wtUlCcJVF1bRtY3otEuq7AaFNuA2BIFboZ
         d78fhbbDSsTWLOEZ8cuxYQ/D26HCd//nKd0olMpgS0KX1isSPIJcKdauh6TI3IRUQbFi
         EOjy0Oln50vWle5xHBV6mj0myMS8d8HSUyx3q+2jucbmh3B4ZGLRfNFOmZxrRKOP/o9P
         pG0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758319183; x=1758923983;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yXRUhKdqv7QBOXS5IW8XSsDl2lr8xkj1Xx7fRC9K9rI=;
        b=vjG9uGBBTc8DLhFKIxPbXX6ett156IHKeOrKHwjGETAEsxWzP3QKw5fF0sAaz2EPVl
         21KISGwM2cRj4o2QaEPLhY2/Kh5FP/XXKcj2l4kxNcDNbc8dNi80HFyZ/r61fcOifVQk
         fkQVJ91gdROI2IAWTeaCIoAK7p4OiExG9LdOPc+Er2iEnXI06syD2XDQIixL7NsjMa+E
         +fHzvxGWO2dR3M+dan+OHvRluJaQMb0UXN/sFtXb5kzopVL3nLqi1yC0W+3E3qqQ7+Sf
         YBFSuwFbqHNw2UBY2kNd6zhaKI9WZ2GZuDwBUp9Rgh/MIUiIUmeUMbnU9o/Wgbik7z75
         LTlA==
X-Gm-Message-State: AOJu0YyH+U1OmsAK58AfVnK9Kk2uKDqC1A9fByLDaJiJt9K+Qf0ASw4Z
	3IPYsERQYfN4L0kQiJwk2SiQUyfTG1Mk4K0Z3bG9j5jO5iJfjmD/xHzs0/nt2JiqX6Qp7xua1J7
	VFBXiYQ==
X-Google-Smtp-Source: AGHT+IFGK3hjPgaXlGacRBbVGX1IoDMhTJWG7Os+7kTXV7E7SzcQdRWb3nKylAdTMvITqkXUkZRNmYKFe3o=
X-Received: from pjbsv4.prod.google.com ([2002:a17:90b:5384:b0:327:e021:e61d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7d9f:b0:248:1d25:28b1
 with SMTP id adf61e73a8af0-2925ca26ff3mr7335930637.21.1758319183358; Fri, 19
 Sep 2025 14:59:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 14:59:31 -0700
In-Reply-To: <20250919215934.1590410-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919215934.1590410-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919215934.1590410-5-seanjc@google.com>
Subject: [PATCH v4 4/7] KVM: SVM: Always print "AVIC enabled" separately, even
 when force enabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Print the customary "AVIC enabled" informational message even when AVIC is
force enabled on a system that doesn't advertise supported for AVIC in
CPUID, as not printing the standard message can confuse users and tools.

Opportunistically clean up the scary message when AVIC is force enabled,
but keep it as separate message so that it is printed at level "warn",
versus the standard message only being printed for level "info".

Suggested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>
Tested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index b4577401ce5f..b8b73c4103c6 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1167,16 +1167,15 @@ bool __init avic_hardware_setup(void)
 		return false;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_AVIC)) {
-		pr_info("AVIC enabled\n");
-	} else if (force_avic) {
-		/*
-		 * Some older systems does not advertise AVIC support.
-		 * See Revision Guide for specific AMD processor for more detail.
-		 */
-		pr_warn("AVIC is not supported in CPUID but force enabled");
-		pr_warn("Your system might crash and burn");
-	}
+	/*
+	 * Print a scary message if AVIC is force enabled to make it abundantly
+	 * clear that ignoring CPUID could have repercussions.  See Revision
+	 * Guide for specific AMD processor for more details.
+	 */
+	if (!boot_cpu_has(X86_FEATURE_AVIC))
+		pr_warn("AVIC unsupported in CPUID but force enabled, your system might crash and burn\n");
+
+	pr_info("AVIC enabled\n");
 
 	/* AVIC is a prerequisite for x2AVIC. */
 	x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
-- 
2.51.0.470.ga7dc726c21-goog


