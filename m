Return-Path: <kvm+bounces-12879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE2F88EB3A
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 17:28:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5EB4CB22B07
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 143AE12A157;
	Wed, 27 Mar 2024 15:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ENKyI+AX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3C5131BA0;
	Wed, 27 Mar 2024 15:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711554247; cv=none; b=MclVkbK91WUb92cOeNkWaHTi2wVM0t1zk3UfxLRiTkfRtmX31P5eToY0d/om3yX+yhtdSzQLNNgX31tJVbni31ZkZGauHuQCq5e6gkBA658nwsC+IHQFowre/nHee2YxB24OXUnk4lJnBRMPsNtjwcFr1qA3JjVWslHdPyOdoyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711554247; c=relaxed/simple;
	bh=D6+E5uoJQ6G7TKgRsAZMZJr80d9n1W6yZjC95dfWkNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GI6wjYnkEK87i/HSurIIdQer6lN9sjFCrb8FJORXFAiYFsD3UF7osL/yIQIvaHsASix+L6XY8cK5OXW+grN9VUHAHg7wEvSqSnQj0AkeQX7T3/2VabAKSdjhuCsAn7b2mEl/Ms9jdOF4ZYeRR7iP5IKAItZA3ld5pFoUfWTW/HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ENKyI+AX reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1DBA740E02A9;
	Wed, 27 Mar 2024 15:44:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3w9bjIk7266G; Wed, 27 Mar 2024 15:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1711554239; bh=jmK0cjraSrwkY9e375az1GRBwh22aHXiWu6RP3/ODdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENKyI+AXk+a1wYEWMCqFdvXEWkqNUgbzfLZ/p5UPHOld29ytRqDKuuqryPIBDCYq5
	 m2JzEPSF+IIrlejpRcIhUThBUc4IpIIv09bRFwdoF6GLiwklzC4xEB2s+hpgG6KkxB
	 CjR259QW1ZX6GWRskXHhKNpmHUdAjRszprfpjuu5E/kmqvSChH0mXjU7d0/XUuWdPH
	 lX3bxmv2G0noZw/Y12i4T6rhwdNPY14BgsWeZH8AhIh8HD0jkYYLucjiNOFJcJ6DU0
	 EcCL5q+0hSSJ5aLn6+sL5+CfE49TFJOqwMdTaxy4GyeTO4TbZVrbx3MQ3qX9MiMXDu
	 ExmxVfMKFpVDQUMk73dE9w8cPfFwhAc7j9DlhE90wQ7ixw6VgICNHV9StxEe0JQYYw
	 NUypYpz4PfJT3ra3oP8DCQmecGFCSi0QRzUTeBcEnT66aCOUCTYJF0YGJLKnlsQL1q
	 kLbCkuJet8tpTYzLBUokjmIhuwN/D6cnc5tL2swxEATPtyuugMk/MxE9XCUJGSCSwC
	 U5y7fjObOjVMkbGrQadYDxflbdqWvys/Yfhovh2mRcQEsVfDvA4I4OG4F1XN8RqfWG
	 zAoRAme/vOMUbm6u20BsBYvWB+H1m55H6BZBLuB6vew30d1eLb4YdxAju8hkO0tDAR
	 Wb59weSD6O1W1fnUKmGIlXhE=
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A430C40E0028;
	Wed, 27 Mar 2024 15:43:52 +0000 (UTC)
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	KVM <kvm@vger.kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>,
	Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 3/5] x86/kvm/Kconfig: Have KVM_AMD_SEV select ARCH_HAS_CC_PLATFORM
Date: Wed, 27 Mar 2024 16:43:15 +0100
Message-ID: <20240327154317.29909-4-bp@alien8.de>
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

The functionality to load SEV-SNP guests by the host will soon rely on
cc_platform* helpers because the cpu_feature* API with the early
patching is insufficient when SNP support needs to be disabled late.

Therefore, pull that functionality in.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 3aaf7e86a859..0ebdd088f28b 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -122,6 +122,7 @@ config KVM_AMD_SEV
 	default y
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=3Dy && CRYPTO_DEV_CCP_DD=3Dm)
+	select ARCH_HAS_CC_PLATFORM
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
--=20
2.43.0


