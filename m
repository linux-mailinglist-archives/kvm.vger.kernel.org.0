Return-Path: <kvm+bounces-19107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6179D900EB0
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 02:08:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC2641F21E40
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 00:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05EA81C2AD;
	Sat,  8 Jun 2024 00:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TKnyr3DM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298D415B7
	for <kvm@vger.kernel.org>; Sat,  8 Jun 2024 00:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717805214; cv=none; b=qHdCdATv3/zuqp4Ft8EmNF9+sFYF83raD8nYLJ3AuJ0FTarRrCOk0HKW+2Yl/WqcUcqHfLH1ai1Js0Tf3UzD4JXnWCXQ2WK+u2RW9wYy4rCv2HyaaZ8Mz4T3T++U2ICoRI7odxlMjyAQ6tL3v/8X9hui6rfT9XMkGwOWp75fl/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717805214; c=relaxed/simple;
	bh=CQMK/h9eb5oR6ViVQX4U3uFGNRM5CkCgrRNqS7xc64k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eR7OdBw2qyOgnVZ11ZzbGoRNSUqMizpJz54eKbx556QE9ghnsMTN1yZUQ2U8kO+Nqpv4DntGhXOdasSl/4AIpsC+MXUv/Fi6fcggczMT9+YlNIB7eml5XBj1PIqgfOwTPX3SWwPOFQGDfTH6HbyVYqCRDW2QME8/Q1n4foBIRP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TKnyr3DM; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6507e2f0615so2531392a12.1
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 17:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717805211; x=1718410011; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hcN62n3eAvJ+wQBQZ24js4P4o2/e149QwTHEtQT2vY4=;
        b=TKnyr3DMIrUaxY21uPkzmiRNOlkXMfQzAPvk5ka/SWee2REQNZVmqzEaAaFdgROC2e
         8bGZKv4B7ASktF2st8uxd5O+ydEKaOpDh1+cz0fLIrFb8KcMQWcKPXBSVxgrCfiT/H3x
         gz5eAdKZ2JC4zXlNAQgA4/yeoOZASvgVH38DI4sXR6cDEQjq+hoXBtpG9IKbdN3eJNRF
         cZkigvl9OpzVSS9WGpks1CpmLirVEMS46+ollyYr9E2X9HdJfjB26U3ruw934vMhHeuQ
         7dqYJJ98spkuTBoElXfKnCk8aeR9AMuolGHo63TA/HOaYZ/GEBxV/WkPVoyQ3RW1zg/k
         sSvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717805211; x=1718410011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hcN62n3eAvJ+wQBQZ24js4P4o2/e149QwTHEtQT2vY4=;
        b=kTpAYQUdpuqkw8vGn3LzrFnES+56JfSyX3ZttpMkqVQYpqso3gqmwrxNpRt7cwFizf
         vE7MwLnRcJzEvSsKcCHCFwPj4bS0hvSCFsxMDA9pF4FFbCf+I8R4sEZXbnCoDiFDZQ46
         YZ0/i+5BqKoLvCNXAXEl0SZpn4DwCucxWaPEsrO8K/zFBbFmtWP7T5dd7HFN4CBBeb/C
         H55V/m7P9XMmaMYCVpuZNUy20ib991zA9dFUZqyVitsmbyhT89ptfK5kBhPnCARaeqVC
         U3caVBK6czEdTvVp/NvdFrjSxuvQVKWjoBfIMYyxQHKxWN8uBKdHLPBgdvAI5TzNQn5N
         Pqfw==
X-Gm-Message-State: AOJu0Yzm3FnyYMUZ2uCwXRa1LF4m98bvLhzPRme6gpg5ZigBS4W33k/k
	hg7Y20y+BRA7Z9Zt6pyh/uqoXePFxtXm5BpbRqIA4ft4x7nNdvPFVA7Lo+pYXGWdJGDXcQKjYEW
	Ikg==
X-Google-Smtp-Source: AGHT+IGqgoQIgsdgjc/QsCSr0LlLIFd2eln/NUclIt/hIDKFvlhwEYksb1GJZEUAX2hQBnqbPh5Y3juuvUA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4e03:0:b0:659:23db:a4b2 with SMTP id
 41be03b00d2f7-6e15eaaf307mr8542a12.8.1717805211114; Fri, 07 Jun 2024 17:06:51
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Jun 2024 17:06:36 -0700
In-Reply-To: <20240608000639.3295768-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240608000639.3295768-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240608000639.3295768-6-seanjc@google.com>
Subject: [PATCH v3 5/8] KVM: Add arch hooks for enabling/disabling virtualization
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add arch hooks that are invoked when KVM enables/disable virtualization.
x86 will use the hooks to register an "emergency disable" callback, which
is essentially an x86-specific shutdown notifier that is used when the
kernel is doing an emergency reboot/shutdown/kexec.

Add comments for the declarations to help arch code understand exactly
when the callbacks are invoked.  Alternatively, the APIs themselves could
communicate most of the same info, but kvm_arch_pre_enable_virtualization()
and kvm_arch_post_disable_virtualization() are a bit cumbersome, and make
it a bit less obvious that they are intended to be implemented as a pair.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 14 ++++++++++++++
 virt/kvm/kvm_main.c      | 14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 96ad3e8b9ddb..12ef3beb4e47 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1514,6 +1514,20 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+/*
+ * kvm_arch_{enable,disable}_virtualization() are called on one CPU, under
+ * kvm_usage_lock, immediately after/before 0=>1 and 1=>0 transitions of
+ * kvm_usage_count, i.e. at the beginning of the generic hardware enabling
+ * sequence, and at the end of the generic hardware disabling sequence.
+ */
+void kvm_arch_enable_virtualization(void);
+void kvm_arch_disable_virtualization(void);
+/*
+ * kvm_arch_hardware_{enable,disable}() are called on "every" CPU to do the
+ * actual twiddling of hardware bits.  The hooks are called all online CPUs
+ * when KVM enables/disabled virtualization.  Enabling/disabling is also done
+ * when a CPU is onlined/offlined (or Resumed/Suspended).
+ */
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7bdd744e4821..e20189a89a64 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5505,6 +5505,16 @@ static DEFINE_PER_CPU(bool, hardware_enabled);
 static DEFINE_MUTEX(kvm_usage_lock);
 static int kvm_usage_count;
 
+__weak void kvm_arch_enable_virtualization(void)
+{
+
+}
+
+__weak void kvm_arch_disable_virtualization(void)
+{
+
+}
+
 static int __kvm_enable_virtualization(void)
 {
 	if (__this_cpu_read(hardware_enabled))
@@ -5604,6 +5614,8 @@ static int kvm_enable_virtualization(void)
 	if (kvm_usage_count++)
 		return 0;
 
+	kvm_arch_enable_virtualization();
+
 	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
 			      kvm_online_cpu, kvm_offline_cpu);
 	if (r)
@@ -5634,6 +5646,7 @@ static int kvm_enable_virtualization(void)
 	unregister_syscore_ops(&kvm_syscore_ops);
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 err_cpuhp:
+	kvm_arch_disable_virtualization();
 	--kvm_usage_count;
 	return r;
 }
@@ -5647,6 +5660,7 @@ static void kvm_disable_virtualization(void)
 
 	unregister_syscore_ops(&kvm_syscore_ops);
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
+	kvm_arch_disable_virtualization();
 }
 
 static int kvm_init_virtualization(void)
-- 
2.45.2.505.gda0bf45e8d-goog


