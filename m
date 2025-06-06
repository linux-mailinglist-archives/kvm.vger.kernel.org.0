Return-Path: <kvm+bounces-48689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D71CAD0A82
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 01:57:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC7F4170849
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 23:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54E11242D97;
	Fri,  6 Jun 2025 23:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JCgHqobM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A626242909
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 23:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254209; cv=none; b=bspYWseh922igPNz4RLwCWjR/GAXu/FAgmUJdDG6Pf5zTFsXJ0nbRhCeh61B51KBFdyACLvGU4Zx5vJj+dh7VVkvCuNfmYO6cwvfmAkeQ58eGGhhfBXFTRkZXClzPUpwr7hKpBMAdfrFEgeYxwkaiPVu1ubb19kYFAjM6nE1BIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254209; c=relaxed/simple;
	bh=Tbt5CxmjIkXyOBWIGl4We1H6W7+keF/4RhCn7qXusBw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BgJBN7kBuNTUp3n0kpvOsQabq+SpU3cyWnLsoRjch8w0fL8Q7yDdrT8f1GIpfhGjrlamWRxnA14/tca3VwBNUFpJzBa7YH7mESnaFA4KlG1AZLAEFD0MwBwt1Y9OGdnuxuXDytyqgIhLbzM/26Ufo71mNjWFG89GV2BAYtFIrOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JCgHqobM; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235e1d66fa6so22468725ad.0
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 16:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254207; x=1749859007; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2YvWqyMXWbV+Eh1iT8lLaW4K5z1z2+DMYGYssKn0fVI=;
        b=JCgHqobMJ2wzle3EiOoYEXZSvSOYmUZZFeVCsOyEj8ylBiyXQlSIqK6ROjVbop0373
         xHeeGeatKgvR07E9D4hsS2fWtnC3shReZgo+KUdoI/o8cfTmUgznjTx6oS3VkXW4q1vs
         u2RsMFJafVSWm+bG7SV+Y19ls717ODBKsjxza8mCczqNBVTeKuq32Xs1xDSQk7Nmc7xU
         roWPOyQ89wr1Rw/pP5JYID9Z8JwFR563Be17OLuBV8Gc8gfF3m1wUEyDUf1dgl0MSA0F
         GdTBErbubw/HAy7GQ8xHMoGW7ZyHCrLIZknSKa8ltMoArDDfJYwrhiZkaOGrW2dJAY1S
         TNIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254207; x=1749859007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2YvWqyMXWbV+Eh1iT8lLaW4K5z1z2+DMYGYssKn0fVI=;
        b=AEurO4g9jVFfshQAS1x+d6CEbzAFy0wL2VIPHD6oFa3MGHldE4csNqMR4sSznPyt1p
         VSnbFoKOu9o8FpzOjrzktqUbdgdkJf8nK++yXGmUBJ2Kqtj4/dBVYdJMUrQxEx8dSXH3
         ZsQ6lFrRLfrZ0TDzdlRsA5O6Dv0dzLoI4AyJrMffRvSWx9lB5IErYIfyapF7r4uF+O4w
         11bDYxUB9lUfcajFrki+wElCuKM/dIqbl2CX673ZqXykc1GeVS0/046DwX/qx2JjRC6J
         3gguzBSANWRbFNEoawqNKHS8Rj7mbX5hiIU1a2ECwNnqFG06ayTyHcttUSgM34e/nr3V
         gywA==
X-Gm-Message-State: AOJu0YypfZYFzPqN4hB4IB83l3my65pQC3jgeJEYsThYMvPMT58mzhNC
	vtnvfp6tYswXbGAbuXawRw2g07ltrV+kESNDn3u2J+z8+tlCG1fyQ8tTs8oTsN8LPUU6el/pT0X
	YtbGfSdoYY/ABiEIX9nTVyryFpx9o1cf2IID5eON6C3SeZ0sjYV8FIJvtFziSf/dAQl9Ei/vZAL
	ssD2frZBZ2oEKmNpwjjNjva8/IRDU+Yp/10RzDKg==
X-Google-Smtp-Source: AGHT+IECcAGloB9eLcQGrexwmZ6dfzE2vnPa3s6mRZgo8fAz19L92je+kXfcgU8ZDEV3rQMzp1fI/Bkas3Ar
X-Received: from pjbcz12.prod.google.com ([2002:a17:90a:d44c:b0:30a:31eb:ec8e])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f686:b0:224:1af1:87f4
 with SMTP id d9443c01a7336-23601cfec20mr73817855ad.22.1749254207363; Fri, 06
 Jun 2025 16:56:47 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:14 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-11-vipinsh@google.com>
Subject: [PATCH v2 10/15] KVM: selftests: Add flag to suppress all output from
 Selftest KVM Runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a command line flag, --quiet, to suppress all of the output from
runner to terminal.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../testing/selftests/kvm/runner/__main__.py  |  8 ++++++-
 .../selftests/kvm/runner/test_runner.py       | 21 ++++++++++++-------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 2dcac1f4d1c4..c02035a62873 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -129,6 +129,12 @@ def cli():
                         default=False,
                         help="Print only the summary status line.")
 
+    parser.add_argument("-q",
+                        "--quiet",
+                        action="store_true",
+                        default=False,
+                        help="Suppress all of the output to terminal")
+
     return parser.parse_args()
 
 
@@ -136,7 +142,7 @@ def level_filters(args):
     # Levels added here will be printed by logger.
     levels = set()
 
-    if args.sticky_summary_only:
+    if args.sticky_summary_only or args.quiet:
         return levels
 
     if args.print_passed or args.print_passed_status or args.print_status:
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index e0da30d216a2..e7730880907d 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -18,6 +18,7 @@ class TestRunner:
         self.status = {x: 0 for x in SelftestStatus}
         self.output_dir = args.output
         self.jobs = args.jobs
+        self.quiet = args.quiet
         self.print_status = args.print_status
         self.print_stds = {
             SelftestStatus.PASSED: args.print_passed,
@@ -35,17 +36,21 @@ class TestRunner:
         test.run()
         return test
 
+    def _print(self, text, end="\n"):
+        if not self.quiet:
+            print(text, end=end)
+
     def _sticky_update(self):
-        print(f"\r\033[1mTotal: {self.tests_ran}/{len(self.tests)}" \
-                f"\033[32;1m Passed: {self.status[SelftestStatus.PASSED]}" \
-                f"\033[31;1m Failed: {self.status[SelftestStatus.FAILED]}" \
-                f"\033[33;1m Skipped: {self.status[SelftestStatus.SKIPPED]}"\
-                f"\033[91;1m Timed Out: {self.status[SelftestStatus.TIMED_OUT]}"\
-                f"\033[34;1m No Run: {self.status[SelftestStatus.NO_RUN]}\033[0m", end="\r")
+        self._print(f"\r\033[1mTotal: {self.tests_ran}/{len(self.tests)}"
+                    f"\033[32;1m Passed: {self.status[SelftestStatus.PASSED]}"
+                    f"\033[31;1m Failed: {self.status[SelftestStatus.FAILED]}"
+                    f"\033[33;1m Skipped: {self.status[SelftestStatus.SKIPPED]}"
+                    f"\033[91;1m Timed Out: {self.status[SelftestStatus.TIMED_OUT]}"
+                    f"\033[34;1m No Run: {self.status[SelftestStatus.NO_RUN]}\033[0m", end="\r")
 
     def _log_result(self, test_result):
         # Clear the status line
-        print("\033[2K", end="\r")
+        self._print("\033[2K", end="\r")
         logger.log(test_result.status,
                    f"[{test_result.status}] {test_result.test_path}")
         if (self.output_dir is None and self.print_status is False
@@ -79,5 +84,5 @@ class TestRunner:
                                                SelftestStatus.NO_RUN,
                                                SelftestStatus.SKIPPED]):
                     ret = 1
-        print("\n")
+        self._print("")
         return ret
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


