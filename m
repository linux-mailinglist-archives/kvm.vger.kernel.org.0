Return-Path: <kvm+bounces-48685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88113AD0A7E
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 01:57:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 107B63AB4FA
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 23:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C59D242D60;
	Fri,  6 Jun 2025 23:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Fyt/ejI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB08B242909
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 23:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254203; cv=none; b=l//tDnsx+C5NZwQjJ1hjT8EeJPFNQmSiY5v1qqCW4eoou9W2/oJ0m0zKk0d8ocWgaEz9DP+1LAFFYAb2Pxy8Z7qehKmo/VZfSfIPQPiv2tvMTZzjpGPSXz70QXy0ow5uNA910ROr9hM6UBiha9qzltPGDuy2XJ8rz/2RVNkdPd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254203; c=relaxed/simple;
	bh=VG/G+DbytmsCJRMeTYLj0G1mYMysJoBW+4ZySPq273k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SNvsRyTT2x5jcNi7DzYa9IzmuhA5gOuF8UxwRZYeEYgmws7xAZzCeAV9/oUUhxPlnkaDLXvNCpsAsxbaSUhs7BPuKqqs37YrT+65OYkAgvUIWcpsZf7S8WwLFNHNlorAzULNLbUsiyRaXhPJ/aCA3pOV7YqX7QSG2XkFsJAUEIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Fyt/ejI; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2eeff19115so3167905a12.0
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 16:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254201; x=1749859001; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PWbzbH1m+wqWOmBrT8udt/40D0dgC1NwBn/2qwIwUgk=;
        b=4Fyt/ejIXDH1XlBbmTCfmRaUbTHExr2NpQd/CVMSVXnwqq5RL08E9QJgJ7hWbaEJmk
         /5WcuR/aANWWWEA74/5B5QhBNPxVhZ4dvoyYWFGi7RZ/9Jw7ap95nlJeo/7FDczOqENZ
         4dyXB6QWqA61Aj7sJdjLDBUUrBfPQlex1xrf/xsDEe+IB/1mgTRGL4KFZATHdsHTifA4
         X7gafrkZaMlvIJZ0lntvN1a8lNKUxZ7lx67EQQxkDpD5atlfSNFackAxWt3nFL0Bqfcg
         f6hEEcUOvLVxsT2enh+NPxqpnBwyxtQWfV2nvRfzQjUzRDi+2fTOW6FEQKFIfwzQeLNs
         43WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254201; x=1749859001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PWbzbH1m+wqWOmBrT8udt/40D0dgC1NwBn/2qwIwUgk=;
        b=vzfuN45FJcSv8HpZCX4XU3V83PGiuHzb7El7XKsq2594Yje5HkR9YzgD2tCpzRC0Jy
         bTZjGVdS2ASt2xsLMxsIKwedcXgMqRiD1KiqWWlL/LJ1wj6N0T1UwEOCskXGyeUWXvkY
         mGvKyB4RbEbDcWfuhAvlv8d5X/ObqmVAIaU5kDjJ7ToXkneobAtKDd1Zp7O2HbilFhve
         pJiHpTmKGGlwECzIBGChvGKuEP/JvX87gtoPJJv0kAFxiswiTA8MWQPZ1gDntf2yf5CK
         eXyNAhGTtI2ZmtrPK9qvGruZ9qWEF4inE1jW+UyH77DYB3Vxvn+Yk4IVhh/J4bOllZxO
         OqpA==
X-Gm-Message-State: AOJu0YxfJWlKNrpPfsTlHd7253FS6mo65batS1nHHVD8VJAQ3JbxZ2Ka
	0wd9dtD4WVO/boziOols32aQurBXGaRZIXF0UUVWVtQ/wBchiSNPlWAOCga4/s2KFrBXiN16Uhv
	UX5cTgoAozUCYgdeb4TOZcvwz/kgJY/raVovdzVgi7vPiEgGcC6AaIXZ/t65d26Rw/5BnYuYboQ
	5+qfEBWslktaVbJq++wpbqYbe1+0UgKLUW+7F9ng==
X-Google-Smtp-Source: AGHT+IGVs207s86YmdkUc4NLTl0O3Ae4xRqr3JThhY5MoJTIq3qF5lZ9DcjFAhjtq7dWe0bT1o+6NEUKFsOo
X-Received: from pfbhu52.prod.google.com ([2002:a05:6a00:69b4:b0:746:1b3a:db4])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3383:b0:215:e60b:3bd3
 with SMTP id adf61e73a8af0-21ee25e0bfemr7507277637.29.1749254201128; Fri, 06
 Jun 2025 16:56:41 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:10 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-7-vipinsh@google.com>
Subject: [PATCH v2 06/15] KVM: selftests: Add a flag to print only test status
 in KVM Selftests run
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a command line argument, --print-status, to limit content printed on
terminal by default. When this flag is passed only print final status of
tests i.e. passed, failed, timed out, etc.

Example:
  python3 runner --test-dirs tests  --print-status

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/runner/__main__.py    | 5 +++++
 tools/testing/selftests/kvm/runner/test_runner.py | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 48d7ce00a097..3f11a20e76a9 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -59,6 +59,11 @@ def cli():
                         type=int,
                         help="Maximum number of tests that can be run concurrently. (Default: 1)")
 
+    parser.add_argument("--print-status",
+                        action="store_true",
+                        default=False,
+                        help="Print only test's status and avoid printing stdout and stderr of the tests")
+
     return parser.parse_args()
 
 
diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
index 0a6e5e0ca0f5..474408fcab51 100644
--- a/tools/testing/selftests/kvm/runner/test_runner.py
+++ b/tools/testing/selftests/kvm/runner/test_runner.py
@@ -17,6 +17,7 @@ class TestRunner:
         self.tests = []
         self.output_dir = args.output
         self.jobs = args.jobs
+        self.print_status = args.print_status
 
         for test_file in test_files:
             self.tests.append(Selftest(test_file, args.executable,
@@ -29,7 +30,7 @@ class TestRunner:
     def _log_result(self, test_result):
         logger.log(test_result.status,
                    f"[{test_result.status}] {test_result.test_path}")
-        if (self.output_dir is None):
+        if (self.output_dir is None and self.print_status is False):
             logger.info("************** STDOUT BEGIN **************")
             logger.info(test_result.stdout)
             logger.info("************** STDOUT END **************")
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


