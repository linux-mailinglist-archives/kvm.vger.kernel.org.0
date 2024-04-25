Return-Path: <kvm+bounces-16005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB6838B2DB5
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 01:41:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A23EA285182
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 23:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC57716D9CD;
	Thu, 25 Apr 2024 23:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kWb5CGXw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B063F15F400
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 23:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714088404; cv=none; b=DrlzTa0YtAg9oO9sRdD3xrVxhKkbJzfxsiK1r1n5unZPfCS14mI56quWvOuKK7xQqiXbkWmTnVeRy7Qe2kNOif7y2/nWRSDTy1sg6/W+cqKM7Je+R0W3kIqCdruOQ2VmYGdeuJJzNArDZfdgsYa30cEVJg1IluernJSvd6mivY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714088404; c=relaxed/simple;
	bh=MJPzSo3K8o6iA/n7UkA1+bc7lne1qdZDGEpRTlZuZI8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EYQwRD2or+24B1kkzfGwj+N8UEwwlh4izbTOICXH2X/ZAhk7rU8Lz1t7qgVLUwTPoQwwATqTJQhhnOJimgyL4OId5QCZM6TPlROSgWtd+gunPvpmTzAp84tdZq+uAaCbVMsWrP5XdGJqcuXOZ05/ZroEgNW4FgzV5k/j4glViu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kWb5CGXw; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6081a08df8fso1751354a12.1
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 16:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714088402; x=1714693202; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/NaaHWoathmI+8UuflB46ON2NyuL/ZRdqhokuCuaP+c=;
        b=kWb5CGXwcxHKV1ARYh6UbIfHiH7abNDR0NuP024bHAlszl+iefVnZk4q7nKLhbNY7u
         x86DpVFTUYqLvKBj+9FDelYE+Op67K29tAWYfC3Y/6WdbQQsganyBKoKl8u2wTQcvq4H
         JUGf5rf4aQjCt4k0bLhzf9F7TDFc1270QgrhKtFcKHBdExz8Rnvexc5ElhdSpZg1kkks
         A6YiikhtgRBTMVa9/TQyLe9VA4VHDQjY6oISjymKil/MymgT5FI0D5S/s8B9iCjc30jM
         Dw5w4aEphVfohyN5gifalK9G04YjeRlPyzm9mWX+vUayAlT5zYJikKaLaUtS2Y6TTqzY
         +HUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714088402; x=1714693202;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/NaaHWoathmI+8UuflB46ON2NyuL/ZRdqhokuCuaP+c=;
        b=WGxnYfmyd+i5r1oCFm2AlCjHRbXZU+0unCNWo0G6bU5ScpgZpAxX/qPyDGnO1w07fK
         UCzX5TeYEw8Cr7+ud9KvG31JoEayU5RKDTAsYW1oFhvqZHydjoNoKOipKZlYQYIqtTNH
         9luV51Sm9BLFsFfifm2F00hlbuEYelvJ6zqFcrJgfOYEOXVjocOxAA4I69UEXXSW3mZu
         LcMps6QQfe2BZaaiIJUqMVpt4FjhkOyubGP8bC+fECspd5ltmUqvj8xsbiO+Z/0dJWU7
         APRllYO4O2HSW3NGoE2RrLQtIpwcnHl2ZvCmW/CLw7sfu+9EPyq8PDKIYY4WhO7c/t8j
         oDMw==
X-Gm-Message-State: AOJu0YzgRIiEiPw0xGuFVQn+wUMaaObprH8Y0EvpZfJid/q6O1NI+L9v
	w3kpKVMSRRit1iC1OcHaG5DvhmjQGDNUppmaqikMHYyYdhDVDDFT4i4lhK+mgUFuz+EJhT3e118
	wUw==
X-Google-Smtp-Source: AGHT+IFEk/4Fpza+8/ED6blAeYExygS554kH4VB6EPG3G987AZdrRXIKgQ/Bx3DMkpGtNN8vV2lMWQft4DQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5b21:0:b0:5dc:6127:e8b6 with SMTP id
 p33-20020a635b21000000b005dc6127e8b6mr3641pgb.3.1714088401803; Thu, 25 Apr
 2024 16:40:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Apr 2024 16:39:51 -0700
In-Reply-To: <20240425233951.3344485-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425233951.3344485-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240425233951.3344485-5-seanjc@google.com>
Subject: [PATCH 4/4] KVM: Rename functions related to enabling virtualization hardware
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Rename the various functions that enable virtualization to prepare for
upcoming changes, and to clean up artifacts of KVM's previous behavior,
which required manually juggling locks around kvm_usage_count.

Drop the "nolock" qualifier from per-CPU functions now that there are no
"nolock" implementations of the "all" variants, i.e. now that calling a
non-nolock function from a nolock function isn't confusing (unlike this
sentence).

Drop "all" from the outer helpers as they no longer manually iterate
over all CPUs, and because it might not be obvious what "all" refers to.
Instead, use double-underscores to communicate that the per-CPU functions
are helpers to the outer APIs.

Prepend "kvm" to all functions to prepare for exposing the outermost
enable/disable APIs to external users (Intel's TDX needs to enable
virtualization during KVM initialization).

Lastly, use "virtualization" instead of "hardware", because while the
functions do enable virtualization in hardware, there are a _lot_ of
things that KVM enables in hardware.

E.g. calling kvm_hardware_enable() or kvm_hardware_enable_all() from
TDX code is less intuitive than kvm_enable_virtualization().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ad1b5a9e86d4..7579bda0e310 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -139,8 +139,8 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 #define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
 			.open		= kvm_no_compat_open
 #endif
-static int hardware_enable_all(void);
-static void hardware_disable_all(void);
+static int kvm_enable_virtualization(void);
+static void kvm_disable_virtualization(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -1213,7 +1213,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_arch_destroy_vm;
 
-	r = hardware_enable_all();
+	r = kvm_enable_virtualization();
 	if (r)
 		goto out_err_no_disable;
 
@@ -1256,7 +1256,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
 #endif
 out_err_no_mmu_notifier:
-	hardware_disable_all();
+	kvm_disable_virtualization();
 out_err_no_disable:
 	kvm_arch_destroy_vm(kvm);
 out_err_no_arch_destroy_vm:
@@ -1345,7 +1345,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #endif
 	kvm_arch_free_vm(kvm);
 	preempt_notifier_dec();
-	hardware_disable_all();
+	kvm_disable_virtualization();
 	mmdrop(mm);
 }
 
@@ -5490,7 +5490,7 @@ EXPORT_SYMBOL_GPL(kvm_rebooting);
 static DEFINE_PER_CPU(bool, hardware_enabled);
 static int kvm_usage_count;
 
-static int hardware_enable_nolock(void)
+static int __kvm_enable_virtualization(void)
 {
 	if (__this_cpu_read(hardware_enabled))
 		return 0;
@@ -5512,10 +5512,10 @@ static int kvm_online_cpu(unsigned int cpu)
 	 * be enabled. Otherwise running VMs would encounter unrecoverable
 	 * errors when scheduled to this CPU.
 	 */
-	return hardware_enable_nolock();
+	return __kvm_enable_virtualization();
 }
 
-static void hardware_disable_nolock(void *ign)
+static void __kvm_disable_virtualization(void *ign)
 {
 	if (!__this_cpu_read(hardware_enabled))
 		return;
@@ -5527,7 +5527,7 @@ static void hardware_disable_nolock(void *ign)
 
 static int kvm_offline_cpu(unsigned int cpu)
 {
-	hardware_disable_nolock(NULL);
+	__kvm_disable_virtualization(NULL);
 	return 0;
 }
 
@@ -5546,7 +5546,7 @@ static void kvm_shutdown(void)
 	 */
 	pr_info("kvm: exiting hardware virtualization\n");
 	kvm_rebooting = true;
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	on_each_cpu(__kvm_disable_virtualization, NULL, 1);
 }
 
 static int kvm_suspend(void)
@@ -5562,7 +5562,7 @@ static int kvm_suspend(void)
 	lockdep_assert_not_held(&kvm_lock);
 	lockdep_assert_irqs_disabled();
 
-	hardware_disable_nolock(NULL);
+	__kvm_disable_virtualization(NULL);
 	return 0;
 }
 
@@ -5571,7 +5571,7 @@ static void kvm_resume(void)
 	lockdep_assert_not_held(&kvm_lock);
 	lockdep_assert_irqs_disabled();
 
-	WARN_ON_ONCE(hardware_enable_nolock());
+	WARN_ON_ONCE(__kvm_enable_virtualization());
 }
 
 static struct syscore_ops kvm_syscore_ops = {
@@ -5580,7 +5580,7 @@ static struct syscore_ops kvm_syscore_ops = {
 	.shutdown = kvm_shutdown,
 };
 
-static int hardware_enable_all(void)
+static int kvm_enable_virtualization(void)
 {
 	int r;
 
@@ -5617,7 +5617,7 @@ static int hardware_enable_all(void)
 	return 0;
 }
 
-static void hardware_disable_all(void)
+static void kvm_disable_virtualization(void)
 {
 	guard(mutex)(&kvm_lock);
 
@@ -5628,12 +5628,12 @@ static void hardware_disable_all(void)
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 }
 #else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
-static int hardware_enable_all(void)
+static int kvm_enable_virtualization(void)
 {
 	return 0;
 }
 
-static void hardware_disable_all(void)
+static void kvm_disable_virtualization(void)
 {
 
 }
-- 
2.44.0.769.g3c40516874-goog


