Return-Path: <kvm+bounces-12880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5DF88EB67
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 17:36:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B6BAB36F4C
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE751327F7;
	Wed, 27 Mar 2024 15:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="CZ5TWtpZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD8112F585;
	Wed, 27 Mar 2024 15:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711554259; cv=none; b=YrvanGZIuh+UHPZNZAC8KNSC+DLh4HsBWPvOPX2Gzo/kXGfBCwwxFFvlQwrRQ7kJSSPKzyAS+XhcMbl43mx6R6lXgGYQNLyU3yikdC/BZ9DhnoJ7TOqQVZss0gp4fts+V8vUMvkmew1SRlNsmSGHx3+guU/wKBVhqYw9gWO8o38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711554259; c=relaxed/simple;
	bh=ZxZNx0li9LS3G3bW+6eHBjaTe5W1YfdN/sBHLSDr8fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqBGVXaqPgzBn7eS7UqaKh5dRXkJZsSidGoqvFNknwUY3MfwNWkyaGJOr/Wo+8IF77JC8QcroWz4i3bD9UO6xIHNDQ/MAxldw81mYYBV/cV2QRQc/ILonh34rsHShnVkptX5w3lFOk9dmE6xK4R23bOBtsHH1fH1Y/3XDGLm2jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=CZ5TWtpZ reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E463240E0028;
	Wed, 27 Mar 2024 15:44:15 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ENC606ywPq6q; Wed, 27 Mar 2024 15:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1711554248; bh=DAolyB0vvY5i1XxPWdJrJ5aenCeS8iAhZUbtkvPczFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZ5TWtpZy0z5LwLElXLjFjtPyYkQ7Y+4/ykZ1o3xS8a1SvhOKoElEeBcw2FYH8FJt
	 uVr6p+6CDHHkzfER8xBjAQ20m183nna+dRoLqNsqXeSaHbf60bn0ksvsmWGbvgKK0M
	 /pOyJ2bo4H8Y7vbC3pAVuR9NENKgvo6j54MmHXuWj+mmrNQzxm0UIlPi2ch6xjechj
	 8B2Phodz8czukHhy0RNmmamNDYtKAzK/ore0o88PJtfIe7JX/wbSXn1m1m+Wy9/lJ/
	 DHrJVpwd4eOAcivsZ6Yl3E6AsgB3kz3ZUUhDw2CXfAdqn7djEBAgsrua2ZUxJdBlRd
	 WeoNyx/I13cj5dRdqhGZl/dMRhyRd08qbyeNYriKBLwkck4Uz8bcPXUO3GSla6NFSr
	 mvectRCPxlQRmocSFmQTL81S300dyq93JR+1recwmxrW2g6Nsj0iLbB6GBUQP1zZjA
	 9l0ZMUrTB0u8IfGZp0P96vqL2AAJHAIJQjWGe7JN8QARDvy59qXvxbfMWkTag7TiIi
	 Uvc0Wd3KhwXp7I/bSGiO1mMqEkBUm1uOV3FSldDenY7+HGf0ZaKZnt2QSk5QMveJzA
	 I3b8gP0MFIKWoglmkjr8SF6KlzEkAGbvfTanD8e+K8ubule/ostJs2O32JZ+bP6TMs
	 KvN2JYcfx6ky4zbt36+xM8hc=
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 79CF040E02A5;
	Wed, 27 Mar 2024 15:44:01 +0000 (UTC)
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	KVM <kvm@vger.kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>,
	Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 4/5] x86/cc: Add cc_platform_set/_clear() helpers
Date: Wed, 27 Mar 2024 16:43:16 +0100
Message-ID: <20240327154317.29909-5-bp@alien8.de>
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

Add functionality to set and/or clear different attributes of the
machine as a confidential computing platform. Add the first one too:
whether the machine is running as a host for SEV-SNP guests.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/coco/core.c        | 52 +++++++++++++++++++++++++++++++++++++
 include/linux/cc_platform.h | 12 +++++++++
 2 files changed, 64 insertions(+)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index d07be9d05cd0..8c3fae23d3c6 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -16,6 +16,11 @@
 enum cc_vendor cc_vendor __ro_after_init =3D CC_VENDOR_NONE;
 u64 cc_mask __ro_after_init;
=20
+static struct cc_attr_flags {
+	__u64 host_sev_snp	: 1,
+	      __resv		: 63;
+} cc_flags;
+
 static bool noinstr intel_cc_platform_has(enum cc_attr attr)
 {
 	switch (attr) {
@@ -89,6 +94,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr at=
tr)
 	case CC_ATTR_GUEST_SEV_SNP:
 		return sev_status & MSR_AMD64_SEV_SNP_ENABLED;
=20
+	case CC_ATTR_HOST_SEV_SNP:
+		return cc_flags.host_sev_snp;
+
 	default:
 		return false;
 	}
@@ -148,3 +156,47 @@ u64 cc_mkdec(u64 val)
 	}
 }
 EXPORT_SYMBOL_GPL(cc_mkdec);
+
+static void amd_cc_platform_clear(enum cc_attr attr)
+{
+	switch (attr) {
+	case CC_ATTR_HOST_SEV_SNP:
+		cc_flags.host_sev_snp =3D 0;
+		break;
+	default:
+		break;
+	}
+}
+
+void cc_platform_clear(enum cc_attr attr)
+{
+	switch (cc_vendor) {
+	case CC_VENDOR_AMD:
+		amd_cc_platform_clear(attr);
+		break;
+	default:
+		break;
+	}
+}
+
+static void amd_cc_platform_set(enum cc_attr attr)
+{
+	switch (attr) {
+	case CC_ATTR_HOST_SEV_SNP:
+		cc_flags.host_sev_snp =3D 1;
+		break;
+	default:
+		break;
+	}
+}
+
+void cc_platform_set(enum cc_attr attr)
+{
+	switch (cc_vendor) {
+	case CC_VENDOR_AMD:
+		amd_cc_platform_set(attr);
+		break;
+	default:
+		break;
+	}
+}
diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index cb0d6cd1c12f..60693a145894 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -90,6 +90,14 @@ enum cc_attr {
 	 * Examples include TDX Guest.
 	 */
 	CC_ATTR_HOTPLUG_DISABLED,
+
+	/**
+	 * @CC_ATTR_HOST_SEV_SNP: AMD SNP enabled on the host.
+	 *
+	 * The host kernel is running with the necessary features
+	 * enabled to run SEV-SNP guests.
+	 */
+	CC_ATTR_HOST_SEV_SNP,
 };
=20
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
@@ -107,10 +115,14 @@ enum cc_attr {
  * * FALSE - Specified Confidential Computing attribute is not active
  */
 bool cc_platform_has(enum cc_attr attr);
+void cc_platform_set(enum cc_attr attr);
+void cc_platform_clear(enum cc_attr attr);
=20
 #else	/* !CONFIG_ARCH_HAS_CC_PLATFORM */
=20
 static inline bool cc_platform_has(enum cc_attr attr) { return false; }
+static inline void cc_platform_set(enum cc_attr attr) { }
+static inline void cc_platform_clear(enum cc_attr attr) { }
=20
 #endif	/* CONFIG_ARCH_HAS_CC_PLATFORM */
=20
--=20
2.43.0


