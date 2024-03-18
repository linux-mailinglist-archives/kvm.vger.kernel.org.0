Return-Path: <kvm+bounces-12046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E359B87F406
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:34:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73DF01F22D38
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421DF5F869;
	Mon, 18 Mar 2024 23:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OKKO7YoA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AD65F859
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804838; cv=none; b=EDXnVU13USiHNa28YPqesAR8yd86IDQn2ntluAGb2sSv73T18YEeG1ZUi3REcDSmuRdto8lZ8iv9uFSXzlPh8hhBPmiwWcQUm9JXhpU3qpZjJOpEyDVUvGdy7yQvn+sZPH5ZaplLRC/+juFgzpdqDcmBZ7JDAYCuNPTjp02t/nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804838; c=relaxed/simple;
	bh=Tf4feJZhWwnmgiC2l7Is9hf7qtWmR8OKc/AKvKQIlNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tF9NXrdpPIg3vg92eUIQdeo6CS0HWRxBEeY667ILoQi7TNjtQOWwf5TAQzC1iorTVdzOBlybSJSFTQF2La7YJ+JhCvzJzJuyHJhEDbgk/lpg80SE43Uq1lK+L4c43rnHGCzS1tlC+1gJR6NPvFSR8pzQ08YrVkbHTpdQIgNF7kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OKKO7YoA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710804835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ON5fE7hrojJzQ2xG5TVkP4zn85dxrOKCit9Bo+PfrAs=;
	b=OKKO7YoAKCL0K6ALcAMSm2vIge7+BetCQOP32I/TUyNWhEPmHVMVe/wyfTVxNDeR6qSbby
	egdSpYHU5GWk3nM/QP9XtS2OjBn0woiD78xeeJcd/s/MsYSAXpdGWQiYxRLiZExg5WAgeb
	mT5BxZyTrrhwyEFP7yX1TSCedgERZ00=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-1fJNkKPdNo6AozPsADC4pg-1; Mon, 18 Mar 2024 19:33:54 -0400
X-MC-Unique: 1fJNkKPdNo6AozPsADC4pg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE58D101A523;
	Mon, 18 Mar 2024 23:33:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A72371121312;
	Mon, 18 Mar 2024 23:33:53 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	seanjc@google.com
Subject: [PATCH v4 01/15] KVM: SVM: Invert handling of SEV and SEV_ES feature flags
Date: Mon, 18 Mar 2024 19:33:38 -0400
Message-ID: <20240318233352.2728327-2-pbonzini@redhat.com>
In-Reply-To: <20240318233352.2728327-1-pbonzini@redhat.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

From: Sean Christopherson <seanjc@google.com>

Leave SEV and SEV_ES '0' in kvm_cpu_caps by default, and instead set them
in sev_set_cpu_caps() if SEV and SEV-ES support are fully enabled.  Aside
from the fact that sev_set_cpu_caps() is wildly misleading when it *clears*
capabilities, this will allow compiling out sev.c without falsely
advertising SEV/SEV-ES support in KVM_GET_SUPPORTED_CPUID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c   | 2 +-
 arch/x86/kvm/svm/sev.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index adba49afb5fe..bde4df13a7e8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -761,7 +761,7 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_8000_000A_EDX, 0);
 
 	kvm_cpu_cap_mask(CPUID_8000_001F_EAX,
-		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
+		0 /* SME */ | 0 /* SEV */ | 0 /* VM_PAGE_FLUSH */ | 0 /* SEV_ES */ |
 		F(SME_COHERENT));
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e5a4d9b0e79f..382c745b8ba9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2186,10 +2186,10 @@ void sev_vm_destroy(struct kvm *kvm)
 
 void __init sev_set_cpu_caps(void)
 {
-	if (!sev_enabled)
-		kvm_cpu_cap_clear(X86_FEATURE_SEV);
-	if (!sev_es_enabled)
-		kvm_cpu_cap_clear(X86_FEATURE_SEV_ES);
+	if (sev_enabled)
+		kvm_cpu_cap_set(X86_FEATURE_SEV);
+	if (sev_es_enabled)
+		kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
 }
 
 void __init sev_hardware_setup(void)
-- 
2.43.0



