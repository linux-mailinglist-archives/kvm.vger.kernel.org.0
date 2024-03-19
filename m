Return-Path: <kvm+bounces-12091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DCE887F8AE
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:01:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 409221C21A2C
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C3B853E37;
	Tue, 19 Mar 2024 08:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rc6LxP5f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E50A54673
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835232; cv=none; b=dnocxpQTXTpSIcCV7XtM/twReucIwqrpM70G/UBJEJJV2iivpsA+rN1AI1oqSugQHIoUMIiRqy0lWvnUHPRSjbLOVVzjuaixAhE4m7nz69QcYVMhvFh/WxCN3a4b5Okq4qXvO5kOIGmvL0sqyF4NB7yKIMw+OlH4iqqChxJSv+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835232; c=relaxed/simple;
	bh=fBbeS05GPue1lWBfNWG9a5i+q+nm+o7I77u7DPRlU7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcE7lVqe2oaOssfOHF/itl5XmX3BVcRTBaUqq2hwWsFERHXMOCABAOARKUJmYTk7hp1C0hfrCzcVn3dDTtoAL5jouQJXM3c8R9+YkuWZ1dhckrfUEFyTJoA4vOoqZHvqdrlfergegQ6uU0qjAl+Nsb+csSHJu1fVzZXgroDo12s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rc6LxP5f; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e6082eab17so4598763b3a.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835231; x=1711440031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iE7qlIRnEcs8kYKgLfZ1UH5UWYqf3U0H7OylMM9X6hk=;
        b=Rc6LxP5f/c6XgJacPzz8M3KO3sW9Vvy3Wz0PYTcxKeIUgLDH5Hd+deHQ5rY/GvULtk
         Eg62/PXuSAy3THPvRcTOY/wdQFtQNS+BzRWKZdcZcHAhR4jFQAMBVnGSXDJZJon+CikM
         HwUDgsdTSiruxIrvajB+C63XSq5ycKl9CalsqEo8dQUtIXT5oSL8tWXcupzvH2wuoGAA
         bC7tHgSSpTm4ldSI2AgFlh1SAZto7z2HpGfl7YA3PnmMPVy56RFC8nXCAo+B7KcGH7k8
         O3nyvBqU2nvOoHQi/GycnLQVSOp3cdOXo2kpZZlcoeU04PuQzoHliGmA1A53yciT3YLf
         bvRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835231; x=1711440031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iE7qlIRnEcs8kYKgLfZ1UH5UWYqf3U0H7OylMM9X6hk=;
        b=LPR6ajb+qaHsUCTnNHxbzQgZrKK+mDhZJpbhZUvItWBauuNmX7g0hgJJ8ZA2QiRaxR
         60AvKhNWCDgKkpB4I6xPKrd4zkXbI67L4zFHLB8q3veQ3KNtByiqZB8dK+VWJdW6sWgP
         dDAL0CjixvrkjUVW0wHzfXbv5rW7jG43IxGyRnQf1Qltd0m1UMyHnB3ZFDLDyoQPzVV4
         rZwRaGOEpU9H5KfxLtDX0FzAjpoA2JHiCrIUNHVn5ZWycIKS/uJaF1fo6JEAyjk13yVn
         EvKvHSnyfYxq2hJkE5rT3jq4wLAwxu6qdTR7XmLGOV/+wOzLpgpvy+UtkFCGPv1G8TZS
         thSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXj6bzI5yy9pvKuvMoG1ES2p+oEn9NhKI8/8eVLDjCJ/pZg6cUpG4RrNRKoMKGQCIKMWIUAzn2CoY5ZgEy234I4bu2E
X-Gm-Message-State: AOJu0Yxa4umyE+gsyWK3N6bskaHvrpsrvs2kmvFtD+uNKlp2XN4Miau+
	BfDE895EFxeoIk9oNE2BhVN3pm9Jaat8bvjySkeiSz7b6oryXd4AmZt3rOuzGrY=
X-Google-Smtp-Source: AGHT+IE3j83vagr9YQNSHx4O3hggYW3w01Qxw3BclgKX6y9IBAmrQryPE+Xgc1ShN/cEbvm0lP5Q4g==
X-Received: by 2002:a05:6a00:b4c:b0:6e6:f799:5480 with SMTP id p12-20020a056a000b4c00b006e6f7995480mr12594586pfo.4.1710835230661;
        Tue, 19 Mar 2024 01:00:30 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:00:30 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 15/35] scripts: Accommodate powerpc powernv machine differences
Date: Tue, 19 Mar 2024 17:59:06 +1000
Message-ID: <20240319075926.2422707-16-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
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
2.42.0


