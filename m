Return-Path: <kvm+bounces-69950-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EEHcJ9IogWkwEgMAu9opvQ
	(envelope-from <kvm+bounces-69950-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:44:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 419B8D2646
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4219A305E7CC
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D150E39A807;
	Mon,  2 Feb 2026 22:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RwuL38Dx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5E938E124
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071482; cv=none; b=rctCd2HGEVOIn72bBNhc8Ltg65z+I2LY4BqZn0e3pFxM6ZdJffJbB0+jKQKg84LjpwLrbXLue9vZZb2rAxCFYL+t+meJb1TcUZFd+/ZqsiN9ZyiCCsuwRfEsz5CPWFIWi1JYZ55pM+bDryrxpvpWHvwct+8GLZhLTRiM78kCb1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071482; c=relaxed/simple;
	bh=2WTkW1ohNlyry4byAU9mrt/4FbKH8bSD8cCbQ3cjXxc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iZduXpRURCaJIh6S9omXn+RNUp3bd3rcqo94j69ltTy37xqtQPta7d2tZih2THisgQO+GgCtnWUAZY/0quPzIi/GkuTEC/4Fu80SorEE09wqVIoMW8A6Gx8W2wJUl2yqdeDV7FJsZkz/u8e3LT9MQ2vQmvqvvFSpRd+DFqeEePk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RwuL38Dx; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0a4b748a0so105182295ad.1
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071480; x=1770676280; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zg+HE16wd7vn5dsGeMXGIm23bEFage9ublA+Ui2LaW4=;
        b=RwuL38DxoGv/42gsWFfgH9GrCJJNBQrtV0sVZ2WyVwnd8LjN/Ul16Ju7NslSYi7UCz
         8ecemlQhfPNdjxUXycQd6ERUo2Hvxt1SuuKmllTdezbVh4v3Q8Wjdz1xOxB4/fWTko57
         SQktyvee2bBpOgcbr/RHD4aMpPWKvcxINnUGUAd0eJ3qV09t8T8g93P1AcPVOLrznDSA
         LJxQUOfrW+C9mbCTzRyNuwg7ZtMfL6fxte0gAOi8FQEsOvotgbKHcgVBHUN/4gS9tWRn
         T6ipC/6VeZZzlE+EdfSK/QUTWTzMjr+N5doyVfFz28urPF2rmmm7hXPdOjn/1/bBAyyV
         qOcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071480; x=1770676280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zg+HE16wd7vn5dsGeMXGIm23bEFage9ublA+Ui2LaW4=;
        b=iGwGrd1Dps4C2264Lqo8FxOYAkSHTiyOr9edbtNJOSYP1U6KwsjSw640CQVfDk+TZr
         HV3ETxeJFv3e+Kz2bjEYWOoik6IUFQV42ZF91lULR7MpGS1u53upw3Bta27RVWejX94A
         olNDFM3Zm4kY3fU6GqPxaippT0P5gOOVjBkypBucCDcV50qHAjZDu9uvg6gg3pUS51UE
         JdKtBhX/OTvye+GOeAcY5nwxj/CkAyJ2nLwODrtkPcGuyQks0pGwRMUHmhIXiIhOdSj3
         hBD1p7Lg8/pGmiG/coxstvtWmSwz/HThRiNOTKk56Q+D4JV8NapQHoPfc9cAfhCiZ9MF
         6LEg==
X-Gm-Message-State: AOJu0Yw94z+lS5kGPISk+YCbDlnyZeNWw2MG761BdQnwuoyBcGvUSHaR
	6Z6DNfIteaQ/m9vGYeau7DDVM8BmRSghRT8vFx9ayBI70v8ua+w/MrCeS+hv/Lt6uRy2cOjLdgC
	4ZzOeQUXgYePnPYCtEHHM9rw4OamMWui5fyIdMdWaTwS3/0lgF5Lw611SgsjqBRs7Do1sg8W5sj
	LE0LfDFICkJP2lKNCzpFx94SPjR/CA11XwA4smbTVgBPjl+kN7cqPzqLqyg1w=
X-Received: from plbkg6.prod.google.com ([2002:a17:903:606:b0:2a3:2b32:4916])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d2c5:b0:2a9:410:23f6 with SMTP id d9443c01a7336-2a9041026f0mr68971965ad.41.1770071479409;
 Mon, 02 Feb 2026 14:31:19 -0800 (PST)
Date: Mon,  2 Feb 2026 14:30:13 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <b258770e0cc153b3313c348b7110d5998cbec7af.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 35/37] KVM: selftests: Add script to exercise private_mem_conversions_test
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69950-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 419B8D2646
X-Rspamd-Action: no action

Add a wrapper script to simplify running the private_mem_conversions_test
with a variety of configurations. Manually invoking the test for all
supported memory backing source types is tedious.

The script automatically detects the availability of 2MB and 1GB hugepages
and builds a list of source types to test. It then iterates through the
list, running the test for each type with both a single memslot and
multiple memslots.

This makes it easier to get comprehensive test coverage across different
memory configurations.

Use python to be able to issue an ioctl to /dev/kvm.

Update .gitignore to allowlist python scripts.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 .../kvm/x86/private_mem_conversions_test.py   | 152 ++++++++++++++++++
 2 files changed, 153 insertions(+)
 create mode 100755 tools/testing/selftests/kvm/x86/private_mem_conversions_test.py

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 1d41a046a7bf..d7e9c1d97e37 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -4,6 +4,7 @@
 !*.c
 !*.h
 !*.S
+!*.py
 !*.sh
 !.gitignore
 !config
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.py b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.py
new file mode 100755
index 000000000000..17f46c21e85e
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.py
@@ -0,0 +1,152 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Wrapper script which runs different test setups of
+# private_mem_conversions_test.
+#
+# Copyright (C) 2025, Google LLC.
+
+import os
+import fcntl
+import sys
+import subprocess
+
+
+NUM_VCPUS_TO_TEST = 4
+NUM_MEMSLOTS_TO_TEST = NUM_VCPUS_TO_TEST
+
+# Required pages are based on the test setup in the C code.
+# These static requirements are set to the maximum required for
+# NUM_VCPUS_TO_TEST, over all the hugetlb-related tests
+REQUIRED_NUM_2M_HUGEPAGES = 1024 * NUM_VCPUS_TO_TEST
+REQUIRED_NUM_1G_HUGEPAGES = 2 * NUM_VCPUS_TO_TEST
+
+
+def get_hugepage_count(page_size_kb: int) -> int:
+    """Reads the current number of hugepages available for a given size."""
+    try:
+        path = f"/sys/kernel/mm/hugepages/hugepages-{page_size_kb}kB/nr_hugepages"
+        with open(path, 'r') as f:
+            return int(f.read().strip())
+    except (FileNotFoundError, ValueError):
+        return 0
+
+
+def get_default_hugepage_size_in_kb():
+    """Reads the default hugepage size from /proc/meminfo."""
+    try:
+        with open("/proc/meminfo", 'r') as f:
+            for line in f:
+                if line.startswith("Hugepagesize:"):
+                    parts = line.split()
+                    if len(parts) >= 2 and parts[1].isdigit():
+                        return int(parts[1])
+    except FileNotFoundError:
+        return None
+
+
+def run_tests(executable_path: str, src_type: str, num_memslots: int, num_vcpus: int) -> None:
+    """Runs the test executable with different arguments."""
+    command = [executable_path, "-s", src_type, "-m", str(num_memslots), "-n", str(num_vcpus)]
+    print(" ".join(command))
+    _ = subprocess.run(command, check=True)
+
+
+def kvm_check_cap(capability: int) -> int:
+    KVM_CHECK_EXTENSION = 0xAE03
+    KVM_DEVICE = '/dev/kvm'
+
+    if not os.path.exists(KVM_DEVICE):
+        print(f"Error: KVM device not found at {KVM_DEVICE}. Is the 'kvm' module loaded?")
+        return -1
+
+    try:
+        fd = os.open(KVM_DEVICE, os.O_RDONLY)
+
+        result = fcntl.ioctl(fd, KVM_CHECK_EXTENSION, capability)
+
+        os.close(fd)
+        return result
+    except OSError as e:
+        print(f"Error issuing KVM ioctl on {KVM_DEVICE}: {e}", file=sys.stderr)
+        if fd > 0:
+            os.close(fd)
+        return -1
+
+
+def kvm_has_gmem_attributes() -> bool:
+    KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES = 246
+
+    return kvm_check_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES) > 0
+
+
+def get_backing_source_types() -> list[str]:
+    hugepage_2mb_count = get_hugepage_count(2048)
+    hugepage_2mb_enabled = hugepage_2mb_count >= REQUIRED_NUM_2M_HUGEPAGES
+    hugepage_1gb_count = get_hugepage_count(1048576)
+    hugepage_1gb_enabled = hugepage_1gb_count >= REQUIRED_NUM_1G_HUGEPAGES
+
+    default_hugepage_size_kb = get_default_hugepage_size_in_kb()
+    hugepage_default_enabled = False
+    if default_hugepage_size_kb == 2048:
+        hugepage_default_enabled = hugepage_2mb_enabled
+    elif default_hugepage_size_kb == 1048576:
+        hugepage_default_enabled = hugepage_1gb_enabled
+
+    backing_src_types: list[str] = ["anonymous", "anonymous_thp"]
+
+    if hugepage_default_enabled:
+        backing_src_types.append("anonymous_hugetlb")
+    else:
+        print("skipping anonymous_hugetlb backing source type")
+
+    if hugepage_2mb_enabled:
+        backing_src_types.append("anonymous_hugetlb_2mb")
+    else:
+        print("skipping anonymous_hugetlb_2mb backing source type")
+
+    if hugepage_1gb_enabled:
+        backing_src_types.append("anonymous_hugetlb_1gb")
+    else:
+        print("skipping anonymous_hugetlb_1gb backing source type")
+
+    backing_src_types.append("shmem")
+
+    if hugepage_default_enabled:
+        backing_src_types.append("shared_hugetlb")
+    else:
+        print("skipping shared_hugetlb backing source type")
+
+    return backing_src_types
+
+
+def main():
+    script_dir = os.path.dirname(os.path.abspath(__file__))
+    test_executable = os.path.join(script_dir, "private_mem_conversions_test")
+
+    if not os.path.exists(test_executable):
+        print(f"Error: Test executable not found at '{test_executable}'", file=sys.stderr)
+        sys.exit(1)
+
+    return_code = 0
+
+    backing_src_types = ["shmem"] if kvm_has_gmem_attributes() else get_backing_source_types()
+    try:
+        for i, src_type in enumerate(backing_src_types):
+            if i > 0:
+                print()
+            run_tests(test_executable, src_type, num_memslots=1, num_vcpus=1)
+            run_tests(test_executable, src_type, num_memslots=1, num_vcpus=NUM_VCPUS_TO_TEST)
+            run_tests(test_executable, src_type, num_memslots=NUM_MEMSLOTS_TO_TEST, num_vcpus=NUM_VCPUS_TO_TEST)
+    except subprocess.CalledProcessError as e:
+        print(f"Test failed for source type '{src_type}'. Command: {' '.join(e.cmd)}", file=sys.stderr)
+        return_code = e.returncode
+    except Exception as e:
+        print(f"An unexpected error occurred: {e}", file=sys.stderr)
+        return_code = 1
+
+    sys.exit(return_code)
+
+
+if __name__ == "__main__":
+    main()
-- 
2.53.0.rc1.225.gd81095ad13-goog


