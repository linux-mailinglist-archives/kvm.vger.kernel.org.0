Return-Path: <kvm+bounces-33036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD669E3B98
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 14:46:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5600D286104
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 579941F4279;
	Wed,  4 Dec 2024 13:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="kwR+4FO4"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53D418AE2;
	Wed,  4 Dec 2024 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733319954; cv=none; b=glpLhF+2bLBaResmgsewZqKc1j5dpbNlSb7gTPImz6SAtbOpK/N86WM1cuxths4nAmEChVFZGhqKeWlM1Msa80YdA+04kqGOhrFwcnV5mxAjCvxNe2zz85W7BFynn5wK70MdKOPLYhwMZvcIHw6voe5Jn5wrB46fUZ3EimdNmks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733319954; c=relaxed/simple;
	bh=9pHtMb0zhA8IZCgqFuHY/Df1oDagn1gFNoblrBgk7TQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GsCxAXz0RcBVfJeUg44s7Vl8MZBLLnABcdsXapUYoRwpKeeipvUVyndQl6R98TpqydK+BcXR5TEQWOMOmcIYUoZTpDsHi5bHVH57n4Y53uq+hYpmTwNWsb0wUAHBluo8I0ks5zUOULlSN3/ZLzCIOoSBgedCOtEC7C9cfrAyrzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=kwR+4FO4; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:2e8b:0:640:9795:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id C5D6260A5C;
	Wed,  4 Dec 2024 16:43:59 +0300 (MSK)
Received: from davydov-max-lin.yandex.net (unknown [2a02:6bf:8011:701:66e1:20a5:ba04:640b])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id lhgH281Ia8c0-xxrqopuL;
	Wed, 04 Dec 2024 16:43:59 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1733319839;
	bh=D1MIm1QJ9PdNAbNZFIfayaS97QQZKZ2TJT5zCanRheI=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=kwR+4FO4fbmtBWD61ERQfkdv8F09T7EoK+jrju1B6fX3dBms5MZqjbT6elDEvDQpX
	 GZn0/JcPu4B0pguZdwhQKOW8QzsZsGAmQwQWungKdRi1l1ILFEsh7vj081cidKskYG
	 81YJK/rVp0bcfMaONsOypaDDpYdSsGPiZUggg8Ys=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Maksim Davydov <davydov-max@yandex-team.ru>
To: kvm@vger.kernel.org
Cc: davydov-max@yandex-team.ru,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	babu.moger@amd.com,
	seanjc@google.com,
	mingo@redhat.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	jmattson@google.com,
	pbonzini@redhat.com
Subject: [PATCH v3 2/2] x86: KVM: Advertise AMD's speculation control features
Date: Wed,  4 Dec 2024 16:43:45 +0300
Message-Id: <20241204134345.189041-3-davydov-max@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241204134345.189041-1-davydov-max@yandex-team.ru>
References: <20241204134345.189041-1-davydov-max@yandex-team.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It seems helpful to expose to userspace some speculation control features
from 0x80000008_EBX function:
* 16 bit. IBRS always on. Indicates whether processor prefers that
  IBRS is always on. It simplifies speculation managing.
* 18 bit. IBRS is preferred over software solution. Indicates that
  software mitigations can be replaced with more performant IBRS.
* 19 bit. IBRS provides Same Mode Protection. Indicates that when IBRS
  is set indirect branch predictions are not influenced by any prior
  indirect branches.
* 29 bit. BTC_NO. Indicates that processor isn't affected by branch type
  confusion. It's used during mitigations setting up.

Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/cpufeatures.h | 3 +++
 arch/x86/kvm/cpuid.c               | 5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 45f87a026bba..0a709d03ee5c 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -343,7 +343,10 @@
 #define X86_FEATURE_AMD_IBPB		(13*32+12) /* Indirect Branch Prediction Barrier */
 #define X86_FEATURE_AMD_IBRS		(13*32+14) /* Indirect Branch Restricted Speculation */
 #define X86_FEATURE_AMD_STIBP		(13*32+15) /* Single Thread Indirect Branch Predictors */
+#define X86_FEATURE_AMD_IBRS_ALWAYS_ON	(13*32+16) /* Indirect Branch Restricted Speculation always-on preferred */
 #define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* Single Thread Indirect Branch Predictors always-on preferred */
+#define X86_FEATURE_AMD_IBRS_PREFERRED	(13*32+18) /* Indirect Branch Restricted Speculation is preferred over SW solution */
+#define X86_FEATURE_AMD_IBRS_SAME_MODE	(13*32+19) /* Indirect Branch Restricted Speculation provides Same Mode protection */
 #define X86_FEATURE_AMD_PPIN		(13*32+23) /* "amd_ppin" Protected Processor Inventory Number */
 #define X86_FEATURE_AMD_SSBD		(13*32+24) /* Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* "virt_ssbd" Virtualized Speculative Store Bypass Disable */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7bc095add8ee..204192425e2c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -756,8 +756,9 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
 		F(CLZERO) | F(XSAVEERPTR) |
 		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
-		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
-		F(AMD_PSFD) | F(AMD_IBPB_RET)
+		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_IBRS_ALWAYS_ON) |
+		F(AMD_STIBP_ALWAYS_ON) | F(AMD_IBRS_PREFERRED) |
+		F(AMD_IBRS_SAME_MODE) | F(AMD_PSFD) | F(BTC_NO) | F(AMD_IBPB_RET)
 	);
 
 	/*
-- 
2.34.1


