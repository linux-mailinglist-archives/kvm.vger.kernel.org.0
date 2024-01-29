Return-Path: <kvm+bounces-7316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B898400C0
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 09:59:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2708E1C2338C
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 08:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 029D955784;
	Mon, 29 Jan 2024 08:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fqewF380"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A4955779
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706518736; cv=none; b=JR0Fs0fZQOkNcVoslVWSwg1iIjxmcU4K9a3DU0oPI4UPiDhrhbXxlpR/SbSBNcsyZDgCBQN3hs5dLq407imNgmMZyUTDJCpp/V3gU7crw5ZjL8rPj00dcN7h1rA61m9uAt525dNii56TkOzpgRNdp5XXMJJPdQy5Evb8Tsn9TFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706518736; c=relaxed/simple;
	bh=CqtkdCNxl9n+RA9D/beypA4ENvb3fZHppFOaSs6zSAY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YP2X/KhwY94Y4TDiYA9uqabCl0A2hKZ0rMi2sUddmXUgA4nFV5n8OdxU3BFpz4P44Ha1Yo9WvLB214d/NIhpXI76VWq696gzdKMa+uXaYbzUkScBTvBzMDbdVgOdfJrHPCox3hGMu4Xuob51pIBToYInF8W4CaP2vFO3FE6YgDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fqewF380; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706518733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5XzGyD91tSFtwbaP/RZX9vrPIPZ99bsOrgK+5Q9UbRw=;
	b=fqewF380ObVUeZrtHa0ZYRpP83f3SZAj0SPFHic6D0YsUkup5m6pOegVAte1Ru36MP2I2Q
	nhI0J/w9iYQH4xyIpnROfV5Lvr5rjA+MrmkLWLZ9cFkIpeCGrcSwkOyrBVHhsYxfmQm1Tq
	HDj63AIDgj5QNP78D5fz0UXDLZvnmcE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-O3wt7qbhOH660AYE7c-3vg-1; Mon, 29 Jan 2024 03:58:49 -0500
X-MC-Unique: O3wt7qbhOH660AYE7c-3vg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B53A868900;
	Mon, 29 Jan 2024 08:58:49 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.225.235])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 82AA2492BE2;
	Mon, 29 Jan 2024 08:58:48 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v2 1/2] KVM: selftests: Avoid infinite loop in hyperv_features when invtsc is missing
Date: Mon, 29 Jan 2024 09:58:46 +0100
Message-ID: <20240129085847.2674082-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

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


