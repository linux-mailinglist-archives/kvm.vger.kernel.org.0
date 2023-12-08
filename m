Return-Path: <kvm+bounces-3953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A9D880ACA7
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 20:09:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F66EB20C1C
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83ECD4CB27;
	Fri,  8 Dec 2023 19:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G3xKavsx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDE984
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 11:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702062573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HAQodLw6o39wfGU2+kKO3r3kXuqnKBwHuQCL8rcVZAo=;
	b=G3xKavsx8MJ3CAAQjMG5ZuUO9o9uWfWjQQQNQBh+AHRaRpUpFTamZUM7u4XldAjRJkwtL7
	i9YxIj9vsjkN2THpznD45f3oWzbYy6pQ4Fy7QvXX5e4IshG/hROaLpDBlE0jcFzASWXHtW
	tbAOKw9Ni6dlueYUF24DD1ysG7JV4e8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-st6o27ktOfGRsVq4m6Pwjw-1; Fri, 08 Dec 2023 14:09:28 -0500
X-MC-Unique: st6o27ktOfGRsVq4m6Pwjw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D73CE85A58A;
	Fri,  8 Dec 2023 19:09:27 +0000 (UTC)
Received: from p1.localdomain.com (ovpn-114-104.gru2.redhat.com [10.97.114.104])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D23BB112131D;
	Fri,  8 Dec 2023 19:09:24 +0000 (UTC)
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
Subject: [PATCH 02/10] tests/avocado: mips: add hint for fetchasset plugin
Date: Fri,  8 Dec 2023 14:09:03 -0500
Message-ID: <20231208190911.102879-3-crosa@redhat.com>
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

Avocado's fetchasset plugin runs before the actual Avocado job (and
any test).  It analyses the test's code looking for occurrences of
"self.fetch_asset()" in the either the actual test or setUp() method.
It's not able to fully analyze all code, though.

The way these tests are written, make the fetchasset plugin blind to
the assets.  This adds redundant code, true, but one that doesn't hurt
the test and aids the fetchasset plugin to download or verify the
existence of these assets in advance.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/boot_linux_console.py | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tests/avocado/boot_linux_console.py b/tests/avocado/boot_linux_console.py
index 8066861c17..f5c5d647a4 100644
--- a/tests/avocado/boot_linux_console.py
+++ b/tests/avocado/boot_linux_console.py
@@ -303,6 +303,11 @@ def test_mips_malta32el_nanomips_4k(self):
                       'kernels/v4.15.18-432-gb2eb9a8b07a1-20180627102142/'
                       'generic_nano32r6el_page4k.xz')
         kernel_hash = '477456aafd2a0f1ddc9482727f20fe9575565dd6'
+
+        # The following line is a no-op that aids the avocado
+        # fetchasset plugin that runs before any portion of the test
+        self.fetch_asset(kernel_url, asset_hash=kernel_hash)
+
         self.do_test_mips_malta32el_nanomips(kernel_url, kernel_hash)
 
     def test_mips_malta32el_nanomips_16k_up(self):
@@ -316,6 +321,11 @@ def test_mips_malta32el_nanomips_16k_up(self):
                       'kernels/v4.15.18-432-gb2eb9a8b07a1-20180627102142/'
                       'generic_nano32r6el_page16k_up.xz')
         kernel_hash = 'e882868f944c71c816e832e2303b7874d044a7bc'
+
+        # The following line is a no-op that aids the avocado
+        # fetchasset plugin that runs before any portion of the test
+        self.fetch_asset(kernel_url, asset_hash=kernel_hash)
+
         self.do_test_mips_malta32el_nanomips(kernel_url, kernel_hash)
 
     def test_mips_malta32el_nanomips_64k_dbg(self):
@@ -329,6 +339,11 @@ def test_mips_malta32el_nanomips_64k_dbg(self):
                       'kernels/v4.15.18-432-gb2eb9a8b07a1-20180627102142/'
                       'generic_nano32r6el_page64k_dbg.xz')
         kernel_hash = '18d1c68f2e23429e266ca39ba5349ccd0aeb7180'
+
+        # The following line is a no-op that aids the avocado
+        # fetchasset plugin that runs before any portion of the test
+        self.fetch_asset(kernel_url, asset_hash=kernel_hash)
+
         self.do_test_mips_malta32el_nanomips(kernel_url, kernel_hash)
 
     def test_aarch64_xlnx_versal_virt(self):
-- 
2.43.0


