Return-Path: <kvm+bounces-10991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD62F872092
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:43:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47D431F2201D
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:43:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 252CC86151;
	Tue,  5 Mar 2024 13:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z+Y8hS62"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A877B85C51
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646196; cv=none; b=bofee1rlSawzzC3/mrcTKyUOBit7RX3lIW2cQ4h9QO8Y32Q7j2301C3EtTijhX+a914rhRMzT0sOVTUsgczZJrmI1RBtt5Rj0eqCZwQABGXUuNQB5Gi1NZF2Ytvrgon69O15KUuBbPotIS8V+YGFgJHMlbTKq94GQNUhCucaaAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646196; c=relaxed/simple;
	bh=pAKK7dTCGBw6agU834mHgxGV6lNe6KaXR+W11o95NKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QOQ91+WjgArhwjrGbNtwW6za1aw736j38C8cdXDxGLkT5P12VId4xfz7xxY1TFPlgZj2nddUj/e09IPwY1Sjp1V5diSzTNs+kSehqh26puiEgM+J3epLNjia4toB/xdrexvMqlMl0GpBniZakIEOYDAZNvpSobyUjdIvuybpXLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z+Y8hS62; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d220e39907so85843141fa.1
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646193; x=1710250993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OT8ZTO+xhnK0H2YL2SoKQeqlcBWyfPJJ6GJXZNxMx34=;
        b=Z+Y8hS62p23txUGVpURW/a+2xyoVbPmYRP9L+te0vj2C007FvGAcVmsuFxuUF/3Uek
         YHguv3XOSglyyhYRSauA1tGnbArviTcLwq9xettm9JuL00ej5IJWiSrNTOR/OPfmZ/0Z
         IF4ZVr/PirEXhaeUHuvhkLaoIvyugi8gbsbm5KQ5UIR7DxOiZ4FV3LHHwe85AThtl0lg
         PPFX0TMvibOR6Am0rWJTURMIPXrwV/UxqmLzPxC8GLMOZkaFuwfWYEhmxyV3kNB/gkIs
         YkwOXkT2D1qTKNo4+UqLlACfA90QbmokKooQdt+qTBPMtWLinPBj++NgdDd6VaqPWRxK
         KZ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646193; x=1710250993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OT8ZTO+xhnK0H2YL2SoKQeqlcBWyfPJJ6GJXZNxMx34=;
        b=gARncrq4PIhxsh6Jrhjlz2veHahN2KGXUW36wUPQXNSY+MdmIKHHwMBB9WX0NWeWks
         QkA3FWda/4Qje+5ZUnyXtbcPLFlY4ITcDWVZckQXe7/RLspPQLKe9H6QFVs83fdwyqTk
         ea0I6MdY0IH1SWdA5jkntlDMkz3vQKQyAoxd6/SdsTnVOI55LbvsqduFRL5SxTggbQLo
         tJyu+dnOnuWK5OwnNFRDolvyN7OoD7BG55jr3FxYyoytzc7XSrtdR7EqhCwNk0ZgHwm/
         mf1sCFWMC7HBg/OL+5nlijvO96Gs2fC9qGMhV6UoGQEc4vb9cUXoDqqInu11frEBFQNG
         SsFg==
X-Forwarded-Encrypted: i=1; AJvYcCVufZe56GFkmVxKQrzgtoe5u/AsFaey72HusrBXt2Wat4mBcA04UNuNx+ZUN22y4JOgTPljQnrAjELOnVaBBwtE5lr9
X-Gm-Message-State: AOJu0Yz1GxYx4rTu1MszP08rxMz5iQQj6ENlkpNdmL9g9eKWXIrxYN1A
	BpMpDe4wl+8/9A5Tro+W2w7NBCG9uGjqgLubmD3kDgIBaA/afgl666/keBZnzS0=
X-Google-Smtp-Source: AGHT+IHLwmHlfKl35XuwdEpGZVpnOk61AIZfeU4H/uc9w8OSaeyHZp72bMkq1nwPsKgfBewcEeKcwQ==
X-Received: by 2002:a05:6512:39cd:b0:513:46cc:8966 with SMTP id k13-20020a05651239cd00b0051346cc8966mr1840957lfu.2.1709646192884;
        Tue, 05 Mar 2024 05:43:12 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id k13-20020a1709067acd00b00a44f3fb4f07sm3564090ejo.191.2024.03.05.05.43.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:43:12 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	devel@lists.libvirt.org,
	David Hildenbrand <david@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.1 07/18] target/i386/kvm: Remove x86_cpu_change_kvm_default() and 'kvm-cpu.h'
Date: Tue,  5 Mar 2024 14:42:09 +0100
Message-ID: <20240305134221.30924-8-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240305134221.30924-1-philmd@linaro.org>
References: <20240305134221.30924-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

x86_cpu_change_kvm_default() was only used out of kvm-cpu.c by
the pc-i440fx-2.1 machine, which got removed. Inline it, and
remove its declaration. "kvm-cpu.h" is now empty, remove it too.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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


