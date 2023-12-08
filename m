Return-Path: <kvm+bounces-3954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F4980ACA8
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 20:09:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D61FE1F21353
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D2E84CB40;
	Fri,  8 Dec 2023 19:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VN1FchSI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4137384
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 11:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702062580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RtZ362NiJGxvbeWbael3pXl8UQtexWlIoEdoihDgXIM=;
	b=VN1FchSIO3xNilXpsIE/iddXTysu0JpbiR0r5B0X5ipBx+vLjblfVcz7q+zBrxHfCY6McU
	8SknqEEUZVfmWgOTx9V+Fpeo8gpnSNMGx92h0R8u0lGXTVYNTcS+I5so/0Fo/kmMcpqWWs
	04tQaJqJxeYoH9GqXaDkj8LDgC7WHvU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-625-FVcO3bX4Nqmuzkc0Zr7RvQ-1; Fri,
 08 Dec 2023 14:09:32 -0500
X-MC-Unique: FVcO3bX4Nqmuzkc0Zr7RvQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32A5A1C05195;
	Fri,  8 Dec 2023 19:09:31 +0000 (UTC)
Received: from p1.localdomain.com (ovpn-114-104.gru2.redhat.com [10.97.114.104])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DA75112131D;
	Fri,  8 Dec 2023 19:09:28 +0000 (UTC)
From: Cleber Rosa <crosa@redhat.com>
To: qemu-devel@nongnu.org
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Paul Durrant <paul@xen.org>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Leif Lindholm <quic_llindhol@quicinc.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Beraldo Leal <bleal@redhat.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
	Cleber Rosa <crosa@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 03/10] tests/avocado/intel_iommu.py: increase timeout
Date: Fri,  8 Dec 2023 14:09:04 -0500
Message-ID: <20231208190911.102879-4-crosa@redhat.com>
In-Reply-To: <20231208190911.102879-1-crosa@redhat.com>
References: <20231208190911.102879-1-crosa@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Based on many runs, the average run time for these 4 tests is around
250 seconds, with 320 seconds being the ceiling.  In any way, the
default 120 seconds timeout is inappropriate in my experience.

Let's increase the timeout so these tests get a chance to completion.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/intel_iommu.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/avocado/intel_iommu.py b/tests/avocado/intel_iommu.py
index f04ee1cf9d..24bfad0756 100644
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
2.43.0


