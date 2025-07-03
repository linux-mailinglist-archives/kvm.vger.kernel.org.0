Return-Path: <kvm+bounces-51451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21257AF7156
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:01:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D8185272D6
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1B22E3397;
	Thu,  3 Jul 2025 11:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a+ANwHei"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4152E2F03
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540399; cv=none; b=ZITkuUl1bNLzHKYpmYZMElwaaSXeeJO8Vp8JJ/AUaDCjlAChxm4GePhEwhXf24pgxLVWXodnCn2tg6yklK61fSNbDNvi02HHlf99epmscuBF1L32rd8Oll3zKqB9erCsHL0MZBzGVxMnDZ5Z4n+dJtpx7M/bJDg6RZRhquPMdZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540399; c=relaxed/simple;
	bh=OA7NyJnul1v0uPJThlucMLA7h//6EhxZ3v3F1U7edKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ko3uo1RuyW8S8r70na6Cze1pDApmFK72aGsESECh7uup4KCdxTItXM2AuIMwumV0b5SAKJpIKWo4C+qfU1kMtv9QKIbq4y4YRniXVTno+SwrszfgmAPFm3dhxJq6aJvL9apa6KhVYVMyXqUtKC/r3xrsJnJidGG5OnKSFNzwvvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=a+ANwHei; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a6d1369d4eso4374007f8f.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540396; x=1752145196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1uXIn8FF+VzmPqfa1+8428fM/RDSExpMjk/8h5CzpzY=;
        b=a+ANwHeiiVth21uPOKDkZwODDGWz6D7TTqQNXoE05vE0n5b10h0tSLIryqapeIviB6
         2FACZK1BpTC+UeR994q+aXTmohaxfLyv5c4/sSiUWXjtGJ7Qdglm/ufJyTueZjCbJIdl
         MlGhM2XgCKJr+GHtTa+J+FPsuUH5wavPxH3yirSsLwhn+BnfEb4eb2meNAyY08Em2XsA
         zK8Iy+J5BoOkbq0LmkBG5XBo/M+TlbLitrPcIp7BqJwdlcObxQI3n1bZ2kHPGSxbgWUk
         xSQs0tiGUSeKQSX+BSD3gDemjwpYFFi4mDjFNAe7fWOoKq4gwq6G5eRRvaESs1lXT+89
         QGbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540396; x=1752145196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1uXIn8FF+VzmPqfa1+8428fM/RDSExpMjk/8h5CzpzY=;
        b=LzHIGrWqv2M6eD5/e0yaXYFlZFnNHixR3msfSsCNkJE+qH4GtUBe8qy7rZKkFRCWs+
         hBGpWb8ngGJmYx5VafRDVJeKWUGpBzxndqO+EW/DY+ogiU7uyz5LKJGcKYJ1ycZBwOcu
         aYt82x2fFkMHpZcK3PcTLb6CFjWzpCH/sEpxpcs6X/02dqcoKeoBIICGwgcZ4P1+j4NK
         7a+AQJiHhg87pXERVyQ42tiMd7IsNYUc/IFFrWrE+zKu09vIJAEGt9RTic3hsSIwhlv3
         za1WAO7djxdu7VFOCWh1v1rdlGvhV2gxYzOcY5r1yhuWU5iHTyAJnBgkd7fexaOyxnzf
         sECw==
X-Forwarded-Encrypted: i=1; AJvYcCXY/QPP4XQg75nADrmsdZIXq2pmkbOa9swefG2Sazn7NfxyNYjO4WHtDay88FsPuHjbbqQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiH42cymn2lnpzEelkOy+cS/d6kf918Zau9UMLHYUMadRLlnhE
	zImqHxaYjswyvdMeZT18on+10pcG5pHtwy/K6BJgoh7kqFRp8v7YQhuTzXX5sN5wMoc=
X-Gm-Gg: ASbGncsxz09FwaU7BUzLWJp7v489yzJlCn3yPT1aFnX8dKfpk62DIJtdW4PM7aPQtNa
	i90eBV/tTBUJW3XvQZA8WGfkPQu2AcHQ40A4V6YaJLEqjppxwoglC292WIIcclUwtUK04QKiBHR
	Bk/eCTDK7VXAfgcZIeZcx8Wwq5ngApPTyacWArNy6qnfefBI1vWDfn/nuSzr/l1r1QRU7fUGI5s
	z6a2VcovME0sMtI+PiDJKh/HFkijc2sTqXXYJtTdly8VbW+qTnHzvRzsYGqIHDUFYMSVsaRnmP6
	CBKsxwFKgyntSMwuxid/rVVGGWJ7ru2vKt/uLRe635W5npETVTcuOgrVg0qqFc1FA/qZil/HTUJ
	VY6KKYh7m9PQ=
X-Google-Smtp-Source: AGHT+IGkl7DBEVSrsarAakeoJRDOUyErzjUrrwRi8jgXThFkNvPPbLQTGnxMgTtTTTxzMt5tQq0f5g==
X-Received: by 2002:a5d:6f02:0:b0:3a5:2575:6b45 with SMTP id ffacd0b85a97d-3b32f666124mr2129038f8f.48.1751540396119;
        Thu, 03 Jul 2025 03:59:56 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7fadf3sm18662688f8f.34.2025.07.03.03.59.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:59:55 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v5 48/69] accel/dummy: Extract 'dummy-cpus.h' header from 'system/cpus.h'
Date: Thu,  3 Jul 2025 12:55:14 +0200
Message-ID: <20250703105540.67664-49-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

'dummy' helpers are specific to accelerator implementations,
no need to expose them via "system/cpus.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/dummy-cpus.h    | 14 ++++++++++++++
 include/system/cpus.h |  5 -----
 accel/dummy-cpus.c    |  1 +
 accel/qtest/qtest.c   |  1 +
 accel/xen/xen-all.c   |  1 +
 5 files changed, 17 insertions(+), 5 deletions(-)
 create mode 100644 accel/dummy-cpus.h

diff --git a/accel/dummy-cpus.h b/accel/dummy-cpus.h
new file mode 100644
index 00000000000..d18dd0fdc51
--- /dev/null
+++ b/accel/dummy-cpus.h
@@ -0,0 +1,14 @@
+/*
+ * Dummy cpu thread code
+ *
+ * Copyright IBM, Corp. 2011
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef ACCEL_DUMMY_CPUS_H
+#define ACCEL_DUMMY_CPUS_H
+
+void dummy_start_vcpu_thread(CPUState *cpu);
+
+#endif
diff --git a/include/system/cpus.h b/include/system/cpus.h
index 3226c765d01..69be6a77a75 100644
--- a/include/system/cpus.h
+++ b/include/system/cpus.h
@@ -7,11 +7,6 @@ void cpus_register_accel(const AccelOpsClass *i);
 /* return registers ops */
 const AccelOpsClass *cpus_get_accel(void);
 
-/* accel/dummy-cpus.c */
-
-/* Create a dummy vcpu for AccelOpsClass->create_vcpu_thread */
-void dummy_start_vcpu_thread(CPUState *);
-
 /* interface available for cpus accelerator threads */
 
 /* For temporary buffers for forming a name */
diff --git a/accel/dummy-cpus.c b/accel/dummy-cpus.c
index 867276144fa..03cfc0fa01e 100644
--- a/accel/dummy-cpus.c
+++ b/accel/dummy-cpus.c
@@ -17,6 +17,7 @@
 #include "qemu/guest-random.h"
 #include "qemu/main-loop.h"
 #include "hw/core/cpu.h"
+#include "accel/dummy-cpus.h"
 
 static void *dummy_cpu_thread_fn(void *arg)
 {
diff --git a/accel/qtest/qtest.c b/accel/qtest/qtest.c
index 8b109d4c03b..2606fe97b49 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -24,6 +24,7 @@
 #include "qemu/guest-random.h"
 #include "qemu/main-loop.h"
 #include "hw/core/cpu.h"
+#include "accel/dummy-cpus.h"
 
 static int64_t qtest_clock_counter;
 
diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
index ba752bbe5de..f412ea346bb 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -18,6 +18,7 @@
 #include "hw/xen/xen_igd.h"
 #include "chardev/char.h"
 #include "qemu/accel.h"
+#include "accel/dummy-cpus.h"
 #include "system/accel-ops.h"
 #include "system/cpus.h"
 #include "system/xen.h"
-- 
2.49.0


