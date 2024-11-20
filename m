Return-Path: <kvm+bounces-32127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 048A39D341C
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 08:28:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE8E41F2379F
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 07:28:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 681D016A95B;
	Wed, 20 Nov 2024 07:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e6fgufwB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB1D165EED;
	Wed, 20 Nov 2024 07:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732087675; cv=none; b=NmD8HLttpX8w3okNW0ImrVGlRVssg1lOuWb5duRZUwT4MvKl2/6H2Rao50C9Gd2sgIg9vkRs3OV8BzD9X5dCK2uKzEkd6LIb7GfNeKmJPzm92vN1B5j5ImxN92VAZeEWk5oYaDE3sWcBQ7ds2c1NfJCroRdu+UCy8fnMC68TnZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732087675; c=relaxed/simple;
	bh=XkttW6No2zGOcOnzelZaVIehztftA9meve9EsB8URIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D39xFjX3bf4V+LSjMjq3ygvLeMhfeXHzuO19xlPfFdH8n0HGaRE8Lz3mbS9JqeyF2CwRETt76Yi8XEyUBIoD28Wqo8OC74AXTwv0dAR8fBe8skfvCMl4irr5L9GxwxtlVf2/YhrvnD4TM9OwOw84Z0vXAQpvE1Ry36fL9KTVOO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e6fgufwB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E06C4CED6;
	Wed, 20 Nov 2024 07:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732087675;
	bh=XkttW6No2zGOcOnzelZaVIehztftA9meve9EsB8URIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6fgufwBABjugxF/RB02PuNVV2+75rWMd1Epw6o1LjluVf97UgZYGNYIHPy7LvqDj
	 7EgjyIdkpxEO5i64TLMv4YV2RYKIU71fuuQ19Lv0tHqOF6kh4/88Y9qjlCOmQRyywk
	 Kx7fQZQ5RaTnydBrM+sPCbVVcb+bVaDFCRLbFT+66P5t3neeCPQpyoRfsLPkMVa4qt
	 wirD5BrkmLAZJeRQnHVtzQ/vaI9wdAgpxC4bYztgtIWZdLbORxkwFcZZrV5P9aZz+2
	 6XValI2BLJ5oWG0tvizUB4XB5eCB75QhcEZdZRPrd8oV9ay9SEhNRHRxM5zpYPuVpL
	 EY113sPzgGfmQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	amit@kernel.org,
	kvm@vger.kernel.org,
	amit.shah@amd.com,
	thomas.lendacky@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com,
	corbet@lwn.net,
	mingo@redhat.com,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com,
	kai.huang@intel.com,
	sandipan.das@amd.com,
	boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com,
	david.kaplan@amd.com,
	dwmw@amazon.co.uk,
	andrew.cooper3@citrix.com
Subject: [PATCH 1/2] x86/bugs: Don't fill RSB on VMEXIT with eIBRS+retpoline
Date: Tue, 19 Nov 2024 23:27:50 -0800
Message-ID: <2e062b6c142bb3770a0829e2cf21e11e8fb6ae5c.1732087270.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1732087270.git.jpoimboe@kernel.org>
References: <cover.1732087270.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

eIBRS protects against RSB underflow/poisoning attacks.  Adding
retpoline to the mix doesn't change that.  Retpoline has a balanced
CALL/RET anyway.

So the current full RSB filling on VMEXIT with eIBRS+retpoline is
overkill.  Disable it (or do the VMEXIT_LITE mitigation if needed).

Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 47a01d4028f6..68bed17f0980 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1605,20 +1605,20 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
 	case SPECTRE_V2_NONE:
 		return;
 
-	case SPECTRE_V2_EIBRS_LFENCE:
 	case SPECTRE_V2_EIBRS:
+	case SPECTRE_V2_EIBRS_LFENCE:
+	case SPECTRE_V2_EIBRS_RETPOLINE:
 		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
-			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
 			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
+			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
 		}
 		return;
 
-	case SPECTRE_V2_EIBRS_RETPOLINE:
 	case SPECTRE_V2_RETPOLINE:
 	case SPECTRE_V2_LFENCE:
 	case SPECTRE_V2_IBRS:
-		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
 		pr_info("Spectre v2 / SpectreRSB : Filling RSB on VMEXIT\n");
+		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
 		return;
 	}
 
-- 
2.47.0


