Return-Path: <kvm+bounces-28299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 911F39973C5
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:51:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C30D81C22EDB
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E0D1D4176;
	Wed,  9 Oct 2024 17:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TEmHu0RP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A791E1A0F
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 17:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728496213; cv=none; b=EL4Zg9EnN7Hm/+JqL4h94wxu5ztBR4BNeEhwNIJfZH7BaC9D9Lt+7hASEPd66HaW3xvb0DyPd1twzjDpiJPw+pzrT6Bg7y74q0ePpPjyIT6qq8y8hYHT65W4qF6HMgxlHtJev6FWE11AEly0c/EBDb5P+EBLEwHH86elCi3qXqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728496213; c=relaxed/simple;
	bh=SGkZJcqM6l7cc+bXFGwWYrJw06CpvtpeZuEcwNGJSXM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sheTgevSfvp64p5C563QSOGBfgeqcg/AAO5o/4KmcAAdXFGUIqDXOiEHrKapEHqgqxlnLIfY9gGew+RSZc1yI30VuySgIn81CDN9C70DONYrhif3S2XFbYJ7XZUGQOYKOHTlUOW/pY7vpcoLte/OHORl99d76wOECtNuehxhP90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TEmHu0RP; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e019ab268so77712b3a.2
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 10:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728496211; x=1729101011; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AwyBAzSnZj8uKv6KW6XIzrczvMSQb4MHq6nrZHBBhJE=;
        b=TEmHu0RPEu+YlIiSTs4vjdGaYVOcftqmesl7VGz8OmdCiuqiT2sJjcy4OYPYzsPa2F
         eOv97SOzPLJ92DnZlI2foFGr5cF6ASnvRrSRs2dNw9KTyZHG8ZVc9ymmzbSkgmDtW68d
         5gwahUPt3KNJW+93W+MhnIlKALRD1TbsM0XLePqD6gknLgH+FmjCIUvAZ9M9zV1C75A9
         kLdPao7oIpPJlxmYze+YLVKXIOMU5bF+LG2lWMebeXgEllRhJdimq2Apz8q6ZHnp5iRg
         LmKESrObjbpbt9V9D2GWBtw9NKk7+nSN9HP68i/17k7EJxk0XeZmx8DZ3rsCY82aCQvf
         BZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728496211; x=1729101011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AwyBAzSnZj8uKv6KW6XIzrczvMSQb4MHq6nrZHBBhJE=;
        b=Ky3AP0ZeNLysiewspObu+JMhWX0XZw7b0W6eSStcnJXb79ZrDcnXZAgLlVuSSvV8d2
         80kQb0qZWysInYDQdkSI+1O6e/dVVPt95Zpak9enmJe12cohPKDed3thq3EDdAAq1Yhq
         8JlfcbeWhgt6fU1ijLMcOmqIzn4iDRfBERFwULSQht7ySPjys3MyVMUfealSRe913daX
         f0RO7Z4woLGmM33rrYOtr6JVSlHB27aRrx13ISJySAYMQhVWduA33quD89ZO6brBSzkX
         zf0El7FRoaljbVanW0DG0+brAQfgXxwI40An6+6kr5UbhT1ffVp6H6ZbyY/mYoSUUbJz
         vTuQ==
X-Gm-Message-State: AOJu0YxorhlhDq+r+MUK+6ygCkAX2lWqsDZcxhvdHHtXmtRCyzTUa7eG
	MwdB98TyNaXkQsyQYPL3k12B4hu126MSxrg1c13LuX8Ay5VpSmGuP1RyHzwakoILfTcZzq+2vyL
	3jw==
X-Google-Smtp-Source: AGHT+IEUDzIOqyoe2fHUURoFuYYcS3+r+FH0yq7uJsmpfcv/LkNzTroW0jRCSQ+Vt3s4Kg9OOtr2wC8SkO0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9199:b0:71e:1e8:e337 with SMTP id
 d2e1a72fcca58-71e1dbe467fmr3709b3a.4.1728496210470; Wed, 09 Oct 2024 10:50:10
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 10:50:01 -0700
In-Reply-To: <20241009175002.1118178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009175002.1118178-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009175002.1118178-4-seanjc@google.com>
Subject: [PATCH v4 3/4] KVM: x86: Add lockdep-guarded asserts on register
 cache usage
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

When lockdep is enabled, assert that KVM accesses the register caches if
and only if cache fills are guaranteed to consume fresh data, i.e. when
KVM when KVM is in control of the code sequence.  Concretely, the caches
can only be used from task context (synchronous) or when handling a PMI
VM-Exit (asynchronous, but only in specific windows where the caches are
in a known, stable state).

Generally speaking, there are very few flows where reading register state
from an asynchronous context is correct or even necessary.  So, rather
than trying to figure out a generic solution, simply disallow using the
caches outside of task context by default, and deal with any future
exceptions on a case-by-case basis _if_ they arise.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index b1eb46e26b2e..36a8786db291 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -43,6 +43,18 @@ BUILD_KVM_GPR_ACCESSORS(r14, R14)
 BUILD_KVM_GPR_ACCESSORS(r15, R15)
 #endif
 
+/*
+ * Using the register cache from interrupt context is generally not allowed, as
+ * caching a register and marking it available/dirty can't be done atomically,
+ * i.e. accesses from interrupt context may clobber state or read stale data if
+ * the vCPU task is in the process of updating the cache.  The exception is if
+ * KVM is handling a PMI IRQ/NMI VM-Exit, as that bound code sequence doesn't
+ * touch the cache, it runs after the cache is reset (post VM-Exit), and PMIs
+ * need to access several registers that are cacheable.
+ */
+#define kvm_assert_register_caching_allowed(vcpu)		\
+	lockdep_assert_once(in_task() || kvm_arch_pmi_in_guest(vcpu))
+
 /*
  * avail  dirty
  * 0	  0	  register in VMCS/VMCB
@@ -53,24 +65,28 @@ BUILD_KVM_GPR_ACCESSORS(r15, R15)
 static inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
 					     enum kvm_reg reg)
 {
+	kvm_assert_register_caching_allowed(vcpu);
 	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 }
 
 static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
 					 enum kvm_reg reg)
 {
+	kvm_assert_register_caching_allowed(vcpu);
 	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
 }
 
 static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
 					       enum kvm_reg reg)
 {
+	kvm_assert_register_caching_allowed(vcpu);
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 }
 
 static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
 					   enum kvm_reg reg)
 {
+	kvm_assert_register_caching_allowed(vcpu);
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
 }
@@ -84,6 +100,7 @@ static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
 static __always_inline bool kvm_register_test_and_mark_available(struct kvm_vcpu *vcpu,
 								 enum kvm_reg reg)
 {
+	kvm_assert_register_caching_allowed(vcpu);
 	return arch___test_and_set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 }
 
-- 
2.47.0.rc1.288.g06298d1525-goog


