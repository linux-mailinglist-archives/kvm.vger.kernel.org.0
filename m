Return-Path: <kvm+bounces-60429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 813F5BEC229
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 02:12:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DCC031AE167F
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 00:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E0B2253B4C;
	Sat, 18 Oct 2025 00:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q10bwwsl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2C52441A6
	for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 00:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760746080; cv=none; b=ZUH9zqyxwaZcrBYcVGdWIFBNEFDEZdnhO4uk+/JJEw+Ep8djz4EIlus4Y56hT5KsC29QawFRCS/O5xlC90PKxo5sKnZreQ4+xWS8sqX6Hjthn/WikQZBo4jf15uMtvjsIw+3kIkyL2wzAmuzbyBVB36VQffmhE43SlwEXMDd3Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760746080; c=relaxed/simple;
	bh=L7bQsmwx8ZEiES29AaBMBPJDcgdVXbcHzVj4Z5bbaGU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D8Q9qa8onjBu5sjBai14nBPC5XQehdxwGblcLKHrYH8RBvW1so8hc8D1UhGJrgD69mZ/wian40q+uElEraVkrcfSws0B4DNWrmQwJfvhstH7F/g2GMiC5kA/hPQpSccXs144k7WXpGjzhcNwA5+ZMYqBVZe8xIE+aUTEkxzT7lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q10bwwsl; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2924b3b9d47so1042575ad.0
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 17:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760746078; x=1761350878; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jwtg4bEBkOAaSJBH9eJxsurOXu99SsbvOed4JRZ9vuM=;
        b=Q10bwwsl0fLetkY8IBCDDieBttB4Q0ujAEDKR+rBYDag6J5KHIr9IaYHlEg+qjUo1G
         1exg07b60Ezv4gDecX6Wxi8mCRqKTPdrxKIqr9Wy3RzOpNG9/QFd/4/I3GzvRf/AJ+7h
         EP1aUJc2UnCDYjl9Hoi0rPo+oCdVXO2CPqHw/89+tb4aILBQoloyMKOWOS8DBrNdJV2V
         +WsDOJLjaxIW0+PpuG6mSgKK40CNruz2kxYsxtOJY1JWJ2sfPU5A7P5800oVlFnXke9k
         +XeSwsojcK/U1+7T+7/gX5hDCREFpP7su0pKahUQQyM2efFimggUZq/vWm0TUjtMh7du
         GVWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760746078; x=1761350878;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jwtg4bEBkOAaSJBH9eJxsurOXu99SsbvOed4JRZ9vuM=;
        b=K3WDGL8t2wA4Iu1I2Dx/yNmVnbuJSuw2OPfXdCwUbAd/eT8mZoI2/ObdiQZXyLlaXh
         RFwgrzseVt2B9UpcC2dl2p5yrs0qTcrMAfOZhfSVvIdFI16zo9WmDuRd18CR6IukR2Qu
         O8+dE4XJb7MQteaodHVMcPA6H8x5pKRJVIs5uUQukIIqeIVWza12aRhImcU0zwC1i+or
         YBNtP/xq2i5djatbP8r2fkk2Iw5wrMBL3YTgFfS+lnCqX2vVFb/TeQk21JT19bpmiSGI
         RQeoPdb4963se/Z0sfxoYQGg06gNRZiLkxkkhlE7ZEDhDjN7dHPjNyiXtylyUgFE5CJP
         Hx8A==
X-Forwarded-Encrypted: i=1; AJvYcCVXSDoxSzQiPt+RmyWug/zog0Pmgdm+d4YCFCEzGGElYAkcGvAsu2TKEwrxbCpd/fZmBHs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5l7oD2gLkEa5vGYNTsZdCnKjRmvXI6pbTUa6HhZ7rc4Fk9V24
	OwIw9xI5UXlCgfR0UhV+APTYkjSyxB5Tq3qksWoUoyV63FB35DWJbtG0O4Ecqr9hZa1w5rxVbbI
	tXe7sQ8sz2Q==
X-Google-Smtp-Source: AGHT+IGPunWrE69G7Pp3xNpNGMHvy48e05wfcB9s0P6nq+4nmRJL/y5Vc5fV/xG3iuY7KjA+wnCFMmKqGR3H
X-Received: from pjbfv23.prod.google.com ([2002:a17:90b:e97:b0:33b:cfaf:ce3e])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:240d:b0:290:ac36:2ecd
 with SMTP id d9443c01a7336-290c9ca66famr73630705ad.14.1760746078012; Fri, 17
 Oct 2025 17:07:58 -0700 (PDT)
Date: Fri, 17 Oct 2025 17:07:12 -0700
In-Reply-To: <20251018000713.677779-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251018000713.677779-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251018000713.677779-21-vipinsh@google.com>
Subject: [RFC PATCH 20/21] vfio: selftests: Add VFIO live update test
From: Vipin Sharma <vipinsh@google.com>
To: bhelgaas@google.com, alex.williamson@redhat.com, pasha.tatashin@soleen.com, 
	dmatlack@google.com, jgg@ziepe.ca, graf@amazon.com
Cc: pratyush@kernel.org, gregkh@linuxfoundation.org, chrisl@kernel.org, 
	rppt@kernel.org, skhawaja@google.com, parav@nvidia.com, saeedm@nvidia.com, 
	kevin.tian@intel.com, jrhilke@google.com, david@redhat.com, 
	jgowans@amazon.com, dwmw2@infradead.org, epetron@amazon.de, 
	junaids@google.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Write a test to exercise VFIO live update support on the passed device
BDF. Provide different behavior of the test based on host live update
state (NORMAL or UPDATED).

When test is executed in NORMAL state, initialize a VFIO PCI device and
enable its Bus Master Enable bit by writing to PCI command register.
Create a live update session, and pass the VFIO device FD to it for
preservation. Preserve the session and then send the global live update
prepare event. If everything is fine up to this point, then reboot the
kernel using kexec.

When test is executed in UPDATED state, retrieve the session from Live
Update Orchestrator, restore the VFIO FD from the session. Use the
restored FD to initialize vfio_pci_device in selftest. Move the host to
NORMAL state and verify if the Bus Master Enable bit is still enabled on
the VFIO device.

Test will not be auto run, therefore, only build this test and let the
user run the test manually with the command:

./run.sh -d 0000:6a:01.0 ./vfio_pci_liveupdate_test

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/vfio/Makefile         |   1 +
 .../selftests/vfio/vfio_pci_liveupdate_test.c | 106 ++++++++++++++++++
 2 files changed, 107 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_test.c

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index c7f271884cb4..949b7fcc091e 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -3,6 +3,7 @@ TEST_GEN_PROGS += vfio_dma_mapping_test
 TEST_GEN_PROGS += vfio_iommufd_setup_test
 TEST_GEN_PROGS += vfio_pci_device_test
 TEST_GEN_PROGS += vfio_pci_driver_test
+TEST_GEN_PROGS_EXTENDED += vfio_pci_liveupdate_test
 TEST_PROGS_EXTENDED := run.sh
 include ../lib.mk
 include lib/libvfio.mk
diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_test.c
new file mode 100644
index 000000000000..9fd0061348e0
--- /dev/null
+++ b/tools/testing/selftests/vfio/vfio_pci_liveupdate_test.c
@@ -0,0 +1,106 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Vipin Sharma <vipinsh@google.com>
+ */
+
+#include <linux/liveupdate.h>
+#include <liveupdate_util.h>
+#include <vfio_util.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+
+#define SESSION_NAME "multi_file_session"
+#define TOKEN 1234
+
+static void run_pre_kexec(int luo_fd, const char *bdf)
+{
+	struct vfio_pci_device *device;
+	int session_fd;
+	u16 command;
+
+	device = vfio_pci_device_init(bdf, "iommufd");
+
+	command = vfio_pci_config_readw(device, PCI_COMMAND);
+	VFIO_ASSERT_FALSE(command & PCI_COMMAND_MASTER);
+
+	vfio_pci_config_writew(device, PCI_COMMAND,
+			       command | PCI_COMMAND_MASTER);
+
+	session_fd = luo_create_session(luo_fd, SESSION_NAME);
+	VFIO_ASSERT_GE(session_fd, 0, "Failed to create session %s",
+		       SESSION_NAME);
+	VFIO_ASSERT_EQ(luo_session_preserve_fd(session_fd, device->fd, TOKEN),
+		       0, "Failed to preserve VFIO device");
+	VFIO_ASSERT_EQ(luo_set_global_event(luo_fd, LIVEUPDATE_PREPARE), 0,
+		       "Failed to set global PREPARE event");
+
+	VFIO_ASSERT_EQ(system(KEXEC_SCRIPT), 0, "kexec script failed");
+
+	sleep(10); /* Should not be reached */
+	vfio_pci_device_cleanup(device);
+	exit(EXIT_FAILURE);
+}
+
+static void run_post_kexec(int luo_fd, const char *bdf)
+{
+	int session_fd;
+	int vfio_fd;
+	struct vfio_pci_device *device;
+	u16 command;
+
+
+	session_fd = luo_retrieve_session(luo_fd, SESSION_NAME);
+	VFIO_ASSERT_GE(session_fd, 0, "Failed to retrieve session %s",
+		       SESSION_NAME);
+
+	vfio_fd = luo_session_restore_fd(session_fd, TOKEN);
+	if (vfio_fd < 0) {
+		printf("Failed to restore VFIO device, error %d", vfio_fd);
+		exit(1);
+	}
+
+	device = vfio_pci_device_init_fd(vfio_fd);
+
+	if (luo_set_global_event(luo_fd, LIVEUPDATE_FINISH) < 0) {
+		printf("Failed to set global FINISH event");
+		exit(1);
+	}
+
+	close(session_fd);
+
+	command = vfio_pci_config_readw(device, PCI_COMMAND);
+	VFIO_ASSERT_TRUE(command & PCI_COMMAND_MASTER);
+	vfio_pci_device_cleanup(device);
+}
+
+int main(int argc, char *argv[])
+{
+	enum liveupdate_state state;
+	const char *device_bdf;
+	int luo_fd;
+
+	device_bdf = vfio_selftests_get_bdf(&argc, argv);
+
+	luo_fd = luo_open_device();
+	VFIO_ASSERT_GE(luo_fd, 0, "Failed to open %s", LUO_DEVICE);
+	VFIO_ASSERT_EQ(luo_get_global_state(luo_fd, &state), 0, "Failed to get LUO state.");
+
+	switch (state) {
+	case LIVEUPDATE_STATE_NORMAL:
+		printf("Running pre-kexec actions.\n");
+		run_pre_kexec(luo_fd, device_bdf);
+		break;
+	case LIVEUPDATE_STATE_UPDATED:
+		printf("Running post-kexec actions.\n");
+		run_post_kexec(luo_fd, device_bdf);
+		break;
+	default:
+		printf("Test started in an unexpected state: %d", state);
+	}
+
+	close(luo_fd);
+}
-- 
2.51.0.858.gf9c4a03a3a-goog


