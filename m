Return-Path: <kvm+bounces-11174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EC87873D4A
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:19:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE2CAB25AAA
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11CED13C9C9;
	Wed,  6 Mar 2024 17:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g9NywxzB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CB0135401
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745513; cv=none; b=lkqEt+VdJdIAGUOy3oSgmy70tadBKzN0DIHzH1BeqQhb2hxPK1LfaHncZdliQYIlffULqo3xYrkexR6IlRRONtCie9pTqNpVl6+nM+KnajjD5iULmgjuIpMjGpXbeyx6vnW9ePiMeqdAtZsRNk8LtYvrLx6FszA/xUeNcUkHhlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745513; c=relaxed/simple;
	bh=7YtPki6tYRUa1CMUzO7NjOIR7Q4meW6ryP9Bh7s4oyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vr4zZqkf3j6e/5ZC9PyRDAmmJ+c50pO2zKf6QItecHP2fYMrqtSFVwpoXeu2gP3aOsO35nWFMrRTAbHMnAawP4r58KvT+yrLjsU9dryV+hfpmf4bL9q0OFj7MV9RZHGdeHsWEMB+B+z8ey0ibEKjTfAcn0xTXI2QjLDgLgdQMi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g9NywxzB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709745510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C9ogIIV0VWSurhlZcNa5XnUzwLypJneVYdk1Av68RXg=;
	b=g9NywxzB6o6u1I+/waY+nNqw+pL5HfiWi+N1sDpokBLumdzMweJzVjSMfOioRyEIGTPB+o
	zamAJhjax1tcmaQ7xAzpHy/+N9bYWVoUpw27HgN73B7OUVf3nZvKts+GxdbROtL63Nch/1
	X+MnObWHhEjbL1xqYUSFBb194gykzXk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-574-Cn50-092OoiEoMuecwcIUQ-1; Wed,
 06 Mar 2024 12:18:28 -0500
X-MC-Unique: Cn50-092OoiEoMuecwcIUQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12E551C3826E;
	Wed,  6 Mar 2024 17:18:28 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5D67140C6CB8;
	Wed,  6 Mar 2024 17:18:27 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Metin Kaya <metikaya@amazon.com>
Subject: [PATCH kvm-unit-tests 03/13] x86: hyperv_clock: handle non-consecutive APIC IDs
Date: Wed,  6 Mar 2024 18:18:13 +0100
Message-ID: <20240306171823.761647-4-vkuznets@redhat.com>
In-Reply-To: <20240306171823.761647-1-vkuznets@redhat.com>
References: <20240306171823.761647-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

From: Metin Kaya <metikaya@amazon.com>

smp_id() should not be used if APIC IDs are not allocated consecutively.
Fix it by using on_cpu_async() with CPU ID parameter.

Fixes: 907ce0f78c94 ("KVM: x86: add hyperv clock test case")
Signed-off-by: Metin Kaya <metikaya@amazon.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv_clock.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/x86/hyperv_clock.c b/x86/hyperv_clock.c
index f1e7204a8ea9..dcf101af6968 100644
--- a/x86/hyperv_clock.c
+++ b/x86/hyperv_clock.c
@@ -63,7 +63,7 @@ uint64_t loops[MAX_CPU];
 
 static void hv_clock_test(void *data)
 {
-	int i = smp_id();
+	int i = (long)data;
 	uint64_t t = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
 	uint64_t end = t + 3 * TICKS_PER_SEC;
 	uint64_t msr_sample = t + TICKS_PER_SEC;
@@ -80,7 +80,7 @@ static void hv_clock_test(void *data)
 		if (t < msr_sample) {
 			max_delta = delta > max_delta ? delta: max_delta;
 		} else if (delta < 0 || delta > max_delta * 3 / 2) {
-			printf("suspecting drift on CPU %d? delta = %d, acceptable [0, %d)\n", smp_id(),
+			printf("suspecting drift on CPU %d? delta = %d, acceptable [0, %d)\n", i,
 			       delta, max_delta);
 			ok[i] = false;
 			got_drift = true;
@@ -88,7 +88,7 @@ static void hv_clock_test(void *data)
 		}
 
 		if (now < t && !got_warp) {
-			printf("warp on CPU %d!\n", smp_id());
+			printf("warp on CPU %d!\n", i);
 			ok[i] = false;
 			got_warp = true;
 			break;
@@ -97,7 +97,7 @@ static void hv_clock_test(void *data)
 	} while(t < end);
 
 	if (!got_drift)
-		printf("delta on CPU %d was %d...%d\n", smp_id(), min_delta, max_delta);
+		printf("delta on CPU %d was %d...%d\n", i, min_delta, max_delta);
 	barrier();
 }
 
@@ -106,7 +106,11 @@ static void check_test(int ncpus)
 	int i;
 	bool pass;
 
-	on_cpus(hv_clock_test, NULL);
+	for (i = ncpus - 1; i >= 0; i--)
+		on_cpu_async(i, hv_clock_test, (void *)(long)i);
+
+	while (cpus_active() > 1)
+		pause();
 
 	pass = true;
 	for (i = ncpus - 1; i >= 0; i--)
@@ -117,6 +121,7 @@ static void check_test(int ncpus)
 
 static void hv_perf_test(void *data)
 {
+	int i = (long)data;
 	uint64_t t = hv_clock_read();
 	uint64_t end = t + 1000000000 / 100;
 	uint64_t local_loops = 0;
@@ -126,7 +131,7 @@ static void hv_perf_test(void *data)
 		local_loops++;
 	} while(t < end);
 
-	loops[smp_id()] = local_loops;
+	loops[i] = local_loops;
 }
 
 static void perf_test(int ncpus)
@@ -134,7 +139,11 @@ static void perf_test(int ncpus)
 	int i;
 	uint64_t total_loops;
 
-	on_cpus(hv_perf_test, NULL);
+	for (i = ncpus - 1; i >= 0; i--)
+		on_cpu_async(i, hv_perf_test, (void *)(long)i);
+
+	while (cpus_active() > 1)
+		pause();
 
 	total_loops = 0;
 	for (i = ncpus - 1; i >= 0; i--)
-- 
2.44.0


