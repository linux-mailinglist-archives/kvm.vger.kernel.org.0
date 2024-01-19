Return-Path: <kvm+bounces-6470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D63658328E1
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 12:36:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7F611C23A4D
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 11:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF654F894;
	Fri, 19 Jan 2024 11:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A9WVw3dl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD744F615
	for <kvm@vger.kernel.org>; Fri, 19 Jan 2024 11:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705664130; cv=none; b=lCPhiL+awWPDxNvC4tWh3WFEE+T/F4RnArMSNp1LmRcU7eDLn5Ucnc7OhF0tcj2xy9f8YL+aj5c0VykDHX0J5gnlfxylmB55XXv6Q1I2oRYnZtxmE2g1M6fyH6no/EhAY12AwJ93Br9TVbsXzAlbcBpjqRdQNNarmjd3sSYWKQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705664130; c=relaxed/simple;
	bh=Qgyin/o3RSTIuThCiCSuzQzPUzhql5UlpLwSaiSNak4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AQ0L8sy4nQprea3n2oCFYmRTjreFc/8kgxUghjUMrrwL/lNU6umdhLLsPBYQM+FvwrKVRjF1DyqmX0dpgM7LZezSTgeMFKK6i8ub1XaGLjNTe822+Uln0JmaOdu/zn7HOBuplXinFqGc6/IDAoZZVdDSrO/AjbcKbzoN6EqXIwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A9WVw3dl; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-40e9d4ab5f3so6321215e9.2
        for <kvm@vger.kernel.org>; Fri, 19 Jan 2024 03:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705664127; x=1706268927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H2zlYB8RHgO8CCP+jqoBT970ZAV+LbSEyEbXoFvRXkI=;
        b=A9WVw3dlYm56rd9Lo4Z++8OnvGC6zdaRuF+xFATIwdUiv6KH4K9Q+wytAi9uFTco+M
         tcKR7GR5/l8NmtCNyDESdITEubMt3QWm9m8PKNR8kly8u4/Dpgowm7EBq0sMBFpKUOSS
         sWZYqYeOanDV5LmXa8gXcHcSnW9qPfK519p9Nw2JHOyYJOBeR82fhDuhhJto+SxPYd42
         U7da5kiZNSPwpCl1lW/YrwSZ/1yqf01h7MLg1BgxxbcjRWRVCkaYmEeSIRu/mfFujm2H
         ZKaFYdP/akhAagMhuggSqFhU7rovxRGvr+NsN2kia+ptZhZdKDnn3azAkHDkc0tIqj8R
         9aJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705664127; x=1706268927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H2zlYB8RHgO8CCP+jqoBT970ZAV+LbSEyEbXoFvRXkI=;
        b=TrwT7D2PWpuGTIM3K+QsIjZbju+rfRxOXHRG3kM5+oxLftJq1ZTDW/29Zyuv558dIa
         a8AGI4uN/Ulw9xS4DayAIR49iZmXrxotgFizvJRGF9erXqi1TjqG8ycKcLOuG239o1jR
         Z8h6I7mMgAsWbUXQPWtu3ec9oJ22CkzUY7WB07xQGDhvsMrQz6UvgULx79ER5fIFUw8W
         2HUwZLYdn/hvDmuhGHaZ9414SumAZ0eWvxgjNKAiRDWxutp4ao+tDBnz4pmAjEvrnao/
         QKbrn7AKu17qnvGqnChD72q45w0PGNOBkwhlv9RoGo+mdvHyU/aQElFyu03YEKh5Eui0
         ykLg==
X-Gm-Message-State: AOJu0YyPdEWT7n4qX+p5I3TFOCulz1l/oN/xfy+xy6Bx5mZRcAgxLpMR
	aYrjH1EXlaBJEOKhekbZNPuywTfB6YXj5eVW5BXUvRXW04++dLLslIQWy+4d5gw=
X-Google-Smtp-Source: AGHT+IGXU2gL8oAHDVoYCWzkuB2wKuhhJqWN9FvsoGiKo9WKC58O5rIAZisM3Bq3Tpucyvg8fXp3yg==
X-Received: by 2002:a05:600c:46cf:b0:40e:5118:5046 with SMTP id q15-20020a05600c46cf00b0040e51185046mr1365481wmo.21.1705664127043;
        Fri, 19 Jan 2024 03:35:27 -0800 (PST)
Received: from localhost.localdomain (91-163-26-170.subs.proxad.net. [91.163.26.170])
        by smtp.gmail.com with ESMTPSA id p10-20020a05600c358a00b0040e559e0ba7sm32395502wmq.26.2024.01.19.03.35.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Jan 2024 03:35:26 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: [PULL 04/36] accel: Do not set CPUState::can_do_io in non-TCG accels
Date: Fri, 19 Jan 2024 12:34:33 +0100
Message-ID: <20240119113507.31951-5-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240119113507.31951-1-philmd@linaro.org>
References: <20240119113507.31951-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

'can_do_io' is specific to TCG. It was added to other
accelerators in 626cf8f4c6 ("icount: set can_do_io outside
TB execution"), then likely copy/pasted in commit c97d6d2cdf
("i386: hvf: add code base from Google's QEMU repository").
Having it set in non-TCG code is confusing, so remove it from
QTest / HVF / KVM.

Fixes: 626cf8f4c6 ("icount: set can_do_io outside TB execution")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20231129205037.16849-1-philmd@linaro.org>
---
 accel/dummy-cpus.c        | 1 -
 accel/hvf/hvf-accel-ops.c | 1 -
 accel/kvm/kvm-accel-ops.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/accel/dummy-cpus.c b/accel/dummy-cpus.c
index f4b0ec5890..20519f1ea4 100644
--- a/accel/dummy-cpus.c
+++ b/accel/dummy-cpus.c
@@ -27,7 +27,6 @@ static void *dummy_cpu_thread_fn(void *arg)
     bql_lock();
     qemu_thread_get_self(cpu->thread);
     cpu->thread_id = qemu_get_thread_id();
-    cpu->neg.can_do_io = true;
     current_cpu = cpu;
 
 #ifndef _WIN32
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index 8eabb696fa..d94d41ab6d 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -428,7 +428,6 @@ static void *hvf_cpu_thread_fn(void *arg)
     qemu_thread_get_self(cpu->thread);
 
     cpu->thread_id = qemu_get_thread_id();
-    cpu->neg.can_do_io = true;
     current_cpu = cpu;
 
     hvf_init_vcpu(cpu);
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 45ff06e953..b3c946dc4b 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -36,7 +36,6 @@ static void *kvm_vcpu_thread_fn(void *arg)
     bql_lock();
     qemu_thread_get_self(cpu->thread);
     cpu->thread_id = qemu_get_thread_id();
-    cpu->neg.can_do_io = true;
     current_cpu = cpu;
 
     r = kvm_init_vcpu(cpu, &error_fatal);
-- 
2.41.0


