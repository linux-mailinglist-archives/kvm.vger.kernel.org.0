Return-Path: <kvm+bounces-3959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE3880ACAD
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 20:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F83DB20D60
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C26951C48;
	Fri,  8 Dec 2023 19:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QAZR/DTt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C2610D
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 11:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702062591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AmGLkTWwFQFYqZRcdZPvYJBBBCt8tOcHxSrPZZ9IGpU=;
	b=QAZR/DTtWZyADNkWHtHcpl/GWJqGy5OKQ/B1P/rzFQTXv8EmJXMUPtkbF97Tveus70cnb8
	8He+RMbXcptjmkxPS2AHbsR7lKakdHMlyQ27s2SkX6N/TAaDHZaaWbXLhWmpaCr+ZAeNYG
	PLNPtsd6cS8yw1yshhg1lsNbHvMxZ3s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-BBdazSDrOnOS10C4y7b7oQ-1; Fri, 08 Dec 2023 14:09:45 -0500
X-MC-Unique: BBdazSDrOnOS10C4y7b7oQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76559102F220;
	Fri,  8 Dec 2023 19:09:44 +0000 (UTC)
Received: from p1.localdomain.com (ovpn-114-104.gru2.redhat.com [10.97.114.104])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7169B111E404;
	Fri,  8 Dec 2023 19:09:41 +0000 (UTC)
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
Subject: [PATCH 07/10] testa/avocado: test_arm_emcraft_sf2: handle RW requirements for asset
Date: Fri,  8 Dec 2023 14:09:08 -0500
Message-ID: <20231208190911.102879-8-crosa@redhat.com>
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

The asset used in the mentioned test gets truncated before it's used
in the test.  This means that the file gets modified, and thus the
asset's expected hash doesn't match anymore.  This causes cache misses
and re-downloads every time the test is re-run.

Let's make a copy of the asset so that the one in the cache is
preserved and the cache sees a hit on re-runs.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/boot_linux_console.py | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tests/avocado/boot_linux_console.py b/tests/avocado/boot_linux_console.py
index f5c5d647a4..e2e928e703 100644
--- a/tests/avocado/boot_linux_console.py
+++ b/tests/avocado/boot_linux_console.py
@@ -414,14 +414,16 @@ def test_arm_emcraft_sf2(self):
                    'fe371d32e50ca682391e1e70ab98c2942aeffb01/spi.bin')
         spi_hash = '65523a1835949b6f4553be96dec1b6a38fb05501'
         spi_path = self.fetch_asset(spi_url, asset_hash=spi_hash)
+        spi_path_rw = os.path.join(self.workdir, os.path.basename(spi_path))
+        shutil.copy(spi_path, spi_path_rw)
 
-        file_truncate(spi_path, 16 << 20) # Spansion S25FL128SDPBHICO is 16 MiB
+        file_truncate(spi_path_rw, 16 << 20) # Spansion S25FL128SDPBHICO is 16 MiB
 
         self.vm.set_console()
         kernel_command_line = self.KERNEL_COMMON_COMMAND_LINE
         self.vm.add_args('-kernel', uboot_path,
                          '-append', kernel_command_line,
-                         '-drive', 'file=' + spi_path + ',if=mtd,format=raw',
+                         '-drive', 'file=' + spi_path_rw + ',if=mtd,format=raw',
                          '-no-reboot')
         self.vm.launch()
         self.wait_for_console_pattern('Enter \'help\' for a list')
-- 
2.43.0


