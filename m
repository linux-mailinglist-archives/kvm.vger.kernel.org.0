Return-Path: <kvm+bounces-59183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7620CBAE0F6
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:37:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D7394C03C9
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E3724DFF9;
	Tue, 30 Sep 2025 16:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sehewClQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD4F23E35F
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250214; cv=none; b=qhtXsqR4WnufyzSX9So/5eUimrvEmg1m7CCeKZGFfq3yJgEv19Wij/kNMyXkAbpaigIRHuHK4tZpeggdYCB98SFu0RcEQKN714HCc5O2ztWsdkhv16zwZQcnmmt+ASqrYedhuqNqkjD07mixT/xInfn+e11bHnOOGtWe+o6sQsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250214; c=relaxed/simple;
	bh=kLygl0SPMeE6v2PxNRdsuri9gfw3S5XMZpA7QdRH8fU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=caT04De++PfWTh9DWgT9A3NA2+6mB0NioqpghSpyo2BZhU7X+nczFHEWoDH3rLYqZW6q52afot4vgpO36ktmeRZFbuZsgc5Q85m0c5olBidOp20YC91wtnHLkzi+XIWkFsqjQIGvFBUOsEexzZ5oUEdVIFQxrlT+9Q7wXm3BjM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sehewClQ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-336b646768eso4555676a91.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250212; x=1759855012; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y+zFjp+5NM5jNpiAGubNmlLxuVM2bHjpWFC3hzUQlno=;
        b=sehewClQox93AlZmlfKcEADaJaU39AEs5y8G9n3xzW5xTQg0Pks/J4M6IglxmHiNtx
         Z3ALsLkhbZI/pqvVYXs37gwVxmNjqSI/OkUsT7r0CAf+d8yyT+6Ahzk8aJAvu8dELAsX
         3sjADN9ZyU4bqpjgp3e4mM3kzRQOxf70D4HmqgALgyJ6reBuGoQ+Mxgk3WdOl0uoUQCg
         ISiP5A0p3V6kzZqhazWfbyAxlQNK3wOs4JLasEMnHc4ga6FXuWAsasHayt+6ycifDMwM
         9oXJR8gbgt3AoZ7+oRB4r58wbzKgxQ/4XSXEQcijO+K1ZlpKmiZleIiUzi82AQvbyP3y
         ZV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250212; x=1759855012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y+zFjp+5NM5jNpiAGubNmlLxuVM2bHjpWFC3hzUQlno=;
        b=X+hybmCtQOjITWQM0nRuQkZzBO3tqnXdfwogjRf6zZV1bbkkqOYQ8AsjJnTOGtf2AY
         tPlMJgMsSOKmm/Cw1PPOU3PjMHaQeXkR71mMO7OImH4Kc6gxW15Oz1zcFvVgy3IqSvF9
         zKh7X7R6e8+QxZXBgZAWLJ+fhEj2xNihXWcUTz/nQjQftVYYRYVmB53ocVuiLHhTSIzK
         cwqTc0b5rbTTtn7wz2jcFeS61Mf1j/DGaGYPyREC+njDbHRd/YXdMyYrGxMkdLXmzp77
         ObpzR5c9aa7jmmqPUb4ZzdW3B6ZCOt1CIBHibqbw6WIoDyL965tdW2VAmhDOuDzZNGve
         RiUg==
X-Gm-Message-State: AOJu0YyJJonhrfLYbQR/gtbhHRtH91iLreDHeXFqDtnSIgRdizxIizSy
	Otf4zFinyOA2IKz+y2S3MJavOHC/16sDt0maatOoFwmYhV3d2tzhDUQIxLDT3IzOihE6kChP9xD
	mGIfUGj5zMtiKgn2MxiXChpHliwXWQwtiHsyY9Z+XX4dNVTCx4jfke62zTHOfQF7a+Al76ZRjHa
	LsLlSW2E3q+JSeTaXmUnGvkKA1Vy28deNJY7ukIw==
X-Google-Smtp-Source: AGHT+IFs2HoXuNbjJ6THNWiEgkTSiX/5Eo4qEtefSIhRbGYg0YLR1fsOEVA+aC+FeUieWz082F7fpocBNbqJ
X-Received: from pjup24.prod.google.com ([2002:a17:90a:d318:b0:329:e84e:1c50])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a8f:b0:32e:7270:94a0
 with SMTP id 98e67ed59e1d1-339a6f84e2amr100040a91.33.1759250212045; Tue, 30
 Sep 2025 09:36:52 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:28 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-3-vipinsh@google.com>
Subject: [PATCH v3 2/9] KVM: selftests: Provide executables path option to the
 KVM selftest runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add command line option, -p/--path, to specify the directory where
test binaries exist. If this option is not provided then default
to the current directory.

Example:
  python3 runner --dirs test -p ~/build/selftests

This option enables executing tests from out-of-tree builds.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/runner/__main__.py    | 8 +++++++-
 tools/testing/selftests/kvm/runner/selftest.py    | 4 ++--
 tools/testing/selftests/kvm/runner/test_runner.py | 4 ++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 8d1a78450e41..943c3bfe2eb6 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -31,6 +31,12 @@ def cli():
                         default=[],
                         help="Run the testcases present in the given directory and all of its sub directories. Provide the space separated paths to add multiple directories.")
 
+    parser.add_argument("-p",
+                        "--path",
+                        nargs='?',
+                        default=".",
+                        help="Finds the test executables in the given path. Default is the current directory.")
+
     return parser.parse_args()
 
 
@@ -87,7 +93,7 @@ def main():
     args = cli()
     setup_logging()
     testcases = fetch_testcases(args)
-    return TestRunner(testcases).start()
+    return TestRunner(testcases, args).start()
 
 
 if __name__ == "__main__":
diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
index 34005f83f0c3..a94b6d4cda05 100644
--- a/tools/testing/selftests/kvm/runner/selftest.py
+++ b/tools/testing/selftests/kvm/runner/selftest.py
@@ -28,12 +28,12 @@ class Selftest:
     Extract the test execution command from test file and executes it.
     """
 
-    def __init__(self, test_path):
+    def __init__(self, test_path, path):
         test_command = pathlib.Path(test_path).read_text().strip()
         if not test_command:
             raise ValueError("Empty test command in " + test_path)
 
-        test_command = os.path.join(".", test_command)
+        test_command = os.path.join(path, test_command)
         self.exists = os.path.isfile(test_command.split(maxsplit=1)[0])
         self.test_path = test_path
         self.command = test_command
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index 4418777d75e3..acc9fb3dabde 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -11,11 +11,11 @@ logger = logging.getLogger("runner")
 
 
 class TestRunner:
-    def __init__(self, testcases):
+    def __init__(self, testcases, args):
         self.tests = []
 
         for testcase in testcases:
-            self.tests.append(Selftest(testcase))
+            self.tests.append(Selftest(testcase, args.path))
 
     def _log_result(self, test_result):
         logger.info("*** stdout ***\n" + test_result.stdout)
-- 
2.51.0.618.g983fd99d29-goog


