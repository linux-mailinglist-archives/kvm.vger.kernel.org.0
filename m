Return-Path: <kvm+bounces-33003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1F399E3797
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 11:35:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96EA52810A0
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF331F6663;
	Wed,  4 Dec 2024 10:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUi7Ft3i"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509D11B0F31;
	Wed,  4 Dec 2024 10:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733308292; cv=none; b=W6y/Jt4qL4nVePqc1dUs8reTvfFf26Ww69vJ9+CfJMwGCwnXuT9rIdHALNacM9Kr3CRP8L5ish8F1429wVLRWhXU4kbYixTctIwz1Nckt+J64Mp0nmv7OkDystn5QKkmtsLJKmyzI1/D7AYVeLWrtOtmRmu4zMb9Sjzry9HWkFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733308292; c=relaxed/simple;
	bh=zBl88AZDOvJENYaWyugbt/HQ/28DClmezJYLU2g+1JU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OPkUjAjdEHp08qZVVEtMoKJy0U/3tTTj9KkY0KuFlGQDdky14O1QaK33jB6bvlabvTmAWHGCOnAsV+EtHYycxFygo77KJ2JSP5ZyDxW4Utkq4DCemAnv7Shz+KbvRTITqsdZhp2PjaWdU368qaNUBhSQF2X8SJR7DQBqQO7UR8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUi7Ft3i; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC105C4CEE0;
	Wed,  4 Dec 2024 10:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733308291;
	bh=zBl88AZDOvJENYaWyugbt/HQ/28DClmezJYLU2g+1JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUi7Ft3iFb+rKlDZ/4jUGmf/9vVnk08ef8Z0doL58zvUwdmTx2KLhNOYTeOyRIjch
	 OjCHTrKoQeXkuhZrQ2G+tDhQ0UjqVjV2uBSXEF1pTmfUMRoOpA9ACUHYDHmL8WeEqC
	 zJCxixXEu+ES8N+aQXdDqUdBn/xfSNicIjOoC6OhwhWOJ6hpOtHgv1sauw/NNEIZ+W
	 k8HBxpnE1wAn/lbM3vbwrGYZ1tJ0SfMnaOslFaO027UT6EptFLA0QyV9ZhuXz3wE0H
	 MD1ydXfmLyeU7id+F3idmyS6NIdM/8OabxEvoCsq60bz5EzzBD99aT6eHi69Zx6uck
	 tt04hTEcpTr/Q==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Shevchenko <andy@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH 08/11] x86: document X86_INTEL_MID as 64-bit-only
Date: Wed,  4 Dec 2024 11:30:39 +0100
Message-Id: <20241204103042.1904639-9-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241204103042.1904639-1-arnd@kernel.org>
References: <20241204103042.1904639-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The X86_INTEL_MID code was originally introduced for the
32-bit Moorestown/Medfield/Clovertrail platform, later the 64-bit
Merrifield/Moorefield variant got added, but the final
Morganfield/Broxton 14nm chips were canceled before they hit
the market.

To help users understand what the option actually refers to,
update the help text, and make it a hard dependency on 64-bit
kernels. While they could theoretically run a 32-bit kernel,
the devices originally shipped with 64-bit one in 2015, so that
was proabably never tested.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/Kconfig         | 16 ++++++++++------
 arch/x86/kernel/head32.c |  3 ---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d8a8bf9ea9b9..fa6dd9ec4bdf 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -544,12 +544,12 @@ config X86_EXTENDED_PLATFORM
 		RDC R-321x SoC
 		SGI 320/540 (Visual Workstation)
 		STA2X11-based (e.g. Northville)
-		Moorestown MID devices
 
 	  64-bit platforms (CONFIG_64BIT=y):
 		Numascale NumaChip
 		ScaleMP vSMP
 		SGI Ultraviolet
+		Merrifield/Moorefield MID devices
 
 	  If you have one of these systems, or if you want to build a
 	  generic distribution kernel, say Y here - otherwise say N.
@@ -621,11 +621,11 @@ config X86_INTEL_CE
 	  boxes and media devices.
 
 config X86_INTEL_MID
-	bool "Intel MID platform support"
+	bool "Intel Z34xx/Z35xx MID platform support"
 	depends on X86_EXTENDED_PLATFORM
 	depends on X86_PLATFORM_DEVICES
 	depends on PCI
-	depends on X86_64 || (PCI_GOANY && X86_32)
+	depends on X86_64
 	depends on X86_IO_APIC
 	select I2C
 	select DW_APB_TIMER
@@ -633,10 +633,14 @@ config X86_INTEL_MID
 	help
 	  Select to build a kernel capable of supporting Intel MID (Mobile
 	  Internet Device) platform systems which do not have the PCI legacy
-	  interfaces. If you are building for a PC class system say N here.
+	  interfaces.
+
+	  The only supported devices are the 22nm Merrified (Z34xx) and
+	  Moorefield (Z35xx) SoC used in Android devices such as the
+	  Asus Zenfone 2, Asus FonePad 8 and Dell Venue 7.
 
-	  Intel MID platforms are based on an Intel processor and chipset which
-	  consume less power than most of the x86 derivatives.
+	  If you are building for a PC class system or non-MID tablet
+	  SoCs like Bay Trail (Z36xx/Z37xx), say N here.
 
 config X86_INTEL_QUARK
 	bool "Intel Quark platform support"
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index de001b2146ab..4f69239556e4 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -65,9 +65,6 @@ asmlinkage __visible void __init __noreturn i386_start_kernel(void)
 
 	/* Call the subarch specific early setup function */
 	switch (boot_params.hdr.hardware_subarch) {
-	case X86_SUBARCH_INTEL_MID:
-		x86_intel_mid_early_setup();
-		break;
 	case X86_SUBARCH_CE4100:
 		x86_ce4100_early_setup();
 		break;
-- 
2.39.5


