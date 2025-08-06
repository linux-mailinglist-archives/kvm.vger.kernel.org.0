Return-Path: <kvm+bounces-54208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55A77B1CF2E
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 00:52:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06AAF18C4F4F
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B00230BF6;
	Wed,  6 Aug 2025 22:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rW7oFrSm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E752522AE7A
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 22:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754520723; cv=none; b=lpUMCkbz7TcJpohD8ieC3Xju3r+aNFFrhzZGF1f16iZ+w6wh+sCd2r8lTY/TQ4pLG+f2M/UcA6Hl3yryDyboUa6i4Es3MrNWWC4yIU75DCZsRmfWey41xGvOW6uCC+LEsKjTNs+H1aJc/9VwmkzHqnmtbgRapoIj/u3GPUq0pJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754520723; c=relaxed/simple;
	bh=S0khaiV2Yjbn0vrnETjyIgfSHs7y3d46GzkAPO4gkk8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=N8axAwbG7AlBrXc/Wwt2IRnsimGrMsVh1WCCt2iWf2XjE0NK3qeAOX87S1QaJCkMQYFcJ35IWQ7FcOyfPxO7PdfEP/SOqZTbZgN03oLqykZpaGeI44YGI6PSLf6HaNAdWH1BZqpByGIMrPEJYmcia9xzEOhEMyFaKHeS5iuP6kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rW7oFrSm; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f5f70a07bso565426a91.3
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 15:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754520721; x=1755125521; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nb/+hiSIBqzVp6CSex90Vi5aXgUoBso6lv3HIdZ3rLE=;
        b=rW7oFrSmwKPZEvrLM7LNn25xNZlRuAPz73NkK8FexQPbl2SBYUfz2sU2xlfLiEYHiq
         HuIdeYMfqJoZHOfWgfQl7ViUXDu1Mtl6SNmPw+evMTFXBNfEWoly+X7lS1/WpLAD4qSY
         Cj1CTw8ctWHj9Fwv5PKvnTqY+VOyAy+5/dQ6F426+DoS7UFXtOQ6f3K9CElmIccHhQdG
         glpt0v3hPNqi07yj5TOMPY+7V6thOizbSm4PzWQ72GVhVrUmcPD6bGzkl6NGFN3iA1TH
         DUiBJDbyqOWFBz6Cy2ZSNUjP3mhlxuVOmON2+xwmSXDc10cMNoY8hxF/LjsJszLZYTvy
         pQhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754520721; x=1755125521;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nb/+hiSIBqzVp6CSex90Vi5aXgUoBso6lv3HIdZ3rLE=;
        b=LjKGbLXYAXP3TWS0CnUwJN1P3DIkSGpIQ6XsY2t6spI1dGdPCtL6Suqw1SdGXCJvfi
         wwel4D8Kw38R4GmL+GQkSTZ6e8cwulwo2lj9PKZAA9UHwkJgfiDduMHckebRySrquIzg
         RlYNCg7vOkyjMwQlxlf8vHL8TxSvCa8CUghMNR2AMsIBQ0r2EKPb4rqzhssS75PrxPuf
         IQm5Y/aNd84C/jbGNE7GXjDbuM5u6SGxFR57NwkNEx8lLdDDOVq9mM7zg6ZR9itX2sZ/
         VPjTuiHa2AihtvEOPrDnCrnTsAfLw1OOT9MJu1GyXornOc7STQkBy9RwgqYSYM3IZqxg
         CWXg==
X-Gm-Message-State: AOJu0YzysARIOQYrb3bUN40Z2eCl1SiG14gS4Zu0NdNxVr2b5yuaQIMQ
	DGPDweze60hi6ZVCNgwC/XIYZgZTs/X0PlsuV7364C3gYJd+RU8YVy8HTGgXXDrM2J7YVFjUuX6
	rwIixxw==
X-Google-Smtp-Source: AGHT+IEW0Iq87ZeOVm0vGfsBGLoOolJN4ayD/9hByHJThL7Q0jxR2SZQ2q7ZCQ+ffQ8GezO+fBMLEhiVT8U=
X-Received: from pjpq9.prod.google.com ([2002:a17:90a:a009:b0:31e:cee1:4d04])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4cc1:b0:31f:59d1:85be
 with SMTP id 98e67ed59e1d1-3216756d193mr5768264a91.24.1754520721324; Wed, 06
 Aug 2025 15:52:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 15:51:59 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806225159.1687326-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Move Intel and AMD module param helpers to x86/processor.h
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move the x86 specific helpers for getting kvm_{amd,intel} module params to
x86 where they belong.  Expose the module-agnostic helpers globally, there
is nothing secret about the logic.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 17 ++++++----
 .../selftests/kvm/include/x86/processor.h     | 20 +++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 34 ++-----------------
 3 files changed, 33 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 23a506d7eca3..652ac01e1adc 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -260,13 +260,18 @@ int __open_path_or_exit(const char *path, int flags, const char *enoent_help);
 int open_path_or_exit(const char *path, int flags);
 int open_kvm_dev_path_or_exit(void);
 
-bool get_kvm_param_bool(const char *param);
-bool get_kvm_intel_param_bool(const char *param);
-bool get_kvm_amd_param_bool(const char *param);
+int kvm_get_module_param_integer(const char *module_name, const char *param);
+bool kvm_get_module_param_bool(const char *module_name, const char *param);
 
-int get_kvm_param_integer(const char *param);
-int get_kvm_intel_param_integer(const char *param);
-int get_kvm_amd_param_integer(const char *param);
+static inline bool get_kvm_param_bool(const char *param)
+{
+	return kvm_get_module_param_bool("kvm", param);
+}
+
+static inline int get_kvm_param_integer(const char *param)
+{
+	return kvm_get_module_param_integer("kvm", param);
+}
 
 unsigned int kvm_check_cap(long cap);
 
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 2efb05c2f2fb..488d516c4f6f 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1314,6 +1314,26 @@ static inline uint8_t xsetbv_safe(uint32_t index, uint64_t value)
 
 bool kvm_is_tdp_enabled(void);
 
+static inline bool get_kvm_intel_param_bool(const char *param)
+{
+	return kvm_get_module_param_bool("kvm_intel", param);
+}
+
+static inline bool get_kvm_amd_param_bool(const char *param)
+{
+	return kvm_get_module_param_bool("kvm_amd", param);
+}
+
+static inline int get_kvm_intel_param_integer(const char *param)
+{
+	return kvm_get_module_param_integer("kvm_intel", param);
+}
+
+static inline int get_kvm_amd_param_integer(const char *param)
+{
+	return kvm_get_module_param_integer("kvm_amd", param);
+}
+
 static inline bool kvm_is_pmu_enabled(void)
 {
 	return get_kvm_param_bool("enable_pmu");
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c3f5142b0a54..b20d242ddcbe 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -95,7 +95,7 @@ static ssize_t get_module_param(const char *module_name, const char *param,
 	return bytes_read;
 }
 
-static int get_module_param_integer(const char *module_name, const char *param)
+int kvm_get_module_param_integer(const char *module_name, const char *param)
 {
 	/*
 	 * 16 bytes to hold a 64-bit value (1 byte per char), 1 byte for the
@@ -119,7 +119,7 @@ static int get_module_param_integer(const char *module_name, const char *param)
 	return atoi_paranoid(value);
 }
 
-static bool get_module_param_bool(const char *module_name, const char *param)
+bool kvm_get_module_param_bool(const char *module_name, const char *param)
 {
 	char value;
 	ssize_t r;
@@ -135,36 +135,6 @@ static bool get_module_param_bool(const char *module_name, const char *param)
 	TEST_FAIL("Unrecognized value '%c' for boolean module param", value);
 }
 
-bool get_kvm_param_bool(const char *param)
-{
-	return get_module_param_bool("kvm", param);
-}
-
-bool get_kvm_intel_param_bool(const char *param)
-{
-	return get_module_param_bool("kvm_intel", param);
-}
-
-bool get_kvm_amd_param_bool(const char *param)
-{
-	return get_module_param_bool("kvm_amd", param);
-}
-
-int get_kvm_param_integer(const char *param)
-{
-	return get_module_param_integer("kvm", param);
-}
-
-int get_kvm_intel_param_integer(const char *param)
-{
-	return get_module_param_integer("kvm_intel", param);
-}
-
-int get_kvm_amd_param_integer(const char *param)
-{
-	return get_module_param_integer("kvm_amd", param);
-}
-
 /*
  * Capability
  *

base-commit: 196d9e72c4b0bd68b74a4ec7f52d248f37d0f030
-- 
2.50.1.565.gc32cd1483b-goog


