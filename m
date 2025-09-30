Return-Path: <kvm+bounces-59189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B3FBBAE108
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3D9874E2723
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B79258EF9;
	Tue, 30 Sep 2025 16:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NJtuyBoT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602EB258ECB
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250223; cv=none; b=iOQvOjVu9yV11llLT4laJ3ruY3vpvfLldqDn5KTpg+JGwgaLuOIr9oeukHFG8yBmJptUSfgqke479+9qMAiwk54SvmwUAkfSehfDzSpgcvOG+msMZTsS/ZYJACYGcQj5JFbFHxJpZv/VscrNy84lxYf76sVCHEpzaEOiw8y8hnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250223; c=relaxed/simple;
	bh=fWBQvt8bKN+5MW/gnO5saP7mD9az3949yN/IfQk5Tg4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pjn4mGJSHrYYHqhdBft6tM4AYL15tkFn+To7xiVKeYPE9asysRuyiwMVVh91NRUrVGLAmuHncMbKJGVKJozmkJj9wb/CHE1yn1513iNRRWA0OLiVN6g0orVgQLkq58MA0LouQLL8nDUMAPGQ3VvzeCxQca1YbAMydyIcSNDIMZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NJtuyBoT; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-339a6d9defdso91815a91.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250221; x=1759855021; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OUg12Od11PLsJD4awVDsfJr7RcaROxBR6pzVFyNdKj8=;
        b=NJtuyBoTN/Un8l4Mv7pceimMfCT2X4bR52JD7HJZ4sZKm6fnvdWjDkdMSrR17KiUx0
         I/vPQGNNM244jkaAIIhCx/6rAOE/2fccOpm8y7AjeIn1FxbBEOsavyY+Z96+1yvg2CJ1
         JSG8JN+v95+gd/dDHsmLFGMkjgF6+sovLtP3+PV3VTSVOqv2erPG5PxmPmTmIdCb/PVK
         E8sJ8iflzEgX3c9Aa2IlQLyUWGziwK1LS7LqL7FwcNadrDdVLtDhZ2opoF6gJ7wiHBWE
         93rV5EaJwv/XWgoeJkSDxGO95GOZsyb0pxhJ6LLiHtK6efkkap+BD6BaekGyMwN9/Soh
         jI3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250221; x=1759855021;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OUg12Od11PLsJD4awVDsfJr7RcaROxBR6pzVFyNdKj8=;
        b=wrTsfz8o30N5kzUBklbAOAfZC9A2tmHAv46gTyF73TvvEXP923KS8lK7cDWOsPyIWq
         hTrx5F5uh/jwkNbcY7yZByew59It+NajzH0tsTKRivNFWmuxx5pQlxN9DWjv+ImFtcOr
         Si3bKMHP7SRiwrQzAD1aiejno/rCLs+9GIiO/yV/oFvkFu/sfkHl/Rw/ELTUDkOlc3cs
         uxAgVlv/edm6Y3RCjNNjYtyp5ev1IJ+9bXCbRXMDvrJQjU18IMh1XUJXebXlpaC8IYiy
         A+2vPiulDVcNby8Iex3KdW6o1hEEFvDveBzFNYdC/jyz4+KLZjKO2U8V7DUL0WpMwJzp
         risA==
X-Gm-Message-State: AOJu0YyHOJFX3UZye4vmjouhrKUvkEt6uEIQAPkV0hqduQgVcTtrkh3i
	CMLU5iT8XKdSI6xC6stGWJbuPV3edKUnD+naNc7gnPamBgcJ2DpZIaW1MVNk/A7VSMbRUOcMQTt
	pgvQj9Rm5dg/dLXAXKGSOOvJotgF8ftn+IeMpqIGxEgP+reDh+5Hgq4pCt7ux76lUGrhfgCt8Hm
	LIY/N5g1c9aWuY1mHcCQ3eNI3wRXq6SVjgrozbSw==
X-Google-Smtp-Source: AGHT+IFs+CMWNOODVu6P+nzztd0EOiTd83LgNk/a5bScJBUGMhwZj+o12u3ClbHwdU+ZCLfO3OKClHjbbXZN
X-Received: from pjbcm23.prod.google.com ([2002:a17:90a:fa17:b0:32e:ddac:6ea5])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b08:b0:329:e9da:35e9
 with SMTP id 98e67ed59e1d1-339a6e8ff19mr118159a91.2.1759250220455; Tue, 30
 Sep 2025 09:37:00 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:33 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-8-vipinsh@google.com>
Subject: [PATCH v3 7/9] KVM: selftests: Print sticky KVM selftests runner
 status at bottom
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Print current state of the KVM selftest runner during its execution.
Show it as the bottom most line, make it sticky and colored. Provide
the following information:
- Total number of tests selected for run.
- How many have executed.
- Total for each end state.

Example:

Total: 3/3 Passed: 1 Failed: 1 Skipped: 0 Timed Out: 0 No Run: 1

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/test_runner.py | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index e8e8fd91c1ad..42274e695b76 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -15,6 +15,7 @@ logger = logging.getLogger("runner")
 class TestRunner:
     def __init__(self, testcases, args):
         self.tests = []
+        self.status = {x: 0 for x in SelftestStatus}
         self.output_dir = args.output
         self.jobs = args.jobs
         self.print_stds = {
@@ -33,9 +34,18 @@ class TestRunner:
         test.run()
         return test
 
+    def _sticky_update(self):
+        print(f"\r\033[1mTotal: {self.tests_ran}/{len(self.tests)}" \
+                f"\033[32;1m Passed: {self.status[SelftestStatus.PASSED]}" \
+                f"\033[31;1m Failed: {self.status[SelftestStatus.FAILED]}" \
+                f"\033[33;1m Skipped: {self.status[SelftestStatus.SKIPPED]}"\
+                f"\033[91;1m Timed Out: {self.status[SelftestStatus.TIMED_OUT]}"\
+                f"\033[34;1m No Run: {self.status[SelftestStatus.NO_RUN]}\033[0m", end="\r")
+
     def _log_result(self, test_result):
         print_level = self.print_stds.get(test_result.status, "full")
 
+        print("\033[2K", end="\r")
         if (print_level == "full" or print_level == "stdout"):
             logger.info("*** stdout ***\n" + test_result.stdout)
         if (print_level == "full" or print_level == "stderr"):
@@ -43,8 +53,13 @@ class TestRunner:
         if (print_level != "off"):
             logger.log(test_result.status, f"[{test_result.status.name}] {test_result.test_path}")
 
+        self.status[test_result.status] += 1
+        # Sticky bottom line
+        self._sticky_update()
+
     def start(self):
         ret = 0
+        self.tests_ran = 0
 
         with concurrent.futures.ProcessPoolExecutor(max_workers=self.jobs) as executor:
             all_futures = []
@@ -54,9 +69,11 @@ class TestRunner:
 
             for future in concurrent.futures.as_completed(all_futures):
                 test_result = future.result()
+                self.tests_ran += 1
                 self._log_result(test_result)
                 if (test_result.status not in [SelftestStatus.PASSED,
                                                SelftestStatus.NO_RUN,
                                                SelftestStatus.SKIPPED]):
                     ret = 1
+        print("\n")
         return ret
-- 
2.51.0.618.g983fd99d29-goog


