Return-Path: <kvm+bounces-36449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55C16A1AD70
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:45:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95A121641F3
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D32B1D61A5;
	Thu, 23 Jan 2025 23:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UJigkRKL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBAD1D47C6
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675924; cv=none; b=IAfu/FSrYH9GzU7n66seFINFMOk1mcRjjQ5ngyeFktRQuLhN03d1fzQraZY5BD98aoVVJ0x6uGZJiVEvPZ3BzUXTKkl3i2qzmrBM6kMU82m6SIetuOzBLMD8Eo+fNEdk4cLN8eGqXYNBYZ1VdiaB8WEkODAinlUTqtE9ItAssa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675924; c=relaxed/simple;
	bh=crQc+e5YegHMpgjh7hJOPVwNQ1Or/+MQ3o6kdJ1gfVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQZdPrmc2MsFgWRO4umPPmjQfaPdGLDca5XdE3cq5waDX3YSgBKj6LEGXZU6mWJx7wUm5IwncrJNQTmBn5slrHEVQcdkMsbB38SqE8uvge77d98ORUPhnlMgagYgUanhnxOdT8gQ6VxJFmbb8QwgLrVlBM4nP1y0xnDKLIHabt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UJigkRKL; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-436341f575fso16144075e9.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675920; x=1738280720; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KLiVQy6/uYr9fS/vE5notUMei/mcFiOsSDRea34SIY0=;
        b=UJigkRKLG4rbWV+LTtfV6kg2a1JAuaSZ84U1mb0Phis2AwhNc9sUuw+bPknyOPQOHF
         HFfX6OLsIhq8f3wMqfVIO0cqpHT0kBLmnzRNT1xYdoP7awmFZRXnWTsj7EdgqmZW2jR0
         YpWtYFtCJZQPBNSaegFjdxCBeDwVEdtvdK1p5wkYI7D4KxGxXbf5oKQGANTr4FQniJ5Y
         RsSM6mX/OLWPlQ9ago3ANRuBhed/TRTlEeTEDAqdzFZzpaYPQvYSoHO6qUaexzUzSYA+
         1qGz8DGmUg57+Gls6QUGa+H2+94y6vfcBIubKXOWwl1NFxkdA52dS8CFZc3B2d88BXAV
         OOag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675920; x=1738280720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KLiVQy6/uYr9fS/vE5notUMei/mcFiOsSDRea34SIY0=;
        b=TMJOvXy6k7vSlcUcgrNjR4tk/WmUEvt6+GH+iVlB1W0fqxLSUj5s6aqHPsDl0bDk2i
         u5VxpfmLymdJR2ww//E9O1k6hBLU7ZI44RqRHEa7+IyGqnR+fCRtXRIpAX+aqZYjj/rU
         PsJBTT5gPhjybxXPQAvReyu5gceLFsfJ3jEYF4WLXreGgWoHCoalmTgqujKQeDwu5d8a
         0ZgrhOtFMKUsy5E1gkUlM+z6+kYzHhXFK/e4YChR+gn3kmw2fywtBzxZ9tS7RQWQxgiB
         T3DzUUTiaQNoVVm8fprvXQ9NuDB3D5aIfuGgrTmcg3FNNL6VLes6VxlLrBoaKtseZwIq
         gHlA==
X-Forwarded-Encrypted: i=1; AJvYcCUknHEI3LjskVUKjeTdknHuvPeVO3uu6iZwnaSh7ZiktrmGUfvvLPt0Mv7Ox3u4rgRY7U0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQUwCl+qH4NKv8g3WC7bCbiyg1rP590fbDh5Ooc0FSoF+Gtihm
	wMl6swGcUwQq92qla2Zh3tbNE1OOl86n3Zz+189VuntKNYj5h1dIdsVor2DD654=
X-Gm-Gg: ASbGncsO1KkA0I4Bd3dRmbOO6yvguhy7hZakz/O6Qc902Ub+k3Ov9WN+nkov8ANzrbT
	JFJkrXYwCFY1o8/RxLSUwYhmHaPYVpxOHqiz6bIxFugJdsewuQIKYQ5oTMoU1GE9fzt9MqA8bMz
	h+dFyqLjvM14w+t7NYT780WNZx7XnntERqnqLLgT25mlyFEqAXO8dAVSTGfWbzQq1REIGjkK3FD
	AqDFACvTcqMO3F3mMX+Yv/iuE+5KWtaiSvDxbyq4d9qv/WsHTDt43r6OO0I9PxKFtxoCAr0AZSZ
	GlyrzCnzf8HtJW9HJ/heliqsPK0V3BoEYQJhzD54vcfqO1Rybttrazk=
X-Google-Smtp-Source: AGHT+IHCUhXEKn4F81kx6ZpXqs9faqGpJN5W9Mj/EUJJpXYvZE3+gYqYLTjnf0hJ5kDL6XLUxlFm9g==
X-Received: by 2002:a05:600c:1913:b0:434:f4fa:83c4 with SMTP id 5b1f17b1804b1-43891453fa7mr280858325e9.29.1737675919693;
        Thu, 23 Jan 2025 15:45:19 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd54c0f7sm6499935e9.28.2025.01.23.15.45.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:45:18 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	qemu-s390x@nongnu.org,
	xen-devel@lists.xenproject.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 11/20] accel: Rename 'hw/core/accel-cpu.h' -> 'accel/accel-cpu-target.h'
Date: Fri, 24 Jan 2025 00:44:05 +0100
Message-ID: <20250123234415.59850-12-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250123234415.59850-1-philmd@linaro.org>
References: <20250123234415.59850-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

AccelCPUClass is for accelerator to initialize target specific
features of a vCPU. Not really related to hardware emulation,
rename "hw/core/accel-cpu.h" as "accel/accel-cpu-target.h"
(using the explicit -target suffix).

More importantly, target specific header often access the
target specific definitions which are in each target/FOO/cpu.h
header, usually included generically as "cpu.h" relative to
target/FOO/. However, there is already a "cpu.h" in hw/core/
which takes precedence. This change allows "accel-cpu-target.h"
to include a target "cpu.h".

Mechanical change doing:

 $  git mv include/hw/core/accel-cpu.h \
           include/accel/accel-cpu-target.h
 $  sed -i -e 's,hw/core/accel-cpu.h,accel/accel-cpu-target.h,' \
   $(git grep -l hw/core/accel-cpu.h)

and renaming header guard 'ACCEL_CPU_TARGET_H'.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 MAINTAINERS                                               | 2 +-
 include/{hw/core/accel-cpu.h => accel/accel-cpu-target.h} | 4 ++--
 accel/accel-target.c                                      | 2 +-
 cpu-target.c                                              | 2 +-
 target/i386/hvf/hvf-cpu.c                                 | 2 +-
 target/i386/kvm/kvm-cpu.c                                 | 2 +-
 target/i386/tcg/tcg-cpu.c                                 | 2 +-
 target/ppc/kvm.c                                          | 2 +-
 target/riscv/kvm/kvm-cpu.c                                | 2 +-
 target/riscv/tcg/tcg-cpu.c                                | 2 +-
 10 files changed, 11 insertions(+), 11 deletions(-)
 rename include/{hw/core/accel-cpu.h => accel/accel-cpu-target.h} (95%)

diff --git a/MAINTAINERS b/MAINTAINERS
index fa46d077d30..e4521852519 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -499,7 +499,7 @@ R: Paolo Bonzini <pbonzini@redhat.com>
 S: Maintained
 F: include/qemu/accel.h
 F: include/system/accel-*.h
-F: include/hw/core/accel-cpu.h
+F: include/accel/accel-cpu-target.h
 F: accel/accel-*.c
 F: accel/Makefile.objs
 F: accel/stubs/Makefile.objs
diff --git a/include/hw/core/accel-cpu.h b/include/accel/accel-cpu-target.h
similarity index 95%
rename from include/hw/core/accel-cpu.h
rename to include/accel/accel-cpu-target.h
index 24dad45ab9e..0a8e518600d 100644
--- a/include/hw/core/accel-cpu.h
+++ b/include/accel/accel-cpu-target.h
@@ -8,8 +8,8 @@
  * See the COPYING file in the top-level directory.
  */
 
-#ifndef ACCEL_CPU_H
-#define ACCEL_CPU_H
+#ifndef ACCEL_CPU_TARGET_H
+#define ACCEL_CPU_TARGET_H
 
 /*
  * This header is used to define new accelerator-specific target-specific
diff --git a/accel/accel-target.c b/accel/accel-target.c
index 08626c00c2d..09c1e1053e0 100644
--- a/accel/accel-target.c
+++ b/accel/accel-target.c
@@ -27,7 +27,7 @@
 #include "qemu/accel.h"
 
 #include "cpu.h"
-#include "hw/core/accel-cpu.h"
+#include "accel/accel-cpu-target.h"
 
 #ifndef CONFIG_USER_ONLY
 #include "accel-system.h"
diff --git a/cpu-target.c b/cpu-target.c
index 75501a909df..f97f3a14751 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -44,7 +44,7 @@
 #include "exec/tb-flush.h"
 #include "exec/translation-block.h"
 #include "exec/log.h"
-#include "hw/core/accel-cpu.h"
+#include "accel/accel-cpu-target.h"
 #include "trace/trace-root.h"
 #include "qemu/accel.h"
 
diff --git a/target/i386/hvf/hvf-cpu.c b/target/i386/hvf/hvf-cpu.c
index 560b5a05940..b5f4c80028f 100644
--- a/target/i386/hvf/hvf-cpu.c
+++ b/target/i386/hvf/hvf-cpu.c
@@ -14,7 +14,7 @@
 #include "system/system.h"
 #include "hw/boards.h"
 #include "system/hvf.h"
-#include "hw/core/accel-cpu.h"
+#include "accel/accel-cpu-target.h"
 #include "hvf-i386.h"
 
 static void hvf_cpu_max_instance_init(X86CPU *cpu)
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 1bda403f88b..6269fa80452 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -15,7 +15,7 @@
 #include "hw/boards.h"
 
 #include "kvm_i386.h"
-#include "hw/core/accel-cpu.h"
+#include "accel/accel-cpu-target.h"
 
 static void kvm_set_guest_phys_bits(CPUState *cs)
 {
diff --git a/target/i386/tcg/tcg-cpu.c b/target/i386/tcg/tcg-cpu.c
index f09ee813ac9..b8aff825eec 100644
--- a/target/i386/tcg/tcg-cpu.c
+++ b/target/i386/tcg/tcg-cpu.c
@@ -21,7 +21,7 @@
 #include "cpu.h"
 #include "helper-tcg.h"
 #include "qemu/accel.h"
-#include "hw/core/accel-cpu.h"
+#include "accel/accel-cpu-target.h"
 #include "exec/translation-block.h"
 
 #include "tcg-cpu.h"
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 966c2c65723..216638dee40 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -49,7 +49,7 @@
 #include "elf.h"
 #include "system/kvm_int.h"
 #include "system/kvm.h"
-#include "hw/core/accel-cpu.h"
+#include "accel/accel-cpu-target.h"
 
 #include CONFIG_DEVICES
 
diff --git a/target/riscv/kvm/kvm-cpu.c b/target/riscv/kvm/kvm-cpu.c
index 23ce7793594..7e4443c5bda 100644
--- a/target/riscv/kvm/kvm-cpu.c
+++ b/target/riscv/kvm/kvm-cpu.c
@@ -32,7 +32,7 @@
 #include "system/kvm_int.h"
 #include "cpu.h"
 #include "trace.h"
-#include "hw/core/accel-cpu.h"
+#include "accel/accel-cpu-target.h"
 #include "hw/pci/pci.h"
 #include "exec/memattrs.h"
 #include "exec/address-spaces.h"
diff --git a/target/riscv/tcg/tcg-cpu.c b/target/riscv/tcg/tcg-cpu.c
index e40c8e85b26..79345e4b89d 100644
--- a/target/riscv/tcg/tcg-cpu.c
+++ b/target/riscv/tcg/tcg-cpu.c
@@ -30,7 +30,7 @@
 #include "qemu/accel.h"
 #include "qemu/error-report.h"
 #include "qemu/log.h"
-#include "hw/core/accel-cpu.h"
+#include "accel/accel-cpu-target.h"
 #include "accel/tcg/cpu-ops.h"
 #include "tcg/tcg.h"
 #ifndef CONFIG_USER_ONLY
-- 
2.47.1


