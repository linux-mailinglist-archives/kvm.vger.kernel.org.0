Return-Path: <kvm+bounces-12877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E94588E9A8
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 16:46:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3393D1F32D8B
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A3A3130AFC;
	Wed, 27 Mar 2024 15:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jc59lUDr"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09BC12FF93;
	Wed, 27 Mar 2024 15:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711554235; cv=none; b=StM7r2492W5zZ3ckVxJdrY+1GynNv40RAcWUj+kwEtUHmcC2z0ePeazbrxsTlWwfh8Qso51S/DHwvxrnXjkr4oEjdwbMKlFZeL/dNvUwqwrIbrsIaCGzQ6kXh27sC6O60+XScm0s6VFlfqtOfU2xi+miIu4vMe2cLUqg03pbp6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711554235; c=relaxed/simple;
	bh=KPfUWJQyZW2bCdqaMrNIY6ngoo0Dhq6iciPb0rjmCPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEVjjPU1HyJlz20FUEbMmKMSWWSmNMXBj6icXs56lofNy5gZKnj8V3lEwv3FXgyUB+YBHKR3prk2MOqhbOvL/CzbZ6vTU835r8k1366g4G/Sji0gh0gaQBwFWSQ6qAXgywXbJSZhknrqijrZCqX9bEvH0Cu1Zz/7QI8rZ5toppY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=jc59lUDr reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 622A340E02A6;
	Wed, 27 Mar 2024 15:43:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id SvYh-JZ9w_kP; Wed, 27 Mar 2024 15:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1711554221; bh=9+bM4s99ZaYsSepq5xH3Z7iP2Cx0eYjP06s88fa4x+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jc59lUDrfs3r1+A8xZDGG1/saR8DBogIHOpKjcAukHqKnHSSmGTGI6r30cOEu6sIO
	 8C307fQkklozrD7EZacEYdUkKGHyw8KluBXsEZVY1dG84FKtXEpvYgjwkoRNREkd+a
	 dIWVBs6zdedScc+rtGMqwoT2eMrUKeoEDeglqJl3Pl7Xd7mmPdCsxeR8FNvu0P//uz
	 XBT8zGsUX2rG3aJw9Olo2i1gICLr+ue+vbTLe/yicYx8A5P0XjdZHj+9ezPciZa91H
	 EgORf09oQtsfesv3v6sDHIss1p/KfCCEvfEarBUZJNlB27bIE69eUhFJo9D6z/0C07
	 /SeykjpdAFyJvT7UmSqq5d/nB9wpR3xiHDYJgFmIFSeMFJlCK0WGSh7iWNl6lmQduA
	 FoqOL9M17TbvswUuiJ3zUBqF/14iAU9+4Ng4E7wduijdpo9E/zAmscbzNNF8PKkv8P
	 QkGS1zrkLiDj1ocmkTepCeWAFbex1cOrh/ZMAS5IS0t7HuWDlTUxXLRPjTHZkNLONb
	 xMCiVRvr9xezbbBvDVGTQgyBR44cUy3JOKqR3Q+ljPxqfn2UHB0w7nbYB0/7xFkwww
	 WS2fP5CJdl0roSTXVVTmf7dZ/6PkaFqaDsHuYr1QkGrbIoiXBk612McOAUWmXTHf02
	 uPo1Jwb802Zwel4jvqDFZ8oA=
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C90A540E0028;
	Wed, 27 Mar 2024 15:43:34 +0000 (UTC)
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	KVM <kvm@vger.kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>,
	Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 1/5] x86/alternatives: Remove a superfluous newline in _static_cpu_has()
Date: Wed, 27 Mar 2024 16:43:13 +0100
Message-ID: <20240327154317.29909-2-bp@alien8.de>
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

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/include/asm/cpufeature.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpu=
feature.h
index a1273698fc43..1ef620d508f4 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -168,8 +168,7 @@ extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsi=
gned int bit);
  */
 static __always_inline bool _static_cpu_has(u16 bit)
 {
-	asm goto(
-		ALTERNATIVE_TERNARY("jmp 6f", %P[feature], "", "jmp %l[t_no]")
+	asm goto(ALTERNATIVE_TERNARY("jmp 6f", %P[feature], "", "jmp %l[t_no]")
 		".pushsection .altinstr_aux,\"ax\"\n"
 		"6:\n"
 		" testb %[bitnum]," _ASM_RIP(%P[cap_byte]) "\n"
--=20
2.43.0


