Return-Path: <kvm+bounces-41902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC4CA6E902
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:00:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F3523AB2E7
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31AD81EE7B3;
	Tue, 25 Mar 2025 04:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Sgibovhw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3A71E3DF4
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878775; cv=none; b=Aq0aV3tNyCXfvwG20MIrWN9TfmW4kVPgwMOfxeD1hVm/M+eM7Nga94jNIv2+XlaWFdgmyIHoXEym+WilhDN5E72DRE+lbLpxHN3FTZISq7xb5n+fbN0/wo0PXfBtQc3gS1TFo/HliXjAYxVWxx6dESe3A6dk1ragkvSLCuXlsXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878775; c=relaxed/simple;
	bh=g8ShIoBqTqEm71nmsr/sJlpxmoX5pD0zgMBxuwdGjEI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XMifhQwEy5FUrd56C7RsrmK832GXjFWrgii5NBLyawjEYw7FiPVHgRe+XtE2/ok/oZ4WE4cUdTj5Q8n0QcRrbPXxuQz5GMFaO5Qp+4o8YXsmjzLdv5VO+XyWsdVq23pfAWJ/QHX1ZnsfX/v10i4iB0tw7r2IYzPV3QWFSUarse8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Sgibovhw; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3035858c687so2065232a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878773; x=1743483573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Id5pPosDfyEQ/m8+tZSrdDNfNTCKXAcrGpGPGvWGZxY=;
        b=SgibovhwnnaY8HrjNZ3G91WlLAY0qm+5ij67y/d/nq6gjJo1GKJBsYLfZ1STwXFoRB
         L4eFzemfoI9RMGoxuRcwwoh+B5hVCeDsRAgozdelP83q1v8n/Pmt9OnYHEhuwWeJltkw
         Px4fLV9Ub0AzdoEpeuIuyuNRmk8YWZjaNViU1YDXewBmB+9b61SvDtYdX/I+xM/3s/B9
         QPj2Zkdwjkb0NWcPA8I7W5gIDTNejB0MOfMbZfyzcLnjsS6VE9XVo775t7KhzswBFFbP
         txqi4fymNyEpg2WZ9c0v3HBqpeVhWvu62+xSu4zuHWNurSfeGYPPy410WnudEBdhGzFD
         4VEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878773; x=1743483573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Id5pPosDfyEQ/m8+tZSrdDNfNTCKXAcrGpGPGvWGZxY=;
        b=wTRN5DKkJUQXxboDrCyYMgCpsV6/QmxBzCEVGDz/JAkN4+zQam+/OqYobNFNCGZKX3
         Ke3IIdWPXFImq388F88XJfp3hd/jg8+Stu6IMnF2g9/d+mFhtC2oRY9Zkb1lSMoBJCix
         lvENWuK4BnwLgHVYxh1Lc8FF6MHA4aQYL1/NEsp2GA1evsPZAHNBzMtVEkzkI0Dn755X
         sY110StQnmydaYEhDlPIT3n1pMc/AoMMj00nxl7RNC8eiicHnKfWatu8ipqXQVoMvGWr
         thOQz/2Af9M8P+Wy0pIkIdEi8BrrhjChZKgSwnHGFNUoKxJUFeT2mV9EIknYHR+PbFHz
         1oIw==
X-Forwarded-Encrypted: i=1; AJvYcCVVRQWyFSFkZ8gn3wu731ieQq6c5BrxR1Eq6qQvXVyPQFn76U2dpj7+7/jJl1e+FdXHe4w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTo3w9bajT2uIk1PbW2wioLUixtNJNo5tpw2AlfACFAhuUrxxp
	AT7pFQPRmloM30uUiz6jsLZh+YIdIf6Ym4NrCKAW4JTyCpDJ0rxpwP//9aKrIlI=
X-Gm-Gg: ASbGncuoBrYGwusabL9xy7KBjslOxnDtnJE8nh8dyNGxIRqqvhFdhBl8Vo1HaxZwzOt
	qtcLOJ++JypYgUBZTjwdxWttZlEs8XIE0pSZ4NLoCP3OFdlbFLWdG/AZ7uVFdGkMw5uKwXyTjGE
	tERqFCkfZrmv9LYcnSeHf6Ix8Mdwbqig7PJnr1KXUdKl7rf7btiHaerlWrUAbm1pzzdX1bNIS8a
	CqjiTbed42rIDlqNNVsqawDuxvogGbAUHxi6wbkJjoDM+BOlS1dMViuw/rWrHghyvE3KmRRN8aV
	Bulm8ULDkOwoioMWyRv59+VI9GfyibwjyfpmPpCgvzSw
X-Google-Smtp-Source: AGHT+IE3ojZ3dw6zf0DQN1QqM31clL7OO0QTiS/Hm2mkhOEWn1LSr74m3PtPxOJna5YJtYoKHucVJA==
X-Received: by 2002:a17:90b:1b46:b0:2ee:ee5e:42fb with SMTP id 98e67ed59e1d1-3030fe7f1a6mr19332641a91.13.1742878773114;
        Mon, 24 Mar 2025 21:59:33 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:32 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 12/29] accel/tcg: fix missing includes for TARGET_HAS_PRECISE_SMC
Date: Mon, 24 Mar 2025 21:58:57 -0700
Message-Id: <20250325045915.994760-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/poison.h | 1 +
 accel/tcg/tb-maint.c  | 1 +
 accel/tcg/user-exec.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/exec/poison.h b/include/exec/poison.h
index 8ec02b40e84..f267da60838 100644
--- a/include/exec/poison.h
+++ b/include/exec/poison.h
@@ -38,6 +38,7 @@
 #pragma GCC poison TARGET_SUPPORTS_MTTCG
 #pragma GCC poison TARGET_BIG_ENDIAN
 #pragma GCC poison TCG_GUEST_DEFAULT_MO
+#pragma GCC poison TARGET_HAS_PRECISE_SMC
 
 #pragma GCC poison TARGET_LONG_BITS
 #pragma GCC poison TARGET_FMT_lx
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


