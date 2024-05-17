Return-Path: <kvm+bounces-17699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 764238C8BAF
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:54:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32ACB286371
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B1BD13FD9D;
	Fri, 17 May 2024 17:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cneBLwrI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAAB13FD9A
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967674; cv=none; b=o5d0KhPfjGWQo0wo8pgNL242TzHqKxfKV8R1i6y5k4gYT+frO06cm4mhygAWuC4ykgFXd/5/nuZeaEQu7iqlOpV+L/0gFmYjb99u/31A/bXnsK/Q9IIkExcRUa7vPK7lr+HH6CUtvMAjIR8gVYjXh9f+tPpVtmhnMwqsdVQMJ7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967674; c=relaxed/simple;
	bh=DbRs/X4W9CfO4QMBHQGwEV70PLWdGInmhoZ6jcJx+o4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CKc3OFY2p9MlqVlarGqGUrpMtzSWzq7kRHWOoy4DrN3bpX3ZxzZMHfksrEOdkZUDQEkfzT9BHEJQ9ibHRfOhF/XZrrbjAZIa59MeDjtgs4c1Rlu96dAfM9ClHGZHD4FGLE5lVeZohrOyiIDDL3097eS9CfCjZavXDFCJxvwR4l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cneBLwrI; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6f4755be972so6418308b3a.0
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967673; x=1716572473; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tJWRXOUZEf0tFhXUEsVYsHdLmAwURDTHhDYt6uCUFks=;
        b=cneBLwrIX/09t74mq/vj2oGl7EdY6CzBbaoPFAs6EyDOq0tf/X1PUqqUwEEKxr/3o2
         KGfNb4TO37BhPeXQ+pNImpudUN5fjj7hLYkrt5mnHXk2Z61tZRC9aXmtZ2X2yiq51GFI
         w5aE9i7IU31qVorTn6XJ7xsrTvsS6FHA6Ayb0oKMsefVWkEmA9dbNfGHr85gy97CsBYF
         tX35ayncrgUWAxodsLaLDGet3KoidumE1f/t2dlWSJY2EnbCBCNYcK4DTd/zh+vtzF/r
         uHyMDwTBgO59jL0tXKEtyjCE9XZi/40W+6/G9nyf+0JyHbboqsFEsRkNobKtWgD8TYyO
         gwdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967673; x=1716572473;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tJWRXOUZEf0tFhXUEsVYsHdLmAwURDTHhDYt6uCUFks=;
        b=U71Yar8e1itLJq5mW+GHjWPOq/D/wTXUBbd23CYycxsffkJBZyD6cogjtfpGTKCYZx
         PdyrnLvGwKyhH+FbZx0y3ZNRbpia6+Ys4htk6a+5axmzYnffT2JyJAVqGg3121bMP5WZ
         hFoCem2iiDNgjKeeGghBT6jOjrKzlUDiWFH4Ob3BEwSZV7GJsqBqXj1Z7yk29k2d9ABm
         SDwG26lXpw9cQvLKE+UjtL0PSeAJ90YbpNAKuucVJSnrhCGJ+bn+R0Un0ndRIax0UyKx
         srWNME6PHyf7TMLvp1jNDjp7OlB7EdPBMzXrGnLl/Mv0kW1mehEpsv1IRq+yGbYQTjZi
         Oyvg==
X-Gm-Message-State: AOJu0YzJ/5wlgKo65zHUrkusJ5mlz37RtGaOo7wHri76+WJVdc9kXSTD
	faysUcIWKRh607fMeQQig81Ky97Slxfq2jGVGlQ86Pt2mstL2cuXuR0DJrFxOU7TVBANeGBfYtF
	cgA==
X-Google-Smtp-Source: AGHT+IEoiu5oVtBc2xte06xumcU1fR7G2fGD82bViLeMfqX3DwDl7AOxQ5irBK30N+71sDLyuskNw3VKqWs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1397:b0:6ea:8a0d:185f with SMTP id
 d2e1a72fcca58-6f4e02a64c3mr1357360b3a.2.1715967672755; Fri, 17 May 2024
 10:41:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:24 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-48-seanjc@google.com>
Subject: [PATCH v2 47/49] KVM: x86: Drop superfluous host XSAVE check when
 adjusting guest XSAVES caps
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Drop the manual boot_cpu_has() checks on XSAVE when adjusting the guest's
XSAVES capabilities now that guest cpu_caps incorporates KVM's support.
The guest's cpu_caps are initialized from kvm_cpu_caps, which are in turn
initialized from boot_cpu_data, i.e. checking guest_cpu_cap_has() also
checks host/KVM capabilities (which is the entire point of cpu_caps).

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 1 -
 arch/x86/kvm/vmx/vmx.c | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 06770b60c0ba..4aaffbf22531 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4340,7 +4340,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * the guest read/write access to the host's XSS.
 	 */
 	guest_cpu_cap_change(vcpu, X86_FEATURE_XSAVES,
-			     boot_cpu_has(X86_FEATURE_XSAVE) &&
 			     boot_cpu_has(X86_FEATURE_XSAVES) &&
 			     guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE));
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 741961a1edcc..6fbdf520c58b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7833,8 +7833,7 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * to the guest.  XSAVES depends on CR4.OSXSAVE, and CR4.OSXSAVE can be
 	 * set if and only if XSAVE is supported.
 	 */
-	if (!boot_cpu_has(X86_FEATURE_XSAVE) ||
-	    !guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
 		guest_cpu_cap_clear(vcpu, X86_FEATURE_XSAVES);
 
 	vmx_setup_uret_msrs(vmx);
-- 
2.45.0.215.g3402c0e53f-goog


