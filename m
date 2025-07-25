Return-Path: <kvm+bounces-53439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DD9CB11B46
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 11:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32E99542286
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 09:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2E562D63E2;
	Fri, 25 Jul 2025 09:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LqB0Z/oK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BD42D59E3
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 09:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753437284; cv=none; b=AEk0UIW2GVJcoLfIYKsdE4Ea+EmRorFbV+A1t1SjEl6/7vhOkTlprkiW3/lStJcaEVZfL5BE5IqYt9U/ArYPAH9gieccgTXQuFlsM68PdAX13MrIufoIqPeA5dOlNJoIuoOD6aBCCVAaOcgAVzoMVmZ8zrDvgjy6pigu1IZwe2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753437284; c=relaxed/simple;
	bh=Dzv54GeGMcnkv4wh6z2/4PaIEjFPXvAD0QbN4yLSwxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BLz1CcIQP4c5IOp9WdXMhxiiDoUypP36264t1FoDxQchQHq5P1LuhDDW/2Z13WUXk7ODFo+ssNBrCET4d5adJryMw1lLLmYRZ52HEjculhAQsHZoOv+Qia1uzXO1Gih9DKLlM8MGi47aQsAkv1OJTT+RQHABDTua6+J7v8ziN1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LqB0Z/oK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753437281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z0Molssbr+H4GU+Tp94wRgazwZ14/FROuxZY856dEc4=;
	b=LqB0Z/oK/+2gWqAlkhWMM6Qk2MUpNDVQDx5tgp0AHatcDsXQ5UHAhlktZZZGTSHRKOeWs4
	OoQOE5uSH6yTwSM32mewxacntp47XRw68jeRVaruLEjASodpIhdk+9qFVF1paLuTMmYvYS
	7EnbGtBskMRAc9cpT0AcAwerzo95rsk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-495-R2QG3GcQM0iSSZZiCyro9w-1; Fri,
 25 Jul 2025 05:54:39 -0400
X-MC-Unique: R2QG3GcQM0iSSZZiCyro9w-1
X-Mimecast-MFC-AGG-ID: R2QG3GcQM0iSSZZiCyro9w_1753437278
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A975F180137E
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 09:54:38 +0000 (UTC)
Received: from dell-r430-03.lab.eng.brq2.redhat.com (dell-r430-03.lab.eng.brq2.redhat.com [10.37.153.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4C8FA19560AA;
	Fri, 25 Jul 2025 09:54:37 +0000 (UTC)
From: Igor Mammedov <imammedo@redhat.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	peterx@redhat.com
Subject: [kvm-unit-tests PATCH v4 4/5] x86: bump number of max cpus to 1024
Date: Fri, 25 Jul 2025 11:54:28 +0200
Message-ID: <20250725095429.1691734-5-imammedo@redhat.com>
In-Reply-To: <20250725095429.1691734-1-imammedo@redhat.com>
References: <20250725095429.1691734-1-imammedo@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

this should allow run tests with more thatn 256 cpus

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 lib/x86/smp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/smp.h b/lib/x86/smp.h
index bbe90daa..272aa5ee 100644
--- a/lib/x86/smp.h
+++ b/lib/x86/smp.h
@@ -1,7 +1,7 @@
 #ifndef _X86_SMP_H_
 #define _X86_SMP_H_
 
-#define MAX_TEST_CPUS (255)
+#define MAX_TEST_CPUS (1024)
 
 /*
  * Allocate 12KiB of data for per-CPU usage.  One page for per-CPU data, and
-- 
2.47.1


