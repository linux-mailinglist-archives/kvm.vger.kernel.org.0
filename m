Return-Path: <kvm+bounces-20102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D21DA9109AD
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:23:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30D53B21649
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20ECF1AF696;
	Thu, 20 Jun 2024 15:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hjL7CM1x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AF81B0109
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896955; cv=none; b=IQK+mC7Po1NfWYzGX7mt7O0yw41dHWhnYHcgH55dvaEuD8OPjABDWac1HGmJ2NYBE5DTUaCPDdr+2uQrFOM8VUtZv26nCiz7mr+Sh+Z8WT2w6Ab+cJf0HRQCOA/cnDZl2Z06WF3F2hO+z6r1/WD0lQ+apbqtB+KDa5ik2z+jve4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896955; c=relaxed/simple;
	bh=jmtIKePhQcjj1EOi2/U3yq7fxT7nUM+IOtIIQSVIq5o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QR5WxvT2djEx61/tZlwN7EnJU3OnaugtdpJWPbpi3KSNyJzAQLHBnyNRF8X4eaxzzsqiwfhSRoAp7dTZ4rVPUsRe2keopK46USD4yU3IFxkG8ZVbD1lLe2mHg+W+QobZ53Gd1pSfn2nLAzuVW4P2IHW8SqCq0HTWS2TD13mYA6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hjL7CM1x; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-52c525257feso1144337e87.1
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718896952; x=1719501752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a0NIpkhyGGYgnbxSmBPfzzcGZB9GrmkEzQVe5cCnoVc=;
        b=hjL7CM1xS2IEyVB0PRyCYjmg6WmCaWbDOYVC56v6AHDiOIswtRyWvmFucGSNlqv04S
         8nnnA2rEEub7O4VREozGljsjc/CAkoZtwgtmhruerdeM+gt6D+NqOAynqHEq5KFzLujc
         +wFa19cPiboRbFY2TdJqJPJ8Vg3HW66hBL2QdSG8SeI1qsWAXylTJX4Xjj0IE+QI7vHy
         JySlB+s2jPwBooGrOpP4j2qgdQ8WO0ZTZ+lmuf6SRZ5kgTQ7rjLZV9kE06ZKNxlEUW1h
         1r/GBIgMvLisNR5ZFlaWeULommLXHbwY2vSmzZnDPd5hvMEqJg3n2aibccoRyVR/BHwJ
         BtIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718896952; x=1719501752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a0NIpkhyGGYgnbxSmBPfzzcGZB9GrmkEzQVe5cCnoVc=;
        b=wlDFokleRwG+J+bH5FvDJcKpvvIj09o0Iawp5pg/8EUkpBP7CX/OGia8PqW2Dbvvdh
         lwYi/Ty5HXaMXCEVy5Tx4LspYa3FBgaKIH5/UiW8MS2mS1vwyYp7Wr4yINHiFNJdO8UF
         mVtfLz5cW58IOTlTOkvvoN+CMt3F0NfwhRHUXSMjx+bArSb4A+W43GlfeqG0oMim9VD4
         w7lbso/bvQvalwGphQQwGkmZIqnJJ/ys5jcIegRnA1uNa+LOj/Up4iPbmfXZ/7Aouuf1
         vzGTbfJueKVHjqWqFfjLXwrVIr/zLpO39kB9FBJG3egST7hVCWRzPbZVCo8NdPyDvifd
         x8qA==
X-Forwarded-Encrypted: i=1; AJvYcCV+PRZdLIeDksKdJDV8oA31B29nfbbGwiOMq74Z+Bbjkl+euV9mAH/+X4ba1ye3DlA9V51cvIsek/ornUQFj37Nbdme
X-Gm-Message-State: AOJu0Yy4/FkLNV0cOPSPCas1m7+3WOwn6KZFDKkmACXDxB+NWnFCznKB
	JOhIltRyjEXC6Wi2pqEk7YMcYYnBrOuvaGhNr09Zg8dLODlNbfuWS8Cij3+oK2I=
X-Google-Smtp-Source: AGHT+IF/Ow3t51hj2zvFm2LAur2fftlTRBJVGqnvOSs+DkFtw+O0hxF8fAtrEgLsUxfRTp/WRXnwOw==
X-Received: by 2002:a05:6512:6d3:b0:52c:7f7f:dc1f with SMTP id 2adb3069b0e04-52ccaa5c755mr4114734e87.61.1718896951767;
        Thu, 20 Jun 2024 08:22:31 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ed0f2asm783454366b.131.2024.06.20.08.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:22:28 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id B3C945FA03;
	Thu, 20 Jun 2024 16:22:21 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-arm@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 07/12] qtest: move qtest_{get, set}_virtual_clock to accel/qtest/qtest.c
Date: Thu, 20 Jun 2024 16:22:15 +0100
Message-Id: <20240620152220.2192768-8-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240620152220.2192768-1-alex.bennee@linaro.org>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierrick Bouvier <pierrick.bouvier@linaro.org>

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20240530220610.1245424-5-pierrick.bouvier@linaro.org>
---
 include/sysemu/qtest.h |  3 ---
 accel/qtest/qtest.c    | 12 ++++++++++++
 system/qtest.c         | 12 ------------
 3 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/include/sysemu/qtest.h b/include/sysemu/qtest.h
index 45f3b7e1df..c161d75165 100644
--- a/include/sysemu/qtest.h
+++ b/include/sysemu/qtest.h
@@ -34,9 +34,6 @@ void qtest_server_init(const char *qtest_chrdev, const char *qtest_log, Error **
 void qtest_server_set_send_handler(void (*send)(void *, const char *),
                                  void *opaque);
 void qtest_server_inproc_recv(void *opaque, const char *buf);
-
-int64_t qtest_get_virtual_clock(void);
-void qtest_set_virtual_clock(int64_t count);
 #endif
 
 #endif
diff --git a/accel/qtest/qtest.c b/accel/qtest/qtest.c
index 53182e6c2a..bf14032d29 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -24,6 +24,18 @@
 #include "qemu/main-loop.h"
 #include "hw/core/cpu.h"
 
+static int64_t qtest_clock_counter;
+
+static int64_t qtest_get_virtual_clock(void)
+{
+    return qatomic_read_i64(&qtest_clock_counter);
+}
+
+static void qtest_set_virtual_clock(int64_t count)
+{
+    qatomic_set_i64(&qtest_clock_counter, count);
+}
+
 static int qtest_init_accel(MachineState *ms)
 {
     return 0;
diff --git a/system/qtest.c b/system/qtest.c
index 8cb98966b4..12703a2045 100644
--- a/system/qtest.c
+++ b/system/qtest.c
@@ -325,18 +325,6 @@ static void qtest_irq_handler(void *opaque, int n, int level)
     }
 }
 
-static int64_t qtest_clock_counter;
-
-int64_t qtest_get_virtual_clock(void)
-{
-    return qatomic_read_i64(&qtest_clock_counter);
-}
-
-void qtest_set_virtual_clock(int64_t count)
-{
-    qatomic_set_i64(&qtest_clock_counter, count);
-}
-
 static bool (*process_command_cb)(CharBackend *chr, gchar **words);
 
 void qtest_set_command_cb(bool (*pc_cb)(CharBackend *chr, gchar **words))
-- 
2.39.2


