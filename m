Return-Path: <kvm+bounces-19473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D1E6905701
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 17:36:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2147D28248F
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 15:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B501181327;
	Wed, 12 Jun 2024 15:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ieevseac"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0539E180A9B
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 15:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718206516; cv=none; b=JbBu4k71PhehU1HU/6fhDCTrqTSD64I4iA+KkdKurDM6kyBryuQ50JXwQ2KKenKzVWP8y8onc5U4BDHiW/H/hL7HtYn/21G5dnvxzd2FVW4XXPOwraazK5nK+I5TKk5jPpJdXWDEa/j1Ba4XAG9bc2hWO4WShuXgeCu/nRXi+RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718206516; c=relaxed/simple;
	bh=jmtIKePhQcjj1EOi2/U3yq7fxT7nUM+IOtIIQSVIq5o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UMrmsV/y4XPGqf1MjbrSYdj1b2IdPvwTVX/unT9Tb5oCG3ETybqbDTzWFfFYqBzFVB/5Q6bei28XiF1WjSevd/NNEAgkfLWe9bUYaMyLM/1LgTkmRHjISFq15Dy6MiBD/sZAwVOsgz9chFZt3nVshbECgwo2Xt5IxwEpJOMdVx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ieevseac; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-572c65cea55so1728059a12.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 08:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718206513; x=1718811313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a0NIpkhyGGYgnbxSmBPfzzcGZB9GrmkEzQVe5cCnoVc=;
        b=IeevseacMlTK3FwgI+zwjBrraJxgr5eZqoCRzNs98BWRE2e5Z2cLOV6m7Ytz1QL7lO
         TxsK7/C5W+LdOKb0cATM6ijmFNSzesEZSjUdxL1GzlnogC+o4AYDsy7SZKAnjFE5cwA9
         x4pURL9rsIHwvE82DaOKk4aT+HdSiG9jcbifhg7HFJgtJX9kg7onIdNehrRTxHqFHOlu
         8QJtf17Us/y0oOyLCQlVtBqz5UpU3djaPG/koCJcdod5aYOWixiQEVUrW5dT4jYVu/1J
         stVfsloytitZR4M/Imojokb1SAJ+/BT58trmlZLHtlJagyv1/te9VScZ4MQ9wWmjJCHw
         QevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718206513; x=1718811313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a0NIpkhyGGYgnbxSmBPfzzcGZB9GrmkEzQVe5cCnoVc=;
        b=m+GJQhUgs466Q8RAe3Fko3/itfhIXr0Li3Qe434HabGNSEyN3UzCgjCm6qBDA6bTIZ
         jnvG0qoRg/EU/VzfDdfodjLJXgpgS95HMHiimfhPZayUx61Aql5ghDLWxwSwJ9OvBKAn
         SAk6wODSDSgNrEBOgxGyMBCmYgk8pqXLXp0niGb2oRixqasxR73M5DZteG6HYMs/VxZC
         CH2WDD8nrTvaV+JqkYxuTVpsTYUSsqjEzxEeaxQanVt9rXVE+RgVC/jN2vJ3dlWZ4skN
         f0NI6ieUhdStkrVH4SDJa/SBm237FovwRSOdFKIOi7MYevZOIMvXKUSKsg8i+rbCzB2f
         LmPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAtVV9bp5oRkVw54Uc1TCVxV+qKXuMBEG3NRCTsfF62Uyu2jrrnubRNDs//NLLtDh7Vkc28DPkWiZJkAZjTaIBABjh
X-Gm-Message-State: AOJu0YzbJiMVL1PEm2XNsWD2h1yw5TfQ2oUaEHwiFi5MGgtXZnDt4umb
	5fYkWb47nw20tlFNgrJHG+hpXe9Ygug5q/gjzBc0jVORYM4cYIwqSaPc+GWdmfM=
X-Google-Smtp-Source: AGHT+IHiw9ywaeCwe00VTJSJ8JkM2YVfCIcQrjCS/i3yRBDrnPHhfF6suexbyfgKr6PBW9GlUolKmQ==
X-Received: by 2002:a05:6402:703:b0:57c:537a:49c5 with SMTP id 4fb4d7f45d1cf-57cb4c17f24mr6294a12.18.1718206513407;
        Wed, 12 Jun 2024 08:35:13 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57c855b959bsm5045481a12.38.2024.06.12.08.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 08:35:11 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id DE76D5FA1B;
	Wed, 12 Jun 2024 16:35:08 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	qemu-s390x@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	qemu-arm@nongnu.org,
	Alexander Graf <agraf@csgraf.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	qemu-ppc@nongnu.org,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH 7/9] qtest: move qtest_{get, set}_virtual_clock to accel/qtest/qtest.c
Date: Wed, 12 Jun 2024 16:35:06 +0100
Message-Id: <20240612153508.1532940-8-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240612153508.1532940-1-alex.bennee@linaro.org>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
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


