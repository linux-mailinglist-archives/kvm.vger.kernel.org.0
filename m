Return-Path: <kvm+bounces-36772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6357FA20BEB
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:22:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72FCD3A4361
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 14:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C2D1AA1D9;
	Tue, 28 Jan 2025 14:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VH8kakQG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134F5BE40
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738074122; cv=none; b=uDGPhwqf4BM7EufbHQbJUDL4XgadsobfCBOuuWiUz1hDcP0zwp20YuTsCEQrJUjGg7RIejhPv484vMRDE3E9BDR7TUF4q4mbHnjUqfjWNBfCFFS10/K+4gDVqUtn+D/YQpcaSbO+OtSNirTMo84fglQ8WB8vrbg7R7CqxA+TeCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738074122; c=relaxed/simple;
	bh=RFOzBuMsneVwtN783B11tDxukbOuJFk+FGb501bNZqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L9JJCVyUjmL7tkJNnwR9iRrWb16n96uy1d9XShpUVj5FD4tPVQ4qBPr5gIUUPwNJLFoP3sbJ8j02eK8ubnU826IhRZlcOoJmjg/Gk/b3wNajZC+TSXxuZ3bVrvjP8LEijpLs6eIhFS7V8dxuBc/RC1ullTN1yji7ffPCJcHT/vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VH8kakQG; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-438a39e659cso37681395e9.2
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 06:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738074119; x=1738678919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kO0uRE/b6a4B7/JlExmMlApMO3OGmNzh+eMs/4hpwh4=;
        b=VH8kakQGA+DmUgAh0KFwxoaSIa3YPYB9ZhYKRGdtmaHj/NruXD3XBAZ7kf7Fp6MCrL
         WU3Ingh7SBv9J4M2WazMBbsrleWjJtf/LrR9wHZysikc0amo7YALgZwbwlkvmZsvOoGI
         BkUsk4ppA1NbMBB4intXfbwvQWW64G49gnRfCSosgFg1L/EtV/yJpN7F9hRVCRkZh6Yd
         4TkQVvLrI82Za+Dpgc71X+Nd1rkanR48ul8yYOfYo5jXo3P7ffbZEWhgLeAVgAqYUWsb
         FvIDLCYhtLJBOioJR/hSGfSsybdOjZEpGOD+B8f+sDZYaO/HDZFDXkGvGJ4JtEtgp9EC
         Es+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738074119; x=1738678919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kO0uRE/b6a4B7/JlExmMlApMO3OGmNzh+eMs/4hpwh4=;
        b=fHpFJqNLNqAt3tMkLVS32jf3gDqhzP22fRL4gEzgOOMUjnKGCtf//VmCYTYLkQJMN/
         I3mnkdZwgYlqRl7Ht27ZGeDzxzGjCRtb1FjR/UowqPnWpinzAbeRjrcyj2db3bF4FY1p
         JSO0Y3I3/yAC2HOAN1IGt1MJld5XBAeHjekND5ZPiI+A5BmBuyyaPrHFsfrVBBGWIliS
         Tml+UAX8F8jdSgDDAi4XAKxIuc0+nKwWs7TodjS6rHWaTzg+7XLGhJpyTLSmEn/Yk/V8
         5u2+GXf6RN3yLM7R30zKrr8mAwtJnYuPSd+0ZQvoQDZL08GJ8y0MfBqxgor4n0fP9qhl
         kNqA==
X-Forwarded-Encrypted: i=1; AJvYcCVVVVJzZ7CohGp8Ycw2p4O+rzlp/U0OgUdMbi//ejMlDOsv07QGlFqqTdgoc6COd+n17FU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5BQ768ncwEasrT4AWdxSkwMgNuEnW2bY1a3SAbUid9FG85UO0
	vNeakVtsuZKkbJouVvlwxh5yUwgk5XWQXt4ShCp4njKhm+vmeCGRHWDEluBSl9o=
X-Gm-Gg: ASbGncsGgXLhK+epWH5BRRDZui/ihEAXfw/6xkQ3Klk76wD6yznyhKaZ/o5ThJ8gYuV
	9mIa3NUPnLuIoQ9NBJ7OJFM/gdqaGVZvQxjVgCc1es4ygszkg6AAhnIBaMJ5Ksq6lgI2oqEQ7JI
	xMqv/Cfyys+B8upfsnU63j78KogUQ6bvV1pVm++M5CnCk1xgwjmpqVzecU+RDIhC39gK6ocd5jR
	+C4V99J6b83SGllzDzoZXwGNTqVuYw75sWoMdIMd7O/YK+1nfrE1ZWjNnhbH5rKpSOfGjGmKMe6
	Q9plDQtaISD/7TSKjZxDEoG++hA2DRpPknkfSb61ssuf6l/gK23WD+bKm/Kjem7OJ+zridxyVbC
	6
X-Google-Smtp-Source: AGHT+IG02KmwhuUT6IfvBlK1pHwLP8uF0g7mnNTy6Q9yhDmta3+GBFm8pcBIROf6lvdBXsr32dkLzA==
X-Received: by 2002:a05:600c:4e89:b0:434:f739:7ce3 with SMTP id 5b1f17b1804b1-438913cb518mr403560625e9.8.1738074119339;
        Tue, 28 Jan 2025 06:21:59 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd47f0fdsm174363075e9.5.2025.01.28.06.21.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Jan 2025 06:21:58 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [RFC PATCH 1/9] accel/tcg: Simplify use of &first_cpu in rr_cpu_thread_fn()
Date: Tue, 28 Jan 2025 15:21:44 +0100
Message-ID: <20250128142152.9889-2-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250128142152.9889-1-philmd@linaro.org>
References: <20250128142152.9889-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Let vCPUs wait for themselves being ready first, then other ones.
This allows the first thread to starts without the global vcpu
queue (thus &first_cpu) being populated.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/tcg/tcg-accel-ops-rr.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/accel/tcg/tcg-accel-ops-rr.c b/accel/tcg/tcg-accel-ops-rr.c
index 028b385af9a..5ad3d617bce 100644
--- a/accel/tcg/tcg-accel-ops-rr.c
+++ b/accel/tcg/tcg-accel-ops-rr.c
@@ -197,20 +197,21 @@ static void *rr_cpu_thread_fn(void *arg)
     qemu_guest_random_seed_thread_part2(cpu->random_seed);
 
     /* wait for initial kick-off after machine start */
-    while (first_cpu->stopped) {
-        qemu_cond_wait_bql(first_cpu->halt_cond);
+    while (cpu->stopped) {
+        CPUState *iter_cpu;
+
+        qemu_cond_wait_bql(cpu->halt_cond);
 
         /* process any pending work */
-        CPU_FOREACH(cpu) {
-            current_cpu = cpu;
-            qemu_wait_io_event_common(cpu);
+        CPU_FOREACH(iter_cpu) {
+            current_cpu = iter_cpu;
+            qemu_wait_io_event_common(iter_cpu);
         }
     }
 
+    g_assert(first_cpu);
     rr_start_kick_timer();
 
-    cpu = first_cpu;
-
     /* process any pending work */
     cpu->exit_request = 1;
 
-- 
2.47.1


