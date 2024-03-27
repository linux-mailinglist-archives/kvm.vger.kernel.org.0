Return-Path: <kvm+bounces-12783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41FEB88DA84
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 10:52:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82A18B2372F
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 09:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10D16381CF;
	Wed, 27 Mar 2024 09:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZkEa7YOq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4852CCA0
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 09:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711533139; cv=none; b=RtN0V7a//298zIxSjKv0AxQDYtZhVrIaENZd4wv9T52klDbJujJOvYJ10eS2LSkL6GFF+Ma7yURjgg40GB7vCEnltKkinY7IpBeWHAMsIt3b2tOB5l77cuqVc5JOipvSpyJT1wj8Rpj8Nl9tkzejOJyrW64rDbdcF0wpjCkEz2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711533139; c=relaxed/simple;
	bh=NuewdyMlTZofDS/OB2GkEfNfdyEKz3dNML9QpJlBRFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LUi3EOnmRnl/6BguGez2nPb9in8SxKWdRw9pnbxKMoiQvPoOu1ladnR8tvO/RP/8vVbb3TPOOBSOVIHzUxbV90WjRn5gpp8ABC0QyQaLbBAxCtFkXQAtsWBTDX6Ksz0i8QRb0vAF1kPzPVESG5EcC4h0YC4LjIveRsqdZaHX2bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZkEa7YOq; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-56c404da0ebso416568a12.0
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 02:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711533135; x=1712137935; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Vuzow4wRuBRA6M1t6JbWbYyMIQl6k4id2ay+d/vaQI=;
        b=ZkEa7YOqu6g8l6VXbVsnQSUFiuEecdfBAkqZSAvdt7qzmffobyRrnFtGESUM+e58Fd
         8G3Gs3nQDCnX62WB8aStYe1GOLiXggeMUcq/Xf7fnlzcfJKY8r7WWP/emnuvSQpDbs9/
         rHkvZWCzURX+mC4DlxIAzk9hl4PoIy9tvM0b2meXBxo6M+vJUB5a9P7vg/QK0DpP5MY9
         +L8ThhtlcTPYImHSW8VOtvH/FHRsijyWElHU9zhzysWprQIBugs8xU0v8SbpwVb8E8lH
         uHhKMs5J0XriTklILQPx195vseGnFzchuhPfzWU/1fXSZRukZvs6/9q3wXfq5DbhmONZ
         vzPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711533135; x=1712137935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Vuzow4wRuBRA6M1t6JbWbYyMIQl6k4id2ay+d/vaQI=;
        b=Jz0dpW85seeBZh0UlOMm8zkKh7Bbms4svP6KtgrIae26/nWAfcKHViCV5fNT17UYbf
         v2p9QIDXiJrD3hJR95Jvyq8K3ntTWYOzBk+nh3NDgGUuURK/hkSBYa1MDe0wKQ+8NPtK
         wJ+Lzp6/ky1CjRW3aUdWJbRdJXNEgmQp/lqIalLTThYhms4QYnLyWmO5HVuIj62dkZgR
         jn1EFKxEQSX8B2QD0v4u/qpNMszwcgfrNfYl5ySt9GFc4m/NKqFqfDlrC5FCD71xGcD7
         vM8mhmo8AY/dWCDdIRNiAD+9WBJIMW3PfL6tWhRyfP6ZxaUvaCX7FskHeLxmxNQhC+/8
         11Qw==
X-Forwarded-Encrypted: i=1; AJvYcCWzdYRq6kHpixyDQZSV6C+igrRkv4WXzWCG5UgpktRhHZZJoKr8eQbCytlnWQb0HBcxaF731OKwVvHdrvDHTgVS4QTe
X-Gm-Message-State: AOJu0YxzHrjJT20TS5eLN0mcuvmMQYyWVu8+5Yu2b8YF8rG5C5p9SAUb
	nBgoPj36EIQfKN47czyKY1LCy8ckNKdy5EFmTNr74nE2ZcY1aMYlb4HOBdGv4eg=
X-Google-Smtp-Source: AGHT+IGkho+VF9jZbFTrsl0A52f9KUabCr6P1DiiRsYYyyiIAiLpythomXDl0mt7CQFoKBH1AWEZtQ==
X-Received: by 2002:a50:d781:0:b0:568:9d96:b2d1 with SMTP id w1-20020a50d781000000b005689d96b2d1mr3486483edi.32.1711533135591;
        Wed, 27 Mar 2024 02:52:15 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.205.175])
        by smtp.gmail.com with ESMTPSA id l2-20020aa7cac2000000b00568e3d3337bsm5050818edt.18.2024.03.27.02.52.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 27 Mar 2024 02:52:15 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Thomas Huth <thuth@redhat.com>,
	qemu-devel@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	devel@lists.libvirt.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH-for-9.1 v2 08/21] target/i386/kvm: Remove x86_cpu_change_kvm_default() and 'kvm-cpu.h'
Date: Wed, 27 Mar 2024 10:51:10 +0100
Message-ID: <20240327095124.73639-9-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240327095124.73639-1-philmd@linaro.org>
References: <20240327095124.73639-1-philmd@linaro.org>
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
Message-Id: <20240305134221.30924-8-philmd@linaro.org>
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


