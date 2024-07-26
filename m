Return-Path: <kvm+bounces-22324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 513D293D47B
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 15:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D37E61F248AB
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 13:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D7F51E87B;
	Fri, 26 Jul 2024 13:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NLqP+uGT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7811E51E
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 13:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722001546; cv=none; b=VctGllWKs4dO+bt/fdAEOcB5+NFaLe3QIKQawRBxLyPB4VNM4I5mmpSjG61Rm6wHgkimD7YG76cWFgTfmGBybI9M9cKGb2k8qXrjTWxvU/ANr/4Mj9+aBbcVCVDMyLh6yHXHFL81Vne2htO0+OtgBVca9g1iyzUJumcA905d3l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722001546; c=relaxed/simple;
	bh=DDzXYnuxAnF14vr6BSNq5PMlogVQicbxHLRVmxqLErg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuIAjdYS/0vfNSDdF0IN/mztQfd/poiK/EB2ayy6HA4HMpA18OGB2KjsmyXLRYCah6Cw9TQ+4PRIBwO1vDWJOgupmfsuaBocSoGoBnvcf9fH37A2B8MZ+cZPTIuQsGEDGqI8t8mUUqpD+Neim5O4Y2gssH/mTD1eS5hZjDDiWNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NLqP+uGT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722001544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Pp0EmgfUgef5CCbhzHhQ+sBuTsis6yWoLZCERPLAmQ=;
	b=NLqP+uGTwMbKS1KJczDznX1EVv9HPaSIPO3kYjYUAZ7vP1f4QPQ5IoyAv2gAWWLaX6+cce
	EGMsi7OBBr+SJV9mXS2Q5WepmYW4fkhwPCRny6bjmHjFyFAUGTwksU5auGCaxqSQCNz30j
	R94H8eI9vn/y9+g6y5lgXv26Goq+rV4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-113--MtupRyvNCOkAExirddxAA-1; Fri,
 26 Jul 2024 09:45:37 -0400
X-MC-Unique: -MtupRyvNCOkAExirddxAA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7FD191955D63;
	Fri, 26 Jul 2024 13:45:33 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.22.17.77])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 701441955D48;
	Fri, 26 Jul 2024 13:45:29 +0000 (UTC)
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
Subject: [PATCH 10/13] tests/avocado/tuxrun_baselines.py: use Avocado's zstd support
Date: Fri, 26 Jul 2024 09:44:35 -0400
Message-ID: <20240726134438.14720-11-crosa@redhat.com>
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
 tests/avocado/tuxrun_baselines.py | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/tests/avocado/tuxrun_baselines.py b/tests/avocado/tuxrun_baselines.py
index 736e4aa289..bd02e88ed6 100644
--- a/tests/avocado/tuxrun_baselines.py
+++ b/tests/avocado/tuxrun_baselines.py
@@ -17,6 +17,7 @@
 from avocado_qemu import QemuSystemTest
 from avocado_qemu import exec_command, exec_command_and_wait_for_pattern
 from avocado_qemu import wait_for_console_pattern
+from avocado.utils import archive
 from avocado.utils import process
 from avocado.utils.path import find_command
 
@@ -40,17 +41,12 @@ def get_tag(self, tagname, default=None):
 
         return default
 
+    @skipUnless(archive._probe_zstd_cmd(),
+                'Could not find "zstd", or it is not able to properly '
+                'decompress decompress the rootfs')
     def setUp(self):
         super().setUp()
 
-        # We need zstd for all the tuxrun tests
-        # See https://github.com/avocado-framework/avocado/issues/5609
-        zstd = find_command('zstd', False)
-        if zstd is False:
-            self.cancel('Could not find "zstd", which is required to '
-                        'decompress rootfs')
-        self.zstd = zstd
-
         # Process the TuxRun specific tags, most machines work with
         # reasonable defaults but we sometimes need to tweak the
         # config. To avoid open coding everything we store all these
@@ -99,8 +95,8 @@ def fetch_tuxrun_assets(self, csums=None, dt=None):
                                          asset_hash = isum,
                                          algorithm = "sha256")
 
-        cmd = f"{self.zstd} -d {disk_image_zst} -o {self.workdir}/rootfs.ext4"
-        process.run(cmd)
+        archive.extract(disk_image_zst, os.path.join(self.workdir,
+                                                     "rootfs.ext4"))
 
         if dt:
             dsum = csums.get(dt, None)
-- 
2.45.2


