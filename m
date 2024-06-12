Return-Path: <kvm+bounces-19472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ABE9C905700
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 17:35:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0AF19B2698E
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 15:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D984918131C;
	Wed, 12 Jun 2024 15:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ifLW4S3G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A1B180A8D
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 15:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718206516; cv=none; b=vF2v1zKy399J5rjv+H4hOesKmXYYILh1hEESskbqGVYD0x+MV/OGfN7V61jP6CQjl0P0w9SRjCIwPVRHQMN+bzV4xSiFLjczb2GJU/ztlkI6HKVrsqzwg6OTwg3zRcTSoBo6v6BepH4DE+fs7XpQnhixd/QW630saczvpns60u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718206516; c=relaxed/simple;
	bh=zMyxd/0cgt94CkKT8dAJw6AXCgBcWkEglxBAz0hwelI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Exw3HaGa+e6rwNqAPM9PjDCrj4wAIu2VydFSkPeBakb6s4oCeJU2Xh3LKqTe/HJvryDMkY43YeWF2Hjg458egNA3IyXQQBz0pfIizrRWqikQ48a5NHln4QsFFlJZpMMKuv+9DLd00Q0y3izXFiA9WZxAi52iy0bJ2tSKkb9ZcgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ifLW4S3G; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-57ca578ce8dso1811452a12.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 08:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718206512; x=1718811312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bRGnfZngJdWMgOcvZ7TtStbP9AmubDNWr9Hu5lfqXOc=;
        b=ifLW4S3G5v/KTH8XvaxwZthCyfcBy04stDG9PHhucv+kEr0mbOEEs7lpX6/NW5y+hy
         1wnCIsbsy/h3wTaSRoQeY8RLSPYtzFxoiYM6N5MHZcgxIpJkiSO1n3FxCtoWwlp7fFE7
         HHqNiXS/H3+eYSsnNYnbxFSxxqSazShVHaYHyju6ie1iUFKAt2bDbFfG59tLxYrnig7R
         EzV9kv0S4p/DjAWEM84QukEy/P1g+6Ean913GbvwaZb3AayXRR0Rd7+FnEo6sZ+oY3Kc
         ZJl9AwStt+tW3Vo1YiDL2GhP5n0JqrbEeQC9xpqAfeWC2VE5MBzkjTjyq+3Fz1uNQZOs
         9w1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718206512; x=1718811312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bRGnfZngJdWMgOcvZ7TtStbP9AmubDNWr9Hu5lfqXOc=;
        b=XdwaOwDH20LFTe9DYj3KZs3EVTl+EPF/cqtU5ZPy8EXB7EEwChHrF/1tvXHRPlcEvh
         /ptnRYckBN9gL9dFArSpMsQTx9bMNFie/1tv75Pz6KFji5/fSlLNyorXEjxx0nJYy2jy
         xN0eO2KVPjsdVKBD+MUQ0ZNHPKqXUFP8sPi6hTn9eozxnltBvfsK7HjOZtFNGc+9wC0t
         WqG/k0zdTGUrjWpyGNLUkRIjK2pNj+8nkxSzI8sH5wsBWjXCG5CIE1sT2NU+AuyIwQEi
         U10LvT5RnvZyKdwWGhqQ4luD/OPgLS7t/o8MBPUIgP2+CgoDFw897crlBTQcL109DD9M
         W/6Q==
X-Forwarded-Encrypted: i=1; AJvYcCX3riLv9amSSTwIM2XxyVp8SMwB6GOlrteUBWv8DUWrkdpJETIg+ABxWwOlVUIER1x2drKaRsuA/iJAMBPxCabedLsv
X-Gm-Message-State: AOJu0Yw5sEtXWq/U9Wn63kJC73wd7snY7yNmj9CNVSiFXoeDTsw0EupC
	ypKo8wC6ZMIltQVSPdaj8qnWubWKR8aVb8pbpsY79K49fFoNUi5ZkGxFco/gaV4=
X-Google-Smtp-Source: AGHT+IF/BpQXHDn5YfyPcX+E8r0x84EhBJ4zarPCHSFnZEKPqMjMQ2e+1QuSimw3p+b7y7PH7HguhA==
X-Received: by 2002:a50:aac8:0:b0:579:e6d1:d38b with SMTP id 4fb4d7f45d1cf-57ca97562b0mr1891081a12.2.1718206512236;
        Wed, 12 Jun 2024 08:35:12 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57ca472956bsm1950484a12.29.2024.06.12.08.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 08:35:11 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id ABA8F5F944;
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
Subject: [PATCH 5/9] qtest: use cpu interface in qtest_clock_warp
Date: Wed, 12 Jun 2024 16:35:04 +0100
Message-Id: <20240612153508.1532940-6-alex.bennee@linaro.org>
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

This generalises the qtest_clock_warp code to use the AccelOps
handlers for updating its own sense of time. This will make the next
patch which moves the warp code closer to pure code motion.

From: Alex Bennée <alex.bennee@linaro.org>
Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20240530220610.1245424-3-pierrick.bouvier@linaro.org>
---
 include/sysemu/qtest.h | 1 +
 accel/qtest/qtest.c    | 1 +
 system/qtest.c         | 6 +++---
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/sysemu/qtest.h b/include/sysemu/qtest.h
index b5d5fd3463..45f3b7e1df 100644
--- a/include/sysemu/qtest.h
+++ b/include/sysemu/qtest.h
@@ -36,6 +36,7 @@ void qtest_server_set_send_handler(void (*send)(void *, const char *),
 void qtest_server_inproc_recv(void *opaque, const char *buf);
 
 int64_t qtest_get_virtual_clock(void);
+void qtest_set_virtual_clock(int64_t count);
 #endif
 
 #endif
diff --git a/accel/qtest/qtest.c b/accel/qtest/qtest.c
index f6056ac836..53182e6c2a 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -52,6 +52,7 @@ static void qtest_accel_ops_class_init(ObjectClass *oc, void *data)
 
     ops->create_vcpu_thread = dummy_start_vcpu_thread;
     ops->get_virtual_clock = qtest_get_virtual_clock;
+    ops->set_virtual_clock = qtest_set_virtual_clock;
 };
 
 static const TypeInfo qtest_accel_ops_type = {
diff --git a/system/qtest.c b/system/qtest.c
index 507a358f3b..5be66b0140 100644
--- a/system/qtest.c
+++ b/system/qtest.c
@@ -332,14 +332,14 @@ int64_t qtest_get_virtual_clock(void)
     return qatomic_read_i64(&qtest_clock_counter);
 }
 
-static void qtest_set_virtual_clock(int64_t count)
+void qtest_set_virtual_clock(int64_t count)
 {
     qatomic_set_i64(&qtest_clock_counter, count);
 }
 
 static void qtest_clock_warp(int64_t dest)
 {
-    int64_t clock = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL);
+    int64_t clock = cpus_get_virtual_clock();
     AioContext *aio_context;
     assert(qtest_enabled());
     aio_context = qemu_get_aio_context();
@@ -348,7 +348,7 @@ static void qtest_clock_warp(int64_t dest)
                                                       QEMU_TIMER_ATTR_ALL);
         int64_t warp = qemu_soonest_timeout(dest - clock, deadline);
 
-        qtest_set_virtual_clock(qtest_get_virtual_clock() + warp);
+        cpus_set_virtual_clock(cpus_get_virtual_clock() + warp);
 
         qemu_clock_run_timers(QEMU_CLOCK_VIRTUAL);
         timerlist_run_timers(aio_context->tlg.tl[QEMU_CLOCK_VIRTUAL]);
-- 
2.39.2


