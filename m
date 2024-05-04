Return-Path: <kvm+bounces-16571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 676168BBB3D
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:29:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D47C61F2215C
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A72A524B2A;
	Sat,  4 May 2024 12:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N3xo/p1u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948C422EF4
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825763; cv=none; b=qvbNH6o6PEFttVDjDrjorB+ahK+7bLKR2o+wOC8nykmPbiu8erVQJsTXCIlLJPn9yUbyQChcKyZYnvqWf6Od6Uv5JUW8DDkAU787Nnb7fDWtdVkcvDfElNl/UJJam8TGEWmevGC6CbBus8v1MnLI91HQPlDv2z79L8HhcqK3YPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825763; c=relaxed/simple;
	bh=fpWzryLghyrAk5x6WRzB4rYrtl36cjaHhu12zR9TmWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbdzMIQMSv6pUAfhH9Pwt41DAwF2IGD8vCzzQSCmIn5Gpg7WVDjBV0fPecGiYhP1PN8lhTl6fkW9ckz8zpLnSfeA8u0IAS1houJpBajay/7soev7Q1dbLZHRCRxIFB38L56xZiIVbbWdRs24eYuiS8+jSDT3SPRaoBmTRWQcMp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N3xo/p1u; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e46dcd8feaso259792b3a.2
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825762; x=1715430562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z2oN58zMGF7viCDdv81NUvK9SW9hozVqH9VBnYqZITI=;
        b=N3xo/p1uQbH1+5Sr1ZAfG784xoSIdMcb+3eqNE5rpnhC3dK9tf38ojcuXUKWfHgnV8
         emqqcKnUXZoT+ri9cbxtiy2JiBeKriGpWByV7OQ4/yWLHZemTU+xQk17gNbJqmtSlFZJ
         yQ51r2hPSLoo4R/CZT9UykEusgO/h5waPL1/jJzxWmV4WAKFMk+CdnsD5YMCThQFcX9l
         M7hfH0dhsfdeXRDgmV7NiKH4TYLc1ESFTKEoz6YXKoRgQwT2o69NFQDg6i+pFzPh3Nlz
         qgXfHodyww1v/MrsXrKSygN8ljcsKmUkQuQRDTuDuX1Jw7NF3dcdo5OEwbOIfug99Pmr
         0ivg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825762; x=1715430562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z2oN58zMGF7viCDdv81NUvK9SW9hozVqH9VBnYqZITI=;
        b=B9IrZaiZIIh+b1X/okICcuMW9DhZqLVpdCUAMv+5p9vRlLOnhUFR3Q8mdqVB3MtLem
         lvAKpr1elZpUaYygW/5TKN6X9yAbIeS7+ed+s3FuaQwcR2o8rc+B7ywu+nFMLyhdsJuY
         5r8VTfGoiDHEZLgo0YZWo2E1gTZ5W6C8+04Ps1Cf85CAdO/rWlRn/xIjlvuapE4WP740
         84Q05NX7jlqCq4BzFECPmvLgMbHwM8rnS8jR2zmBmwhjl3TskyGtq0zatE1nR2qp8Vt/
         G6jHkDjoSOgySALOld7nQ28oMBeZ+pQpyyUCMt4zkYLAWRa1DiAbjxVGms53f3JunhWd
         AFTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWko3pYBabVw+nucPY6UZQ20EBtg/BvznhMvPAWx3w9LUdVpyXLc92mwmDRYofgjWMVCtNROb5F/O0lVvOVHAvoWJmm
X-Gm-Message-State: AOJu0YyR+fIEPtmdcv/t89gedt9+EglkIf7UX6T2hIYyZmnZ5frOr0+g
	fju4KgND0RDy6yPrLMFI8Z2tYqfxvmN79HN+j3kbB84Hqmb1nugs
X-Google-Smtp-Source: AGHT+IFpF2KbAJADbX+vvZ9NgIXRALb0JcOtlo9568C/7j2tvWKU/CYfftgPnveWWLcunWzlgXYF+A==
X-Received: by 2002:a05:6a20:8410:b0:1ae:3f11:328e with SMTP id c16-20020a056a20841000b001ae3f11328emr5818088pzd.20.1714825761811;
        Sat, 04 May 2024 05:29:21 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:29:21 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 08/31] scripts: Accommodate powerpc powernv machine differences
Date: Sat,  4 May 2024 22:28:14 +1000
Message-ID: <20240504122841.1177683-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
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
index 699736926..f562de9f4 100644
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
index 0c96d6ea2..4b9c7d6b7 100644
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
@@ -20,7 +20,9 @@ premature_failure()
     log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
 
     echo "$log" | grep "_NO_FILE_4Uhere_" |
-        grep -q -e "could not \(load\|open\) kernel" -e "error loading" -e "failed to load" &&
+        grep -q -e "[Cc]ould not \(load\|open\) kernel" \
+                -e "error loading" \
+                -e "failed to load" &&
         return 1
 
     RUNTIME_log_stderr <<< "$log"
-- 
2.43.0


