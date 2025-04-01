Return-Path: <kvm+bounces-42361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96813A78028
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:23:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52BC53B131C
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C004224258;
	Tue,  1 Apr 2025 16:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DDjZJudh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9393920F069
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523948; cv=none; b=fuoX6irpGAW1NFua8ScpixIE9QOuNdr+xvmIsiL8JvLpXX5PZ232bIPe7qlMcX5PWVM2P1YuYvJoa6t5n5WMosZsxdlEv3uho+YZ8FVrJMAe0NCloCwN95VnU+R72KmWwe3kwTDGtixJHTuK40X49cdmSYEN0ZB/9FCKZwLVZnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523948; c=relaxed/simple;
	bh=7h29/HU5sdApjkYIeGF2/5ZLb/HC0XBAWZ+vi6Cv12I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiFjMc79T2NpY1CgVb5lT+wBLbys2qiBc5WpQj9XqoTKQ1fH6pErvGdQyAqs/Glro6fUu+jpIrhW4ffbrtiCnpeERVMoAUjlusue1oeEduELfGBNPwA69kaCsgPpSze00/AXw001SfCPBcBNd8OsMZiIrg1XThgkqXEs3ikdnfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DDjZJudh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Za9UhBdtRl20IVd/exE7AzVdA7LtofpEuC+6DQ+7Q1I=;
	b=DDjZJudhhTntg9xxUarhZc5vM+EdtBcRi4jynvdzin9UTl2/xgpCISCg68ALTRM33+GhYb
	j5hBykc0fJFIx55qqNWYlgkJ0ar5JLieJnqtg4NT+WHHW9UWn3EKBXGTGcmABb1w0YhJbN
	EzZ4/jwPZyVqQGJI+UXrzO6bbr2VT/Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-_P-BD5FLO4ChEyP0P0Kr_w-1; Tue, 01 Apr 2025 12:12:24 -0400
X-MC-Unique: _P-BD5FLO4ChEyP0P0Kr_w-1
X-Mimecast-MFC-AGG-ID: _P-BD5FLO4ChEyP0P0Kr_w_1743523943
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43e9b0fd00cso13354635e9.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:12:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523943; x=1744128743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Za9UhBdtRl20IVd/exE7AzVdA7LtofpEuC+6DQ+7Q1I=;
        b=m5Jft7KUWtcrO2buCoGICiCwafJKUbLgpac73XNTMkAazL7fC+yg8fzLF2iMDa/Ial
         nSr2+T7AKqsVhqTLuL6Fs+D7eZeOnHU6qgkuNr1tyIQO3h37hmzNhQpPEassBMU7DpC+
         Q37kdVoJVGAyj3TUWf7fpIXvmnu8a3ewK8IHWh88P93Mpvnv8fuhVheSwJA0IVtQJk2p
         kMLvkAs7jB4d0WJef1wGxiWjHLLs0ziJWH4MiTmWzevtT38OFs6QBWZZpqaHRVbsXFhx
         hEqDzok2zVrELnoNSqjDgmOus0Asyqu6HH9k0BIA9GccDJJTIyM+Kmun6z5Wn0CXPD4+
         S5bw==
X-Forwarded-Encrypted: i=1; AJvYcCXXzlYfcJDBSjWBX2V0veiPbtk3mzaRhAOG/M8IemY/uTO5/utbl5GeNd+K93XpFrDY0wA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwDACQokPZMGj/S9PdOp/NySH+00IhIBz9tzSlPnA9fNJ2dEli
	qZ69G88Fo5QUuizvqEFfNa15qF1DiY4SvIUmKsqq5uXtTcRW8snk8MTaz+QP4g+7BI9WjWLs5tl
	iH2U+BclERhiGWKtbpWVdak7ZLM41Tw8+SS76f2fqSAZj/6nc8g==
X-Gm-Gg: ASbGncvatMZk4PRsVrNccl1rabbBHG/qJIBbj1HZ0I0qUmvOxpBn7bdEZUaotnFXJVk
	wiyL7C0DgBcrdyLzS0cYMgLD7gkvlmv3yjo+PzTe20XUR9531gH/TYVvWX3S1qh+AVQFVqGqEhr
	4R3OPtuO/qAaeAW5UzY6cGH1UZmFQOMpH9fqYXh/hlTYllivFI6oDXE8QdUCmPfgHqwKYntJzgY
	HXiwvqaIWztICyLqVN1e4MGVRpETMOxvE5ttoBiXniei1QQhmV0O7OSjLS119sJAksWd+RCszLe
	W7vbAsfFaAcvITm/qYa5ig==
X-Received: by 2002:a05:600c:198e:b0:43c:f3e1:a729 with SMTP id 5b1f17b1804b1-43eb05bd475mr6791715e9.12.1743523943425;
        Tue, 01 Apr 2025 09:12:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgj2ZbCQGfmVhz6lrnJ+5wyjIJ9OaWTHSb2mNQbdBcNI3fX/rNQGWp16Y3i8t/HcaXbmtslA==
X-Received: by 2002:a05:600c:198e:b0:43c:f3e1:a729 with SMTP id 5b1f17b1804b1-43eb05bd475mr6791375e9.12.1743523943004;
        Tue, 01 Apr 2025 09:12:23 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b6588dbsm14265870f8f.2.2025.04.01.09.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:12:20 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 27/29] selftests: kvm: introduce basic test for VM planes
Date: Tue,  1 Apr 2025 18:11:04 +0200
Message-ID: <20250401161106.790710-28-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
References: <20250401161106.790710-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check a few error cases and ensure that a vCPU can have a second plane
added to it.  For now, all interactions happen through the bare
__vm_ioctl() interface or even directly through the ioctl() system
call.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/Makefile.kvm |   1 +
 tools/testing/selftests/kvm/plane_test.c | 108 +++++++++++++++++++++++
 2 files changed, 109 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/plane_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index f62b0a5aba35..b1d0b410cc03 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -57,6 +57,7 @@ TEST_GEN_PROGS_COMMON += guest_print_test
 TEST_GEN_PROGS_COMMON += kvm_binary_stats_test
 TEST_GEN_PROGS_COMMON += kvm_create_max_vcpus
 TEST_GEN_PROGS_COMMON += kvm_page_table_test
+TEST_GEN_PROGS_COMMON += plane_test
 TEST_GEN_PROGS_COMMON += set_memory_region_test
 
 # Compiled test targets
diff --git a/tools/testing/selftests/kvm/plane_test.c b/tools/testing/selftests/kvm/plane_test.c
new file mode 100644
index 000000000000..43c8de13490a
--- /dev/null
+++ b/tools/testing/selftests/kvm/plane_test.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Red Hat, Inc.
+ *
+ * Test for architecture-neutral VM plane functionality
+ */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+#include "asm/kvm.h"
+#include "linux/kvm.h"
+
+void test_create_plane_errors(int max_planes)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	int planefd, plane_vcpufd;
+
+	vm = vm_create_barebones();
+	vcpu = __vm_vcpu_add(vm, 0);
+
+	planefd = __vm_ioctl(vm, KVM_CREATE_PLANE, (void *)(unsigned long)0);
+	TEST_ASSERT(planefd == -1 && errno == EEXIST,
+		    "Creating existing plane, expecting EEXIST. ret: %d, errno: %d",
+		    planefd, errno);
+
+	planefd = __vm_ioctl(vm, KVM_CREATE_PLANE, (void *)(unsigned long)max_planes);
+	TEST_ASSERT(planefd == -1 && errno == EINVAL,
+		    "Creating plane %d, expecting EINVAL. ret: %d, errno: %d",
+		    max_planes, planefd, errno);
+
+	plane_vcpufd = __vm_ioctl(vm, KVM_CREATE_VCPU_PLANE, (void *)(unsigned long)vcpu->fd);
+	TEST_ASSERT(plane_vcpufd == -1 && errno == ENOTTY,
+		    "Creating vCPU for plane 0, expecting ENOTTY. ret: %d, errno: %d",
+		    plane_vcpufd, errno);
+
+	kvm_vm_free(vm);
+	ksft_test_result_pass("error conditions\n");
+}
+
+void test_create_plane(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	int r, planefd, plane_vcpufd;
+
+	vm = vm_create_barebones();
+	vcpu = __vm_vcpu_add(vm, 0);
+
+	planefd = __vm_ioctl(vm, KVM_CREATE_PLANE, (void *)(unsigned long)1);
+	TEST_ASSERT(planefd >= 0, "Creating new plane, got error: %d",
+		    errno);
+
+	r = ioctl(planefd, KVM_CHECK_EXTENSION, KVM_CAP_PLANES);
+	TEST_ASSERT(r == 0,
+		    "Checking KVM_CHECK_EXTENSION(KVM_CAP_PLANES). ret: %d", r);
+
+	r = ioctl(planefd, KVM_CHECK_EXTENSION, KVM_CAP_CHECK_EXTENSION_VM);
+	TEST_ASSERT(r == 1,
+		    "Checking KVM_CHECK_EXTENSION(KVM_CAP_CHECK_EXTENSION_VM). ret: %d", r);
+
+	r = __vm_ioctl(vm, KVM_CREATE_PLANE, (void *)(unsigned long)1);
+	TEST_ASSERT(r == -1 && errno == EEXIST,
+		    "Creating existing plane, expecting EEXIST. ret: %d, errno: %d",
+		    r, errno);
+
+	plane_vcpufd = ioctl(planefd, KVM_CREATE_VCPU_PLANE, (void *)(unsigned long)vcpu->fd);
+	TEST_ASSERT(plane_vcpufd >= 0, "Creating vCPU for plane 1, got error: %d", errno);
+
+	r = ioctl(planefd, KVM_CREATE_VCPU_PLANE, (void *)(unsigned long)vcpu->fd);
+	TEST_ASSERT(r == -1 && errno == EEXIST,
+		    "Creating vCPU again for plane 1. ret: %d, errno: %d",
+		    r, errno);
+
+	r = ioctl(planefd, KVM_RUN, (void *)(unsigned long)0);
+	TEST_ASSERT(r == -1 && errno == ENOTTY,
+		    "Running plane vCPU again for plane 1. ret: %d, errno: %d",
+		    r, errno);
+
+	close(plane_vcpufd);
+	close(planefd);
+
+	kvm_vm_free(vm);
+	ksft_test_result_pass("basic planefd and plane_vcpufd operation\n");
+}
+
+int main(int argc, char *argv[])
+{
+	int cap_planes = kvm_check_cap(KVM_CAP_PLANES);
+	TEST_REQUIRE(cap_planes);
+
+	ksft_print_header();
+	ksft_set_plan(2);
+
+	pr_info("# KVM_CAP_PLANES: %d\n", cap_planes);
+
+	test_create_plane_errors(cap_planes);
+
+	if (cap_planes > 1)
+		test_create_plane();
+
+	ksft_finished();
+}
-- 
2.49.0


