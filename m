Return-Path: <kvm+bounces-13886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1469989C1DB
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 15:24:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2866BB2577F
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 13:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C24917C098;
	Mon,  8 Apr 2024 13:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpDwv0c4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D52757E3;
	Mon,  8 Apr 2024 13:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582189; cv=none; b=hRFXVRsi6khIRynWepwkB/kCQ2gM9TLx88ruwlFYsdoOwZb19gQhX5kJQYFu4oRtW34belCSxoH3FNjMXiLxicnmFChysLslsk0ZABa9QBYw8h/2mf1NCdFiz6GbJfd5a4vkQZF36rcjMei0ABub/KFSNXY8oSAE1Q5gpYoOlYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582189; c=relaxed/simple;
	bh=06ni3DCbQ3ig9NBb3rJXHn1IFQkHFqei2QnMHNmMJ9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QthGybNYlxGXaRJ6fNcxUn9vKxmNldD8KiWaxv/tg+8NnUHODMQuCalh+XRKg1pA41ObjcIEl5GcABl23MJyW1UAvW3b5HjwOMlWvE1Hz5+jsC47GZTrTmVk2PiuU9hSwXTT6KBcAMA4eRUVpsovqd1QIIzaAUYnU6ObZXP/T5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpDwv0c4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572ADC433F1;
	Mon,  8 Apr 2024 13:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582188;
	bh=06ni3DCbQ3ig9NBb3rJXHn1IFQkHFqei2QnMHNmMJ9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JpDwv0c40rj46UZFN8n7yHh3quugYciGDS0Uka5UM0wMkTyop0K/dgg8vH5DSk7jb
	 qJ6LrxUYyrpf0++naXPrIGa3HUWwclxFX71sMX1t3xApqBuDgoMwBCwNZfmlvl9BWq
	 u5fgF9b2vRXg/RnAaEad6X2Wvvi8vSKS5e9lV+/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/138] KVM: SVM: enhance info printks in SEV init
Date: Mon,  8 Apr 2024 14:58:19 +0200
Message-ID: <20240408125258.869451928@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>

[ Upstream commit 6d1bc9754b04075d938b47cf7f7800814b8911a7 ]

Let's print available ASID ranges for SEV/SEV-ES guests.
This information can be useful for system administrator
to debug if SEV/SEV-ES fails to enable.

There are a few reasons.
SEV:
- NPT is disabled (module parameter)
- CPU lacks some features (sev, decodeassists)
- Maximum SEV ASID is 0

SEV-ES:
- mmio_caching is disabled (module parameter)
- CPU lacks sev_es feature
- Minimum SEV ASID value is 1 (can be adjusted in BIOS/UEFI)

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stéphane Graber <stgraber@ubuntu.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Link: https://lore.kernel.org/r/20230522161249.800829-3-aleksandr.mikhalitsyn@canonical.com
[sean: print '0' for min SEV-ES ASID if there are no available ASIDs]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 0aa6b90ef9d7 ("KVM: SVM: Add support for allowing zero SEV ASIDs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3dc0ee1fe9db9..1fe9257d87b2d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2217,7 +2217,6 @@ void __init sev_hardware_setup(void)
 	if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count))
 		goto out;
 
-	pr_info("SEV supported: %u ASIDs\n", sev_asid_count);
 	sev_supported = true;
 
 	/* SEV-ES support requested? */
@@ -2245,10 +2244,18 @@ void __init sev_hardware_setup(void)
 	if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
 		goto out;
 
-	pr_info("SEV-ES supported: %u ASIDs\n", sev_es_asid_count);
 	sev_es_supported = true;
 
 out:
+	if (boot_cpu_has(X86_FEATURE_SEV))
+		pr_info("SEV %s (ASIDs %u - %u)\n",
+			sev_supported ? "enabled" : "disabled",
+			min_sev_asid, max_sev_asid);
+	if (boot_cpu_has(X86_FEATURE_SEV_ES))
+		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
+			sev_es_supported ? "enabled" : "disabled",
+			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
 #endif
-- 
2.43.0




