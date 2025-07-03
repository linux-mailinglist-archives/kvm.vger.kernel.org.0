Return-Path: <kvm+bounces-51520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A750AAF7F07
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CDCF1C44C54
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3A2B2D5420;
	Thu,  3 Jul 2025 17:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JmoQvxKv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B1A2BEC5C
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751564171; cv=none; b=jxCThKsnGhfHO0ekpW1BHsz9PvbxN3OG3mbJbcyVi6WDyZDV/9+DE7FaIKLfJhx2N+0ltjEfLroLtV8MmcsJXoQYoAC6dCr0NfFt5RHdxTYC0mrehGlAQyYxqPE3Cz4W2QVZRFTMcPOEhtzstSoogG+WMpE74RiAatnBWvsuVN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751564171; c=relaxed/simple;
	bh=lxBl3Lj53H/hrilNxdjOVHBHoWK5AnCCW2qFhUEd3mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aru5Hpn81gijQKgmP+RqWWi2V4j9SfsYsvn99qO606095LmT3dT2I6AkQJ09ARUM2s/lcabCIvZuatpzZiAj7vdQWzsST2nt192FRfmrPm1ceoL/L9obYHRGRaD33JdmL8zydWM5fWgpP3E6qUAn3qrzZlSPxoIv8vbDhXWwd3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JmoQvxKv; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a5257748e1so39638f8f.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751564167; x=1752168967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kicmersWSEwnQxJBAM0jhQPBISipbGX/ta4y64dxhJM=;
        b=JmoQvxKvwikVxV9/fnCVhAJlnQ0fG09WCZPbRf7zHQ3XTAP+68nPaAqid2PxyqlYoT
         ymDjkGr3wOqaIodAiroQFZRi46dbjQQhp45Bll8RpFJfHpEjzCynat7UzEpObPqoCQzA
         GWyA2nwBggFzdlhC0tPFo+6yI3vZrUVPtUeDIgT2PGRIrHmDRlI5x+I+ELcX6uPS71a0
         S3PUnT6C/6P+4BCPzXgqgBqdi30+WRfAihHtBZDSrjzsDsb0Sz9WZdvvwF0r2wuKJVbf
         y5l9yxPGBvL5YIJpNwhsow8Y4EfP3yTH0+lUgjjq7id5NuJ/9riUuVzaPyS8XyHGD8VM
         bB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751564167; x=1752168967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kicmersWSEwnQxJBAM0jhQPBISipbGX/ta4y64dxhJM=;
        b=QnO3BLkjpVE0ufkInHd8l1a1s+k79bKrBFns7X/3J5S/nL6Pkh20LwdRvK/wAe4vSW
         EoJxjmwX0TQzMGXRrl3i0TbWkcrN17sdDFs+IZ6pnkDpFY/YL7mFzKbgq3yirgtSw3//
         J/N/I057GOjLi2LgSDyIdsKlUYIkjbpRF+xkg+1BcMzQlpUUkLf7mqoBi9g0/dpqdKKH
         fUE/tVL1GF26PnZCDmXLtIKLnEk8l10qWPhfcwitiTT4KXtOZozVvCviWBjZPeTorWQy
         yCHW1XjA1p7Mdh+4oOJd3rt48mKgsuHwafqEP5wDLuwTpvMQGxghzQv0QQspk0taouX5
         NDLw==
X-Forwarded-Encrypted: i=1; AJvYcCXH+iF4hxCAgAOzsPEuSAPMJMqMDz8OBaOY8fzPTbQ1l/7+XcFMJ26aw0LBQThLKMgTk6c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx209XCM2dST+8Z+Zq6eSTqz0xn4oa1Hwrt335maEgO7WNQSBcB
	5oQShFAVsyRm2gTfr0hYpcIx5PuK6XR/ntdRn9uxDZOdslnarzjXA7YDKXywL8+vRAA=
X-Gm-Gg: ASbGncv36n0tsXeDsImw1TeY9+FFkpam8ansd+ptL8ZHV9eLzASyXxq5twsZREFXqos
	d4DCoz5FKiWCyEZP3OGAeQvKoBsSmNEjuGZAoEBuYmpbzPe+PHKmaiAlEOGFKFW814uE9jitBJb
	exuavISN9GXLehdcjGVy/r3LQ2UbTo97j+HrWELfymfMd6Xkfl//Ixj3w3XUOS9znV3f9kdodgJ
	aph6kFuj5gXuKPUFAupP7sgbN2VJXs/joEKACSoppCQprWy1/lcprHcW3QLiCsW7BGEWU+k11hi
	a0LIatxArPCQoak4UgfabIOz1wQQy4kypP9sitD6r8m6JH7Er1gSPR94sFuHObyvD0lSrn24SSo
	hS0veYze+wlgj9TlqmJewKCRL1eS8JzWFGLi5
X-Google-Smtp-Source: AGHT+IG0qQcqhoVbvfzfM31MKr9oMRdxY420l+gPXOEgJg6BZR9qG6bnUXWA/grDOvUug904CFLjvQ==
X-Received: by 2002:a5d:5f81:0:b0:3aa:ab93:c7de with SMTP id ffacd0b85a97d-3b20095ce9dmr6768426f8f.34.1751564167394;
        Thu, 03 Jul 2025 10:36:07 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b47225afd4sm309707f8f.83.2025.07.03.10.36.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 10:36:06 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>,
	kvm@vger.kernel.org
Subject: [PATCH v6 36/39] accel: Pass AccelState argument to gdbstub_supported_sstep_flags()
Date: Thu,  3 Jul 2025 19:32:42 +0200
Message-ID: <20250703173248.44995-37-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703173248.44995-1-philmd@linaro.org>
References: <20250703173248.44995-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In order to have AccelClass methods instrospect their state,
we need to pass AccelState by argument.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/qemu/accel.h | 2 +-
 accel/accel-common.c | 2 +-
 accel/hvf/hvf-all.c  | 2 +-
 accel/kvm/kvm-all.c  | 2 +-
 accel/tcg/tcg-all.c  | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index 19ccc5ef6a1..3c6350d6d63 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -52,7 +52,7 @@ typedef struct AccelClass {
 
     /* gdbstub related hooks */
     bool (*supports_guest_debug)(AccelState *as);
-    int (*gdbstub_supported_sstep_flags)(void);
+    int (*gdbstub_supported_sstep_flags)(AccelState *as);
 
     bool *allowed;
     /*
diff --git a/accel/accel-common.c b/accel/accel-common.c
index 56d88940f92..b3fbe3216aa 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -125,7 +125,7 @@ int accel_supported_gdbstub_sstep_flags(void)
     AccelState *accel = current_accel();
     AccelClass *acc = ACCEL_GET_CLASS(accel);
     if (acc->gdbstub_supported_sstep_flags) {
-        return acc->gdbstub_supported_sstep_flags();
+        return acc->gdbstub_supported_sstep_flags(accel);
     }
     return 0;
 }
diff --git a/accel/hvf/hvf-all.c b/accel/hvf/hvf-all.c
index 2cf2b18fd23..4fae4c79805 100644
--- a/accel/hvf/hvf-all.c
+++ b/accel/hvf/hvf-all.c
@@ -281,7 +281,7 @@ static int hvf_accel_init(AccelState *as, MachineState *ms)
     return hvf_arch_init();
 }
 
-static int hvf_gdbstub_sstep_flags(void)
+static int hvf_gdbstub_sstep_flags(AccelState *as)
 {
     return SSTEP_ENABLE | SSTEP_NOIRQ;
 }
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f1c3d4d27c7..9d1dc56d7e8 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3985,7 +3985,7 @@ static bool kvm_cpus_are_resettable(AccelState *as)
  * Returns: SSTEP_* flags that KVM supports for guest debug. The
  * support is probed during kvm_init()
  */
-static int kvm_gdbstub_sstep_flags(void)
+static int kvm_gdbstub_sstep_flags(AccelState *as)
 {
     return kvm_sstep_flags;
 }
diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
index 969c50c87ea..93972bc0919 100644
--- a/accel/tcg/tcg-all.c
+++ b/accel/tcg/tcg-all.c
@@ -224,7 +224,7 @@ static bool tcg_supports_guest_debug(AccelState *as)
     return true;
 }
 
-static int tcg_gdbstub_supported_sstep_flags(void)
+static int tcg_gdbstub_supported_sstep_flags(AccelState *as)
 {
     /*
      * In replay mode all events will come from the log and can't be
-- 
2.49.0


