Return-Path: <kvm+bounces-48681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2583AD0A7A
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 01:56:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D299170D79
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 23:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8FC0241698;
	Fri,  6 Jun 2025 23:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QtYMtmlN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8759D241665
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 23:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254197; cv=none; b=m/+Lk6g03PJQI4W26C0M559icJCck0n5U7sltkFlirklV6DUGLfBjkKrAuaHQf8/eiJ9WZ6IHDeLQSH/aBL7aACMZxmtIScEhy3VSZ9Ni75LRasmLeWJg2oCQT80IvfFEJiMGucIjByeEMxZ5JNno1gnqLzM73NE2Az+24Gnvto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254197; c=relaxed/simple;
	bh=lnfOEn8KwE21VNo/EuQIxEnTySlWxa+6Ls0eFU2V74o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ex8Qx4Q/ai+cuPILi5JvEBgeVB4pOhhACVjG/GCcm7KAPrXcA5Co/IcnlT/FqolppL1k/DSTDAQdLN7hrmuKQyEe6DNrNXtln7kbStGmVZDV3v5vZ24nOEUH8XnByCLvA9XDMGoDrTvHVFKCHf5bRc6uvmMEsKtvWTnktwhJEVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QtYMtmlN; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747dd44048cso2193931b3a.3
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 16:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254195; x=1749858995; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J5qPyWDdZjBYrNiWpTSfn3gp6ZZ42Mm3+G5MVBiOPg4=;
        b=QtYMtmlN5y7AiT9U2512GyV4bA+ppxSXOzRWfOsn4SCEikrfegN95igj2LfZvYKRnb
         LaClIyll0cfJgN/0QuaiQIlxbqW+eFu5tt4Vo/BxUc0dcs/4/WhwHJMvsdVE6y8t0yi3
         fmyrIn7SPTMWCZ+rMJ5d8tuKlfYt0saoA60HBL3f7dXLk0yBvvK0oPRiqFBEoVxjEy10
         +MMDaAV/UouU0749Zw2QkT3v5lFAGeHqK/fajScpT56ur3QS09kOG4ggeODFHfLaNpcI
         3gS8nKWRQORNZ+ZG2vuMI/EzyG3tnmod1qMOD9zt+Fn2iidKyhVPr9ZdTq9M7LZ2BBjW
         EtfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254195; x=1749858995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J5qPyWDdZjBYrNiWpTSfn3gp6ZZ42Mm3+G5MVBiOPg4=;
        b=glUVrGEHDU45iBDuuxIjvN0OC93npspSOlrv72xmg30Qn4Kgb84K/e/UAAHAAC+1hQ
         OPA6lJRJG+V0fuHWiyZCvB5cv+g8eDhQohh9yTkZq3UU+eAXguyzz707ifgQQ+gqoZwA
         0wF44DzgToALGa/xDLwe8P7pYtiwMlw87RisKqfkzzCPoS7h+3Oy7fokLZCkWOaCyykt
         +Q2eoJjTzveFY9gF1AB+cpumzqe+q4wNwG3ISpHJznf4sBa5G91iNcxyd12t0wpSTLjl
         kb1S+HQwt9APr+YWBk9nHqy60YhmZz6WIpDHER67+p9i+0qJaK456qBjup4fiYfjzXXt
         cRWA==
X-Gm-Message-State: AOJu0YzKvlZ+Sk1/TJnPVwMAbdKkFcxa2SfFf1TE+XJozq1Xxyp/3Sqe
	aylfh6mz64tW/FRSJMA8kqPM1B4CrhDTVDmu8s+OCfIGGZj7eVutyBPlpZlc3k5lKPkMCHg7b/u
	0PUeE25dUlACDqWsmsZS+ob/XVCQtvCQpD8hawq0NAXah6hlc2ae0Qftv5kvXUeVewqrrRgeZYH
	+SjbVP7jV35EuUZoayiz3nREzC53gnly0uzI+m6w==
X-Google-Smtp-Source: AGHT+IGPFN25sf5fBQuUahDsniRulhDsp5/A6v15vwSgp1kUKeD/wcPxz2MlbUSH1xlqTKiLIES98JHHfcZB
X-Received: from pfbhm22.prod.google.com ([2002:a05:6a00:6716:b0:746:2bf3:e5e8])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:13a4:b0:736:5725:59b4
 with SMTP id d2e1a72fcca58-74827e51491mr7448173b3a.3.1749254194854; Fri, 06
 Jun 2025 16:56:34 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:06 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-3-vipinsh@google.com>
Subject: [PATCH v2 02/15] KVM: selftests: Enable selftests runner to find
 executables in different path
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add command line option, --executable/-e, to specify a directory where
test binaries are present. If this option is not provided then default
to the current directory.

Example:
  python3 runner --test-dirs test -e ~/build/selftests

This option enables executing tests from out-of-tree builds.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/runner/__main__.py    | 8 +++++++-
 tools/testing/selftests/kvm/runner/selftest.py    | 4 ++--
 tools/testing/selftests/kvm/runner/test_runner.py | 4 ++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index b2c85606c516..599300831504 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -29,6 +29,12 @@ def cli():
                         default=[],
                         help="Run tests in the given directory and all of its sub directories. Provide the space separated paths to add multiple directories.")
 
+    parser.add_argument("-e",
+                        "--executable",
+                        nargs='?',
+                        default=".",
+                        help="Finds the test executables in the given directory. Default is the current directory.")
+
     return parser.parse_args()
 
 
@@ -85,7 +91,7 @@ def main():
     args = cli()
     setup_logging(args)
     test_files = fetch_test_files(args)
-    return TestRunner(test_files).start()
+    return TestRunner(test_files, args).start()
 
 
 if __name__ == "__main__":
diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
index cc56c45b1c93..a0b06f150087 100644
--- a/tools/testing/selftests/kvm/runner/selftest.py
+++ b/tools/testing/selftests/kvm/runner/selftest.py
@@ -30,12 +30,12 @@ class Selftest:
     Extract the test execution command from test file and executes it.
     """
 
-    def __init__(self, test_path):
+    def __init__(self, test_path, executable_dir):
         test_command = pathlib.Path(test_path).read_text().strip()
         if not test_command:
             raise ValueError("Empty test command in " + test_path)
 
-        test_command = os.path.join(".", test_command)
+        test_command = os.path.join(executable_dir, test_command)
         self.exists = os.path.isfile(test_command.split(maxsplit=1)[0])
         self.test_path = test_path
         self.command = command.Command(test_command)
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index 20ea523629de..104f0b4c2e4e 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -11,11 +11,11 @@ logger = logging.getLogger("runner")
 
 
 class TestRunner:
-    def __init__(self, test_files):
+    def __init__(self, test_files, args):
         self.tests = []
 
         for test_file in test_files:
-            self.tests.append(Selftest(test_file))
+            self.tests.append(Selftest(test_file, args.executable))
 
     def _log_result(self, test_result):
         logger.log(test_result.status,
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


