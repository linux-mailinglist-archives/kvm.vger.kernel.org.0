Return-Path: <kvm+bounces-6845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8620D83AEAF
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 17:49:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01D6DB242C2
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 16:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B3E7E566;
	Wed, 24 Jan 2024 16:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X616eYhO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE7E77638
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 16:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706114943; cv=none; b=m/ajDgRv4Cf612RkTINaOxTI3X7m68r8kTVjgAaH1hG+fRewvRBNgg7rTSOf7ydrk3XHJZwzyCx9eR+sQVWUUwe4FYjq8hZZ3Om8XDdudMujQBpIFxxCBV9diUNzeFG6yokuBLL03M0nJ8J6bTfeBQMaG9a/fzbP6Xboi772OuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706114943; c=relaxed/simple;
	bh=CqtkdCNxl9n+RA9D/beypA4ENvb3fZHppFOaSs6zSAY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Kka6aW5dUOeEGvpaYNfmI83oWcT6hX+/+FHUHXAvUANgKTxaqJNX/mB9ttPP06OTeZC0Xe84cDEwyQDW5sxqduGfcWepoYxPVMaCH0bHoCKu3sr72vkzWJkxbcgIz6hdYNUREdLF4yuQJiSV0WLBmnWd4ze6tbtoYOHiEBZSY/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X616eYhO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706114941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5XzGyD91tSFtwbaP/RZX9vrPIPZ99bsOrgK+5Q9UbRw=;
	b=X616eYhONdFj8xF9lPhayO4W4hsZ0wV2DuFOE6TUJPBrMT+J1O1zdd5cQX7JlZ2H23mpOe
	hT2bMoexFsP2Py4jhrXZu74zUtKCmRztI5kz10HEJxFdiWEk8xtbEHwqcecBj9p6SF8jPW
	WXP7z2e4wQjBO8HKNpSCVYZUeiVGhy8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-65-V9urWlJmM82sqzWWOEa5og-1; Wed,
 24 Jan 2024 11:48:59 -0500
X-MC-Unique: V9urWlJmM82sqzWWOEa5og-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68A73280604B;
	Wed, 24 Jan 2024 16:48:56 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.249])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B15811C060AF;
	Wed, 24 Jan 2024 16:48:55 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 1/2] KVM: selftests: Avoid infinite loop in hyperv_features when invtsc is missing
Date: Wed, 24 Jan 2024 17:48:54 +0100
Message-ID: <20240124164855.2564824-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

When X86_FEATURE_INVTSC is missing, guest_test_msrs_access() was supposed
to skip testing dependent Hyper-V invariant TSC feature. Unfortunately,
'continue' does not lead to that as stage is not incremented. Moreover,
'vm' allocated with vm_create_with_one_vcpu() is not freed and the test
runs out of available file descriptors very quickly.

Fixes: bd827bd77537 ("KVM: selftests: Test Hyper-V invariant TSC control")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_features.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 4f4193fc74ff..b923a285e96f 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -454,7 +454,7 @@ static void guest_test_msrs_access(void)
 		case 44:
 			/* MSR is not available when CPUID feature bit is unset */
 			if (!has_invtsc)
-				continue;
+				goto next_stage;
 			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
 			msr->write = false;
 			msr->fault_expected = true;
@@ -462,7 +462,7 @@ static void guest_test_msrs_access(void)
 		case 45:
 			/* MSR is vailable when CPUID feature bit is set */
 			if (!has_invtsc)
-				continue;
+				goto next_stage;
 			vcpu_set_cpuid_feature(vcpu, HV_ACCESS_TSC_INVARIANT);
 			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
 			msr->write = false;
@@ -471,7 +471,7 @@ static void guest_test_msrs_access(void)
 		case 46:
 			/* Writing bits other than 0 is forbidden */
 			if (!has_invtsc)
-				continue;
+				goto next_stage;
 			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
 			msr->write = true;
 			msr->write_val = 0xdeadbeef;
@@ -480,7 +480,7 @@ static void guest_test_msrs_access(void)
 		case 47:
 			/* Setting bit 0 enables the feature */
 			if (!has_invtsc)
-				continue;
+				goto next_stage;
 			msr->idx = HV_X64_MSR_TSC_INVARIANT_CONTROL;
 			msr->write = true;
 			msr->write_val = 1;
@@ -513,6 +513,7 @@ static void guest_test_msrs_access(void)
 			return;
 		}
 
+next_stage:
 		stage++;
 		kvm_vm_free(vm);
 	}
-- 
2.43.0


