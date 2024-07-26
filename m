Return-Path: <kvm+bounces-22319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDFCE93D476
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 15:45:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B9541C230EF
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 13:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E0F71E536;
	Fri, 26 Jul 2024 13:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I1zFoCAg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A42D1E4B0
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 13:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722001520; cv=none; b=PEiQg/zyFEbRBjPVzQMvuzOBzxh0ikmnB76MGsykjGQYcVrXxChTpNrs97Cr82trW0FXjdC/l9BrDFsUn5sdDeSvxsT5jiIG01PyO+/h7p+ncgIfS7HEKrxZWfmdHKdIckU7ZXWtL0OISy9P516V3wU8FL3ZnU8w4hRf+CW9nBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722001520; c=relaxed/simple;
	bh=97b8YgaveA4LK6HRs7GsLX007P7pXU7xzg3hfb3Ho/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXDdJdUceT0N7RsgFmZA4sB2jdCi/XDF0n1BVAA+Bp24IV9qkLJBpymVxBoCF6iCFNiacL8fKU5JaKP4dEV2P2dugsNPy43Rk9hxj2DxB38J8Myo3GmjoT1abjjofPO86D67dvi1wLvxJDrJKnZEzNmTOTYJYNwM7K6c+7jVCRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I1zFoCAg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722001518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WtaWhlmHpoy33xPksIjdi5YUZQGPJj68+Jp6A9OldAg=;
	b=I1zFoCAgIzHok5VIZGoBh+WRRG6IoWDvbEoEr8ock63JIiay6C5G5mQuWPgp3ZxZGEtTrw
	gvcYpn98AyvOgMQvX9WEqNsnh3Yq02o3yYOtP88qlacZwMGW/wpC5UHRLMvFi0kaa6e75W
	sJknY7X7fbwAGvCo8l2rg2k51bP2D34=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-223-GsuuMM2uP7WZa0qYNGJc5w-1; Fri,
 26 Jul 2024 09:45:14 -0400
X-MC-Unique: GsuuMM2uP7WZa0qYNGJc5w-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A2DB31955BFA;
	Fri, 26 Jul 2024 13:45:12 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.22.17.77])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 708501955D48;
	Fri, 26 Jul 2024 13:45:08 +0000 (UTC)
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
Subject: [PATCH 05/13] tests/avocado: machine aarch64: standardize location and RO access
Date: Fri, 26 Jul 2024 09:44:30 -0400
Message-ID: <20240726134438.14720-6-crosa@redhat.com>
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

The tests under machine_aarch64_virt.py and machine_aarch64_sbsaref.py
should not be writing to the ISO files.  By adding "media=cdrom" the
"ro" is autmatically set.

While at it, let's use a single code style and hash for the ISO url.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/machine_aarch64_sbsaref.py |  6 +++++-
 tests/avocado/machine_aarch64_virt.py    | 14 +++++++-------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/tests/avocado/machine_aarch64_sbsaref.py b/tests/avocado/machine_aarch64_sbsaref.py
index e920bbf08c..1275f24532 100644
--- a/tests/avocado/machine_aarch64_sbsaref.py
+++ b/tests/avocado/machine_aarch64_sbsaref.py
@@ -129,7 +129,11 @@ def boot_alpine_linux(self, cpu):
             "-cpu",
             cpu,
             "-drive",
-            f"file={iso_path},format=raw",
+            f"file={iso_path},media=cdrom,format=raw",
+            "-device",
+            "virtio-rng-pci,rng=rng0",
+            "-object",
+            "rng-random,id=rng0,filename=/dev/urandom",
         )
 
         self.vm.launch()
diff --git a/tests/avocado/machine_aarch64_virt.py b/tests/avocado/machine_aarch64_virt.py
index a90dc6ff4b..6831d2c0ed 100644
--- a/tests/avocado/machine_aarch64_virt.py
+++ b/tests/avocado/machine_aarch64_virt.py
@@ -37,13 +37,13 @@ def test_alpine_virt_tcg_gic_max(self):
         :avocado: tags=machine:virt
         :avocado: tags=accel:tcg
         """
-        iso_url = ('https://dl-cdn.alpinelinux.org/'
-                   'alpine/v3.17/releases/aarch64/'
-                   'alpine-standard-3.17.2-aarch64.iso')
+        iso_url = (
+            "https://dl-cdn.alpinelinux.org/"
+            "alpine/v3.17/releases/aarch64/alpine-standard-3.17.2-aarch64.iso"
+        )
 
-        # Alpine use sha256 so I recalculated this myself
-        iso_sha1 = '76284fcd7b41fe899b0c2375ceb8470803eea839'
-        iso_path = self.fetch_asset(iso_url, asset_hash=iso_sha1)
+        iso_hash = "5a36304ecf039292082d92b48152a9ec21009d3a62f459de623e19c4bd9dc027"
+        iso_path = self.fetch_asset(iso_url, algorithm="sha256", asset_hash=iso_hash)
 
         self.vm.set_console()
         kernel_command_line = (self.KERNEL_COMMON_COMMAND_LINE +
@@ -60,7 +60,7 @@ def test_alpine_virt_tcg_gic_max(self):
         self.vm.add_args("-smp", "2", "-m", "1024")
         self.vm.add_args('-bios', os.path.join(BUILD_DIR, 'pc-bios',
                                                'edk2-aarch64-code.fd'))
-        self.vm.add_args("-drive", f"file={iso_path},format=raw")
+        self.vm.add_args("-drive", f"file={iso_path},media=cdrom,format=raw")
         self.vm.add_args('-device', 'virtio-rng-pci,rng=rng0')
         self.vm.add_args('-object', 'rng-random,id=rng0,filename=/dev/urandom')
 
-- 
2.45.2


