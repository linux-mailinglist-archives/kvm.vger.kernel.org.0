Return-Path: <kvm+bounces-19106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF6EC900EAD
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 02:07:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97E9F284FB4
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 00:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F29D1175BE;
	Sat,  8 Jun 2024 00:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YTC645Sx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A26CD51D
	for <kvm@vger.kernel.org>; Sat,  8 Jun 2024 00:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717805212; cv=none; b=kpLoBB6mW5REfYiC+QMsyn0MMlJWhhqGEu7tGJ+xzwwRDTUyC9ozsRjZ7X4vKdWOfmXTlObi4X6JBbOlCgwppz2lXZSh5WNfoHNuClDCYNHgbymLUJe3+9MfPAe78GT4p3i3oySUzsPPe+JsWKw1DWa4Gyy0sed9Afq1gylVVR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717805212; c=relaxed/simple;
	bh=kosHQz2mO5WsDhLLqPXFZqPb2PZkIqYIvZGswimzFcE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YZt51uU96QFt6p49wz+w6IQ8EwIgVfhT1lPcZiWcsD6BHLhc/t3TVtsJWvlRG35gbLmnpTMv1EQFZnqMNtCIpGiDaYhbkTz947ybwEegV7M6Z6clWfya4J4yXkVpXTPt6X7mK/GTrhzTZZoYOrIXJilkQNnsKKqzfsSkh3pSxgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YTC645Sx; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-627e9a500faso43517857b3.1
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 17:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717805209; x=1718410009; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=U44HT/MSZO+MfGZ9R6nvDDZFtdhwkwnAqQLWwNh4/1A=;
        b=YTC645Sx/o+2Hf/holcYvVQV2vL1CfjQRv7IO1YIiSkwFwZg9qPFWwTSHRGL2D342+
         UmhCDQFrUZhMjqzujwawLsrvhuyiIBN0qDSqFIAnk1Hu0luUqT6Tdf5s58oiuJJZOjAi
         QSFkaBdGrrEfeDRx/ATFTEUt8kqsDReilNurIjFdi34LoTe77CAYzNe8HCkjziudHehH
         DzUrXL+kPCrmV/J1qr/eWOua+pLdkN3emVvLRMnMK/2ecEOIENHRVQpH0piCzRxXgzqu
         qIgDkkzb+26gqAfdsFlc4Qb08RMEa4He+NY2kfClr4QCaJJRz68imWj532NsYgEIqco0
         NqGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717805209; x=1718410009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U44HT/MSZO+MfGZ9R6nvDDZFtdhwkwnAqQLWwNh4/1A=;
        b=aQ55s7atNvEwh8P5/IatYx16cWvYr/+nIr/0+gTFOZLer3IoS4EK4aGrkh3ezTFWTg
         VQAEwQvw3EBRtnGd5++3KpIQFyuoXb4t5S5d9AUZR2kY2VRUoNVbz8OjIuA0pXxn4qSJ
         YZdDxbcVHI3z1OdLAKpFVCOikQGdpnFGMuOK8MN5ou9wGai8PPy4pJ+/cMpvLp9kAzSZ
         IhO9uUfx8QLQjCynblD2qeA6ji+iCc0GnBE55aG3ujSoUwFvX27/6RS9mSIQRTos2+A3
         YFe0mXyf0IPt0hV+uSAjpNIhAQmdNe1xkLGzicR74vxj2DGC07W9mFOASWrJ3EJRIohn
         04Dg==
X-Gm-Message-State: AOJu0YxV2Hd+UV6+LlO3gr8MkAJ+TK+d1vXZ3b2UJwh0qZSG13yxGLl9
	fw4X7jX3r7ivZWuApMdpG4YwJ3JtU4v/o5wYmCQhxWt0gMRM5ZlO3qvhIzcy7pP3DqaoZcwrhvL
	vkQ==
X-Google-Smtp-Source: AGHT+IHRwQ4x9TCmQSW6AWp9+/8y2WG7Y4nCfpX6fD0I2kzjUWVv+BUZsTJw8+ZiUMqV0PE2GMOJIENNeyk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18cf:b0:dfa:48f9:1855 with SMTP id
 3f1490d57ef6-dfaf65228b6mr492235276.3.1717805209598; Fri, 07 Jun 2024
 17:06:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Jun 2024 17:06:35 -0700
In-Reply-To: <20240608000639.3295768-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240608000639.3295768-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240608000639.3295768-5-seanjc@google.com>
Subject: [PATCH v3 4/8] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add an off-by-default module param, enable_virt_at_load, to let userspace
force virtualization to be enabled in hardware when KVM is initialized,
i.e. just before /dev/kvm is exposed to userspace.  Enabling virtualization
during KVM initialization allows userspace to avoid the additional latency
when creating/destroying the first/last VM.  Now that KVM uses the cpuhp
framework to do per-CPU enabling, the latency could be non-trivial as the
cpuhup bringup/teardown is serialized across CPUs, e.g. the latency could
be problematic for use case that need to spin up VMs quickly.

Enabling virtualizaton during initialization will also allow KVM to setup
the Intel TDX Module, which requires VMX to be fully enabled, without
needing additional APIs to temporarily enable virtualization.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 98e52d12f137..7bdd744e4821 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5495,6 +5495,9 @@ static struct miscdevice kvm_dev = {
 };
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+static bool enable_virt_at_load;
+module_param(enable_virt_at_load, bool, 0444);
+
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
@@ -5645,15 +5648,41 @@ static void kvm_disable_virtualization(void)
 	unregister_syscore_ops(&kvm_syscore_ops);
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 }
+
+static int kvm_init_virtualization(void)
+{
+	if (enable_virt_at_load)
+		return kvm_enable_virtualization();
+
+	return 0;
+}
+
+static void kvm_uninit_virtualization(void)
+{
+	if (enable_virt_at_load)
+		kvm_disable_virtualization();
+
+	WARN_ON(kvm_usage_count);
+}
 #else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
 static int kvm_enable_virtualization(void)
 {
 	return 0;
 }
 
+static int kvm_init_virtualization(void)
+{
+	return 0;
+}
+
 static void kvm_disable_virtualization(void)
 {
 
+}
+
+static void kvm_uninit_virtualization(void)
+{
+
 }
 #endif /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
 
@@ -6395,6 +6424,10 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 
 	kvm_gmem_init(module);
 
+	r = kvm_init_virtualization();
+	if (r)
+		goto err_virt;
+
 	/*
 	 * Registration _must_ be the very last thing done, as this exposes
 	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
@@ -6408,6 +6441,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	return 0;
 
 err_register:
+	kvm_uninit_virtualization();
+err_virt:
 	kvm_vfio_ops_exit();
 err_vfio:
 	kvm_async_pf_deinit();
@@ -6433,6 +6468,8 @@ void kvm_exit(void)
 	 */
 	misc_deregister(&kvm_dev);
 
+	kvm_uninit_virtualization();
+
 	debugfs_remove_recursive(kvm_debugfs_dir);
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
-- 
2.45.2.505.gda0bf45e8d-goog


