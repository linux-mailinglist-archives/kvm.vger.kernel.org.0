Return-Path: <kvm+bounces-41978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B4AA70610
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 17:08:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74F473A935C
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 16:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F8ED256C8A;
	Tue, 25 Mar 2025 16:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d0wl29QB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C629F1990AB
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 16:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918874; cv=none; b=s8/mc0Zp9LX6M5egfV/PkkKcPcFA7H1yLMUUak+1qH/0iecj4TfB2EX/PQ4moXCl0MKW0F8j5XNPJGOiipMqSaCPH50Km00xAwf7Hr9hwxvxLAyiyl41y6vqJcQ9fYB258ylVFW8+Pyfag5LKteeUX0M2DsIDw69SZ4h5mi8EmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918874; c=relaxed/simple;
	bh=pCZd7GShmFREJQXP8FWM/PwyLDPr3IHAugWyScPUO4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dM89uAuckpb0vB1q+k+tQNss2bTEIhrAsJ9UqpUJJfv1ZLKpVnbgK6Sm297TXCK+g3w+PZB7BOICj1QbzKXt42pzVB0tf5r6CpIH158lAzR9H6LneDeXNvYoiYIXga8mYVo/OI+yj+3FE90nWWZNujYShpRgcFQPcUTNlEvxF+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d0wl29QB; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3913d45a148so4720767f8f.3
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 09:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742918871; x=1743523671; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rb9ebUJ9N7Jt+0/wSlKeZDJqEG8Zo62aWudcvmr0rRI=;
        b=d0wl29QBY1vQMsXf5+HCvxs7+PQsym8spw52MIdCseoviHusmueYGldLtykHsMVa80
         Sv7QHQ6G22UTN8KmzKuRi3d4R/ZDhRkJEYpdnbLQh+78ss9pg6AzeZulzD/DphBaGa8x
         i4mNgP9rYLusVePulEb1aA/DaLUEs4am+hIhcHMQFgZ95+q/kVWTNhnvdS1Z9FFEcbxs
         BtVWnOL+D4Vm6kvGMxWcUBx1q7Uy1ziM1AnUzVDhzmuog0GKmszS1P5yuOdHDfmUfGT4
         1PkEHbGzsg//lE6dOvVir7ndLInn3iISxmIjXsKEgCEWWtaO0xCPXoQfBCivIgFmQfLy
         zh5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742918871; x=1743523671;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rb9ebUJ9N7Jt+0/wSlKeZDJqEG8Zo62aWudcvmr0rRI=;
        b=dMrS8rYVsfZmsZODdMUaXDsb9H2tgc20jNNJ8LTCGKFB15TVUZbKcjTDPI/j1+FMNy
         4LEYeKpedhzEoLNB6WLZ1I9roxq0I0lLSCJalbJtiDfhIyEHxqBnHBSilT94s9Rv5+QU
         t7HweuyEKohM80suMgNXbqhLPRBfs+zPUZ5K7Vzwup5m9o+OTSmTgXNRogWPtkkt/YsC
         drf97D5f8Ap8Vv3SkDsMgVITXog2OMPHkItOanbD3yk7jATd0WGhcvVRO8GAw8LCTFPX
         3cRVShivKfHM/NIjqD8t2G8UQB2S9C/k6G62ryJLQ3utzcLb1PRZZV4y1QA6pUsGWR3/
         qt/g==
X-Forwarded-Encrypted: i=1; AJvYcCWyKZO+sygrUH5TjQugHm9rNCxC5q3qClXRrdY2Eq/1+VgDmwJAGdNDalh+KSCuqzgnZWI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAJDS1gEnhBDTMJZONXFbI6bYX1cHH4OXZoFbRT+6m1l88cNQZ
	0mGBpDCzSBmaIqmyHi2MSmV5PR20kNf4/ru9/vrLtBD7HyGzXQYycHG9gURT77M=
X-Gm-Gg: ASbGncvBxvo8pt8XKqCBFvduDBFokeFMgWPp1aLjm6scWTnqcqpXUs0oKYNGhcctnfT
	6Ueza1ng5UESndY+YEIDfn6xHrMdZ7IcZIQmtn9LGMUki6LJcYZ3xdIENaRhGi2kfH8uuU+2n0s
	6LRw6YOih0qoXFftuD63wRUrdIX/7CPryIz0wafNSON4REF/czJaZPUoN7tY2v56aSr+8CRU5E/
	TxuhPgpPbtGUSJq3OOhb9s5you/E05c9J+zd7NARunEUb8KTQmaBo/dYHJx813ky1/0SEi9XLen
	yiwb2X2O6KRO0KO5WDD960kz42323/t+XN8g6jzIq//kcVxAu8sL//hTFkR20qQ=
X-Google-Smtp-Source: AGHT+IFI/7tTmUNqF1LFsp9CSF0jzd2wofLTJjRMMtVmsGu6/uq/OnH6WnDOGAESyJFHG7RUegV3gg==
X-Received: by 2002:a05:6000:2d83:b0:39a:c9ed:8657 with SMTP id ffacd0b85a97d-39ac9ed8663mr1542229f8f.17.1742918870911;
        Tue, 25 Mar 2025 09:07:50 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43f43cbasm203972195e9.9.2025.03.25.09.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 09:07:50 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v3 2/5] configure: arm/arm64: Display the correct default processor
Date: Tue, 25 Mar 2025 16:00:30 +0000
Message-ID: <20250325160031.2390504-5-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325160031.2390504-3-jean-philippe@linaro.org>
References: <20250325160031.2390504-3-jean-philippe@linaro.org>
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


