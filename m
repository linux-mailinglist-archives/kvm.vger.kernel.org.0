Return-Path: <kvm+bounces-23415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AAFFB9496D9
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 551831F22910
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD2CB6F2E2;
	Tue,  6 Aug 2024 17:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V3W5UCpl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E07554BD4
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 17:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722965544; cv=none; b=p0pWNe3u0M/KazEyYxHCwBulct+N4ixT/smC6t33LhniI/znFswyQi/qeHAdeU4A3wB6Uuyl6BmJH/BmwLFg4Tx6tOOHc/WnRTTxd+FHI/Bjg7IiAxKG1rVLrzoYe3YfjINeEAJotoCd2GWmNCE2WE0RTga/EQqQpHnAk2vOaOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722965544; c=relaxed/simple;
	bh=ptCjm3ovv7r1KQq7eJlaiU2FhFTHUWJq7lzgmGoKJYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WT+9NtPxtWvdjZ7AXJ4gxWX7gUsjXdnGrWNUzPGZIgruEp38YcRu3P2nrLOufC1fGFM9gtwduYbDiFFDGwPH2Io4dNn8fGpXpDDpfKCW7pClscJ1MNEKFUhciHoxcq3nomN2xP6j94nSNjtwRq/WX9D4VDTqpzbeHJwD5Iv0AYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V3W5UCpl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722965541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nbyiJBKV1667Kt+ZajabFyIsW7lZeMVEfNzrj1/3epM=;
	b=V3W5UCplgf/h9H1w1kphSOZcPDOofRFqc0GKjKZfbOvqwcI47Yr3e4fUm6qZky5917/Q/s
	cGbwJR6nitwdfEqoHia9VghP3O+8gmE38n6AfEUZ6SATIl2+LfZXnTcmmMjQNtoJT9nHEq
	FRY/0nte9hWDX32eCvd0JUlObCt36fQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-S8N2O7wLOCCk9w6DrMGlUA-1; Tue,
 06 Aug 2024 13:32:18 -0400
X-MC-Unique: S8N2O7wLOCCk9w6DrMGlUA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E086C1955D53;
	Tue,  6 Aug 2024 17:32:13 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.39.192.15])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE04C19560AE;
	Tue,  6 Aug 2024 17:32:04 +0000 (UTC)
From: Cleber Rosa <crosa@redhat.com>
To: qemu-devel@nongnu.org
Cc: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
	Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Troy Lee <leetroy@gmail.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Beraldo Leal <bleal@redhat.com>,
	kvm@vger.kernel.org,
	Joel Stanley <joel@jms.id.au>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Paul Durrant <paul@xen.org>,
	Eric Auger <eric.auger@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	qemu-arm@nongnu.org,
	Cleber Rosa <crosa@redhat.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Jamin Lin <jamin_lin@aspeedtech.com>,
	Steven Lee <steven_lee@aspeedtech.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Leif Lindholm <quic_llindhol@quicinc.com>
Subject: [PATCH v2 3/9] tests/avocado: add cdrom permission related tests
Date: Tue,  6 Aug 2024 13:31:13 -0400
Message-ID: <20240806173119.582857-4-crosa@redhat.com>
In-Reply-To: <20240806173119.582857-1-crosa@redhat.com>
References: <20240806173119.582857-1-crosa@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The "media=cdrom" parameter is also used on some Avocado tests as a
way to protect files from being written.  The tests here bring a more
fundamental check that this behavior can be trusted.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/cdrom.py | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 tests/avocado/cdrom.py

diff --git a/tests/avocado/cdrom.py b/tests/avocado/cdrom.py
new file mode 100644
index 0000000000..c9aa5d69cb
--- /dev/null
+++ b/tests/avocado/cdrom.py
@@ -0,0 +1,41 @@
+# Simple functional tests for cdrom devices
+#
+# Copyright (c) 2023 Red Hat, Inc.
+#
+# Author:
+#  Cleber Rosa <crosa@redhat.com>
+#
+# This work is licensed under the terms of the GNU GPL, version 2 or
+# later.  See the COPYING file in the top-level directory.
+
+import os
+
+from avocado.utils.iso9660 import iso9660
+from avocado_qemu import QemuSystemTest
+
+
+class Cdrom(QemuSystemTest):
+    """
+    :avocado: tags=block,cdrom,quick
+    :avocado: tags=machine:none
+    """
+    def setUp(self):
+        super().setUp()
+        self.iso_path = os.path.join(self.workdir, "cdrom.iso")
+        iso = iso9660(self.iso_path)
+        iso.create()
+        iso.close()
+
+    def test_plain_iso_rw(self):
+        self.vm.add_args('-drive', f'file={self.iso_path}')
+        self.vm.launch()
+        query_block_result = self.vm.qmp('query-block')['return']
+        self.assertEqual(len(query_block_result), 1)
+        self.assertFalse(query_block_result[0]["inserted"]["ro"])
+
+    def test_media_cdrom_ro(self):
+        self.vm.add_args('-drive', f'file={self.iso_path},media=cdrom')
+        self.vm.launch()
+        query_block_result = self.vm.qmp('query-block')['return']
+        self.assertEqual(len(query_block_result), 1)
+        self.assertTrue(query_block_result[0]["inserted"]["ro"])
-- 
2.45.2


