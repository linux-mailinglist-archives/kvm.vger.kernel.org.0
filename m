Return-Path: <kvm+bounces-41079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 203EFA6154A
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 16:51:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E1EA7ACD9B
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A625B202F72;
	Fri, 14 Mar 2025 15:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CoL/neej"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3A420296A
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 15:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967479; cv=none; b=MBuEwq6zcQCYEK9GcPPIYnHezGKZpTNQ0rZvxJTgo79Cutu7HyU/x44fRU40XKp3sXkv/kye0VSVbnNGEOxhWP1EM7lCudJA2bO1jzzG9qMCt5M22Hu91CBrQ9aZdrd7xgkcSv1CITr/pgqrEhDYLitEBK4bIYdpLciTmL9tfX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967479; c=relaxed/simple;
	bh=T9x3c3QuJ2C9hpuOVam04QMDNACk2y6/xzXy91lyRNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXa6ezmXZD3t9t4uqW7LUQfjlqTZUCdbgyIamVa6LW70KNfbCyV8C4c8n4l+Cs866Q6s0CH9tTNn8428ugJluJt4sLGjXnpI5hCpqpRUnuZMWDcqwck6vUt86KLdv789x0UjaBojziG23z2UqZn7HtNtxdEjKDzn53PfkBFnYrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CoL/neej; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43ce71582e9so15325175e9.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 08:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741967476; x=1742572276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x6KdM0HrFbl7EBCoEX5NDExMeE7MkqEbvD9eQdkyg/A=;
        b=CoL/neejGvW75VW7En3KadGfyYPXm8P2NEp6SwpG8c29IrqJ2RQ4gH0hLcA9y7NHQ+
         cXSKJ5CSV8phDM9kgjDtvcfOAa5+yZRG3ACe/kNfwo02TYUB/XDdfqGAbHQrPDa7KHq7
         cqtI45OZoXnmWACU7N33CjjWiKUV475856U6efF1EEwYpVHJ1EKGIvFreo8wly9To4EC
         Qk8Wo/+7CWVaX7xVDA04cGd8JvJIEkhJxQQEMbdo4xkHg1HwJbhBxRzAqAzb2FH+h2jv
         dSVSMChaLAuql0MjGsDTIXKCRyRVb44Fd67LXUq9EQqb9oWdcBotPMqTdOCYhrD14Emw
         2trw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741967476; x=1742572276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6KdM0HrFbl7EBCoEX5NDExMeE7MkqEbvD9eQdkyg/A=;
        b=g+NWmb/FH96KKsU/hBWxbHADQGNe/7gbv8+bSvE07n/lhjP7whAXMOEERjisna0iY4
         opHg8QroNfYjvY8c3J8JhuyXu1zPxDWhGlTIiVfG4pCWhSotffj/re0eFot0noAD1J75
         uui3q9Ib27S6IGlJEsbVUenb0TXkDxT6LLfZ/U5Swpw3StLqUklwwrlqpMHEtQvlnEMN
         mxe7sSKeZQdL9GWp4GWanWYBYuuIQ3O2eJKx7ZWotyNrrn/0Td84BTEuJXpQ9sT8fzzi
         g5BzAkj6L+FVXLYGQDOz+IbWhHGC+mb4/MsFrqPkfrbdy5E8z/uDtPQP6rRkwPBEFA/M
         HHbg==
X-Forwarded-Encrypted: i=1; AJvYcCUIJZM+n/sz1mcQhjEsqn4QjgFxriC+Z+o9IIiAZtoyroT8Dsqu3+zQzI7janjyJCQctzQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwS/R3CAnvrhYOViJADUS2i+gdEV0LipKbMbAGYmaXhq+IswD6R
	ghQrAsQj3pOBc2j98bcTxxraTwb1JndBS6pP8g+k7AovlUEhg6zqfCcTPlyJay0=
X-Gm-Gg: ASbGnctFgkmNd5d63xBfMrbHxoi2FjI5JcRnHJ217MyiJF5NomETcD6vhmLet/pmEZY
	zF4pMVEBy2QGmdxxCAn16TKp3xeGPeuAHSWfYVA1oezpPsp5WnOg+KL2yDlGbuT5YDurDwi4Y8X
	KuxbsdOZVbcZNA95OsFlTcgCm+ge8mdoQ1L/yDicfHJ63hAc3J/MYx5i6CQ671e/AMZcSnXp+QK
	YzsPD5S4cDGc6wbg7q5WnLFq1Sy/X5lD6AqcnjIayT7Y2jBVsPdIkLzc1N+QhxAnRYSn9oNmig9
	AiOodRXvy9ueTVcqfb8DSn2xFyYDqcIKTr4arpL1hk04OhP7rvIr7s71y2k7R4r7ASWaafGg9Q=
	=
X-Google-Smtp-Source: AGHT+IGqjIk/FKjEZDkdrc3AqaWCRNKHzrwFDig+752nD7yLPvk8XeA3buiKLcR8gQHXba5VpmxCpA==
X-Received: by 2002:a05:600c:3b10:b0:43d:ed:acd5 with SMTP id 5b1f17b1804b1-43d1ec78437mr43895775e9.10.1741967475876;
        Fri, 14 Mar 2025 08:51:15 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d21d67819sm15249945e9.21.2025.03.14.08.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 08:51:15 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com
Subject: [kvm-unit-tests PATCH v2 2/5] configure: arm/arm64: Display the correct default processor
Date: Fri, 14 Mar 2025 15:49:02 +0000
Message-ID: <20250314154904.3946484-4-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250314154904.3946484-2-jean-philippe@linaro.org>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandru Elisei <alexandru.elisei@arm.com>

The help text for the --processor option displays the architecture name as
the default processor type. But the default for arm is cortex-a15, and for
arm64 is cortex-a57. Teach configure to display the correct default
processor type for these two architectures.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 configure | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/configure b/configure
index dc3413fc..5306bad3 100755
--- a/configure
+++ b/configure
@@ -5,6 +5,24 @@ if [ -z "${BASH_VERSINFO[0]}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ] ; then
     exit 1
 fi
 
+function get_default_processor()
+{
+    local arch="$1"
+
+    case "$arch" in
+    "arm")
+        default_processor="cortex-a15"
+        ;;
+    "arm64")
+        default_processor="cortex-a57"
+        ;;
+    *)
+        default_processor=$arch
+    esac
+
+    echo "$default_processor"
+}
+
 srcdir=$(cd "$(dirname "$0")"; pwd)
 prefix=/usr/local
 cc=gcc
@@ -43,13 +61,14 @@ else
 fi
 
 usage() {
+    [ -z "$processor" ] && processor=$(get_default_processor $arch)
     cat <<-EOF
 	Usage: $0 [options]
 
 	Options include:
 	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
 	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
-	    --processor=PROCESSOR  processor to compile for ($arch)
+	    --processor=PROCESSOR  processor to compile for ($processor)
 	    --target=TARGET        target platform that the tests will be running on (qemu or
 	                           kvmtool, default is qemu) (arm/arm64 only)
 	    --cross-prefix=PREFIX  cross compiler prefix
@@ -319,13 +338,8 @@ if [ "$earlycon" ]; then
     fi
 fi
 
-[ -z "$processor" ] && processor="$arch"
-
-if [ "$processor" = "arm64" ]; then
-    processor="cortex-a57"
-elif [ "$processor" = "arm" ]; then
-    processor="cortex-a15"
-fi
+# $arch will have changed when cross-compiling.
+[ -z "$processor" ] && processor=$(get_default_processor $arch)
 
 if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
-- 
2.48.1


