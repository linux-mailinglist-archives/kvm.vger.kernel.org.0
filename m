Return-Path: <kvm+bounces-42938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29228A80C43
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 15:30:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FEFA501768
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 13:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86F813B284;
	Tue,  8 Apr 2025 13:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="b9Bizyan"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E752A1A4
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 13:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744118467; cv=none; b=A/CIrNWJlQtCYf222JUH8vo5qBWm/6m6f00w4oHYNtZiDqB1qjKzfBtgNYyWy9KHPoC8QyZ7E1wSvlq8bzgTg7wny+/wGUKXnsMJYct/kEOvgeHvnK+TVpZBBxfbI21V4GcpGj5YOoMuZY1maGLVmwg46ZBym4K8nxLSfGkAVYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744118467; c=relaxed/simple;
	bh=OSfxs5iCrFQRqvReCu5va442baMyJ2MCQdEE5yR8Qso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7Z2BpILikP4lxK+FhsMZz0rdGpQZMlxKOUW088oVbjd00DBf9nCqkKxOewRCEZoK1hjUeOF2sbVvrC4tLqKZDsQujJidKkXM6X28NNYAQwLNbmpEcm6IjugnKx9SoSg2F+ytDnT10F/UZBr3poGzjwVTaOXl2NVhLYPIIb/+M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=b9Bizyan; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3914a5def6bso3293865f8f.1
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 06:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744118463; x=1744723263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ilwSm1opvpysUjixabDWM8lrwnBUd7ZKRR02fY60WCw=;
        b=b9BizyanhjZPMKwPSip7Pz9jWZIDp1QIwSjz8tYSfSmsfuzj1ymN0IRdXA3UNHbatn
         DoLEbVeWUq7tNXM/jUs1z15HoMocPeRHQoQunmWvKsFqghxY/TbGBMHgy+Xdgn4w2hbH
         sGhmYZ8It3H3Z2/zJxanjR2G46CeM6S08+6v9Odkas6gEBcPOabPoTSyDC+pGgd6pcP0
         7Qa+wtZj6fbV6bpRfcUVe/eXkeKUTipY8UlKA+dhGV7ko2PqBJvRXjRSCEcGDj2Tf6I0
         b4xOhlUgQN2HXW7JEpcW4kRKJlUjPlnUvt8XaSVuwwv8vAKbm5Ji426flUbYtsCYk8Md
         fGbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744118463; x=1744723263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ilwSm1opvpysUjixabDWM8lrwnBUd7ZKRR02fY60WCw=;
        b=GYdT1oTkrFgvNjzqInYZPESc/jjzC1TYJgmfSuCtWP0rEq1MYqsYdrxLR5UFop+izq
         wmUeL0HUCvv/y08rGGWGMJQGT5c+sikIMO0IFQV+1XWRb6AYRRZELZu4iSllwHi6J9Or
         PhBjfVo2Y6nO+DmD1VHdagMnbeO7Q6sn+jCC/lHOrFgQaZTcHF6xGx+ZLUGqXbM5hziq
         nXL/ofLJqH8iEhkzzM+AiglcJ47y/jJFElI9UIWQJXliJYkQqPtM2FhRz3ol16fJy9l2
         +1kMT/yuYWzrR29YSewyuWZrOW4BcjCxQtgbPf+AJQVVH0Dtn5HzaLA/AozRc2CNdJMv
         mL/w==
X-Forwarded-Encrypted: i=1; AJvYcCUClDl5TkzwhjhXEn+Lh4hG8l1fb9nwNhVX1Sd4MRB4ssUCKs06trzle0Vk/uDfZDVFDBg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx64BBftoZFGWUpzP9G5uEoFi9rW9nPhexGGIfq6r917LOmMNhh
	18LqlwWJJR/462vY83pgwgZTM6QwcG+zlSZ6BWpn+DI273yCrkq+HjK15g4WhKI=
X-Gm-Gg: ASbGncsJMnTJ6MNuqPt7NsDALbvOmmZ8W6VDNvmCjfqC7ZjIjGOueav3DH+bLBfE9xO
	IYetw2zw6G0InjBhvnfIihvmyS62n9aOfLiUYJ/gLg4JudDcUcmf/iZuAFF6oZn6/BVG44JSPlH
	wVvKqs7R0PN6pCCtxE/FrGZNt0KGKu7r9D9M+jdlQbEGRrHXU/ktmrTB97O/9cko96ZaOJeqYkk
	D7jhgb8VHmqurWBg0ue1b+f6GMzI/TWWjirmzsyrHMazLSr/gXg2pDtvgcDxbvR6hzsjRS0ZQFI
	JsOHuyA94byNQAfll3nPhIMyzNZ3C1sytWMp2/6v9f8q/s9IcCT10fcLsC5AaSE=
X-Google-Smtp-Source: AGHT+IFNyeSMXRQkAbHJWisVmPMP4/fHS+R5uIOxb+upWzY4DBBeBmZDM0lxIP3xSXgDasJ13TRs/Q==
X-Received: by 2002:a05:6000:4203:b0:391:3998:2660 with SMTP id ffacd0b85a97d-39cb35759c8mr13486863f8f.7.1744118463310;
        Tue, 08 Apr 2025 06:21:03 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec36699e0sm162159705e9.35.2025.04.08.06.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 06:21:02 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v4 2/5] configure: arm/arm64: Display the correct default processor
Date: Tue,  8 Apr 2025 14:20:51 +0100
Message-ID: <20250408132053.2397018-4-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408132053.2397018-2-jean-philippe@linaro.org>
References: <20250408132053.2397018-2-jean-philippe@linaro.org>
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
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 configure | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/configure b/configure
index 010c68ff..b4875ef3 100755
--- a/configure
+++ b/configure
@@ -5,6 +5,24 @@ if [ -z "${BASH_VERSINFO[0]}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ] ; then
     exit 1
 fi
 
+# Return the default CPU type to compile for
+function get_default_processor()
+{
+    local arch="$1"
+
+    case "$arch" in
+    "arm")
+        echo "cortex-a15"
+        ;;
+    "arm64")
+        echo "cortex-a57"
+        ;;
+    *)
+        echo "$arch"
+        ;;
+    esac
+}
+
 srcdir=$(cd "$(dirname "$0")"; pwd)
 prefix=/usr/local
 cc=gcc
@@ -44,13 +62,14 @@ fi
 
 usage() {
     [ "$arch" = "aarch64" ] && arch="arm64"
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
@@ -326,13 +345,8 @@ if [ "$earlycon" ]; then
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
2.49.0


