Return-Path: <kvm+bounces-60631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15D51BF519D
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:55:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F38B482ED2
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE492FBE15;
	Tue, 21 Oct 2025 07:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Shsy/ruz"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C987D2FBDFD
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032944; cv=none; b=u+Zy1T2qVmOtb51txJtQ2o0f8QusJOsI98aAFj6PNdl14lhvA+VuGptjQVaESjXbsdGKl1pD1vIlnlf5Kf5/fNrDuMsTzvQEoHBXd1wBg+zclVQfQqj7g/VIoMz3L5mTNX97CaqdU63E7ABsfdL+s/jeYzTqHBhkCpfuFTEpYQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032944; c=relaxed/simple;
	bh=WZl+NfvTFeCIICBy80HPXyO6w6fEy2StixIcs1Ny6VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kx67mlpJfYe+zi139ETvUWRVCnnrsI6An4HmhtXMZXd6H0SDeI3pmLvJ1VdlhDyuPilwKIeAImsIDcuJX1vWOmI94iXDzzekJqilRULRGJD5gwtg4qDxKOQmeBA0GC4yuiblmuGkf2owjR8uoAcRqVqpnhwBauxEpJdddKAcTvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Shsy/ruz; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kJ+nTdf4y8042XWe/XSw+OeuCD1JfIcWdatLaH3A3NI=;
	b=Shsy/ruzjuIiopgtAiiSs+RlB9sxVVM5J0qH71bi6Z82vUS2P59ax/qN7UZmrQjf3Nr0Vr
	3ov85i38X84gBqni3iWdSxBMKpXAXHxS3GCMGhSeYratWhOSM6qTCuuv/GzK35WcKxYY5W
	GyJD7t3ucY63vqEBoZw+Y/8UmBB9YaI=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 21/23] KVM: selftests: Allow kvm_cpu_has_ept() to be called on AMD CPUs
Date: Tue, 21 Oct 2025 07:47:34 +0000
Message-ID: <20251021074736.1324328-22-yosry.ahmed@linux.dev>
In-Reply-To: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
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
index 1a9743cabcf4b..b1f22e78aca1a 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -365,6 +365,9 @@ bool kvm_cpu_has_ept(void)
 {
 	uint64_t ctrl;
 
+	if (!kvm_cpu_has(X86_FEATURE_VMX))
+		return false;
+
 	ctrl = kvm_get_feature_msr(MSR_IA32_VMX_TRUE_PROCBASED_CTLS) >> 32;
 	if (!(ctrl & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
 		return false;
-- 
2.51.0.869.ge66316f041-goog


