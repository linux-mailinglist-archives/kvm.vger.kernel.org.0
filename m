Return-Path: <kvm+bounces-3957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00D1180ACAB
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 20:10:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31B211C20AB0
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7CA4F5F9;
	Fri,  8 Dec 2023 19:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ai4qAgzN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2529E10DA
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 11:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702062586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TtGy8l+fgmdQS+kFDaMnC380yWtdx1MWMjnafi+N5hE=;
	b=ai4qAgzNOxFLHeojsWVRx3Qci+Rb23fqpe2QFlvO3rvRDojjOZo+atNI1+GsV1xmqs7FT4
	jG0hRt0hEtSPg6Pm7nM2555wedmlCS1/0NX1ItMX3Qfl4oLriawIor74WfSVcm/f2HfnKb
	rwlgNC63Bty/Pkp+MMQFIXv9nWQ6LJs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-NG8nsRIfMeOT9mJg1nEguw-1; Fri, 08 Dec 2023 14:09:41 -0500
X-MC-Unique: NG8nsRIfMeOT9mJg1nEguw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 271FE185A784;
	Fri,  8 Dec 2023 19:09:41 +0000 (UTC)
Received: from p1.localdomain.com (ovpn-114-104.gru2.redhat.com [10.97.114.104])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22DAB112131D;
	Fri,  8 Dec 2023 19:09:37 +0000 (UTC)
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
Subject: [PATCH 06/10] tests/avocado/kvm_xen_guest.py: cope with asset RW requirements
Date: Fri,  8 Dec 2023 14:09:07 -0500
Message-ID: <20231208190911.102879-7-crosa@redhat.com>
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
index ec4052a1fe..d73fa888ef 100644
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
-                         '-drive',  f"file={self.rootfs},if=none,format=raw,id=drv0",
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
2.43.0


