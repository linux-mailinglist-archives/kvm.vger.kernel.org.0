Return-Path: <kvm+bounces-34392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61FCE9FD29D
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 10:47:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF27E3A0852
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 09:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62EFF156676;
	Fri, 27 Dec 2024 09:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ueQbZ6qm"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE53614B95A
	for <kvm@vger.kernel.org>; Fri, 27 Dec 2024 09:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735292849; cv=none; b=gOo1Gw7s8KtY6GZRYQWHt78aAldmcYqqbjzSp9lUTnUv+89c7TlqXB2zaaW2kMXqkzyv16yHkTm2yA76r/DOcpFEl+ijjPhOzA+6vd20pmn/T7WoQc7Xs5FpnG2VDeACBLzoVRvk/zh5eIIFLGnqpglzkaOBpW+ahlmUFGb00/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735292849; c=relaxed/simple;
	bh=I5rAxSKt6KZgIgjQqisyZF8i76xSM/OKzCzooJPLS4s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YvSgRGfQer3umDMQmum06RLgRmoZRDdHi8bqDNeF5NXs6VboYWjZk2J7LNsWyfBfjOMV/jwQ5rrHLuDgLLrwxI9mtZXQngwthHgx94GdYwSdrkTJ4jEw2R6MMNjGqlyf2pSfy+VyD/pyimzfnN93JH3Ud+nM42eknfdc9icHlWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ueQbZ6qm; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735292844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=R6y3mLgVWfptFv2XR/X3flKX5gXTmzLTfkqaGw6CwY8=;
	b=ueQbZ6qmwiptX6FfwQXuhLYV9MtypBBr2X/6xvCob6j+sqK7pN0Z6vgeAoJgK47sfG31qm
	q11GmoH8LXpM52VI05lkLnhkBmQNbWdrAtxRwA8XkvvAeS9B36R46xOyjU88yC8seS8YR3
	eVXZ4Ps9jvNuS3RQji7DVIYcohXlk0I=
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
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: SVM: Use str_enabled_disabled() helper in sev_hardware_setup()
Date: Fri, 27 Dec 2024 10:44:51 +0100
Message-ID: <20241227094450.674104-2-thorsten.blum@linux.dev>
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

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 943bd074a5d3..87ed8cde68a7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3051,11 +3051,11 @@ void __init sev_hardware_setup(void)
 			min_sev_asid, max_sev_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_ES))
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
-			sev_es_supported ? "enabled" : "disabled",
+			str_enabled_disabled(sev_es_supported),
 			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
 	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
 		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
-			sev_snp_supported ? "enabled" : "disabled",
+			str_enabled_disabled(sev_snp_supported),
 			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
 
 	sev_enabled = sev_supported;
-- 
2.47.1


