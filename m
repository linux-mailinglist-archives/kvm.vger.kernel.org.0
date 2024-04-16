Return-Path: <kvm+bounces-14770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FF8B8A6CDE
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 15:54:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2B031F2205C
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 13:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6444E12C7E1;
	Tue, 16 Apr 2024 13:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eu3VTTZ+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5114129A72
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 13:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713275636; cv=none; b=pl/EK7Wx0IR3QhaxtUCI9XsB+S4n5az+f4m4kI+ekdXaFklHxFFuB+zpG6DAgvWF4l35YYevjNszTTjtiXy6YGYg3Dx+cfxhonM3d54zunZkhxe8kAyfuyBBSbvIYGQAuOMc81pwtnsEP2vZQrkTMerAJOw13zSML5FJEG/e0dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713275636; c=relaxed/simple;
	bh=a/lHiyqD0LuQef7tb+rKPgTHO0b7ylPmocM5y30krnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JK+SRvvY+StkSfyhDwaaFG2U4gAazC0ooIGl5s5gIULbZoupOivtYoeRoOW6EyDrKHMMs1H2CYGinFaPPVincwFKMBRHR6TDXC37Ktq6UFMTWl7NzJBV/jJWta+w/llFB+RPbENc5ZQKdcsD/SXMmZPpm0oJn+iFBxBVoJEmo0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eu3VTTZ+; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-56e136cbcecso5341702a12.3
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 06:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713275633; x=1713880433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WRu6gIdKkp2mUDaWmMaxQTExs6byim7bx/MfazoYUmc=;
        b=eu3VTTZ+Al1aFsfLwCDTaRqdcKGu+wSHCbEkvwaxNttRH8Le9vJNeq1/tgBJCOChB4
         u3KNWkfLhZM2BmFWSK1dIgO6J9YSAzxosBL+WMcO96Mz2faONL+vHGb8pW1Zi8fvFsFT
         peCWyGu8y8ioPk1U0ghuSaAHcXVCIWfRujjdupOX+05woOPD2WyQympj9su4aVsGjO1r
         zpBPZmZMcmfJFaqjuUFxLBKZ1RUBLGvGladcoVToCMLXkNoM8Bl9l4s1y1VjXPllZwt3
         9Ym22PT+eqSMO/RrrOSw8Q0YR3BN1swbYOrZcP3RCe3+MXh+IG5Tww9vtnuQs7Q1wkX0
         1RFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713275633; x=1713880433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WRu6gIdKkp2mUDaWmMaxQTExs6byim7bx/MfazoYUmc=;
        b=rN4gn0PUX4evHsdO+M+vg8rqhBG3KoXfc5YACqvx4BABqsOX1hDZsM3+p05f+hCgvt
         q6DxasjVYVvpogmurOlcQKgOuGRG/v0uHxEE7aDmgkBlrQHMpJN4GZNA8FO48Mv/bdhc
         ZQbfy28AEe/tKbQUv0k+P8fWEURoFKFmeRzFYMbRxfKzFesrj3R9j8XkrpeELJCGBiGb
         ih80wCHUD9RH1SpKXC/obpE9s/alCFpUksX85XOQgdAwa5q40DaxNEqej57rkLCws39p
         7HBkJV7m35LZBQbSoyHRiJ87MXrjkdYBqEpMnds74PfwdW9AkA/X9X4//tGj/ZJx4hNe
         fKlw==
X-Forwarded-Encrypted: i=1; AJvYcCU4Z4b9RUUkht0LWDMEjWRebmk0O8P7ij2OB2lcV9DLvUqvO7jWBn2ZMV8ww+bqXggF4VusMewClUqImPsm0l3WUrQL
X-Gm-Message-State: AOJu0YxVKKdfs5IhcIJRUsBWDywrRWfv08t4Ehz+DgOOZZ+Sw3FFR+7B
	ZL4DszlaGSYQy23nKeK2GObOAyC8y0fDxIxS8TUEz07SN97785IyZaAPFeA37Bk=
X-Google-Smtp-Source: AGHT+IGEkV4NtWFwS7smQ8etZfExDim57HWSMuEPad1Ashde9/8qRGKDeoK0TUptFcJYLEy24Oqhkg==
X-Received: by 2002:a50:9545:0:b0:570:1de9:4cd7 with SMTP id v5-20020a509545000000b005701de94cd7mr6143993eda.15.1713275633197;
        Tue, 16 Apr 2024 06:53:53 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id n13-20020a05640206cd00b005704ae9272dsm240052edy.93.2024.04.16.06.53.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 06:53:52 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	Zhao Liu <zhao1.liu@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v3 09/22] target/i386/kvm: Remove x86_cpu_change_kvm_default() and 'kvm-cpu.h'
Date: Tue, 16 Apr 2024 15:52:38 +0200
Message-ID: <20240416135252.8384-10-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240416135252.8384-1-philmd@linaro.org>
References: <20240416135252.8384-1-philmd@linaro.org>
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


