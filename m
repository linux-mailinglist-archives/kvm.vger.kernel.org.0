Return-Path: <kvm+bounces-29488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FBB89AC90F
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:35:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1309B1F211D5
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA851B4F25;
	Wed, 23 Oct 2024 11:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ksSI1D43"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455651AE01E
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683259; cv=none; b=J4J4ekf3uR+tT6NMKxg0WzHqsknBnQaUH97tAIB21ULK3/U/VhpHAizT/2fB/gisvYI2YlIrGiULRdQXtmcOFAmQuD314GAug/V+DXFav8EvJldLU8PLmKsbDBIIC43hh/JUnbT0USpAo8FVKxCfYQ5AE/syVaWUN1DN5jGH24g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683259; c=relaxed/simple;
	bh=k4DUf5ld0t+Rj337VJF2t4M25SBJ9Xw6VHcscakA8eI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VaOZQjQuusJ3J3NxZsAvhvDAKFXGkujoZgszvYHXwZa64JdiS3frM1ULNtlnaMvx4lauaPspiNLUOvqN6vYbYZy1Eec1+hEnPf+w0g0ofD+jDfBialpnH03VuW2uJz6jI+BJul7exGcQwxjvnH38Kwg/KRbLFbcNWGTQYz7SnJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ksSI1D43; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a998a5ca499so830411866b.0
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683256; x=1730288056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnSO5MY5LW+ONfwtsvf8QoavFQHBZ1D8g95DfEWZbMI=;
        b=ksSI1D43w94dfU43YCU6HTO4Bxj7sRg5m0rt+55yFNnDUB78C6cgzHyAM/w9zv7tAj
         UG+StpTO8ZazuksxxyNVj5fqadSHn4vB+LcswbfufrB8VzOLqLJVKVqa817tUI1k8C1+
         NPwJR3WelTCkpzSS039CS1O5DSVdrDr+Fvuu/Gss+bEVXdVPmJCZXF7WK4VrcsmaDqKL
         A0xv5Z077vjszJcgbioO3SEQc0B1WHpiY2UXYnZWslEV+swxWxBp8L1RUTsHjE0qONLb
         +K+H4UOh/j35WOgf6AnPY04AVl+mdjDYZbKiR4KUsmQbhhWID2lYJTwnXbRVmMj9gqgG
         H0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683256; x=1730288056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CnSO5MY5LW+ONfwtsvf8QoavFQHBZ1D8g95DfEWZbMI=;
        b=L9jA4qphfFJFl4TbcHg7oSRosSRR9WbwEIvTyo0D99XYsN3t9FEIxbXEAqPfwpIzdO
         qAcOh7i+w3GiDrKPSwCNwOgCdGBibtDJ898YSoPd647eFGpGJKv1rFCfcC+PA19ftQHj
         1lKpABSkXFz9opIawdCeeKkYXWn/U7yT+1fYvLVOfs++1RU6ZpTIyAv6+BfRex3UVdb0
         2jmQI+/WXaOFuAjYg6vwbIfKqy4LLqC2mGvoAWlhRuorrfHnB7nkj9KehQ0ppcc9odFM
         hRXJcLd4SMd7zh6El3TVWxsPa5Nqi+esHZodxjyZUM152yKjF6JPYsLhj8HNxHANaJ2K
         19YA==
X-Forwarded-Encrypted: i=1; AJvYcCVOmUmKmidkWVIkEyKS12EinkP6xeQJifjIgTcYOEl18IUddYtKRV5pbVO2rapOmQkg54c=@vger.kernel.org
X-Gm-Message-State: AOJu0YztO0BeiDhGAhHXx8EjTmwdVIMNGgXELCgBWhGqEv98rzColRLo
	A8BK5Q3n8FmYa1FJNDMQc+IFXd4nFLUGSqea9cnDrKDLk9jb86NXaObNqaKiMII=
X-Google-Smtp-Source: AGHT+IGQ8eNDG4hvQQMgEDKqe0AnFuHG96cp2iQINzDD7TQGbtAzIgC/b75CNykQdz9lIW4fA7WJ8w==
X-Received: by 2002:a17:907:9496:b0:a99:46dd:f397 with SMTP id a640c23a62f3a-a9abf96f1f5mr184448566b.64.1729683255674;
        Wed, 23 Oct 2024 04:34:15 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912ed80fsm463139066b.46.2024.10.23.04.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:34:10 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id B61D85F942;
	Wed, 23 Oct 2024 12:34:07 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	devel@lists.libvirt.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Beraldo Leal <bleal@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 08/18] accel/tcg: add tracepoints for cpu_loop_exit_atomic
Date: Wed, 23 Oct 2024 12:33:56 +0100
Message-Id: <20241023113406.1284676-9-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241023113406.1284676-1-alex.bennee@linaro.org>
References: <20241023113406.1284676-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We try to avoid using cpu_loop_exit_atomic as it brings in an all-core
sync point. However on some cpu/kernel/benchmark combinations it is
starting to show up in the performance profile. To make it easier to
see whats going on add tracepoints for the slow path so we can see
what is triggering the wait.

It seems for a modern CPU it can be quite a bit, for example:

./qemu-system-aarch64 \
           -machine type=virt,virtualization=on,pflash0=rom,pflash1=efivars,gic-version=max \
           -smp 4 \
           -accel tcg \
           -device virtio-net-pci,netdev=unet \
           -device virtio-scsi-pci \
           -device scsi-hd,drive=hd \
           -netdev user,id=unet,hostfwd=tcp::2222-:22 \
           -blockdev driver=raw,node-name=hd,file.driver=host_device,file.filename=/dev/zen-ssd2/trixie-arm64,discard=unmap \
           -serial mon:stdio \
           -blockdev node-name=rom,driver=file,filename=(pwd)/pc-bios/edk2-aarch64-code.fd,read-only=true \
           -blockdev node-name=efivars,driver=file,filename=$HOME/images/qemu-arm64-efivars \
           -m 8192 \
           -object memory-backend-memfd,id=mem,size=8G,share=on \
           -kernel /home/alex/lsrc/linux.git/builds/arm64/arch/arm64/boot/Image -append "root=/dev/sda2 console=ttyAMA0 systemd.unit=benchmark-stress-ng.service" \
           -display none -d trace:load_atom\*_fallback,trace:store_atom\*_fallback

With:

  -cpu neoverse-v1,pauth-impdef=on => 2203343

With:

  -cpu cortex-a76 => 0

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

---
v2
  - 0x prefixes for ra as per checkpatch
---
 accel/tcg/user-exec.c          |  2 +-
 accel/tcg/ldst_atomicity.c.inc |  9 +++++++++
 accel/tcg/trace-events         | 12 ++++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/accel/tcg/user-exec.c b/accel/tcg/user-exec.c
index 51b2c16dbe..aa8af52cc3 100644
--- a/accel/tcg/user-exec.c
+++ b/accel/tcg/user-exec.c
@@ -29,7 +29,7 @@
 #include "exec/page-protection.h"
 #include "exec/helper-proto.h"
 #include "qemu/atomic128.h"
-#include "trace/trace-root.h"
+#include "trace.h"
 #include "tcg/tcg-ldst.h"
 #include "internal-common.h"
 #include "internal-target.h"
diff --git a/accel/tcg/ldst_atomicity.c.inc b/accel/tcg/ldst_atomicity.c.inc
index 134da3c1da..c735add261 100644
--- a/accel/tcg/ldst_atomicity.c.inc
+++ b/accel/tcg/ldst_atomicity.c.inc
@@ -168,6 +168,7 @@ static uint64_t load_atomic8_or_exit(CPUState *cpu, uintptr_t ra, void *pv)
 #endif
 
     /* Ultimate fallback: re-execute in serial context. */
+    trace_load_atom8_or_exit_fallback(ra);
     cpu_loop_exit_atomic(cpu, ra);
 }
 
@@ -212,6 +213,7 @@ static Int128 load_atomic16_or_exit(CPUState *cpu, uintptr_t ra, void *pv)
     }
 
     /* Ultimate fallback: re-execute in serial context. */
+    trace_load_atom16_or_exit_fallback(ra);
     cpu_loop_exit_atomic(cpu, ra);
 }
 
@@ -519,6 +521,7 @@ static uint64_t load_atom_8(CPUState *cpu, uintptr_t ra,
         if (HAVE_al8) {
             return load_atom_extract_al8x2(pv);
         }
+        trace_load_atom8_fallback(memop, ra);
         cpu_loop_exit_atomic(cpu, ra);
     default:
         g_assert_not_reached();
@@ -563,6 +566,7 @@ static Int128 load_atom_16(CPUState *cpu, uintptr_t ra,
         break;
     case MO_64:
         if (!HAVE_al8) {
+            trace_load_atom16_fallback(memop, ra);
             cpu_loop_exit_atomic(cpu, ra);
         }
         a = load_atomic8(pv);
@@ -570,6 +574,7 @@ static Int128 load_atom_16(CPUState *cpu, uintptr_t ra,
         break;
     case -MO_64:
         if (!HAVE_al8) {
+            trace_load_atom16_fallback(memop, ra);
             cpu_loop_exit_atomic(cpu, ra);
         }
         a = load_atom_extract_al8x2(pv);
@@ -897,6 +902,7 @@ static void store_atom_2(CPUState *cpu, uintptr_t ra,
         g_assert_not_reached();
     }
 
+    trace_store_atom2_fallback(memop, ra);
     cpu_loop_exit_atomic(cpu, ra);
 }
 
@@ -961,6 +967,7 @@ static void store_atom_4(CPUState *cpu, uintptr_t ra,
                 return;
             }
         }
+        trace_store_atom4_fallback(memop, ra);
         cpu_loop_exit_atomic(cpu, ra);
     default:
         g_assert_not_reached();
@@ -1029,6 +1036,7 @@ static void store_atom_8(CPUState *cpu, uintptr_t ra,
     default:
         g_assert_not_reached();
     }
+    trace_store_atom8_fallback(memop, ra);
     cpu_loop_exit_atomic(cpu, ra);
 }
 
@@ -1107,5 +1115,6 @@ static void store_atom_16(CPUState *cpu, uintptr_t ra,
     default:
         g_assert_not_reached();
     }
+    trace_store_atom16_fallback(memop, ra);
     cpu_loop_exit_atomic(cpu, ra);
 }
diff --git a/accel/tcg/trace-events b/accel/tcg/trace-events
index 4e9b450520..14f638810c 100644
--- a/accel/tcg/trace-events
+++ b/accel/tcg/trace-events
@@ -12,3 +12,15 @@ memory_notdirty_set_dirty(uint64_t vaddr) "0x%" PRIx64
 
 # translate-all.c
 translate_block(void *tb, uintptr_t pc, const void *tb_code) "tb:%p, pc:0x%"PRIxPTR", tb_code:%p"
+
+# ldst_atomicity
+load_atom2_fallback(uint32_t memop, uintptr_t ra) "mop:0x%"PRIx32", ra:0x%"PRIxPTR""
+load_atom4_fallback(uint32_t memop, uintptr_t ra) "mop:0x%"PRIx32", ra:0x%"PRIxPTR""
+load_atom8_or_exit_fallback(uintptr_t ra) "ra:0x%"PRIxPTR""
+load_atom8_fallback(uint32_t memop, uintptr_t ra) "mop:0x%"PRIx32", ra:0x%"PRIxPTR""
+load_atom16_fallback(uint32_t memop, uintptr_t ra) "mop:0x%"PRIx32", ra:0x%"PRIxPTR""
+load_atom16_or_exit_fallback(uintptr_t ra) "ra:0x%"PRIxPTR""
+store_atom2_fallback(uint32_t memop, uintptr_t ra) "mop:0x%"PRIx32", ra:0x%"PRIxPTR""
+store_atom4_fallback(uint32_t memop, uintptr_t ra) "mop:0x%"PRIx32", ra:0x%"PRIxPTR""
+store_atom8_fallback(uint32_t memop, uintptr_t ra) "mop:0x%"PRIx32", ra:0x%"PRIxPTR""
+store_atom16_fallback(uint32_t memop, uintptr_t ra) "mop:0x%"PRIx32", ra:0x%"PRIxPTR""
-- 
2.39.5


