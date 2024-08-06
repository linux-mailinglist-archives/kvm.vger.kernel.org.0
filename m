Return-Path: <kvm+bounces-23418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 401AA9496E0
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:33:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 700F41C21278
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8F673451;
	Tue,  6 Aug 2024 17:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BBjSPEsE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD4629CE5
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 17:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722965581; cv=none; b=kiBkIpPA7nz4QpcUS7rKCPezOImn4NR5/bCkuttrTHLKRc2p1M82nV5+sqDMmT+h3KNANfWbDEiNC6YA7kjE4xlhqOAxOCfN6AOLwdxFnbr1SvQXdVeKda1yhGmlD50EEyDjkhEdI/2Omx9IX6dyA1QkGd0iNHuEllz3NsPVanU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722965581; c=relaxed/simple;
	bh=uOJJXadgsAZq3WmO2qAZQTeIcvR/iwwubszGqZNC0PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YA72qxRWXvyH1S6RAK5WUrtxSnMv3b4q2F6Hj6wb8TzkSoKv7HmGrivloW1ynpu1oYAtgFL1lFFnYsMX2LQHPTuoWUpNt9H6UftGkEANg85mMKXIlTouYSoQyWa0YrhrXmIoQR2DUtp4XeMXEObyZjGLxvIp+RUYMgv/CHGLIU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BBjSPEsE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722965579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SjcpbA2sD6CYVWhEq7nq8PpqkGiIsiq71NF+s5HMhDo=;
	b=BBjSPEsEp5W/wmu/sQ3+mREGl0C9S3r45dxWPKI72jUnWA499pjqGkQQBPGEslMdUi6Pxt
	WWOqSNxbTcWOOeZ5b5Ew8fsrXcOhDU/TMX4oACFim7Rv9HtLV14labUYVh6uImRlgIFLgQ
	TsyS+ypQGkEQyvVabeRbAfygwkxzTDA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-jdUwjjb2PYOdaJpWsbZVsg-1; Tue,
 06 Aug 2024 13:32:56 -0400
X-MC-Unique: jdUwjjb2PYOdaJpWsbZVsg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BE3B1955D48;
	Tue,  6 Aug 2024 17:32:46 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.39.192.15])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA23019560AE;
	Tue,  6 Aug 2024 17:32:36 +0000 (UTC)
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
Subject: [PATCH v2 6/9] tests/avocado/boot_xen.py: fetch kernel during test setUp()
Date: Tue,  6 Aug 2024 13:31:16 -0400
Message-ID: <20240806173119.582857-7-crosa@redhat.com>
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

The kernel is a common blob used in all tests.  By moving it to the
setUp() method, the "fetch asset" plugin will recognize the kernel and
attempt to fetch it and cache it before the tests are started.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/boot_xen.py | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tests/avocado/boot_xen.py b/tests/avocado/boot_xen.py
index f29bc58b9e..490a127a3e 100644
--- a/tests/avocado/boot_xen.py
+++ b/tests/avocado/boot_xen.py
@@ -30,23 +30,22 @@ class BootXen(LinuxKernelTest):
     timeout = 90
     XEN_COMMON_COMMAND_LINE = 'dom0_mem=128M loglvl=all guest_loglvl=all'
 
-    def fetch_guest_kernel(self):
+    def setUp(self):
+        super(BootXen, self).setUp()
+
         # Using my own built kernel - which works
         kernel_url = ('https://fileserver.linaro.org/'
                       's/JSsewXGZ6mqxPr5/download?path=%2F&files='
                       'linux-5.9.9-arm64-ajb')
         kernel_sha1 = '4f92bc4b9f88d5ab792fa7a43a68555d344e1b83'
-        kernel_path = self.fetch_asset(kernel_url,
-                                       asset_hash=kernel_sha1)
-
-        return kernel_path
+        self.kernel_path = self.fetch_asset(kernel_url,
+                                            asset_hash=kernel_sha1)
 
     def launch_xen(self, xen_path):
         """
         Launch Xen with a dom0 guest kernel
         """
         self.log.info("launch with xen_path: %s", xen_path)
-        kernel_path = self.fetch_guest_kernel()
 
         self.vm.set_console()
 
@@ -56,7 +55,7 @@ def launch_xen(self, xen_path):
                          '-append', self.XEN_COMMON_COMMAND_LINE,
                          '-device',
                          'guest-loader,addr=0x47000000,kernel=%s,bootargs=console=hvc0'
-                         % (kernel_path))
+                         % (self.kernel_path))
 
         self.vm.launch()
 
-- 
2.45.2


