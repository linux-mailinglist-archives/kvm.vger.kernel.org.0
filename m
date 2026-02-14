Return-Path: <kvm+bounces-71094-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aLKMK3LQj2l7TwEAu9opvQ
	(envelope-from <kvm+bounces-71094-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:31:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 49D5513AB09
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:31:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 54243310219D
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B73B2BD02A;
	Sat, 14 Feb 2026 01:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PWMlD0o+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B1829AAFA
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 01:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771032455; cv=none; b=ahUmEd/8cienvrsrtVio5MT6Y6Se1n9fZ9amOizdezcivNx+2LSBJCL7eqigJA33pZLOX6w3+5meApliUugDdvBdxvfwTe2UyfMT6ONeXXBTpqwosTD7IZRbyu96M0Mq9TbK+x9X04f3cGVVUYdRwmKLch4eBYbqA8ciHfyerVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771032455; c=relaxed/simple;
	bh=n0glIiKij5SE6jJtccYoydGsQfuK8yUaTbTzRTF8FPk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UCPNiMKMvVO5P/E6tCHF0+qirGHtJ8T93uy9ANtIYrcrgOgm9KLoaZXTt+2adrbdIc2HKAvgiRkon8dxHI5dqUBP3VnkNpzKakLYyPHdfejOt1r1dCqq1qLHhU3S4ZS5+qCzFwwsGK9ytDhvxhnwdewAZ4Tm/UJMvlRDjzPRyK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PWMlD0o+; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a7b7f04a11so66069555ad.3
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 17:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771032453; x=1771637253; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fCDccjCq5My2WdlmlvmFH+sEHO27BgDMTfTEXHYAVac=;
        b=PWMlD0o+3iMLoQtU44m9hyF7kD1xkm2VN/1hVsF58ld6s/iJwKtUboCn6Fqmbv7oXt
         bWkuCxQmiLUssrcYE5sMVjVlES441KjpD9KKLEc7etS7k3oXPZUCS6aTRYklaJOIS7fV
         Fa2Q/n/eYiUA3pVFIRivtidEX7K7FVgIUgkoAenFqwkJnHvuvsIEu/nKBtMEx/VQQmvv
         pfUUgyqB5KJEOzICbvUcCSyMAKq1t0dnZATGady7p0saJnXMWmLJLu3Gx/Vc8rFeq7yQ
         L+exN3P8IJF5gk6elSyvMAi6381ael/jbl6kx5jxzGFZLKA/dkyHbZnRONdz+GeMl9bA
         y4+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771032453; x=1771637253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fCDccjCq5My2WdlmlvmFH+sEHO27BgDMTfTEXHYAVac=;
        b=OZH65IRIoYuSXxUmWhHevkDrUKiVhXOW1TPlFAQpzQJXfZ15HJXgxpe7zsww/b5SJB
         3dKSkvp7eqbOOMbvwjUkJDWlPF9hU2hgYHReH6nlrqJMomlKZR67dkC8mUDMatE3Mjc+
         FnUT6PG6X+lcNwGuPk/0FT44ilPhj8JfDLQ6YFYXUwk9Nm+nSjn0YhHxh5bWJhUnJu3E
         Mss4xB9h1UfXFA+po7VXx/emd1AJtUzlifcNVAn0PVAlNuYwbSVEYs1s/nCXJUmiRnoY
         wjH08NKWBU37qk9wM8p8WNkeiewIw0WNBfVxqKPICnmrrQOk0ArmrIcvQ6Ppt2/xS1Yp
         cvNg==
X-Forwarded-Encrypted: i=1; AJvYcCWABhua/5ySFFznBxare+QHMBcgQgPe2fh19t95zY0K8aXtcHSbikh7bsxIXcBrcy9be68=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4+iJ56/niRd1lx5kP/aQ4NqMuuTCuZ2SmaRDZ50R2yi7AVNgn
	adqTBlXBjMbcEsTMYkNrmGd1WR2+SJCwtssGJ4FqAZ8Tcywx76KsvDjwPszGTwQYDVC10mp5aCW
	RXDAMrw==
X-Received: from plse10.prod.google.com ([2002:a17:902:b78a:b0:2a9:5b1d:9c8a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2450:b0:2aa:d6d5:773c
 with SMTP id d9443c01a7336-2ab50546cb2mr32518995ad.25.1771032452483; Fri, 13
 Feb 2026 17:27:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Feb 2026 17:27:01 -0800
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260214012702.2368778-16-seanjc@google.com>
Subject: [PATCH v3 15/16] KVM: Bury kvm_{en,dis}able_virtualization() in
 kvm_main.c once more
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71094-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 49D5513AB09
X-Rspamd-Action: no action

Now that TDX handles doing VMXON without KVM's involvement, bury the
top-level APIs to enable and disable virtualization back in kvm_main.c.

No functional change intended.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  8 --------
 virt/kvm/kvm_main.c      | 17 +++++++++++++----
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 981b55c0a3a7..760e0ec2c8eb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2605,12 +2605,4 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range);
 #endif
 
-#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
-int kvm_enable_virtualization(void);
-void kvm_disable_virtualization(void);
-#else
-static inline int kvm_enable_virtualization(void) { return 0; }
-static inline void kvm_disable_virtualization(void) { }
-#endif
-
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e081e7244299..737b74b15bb5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1112,6 +1112,9 @@ static inline struct kvm_io_bus *kvm_get_bus_for_destruction(struct kvm *kvm,
 					 !refcount_read(&kvm->users_count));
 }
 
+static int kvm_enable_virtualization(void);
+static void kvm_disable_virtualization(void);
+
 static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 {
 	struct kvm *kvm = kvm_arch_alloc_vm();
@@ -5704,7 +5707,7 @@ static struct syscore kvm_syscore = {
 	.ops = &kvm_syscore_ops,
 };
 
-int kvm_enable_virtualization(void)
+static int kvm_enable_virtualization(void)
 {
 	int r;
 
@@ -5749,9 +5752,8 @@ int kvm_enable_virtualization(void)
 	--kvm_usage_count;
 	return r;
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_enable_virtualization);
 
-void kvm_disable_virtualization(void)
+static void kvm_disable_virtualization(void)
 {
 	guard(mutex)(&kvm_usage_lock);
 
@@ -5762,7 +5764,6 @@ void kvm_disable_virtualization(void)
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 	kvm_arch_disable_virtualization();
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_disable_virtualization);
 
 static int kvm_init_virtualization(void)
 {
@@ -5778,6 +5779,14 @@ static void kvm_uninit_virtualization(void)
 		kvm_disable_virtualization();
 }
 #else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
+static int kvm_enable_virtualization(void)
+{
+	return 0;
+}
+static void kvm_disable_virtualization(void)
+{
+
+}
 static int kvm_init_virtualization(void)
 {
 	return 0;
-- 
2.53.0.310.g728cabbaf7-goog


