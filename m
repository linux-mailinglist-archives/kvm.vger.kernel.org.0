Return-Path: <kvm+bounces-59187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90B0BBAE102
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:37:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29AB44C00BA
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7ABF23D7D1;
	Tue, 30 Sep 2025 16:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wgA91Y3+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3057255F22
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250220; cv=none; b=jUi2r6JoDp4B7cdBuIxFLjgNt8qT31llywKKS3o3Bo3N7wWrmM0r7WSR8zG00b5JB9j/fQLHXUWHtsITXC6yDEKHWYs9Eirw2+I5Ui9lgzNUXBBZ6zLa6wSD/BPRk9vnDNC9D+6vnIiZU1iFU7HzIZcNMOEtHPFBGWu0pV/gcaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250220; c=relaxed/simple;
	bh=ruAd1QUl9SteirFgNfga6On/tTiMWyXsGfVXvanlDfI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fLkl5knXVTnCOG7WPybUosNQxbVZWJy33k8ML2u2hUrJPxnfuaIpEKVSNFy81sHwQI9QJBCpiceo/x5A1HcCrpFfCexLPqM08StwKWwK9PIl38odt76CYd8AU+/W6+inTAKM7GXbYQb+No31y9rhTMX1lFKA7KbIhpX6FAP6dIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wgA91Y3+; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e2e60221fso8488662b3a.0
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250217; x=1759855017; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/blTKaVRJ7ExwjOeSNjQIII5Nz+Rh7TdSzJjFSlh4/M=;
        b=wgA91Y3+vCWkrbny8W+lMKJl+SX4gcTO++DPT4mlOns2BF7VLyAtOn9Fd2uNSKslIC
         1cOenpCwbAHE3uazGxuZNwrqPwpdDxYMb3HKOEZYZ8x/11icxt8my/w2BT/LIt/fHLWZ
         M4WO89FHOg16ZYoSASwTSQwPI+UlLA6FGbXSfGTrIWy1T+dilUieXgToxjBLZ1JErsPz
         6oWfESSsdOFQQsj7seY3B+5Rx3WyI8z8H39mvZhmZpOrNAkLpqJdpZP/XuAIFmQMvvuT
         7krygNnTDoyKeY9uy9ENfetOiWPgMsrFNRkqohxRIYmo+26cRD69w4FpOcSCuTUyW9nf
         76wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250217; x=1759855017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/blTKaVRJ7ExwjOeSNjQIII5Nz+Rh7TdSzJjFSlh4/M=;
        b=selk80ErLX9ZiOcY+V/cGnlqKCBHfJq9PbhgwrK5LKFVbSuii6v2AFlZ4x+w4ZKcb1
         AUVuSBqeDMq2vqa2zh5rUXLYfiPuDlqPZHKwLa88+WQjZLaQo8g1h53TSrGKfoTsRXDc
         1Q0IssbYuCjce4dKVdMW1VuVOQeBPgoav7MMLtLLTgardg5Wtvgocy5dY5pmilK8Djp2
         1wIGgfFaheX56/a04kK/41eCVFDyJyroEWpyXIukT5mgFBFuxC7iPYZq6XVwb8vun3Ez
         CjvrTNQwwGFO/FMaf4J32E8bjSVLDEKwgDFnRstZnCJvH8xaVdQb8rW3p6RDTRnVrE9o
         WHDQ==
X-Gm-Message-State: AOJu0YwUB5Or42nKH1UCxFgy9LLz0K4zKLHqU8y4I4V/bEUVrsdw8fcn
	0JwYeCyiSjHUA9Q6/D5rWmYRdV892mAOjPlhnjfp/ucYwz807byveIEZQuhx3z2EWFHRZ46PieR
	krFBb6RE/Qtxw7foi9p9BGQj6XyYZiP0C4Fvxp03L2WAJalLcI3c+eNVuyt4fn4CZdvz0d8dcr7
	7CGmIosRfjd0mG9XEtTKsY34OV9k799CBwWzJWcQ==
X-Google-Smtp-Source: AGHT+IE7rnnLhXFO5s/R1gQ25mkbUuQhQ07CGMf/RRIqGNDBQAmFMCZUe6cqXMyhDeruvPI5USo/PgLLbGsF
X-Received: from pgdf22.prod.google.com ([2002:a05:6a02:5156:b0:b58:d933:1281])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1813:b0:301:daeb:589f
 with SMTP id adf61e73a8af0-321cf13ac4bmr518324637.8.1759250216877; Tue, 30
 Sep 2025 09:36:56 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:31 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-6-vipinsh@google.com>
Subject: [PATCH v3 5/9] KVM: selftests: Run tests concurrently in KVM
 selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
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
index b27a41e86271..b98f72c9f7ee 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -54,6 +54,12 @@ def cli():
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
index b9101f0e0432..92eec18fe5c6 100644
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
     def __init__(self, testcases, args):
         self.tests = []
         self.output_dir = args.output
+        self.jobs = args.jobs
 
         for testcase in testcases:
             self.tests.append(Selftest(testcase, args.path, args.timeout,
                                        args.output))
 
+    def _run_test(self, test):
+        test.run()
+        return test
+
     def _log_result(self, test_result):
         logger.info("*** stdout ***\n" + test_result.stdout)
         logger.info("*** stderr ***\n" + test_result.stderr)
@@ -28,12 +35,17 @@ class TestRunner:
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
2.51.0.618.g983fd99d29-goog


