Return-Path: <kvm+bounces-22318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BB3F93D475
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 15:45:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56D16286D9E
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 13:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CE8E17BB31;
	Fri, 26 Jul 2024 13:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IO57rz/L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EBF17B4FF
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 13:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722001514; cv=none; b=W9t0Od0IvyiCaMZgQFU1wyOD5icUHjPJ/NbOv7LrXLDRscpAUCuK6AHdtyQe6NogK4Ut6CVu0/Vi4udlMDWPY5t0ShHHZa2dDJCwwSwRmHDtCobBBWLD9ZCvmL63UVVObbizQsRL96FLBtcTykrB3CeSKoc6ZS3g9blVDPza7JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722001514; c=relaxed/simple;
	bh=1zX2K2QJLCXIFYCEQbFOJq6h9l4RjEhyqg+jefGa8KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFB2lzHCEGOlLWbpdmut56GV381gyLRO5XFyF36RL+5vnOUf90TDb4XimqQ1OaWBJzihey4NQBsudt4fTPITNbkb/uyAg+67TYBHpYt4rAYj3q8gXzWaP4Z2y++Nmm2ynxcji7FDzfTGys/wcGKQsgk6tNm4ZobhlVf+raoqKtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IO57rz/L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722001511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=osLPoiTFxmzb7yDc5D1S/zDpmyUMFotz0CS6WEgfGpM=;
	b=IO57rz/LPyiIaP+fyI+jk0mSl9nSyGFB0nZFzvJRtEHc5WFmr0d8USwHVpBchoNU4daPlb
	iGIhD6myvgpmVqVHn9oJ96kLRzhouPIALuOyp7EF6whu63zKtwuMx1599X98ARCcasGS+3
	gJwi/j1qEPHrH7OwpeWxIasVBFC2dQs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-149-3RQj_R13N2mlf7KIO6P6CQ-1; Fri,
 26 Jul 2024 09:45:10 -0400
X-MC-Unique: 3RQj_R13N2mlf7KIO6P6CQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04B251944A95;
	Fri, 26 Jul 2024 13:45:08 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.22.17.77])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B9EB1955D45;
	Fri, 26 Jul 2024 13:45:03 +0000 (UTC)
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
Subject: [PATCH 04/13] tests/avocado: add cdrom permission related tests
Date: Fri, 26 Jul 2024 09:44:29 -0400
Message-ID: <20240726134438.14720-5-crosa@redhat.com>
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


