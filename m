Return-Path: <kvm+bounces-23419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56F7D9496E1
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:33:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12F4A2868F6
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 491687346F;
	Tue,  6 Aug 2024 17:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iDGoy/k7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97534D9FE
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 17:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722965583; cv=none; b=eympQ7J6DnUFL0lWWijPkKdYYK5EetlDW5QSANPf2D2X3zSBEW9xpqB4HjCByDb0wz2pxAw7H1M9tYCkF59sxunM+6iHH/4veGtpIiw63f1mGRnxhRkvSoTBHO5vB8gUH/NQqxJX7jLM5jiBpqtfvZq2xmQheY+puvWhVabm5Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722965583; c=relaxed/simple;
	bh=k31f73xLdPxzX1A1daff9oOyY3w8/pU4WG8XseWt+ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tp6acfDRNAGXDyfDzlNemEea5GN71o3kz3j0oB9wAO76XDFx0U7WGZeQfEizWpZUh+9AuM1TPa3GOwbN8rzWbD7B/igOVtygLi5R/OvUmqUvDsf1HpfMjbQ9aVAhY2TVhe3xV+wSdjtMu7+1cx8y9N8f83nlnsV2UPJTsZe0AFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iDGoy/k7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722965580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/43rvxiHluDKPSD2ULvPBKTQ4qhQty2OCaQvduh/gz8=;
	b=iDGoy/k7iKj/XqthrNxrmnAC5lNSK4gQ8qjNaL6titvDoaPDJ/l9mcm+LuXDAECHvE5dFK
	HUql15dfJ9oCD0MNKQVO+SvJH9tZgen1LXXZk9FY7KQoJz9LEPSRHNjQJSUIhiddQGq5cG
	TnZH928x2rWxisGDJlrqhGeYizUd5TI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-PKl5JxhrOmm8bMkomHdUyg-1; Tue,
 06 Aug 2024 13:32:59 -0400
X-MC-Unique: PKl5JxhrOmm8bMkomHdUyg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E0DA1955F0D;
	Tue,  6 Aug 2024 17:32:56 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.39.192.15])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7EB91956046;
	Tue,  6 Aug 2024 17:32:46 +0000 (UTC)
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
Subject: [PATCH v2 7/9] tests/avocado/tuxrun_baselines.py: use Avocado's zstd support
Date: Tue,  6 Aug 2024 13:31:17 -0400
Message-ID: <20240806173119.582857-8-crosa@redhat.com>
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

This makes use of the avocado.utils.archive support for zstd.

In order to not duplicate code, the skip condition uses a private
utility from the module which is going to become public in Avocado
versions 103.1 LTS (and also in versions >= 107.0).

Reference: https://github.com/avocado-framework/avocado/pull/5996
Reference: https://github.com/avocado-framework/avocado/pull/5953
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


