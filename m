Return-Path: <kvm+bounces-59191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47E04BAE10E
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:37:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEACC1944A16
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66061264F96;
	Tue, 30 Sep 2025 16:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0m2M6q1j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F12259CA4
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250227; cv=none; b=K2pSuvD8Hb6nXR3Dxg4dYBpcfMCJz8zH7BatEqATanaWZSc1ymJ7G6X9HIefpEi4qfDf+f1SRnD50jZgrLyhnCTtofBg1pvvcxs49SZUa6HiBab0OazyEW2wSBAtNnG8hO11y2777BCWGlXGGDdcmEmUlq+2OmuniiIRYhQJFZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250227; c=relaxed/simple;
	bh=GJ6Trfw8ZxlzDRTI1uQfQ+m2EdLCPjK6h626Z8z84xY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RgJVgMM8AdT6/J45RXQnz4G6yT3n+skcDSwYrlWo2GGdCxg5XmMnWrmA5oq9Px7uKljvZwTpS6KR2D4TCYvnNQlVaLEvC7X+uUNnbEnQ1Wxdp545PT6s6/c/XBiHWb18zhoxJspkVx+gZLijENjBajTOyD5ALkGdS/tzXVSs+hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0m2M6q1j; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3307af9b55eso5292194a91.2
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250224; x=1759855024; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VhViqDkwcWVSLWWD+zOBqBHO20tquMwNgbfY3Bzt4yk=;
        b=0m2M6q1jbZfJ2GWzXibrSoxsd3in9uS58AbZ+hzsdq3S+fE4ap71dX93B9B7eYoSc2
         M4q3g3pAL9lMvmFrOoP7daWSsO7hL+N9D1yRlVivJU5K+gFz2q0HshZBcnWetGihKIzJ
         smv/zHH67YocaXfX16tQ1To4AWijwvQGvq1VDw5LRdnCX7YlqGI5pNmPjg9gImZBjnL8
         YYSpDnN+3cWubuLCiWxFReozV7WSa7zZTzf4zuizuaWF8pwbMw2IBzXN2iCYL1tLTJ2W
         HyUpiFoTYXc9bHSPuVJaoCLnm6A3LIKW7+XF6l9c7dUlADtB+Rs3OhnTCup03RfYrO9g
         S88g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250224; x=1759855024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VhViqDkwcWVSLWWD+zOBqBHO20tquMwNgbfY3Bzt4yk=;
        b=W67aRMe3i6P/aAAmLOoAZ0iHSaZ428/e4xrvUwzZ1DvVylsIO291RN39NVzEJm/FDr
         xWrL9+bLvyeWPhcZzDrw7RwFIk/pQlRlXBuLoyHP8/DxXbk7u1NsZAoSu0xGU3GNF7uB
         CKk0MaSJvoygoKt76/QqWH9VhHPiNV1lKqgS6h6KFPP63gJ97Yx/ViR6HuenrA5ETL+y
         6hyTbBmNbcgqTtE+Ng1SkPiaMmX5sdouyhz0jodYwxFmc/ByT4o1KLr3HgXq+K/IaEkV
         VzifGN/Xwfcnkbu2OBaWgdjWEVEMxsWZq+Gf2uKApocUWVMKEwxW9bkJOIZw5g2qWw2K
         6svA==
X-Gm-Message-State: AOJu0YwJJaO1VssmhJPlfYPtgV4DXSBEhTeiYlvdEoVHZyIAQBuP5o2g
	pMAxaeU+BM6HBWAbBwxyh7P1/WbsSm4bICh8dnnZefwHHjL9dYVcEDLNA9fwfyIBjUzY5s5o4F4
	giXq8SsO8hhV3JFYfReRBCrXh6FK68pDagxEqUUWiFe4djsO6LD9sCWMbzLw1B33L5JlMg9IFUr
	gcsfXiibde7HsOOCAbkSdAnES99QwnNBUht5aPZQ==
X-Google-Smtp-Source: AGHT+IFNJr9lipNoSDt3DruF7rcxWQ60eYd2ESWJFpivjjPDmvUD5g41M9KiJ+nbTnZt0uYf5BR5V0buLOkY
X-Received: from pjkh7.prod.google.com ([2002:a17:90a:7107:b0:332:4129:51b2])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b50:b0:330:48d1:f90a
 with SMTP id 98e67ed59e1d1-339a6f680d9mr89247a91.27.1759250224019; Tue, 30
 Sep 2025 09:37:04 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:35 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-10-vipinsh@google.com>
Subject: [PATCH v3 9/9] KVM: selftests: Provide README.rst for KVM selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add README.rst for KVM selftest runner and explain how to use the
runner.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/runner/README.rst | 54 +++++++++++++++++++
 2 files changed, 55 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/runner/README.rst

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 548d435bde2f..83aa2fe01bac 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -4,6 +4,7 @@
 !*.c
 !*.h
 !*.py
+!*.rst
 !*.S
 !*.sh
 !*.test
diff --git a/tools/testing/selftests/kvm/runner/README.rst b/tools/testing/selftests/kvm/runner/README.rst
new file mode 100644
index 000000000000..83b071c0a0e6
--- /dev/null
+++ b/tools/testing/selftests/kvm/runner/README.rst
@@ -0,0 +1,54 @@
+KVM Selftest Runner
+===================
+
+KVM selftest runner is highly configurable test executor that allows to run
+tests with different configurations (not just the default), parallely, save
+output to disk hierarchically, control what gets printed on console, provide
+execution status.
+
+To generate default tests use::
+
+  # make tests_install
+
+This will create ``testcases_default_gen`` directory which will have testcases
+in `default.test` files. Each KVM selftest will have a directory in  which
+`default.test` file will be created with executable path relative to KVM
+selftest root directory i.e. `/tools/testing/selftests/kvm`. For example, the
+`dirty_log_perf_test` will have::
+
+  # cat testcase_default_gen/dirty_log_perf_test/default.test
+  dirty_log_perf_test
+
+Runner will execute `dirty_log_perf_test`. Testcases files can also provide
+extra arguments to the test::
+
+  # cat tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
+  dirty_log_perf_test -x 2 -v 5 -i 10
+
+In this case runner will execute the `dirty_log_perf_test` with the options.
+
+Example
+=======
+
+To see all of the options::
+
+  # python3 runner -h
+
+To run all of the default tests::
+
+  # python3 runner -d testcases_default_gen
+
+To run tests parallely::
+
+  # python3 runner -d testcases_default_gen -j 40
+
+To print only passed test status and failed test stderr::
+
+  # python3 runner -d testcases_default_gen --print-passed status \
+  --print-failed stderr
+
+To run tests binary which are in some other directory (out of tree builds)::
+
+  # python3 runner -d testcases_default_gen -p /path/to/binaries
+
+
-- 
2.51.0.618.g983fd99d29-goog


