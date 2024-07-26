Return-Path: <kvm+bounces-22317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 361BE93D474
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 15:45:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D306A1F24533
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 13:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A07E817BB26;
	Fri, 26 Jul 2024 13:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WvgRSOU7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333871E51F
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 13:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722001512; cv=none; b=Eut9X5IfLQcoYsFhhv2k+kJ7YUWWhMUqEC6oglBPBOFrUiHXLWAeC5sbH6Dvf/XTmwH3vw8MWUTK7yqkNsvucknRPEwV8AhYW43XhHZ7GVOCz9AT14l8ohppk+Z5JYurXgFWMal5z32AHWeoNgyqGuvWw/o+LUmbDsWQBc0YAt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722001512; c=relaxed/simple;
	bh=jHCUIM+RYqPqB2UI6fy8qFUoDGCmOaxu61kmYgMyhsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnaTfkMw3UqYJ+FlivYmnrhhnQsiUwcwG4tkjUOogYvDij7LQ7mIr8xtKa9lqB5Dz9195xoirGN1q1ZGmEf+1SXCttmOhmTMgAnLzi8VR9yAB1E/GA4I8hH12nWat3GAeiN6bdKQo/Wbhvi0MsXDd7HlWdxd4qQfuNW99H5qO7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WvgRSOU7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722001510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E3IWYfQZY9Vtpyu9w1tUYKrkYYnY1w3NcI8rW4hxkqc=;
	b=WvgRSOU7MdEBrShciCWLIbxPsFHL7yl603WQsf+BrLfj0pkzntL1Q1bjHC3z2kQ/bs4boR
	zOgpQbMmfdX+xAuojr8R59HD+QWxx3mOr0kx1hcR0vJqZ4IxQsAAHPbEa6kMIhDX1eYjcU
	YWwFvVegbFMv3PXOCOlqCrBzkZ/LH7s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-670-PAgA_eesNUeDe2ihR7jBMg-1; Fri,
 26 Jul 2024 09:45:05 -0400
X-MC-Unique: PAgA_eesNUeDe2ihR7jBMg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2D3B11955D4E;
	Fri, 26 Jul 2024 13:45:03 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.22.17.77])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 102E31955D42;
	Fri, 26 Jul 2024 13:44:57 +0000 (UTC)
From: Cleber Rosa <crosa@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Beraldo Leal <bleal@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	David Woodhouse <dwmw2@infradead.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Leif Lindholm <quic_llindhol@quicinc.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	qemu-arm@nongnu.org,
	Radoslaw Biernacki <rad@semihalf.com>,
	Cleber Rosa <crosa@redhat.com>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH 03/13] tests/avocado/intel_iommu.py: increase timeout
Date: Fri, 26 Jul 2024 09:44:28 -0400
Message-ID: <20240726134438.14720-4-crosa@redhat.com>
In-Reply-To: <20240726134438.14720-1-crosa@redhat.com>
References: <20240726134438.14720-1-crosa@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Based on many runs, the average run time for these 4 tests is around
250 seconds, with 320 seconds being the ceiling.  In any way, the
default 120 seconds timeout is inappropriate in my experience.

Let's increase the timeout so these tests get a chance to completion.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/intel_iommu.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/avocado/intel_iommu.py b/tests/avocado/intel_iommu.py
index 008f214397..9e7965c5df 100644
--- a/tests/avocado/intel_iommu.py
+++ b/tests/avocado/intel_iommu.py
@@ -25,6 +25,8 @@ class IntelIOMMU(LinuxTest):
     :avocado: tags=flaky
     """
 
+    timeout = 360
+
     IOMMU_ADDON = ',iommu_platform=on,disable-modern=off,disable-legacy=on'
     kernel_path = None
     initrd_path = None
-- 
2.45.2


