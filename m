Return-Path: <kvm+bounces-12876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7589C88E9A6
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 16:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F2862810BA
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93353130A4C;
	Wed, 27 Mar 2024 15:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Zb53IOBN"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607BC12FF93;
	Wed, 27 Mar 2024 15:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711554226; cv=none; b=Jmj9FutFo4/Z1hRg4sWqu9WuXALE9QabuK2bNuUXTdDkW3G/1Qcpvn1WroRCzinzGHRfS1Bpjj2ZewNmppHFi21tgGI88l4cUkSo10/GBxKe3gnzHzSlflRX6y5UOsJTb/Qfrvoab6W7TqcV7UFLjXpVQMbMowfEW6k+2gbLyVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711554226; c=relaxed/simple;
	bh=CwLgVLbFhdWZlf6OpWoWmOPSI+MJO8D+fJmBdVcWK00=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=koWXjHz/HHyVO4iGBhosR48jteyVlKr5+ppER7WXdy7ZFgC15PP4cgPIQmYpLg5HKhDwyF8sn/Mb9HhDNSe+tesZZ0goeLDMdAuBt1I7C9zrwGZUnfNbebZ0BkReZC3+iXnjIaWjIxAJ2/OH+uVpZ0pvQn+qBwvxh7iHfdzn/1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Zb53IOBN reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0ACEC40E016C;
	Wed, 27 Mar 2024 15:43:39 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4MF7391Yt6C3; Wed, 27 Mar 2024 15:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1711554212; bh=NBcRvx/bwn4OFth+fx2rkp+KytsfIQknXzG4/vs/N2U=;
	h=From:To:Cc:Subject:Date:From;
	b=Zb53IOBNca+6CXTKcM+KRd6Jc913BYVkCD5R4jNgC2g7Y8BL3jOIAd6P49eHdnZ8A
	 fDXJrHIbpZgY75xN5QnUNuR0IU+yh8djTL8wE1nvn3NKGnCdFFWYTaMajc/C1KCCJP
	 /6uGqGY6Hif0Hs02iEX8V/nxXA5X4ApexNXG27XR8F059A+RytqKWlqqMUTtXnXowj
	 ROJAYXnjcqQZ14FX7PSQ4/1uiQWvTOGZ5+0AiJD/kuG1uuhfj4fslN1BwZ3GLhiGtK
	 Mjs9mgtG1KXnb6QwYtpyHiIEZqIANlSRMqmqAJrmaUjbpD10E30cpfwFyk1nvi8R/8
	 fdFAbsV4PM1XDMvBDtnoTEsW37HaQPYg58IDfpCeY9rA2Le4PjJ4YDSCIAyeyHpjls
	 W7n6h7IINBEmDVOUYnPGhwlt2ZFWqFKurfDWwsVa633YFjh/fwpS08Y7jEQ7Y2S4Ke
	 oGJbtfcbZX0/F8XKe2L40wmS9EppxnpZA4Jjd1KNHLDeYcjSLZM9f9Q7+17tJKoZN+
	 OtFLOD+yP5o/YUF9UbUOAjf2LGlJQOkjiAIKaPTHkck/ViQXGdNVdvcGbFfZpj/19s
	 35deHR57RRHo7au5LcO7x4sYZR+24P8/I4dz4PE/iWCGh691hja2JA6nkCYYrCj9pO
	 CeM538tsNMW3MD0ygJe5p4sE=
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4EC8B40E02A5;
	Wed, 27 Mar 2024 15:43:25 +0000 (UTC)
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	KVM <kvm@vger.kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>,
	Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 0/5] x86/sev: Fix SNP host late disable
Date: Wed, 27 Mar 2024 16:43:12 +0100
Message-ID: <20240327154317.29909-1-bp@alien8.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Hi,

the intention to track SNP host status with the CPU feature bit
X86_FEATURE_SEV_SNP was all fine and dandy but that can't work if stuff
needs to be disabled late, after alternatives patching - see patch 5.

Therefore, convert the SNP status tracking to a cc_platform*() bit.

The first two are long overdue cleanups.

If no objections, 3-5 should go in now so that 6.9 releases fixed.

Thx.

Borislav Petkov (AMD) (5):
  x86/alternatives: Remove a superfluous newline in _static_cpu_has()
  x86/alternatives: Catch late X86_FEATURE modifiers
  x86/kvm/Kconfig: Have KVM_AMD_SEV select ARCH_HAS_CC_PLATFORM
  x86/cc: Add cc_platform_set/_clear() helpers
  x86/CPU/AMD: Track SNP host status with cc_platform_*()

 arch/x86/coco/core.c               | 52 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/cpufeature.h  | 11 ++++---
 arch/x86/include/asm/sev.h         |  4 +--
 arch/x86/kernel/cpu/amd.c          | 38 +++++++++++++---------
 arch/x86/kernel/cpu/cpuid-deps.c   |  3 ++
 arch/x86/kernel/cpu/mtrr/generic.c |  2 +-
 arch/x86/kernel/sev.c              | 10 ------
 arch/x86/kvm/Kconfig               |  1 +
 arch/x86/kvm/svm/sev.c             |  2 +-
 arch/x86/virt/svm/sev.c            | 26 ++++++++++-----
 drivers/crypto/ccp/sev-dev.c       |  2 +-
 drivers/iommu/amd/init.c           |  4 ++-
 include/linux/cc_platform.h        | 12 +++++++
 13 files changed, 124 insertions(+), 43 deletions(-)

--=20
2.43.0


