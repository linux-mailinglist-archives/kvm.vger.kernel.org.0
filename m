Return-Path: <kvm+bounces-41616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9695FA6B0DB
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:32:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 242009824D8
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B88B922A7F1;
	Thu, 20 Mar 2025 22:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jYjtQq+j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F9422A7E5
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509828; cv=none; b=C+ezQdBzSAbyDevFWeCBG/WUA3NK5Tyd3r/7dZ34ShwT+WvcNKwIGWdenSljrCMht4WlPuJKQIRCCoxlsYi8xQxdRezzrFUZKgaCUmK4GQ8K3ubUHCugOfDrY4bW63CA5Hk2dozHP8kFaqTDSra0mwCb8KBIPh3+yMPDh5vEA3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509828; c=relaxed/simple;
	bh=1v/Wc/sz3jGZAAU0A2kkqCFlelDJtNXufKxX1y5icdo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bkDboMqHE1fLTKd1KqpgREKZE4WkD3WCsTp4AMcC33v7wjZ+P3yhJzRC9m4HmpuUyToxXNcvClpKA0VwMkzcPD6EFMuQDIvGwvSNGcNxKS8KStLdtZofTlTgmIwcU6xcQwyqZsu+PqW7IS9O+stfMItfTG65cN3Rc3VuAwEBJYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jYjtQq+j; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-223f4c06e9fso22984575ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509826; x=1743114626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=avokc7PtwidAIhGAXsNkScUiPBrKycg0jtKiMA4KDgs=;
        b=jYjtQq+jR2xyu4ruixS3sT6CFROjGoyP4VmEvija5KH1FP1xhELA3j5UgayauaLCnl
         pjYw71vQPkwjzQS1XcFxhZhGnpUw7mH/95Lst6XGOqnfTRaL2VdWea9Ut0V6uFGLg8vQ
         d6uqnvZ3oIxrt6ZlajbGb6fCwJA5g6Em/gxE5GZl7tmgQEO/7cLQmnewZUJ4ptUESS2n
         JMjLLZntWnbVvPyf1GOCsAPXimoPMeXF5XQT8/kTtz3MKh9KFSn+i1Jko50uLsnTyJ9v
         fC2Tyu8jXUO6m9c7JxnNKzruvtq3BLdRn5B7+eoV61jBA/GlnNXfMcRi1VURsKw6sufY
         iTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509826; x=1743114626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=avokc7PtwidAIhGAXsNkScUiPBrKycg0jtKiMA4KDgs=;
        b=hOp6nqMjULn3G3Pm0xpZZt7PjGHTxV4zB9k3OMMJY/Sw+b5HsqboFrw9MQ66e3sXqO
         DkVdT8YqM8Ebj5QheAP7m6WF21o8y/4td/lj689x0F9OJ3t8seDy46Af0tvQAdhFqV1m
         bBTjbliK6ge4DkeI7/aMM7O2tu6pQjLaGOex870qbOThcxU9auMLDewJaoKYwhptpEl4
         i2TYvb01p9oevuS6fLBFpRG7kjRbIFoWhL/6he+rZhYFfrVwthmhh0YLh1TP3h2YOPXf
         BeckvecRlNrn0SqHyaf6LGpFny8Dj+OcIqXjWVIEXsOROID7R6V85uDFAoOa1iZSrM1n
         HGSw==
X-Gm-Message-State: AOJu0YzNGRkCr45lllONhNIoGtrbPOiarlcD7t9qWyjwGARbhbovhUaX
	HO5C0S6mpZTxOmaB5Ky+3CYhVg9S3ZWO1F6Kas8fjOGYTdmttCIoNYzy8ugmPs0=
X-Gm-Gg: ASbGnctQxSpoGsQQYoY6bCSt+qcH78FLC5aN4aD1rdZNM6lnnMAZzpxSoxyz4fLVsRG
	yXGreI+9wKjetGTm1FGf72RkpI19FVOZ7PWptGrhkKSjYQZikVruHlYwxCAn4N/ncwZZshFKX+n
	nO8zhStpOb8QNKx7MBP6srWoW15Ar0yZAYeYnwJ4jTwpbEskkzWZEtggvjd1deWQpCUXB0zp5u6
	CkWW4oSyXCBrpfb20nkiI83KHgL+IdD54Rstni+g4dbmG5WqSgiw3kT6Kc+x8CaJOqaunnryVkX
	PK/qB1DSqzOUzU4Pr7J/QqnZ030Ei85wavE2F3l3c8xL
X-Google-Smtp-Source: AGHT+IGEEKE91spkEXTcAVV49R6+3YhJ1RqwkB0C8ZoyykH1H01x06i5gZ0hciM5xTE4CtOtK2OMPw==
X-Received: by 2002:a17:902:ef4f:b0:21f:1348:10e6 with SMTP id d9443c01a7336-227806cfff4mr22432425ad.13.1742509825855;
        Thu, 20 Mar 2025 15:30:25 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:25 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 13/30] accel/tcg: fix missing includes for TARGET_HAS_PRECISE_SMC
Date: Thu, 20 Mar 2025 15:29:45 -0700
Message-Id: <20250320223002.2915728-14-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We prepare to remove cpu.h from cpu-all.h, which will transitively
remove it from accel/tcg/tb-internal.h, and thus from most of tcg
compilation units.

Note: this was caught by a test regression for s390x-softmmu.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/poison.h | 1 +
 accel/tcg/tb-maint.c  | 1 +
 accel/tcg/user-exec.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/exec/poison.h b/include/exec/poison.h
index 964cbd5081c..c72f56df921 100644
--- a/include/exec/poison.h
+++ b/include/exec/poison.h
@@ -38,6 +38,7 @@
 #pragma GCC poison TARGET_SUPPORTS_MTTCG
 #pragma GCC poison TARGET_BIG_ENDIAN
 #pragma GCC poison TCG_GUEST_DEFAULT_MO
+#pragma GCC poison TARGET_HAS_PRECISE_SMC
 #pragma GCC poison BSWAP_NEEDED
 
 #pragma GCC poison TARGET_LONG_BITS
diff --git a/accel/tcg/tb-maint.c b/accel/tcg/tb-maint.c
index d5899ad0475..efe90d2d695 100644
--- a/accel/tcg/tb-maint.c
+++ b/accel/tcg/tb-maint.c
@@ -20,6 +20,7 @@
 #include "qemu/osdep.h"
 #include "qemu/interval-tree.h"
 #include "qemu/qtree.h"
+#include "cpu.h"
 #include "exec/cputlb.h"
 #include "exec/log.h"
 #include "exec/exec-all.h"
diff --git a/accel/tcg/user-exec.c b/accel/tcg/user-exec.c
index 667c5e03543..9d82d22bf40 100644
--- a/accel/tcg/user-exec.c
+++ b/accel/tcg/user-exec.c
@@ -19,6 +19,7 @@
 #include "qemu/osdep.h"
 #include "accel/tcg/cpu-ops.h"
 #include "disas/disas.h"
+#include "cpu.h"
 #include "exec/vaddr.h"
 #include "exec/exec-all.h"
 #include "exec/tlb-flags.h"
-- 
2.39.5


