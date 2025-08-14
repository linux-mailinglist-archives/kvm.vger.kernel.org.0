Return-Path: <kvm+bounces-54668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 31BA0B264EC
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 14:03:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E1751CC32A4
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 12:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D33A2FCC18;
	Thu, 14 Aug 2025 12:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ew59hpzk"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D34E2727FC;
	Thu, 14 Aug 2025 12:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755172994; cv=none; b=Q1H0ae06V5/jMij7lbYEWr0cIOBayIJSRI0bUBUes6AvCMn7a77J1jxRl7SxN1DrURrGATV+IdfLekkVktmrN8UpJm321i6gJ7Bs3DOxXOxReSJ3HM07dKibUYtOj5tZYb49aFA7UyEYQulvx9uzA8YL8967mP/M00D/EC9HgVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755172994; c=relaxed/simple;
	bh=Xv927clxzvv7etIdOV5tAySmi+ZdvMYf+t8s6rS2Duo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hRNE7ewt0ye2PFMUIeOQmAMKrchqLD4lBgCe+qjunaf/APwqpPb/4RyyxFPKWGSSIFaVPzZwmvC3c/0O2RsYFwZznJgQU2ykco8qxsg0Cto2cRvlZMvQSld7Ficrlkq2/yVzUyRwhWgud22Bcmdr4V3MTkUkdEDWcCC9G8qquS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ew59hpzk; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:To:
	From:Reply-To:Cc:Content-ID:Content-Description;
	bh=mGS5KD4K3Hl92P1KTfNmSqYsreyv1JVai3wachOAJC4=; b=Ew59hpzkFKy5/CCOhMlmgv5Rhn
	YQq+zfS+bfn8QqRkS7i8EsCvK2qSxfKizAobTAF9KvgvWy5rSbl1MuEQXsp/yFRQznEvxeChBleb4
	Q9En+X/DzXwgzp5lOK0q/6dvcfVEn549Z4yCoNZff+/5cpUs1HvpcI+jWOWZAuvfNW71nlIROzTO0
	qjLyogW6KoUViwqOiyJD4x9uOJvxXfcbBZ0epx6i4jeZY0Nt2fcEkZafmrSU3cS0JYsLJ0vfsCAlI
	Z3uX/UkmJnd5jKICzgNBbakzPBU/8nXiR0Z0QEp0rHRnNPuF4M1J+JnZPiSFCrPjZ+puWvsHyCt7R
	fUH9zaFg==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1umWfd-00000000Ia4-1vq5;
	Thu, 14 Aug 2025 12:03:02 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1umWfd-0000000AMTr-1hl9;
	Thu, 14 Aug 2025 13:03:01 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	graf@amazon.de,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Alok N Kataria <akataria@vmware.com>
Subject: [PATCH 3/3] x86/kvm: Obtain TSC frequency from CPUID if present
Date: Thu, 14 Aug 2025 12:56:05 +0100
Message-ID: <20250814120237.2469583-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250814120237.2469583-1-dwmw2@infradead.org>
References: <20250814120237.2469583-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

In https://lkml.org/lkml/2008/10/1/246 a proposal was made for generic
CPUID conventions across hypervisors. It was mostly shot down in flames,
but the leaf at 0x40000010 containing timing information didn't die.

It's used by XNU and FreeBSD guests under all hypervisors¹² to determine
the TSC frequency, and also exposed by the EC2 Nitro hypervisor (as
well as, presumably, VMware). FreeBSD's Bhyve is probably just about
to start exposing it too.

Use it under KVM to obtain the TSC frequency more accurately, instead
of reverse-calculating the frequency from the mul/shift values in the
KVM clock.

Before:
[    0.000020] tsc: Detected 2900.014 MHz processor

After:
[    0.000020] tsc: Detected 2900.015 MHz processor

$ cpuid -1 -l 0x40000010
CPU:
   hypervisor generic timing information (0x40000010):
      TSC frequency (Hz) = 2900015
      bus frequency (Hz) = 1000000

¹ https://github.com/apple/darwin-xnu/blob/main/osfmk/i386/cpuid.c
² https://github.com/freebsd/freebsd-src/commit/4a432614f68

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_para.h |  1 +
 arch/x86/kernel/kvm.c           | 10 ++++++++++
 arch/x86/kernel/kvmclock.c      |  7 ++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 57bc74e112f2..d53927103cab 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -121,6 +121,7 @@ static inline long kvm_sev_hypercall3(unsigned int nr, unsigned long p1,
 void kvmclock_init(void);
 void kvmclock_disable(void);
 bool kvm_para_available(void);
+unsigned int kvm_para_tsc_khz(void);
 unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
 void kvm_async_pf_task_wait_schedule(u32 token);
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 8ae750cde0c6..1a80f4e5c854 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -896,6 +896,16 @@ bool kvm_para_available(void)
 }
 EXPORT_SYMBOL_GPL(kvm_para_available);
 
+unsigned int kvm_para_tsc_khz()
+{
+	u32 base = kvm_cpuid_base();
+
+	if (cpuid_eax(base) >= (base | KVM_CPUID_TIMING_INFO))
+		return cpuid_eax(base | KVM_CPUID_TIMING_INFO);
+
+	return 0;
+}
+
 unsigned int kvm_arch_para_features(void)
 {
 	return cpuid_eax(kvm_cpuid_base() | KVM_CPUID_FEATURES);
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index ca0a49eeac4a..0908450ebac9 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -117,7 +117,12 @@ static inline void kvm_sched_clock_init(bool stable)
 static unsigned long kvm_get_tsc_khz(void)
 {
 	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
-	return pvclock_tsc_khz(this_cpu_pvti());
+
+	/*
+	 * If KVM advertises the frequency directly in CPUID, use that
+	 * instead of reverse-calculating it from the KVM clock data.
+	 */
+	return kvm_para_tsc_khz() ? : pvclock_tsc_khz(this_cpu_pvti());
 }
 
 static void __init kvm_get_preset_lpj(void)
-- 
2.49.0


