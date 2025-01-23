Return-Path: <kvm+bounces-36446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6F7BA1AD6D
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:45:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE473188E1B3
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ACCD1EE028;
	Thu, 23 Jan 2025 23:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cCI+q8H8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF34D1EE02F
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675905; cv=none; b=GtylmMZ5Z+ABmHJl5Aw/r5CXg7u+I3kaFt8WAPAlDJfMOvb1Z36DZp6g484C8jwL2cOX+rZd0ufVkuhovW1YhsrXqlz5Pv353CTa1i9xcKf2QHHe9DjaN2RSqyR8zwzAWi0AA0NAzFfso1T2/xhbHOBP7VsgeMPyF3eVbIfFW/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675905; c=relaxed/simple;
	bh=KjD/YB+iLnJV/kcWYEO7ZhZXOobErSx+6zpYDpvkb4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dHXev2xnBcMSFkFqfoUlRcWiHZkBQERzgEebKbjkE8DLgfOGmBT6bX+vd7/gVmbL+tVO1B4De7TAu92A1FOUgJTETMhBj+U5PdOAGbhCz/+MPI1sDK0RiB0YXfnnADfenUtmRiNaH9DVXrEL6cPn0Oo7DYwkyHz4PXIkAvgCR5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cCI+q8H8; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-436345cc17bso11060485e9.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675902; x=1738280702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+Ptx+X+/4qytTYw1NRizSw3Es7j283R5duCMBs45So=;
        b=cCI+q8H8FeKVshHUhcELE+hFKZyxffcDuzy1EKLEEE9bM2XhNEvu6wIETYGW/iXBPK
         dAf9i1u9C+HUZZwCt3Q/HBp2cMww+SAOel7DJbaQuQUK2V6YeX4CAEoCYdNohAp/pgBM
         mQRPcQM1lbSrcGCuO2epB4YaT2uPTZvckwz301YXz2Fs5jW8FWQdiBHvurQ/qQqxGFsK
         DVKD9vaG7lDaZjcyyWE7eVRcT/rCLurS/IH2/Ivh6nkiugwFV+yXt18piGnjwXrxTJr6
         5/ov4X52EBWovsmSnviwDLMEWpCORiKWfQUw9AK27KXLyJTV2WI66ki+qoxqjEJCmSXJ
         kTUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675902; x=1738280702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b+Ptx+X+/4qytTYw1NRizSw3Es7j283R5duCMBs45So=;
        b=HiKzrpNNchj2RiatRV7Bj+rnp3y1H+VA2AiFLTQzPcvNIiJbBwE3IubRTiEfcFktsL
         57Z67lPL0l2rx2THhEvMbUd/FIuAXvtkkDy3cMR6DkaY1wXdVwu/cv3PWTzn3qO1DA6t
         6R8gl68MFhU10bHBxqKHZjABVDfm1W1uXxjBnJiixR3Yv9QmqPKF7f9f78cvdRH36uck
         vqVTehekvlg+LJQho/EX4HdyNrOLcAhHntMt8w/WN7Q96dETQBYifcGRwZpaKxz7Yxxz
         yKhy4OH9oTgs1ph6V4FtRNOkRo0SeyXTfhmwvKZ54LV44X58EPg03myu5gJRZENBTeJV
         jmJw==
X-Forwarded-Encrypted: i=1; AJvYcCW+GktLJiocVoRbXZMYZaB3nENPonr97KPUejtSEkD747qA8TDg9t3mTW19XhHkka1Dwjk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvDHleJeS01kWV/f0pHNGvqyLGiY5AG7o6nMaeOJ/oJcE1NIb/
	xX7FF3j1z0gi/0AuNexEhGUwlIDYYGoTXpYvf2UPgKhpzYB0ql/nsEMxvX3cAFc=
X-Gm-Gg: ASbGncs4REKe86UnB4bA4dsMHQt6wgMoTO3PZIfqvAQ38ZVS+Bnnl0B5XoModFidlH/
	xhio/S8nTeHuTJtkzpdh/CEnqfZWUY0+G69g2V885/SfJId1+cakHH9kfhr4Io5G6bOYem3zdDy
	NGCOfUlrg8z9SkIpvYvE7Uf/RqgeduJzuqSV2uMpDfssNBU9FmX9EUccZcBWOe4Daa87oHUgvoq
	Js/sDRizOJyXtbXUhcfwP9XU6UGOoCddpW96zTRDWGSJxA6f5YUsz6Soro5KDOsYZqheUpGHLUE
	gn1bGxXNNnEK/1wG/urmIe6WcXG4SUPu4nGBVTsUgGM+vlM1kb/Qtg4=
X-Google-Smtp-Source: AGHT+IGYKHSOUWuv3Z35/L1kDcj+xko6P82ABEfwOu6IFt4mwFRNrLSNCMYz6YlSXtAKxKsobnoAmQ==
X-Received: by 2002:a05:600c:46ca:b0:434:a367:2bd9 with SMTP id 5b1f17b1804b1-438913dfd7fmr310320675e9.14.1737675901922;
        Thu, 23 Jan 2025 15:45:01 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd54c0ecsm6510925e9.30.2025.01.23.15.44.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:45:00 -0800 (PST)
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
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 08/20] accel/tcg: Restrict tlb_init() / destroy() to TCG
Date: Fri, 24 Jan 2025 00:44:02 +0100
Message-ID: <20250123234415.59850-9-philmd@linaro.org>
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

Move CPU TLB related methods to accel/tcg/ scope,
in "internal-common.h".

Suggested-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/tcg/internal-common.h | 11 +++++++++++
 include/exec/exec-all.h     | 16 ----------------
 accel/tcg/user-exec-stub.c  | 11 +++++++++++
 3 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/accel/tcg/internal-common.h b/accel/tcg/internal-common.h
index c8d714256cb..d3186721839 100644
--- a/accel/tcg/internal-common.h
+++ b/accel/tcg/internal-common.h
@@ -53,6 +53,17 @@ TranslationBlock *tb_link_page(TranslationBlock *tb);
 void cpu_restore_state_from_tb(CPUState *cpu, TranslationBlock *tb,
                                uintptr_t host_pc);
 
+/**
+ * tlb_init - initialize a CPU's TLB
+ * @cpu: CPU whose TLB should be initialized
+ */
+void tlb_init(CPUState *cpu);
+/**
+ * tlb_destroy - destroy a CPU's TLB
+ * @cpu: CPU whose TLB should be destroyed
+ */
+void tlb_destroy(CPUState *cpu);
+
 bool tcg_exec_realizefn(CPUState *cpu, Error **errp);
 void tcg_exec_unrealizefn(CPUState *cpu);
 
diff --git a/include/exec/exec-all.h b/include/exec/exec-all.h
index d9045c9ac4c..8eb0df48f94 100644
--- a/include/exec/exec-all.h
+++ b/include/exec/exec-all.h
@@ -29,16 +29,6 @@
 
 #if !defined(CONFIG_USER_ONLY) && defined(CONFIG_TCG)
 /* cputlb.c */
-/**
- * tlb_init - initialize a CPU's TLB
- * @cpu: CPU whose TLB should be initialized
- */
-void tlb_init(CPUState *cpu);
-/**
- * tlb_destroy - destroy a CPU's TLB
- * @cpu: CPU whose TLB should be destroyed
- */
-void tlb_destroy(CPUState *cpu);
 /**
  * tlb_flush_page:
  * @cpu: CPU whose TLB should be flushed
@@ -223,12 +213,6 @@ void tlb_set_page(CPUState *cpu, vaddr addr,
                   hwaddr paddr, int prot,
                   int mmu_idx, vaddr size);
 #else
-static inline void tlb_init(CPUState *cpu)
-{
-}
-static inline void tlb_destroy(CPUState *cpu)
-{
-}
 static inline void tlb_flush_page(CPUState *cpu, vaddr addr)
 {
 }
diff --git a/accel/tcg/user-exec-stub.c b/accel/tcg/user-exec-stub.c
index 4fbe2dbdc88..1d52f48226a 100644
--- a/accel/tcg/user-exec-stub.c
+++ b/accel/tcg/user-exec-stub.c
@@ -1,6 +1,7 @@
 #include "qemu/osdep.h"
 #include "hw/core/cpu.h"
 #include "exec/replay-core.h"
+#include "internal-common.h"
 
 void cpu_resume(CPUState *cpu)
 {
@@ -18,6 +19,16 @@ void cpu_exec_reset_hold(CPUState *cpu)
 {
 }
 
+/* User mode emulation does not support softmmu yet.  */
+
+void tlb_init(CPUState *cpu)
+{
+}
+
+void tlb_destroy(CPUState *cpu)
+{
+}
+
 /* User mode emulation does not support record/replay yet.  */
 
 bool replay_exception(void)
-- 
2.47.1


