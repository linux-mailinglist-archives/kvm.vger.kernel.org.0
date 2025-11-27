Return-Path: <kvm+bounces-64812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D414CC8C930
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:37:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4D73334ED3F
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D1D2882BB;
	Thu, 27 Nov 2025 01:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uSvzL6h4"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E60217F24
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 01:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764207319; cv=none; b=u+iLhac4I8FmsdBRq6sQSIsYTtwOr4tHfGEsYfmBqMwXr3BF5DbXyCp72Hu9eBViUc2gDfVojeNhouXB0TUGgDEfh6TiFK40JI9TDi4FcJNrAHuaY/vZp196uJ6mx6HGhW2WqYBuJmjlcL/+QtGanU5asFODzLuz1ZtGdPpsUE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764207319; c=relaxed/simple;
	bh=iov89OnzwSVvqHY9f1/B1XYffUPu1JAJnF9bRQI4HI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7YRA6t3nKpfx3Ae/HbS13XJTiYSXf01TvV1gq5uVZxQ2a3XjyEYPFFwYuI23W/hacH12dPkqHTnQ5hZc9msjLHhqtmo8/F85+LwrStImCN1dV18K1xeQQ/GZhrtnKNxoT4nWVQdKATvGasWcj7bwXihzr1BqbPNzn4uHII7q4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uSvzL6h4; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764207316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5f4Tl1oderqSVFxuqxAn2Fzh62L9qK3Bx3fdCjBdAZY=;
	b=uSvzL6h4Ue7vpSUiEM2G/Sef9dyVAe0Q70LfcrdQM3Qjt8Hlca6fGvTJ3PhRqg2nGDPEkz
	Bgcrh1OwBiRm/3o0v/O3vLI1VGPnyVkLAV/btX+2huWSWzq2ZTDVroZpQ62RlxnYIzDRz8
	crvIveyZTewlvw0zKg/Z0u2kk9UXVOI=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 12/16] KVM: selftests: Allow kvm_cpu_has_ept() to be called on AMD CPUs
Date: Thu, 27 Nov 2025 01:34:36 +0000
Message-ID: <20251127013440.3324671-13-yosry.ahmed@linux.dev>
In-Reply-To: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In preparation for generalizing the nested dirty logging test, checking
if either EPT or NPT is enabled will be needed. To avoid needing to gate
the kvm_cpu_has_ept() call by the CPU type, make sure the function
returns false if VMX is not available instead of trying to read VMX-only
MSRs.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/lib/x86/vmx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 4289c9eb61ff..f70d0d591d5a 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -380,6 +380,9 @@ bool kvm_cpu_has_ept(void)
 {
 	uint64_t ctrl;
 
+	if (!kvm_cpu_has(X86_FEATURE_VMX))
+		return false;
+
 	ctrl = kvm_get_feature_msr(MSR_IA32_VMX_TRUE_PROCBASED_CTLS) >> 32;
 	if (!(ctrl & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
 		return false;
-- 
2.52.0.158.g65b55ccf14-goog


