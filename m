Return-Path: <kvm+bounces-35023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C740A08D9D
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:13:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B870188923F
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 10:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B5B420C461;
	Fri, 10 Jan 2025 10:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z1U7K894"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708A420C031
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 10:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736503928; cv=none; b=t75d4b2O4m0+NUSC7oJCw8O3moeq2xglOtTjZRol01TYDncvbq3S5oRTzbZrS2nwzkjrVv3na/yht4FPWuQ5huoLAoDrXnVQu9v8OGhKOsLfsBm+GcFJEQR60rN25pHlA9gkGP5aV7yrr5e69jyDPFz2zW9agGR6ewLpFv6Y/ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736503928; c=relaxed/simple;
	bh=G1AyobH0IOg0TPIvMe8N364pCsW37FBTfeUc6bXwE/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T8dUQpygz0eXW2Vm2XFtJ0preSd4ftocCyprmI269a8hKN4kppR7RtVxgQsxfr6Cm7PtLrSv2kIqcZ4kaaV0z82G3ZUtNX82a5zfuWBG3+3J7owAeE75wZR18Gr0K78B117+QwOezeosYRnwpWRUGTkZbovvbapsGtpaB2V8bCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z1U7K894; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736503908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9Zur2DLealPSnFJgzW8QqdXP4mA+MiHyBCWGmZ1vfD0=;
	b=Z1U7K8940r7DCx4pkrb5AY0UJ22Fnjb6mmpZrbrgwepKlXF6hTYm5NMULcoDA5dUsPG0eY
	+csd7cpcqxehVkTvR5wviSmxSNXhcaOxfEQCAXaCLoowyvufgN/GJpMg2U4ozwy/0+7OZX
	oiT1aLugokhZRTjO1aXjK+SiGH8cngA=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: SVM: Use str_enabled_disabled() helper in svm_hardware_setup()
Date: Fri, 10 Jan 2025 11:11:00 +0100
Message-ID: <20250110101100.272312-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_enabled_disabled() helper
function.

Suggested-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 21dacd312779..bce562548a6a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -28,6 +28,7 @@
 #include <linux/rwsem.h>
 #include <linux/cc_platform.h>
 #include <linux/smp.h>
+#include <linux/string_choices.h>
 
 #include <asm/apic.h>
 #include <asm/perf_event.h>
@@ -5328,7 +5329,7 @@ static __init int svm_hardware_setup(void)
 	/* Force VM NPT level equal to the host's paging level */
 	kvm_configure_mmu(npt_enabled, get_npt_level(),
 			  get_npt_level(), PG_LEVEL_1G);
-	pr_info("Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
+	pr_info("Nested Paging %s\n", str_enabled_disabled(npt_enabled));
 
 	/* Setup shadow_me_value and shadow_me_mask */
 	kvm_mmu_set_me_spte_mask(sme_me_mask, sme_me_mask);
-- 
2.47.1


