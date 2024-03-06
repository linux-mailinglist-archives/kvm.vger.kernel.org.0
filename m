Return-Path: <kvm+bounces-11179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD1F0873D4D
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:19:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B3AF1C22800
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BD5613C9D6;
	Wed,  6 Mar 2024 17:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Br57ynbd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4570213D31A
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745515; cv=none; b=LMk2Pwamu3SEPbc1/P7CzqSxJhlBoSEoSXUeYqirU4aIAGCZKcnyP0oann1KtXC1MFmjyf4SQE5RDCd+Wc68c61SufqqH1uj/Cn+CMMr8i+aApQL9tC8Mr3NUrN7ewN3zWg2m+VIPCU9OlYTX+GvzUIXR655pU8556p8Sg7LdHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745515; c=relaxed/simple;
	bh=/EiI81R1a1VhRo/GH7Abnhdkm/i4OwKQjDvV40o0aes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NJJN8wQ/LxHXm1wY0E46WnIajALQRz6lxgLSqtb3UTJ9A0Eb7flHDPjqtetx281j6cf8mxTeg1GJurDHNJKOH+49hyFMJ/nxMyHaHY69BlDf+nFxVU2EPl4nE9lOtl06roH2ntRpbXSYqHi9u99d8psURaUBB0fQ5QQiq55WlGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Br57ynbd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709745513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ec61FbYLX+dbWUlLAx8gqRMUUUjvwmUPv73wBpbMghI=;
	b=Br57ynbdWeQEpuhdB2lUgKiNjn2xAC5rVTPfKiDoza+07OQ6ugHJAkbIvw0z34mTXnsJaz
	rRehSeU2qKHrxGYrLU66v/exavSGDo+GYUbf2abmL6TcBH/f4LnlBUu0UVsD9oQuM4RRKb
	TVEl1LUNBKgKUSALnoZdCIer6hMpzj8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-owAqfxqBP4eR-yCcNo-T7Q-1; Wed, 06 Mar 2024 12:18:32 -0500
X-MC-Unique: owAqfxqBP4eR-yCcNo-T7Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE42E8007AB;
	Wed,  6 Mar 2024 17:18:31 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 14B0440C6CB8;
	Wed,  6 Mar 2024 17:18:30 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Metin Kaya <metikaya@amazon.com>
Subject: [PATCH kvm-unit-tests 07/13] x86: hyper-v:  Use 'goto' instead of putting the whole test in an 'if' branch in hyperv_synic
Date: Wed,  6 Mar 2024 18:18:17 +0100
Message-ID: <20240306171823.761647-8-vkuznets@redhat.com>
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

Unify 'hyperv_synic' test with other Hyper-V tests by using the:

 if (required-features-missing) {
    report_skip();
    goto done;
 }
 ...

 done:
     return report_summary();

pattern.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv_synic.c | 61 +++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

diff --git a/x86/hyperv_synic.c b/x86/hyperv_synic.c
index 00655db10131..761df8ac43c0 100644
--- a/x86/hyperv_synic.c
+++ b/x86/hyperv_synic.c
@@ -141,45 +141,46 @@ static void synic_test_cleanup(void *ctx)
 
 int main(int ac, char **av)
 {
+    int ncpus, i;
+    bool ok;
 
-    if (hv_synic_supported()) {
-        int ncpus, i;
-        bool ok;
-
-        setup_vm();
-        enable_apic();
+    if (!hv_synic_supported()) {
+	report_skip("Hyper-V SynIC is not supported");
+	goto done;
+    }
 
-        ncpus = cpu_count();
-        if (ncpus > MAX_CPUS)
-            report_abort("number cpus exceeds %d", MAX_CPUS);
-        printf("ncpus = %d\n", ncpus);
+    setup_vm();
+    enable_apic();
 
-        synic_prepare_sint_vecs();
+    ncpus = cpu_count();
+    if (ncpus > MAX_CPUS)
+	report_abort("number cpus exceeds %d", MAX_CPUS);
+    printf("ncpus = %d\n", ncpus);
 
-        printf("prepare\n");
-        on_cpus(synic_test_prepare, (void *)read_cr3());
+    synic_prepare_sint_vecs();
 
-        for (i = 0; i < ncpus; i++) {
-            printf("test %d -> %d\n", i, ncpus - 1 - i);
-            on_cpu_async(i, synic_test, (void *)(ulong)(ncpus - 1 - i));
-        }
-        while (cpus_active() > 1)
-            pause();
+    printf("prepare\n");
+    on_cpus(synic_test_prepare, (void *)read_cr3());
 
-        printf("cleanup\n");
-        on_cpus(synic_test_cleanup, NULL);
+    for (i = 0; i < ncpus; i++) {
+	printf("test %d -> %d\n", i, ncpus - 1 - i);
+	on_cpu_async(i, synic_test, (void *)(ulong)(ncpus - 1 - i));
+    }
+    while (cpus_active() > 1)
+	pause();
 
-        ok = true;
-        for (i = 0; i < ncpus; ++i) {
-            printf("isr_enter_count[%d] = %d\n",
-                   i, atomic_read(&isr_enter_count[i]));
-            ok &= atomic_read(&isr_enter_count[i]) == 16;
-        }
+    printf("cleanup\n");
+    on_cpus(synic_test_cleanup, NULL);
 
-        report(ok, "Hyper-V SynIC test");
-    } else {
-        printf("Hyper-V SynIC is not supported");
+    ok = true;
+    for (i = 0; i < ncpus; ++i) {
+	printf("isr_enter_count[%d] = %d\n",
+	       i, atomic_read(&isr_enter_count[i]));
+	ok &= atomic_read(&isr_enter_count[i]) == 16;
     }
 
+    report(ok, "Hyper-V SynIC test");
+
+done:
     return report_summary();
 }
-- 
2.44.0


