Return-Path: <kvm+bounces-65789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 62223CB6B2F
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 18:24:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 17D93305D387
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 17:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5158C309F0D;
	Thu, 11 Dec 2025 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xc8V6I+b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA0B2367DF
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 17:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765473583; cv=none; b=hH6/5x2xGQ+HYXWQQlTnMKsIaeAx2ircjclAPr9L7jZhzd4sZzgoIyHdZimKPkXm0I4AyoxL1cP/5nfiUNFy+2g4bwzhAWMNSxBolzYjiUZ6wX7Vtypku9IkQMJsWobBU/k47M+NrtixhehHZVxv4b56URFIbe8wmaB4RYrwGLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765473583; c=relaxed/simple;
	bh=7/nM2S+g4oI+35ZgIp+BLFj3KN7HTrqFx2pYgAzZ9yQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gbWgRMrFkVj4nKwZqI83dWcUsFZqtwaJaJs9gxidUk6cc/b3OnxJ4vMUUfAY/7UMNMxB+TxnJME/VhDKqYvq4vY59P6OmPfuTinM6ZASjFasEs2TF2DkPj05xRPrSQprjeilpDiLQ3r3yS3E9B5ZjlPttViJSZnr7eCFD6kNUPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xc8V6I+b; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3437f0760daso564027a91.1
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 09:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765473581; x=1766078381; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EfIDWZs1mfufDz29h6c2X2uNQPD5cvnA//6mO5ttNMk=;
        b=xc8V6I+buCjZD6RZ5wXjRqOvFFsl77q5tUersOgKHOw/8iE9QWoEmhWgMUdMEUASgi
         AdA5ApAKqKTQvt4T1zNbU9j0BDfH5iTfF8J1M+ib/7hqGIPKvjH/xUqOUyw2FpKxLpzq
         qzuFoWh8w8Xbp7BRmD+Mgg6EFk6eMaA7rCGen2mdM0oIvArpQQR6883fB9lQNKtzdfrt
         7Sk1pQStiEpdNjnPI/LK/hkli9VwR8e2CNA4QEp3IR7jbaEkzvVVSD/WNZZnqeuqYOFu
         1LpuKkTfQYSY4Hu29Y3XjoCOf7CPIqVqsdjRGf+Wh+hZPCce4RyB792OB+fOphbtmcyA
         gpYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765473581; x=1766078381;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EfIDWZs1mfufDz29h6c2X2uNQPD5cvnA//6mO5ttNMk=;
        b=PYB+W0m41SLHeM+gmYWHYF1K0hsxkwe/oXSibi66cdQdjewXmqZXtpLFFhYy98QfVO
         i3l+W0ez20Lisaf1noWWH3cZAaN1jyUjwUi8CEVmcL7/qS3+adLvC9acp2qk+DmoT2Qr
         NnkDWHUJ0zXPyX3udBb1y9IbIEIhreTkrltFr5NSGXng15heiu7/pAboN3Yieqoku81f
         fiPNPbYJq9SnWUMLx/yRY+6LEC0vwXj3mvFI9F0VkQpWODiLe4n2FpcHZeooDhZ1NAt1
         jHgCeS5UWAuF0s/HESzdrynmwE+kEoFyPx5IQqIR3P/cwCJ53Ej2WkgenjAfabZYE52H
         XZ4g==
X-Gm-Message-State: AOJu0YygXH6EYUwqmjKa74oK33pFHR2u4mlI70BPYplycHkZMN7IKl4s
	GhUPpurOdB3eMO8CRSJFjm+maNBrK0f2awGlXByjPmV8KYDS9XsRAsy1Ry6hhX3gpMJ12q+vvOW
	z71Nd/A==
X-Google-Smtp-Source: AGHT+IFHsASvUw5QB8HuAvLw18A48kwu5suyIx7VvKoGS2aT2WhIXCDVIeuwRC5t3D94TW6UbpWm7gkPnJs=
X-Received: from pjbnl3.prod.google.com ([2002:a17:90b:3843:b0:33b:9e06:6b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1843:b0:340:bfcd:6afa
 with SMTP id 98e67ed59e1d1-34a72890e52mr6091412a91.8.1765473581321; Thu, 11
 Dec 2025 09:19:41 -0800 (PST)
Date: Thu, 11 Dec 2025 09:19:39 -0800
In-Reply-To: <20251211140520.GC42509@k08j02272.eu95sqa>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1757416809.git.houwenlong.hwl@antgroup.com>
 <45cbc005e14ea2a4b9ec803a91af63e364aeb71a.1757416809.git.houwenlong.hwl@antgroup.com>
 <aTMdLPvT3gywUY6F@google.com> <20251211140520.GC42509@k08j02272.eu95sqa>
Message-ID: <aTr9Kx9PjLuV9bi1@google.com>
Subject: Re: [PATCH 4/7] KVM: x86: Consolidate KVM_GUESTDBG_SINGLESTEP check
 into the kvm_inject_emulated_db()
From: Sean Christopherson <seanjc@google.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: kvm@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 11, 2025, Hou Wenlong wrote:
> On Fri, Dec 05, 2025 at 09:58:04AM -0800, Sean Christopherson wrote:
> > But I think the WARN will be subject to false positives.  KVM doesn't emulate data
> > #DBs, but it does emulate code #DBs, and fault-like code #DBs can be coincident
> > with trap-like single-step #DBs.  Ah, but kvm_vcpu_check_code_breakpoint() doesn't
> > account for RFLAGS.TF.  That should probably be addressed in this series, especially
> > since it's consolidating KVM_GUESTDBG_SINGLESTEP handling.
>
> Sorry, I didn't follow it, how fault-like code #DBs can be coincident
> with trap-like single-step #DBs, could you provide an example?

Ya, here's a KUT testcase that applies on top of
https://lore.kernel.org/all/20251126191736.907963-1-seanjc@google.com.

---
 x86/debug.c | 43 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/x86/debug.c b/x86/debug.c
index 8177575c..313d854e 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -92,6 +92,7 @@ typedef unsigned long (*db_test_fn)(void);
 typedef void (*db_report_fn)(unsigned long, const char *);
 
 static unsigned long singlestep_with_movss_blocking_and_dr7_gd(void);
+static unsigned long singlestep_with_code_db(void);
 static unsigned long singlestep_with_sti_hlt(void);
 
 static void __run_single_step_db_test(db_test_fn test, db_report_fn report_fn)
@@ -106,11 +107,12 @@ static void __run_single_step_db_test(db_test_fn test, db_report_fn report_fn)
 	report_fn(start, "");
 
 	/*
-	 * MOV DR #GPs at CPL>0, don't try to run the DR7.GD test in usermode.
-	 * Likewise for HLT.
+	 * MOV DR #GPs at CPL>0, don't try to run the DR7.GD or code #DB tests
+	 * in usermode. Likewise for HLT.
 	 */
-	if (test == singlestep_with_movss_blocking_and_dr7_gd
-	    || test == singlestep_with_sti_hlt)
+	if (test == singlestep_with_movss_blocking_and_dr7_gd ||
+	    test == singlestep_with_code_db ||
+	    test == singlestep_with_sti_hlt)
 		return;
 
 	n = 0;
@@ -163,6 +165,38 @@ static noinline unsigned long singlestep_basic(void)
 	return start;
 }
 
+static void report_singlestep_with_code_db(unsigned long start, const char *usermode)
+{
+	report(n == 3 &&
+	       dr6[0] == (DR6_ACTIVE_LOW | DR6_BS | DR6_TRAP2) && db_addr[0] == start &&
+	       is_single_step_db(dr6[1]) && db_addr[1] == start + 1 &&
+	       is_single_step_db(dr6[2]) && db_addr[2] == start + 1 + 1,
+	       "%sSingle-step + code #DB test", usermode);
+}
+
+static noinline unsigned long singlestep_with_code_db(void)
+{
+	unsigned long start;
+
+	asm volatile (
+		"lea 1f(%%rip), %0\n\t"
+		"mov %0, %%dr2\n\t"
+		"mov $" xstr(DR7_FIXED_1 | DR7_EXECUTE_DRx(2) | DR7_GLOBAL_ENABLE_DR2) ", %0\n\t"
+		"mov %0, %%dr7\n\t"
+		"pushf\n\t"
+		"pop %%rax\n\t"
+		"or $(1<<8),%%rax\n\t"
+		"push %%rax\n\t"
+		"popf\n\t"
+		"and $~(1<<8),%%rax\n\t"
+		"1:push %%rax\n\t"
+		"popf\n\t"
+		"lea 1b(%%rip), %0\n\t"
+		: "=r" (start) : : "rax"
+	);
+	return start;
+}
+
 static void report_singlestep_emulated_instructions(unsigned long start,
 						    const char *usermode)
 {
@@ -517,6 +551,7 @@ int main(int ac, char **av)
 	       n, db_addr[0], dr6[0]);
 
 	run_ss_db_test(singlestep_basic);
+	run_ss_db_test(singlestep_with_code_db);
 	run_ss_db_test(singlestep_emulated_instructions);
 	run_ss_db_test(singlestep_with_sti_blocking);
 	run_ss_db_test(singlestep_with_movss_blocking);

base-commit: 23071a886edbe303fb964c5c386750b0b458dbfb
--

