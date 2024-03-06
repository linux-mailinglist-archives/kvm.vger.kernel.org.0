Return-Path: <kvm+bounces-11187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA315873D58
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:20:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85E55284FDB
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4C9E13BAC5;
	Wed,  6 Mar 2024 17:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DhJdtVBY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D8C5D8F0
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745581; cv=none; b=jFTniTd9KBHkKxnBYq2DQqfnCBj+3gh6Tz8HjgwlqIE1mD6jvTqnCuMM+6fTt96qupzrOYO0kGCn6gnUQvnImtXJeOKhaHGyVhiXnuAqdiynYDcKruROyNQy7HghQ/HKpmlSAi/LwRBXjatWiqG1PiWO7033TxmzHnjUhGtlsjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745581; c=relaxed/simple;
	bh=cLcUbDThDkL8Hwd2ZWrRNPE69C0PJ40dtLWmywV708s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AZst5r1HiyoN59aAO5JS7ENtZsvqC7nCduuiMb/J7lheIp//uoRQUBQcHIrF6eu+6Xc4T2gc16nVoOM0FVnzShOkyXH8KsKfmG5H8U8BHvg8P9ehK5D5VOfVphDA39aZbKLDUtkeuVxtzmNOwoHCMJlSJipMBrYCSOopkYz5Boc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DhJdtVBY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709745560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z5rCX7AirJikElUvfTFQz3wJR/UTcSxkbD236bsi7dk=;
	b=DhJdtVBYcMvBMVhCfCC9jWp/Cki7RGy40qLOrRtGXQjQtm62oZ0e7Ui4qgfr6p4g2lKq2z
	9Jm6Je2Wrm30nmbntq19K0CX6CAutePzJVjBhXcKMvyDG7ZT60axs/mW5qFiq592V66LqO
	dEbbIMkiGO4HQW7ucD0QYoqW/neLiKM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-1mMPfyPyO2yf5nVH1Lwq9A-1; Wed, 06 Mar 2024 12:18:39 -0500
X-MC-Unique: 1mMPfyPyO2yf5nVH1Lwq9A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9B82800269;
	Wed,  6 Mar 2024 17:18:32 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F3D9E40C6CB8;
	Wed,  6 Mar 2024 17:18:31 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Metin Kaya <metikaya@amazon.com>
Subject: [PATCH kvm-unit-tests 08/13] x86: hyper-v: Unify hyperv_clock with other Hyper-V tests
Date: Wed,  6 Mar 2024 18:18:18 +0100
Message-ID: <20240306171823.761647-9-vkuznets@redhat.com>
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

Always do 'return report_summary()' at the end, use report_abort() when an
abnormality is detected.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv_clock.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/x86/hyperv_clock.c b/x86/hyperv_clock.c
index 9c30fbebf249..d0993bb75ac7 100644
--- a/x86/hyperv_clock.c
+++ b/x86/hyperv_clock.c
@@ -153,7 +153,6 @@ static void perf_test(int ncpus)
 
 int main(int ac, char **av)
 {
-	int nerr = 0;
 	int ncpus;
 	struct hv_reference_tsc_page shadow;
 	uint64_t tsc1, t1, tsc2, t2;
@@ -161,7 +160,7 @@ int main(int ac, char **av)
 
 	if (!hv_time_ref_counter_supported()) {
 		report_skip("time reference counter is unsupported");
-		return report_summary();
+		goto done;
 	}
 
 	setup_vm();
@@ -176,10 +175,8 @@ int main(int ac, char **av)
 	       "MSR value after enabling");
 
 	hvclock_get_time_values(&shadow, hv_clock);
-	if (shadow.tsc_sequence == 0 || shadow.tsc_sequence == 0xFFFFFFFF) {
-		printf("Reference TSC page not available\n");
-		exit(1);
-	}
+	if (shadow.tsc_sequence == 0 || shadow.tsc_sequence == 0xFFFFFFFF)
+		report_abort("Reference TSC page not available\n");
 
 	printf("sequence: %u. scale: %" PRIx64" offset: %" PRId64"\n",
 	       shadow.tsc_sequence, shadow.tsc_scale, shadow.tsc_offset);
@@ -206,5 +203,6 @@ int main(int ac, char **av)
 	report(rdmsr(HV_X64_MSR_REFERENCE_TSC) == 0,
 	       "MSR value after disabling");
 
-	return nerr > 0 ? 1 : 0;
+done:
+	return report_summary();
 }
-- 
2.44.0


