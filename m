Return-Path: <kvm+bounces-22316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21FFC93D473
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 15:45:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 537291C20A15
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 13:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94B321E86A;
	Fri, 26 Jul 2024 13:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ry3oicW7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A83B17C20D
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 13:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722001505; cv=none; b=gXEZnmt6vxjYuhJZXJayH2AQxli6UDw/+wPrhZewaW3uUOd9YOqyfN8Z1OVNeT5Nv5WEJcyumhGqhrTcsGEX9ZPZ3A2AiDbH4IUm1nAp2TH31noW/t65a4C+S0TLfhSQhzW0RT7bsyfGRQamL/zbaeox5KIb5t1S8Th+ZUBO4zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722001505; c=relaxed/simple;
	bh=pm53+ti9b2oNDi+nfcUMmvnbmv9j2wIaBUWaeeJgWOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUOAT4pHOkD5WOhMIIk/eYQRkZb5J2ZxI5QPLCSblwKshdiAf0BNcfoJeDJxvwLiFnCP2rxslbAfpzK/6XjIYX7HmQriio96cGygTohTeswLQATYorU7/S/nR2jzCFzAz98RCXgv1dBar8Os8hRBpm7+YBduSxsTe3C20W6AK9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ry3oicW7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722001503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RKmLOo511M5++BDmKAMU+H3V3j7+sw7OERXfgONtCK4=;
	b=Ry3oicW7vetjljsQ/cjGtPCFYktnkueJZZScStEjDpL+n9s++GVE9jjd9p7MtnAcOPtBPj
	fl96C4teSvHLVv5Tr+VW9BipVrVN9goCvZS+bVH6OJESX/zQ+g3Jp7ekK8QgH9Mnj5QuVV
	HtAhZ8znVHf0UjFn9W1umeCMM7TDEUY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-372-QtkdACIBPma6-WCXhF2TOg-1; Fri,
 26 Jul 2024 09:45:00 -0400
X-MC-Unique: QtkdACIBPma6-WCXhF2TOg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E48F21955D53;
	Fri, 26 Jul 2024 13:44:57 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.22.17.77])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E6F51955D4A;
	Fri, 26 Jul 2024 13:44:52 +0000 (UTC)
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
Subject: [PATCH 02/13] tests/avocado: mips: add hint for fetchasset plugin
Date: Fri, 26 Jul 2024 09:44:27 -0400
Message-ID: <20240726134438.14720-3-crosa@redhat.com>
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

Avocado's fetchasset plugin runs before the actual Avocado job (and
any test).  It analyses the test's code looking for occurrences of
"self.fetch_asset()" in the either the actual test or setUp() method.
It's not able to fully analyze all code, though.

The way these tests are written, make the fetchasset plugin blind to
the assets.  This adds some more code duplication, true, but it will
aid the fetchasset plugin to download or verify the existence of these
assets in advance.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/boot_linux_console.py | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tests/avocado/boot_linux_console.py b/tests/avocado/boot_linux_console.py
index 450d67be6a..b8b0a4df10 100644
--- a/tests/avocado/boot_linux_console.py
+++ b/tests/avocado/boot_linux_console.py
@@ -274,8 +274,7 @@ def test_mips64el_malta_5KEc_cpio(self):
         # Wait for VM to shut down gracefully
         self.vm.wait()
 
-    def do_test_mips_malta32el_nanomips(self, kernel_url, kernel_hash):
-        kernel_path_xz = self.fetch_asset(kernel_url, asset_hash=kernel_hash)
+    def do_test_mips_malta32el_nanomips(self, kernel_path_xz):
         kernel_path = self.workdir + "kernel"
         with lzma.open(kernel_path_xz, 'rb') as f_in:
             with open(kernel_path, 'wb') as f_out:
@@ -303,7 +302,8 @@ def test_mips_malta32el_nanomips_4k(self):
                       'kernels/v4.15.18-432-gb2eb9a8b07a1-20180627102142/'
                       'generic_nano32r6el_page4k.xz')
         kernel_hash = '477456aafd2a0f1ddc9482727f20fe9575565dd6'
-        self.do_test_mips_malta32el_nanomips(kernel_url, kernel_hash)
+        kernel_path_xz = self.fetch_asset(kernel_url, asset_hash=kernel_hash)
+        self.do_test_mips_malta32el_nanomips(kernel_path_xz)
 
     def test_mips_malta32el_nanomips_16k_up(self):
         """
@@ -316,7 +316,8 @@ def test_mips_malta32el_nanomips_16k_up(self):
                       'kernels/v4.15.18-432-gb2eb9a8b07a1-20180627102142/'
                       'generic_nano32r6el_page16k_up.xz')
         kernel_hash = 'e882868f944c71c816e832e2303b7874d044a7bc'
-        self.do_test_mips_malta32el_nanomips(kernel_url, kernel_hash)
+        kernel_path_xz = self.fetch_asset(kernel_url, asset_hash=kernel_hash)
+        self.do_test_mips_malta32el_nanomips(kernel_path_xz)
 
     def test_mips_malta32el_nanomips_64k_dbg(self):
         """
@@ -329,7 +330,8 @@ def test_mips_malta32el_nanomips_64k_dbg(self):
                       'kernels/v4.15.18-432-gb2eb9a8b07a1-20180627102142/'
                       'generic_nano32r6el_page64k_dbg.xz')
         kernel_hash = '18d1c68f2e23429e266ca39ba5349ccd0aeb7180'
-        self.do_test_mips_malta32el_nanomips(kernel_url, kernel_hash)
+        kernel_path_xz = self.fetch_asset(kernel_url, asset_hash=kernel_hash)
+        self.do_test_mips_malta32el_nanomips(kernel_path_xz)
 
     def test_aarch64_xlnx_versal_virt(self):
         """
-- 
2.45.2


