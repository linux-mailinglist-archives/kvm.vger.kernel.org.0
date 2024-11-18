Return-Path: <kvm+bounces-32022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E5F9D16FD
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 18:20:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B19451F22840
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 17:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C07199EA3;
	Mon, 18 Nov 2024 17:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MlQVdKRp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8082D1C1F19
	for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 17:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731950410; cv=none; b=NEk7oNYCIcQJhlQpmXFP4noaaTewyLDGfnil5kC4I0OOYWfT6eMAL7FU3MkB0jAdI7UnghwEzGtoj2XjRNfTCfF8QUo1iek18csc3uj59fCuHDIIDB92iZeO68cUevKIXw+0VQNqDzM9REX2O3qG/AIKDlHu8P3kZowxp8Q+Q+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731950410; c=relaxed/simple;
	bh=M3657UEqaxjhlwGguiJIV2JlitIiGOg2Rw6A7FApcAE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Phj15jBLqq2LgRXrpGNXAGT8bzKAA5trbt/Pd30U+RQyuqwlxaOmk962IUn5wcfvigZVnXCkWBvmKD2c4Zk6af2EEcU3QVfCjPkYOWR+nUOW7csn9monj1CSED+qvKhRU32pCslNvc3muozPLnur+D4NFGM+YLN8wzFB0QaNRDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MlQVdKRp; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e389bce2713so1768668276.2
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 09:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731950407; x=1732555207; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LJkNhNdMu2zqacMxiFxt/S7RLEzafW8TtjYcz3deGhk=;
        b=MlQVdKRpcL+t+4xXyRwjC260b+UqdwJWl1LQBdNJshz3z7hKdq3ABIR80mgUDBSUAs
         8TMrtFH7B06QosCE3pZq59jkVfN7L5wLdla35I2SxDkXnk/CZyIO0sUSHvWj5nktXCgW
         abLiMJTyfXLyNpZIoX+37YtnMA11kb4PMRU831vSikKhbk/sOae8qh0+g1g1s30sVdMz
         w66Ma26Vu58rnnXr9WfZWcC7HDLIIBGNy6c5kaS1paYqVAoAPZNgxM/YqJgage8fVaqU
         GX4hehZpRkguIm+Cjp3t2mERbgpNVn50yw5hgUd2LzBuBqrAONg7ikMDihYzaMv6aLNy
         pD5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731950407; x=1732555207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LJkNhNdMu2zqacMxiFxt/S7RLEzafW8TtjYcz3deGhk=;
        b=YCgiCmE73v3yanJWICPdfrK/iQdQSN1q20p27suV2e3k3EqtM/FME9aX87ZKLISbBG
         R0eTOUxL9jPX128KS+qCVMqz8h9AoDG5DXeBekKlrWXqliekiNyQyhMNQ19bVzL5im8J
         aFVxIVSNbtibpi5x1/iv4NtfzRS5VIxzqVgSgYvdTrz89kD7S10Y+FclcQggpJ4HBOF8
         HvAVCVJHwdin156kJwyToLB9NO3W0ABZwRhk/tgks7eKIdmgnVf56f0704SkbiQ2yqfp
         9sdF8RqfaprRgiPH5ZfZFhtrMMmelE6pYO4LQUi4+R9d99qiyMwikhVmq8zePDPbq8LJ
         WKjg==
X-Gm-Message-State: AOJu0YyaoFBEf2aYUeonX2gtDN2nO24o9LmQKgQ6//6luI96pXSO3CE/
	uoso7q5A8bjkHbkcBsR+kL+SXDMXTcg0aD1QktE13edYN0sy7pk4Y4r3h5CKBpVXn+qClFZ2KCo
	mXA==
X-Google-Smtp-Source: AGHT+IEKCGX3iqyqIKJGlyXgIDuMTtUBvK329iOqiDt0sB2xzK6GmqPfdKdozrddvcHp5efBeol80n+RCtw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a5b:9d2:0:b0:e38:d1e:af86 with SMTP id
 3f1490d57ef6-e3825d2828dmr9902276.2.1731950407594; Mon, 18 Nov 2024 09:20:07
 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 18 Nov 2024 09:20:01 -0800
In-Reply-To: <20241118172002.1633824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241118172002.1633824-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241118172002.1633824-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86: add back X86_LOCAL_APIC dependency
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

From: Arnd Bergmann <arnd@arndb.de>

Enabling KVM now causes a build failure on x86-32 if X86_LOCAL_APIC
is disabled:

arch/x86/kvm/svm/svm.c: In function 'svm_emergency_disable_virtualization_cpu':
arch/x86/kvm/svm/svm.c:597:9: error: 'kvm_rebooting' undeclared (first use in this function); did you mean 'kvm_irq_routing'?
  597 |         kvm_rebooting = true;
      |         ^~~~~~~~~~~~~
      |         kvm_irq_routing
arch/x86/kvm/svm/svm.c:597:9: note: each undeclared identifier is reported only once for each function it appears in
make[6]: *** [scripts/Makefile.build:221: arch/x86/kvm/svm/svm.o] Error 1
In file included from include/linux/rculist.h:11,
                 from include/linux/hashtable.h:14,
                 from arch/x86/kvm/svm/avic.c:18:
arch/x86/kvm/svm/avic.c: In function 'avic_pi_update_irte':
arch/x86/kvm/svm/avic.c:909:38: error: 'struct kvm' has no member named 'irq_routing'
  909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
      |                                      ^~
include/linux/rcupdate.h:538:17: note: in definition of macro '__rcu_dereference_check'
  538 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \

Move the dependency to the same place as before.

Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410060426.e9Xsnkvi-lkp@intel.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Sean Christopherson <seanjc@google.com>
[sean: add Cc to stable, tweak shortlog scope]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index f09f13c01c6b..887df30297f3 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -19,7 +19,6 @@ if VIRTUALIZATION
 
 config KVM_X86
 	def_tristate KVM if KVM_INTEL || KVM_AMD
-	depends on X86_LOCAL_APIC
 	select KVM_COMMON
 	select KVM_GENERIC_MMU_NOTIFIER
 	select HAVE_KVM_IRQCHIP
@@ -49,6 +48,7 @@ config KVM_X86
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
+	depends on X86_LOCAL_APIC
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
-- 
2.47.0.338.g60cca15819-goog


