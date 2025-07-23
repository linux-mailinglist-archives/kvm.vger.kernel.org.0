Return-Path: <kvm+bounces-53275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AA61B0F85C
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 18:48:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55B97AA701E
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 16:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFDB11F4281;
	Wed, 23 Jul 2025 16:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IZXmyH3a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2958C2F5B
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 16:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753289272; cv=none; b=YurHRNLnsHNJSwrR55+7e7znxmMm7yRgDMXTRKFpEak5ZbwElKRzvWjHIo85n5IppldhRV1Nt+zUYczKbQUTqECuBFZcz/VaVR91fRLEFQnxdtuEUTT6SdqNs82epHQfFYmLKKq1YvsLqDmzeyLeLiseBxDUsw+zGGeC2Z72eDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753289272; c=relaxed/simple;
	bh=j/6T3Diy7rkAmW2icHdtncVKOCz3TIqw0F3Q5A4CvYc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RVXVhdpilN1W/tWmnrt5050l07NyWucL1Oh7ck7kb34+mVmHp6+Si5FfF4OaQRtPe4EYejJYDTsTIO1xOWvAKppkhqvU3vf+lhjQAxk8HhFduQaOyxqYPPy+c13iJAgaj4PXyVqA/fPuAgxxX1r2DH+nDKKTFgBW+m40WyV2CQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IZXmyH3a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753289268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DU/3ZuFtC8mVL3Kg42Twus30hoOeEWvMnmTqIziTsew=;
	b=IZXmyH3aAvVGI7Ch3JbUy8wYjtE4NVCQipOQ+zVh5V9dCgY3xSixX3D016o6FBP/MC3UhI
	O53NLX+IH3C59Zj+QYFw0+o13BmNutQ0oVHodFbCGYl62l6B2J7h3bW/83PhW64JOHyMbd
	4Oi0w6MytiosocMA2TfRQbpl4ocroPw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-625-EBd3xw2INiuIaxpXIyEXkA-1; Wed,
 23 Jul 2025 12:47:47 -0400
X-MC-Unique: EBd3xw2INiuIaxpXIyEXkA-1
X-Mimecast-MFC-AGG-ID: EBd3xw2INiuIaxpXIyEXkA_1753289266
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 369FE180028F;
	Wed, 23 Jul 2025 16:47:46 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.32.42])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 996B719560A3;
	Wed, 23 Jul 2025 16:47:44 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	seanjc@google.com
Subject: [kvm-unit-tests PATCH] x86/pmu: Fix compilation on macOS
Date: Wed, 23 Jul 2025 18:47:42 +0200
Message-ID: <20250723164742.1174289-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Thomas Huth <thuth@redhat.com>

Compiling for i686 on macOS in the CI currently fails with:

.../cirrus-ci-build/x86/pmu.c: In function 'main':
.../cirrus-ci-build/x86/pmu.c:1012:41: error: format '%x' expects argument of
 type 'unsigned int', but argument 2 has type 'u32' {aka 'long unsigned int'}
 [-Werror=format=]
 1012 |     printf("Arch Events (mask):  0x%x\n", pmu.arch_event_available);
      |                                    ~^     ~~~~~~~~~~~~~~~~~~~~~~~~
      |                                     |        |
      |                                     |        u32 {aka long unsigned int}
      |                                     unsigned int
      |                                    %lx

Use the correct format string for u32 to fix this issue.

Fixes: 92dc5f7a ("x86/pmu: Mark Intel architectural event available [...]")
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index a6b0cfcc..f932ccab 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -1009,7 +1009,7 @@ int main(int ac, char **av)
 	printf("GP counters:         %d\n", pmu.nr_gp_counters);
 	printf("GP counter width:    %d\n", pmu.gp_counter_width);
 	printf("Event Mask length:   %d\n", pmu.arch_event_mask_length);
-	printf("Arch Events (mask):  0x%x\n", pmu.arch_event_available);
+	printf("Arch Events (mask):  0x%" PRIx32 "\n", pmu.arch_event_available);
 	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
 	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
 
-- 
2.50.1


