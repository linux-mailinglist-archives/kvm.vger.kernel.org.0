Return-Path: <kvm+bounces-11184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15FBC873D55
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:19:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48BE61C226AE
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CA9313E7EF;
	Wed,  6 Mar 2024 17:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BkssRFkh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A363513E7E9
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745524; cv=none; b=qfRy2Dt4Cl1xD8yiU7Pq65dTTmPVR1uBchVW3D05Lb3IZAA/V9p6dbKlYNSLg+DSiSpRfOg+odsAEs8xJkMwGBUhcd1YXaxqVi4udWMnNFrNLb0Nbh0G/eoxMzEjSB5SPdu8hYgWW8rVmlIoka74G50//lxImqYQbaGMYU+pnHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745524; c=relaxed/simple;
	bh=ByIBJvxq24BDyCKGAgmcuEwLRIfNgzsrXPqDzxGeYU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eSddoevWgs9smzrOUQ7slzyIreOsL1+4wR5RlSE3uJdSZbVekbHGHbiIGI/diXSGD0dHHN6OMAYkGg9KuN1pErmpLF7jHHEV++ZtjKGyFnAQVUA5eNs+8mGpU+lmZCaq1Ot6K5HaBWVpqTwTB1UImszkm7RZtiKS5Cto1zhjHgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BkssRFkh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709745521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hdOhJ4rC6hWj1f8J53XvUbaOEQIlDexo3p05dkjBUyo=;
	b=BkssRFkhU4W2nfOBS3XVRHcX8Fp8itJkPGZlygQnzXRqKerJ2OCU3eaNAaCenCH4OQtRuw
	0SHjOse3LNHA3EPZR6s6eWcOmH0TPncnlZfwY5Nuj0L2Z1VnPnVdsNfdB7rD42WuP1ZW0v
	lUIM+gJbFKBcQF+VxigBr9l8p6uMGzw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-IWwJjpNoOi-5zq4xjG_bmA-1; Wed, 06 Mar 2024 12:18:38 -0500
X-MC-Unique: IWwJjpNoOi-5zq4xjG_bmA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 426BB879847;
	Wed,  6 Mar 2024 17:18:37 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8BC9640C6CB8;
	Wed,  6 Mar 2024 17:18:36 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Metin Kaya <metikaya@amazon.com>
Subject: [PATCH kvm-unit-tests 13/13] x86: hyperv-v: Rewrite flaky hv_clock_test()
Date: Wed,  6 Mar 2024 18:18:23 +0100
Message-ID: <20240306171823.761647-14-vkuznets@redhat.com>
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

hv_clock_test() is reported to be flaky:
https://bugzilla.kernel.org/show_bug.cgi?id=217516

The test tries measuring the divergence between MSR based clock and TSC
page over one second and then expects delta to stay within the measured
range over another two seconds. This works well for a completely idle
system but if tasks get scheduled out, rescheduled to a different CPU,...
the test fails. Widening the expected range helps to certain extent but
even when the expected delta is "max_delta * 1024" sporadic failures still
occur.

Rewrite the test completely to make it stable. Check two things:
- MSR based and TSC page clocksources never go backwards.
- MSR based clocksource read between to TSC page reads stays within the
interval.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv_clock.c | 55 +++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/x86/hyperv_clock.c b/x86/hyperv_clock.c
index d0993bb75ac7..9061da8c6d2c 100644
--- a/x86/hyperv_clock.c
+++ b/x86/hyperv_clock.c
@@ -64,40 +64,51 @@ uint64_t loops[MAX_CPU];
 static void hv_clock_test(void *data)
 {
 	int i = (long)data;
-	uint64_t t = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
-	uint64_t end = t + 3 * TICKS_PER_SEC;
-	uint64_t msr_sample = t + TICKS_PER_SEC;
-	int min_delta = 123456, max_delta = -123456;
+	uint64_t t_msr_prev = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
+	uint64_t t_page_prev = hv_clock_read();
+	uint64_t end = t_page_prev + TICKS_PER_SEC;
 	bool got_drift = false;
-	bool got_warp = false;
+	bool got_warp_msr = false;
+	bool got_warp_page = false;
 
 	ok[i] = true;
 	do {
-		uint64_t now = hv_clock_read();
-		int delta = rdmsr(HV_X64_MSR_TIME_REF_COUNT) - now;
-
-		min_delta = delta < min_delta ? delta : min_delta;
-		if (t < msr_sample) {
-			max_delta = delta > max_delta ? delta: max_delta;
-		} else if (delta < 0 || delta > max_delta * 3 / 2) {
-			printf("suspecting drift on CPU %d? delta = %d, acceptable [0, %d)\n", i,
-			       delta, max_delta);
+		uint64_t t_page_1, t_page_2, t_msr;
+
+		t_page_1 = hv_clock_read();
+		barrier();
+		t_msr = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
+		barrier();
+		t_page_2 = hv_clock_read();
+
+		if (!got_drift && (t_msr < t_page_1 || t_msr > t_page_2)) {
+			printf("drift on CPU %d, MSR value = %ld, acceptable [%ld, %ld]\n", i,
+			       t_msr, t_page_1, t_page_2);
 			ok[i] = false;
 			got_drift = true;
-			max_delta *= 2;
 		}
 
-		if (now < t && !got_warp) {
-			printf("warp on CPU %d!\n", i);
+		if (!got_warp_msr && t_msr < t_msr_prev) {
+			printf("warp on CPU %d, MSR value = %ld prev MSR value = %ld!\n", i,
+			       t_msr, t_msr_prev);
 			ok[i] = false;
-			got_warp = true;
+			got_warp_msr = true;
 			break;
 		}
-		t = now;
-	} while(t < end);
 
-	if (!got_drift)
-		printf("delta on CPU %d was %d...%d\n", i, min_delta, max_delta);
+		if (!got_warp_page && t_page_1 < t_page_prev) {
+			printf("warp on CPU %d, TSC page value = %ld prev TSC page value = %ld!\n", i,
+			       t_page_1, t_page_prev);
+			ok[i] = false;
+			got_warp_page = true;
+			break;
+		}
+
+		t_page_prev = t_page_1;
+		t_msr_prev = t_msr;
+
+	} while(t_page_prev < end);
+
 	barrier();
 }
 
-- 
2.44.0


