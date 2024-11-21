Return-Path: <kvm+bounces-32313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44DB09D53B5
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 21:08:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2C12282D0C
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E9771D9329;
	Thu, 21 Nov 2024 20:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oWVqjtF0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E6D1C8773;
	Thu, 21 Nov 2024 20:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732219649; cv=none; b=lIzEoeJmcd/8tdtENAx4AceVALlsR5rQEAr7Dpiir7NePJbGo62/h8iybu6DpKj1GtnEQ+Q/CpqsJmo6M6A3yYJiwCWG6trqzrdjNZQNDuV0J2BzuMpRD5KszafY9wMsnDyRAvHSL4dyAtZ6p7P8mfRg7MImtm+Mf5jLneErjtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732219649; c=relaxed/simple;
	bh=FpjLLZz26oP/xzxw3OgjixqR9UwwP/ENIIDlp6IfE2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrlJM4iVtQKVWSxJxBC/Yu8gO6+/cy9uAITn+McNrdt9SYfE/4LjzIB2aDExzL9sF0o9HGwjim1vSbT1ElZLpC7+2byL6t7VydD6Wz7o6yW7yFdvbCID5hZ8ENpDmp7ADndHLHqxVG993R8wdNExeshM0Xr76F4QEMCn6+Uq3V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oWVqjtF0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E14C4CED2;
	Thu, 21 Nov 2024 20:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732219648;
	bh=FpjLLZz26oP/xzxw3OgjixqR9UwwP/ENIIDlp6IfE2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWVqjtF0LfcKXKv7u/4J8p8uobwGevC3aNnvJ6khsYP3RyYI+sEyIuUcl8q7DefWa
	 dtE3WfuMmFMBqwVXDfRIxcM72590qJ1svl4+MW2VFBkPgehE87KI2LXcz/HzgP/SIj
	 EIzzoFe87uQ5dd7gc4LcrZNzW97wwl01jvRvZFFpkwUE5Ltz2TqCZXzkT4c7kSgpCK
	 Yt3XvlgOfFjWxXZ8+uMsN1ZMCeQjHW+U3RZLJrzyAVm+VoG9uyuwkb+OOV6DDT6NO2
	 0VN/wr3tgrNIq7p22hlcjd+KxVy9tsdNnuW3zitnoVKKGoYaParwxW7V21ASGNhY/7
	 gQU1WwG5xviGQ==
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
Subject: [PATCH v2 1/2] x86/bugs: Don't fill RSB on VMEXIT with eIBRS+retpoline
Date: Thu, 21 Nov 2024 12:07:18 -0800
Message-ID: <9bd7809697fc6e53c7c52c6c324697b99a894013.1732219175.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1732219175.git.jpoimboe@kernel.org>
References: <cover.1732219175.git.jpoimboe@kernel.org>
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
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Reviewed-by: Amit Shah <amit.shah@amd.com>
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


