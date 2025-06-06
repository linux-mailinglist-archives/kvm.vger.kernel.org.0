Return-Path: <kvm+bounces-48687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF3A7AD0A80
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 01:57:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C8DA7A6F78
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 23:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43427242D7A;
	Fri,  6 Jun 2025 23:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y0IEEaSN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0157242909
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 23:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254206; cv=none; b=cz02ncyzIWTNOk5xR/4d5bMNfDR/W9Ze81HXmwh5QB7W/bXhY2v8ssLfFiUdgyl2bm4VfCYyRkHPAWS3oW4JuBXxTpjXisjTJn5YSuu+8k0PCACgBJ+9/wvHcehMB14mhGLKj978ZnNWUKhUrmFqMen6nn9QioZ43A7JQYjC4Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254206; c=relaxed/simple;
	bh=f+eEB/iYNCpX8oI/VsUjK9SDKs311EQm6wKDEhFqTfI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KZQDOrgfa9AgxS3NeQ2wioz5KrAJ47jkMtFDkmM+CtEAy7Hnyjy/eQS8pYjf+FuQDFmzukM71g9/jfVyy+K6zb02CcxIluc7jgSFIx2EUTlrvZtVFoMcEPB5eXun7LPNVSRY6MR7fE2NYJ16iuLVfDTkEyUQwyNN9tbYLwit4Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y0IEEaSN; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23228c09e14so39139945ad.1
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 16:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254204; x=1749859004; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Eryy+YJT09TinpK7TLn0VFQh3NTz7wAuAJ/KxptN2XM=;
        b=y0IEEaSNtkk7dR1wUKXPNmi9NNqeqS4gFMojux1eDFlmbPMWsEZVFP4zucQd16bPi+
         gQJQBkbQ5L9HFomtjxLMUpRJqhox95jcy3BazpsnZNbEL6jsZOlWGWBQsAFbbQbzarBD
         2NkfDpCK8vemyqGmt3JTfg+34Rse3yd2oAMolnQKSkOhGxyIXprILn6Lp5NROjWX5yLz
         Bk3oQpQR+BkNxp9qbCOQadzoewz4QUZ9D9q6zKOnTKuhj1QfmLlOe+XVfFPXkmWi3Oeu
         yOzSr7sPlHhAI/cBLj+mHitkMkKq2vuOsoRnOG3oN0DMs/J1acCNS4iRX3FASFQW21qC
         6FZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254204; x=1749859004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Eryy+YJT09TinpK7TLn0VFQh3NTz7wAuAJ/KxptN2XM=;
        b=OuQkhCN8rXu+dbABmctuAkUno9IKk6jOHDBs4IHqCEV/VU5Lm0lGeOd8T8oR8cOd0s
         lO2PeGKv6PTeI8xsIWK7EjHHNypXk/I2HJlglFpuVISm4Atx10+tVjqBtssOk/F9Jr7X
         8Fb5lAmp2DdjQOcbKMBs4jmoczwN43ZmT7bPLfLOWRBXcdedPIYDHQ2SzG5SFRLO6L5g
         mpBv3plrL1FaCcIONPNVBnzJke7Q/fv1mTS/UXqJnfaDbUv6f2u8jJAF1jI/1W2/ZUI3
         SHVak2xYNWHeiMxk4gFh+SVTTP0iTlQwNTyaEBESwe6YkLYhykkYmx1gWvzTSlmhO0Ep
         bZOA==
X-Gm-Message-State: AOJu0YwfhQo1fp3rjSGPhxrWs6K8MR5u3mMHYBVZMt72mxfnhgVQWHrt
	BB9gT0dtLYqsG+XzLuJCs8kRt6Xa0wm4l4EP95wraVhOmDeG8ZH6/vQn+lnwFtWa5JYu/9sC8Xk
	5UpG746K0bVRU4kAP3jTJbeAhgJaF/tt+IFZ1/nTbwKr+C8D6sQmV6EC/b6tjGQnx6T/sue9i+7
	PAJaQJWx6e2UlVQLdmCZcvmI4UpW4BHFxLB33i+w==
X-Google-Smtp-Source: AGHT+IHoWyMkTDRUV9FORNhwP9EK3SZsd3ZxOrapFYSdtobGvViIWq2t5Q6eVMf+UJBQjw9Zhem7ol5n6al1
X-Received: from pgww16.prod.google.com ([2002:a05:6a02:2c90:b0:b2c:3dd5:8139])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc86:b0:235:e9fe:83c0
 with SMTP id d9443c01a7336-23601d18723mr75766385ad.27.1749254204307; Fri, 06
 Jun 2025 16:56:44 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:12 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-9-vipinsh@google.com>
Subject: [PATCH v2 08/15] KVM: selftests: Print sticky KVM Selftests Runner
 status at bottom
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Print current state of the KVM Selftest Runner during its execution.
Show it as the bottom most line, make it sticky and colored. Provide
the following information:
- Total number of tests selected for run.
- How many have executed.
- Total for each end state.

Example:

Total: 3/3 Passed: 1 Failed: 1 Skipped: 0 Timed Out: 0 No Run: 1

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../selftests/kvm/runner/test_runner.py        | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index 8f2372834104..e0da30d216a2 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -15,6 +15,7 @@ logger = logging.getLogger("runner")
 class TestRunner:
     def __init__(self, test_files, args):
         self.tests = []
+        self.status = {x: 0 for x in SelftestStatus}
         self.output_dir = args.output
         self.jobs = args.jobs
         self.print_status = args.print_status
@@ -34,7 +35,17 @@ class TestRunner:
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
+        # Clear the status line
+        print("\033[2K", end="\r")
         logger.log(test_result.status,
                    f"[{test_result.status}] {test_result.test_path}")
         if (self.output_dir is None and self.print_status is False
@@ -46,8 +57,13 @@ class TestRunner:
             logger.info(test_result.stderr)
             logger.info("************** STDERR END **************")
 
+        self.status[test_result.status] += 1
+        # Sticky bottom line
+        self._sticky_update()
+
     def start(self):
         ret = 0
+        self.tests_ran = 0
 
         with concurrent.futures.ProcessPoolExecutor(max_workers=self.jobs) as executor:
             all_futures = []
@@ -57,9 +73,11 @@ class TestRunner:
 
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
2.50.0.rc0.604.gd4ff7b7c86-goog


