Return-Path: <kvm+bounces-54829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D90EB28CB9
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 12:13:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53AB5AC39A5
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 10:13:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2206F28DF0C;
	Sat, 16 Aug 2025 10:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IG5dgvyP"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BF71E32CF;
	Sat, 16 Aug 2025 10:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755339201; cv=none; b=UI7E7Q+KVtlBeq/ggVp+GrBvhrXFO49kcNXh4xvUiRONNY0If2Q7Vu97d+PaSl0MG/TtZWM8xqd0aXV6Og+L+5C8zOF7F/vDpldx9t7H4WKWuTfz2L9LAsGLRSjCcgacsPtF4MhqyH4U99kJx9+9wa0Foko4Wo7IgtQW+Kq2NnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755339201; c=relaxed/simple;
	bh=YcLRYb3R6cbIFAZW4Bn/fx9bUrc5p8RnkXaJcShWCmw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BdgpzGzN925xtUNBOo671Uqv9dFepAvZPdr5A9aINYGFjJR9hiwTGsDYe/ELXGyoB19e+QV/rwAmm8kfAgVXGOAVK1hV3qnjiamOVBUKeoX2qfReCwLufPNQiQTjV4/Cl4SzS01CSXCwQnQUNguQSvYtEMnqtzh7lAeYZ2YKtZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IG5dgvyP; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:To:
	From:Reply-To:Cc:Content-ID:Content-Description;
	bh=Qr47CfARRDel+2qWsJEMWRvMBqYR0DRalVsR9W35LgY=; b=IG5dgvyPqP67tZ1u0R3HTjNJX4
	DjnWi4DZcN4FprhK17nBuI2CPPdtnEXG2qtcwZeQ33uYCve9fYI/GPlVFl7iIgBvJa8Pty9UA+XbJ
	69MsF2t6cKD/iYW9HEr6BEiZz+ZIH+HbpgdZTG7TaKU8nFAEhTkzUaHfrcvupNHzHVybgoGCgBB8D
	DKsMkbk+ZX0cXBpiwER30XPk5EU+Vnw9eR0iTK1oNNCoIOOoRQWh4lAXWVcPaRAQuN3xRhnGQMMVV
	GjN0upLeZk0OMCfdLzOeXNhndWPU7dFOR4EBSPNiLguIct/kZDlw8oBrwwNC0YjiYRnYQmdFFxAMp
	Y5q9mE6w==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unDuR-00000007nqC-1qiJ;
	Sat, 16 Aug 2025 10:13:12 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1unDuQ-0000000AsuF-1ZIR;
	Sat, 16 Aug 2025 11:13:10 +0100
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
	Colin Percival <cperciva@tarsnap.com>
Subject: [PATCH v2 3/3] x86/kvm: Obtain TSC frequency from CPUID if present
Date: Sat, 16 Aug 2025 11:10:02 +0100
Message-ID: <20250816101308.2594298-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250816101308.2594298-1-dwmw2@infradead.org>
References: <20250816101308.2594298-1-dwmw2@infradead.org>
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
index 8ae750cde0c6..44040e37c9a7 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -896,6 +896,16 @@ bool kvm_para_available(void)
 }
 EXPORT_SYMBOL_GPL(kvm_para_available);
 
+unsigned int kvm_para_tsc_khz(void)
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


