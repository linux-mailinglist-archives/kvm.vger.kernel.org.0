Return-Path: <kvm+bounces-71081-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sI2JBqDPj2l7TwEAu9opvQ
	(envelope-from <kvm+bounces-71081-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:28:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D99813AA5F
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:27:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 235453055CBE
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A72298CAF;
	Sat, 14 Feb 2026 01:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gKzzSoaK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31624285050
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 01:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771032429; cv=none; b=hM8rJKbfJR4W63KtEdcn/Z0QPr2H4YNXJhulVei/pdaOOwlkLSDo3Y90PrWdpWifgHGaX3SYPP6+/ZCYpkY9cUT1jvZX+IPGm8+5/H+etk9gcdbn7W0Y91vMEKuToAbFNbCt3x8dZ6sA+wTn1Z3+5e9AqQIBi/mlETCXN4wd9xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771032429; c=relaxed/simple;
	bh=4EUvtuubXDsq2YIfpcwadRuQgjt5GtaI9Om4D5BZP9I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KaY40eAJLFQGXRcV3yvamGE7U3ZFJ9PZbctD+AoN4sMObtgc1huJXeyq4yfUuwIyI7Cl11KER7EKxjwkE33tMjbHxLaJ1Ztj71lAnOQHLc1JX+/X86fxxe8xy+g0zGXnsIvRLzWlUdge+H/eqL2/TXufRAEOCszV+fe1yhmWAjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gKzzSoaK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35658758045so1207827a91.3
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 17:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771032427; x=1771637227; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=W7MxKQiK0Ayh5SRrSHD6eYo36EclamwmJq0KYQ9dvh4=;
        b=gKzzSoaKu3CK5x+WIOQlXsAY004mj7S0TcoHF3W4e7t61Z1pK2G38ouo9Wdto0DfE7
         ux04nTFlASGw3lmZDUngUaV8wc0gsIL5KqqpLTU9FU1FsP5RfqQo5NGPaLqjA2BhOaMk
         vvNrvjYdF0/A7Xl7qncHbdITQliJiQ/+1S5vg6Isys4Fj1Q2AKNHvlAYvT7oEna5PjsB
         DC1YsgCZr6gIvJ2CqMnLkK4KjvhhGuJYqjNiAtIlq6/W/CY3fGWr/hhBhKiHjSfYhWNf
         IL2FzFZQ24MjDlzMPuGItR4YrgZ5o45tv9BGlqYN2JIBiA2WUK5gdRIJRRIH58ZNUtg5
         rceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771032427; x=1771637227;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W7MxKQiK0Ayh5SRrSHD6eYo36EclamwmJq0KYQ9dvh4=;
        b=C1aTaIBT+ER1oqBajSJXfXFMXG9gKOIyy8+iPPrbK1n7+7yvwDbmJ/7Do3G92dEeUU
         Y6BgFTSw1LgCCVFyUBad40icQJuXSv/EFTrWkQA+i8M8KFKYYzpwCA4NyCQettwZkGKj
         RJX7rBvwKWt4uqZzq3P91/4EJoXwPQqd6Vy+fygxHFccJeZtO7uekWW6YI77l/q4YzdG
         0NGtYvdm4nZZ0eGBGeI4irio3CQb6pPX11km4hddoNOLhnI/U+/V2PiWk1n34zNLoYYP
         xhDlQV4cyTtHR0rdJetm1DVvkfMWvA6hd64Q3yq4IUmRGIJ6/Ws0oNdC+7ofeAm1pndt
         6WrA==
X-Forwarded-Encrypted: i=1; AJvYcCU3gP7chAhu9OHIwCaqy4VoYSlH69CeaMA8ey32kc95eFA91ZP1lNeqrlFSeh7CT9+mx9Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHFheEEDiLHTch19c2SImBjnpIjSeQKBWCFejWahUmPzeVm8Jd
	MdmP5db8eRZTwiZGQYFsoWv9tnjvak/JrXm9iZ/rvqJWZFf0i7XiovvmSodsDf/ngbMC/mjD8EB
	nAauvrQ==
X-Received: from pjbfv20.prod.google.com ([2002:a17:90b:e94:b0:354:a52b:ba9d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c0c:b0:356:2eac:b649
 with SMTP id 98e67ed59e1d1-358448265e8mr1145384a91.7.1771032427400; Fri, 13
 Feb 2026 17:27:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Feb 2026 17:26:47 -0800
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260214012702.2368778-2-seanjc@google.com>
Subject: [PATCH v3 01/16] KVM: x86: Move kvm_rebooting to x86
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71081-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 7D99813AA5F
X-Rspamd-Action: no action

Move kvm_rebooting, which is only read by x86, to KVM x86 so that it can
be moved again to core x86 code.  Add a "shutdown" arch hook to facilate
setting the flag in KVM x86, along with a pile of comments to provide more
context around what KVM x86 is doing and why.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       | 22 ++++++++++++++++++++++
 arch/x86/kvm/x86.h       |  1 +
 include/linux/kvm_host.h |  8 +++++++-
 virt/kvm/kvm_main.c      | 14 +++++++-------
 4 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d9..77edc24f8309 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -700,6 +700,9 @@ static void drop_user_return_notifiers(void)
 		kvm_on_user_return(&msrs->urn);
 }
 
+__visible bool kvm_rebooting;
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_rebooting);
+
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
  *
@@ -13178,6 +13181,25 @@ int kvm_arch_enable_virtualization_cpu(void)
 	return 0;
 }
 
+void kvm_arch_shutdown(void)
+{
+	/*
+	 * Set kvm_rebooting to indicate that KVM has asynchronously disabled
+	 * hardware virtualization, i.e. that errors and/or exceptions on SVM
+	 * and VMX instructions are expected and should be ignored.
+	 */
+	kvm_rebooting = true;
+
+	/*
+	 * Ensure kvm_rebooting is visible before IPIs are sent to other CPUs
+	 * to disable virtualization.  Effectively pairs with the reception of
+	 * the IPI (kvm_rebooting is read in task/exception context, but only
+	 * _needs_ to be read as %true after the IPI function callback disables
+	 * virtualization).
+	 */
+	smp_wmb();
+}
+
 void kvm_arch_disable_virtualization_cpu(void)
 {
 	kvm_x86_call(disable_virtualization_cpu)();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 94d4f07aaaa0..b314649e5c02 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -54,6 +54,7 @@ struct kvm_host_values {
 	u64 arch_capabilities;
 };
 
+extern bool kvm_rebooting;
 void kvm_spurious_fault(void);
 
 #define SIZE_OF_MEMSLOTS_HASHTABLE \
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2c7d76262898..981b55c0a3a7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1630,6 +1630,13 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+/*
+ * kvm_arch_shutdown() is invoked immediately prior to forcefully disabling
+ * hardware virtualization on all CPUs via IPI function calls (in preparation
+ * for shutdown or reboot), e.g. to allow arch code to prepare for disabling
+ * virtualization while KVM may be actively running vCPUs.
+ */
+void kvm_arch_shutdown(void);
 /*
  * kvm_arch_{enable,disable}_virtualization() are called on one CPU, under
  * kvm_usage_lock, immediately after/before 0=>1 and 1=>0 transitions of
@@ -2305,7 +2312,6 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
 extern bool enable_virt_at_load;
-extern bool kvm_rebooting;
 #endif
 
 extern unsigned int halt_poll_ns;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 571cf0d6ec01..e081e7244299 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5593,13 +5593,15 @@ bool enable_virt_at_load = true;
 module_param(enable_virt_at_load, bool, 0444);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(enable_virt_at_load);
 
-__visible bool kvm_rebooting;
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_rebooting);
-
 static DEFINE_PER_CPU(bool, virtualization_enabled);
 static DEFINE_MUTEX(kvm_usage_lock);
 static int kvm_usage_count;
 
+__weak void kvm_arch_shutdown(void)
+{
+
+}
+
 __weak void kvm_arch_enable_virtualization(void)
 {
 
@@ -5653,10 +5655,9 @@ static int kvm_offline_cpu(unsigned int cpu)
 
 static void kvm_shutdown(void *data)
 {
+	kvm_arch_shutdown();
+
 	/*
-	 * Disable hardware virtualization and set kvm_rebooting to indicate
-	 * that KVM has asynchronously disabled hardware virtualization, i.e.
-	 * that relevant errors and exceptions aren't entirely unexpected.
 	 * Some flavors of hardware virtualization need to be disabled before
 	 * transferring control to firmware (to perform shutdown/reboot), e.g.
 	 * on x86, virtualization can block INIT interrupts, which are used by
@@ -5665,7 +5666,6 @@ static void kvm_shutdown(void *data)
 	 * 100% comprehensive.
 	 */
 	pr_info("kvm: exiting hardware virtualization\n");
-	kvm_rebooting = true;
 	on_each_cpu(kvm_disable_virtualization_cpu, NULL, 1);
 }
 
-- 
2.53.0.310.g728cabbaf7-goog


