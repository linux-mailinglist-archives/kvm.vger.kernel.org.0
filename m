Return-Path: <kvm+bounces-22321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 632B193D478
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 15:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 877931C236E8
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 13:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 902461E533;
	Fri, 26 Jul 2024 13:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ONG+W+4+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA1C1E536
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 13:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722001530; cv=none; b=S/7X2PgitPzXCTE37K3cyUcnHOhXNCVIdRKn9j7gxks/7tmrOFGP8DJIoXq9IW//fUF851hsdGXRRAM3Rk/SRdO2MU5g/L9K0b1uNqpL8+OZ4YnjkVg9w4x5cRh/icNRpNxTe+mUb6HyjzhshVqVPlVq/nFWTKwPzuK/Rz8e5Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722001530; c=relaxed/simple;
	bh=YUNzxDPTLigm1IS75kbC8tV0dctEwU3smncbGQXiBeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDUG0E+m2jSIAM6xp3FBHZ+C0PJoVWUlhb5IqFqOhy9pu3O6Y2Z3f74zjQUap6BTqqPGpM2mOnIsiqi3wXohVeu/Yq4R3HmWCqGluxW+3ot2EzDgOY2O3jjEW4gXBlQQZg6Mga/K76Djb2QMDykW/5QD1XHSdM2JpTLdG6cvXqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ONG+W+4+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722001528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iANeBO6ReZ4SXr/ZZKfmq7nYRFwkGFSuGPP72ITezII=;
	b=ONG+W+4+3jPyudFONeVwmTPSooQTMZ9o8dbUnbyAoaWFhaebikWEjoX6SlpK9jTmtkAKCF
	McV1PA+2quO1htWovU/TdYCVVgw510OhiYnmSQ+GRCC23JGbHcEiOt2XqTIRGcCBjv6Rxw
	fBzUfXBLLjR5eOWAQS4VVla+NC80+GU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-336-YaN_GngSPvyKyKgwQTcq-w-1; Fri,
 26 Jul 2024 09:45:23 -0400
X-MC-Unique: YaN_GngSPvyKyKgwQTcq-w-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEAF81955BFA;
	Fri, 26 Jul 2024 13:45:20 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.22.17.77])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D164F1955D45;
	Fri, 26 Jul 2024 13:45:16 +0000 (UTC)
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
Subject: [PATCH 07/13] tests/avocado/kvm_xen_guest.py: cope with asset RW requirements
Date: Fri, 26 Jul 2024 09:44:32 -0400
Message-ID: <20240726134438.14720-8-crosa@redhat.com>
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

Some of these tests actually require the root filesystem image,
obtained through Avocado's asset feature and kept in a common cache
location, to be writable.

This makes a distinction between the tests that actually have this
requirement and those who don't.  The goal is to be as safe as
possible, avoiding causing cache misses (because the assets get
modified and thus need to be dowloaded again) while avoid copying the
root filesystem backing file whenever possible.

This also allow these tests to be run in parallel with newer Avocado
versions.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/kvm_xen_guest.py | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest.py
index 318fadebc3..d73fa888ef 100644
--- a/tests/avocado/kvm_xen_guest.py
+++ b/tests/avocado/kvm_xen_guest.py
@@ -10,6 +10,7 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
 import os
+import shutil
 
 from qemu.machine import machine
 
@@ -43,7 +44,7 @@ def get_asset(self, name, sha1):
         return self.fetch_asset(name=f"qemu-kvm-xen-guest-{name}",
                                 locations=(url), asset_hash=sha1)
 
-    def common_vm_setup(self):
+    def common_vm_setup(self, readwrite=False):
         # We also catch lack of KVM_XEN support if we fail to launch
         self.require_accelerator("kvm")
 
@@ -56,11 +57,19 @@ def common_vm_setup(self):
                                           "367962983d0d32109998a70b45dcee4672d0b045")
         self.rootfs = self.get_asset("rootfs.ext4",
                                      "f1478401ea4b3fa2ea196396be44315bab2bb5e4")
+        if readwrite:
+            dest = os.path.join(self.workdir, os.path.basename(self.rootfs))
+            shutil.copy(self.rootfs, dest)
+            self.rootfs = dest
 
-    def run_and_check(self):
+    def run_and_check(self, readwrite=False):
+        if readwrite:
+            drive = f"file={self.rootfs},if=none,format=raw,id=drv0"
+        else:
+            drive = f"file={self.rootfs},if=none,readonly=on,format=raw,id=drv0"
         self.vm.add_args('-kernel', self.kernel_path,
                          '-append', self.kernel_params,
-                         '-drive',  f"file={self.rootfs},if=none,snapshot=on,format=raw,id=drv0",
+                         '-drive',  drive,
                          '-device', 'xen-disk,drive=drv0,vdev=xvda',
                          '-device', 'virtio-net-pci,netdev=unet',
                          '-netdev', 'user,id=unet,hostfwd=:127.0.0.1:0-:22')
@@ -90,11 +99,11 @@ def test_kvm_xen_guest(self):
         :avocado: tags=kvm_xen_guest
         """
 
-        self.common_vm_setup()
+        self.common_vm_setup(True)
 
         self.kernel_params = (self.KERNEL_DEFAULT +
                               ' xen_emul_unplug=ide-disks')
-        self.run_and_check()
+        self.run_and_check(True)
         self.ssh_command('grep xen-pirq.*msi /proc/interrupts')
 
     def test_kvm_xen_guest_nomsi(self):
@@ -102,11 +111,11 @@ def test_kvm_xen_guest_nomsi(self):
         :avocado: tags=kvm_xen_guest_nomsi
         """
 
-        self.common_vm_setup()
+        self.common_vm_setup(True)
 
         self.kernel_params = (self.KERNEL_DEFAULT +
                               ' xen_emul_unplug=ide-disks pci=nomsi')
-        self.run_and_check()
+        self.run_and_check(True)
         self.ssh_command('grep xen-pirq.* /proc/interrupts')
 
     def test_kvm_xen_guest_noapic_nomsi(self):
@@ -114,11 +123,11 @@ def test_kvm_xen_guest_noapic_nomsi(self):
         :avocado: tags=kvm_xen_guest_noapic_nomsi
         """
 
-        self.common_vm_setup()
+        self.common_vm_setup(True)
 
         self.kernel_params = (self.KERNEL_DEFAULT +
                               ' xen_emul_unplug=ide-disks noapic pci=nomsi')
-        self.run_and_check()
+        self.run_and_check(True)
         self.ssh_command('grep xen-pirq /proc/interrupts')
 
     def test_kvm_xen_guest_vapic(self):
-- 
2.45.2


