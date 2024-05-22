Return-Path: <kvm+bounces-17872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D86858CB682
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:19:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 162B41C2189E
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 00:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED7B1D26A;
	Wed, 22 May 2024 00:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VWElfcsH"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8551B1848;
	Wed, 22 May 2024 00:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716337115; cv=none; b=SjhNWmOf5CE+yEPFUlRsQdYnORK7JERNsAh/BSh/fveasEdcmc9/me4IMWGEgNmHDw/Ah6kIxfx981peHMfr7j//Mx04UiWwdxa7hK66O5C+KvdhS6xoM+cbZz25p3DzufdZF4yULToNGJyz9RtVAGarmZWsLI3VVWRPbzQ08bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716337115; c=relaxed/simple;
	bh=iOmvqV+vbYDKZG4Z0hPkoNLgaOP2tzUKcwotb2WDGfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKHNtDJ96WJD7VTb+7rqArw8aEiBrxcLKxhfNXLZHxMRsTJLEwL1cRblt+/yjhZsql7gegOfWphz1HVyRzxNnlNlSr1X4GgHJiVHJwU15A/BmVAlkWYK7J9wLjKNSzjNeTcADrb3nki4cyqNxc4UOtfe6LlUZGTDvZ2SFlmBH0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VWElfcsH; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vQRg8jTSE/w84X85rubENd1tTskSzNXDiSVdMmVU2k0=; b=VWElfcsH1gVcVWSD8m79ulCmcC
	SGzPWQVxKrr69y8bkhK2I8P2x2S5EpH2XhMnIszSk6TSU89Jbhx2Nzv81fUQ0mVCP6I6G3bkUf48Q
	D/G0oUFQYxDuOyyNtUUwc7ippw+t6lMdXXjJq78s+3SAplzr/YZzvTs0lgO39dJXcrT54yuL2qcMX
	APSYp9VQX7z+adjGQ7Kee0hKMlctaZZKI7om07gEPjpoZW9Uvv2xppQp1XpTJC63nm5pqIXZl93W1
	eN5OvncA92UCDBvEff3qYcUQkOTmUw+jDW2A4QUdS47xTZj2SVsNCNP9C+SlRRiIma+FZRud95kxF
	2vQz6RLw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-000000080jM-3oHr;
	Wed, 22 May 2024 00:18:23 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgR-00000002b4Y-3dFS;
	Wed, 22 May 2024 01:18:19 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paul Durrant <paul@xen.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jalliste@amazon.co.uk,
	sveith@amazon.de,
	zide.chen@intel.com,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [RFC PATCH v3 06/21] KVM: x86: Explicitly disable TSC scaling without CONSTANT_TSC
Date: Wed, 22 May 2024 01:17:01 +0100
Message-ID: <20240522001817.619072-7-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240522001817.619072-1-dwmw2@infradead.org>
References: <20240522001817.619072-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

KVM does make an attempt to cope with non-constant TSC, and has notifiers
to handle host TSC frequency changes. However, it *only* adjusts the KVM
clock, and doesn't adjust TSC frequency scaling when the host changes.

This is presumably because non-constant TSCs were fixed in hardware long
before TSC scaling was implemented, so there should never be real CPUs
which have TSC scaling but *not* CONSTANT_TSC.

Such a combination could potentially happen in some odd L1 nesting
environment, but it isn't worth trying to support it. Just make the
dependency explicit.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 arch/x86/kvm/svm/svm.c | 3 ++-
 arch/x86/kvm/vmx/vmx.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0f3b59da0d4a..4d3ec1c3231e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5202,7 +5202,8 @@ static __init int svm_hardware_setup(void)
 		kvm_enable_efer_bits(EFER_FFXSR);
 
 	if (tsc_scaling) {
-		if (!boot_cpu_has(X86_FEATURE_TSCRATEMSR)) {
+		if (!boot_cpu_has(X86_FEATURE_TSCRATEMSR) ||
+		    !boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 			tsc_scaling = false;
 		} else {
 			pr_info("TSC scaling supported\n");
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6780313914f8..bee830adf744 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8428,7 +8428,7 @@ __init int vmx_hardware_setup(void)
 	if (!enable_apicv || !cpu_has_vmx_ipiv())
 		enable_ipiv = false;
 
-	if (cpu_has_vmx_tsc_scaling())
+	if (cpu_has_vmx_tsc_scaling() && boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		kvm_caps.has_tsc_control = true;
 
 	kvm_caps.max_tsc_scaling_ratio = KVM_VMX_TSC_MULTIPLIER_MAX;
-- 
2.44.0


