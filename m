Return-Path: <kvm+bounces-12878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F8788E9AB
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 16:46:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 172742A605C
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E52A61311BF;
	Wed, 27 Mar 2024 15:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="NW/3Jlhd"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DD913118D;
	Wed, 27 Mar 2024 15:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711554240; cv=none; b=gyUSWLWQefh49LsO62RZ4aTLWBHV0uLIdkNDc7bHYcuCcLFpJN9LnSwUBZwwxWSqeX47va+SHabPrSoG4ZQuu0DeTGxtpBb8KBBLowSC3RHw6kB67a/a9F9uRLDmFh42JZegp4542D0hYoYY8i6ge3KRWkBA+2TN5PHnoiqY7fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711554240; c=relaxed/simple;
	bh=TBvqd4ujGjrA+OEG0n+syO68Cgjq1l9a/go8qjYx8ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUvXglZ1OpqdgtoX+gp5Qej+UUImQn0IiDJtuymjuxCHWhZsI0Nc0rNpY3onnctv0ZRojmXaKEY0gWCdrlv47GRJotoVyAS/m9iURodE3Q8+SKR5K+Cz3hdj+WHwKI1ri4RDQth479yzfBK2qPYgoszo4r4Ev/kahA4BHp3XMic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=NW/3Jlhd reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DA3DB40E02A8;
	Wed, 27 Mar 2024 15:43:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id EGYJW5CSriZ3; Wed, 27 Mar 2024 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1711554231; bh=bYojYaz3Qt0yOaxbHdC8/dOtftdqSFONlreqd9GBVqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NW/3JlhdOPRTaKedcmBt9i6WTUS1ebSXGGgQOxu7MNK0FuJ7mujCBXPO/Sr3mhaHJ
	 dBucxNkc5Xz7x/Qys/A4C4n2HSUEnhM/P0niLZDzyGq2/DcSlxe2XH0V+qoTs6trgh
	 nxw+WEOOiR99SnMYXAyu2xfpinVuNaN3A4UPUYqnoKo2cmU1NI+y2Ck/ycL8QHDxnp
	 TkEzsANFpxzclstlURZOV7Itn6ACnvKROY4kXdHJgWercHldVLmiE2FJNytrrULj87
	 a04Z/tGOqW55PwihKqDIq8dKSwOObD6/ilABk61PRIhEmQ0q256dvOTus4Yyyf5wA1
	 95bXmLW/393EwMJZOeT+uncG7W28mn+lEx6OvNQU7NnVIyB1WAwhjETAC+W1uzQypK
	 7Ensy5qVEH7Ui6vKG72O4h4lUIWmXSu7Vvl6VPiCdrotc+AlG7cgr1EWfqCb+ybzZg
	 Li7GxDEY8upYKCABAphGi7ncNVrU5dPrbiZgeSnNaW3iSl4Ih8LUPZP2J2P9tDbFDY
	 F6flNCDFxBtOgpDoe17dXJOl/6WtNWwJKulRRvm1TYyltdrwhYj1FffgE9u7j+TKME
	 Fun30Wl3JTe08Bl+PzOqwdChj9G8APGu26fo4EtGGwFubIDPMNghqBhExHcLIt0Zhk
	 unWwzKhm3wT0+EXw2bHaj2FI=
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DFE5540E02A5;
	Wed, 27 Mar 2024 15:43:43 +0000 (UTC)
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	KVM <kvm@vger.kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>,
	Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 2/5] x86/alternatives: Catch late X86_FEATURE modifiers
Date: Wed, 27 Mar 2024 16:43:14 +0100
Message-ID: <20240327154317.29909-3-bp@alien8.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240327154317.29909-1-bp@alien8.de>
References: <20240327154317.29909-1-bp@alien8.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: "Borislav Petkov (AMD)" <bp@alien8.de>

After alternatives have been patched, changes to the X86_FEATURE flags
won't take effect and could potentially even be wrong.

Warn about it.

This is something which has been long overdue.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/include/asm/cpufeature.h | 8 ++++++--
 arch/x86/kernel/cpu/cpuid-deps.c  | 3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpu=
feature.h
index 1ef620d508f4..d0b9c411144b 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -146,8 +146,12 @@ extern const char * const x86_bug_flags[NBUGINTS*32]=
;
 extern void setup_clear_cpu_cap(unsigned int bit);
 extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
=20
-#define setup_force_cpu_cap(bit) do { \
-	set_cpu_cap(&boot_cpu_data, bit);	\
+#define setup_force_cpu_cap(bit) do {			\
+							\
+	if (!boot_cpu_has(bit))				\
+		WARN_ON(alternatives_patched);		\
+							\
+	set_cpu_cap(&boot_cpu_data, bit);		\
 	set_bit(bit, (unsigned long *)cpu_caps_set);	\
 } while (0)
=20
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid=
-deps.c
index b7174209d855..5dd427c6feb2 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -114,6 +114,9 @@ static void do_clear_cpu_cap(struct cpuinfo_x86 *c, u=
nsigned int feature)
 	if (WARN_ON(feature >=3D MAX_FEATURE_BITS))
 		return;
=20
+	if (boot_cpu_has(feature))
+		WARN_ON(alternatives_patched);
+
 	clear_feature(c, feature);
=20
 	/* Collect all features to disable, handling dependencies */
--=20
2.43.0


