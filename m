Return-Path: <kvm+bounces-20105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B52C9109B0
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:23:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36044283C06
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9AD11B1420;
	Thu, 20 Jun 2024 15:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JTWzeQQI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB8D1B1411
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896960; cv=none; b=iAZBTi0wKZbLG7EcBX2D+HOFZYkDgsi+1wtkhfSDqwLWJwPSVGpbqTczsMEUrgok2JICyOy+tqefOttzwtJr06oOztR/yrIdEgdQEcvIv4zEgjliYT0ZGQdL2C9t9uKAYGZkvH4cZ5SpzJACiKsgLRcTbv97MstGyVxuOf78VYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896960; c=relaxed/simple;
	bh=AcidVmYUI6No+qBcD3+XqElOHS06xcWQhMyfFyFmudQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kUv7c/fC2gijh2gp8R8oMuCHfZFxM0zk6rS+P8ussRCtVzAv5tHZK66EMd0o+41s7cZBYdhemQmWpd6QHSSRJn9HNIwQXv9Mp5BsoiNjXzh4Tj+OA6MHwzcVIoCCeoF7cazhluP0/AiRY3+kpZ3N+xgFtf/2D3tAB3NJY67P9tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JTWzeQQI; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a6fb341a7f2so130465066b.1
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718896957; x=1719501757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQ8CEbgFXQ50Jx+/zMrlpDCus+bU22jqqVwm5sZfxvc=;
        b=JTWzeQQI/8STMTMQYkYVK+U6yceH2bJw99CoxjJPvcrDv1aKjrYnIG3ZeL/y4Ldutn
         uu0Omj6Q654XkGPJSy7Oxo4bGr8E2/PxbtkEDMb4uY5jIoFMgUy9UxP88Z9tzRP4fI9o
         fPe4bXV17UnxTBYI9noC3EPj7tTv2BOZAdJRSddqtZ5mkJY/WxJZlHT26957ggMQP/n8
         7kjtkujT6XejuoXYOKTcYDP0d7WJ92CvIdnjvxQ7+vE6HWMgMC++vhD1aB2vRrjjH1/6
         OUOFwpxsVRtvZsYfMjKdaCMdzTERHU9MFNpvhWsacC4F/NYiS/UxgtDA38p0Qlt5/9Sy
         P4iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718896957; x=1719501757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQ8CEbgFXQ50Jx+/zMrlpDCus+bU22jqqVwm5sZfxvc=;
        b=gLH3bkRdCEcCqwwVOWPOH0y8/dvJUln/EcTUUDUTO+DR5QpzTxCfHWMWjCRZiH8YJI
         5wrVmVcBxAMcwXAZidfHxvjgwxzFJEijvmYBOn3U7tqL6qZES5iaXv8l0dcmnbCbZXkP
         IWM6u0+Q5ryxOcdMGNUenwMBJXXqiV1NUTfEp2zVKqu+WQpuxlTLLsb8eCwZmG8tJLlO
         B/hABQJQeHCsVjPiiuqah3vyzVDjvqU65GsfocDsK8sHmqc4GjubdykOsz/DAZz8SOFs
         EdRLoJOq4TAvVx/g2QEnydytOPkhuyPuAUAGlx5pXWKjEkDMtuD/0L11NvfFWMhl0P0N
         kJYg==
X-Forwarded-Encrypted: i=1; AJvYcCUQrPYnaZS7XlQUu8orSLEWrlCOVrlGCdpAuOeUEGgFy9p6A7HM7tQ0dvL3XHsXlI1R0TdxbhSw7TD7keW5gHBtSw8E
X-Gm-Message-State: AOJu0YyldoPwvtxeFIz+SAzyCUtd/ef5E2MoG+DRWEPbxpAY8CFJhx3+
	YWBX5JKM/PMfrFoVzoZtzHy08kFFIjaVao/29tFQjzrUjCtUoAXrV/h0Q8bQQQs=
X-Google-Smtp-Source: AGHT+IH9ydE3ImEmECu/jTqHbMKjkbdYKCQBP9DWZg1r82biwaNCpjgKg3b6KL1DuAkpxGXNwAJwVg==
X-Received: by 2002:a17:907:a092:b0:a6f:4ae3:5327 with SMTP id a640c23a62f3a-a6fab609e5dmr478736466b.15.1718896956518;
        Thu, 20 Jun 2024 08:22:36 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ed3590sm782032166b.98.2024.06.20.08.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:22:29 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id E6E735FA08;
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
Subject: [PATCH v2 09/12] plugins: add migration blocker
Date: Thu, 20 Jun 2024 16:22:17 +0100
Message-Id: <20240620152220.2192768-10-alex.bennee@linaro.org>
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

If the plugin in controlling time there is some state that might be
missing from the plugin tracking it. Migration is unlikely to work in
this case so lets put a migration blocker in to let the user know if
they try.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Suggested-by: "Dr. David Alan Gilbert" <dave@treblig.org>
---
 plugins/api.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/plugins/api.c b/plugins/api.c
index 4431a0ea7e..c4239153af 100644
--- a/plugins/api.c
+++ b/plugins/api.c
@@ -47,6 +47,8 @@
 #include "disas/disas.h"
 #include "plugin.h"
 #ifndef CONFIG_USER_ONLY
+#include "qapi/error.h"
+#include "migration/blocker.h"
 #include "exec/ram_addr.h"
 #include "qemu/plugin-memory.h"
 #include "hw/boards.h"
@@ -589,11 +591,17 @@ uint64_t qemu_plugin_u64_sum(qemu_plugin_u64 entry)
  * Time control
  */
 static bool has_control;
+Error *migration_blocker;
 
 const void *qemu_plugin_request_time_control(void)
 {
     if (!has_control) {
         has_control = true;
+#ifdef CONFIG_SOFTMMU
+        error_setg(&migration_blocker,
+                   "TCG plugin time control does not support migration");
+        migrate_add_blocker(&migration_blocker, NULL);
+#endif
         return &has_control;
     }
     return NULL;
-- 
2.39.2


