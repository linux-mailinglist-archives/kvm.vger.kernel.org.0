Return-Path: <kvm+bounces-13655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B46038997FD
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:37:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D435F1C20BB1
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC3A15FA75;
	Fri,  5 Apr 2024 08:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e1Ui0l1I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3CC15F33A
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306209; cv=none; b=cDzl3z8KFIMW1y6bVvNqAAeWS5aFpQB3xWep/trCzruZSZBOs6sEhNqlXqNdx2w6oPx9cfHbr3O2W0Pgz/t1c3kZ5E68qZ2/43TKKSjtFrscWDXQ8rB5cpBx6uieC2dH+vrEBNjOITHf6bCLtDGqcwWshuN831Y+2IpeFuf+gDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306209; c=relaxed/simple;
	bh=QDHxMP3WpHeaQiAKgRiGrezYU0WMSgdCA20vYkGNd7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKMGcSczlH41gaMRg1RmvV5ND8qwr/eZutEHB6jjSsyOS+Vi4FT/svS1cWO3tdXvI2yLqZFsvtTslFvarfmY5Qapr2cM70cndHYx0i/1sJbMu7VRYn3dlCcFsBYQXjbC+ZKfWs0sTiT2RbLlzBjTK7DilTMFthZwaewNXof3LV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e1Ui0l1I; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6e89bdd4e3fso1019039a34.0
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306207; x=1712911007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CPh2KrH1pN0KnvIbdchGvxk45KM224D/ayF8HNf5mvs=;
        b=e1Ui0l1IeJ3pwXnLfKKufXtly6A9Jw+Hwq2EVBYZ4QJCgZvGiN3sSNkVWpNxHEPLTH
         L/6WmLqmbZVq/yMQp59BAu3mraL4taOcK51KOS2+NG4rzo2LlgvB6PBpTM6XPa/wYXwd
         +Rhqty6Ht+TqU7La+5RzYs6BmZSjhkYbwrmMtZjLTPSY8X/doVy2L93uie1NY1RC/gm9
         WGt3JaZ+gqaWdgN60+4bqLaislS5gBOiwPggfEFJd3iN+cUPpdG7aSzkXCMVPT9PhUX8
         R/6/GVLVcrYG7gRqz/5Cjty5+uADwkn1/yiHV+9hIeH02J5xrEEgKFs5tBOxiDmCAYxq
         o0kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306207; x=1712911007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CPh2KrH1pN0KnvIbdchGvxk45KM224D/ayF8HNf5mvs=;
        b=iragpdb0Hcg0gD2DHr95UEGCfnN95/lKFuzGn2Jl6BQpvo0QM+9TEylaKO4sDcPIh3
         YSzNNTVJKFJS/8PacK7wwTq9n2L6XRy4Glbh0v0iK1ljdhe9XHF/ep22HiWHsQrdwdEz
         aL93MQXeTOs2DFABUr3gXTemI3cwP52CGn8kAVX+sfqkCi8q35SLeElDHAg5B27qwbW2
         f9pss57wzreHyuy426C9vbGT8cu651gM+CwE/jHydfRoKKGjooggYdC4VYzCqTWZOPga
         Z2sHimvdkSZ26BLeDcZQTT9cDVwiqneISAKiRhHbtR6KVjberetDSRxHUQ3ZKwMNBLAu
         tBaA==
X-Forwarded-Encrypted: i=1; AJvYcCU70p3tTPGhO4/wgiYoVO9p7NIZGm0CF9mtkJpuHxnKN252l6kQqqCyKiA4L+rvv9/5Yfhgp3OPuC/EjGyNbM2lElLB
X-Gm-Message-State: AOJu0YzDnJqi00Qootcpl1CYPyNUwhii4hvG2HhIY9S2IZVaaLxtDI7s
	GgK586fbutnMoUetLh05j7VKsKDGX66tvXeQp8B2ZwJVf5/v/ob6
X-Google-Smtp-Source: AGHT+IH9gewYhR3dPOmwrOod8u5lYCnhzL769heby6OhTBOHLGjReCvX+OFbriDPQRmb2zonSVKtKA==
X-Received: by 2002:a9d:674b:0:b0:6e6:ce61:3ee3 with SMTP id w11-20020a9d674b000000b006e6ce613ee3mr737004otm.18.1712306207099;
        Fri, 05 Apr 2024 01:36:47 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:36:46 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 15/35] scripts: Accommodate powerpc powernv machine differences
Date: Fri,  5 Apr 2024 18:35:16 +1000
Message-ID: <20240405083539.374995-16-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The QEMU powerpc powernv machine has minor differences that must be
accommodated for in output parsing:

- Summary parsing must search more lines of output for the summary
  line, to accommodate OPAL message on shutdown.
- Premature failure testing must tolerate case differences in kernel
  load error message.

Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/unittests.cfg | 1 +
 scripts/runtime.bash  | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 432c81d58..4929e71a1 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -4,6 +4,7 @@
 # powerpc specifics:
 #
 # file = <name>.elf             # powerpc uses .elf files
+# machine = pseries|powernv
 ##############################################################################
 
 #
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index a66940ead..e4ad1962f 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -9,7 +9,7 @@ FAIL() { echo -ne "\e[31mFAIL\e[0m"; }
 extract_summary()
 {
     local cr=$'\r'
-    tail -3 | grep '^SUMMARY: ' | sed 's/^SUMMARY: /(/;s/'"$cr"'\{0,1\}$/)/'
+    tail -5 | grep '^SUMMARY: ' | sed 's/^SUMMARY: /(/;s/'"$cr"'\{0,1\}$/)/'
 }
 
 # We assume that QEMU is going to work if it tried to load the kernel
@@ -18,7 +18,9 @@ premature_failure()
     local log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
 
     echo "$log" | grep "_NO_FILE_4Uhere_" |
-        grep -q -e "could not \(load\|open\) kernel" -e "error loading" -e "failed to load" &&
+        grep -q -e "[Cc]ould not \(load\|open\) kernel" \
+                -e "error loading" \
+                -e "failed to load" &&
         return 1
 
     RUNTIME_log_stderr <<< "$log"
-- 
2.43.0


