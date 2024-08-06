Return-Path: <kvm+bounces-23414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6072B9496D8
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:32:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82F6C1C226CD
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 541FF535D4;
	Tue,  6 Aug 2024 17:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cvBcIExn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9AD481B7
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 17:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722965535; cv=none; b=ht4lHN+TNFiQcgVAci0lN2JCKBpSrLTmTQVcdvsVh9EaopvX1d8si8f0sEEIWgDzjQEa6U0XPmCxwSf8poa9V3caMW1W3oRu1rdk2xR55VJHEn4KzRjLK7ZdFLEPp6Qg86mTqeFJSVMdeh8DqdqXefCUkSiML9AQ9BQ///TRNaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722965535; c=relaxed/simple;
	bh=H9DpM7EtYX7HeZKPbEoYHYVCDUyFErhc576f86uLpgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+9cZY4WXtc9IU5EZeypZcsilyWH74YvtkTTfO9HeJvhYQQwrkp7o4LY/m98icFMMuDO33wepkiTPq5njaRuDftOfl2hY2zLp8rUK3+nAqdktyEyPidWAngdQ9mk9URiuWGpihEHepzrEInozIoiTm8n3h9I788/Za7iJwFCd54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cvBcIExn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722965532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/GXQbUC+egQPtXlpcMkSOyDnU1wegvQLfhRmhDNQso=;
	b=cvBcIExnHBO9QaancAk2jTyQH+v1B3Pk2hW8y3sI/X4dw0sYMjeKM7hlI+w4N//nPUuoTo
	Uv2nOuLz451hZ6FA1XSpsHh/Lb+e0FImK1Xy/n7KkB1i6xZXOeBEPZ91P6UGc6iFvToqLr
	W2kmq0GWU1Ik+eCg57X+Kb9rOZOBOOc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-qFtQ_wqSOQOYfMZtDARYNA-1; Tue,
 06 Aug 2024 13:32:08 -0400
X-MC-Unique: qFtQ_wqSOQOYfMZtDARYNA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4783E1955BEF;
	Tue,  6 Aug 2024 17:32:04 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.39.192.15])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E2C8F1956046;
	Tue,  6 Aug 2024 17:31:49 +0000 (UTC)
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
Subject: [PATCH v2 2/9] tests/avocado: apply proper skipUnless decorator
Date: Tue,  6 Aug 2024 13:31:12 -0400
Message-ID: <20240806173119.582857-3-crosa@redhat.com>
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

Commit 9b45cc993 added many cases of skipUnless for the sake of
organizing flaky tests.  But, Python decorators *must* follow what
they decorate, so the newlines added should *not* exist there.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/boot_linux_console.py | 1 -
 tests/avocado/intel_iommu.py        | 1 -
 tests/avocado/linux_initrd.py       | 1 -
 tests/avocado/machine_aspeed.py     | 2 --
 tests/avocado/machine_mips_malta.py | 2 --
 tests/avocado/machine_rx_gdbsim.py  | 2 --
 tests/avocado/reverse_debugging.py  | 4 ----
 tests/avocado/smmu.py               | 1 -
 8 files changed, 14 deletions(-)

diff --git a/tests/avocado/boot_linux_console.py b/tests/avocado/boot_linux_console.py
index 2929aa042d..cffdd6b5a2 100644
--- a/tests/avocado/boot_linux_console.py
+++ b/tests/avocado/boot_linux_console.py
@@ -1522,7 +1522,6 @@ def test_ppc_mac99(self):
     # like issues with a buggy kernel. As a result we don't want it
     # gating releases on Gitlab.
     @skipUnless(os.getenv('QEMU_TEST_FLAKY_TESTS'), 'Test is unstable on GitLab')
-
     def test_sh4_r2d(self):
         """
         :avocado: tags=arch:sh4
diff --git a/tests/avocado/intel_iommu.py b/tests/avocado/intel_iommu.py
index 008f214397..992583fa7d 100644
--- a/tests/avocado/intel_iommu.py
+++ b/tests/avocado/intel_iommu.py
@@ -13,7 +13,6 @@
 from avocado_qemu.linuxtest import LinuxTest
 
 @skipUnless(os.getenv('QEMU_TEST_FLAKY_TESTS'), 'Test is unstable on GitLab')
-
 class IntelIOMMU(LinuxTest):
     """
     :avocado: tags=arch:x86_64
diff --git a/tests/avocado/linux_initrd.py b/tests/avocado/linux_initrd.py
index aad5b19bd9..7f47b98ae7 100644
--- a/tests/avocado/linux_initrd.py
+++ b/tests/avocado/linux_initrd.py
@@ -54,7 +54,6 @@ def test_with_2gib_file_should_exit_error_msg_with_linux_v3_6(self):
             self.assertRegex(self.vm.get_log(), expected_msg)
 
     @skipUnless(os.getenv('QEMU_TEST_FLAKY_TESTS'), 'Test is unstable on GitLab')
-
     def test_with_2gib_file_should_work_with_linux_v4_16(self):
         """
         :avocado: tags=flaky
diff --git a/tests/avocado/machine_aspeed.py b/tests/avocado/machine_aspeed.py
index f8e263d37e..c0b01e8f1f 100644
--- a/tests/avocado/machine_aspeed.py
+++ b/tests/avocado/machine_aspeed.py
@@ -323,7 +323,6 @@ def do_test_aarch64_aspeed_sdk_start(self, image):
         self.wait_for_console_pattern('Starting kernel ...')
 
     @skipUnless(os.getenv('QEMU_TEST_FLAKY_TESTS'), 'Test is unstable on GitLab')
-
     def test_arm_ast2500_evb_sdk(self):
         """
         :avocado: tags=arch:arm
@@ -343,7 +342,6 @@ def test_arm_ast2500_evb_sdk(self):
         self.wait_for_console_pattern('nodistro.0 ast2500-default ttyS4')
 
     @skipUnless(os.getenv('QEMU_TEST_FLAKY_TESTS'), 'Test is unstable on GitLab')
-
     def test_arm_ast2600_evb_sdk(self):
         """
         :avocado: tags=arch:arm
diff --git a/tests/avocado/machine_mips_malta.py b/tests/avocado/machine_mips_malta.py
index 8cf84bd805..07a80633b5 100644
--- a/tests/avocado/machine_mips_malta.py
+++ b/tests/avocado/machine_mips_malta.py
@@ -102,7 +102,6 @@ def test_mips_malta_i6400_framebuffer_logo_1core(self):
         self.do_test_i6400_framebuffer_logo(1)
 
     @skipUnless(os.getenv('QEMU_TEST_FLAKY_TESTS'), 'Test is unstable on GitLab')
-
     def test_mips_malta_i6400_framebuffer_logo_7cores(self):
         """
         :avocado: tags=arch:mips64el
@@ -114,7 +113,6 @@ def test_mips_malta_i6400_framebuffer_logo_7cores(self):
         self.do_test_i6400_framebuffer_logo(7)
 
     @skipUnless(os.getenv('QEMU_TEST_FLAKY_TESTS'), 'Test is unstable on GitLab')
-
     def test_mips_malta_i6400_framebuffer_logo_8cores(self):
         """
         :avocado: tags=arch:mips64el
diff --git a/tests/avocado/machine_rx_gdbsim.py b/tests/avocado/machine_rx_gdbsim.py
index 412a7a5089..72f0296e21 100644
--- a/tests/avocado/machine_rx_gdbsim.py
+++ b/tests/avocado/machine_rx_gdbsim.py
@@ -23,7 +23,6 @@ class RxGdbSimMachine(QemuSystemTest):
     KERNEL_COMMON_COMMAND_LINE = 'printk.time=0 '
 
     @skipUnless(os.getenv('QEMU_TEST_FLAKY_TESTS'), 'Test is unstable on GitLab')
-
     def test_uboot(self):
         """
         U-Boot and checks that the console is operational.
@@ -49,7 +48,6 @@ def test_uboot(self):
         #exec_command_and_wait_for_pattern(self, 'version', gcc_version)
 
     @skipUnless(os.getenv('QEMU_TEST_FLAKY_TESTS'), 'Test is unstable on GitLab')
-
     def test_linux_sash(self):
         """
         Boots a Linux kernel and checks that the console is operational.
diff --git a/tests/avocado/reverse_debugging.py b/tests/avocado/reverse_debugging.py
index 92855a02a5..f24287cd0a 100644
--- a/tests/avocado/reverse_debugging.py
+++ b/tests/avocado/reverse_debugging.py
@@ -207,7 +207,6 @@ def get_pc(self, g):
 
     # unidentified gitlab timeout problem
     @skipUnless(os.getenv('QEMU_TEST_FLAKY_TESTS'), 'Test is unstable on GitLab')
-
     def test_x86_64_pc(self):
         """
         :avocado: tags=arch:x86_64
@@ -225,7 +224,6 @@ class ReverseDebugging_AArch64(ReverseDebugging):
 
     # unidentified gitlab timeout problem
     @skipUnless(os.getenv('QEMU_TEST_FLAKY_TESTS'), 'Test is unstable on GitLab')
-
     def test_aarch64_virt(self):
         """
         :avocado: tags=arch:aarch64
@@ -250,7 +248,6 @@ class ReverseDebugging_ppc64(ReverseDebugging):
 
     # unidentified gitlab timeout problem
     @skipUnless(os.getenv('QEMU_TEST_FLAKY_TESTS'), 'Test is unstable on GitLab')
-
     def test_ppc64_pseries(self):
         """
         :avocado: tags=arch:ppc64
@@ -265,7 +262,6 @@ def test_ppc64_pseries(self):
 
     # See https://gitlab.com/qemu-project/qemu/-/issues/1992
     @skipUnless(os.getenv('QEMU_TEST_FLAKY_TESTS'), 'Test is unstable on GitLab')
-
     def test_ppc64_powernv(self):
         """
         :avocado: tags=arch:ppc64
diff --git a/tests/avocado/smmu.py b/tests/avocado/smmu.py
index aadda71e4b..83fd79e922 100644
--- a/tests/avocado/smmu.py
+++ b/tests/avocado/smmu.py
@@ -14,7 +14,6 @@
 from avocado_qemu.linuxtest import LinuxTest
 
 @skipUnless(os.getenv('QEMU_TEST_FLAKY_TESTS'), 'Test is unstable on GitLab')
-
 class SMMU(LinuxTest):
     """
     :avocado: tags=accel:kvm
-- 
2.45.2


