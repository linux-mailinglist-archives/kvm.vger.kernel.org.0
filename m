Return-Path: <kvm+bounces-23416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFEA19496DB
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:32:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A94CE284C7D
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 718EE52F9B;
	Tue,  6 Aug 2024 17:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EacumavA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDF64AEF4
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 17:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722965555; cv=none; b=EaIJTSKisDAe50qs9Iz/kkTFi7rpGVEmXc4fJglWkhhHV1w7Z0lvoA6plvHMQS6+3JqaUfD3d/gj4FBzEpw5EXLIwOKCuRAg8mSoY1gExdERQQwoHsZ5PUE7412TMOAKDrIO90WTOgzCKpxr9iTwn26uF68XodcTqwn9kOBudBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722965555; c=relaxed/simple;
	bh=OhzYNbZPzGg77MDx/pheT2uHbetV90+v1AP9GbtrVtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+n8cvckuPR0cfA2wma2IJ+j7D1dVgngMd2+O7RMkaFD4lhna/5T5a0ifb04HvAS7qBiJhvdIxIJqK3ytwC+S/hNicAczXW/VRhJQdwwOaCKNyhWuOR/JoVVYDV108OWkwbf+a0AQzz/+mY9vE2DIqcCP3xNRTQAQxJVfm78hRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EacumavA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722965553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KL0H1z5/pg3dizYMSsFK6oSLNICej54wUK//KBAoyq8=;
	b=EacumavArqJQAHHLIAZVw/W0V/2RCdX+a+L73LJ51kTYeLe+amc0sbupXqzMOJ7dsdyc/R
	qakByiJtJ+Kzc39ist11KgWQ0h/5Qyscyg5jmLxzfpJ1rDTuJRnwZ4/TUXWDQUoznfBdts
	pLqeD542CC5eJaHL9qQ7RDrUosk3Mws=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-9eWeJM_pNJ6UG27hhqXTPg-1; Tue,
 06 Aug 2024 13:32:29 -0400
X-MC-Unique: 9eWeJM_pNJ6UG27hhqXTPg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76C5C1955BED;
	Tue,  6 Aug 2024 17:32:26 +0000 (UTC)
Received: from p1.localdomain.com (unknown [10.39.192.15])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B3E21956046;
	Tue,  6 Aug 2024 17:32:14 +0000 (UTC)
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
Subject: [PATCH v2 4/9] tests/avocado: machine aarch64: standardize location and RO access
Date: Tue,  6 Aug 2024 13:31:14 -0400
Message-ID: <20240806173119.582857-5-crosa@redhat.com>
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

The tests under machine_aarch64_virt.py and machine_aarch64_sbsaref.py
should not be writing to the ISO files.  By adding "media=cdrom" the
"ro" is autmatically set.

While at it, let's use a single code style and hash for the ISO url.

Signed-off-by: Cleber Rosa <crosa@redhat.com>
---
 tests/avocado/machine_aarch64_sbsaref.py |  2 +-
 tests/avocado/machine_aarch64_virt.py    | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tests/avocado/machine_aarch64_sbsaref.py b/tests/avocado/machine_aarch64_sbsaref.py
index e920bbf08c..756f316ac9 100644
--- a/tests/avocado/machine_aarch64_sbsaref.py
+++ b/tests/avocado/machine_aarch64_sbsaref.py
@@ -129,7 +129,7 @@ def boot_alpine_linux(self, cpu):
             "-cpu",
             cpu,
             "-drive",
-            f"file={iso_path},format=raw",
+            f"file={iso_path},media=cdrom,format=raw",
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


