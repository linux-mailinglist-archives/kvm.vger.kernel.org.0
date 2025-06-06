Return-Path: <kvm+bounces-48684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 831D9AD0A7D
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 01:57:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2834C171C0E
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 23:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A560F24113D;
	Fri,  6 Jun 2025 23:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wQU9PnCu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C643241689
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 23:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254201; cv=none; b=SllEnu2gqOb+THuqbRwk1PJ/h+vN9See1E7E83P4r7s6viXYasO89i8WD8g01LClz+JAVTsZA7T1EuKr1R6zckE1qiRItZzLBd7foX2CxI9YUsGk19+9JuxbhWyG4FFP4WxV7xWxj0QbkxjBYy6l+Q5PA94fL9CV2eL7Lfd+c+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254201; c=relaxed/simple;
	bh=bf0CqANxm6Iu1VekbtrJ8l5NBJ7Y3WNqKwPOa6RcxR0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QZYxW9puQ8NuL8GoZNto3N7oviOT4pGjsboxESFU6jAoP2q59oYLK6kNeqe3dudItQhSpP0f7Gu/c4GZXPvOEfgRD4XteEMPm9+BCWAK0edQGC6EFjvjaa1mTnBuV10CAuFsVpNJJ9BtKeK+0ZhTnVT6SIaUiZPKXh6XaGigFIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wQU9PnCu; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7425efba1a3so2231944b3a.0
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 16:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254200; x=1749859000; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=odBjuILvJ2GdKU4pLjfdkzpf7BXKuFiwJq3tj2s6sYU=;
        b=wQU9PnCu/BhCPL6FifpxC0lvGFRH0l/JmrXIFxK7Mec/QE2I8mmviK5WoVMnLqPxVT
         T/Ua0RSrJCyR30WBdrhvcszghKquIGvxtKM47v4OXE4gnYroE/ZaVMbUdoWNp9i0jpmx
         Vp0XGO52kmUy1K8vaQGkQiq5AMhOMlAV7Xjlpfm/MI59AFUExKWSKmRUb4pwy0kFvvLB
         FnEG/XOMegsPmmIaTR3aRqE295dQzsmetN8fFon40bLkUcUFOSck3K4g2vQTbbU5GPCG
         PvSknKv4ASek0YSlbOG7WQf7F9FTbiuK5KMqhpTdKE/LxdV3Jc8U2Q1PoVhr5HSCYUt5
         XPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254200; x=1749859000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=odBjuILvJ2GdKU4pLjfdkzpf7BXKuFiwJq3tj2s6sYU=;
        b=V9y/Xlxu+si3I4QvD/WHjRu+0csCGSi7WFlOluQW+wY6SqrOeVqzVwbjz9ieNx7Ros
         pc1nd0iYYGg7m8mE6P8BRykoVIcueg3rPFxu06M3JgpCRVMFPLmQS1o6yRK2E0FW5rUC
         fYZ+GgmHua3p4ujw6XW+fwGhh3enJfOsyIq1yh81MzLWk0Gg0Cpmc361PzQZzbYQnKMV
         S66ar0WfGjJV0O++UMlfC42C8d/ANk4zGD5Av3i1zAoU5y1itB25W5bsUmQaeSxFYqWg
         GrGtM3Y1hyX7ksZ/Vz77u/v01kcgv5zYXZaNQnQSblZpZigwG8QCbVAQGm/UVHWX+w6v
         KESg==
X-Gm-Message-State: AOJu0Yy2qBRAvoPlyEeWI+7zyhfH/YXaLxiaKuHBDXi4DptQ0R61gW1D
	xmnliAvonxJjYbky0fzAC5shho6npOXOKV8zeDhazJcnJo7by9/gTkHbvnpPnskuadPSb/qZ6L5
	oGy8w81WFsxF/quN84n/xH2BJQEdh05f0L7QvAfgyExsbpme8uGzpv41clejjwrzpSDap+3W5PR
	UFVahzNao9Qb0VldHyOPfTSV0T24boCTTaldb27g==
X-Google-Smtp-Source: AGHT+IGnW9KI2of5eZ8NHRy+qdCq1b5yQNAN8DIiVg4G8sw5Oy+cQExkg27C/Z3d87sRoL1HT8Zeqsd2ie1W
X-Received: from pfbca27.prod.google.com ([2002:a05:6a00:419b:b0:746:1bf8:e16])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:94a0:b0:746:2217:5863
 with SMTP id d2e1a72fcca58-74839af6c88mr624028b3a.6.1749254199608; Fri, 06
 Jun 2025 16:56:39 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:09 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-6-vipinsh@google.com>
Subject: [PATCH v2 05/15] KVM: selftests: Run tests concurrently in KVM
 selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a command line argument, --jobs, to specify how many tests can
execute concurrently. Set default to 1.

Example:
  python3 runner --test-dirs tests -j 10

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/__main__.py  |  6 ++++
 .../selftests/kvm/runner/test_runner.py       | 28 +++++++++++++------
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 54bdc248b13f..48d7ce00a097 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -53,6 +53,12 @@ def cli():
                         default=False,
                         help="Appends timestamp to the output directory.")
 
+    parser.add_argument("-j",
+                        "--jobs",
+                        default=1,
+                        type=int,
+                        help="Maximum number of tests that can be run concurrently. (Default: 1)")
+
     return parser.parse_args()
 
 
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index 0501d77a9912..0a6e5e0ca0f5 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -4,6 +4,8 @@
 # Author: vipinsh@google.com (Vipin Sharma)
 
 import logging
+import concurrent.futures
+
 from selftest import Selftest
 from selftest import SelftestStatus
 
@@ -14,11 +16,16 @@ class TestRunner:
     def __init__(self, test_files, args):
         self.tests = []
         self.output_dir = args.output
+        self.jobs = args.jobs
 
         for test_file in test_files:
             self.tests.append(Selftest(test_file, args.executable,
                                        args.timeout, args.output))
 
+    def _run_test(self, test):
+        test.run()
+        return test
+
     def _log_result(self, test_result):
         logger.log(test_result.status,
                    f"[{test_result.status}] {test_result.test_path}")
@@ -33,12 +40,17 @@ class TestRunner:
     def start(self):
         ret = 0
 
-        for test in self.tests:
-            test.run()
-            self._log_result(test)
-
-            if (test.status not in [SelftestStatus.PASSED,
-                                    SelftestStatus.NO_RUN,
-                                    SelftestStatus.SKIPPED]):
-                ret = 1
+        with concurrent.futures.ProcessPoolExecutor(max_workers=self.jobs) as executor:
+            all_futures = []
+            for test in self.tests:
+                future = executor.submit(self._run_test, test)
+                all_futures.append(future)
+
+            for future in concurrent.futures.as_completed(all_futures):
+                test_result = future.result()
+                self._log_result(test_result)
+                if (test_result.status not in [SelftestStatus.PASSED,
+                                               SelftestStatus.NO_RUN,
+                                               SelftestStatus.SKIPPED]):
+                    ret = 1
         return ret
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


