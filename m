Return-Path: <kvm+bounces-14858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 420298A740E
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:01:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9031AB234FE
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DBD137921;
	Tue, 16 Apr 2024 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VQ7DwFuk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F42913473F
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 19:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294045; cv=none; b=oY5KUtKAhYJSdAnlPfWNYLw0j1v2tLZ6KPigil38/N0u/d1KojIWeAv13ouB22uRXBybxUzdXKlnImqHou0CdKymgcA2SEXf4mpcXneeb+FGnqHp28oLZkTYAec+H+Ww7aOm8Rc8uHksk5/IDjRCMSjJTrk8B89/bNnog+lwb8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294045; c=relaxed/simple;
	bh=cCJu5PLMQbpniJaVoT+Zoqnqi5eVWl1d4EkEQY1HXOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GkhKQswtkEPustGjmoaIVAKhiXOHWnuI6qIeOcCBUUlvrqosjP9VzUzyI3KGIP/YG47SoXE7nEacg+1B37R/hqfM0hwguTi0fckxkAnMYmBQ8V/DiewXDIVqALxGVXhCwDVLXwWoTw5YkvwCBAdScowewn5QLlXuPrBoAxf7Fbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VQ7DwFuk; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-346b09d474dso4528643f8f.2
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 12:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713294042; x=1713898842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XQMVapEs3CYgmDweUYusfpnz/y/x604jp5xhdw8yVc4=;
        b=VQ7DwFuk7wg93DvZvUZIz8YSeohDOTLG/M5CMLRMyyOwX9sTNc/XhW842Q+0spD/mo
         lbX6/S3LPtDHIxdMuvzhSedWE3NNkbiViH6RV9t/sI8CvV1crn7RYv7M0RyRQ7RwjH+v
         V1xDtRN3036YIgBmZPFFiidqe/nTWCzy9HrUd86st/DaS/y+3F2wnOvJoS/n3t4i/7vv
         8HLpWDXJBw7vBwYFW8MZOunCU9n0XEFYD0BZ762pfRW0pEVxBz7kswhkxD5FsDK0k/Nq
         oQvvOWK6ucfUUzQIIxJ11NKIr3Ex7GeqS3XLeADI1gX+S6VM5hC1tdYS0gL7WEVBIZgg
         m0cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713294042; x=1713898842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQMVapEs3CYgmDweUYusfpnz/y/x604jp5xhdw8yVc4=;
        b=VI97mXBtzeZHnvSokH7sbEq6ZFYYaJbWOA/CZKWS48CnrF9hr+pQQc6MehJwL8uEW9
         RLDU+8qRKCCC2llSFUf2HpHWbeOX7UhlzgRVpqROh5Ysq/S+7kdX1gPL5Z0wzPmqOG4s
         ZdLggPK2SOpmzpyuLMaG3zul7vArgHng+tf3TwCidGzYu53BLJ1hp17hbMp+GmxlsTKS
         pLcLGf5xZhAwGB4YYVF6HG9gGVHCCWezBItS5k5KuYCD3vka3PiC/H+IhDKgNOXPmqbr
         PymuRAo86A6kn3xY6T8gwiRxNbbnIOx6FPpp4pyogYGQpJOefMmb+6JygvGW+XHC62xM
         VLGw==
X-Forwarded-Encrypted: i=1; AJvYcCVDoAfZ4BfIeObZpk1ybbybrXBchq3dYmcts7Aczqtc2Jh2/QKj7SNE4gLi6431tD56v6G04nTNGv3/x8fbHGA1vpUe
X-Gm-Message-State: AOJu0YwJZm3C4rU04UCbsVl7SPNGBxb1P/wHKIaMziu/ff0lTZYp9xQX
	0QYViZlifCCrKwEWTK68VPqj9puUCeIbTOjTU0UIdNpf1hxh7l8Etru+w3hiSeY=
X-Google-Smtp-Source: AGHT+IGnL5JmbtDDZEIcfbVuWwS/E0VTaHNwOqYN0lHrO8H585nWin8P9SPUGxY4DS0gePAUMMYiYA==
X-Received: by 2002:a5d:6703:0:b0:347:82b7:abc2 with SMTP id o3-20020a5d6703000000b0034782b7abc2mr6710909wru.15.1713294042538;
        Tue, 16 Apr 2024 12:00:42 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id sa30-20020a1709076d1e00b00a522e95a580sm6417803ejc.217.2024.04.16.12.00.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 12:00:42 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v4 09/22] target/i386/kvm: Remove x86_cpu_change_kvm_default() and 'kvm-cpu.h'
Date: Tue, 16 Apr 2024 20:59:25 +0200
Message-ID: <20240416185939.37984-10-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240416185939.37984-1-philmd@linaro.org>
References: <20240416185939.37984-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

x86_cpu_change_kvm_default() was only used out of kvm-cpu.c by
the pc-i440fx-2.1 machine, which got removed. Make it static,
and remove its declaration. "kvm-cpu.h" is now empty, remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/kvm-cpu.h | 41 ---------------------------------------
 target/i386/kvm/kvm-cpu.c |  3 +--
 2 files changed, 1 insertion(+), 43 deletions(-)
 delete mode 100644 target/i386/kvm/kvm-cpu.h

diff --git a/target/i386/kvm/kvm-cpu.h b/target/i386/kvm/kvm-cpu.h
deleted file mode 100644
index e858ca21e5..0000000000
--- a/target/i386/kvm/kvm-cpu.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- * i386 KVM CPU type and functions
- *
- *  Copyright (c) 2003 Fabrice Bellard
- *
- * This library is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This library is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this library; if not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef KVM_CPU_H
-#define KVM_CPU_H
-
-#ifdef CONFIG_KVM
-/*
- * Change the value of a KVM-specific default
- *
- * If value is NULL, no default will be set and the original
- * value from the CPU model table will be kept.
- *
- * It is valid to call this function only for properties that
- * are already present in the kvm_default_props table.
- */
-void x86_cpu_change_kvm_default(const char *prop, const char *value);
-
-#else /* !CONFIG_KVM */
-
-#define x86_cpu_change_kvm_default(a, b)
-
-#endif /* CONFIG_KVM */
-
-#endif /* KVM_CPU_H */
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 9c791b7b05..cb8c73d20c 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -10,7 +10,6 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "host-cpu.h"
-#include "kvm-cpu.h"
 #include "qapi/error.h"
 #include "sysemu/sysemu.h"
 #include "hw/boards.h"
@@ -144,7 +143,7 @@ static PropValue kvm_default_props[] = {
 /*
  * Only for builtin_x86_defs models initialized with x86_register_cpudef_types.
  */
-void x86_cpu_change_kvm_default(const char *prop, const char *value)
+static void x86_cpu_change_kvm_default(const char *prop, const char *value)
 {
     PropValue *pv;
     for (pv = kvm_default_props; pv->prop; pv++) {
-- 
2.41.0


