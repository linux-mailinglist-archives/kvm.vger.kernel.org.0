Return-Path: <kvm+bounces-35946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57DBAA16695
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 07:14:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2D687A4026
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 06:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD46188012;
	Mon, 20 Jan 2025 06:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yegHqPlF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05881170A26
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 06:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737353626; cv=none; b=lgYbpbmokhyuAB8FfA9muTrt9Q/q8B/6VaVPLJGSSwviEb+FXuRN2X3AVvoX/+IxlDKXS/tIzsMWru9/CWQ5HZbbHB1Zem83cBcaaACfRNjhY6KkHodFIW06m8SDwjHSo76eHzEXDS76aZdCaVc3JrYTriZ9Ut2bWUcsTVmYRIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737353626; c=relaxed/simple;
	bh=UbcHt2LwLMDBmggxq09TlgZnkfoc/PlJS6gnNXquNYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QMI5lOuPU7KRiW6gzh5vdoDgXf7CUDC7eG8rqs2HQ8JmKiqgCAA4K8WivgIuACaOcO5tCqrChuPSAqU6Ds+Xkf1VC+CXjvyvzhr4OjoWQv02KqMkqDDzVLm6tcSoEr+QPgcg6bfD4LraDTubgEuB9wB+wA6DDz/vP7aVooYatn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yegHqPlF; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-38637614567so1941955f8f.3
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2025 22:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737353623; x=1737958423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Ird8d05maqbGTncIK0+WT8YB4xxN+Zqrhp58nPfLG0=;
        b=yegHqPlFiI3wffbndooyufepv5l5EHjlSvNoWR+Y+k+FQ6+TzRgaazUxTVsLO1yoga
         OpT1er7LCvHQiMxg3JclVpfOZ45GN7E9Mj7lxdveJFBsAIVH5P6FtmAbXBMLuEGu29QX
         eLsFgXGY6e1zs4BJtKq908OxZoGw7l6cD4A38NB+LwfX+cqPGFVJkbJgkCl8qHik/O0X
         zETm5I7AtfZPtyOt6os4nSmcEnse0Mtnxa9oxddflIBHG5ZL6/X4Jc2ONUNU1p1oGq/q
         U0D5y7QzQ2njzKVWsMndICe7+YABOU12LZpfNE+UC/QbVftb0SIVS7nUzqNXfYU7iEhQ
         i7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737353623; x=1737958423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Ird8d05maqbGTncIK0+WT8YB4xxN+Zqrhp58nPfLG0=;
        b=q1t1NTT0XQUHaTO6kCHZQt6F06pVWgEninUNnNEcIhmVYgi4tIb/CwbIXzqmrq02f4
         K/WO31W7T7RfHxXU6NWyuujQRq2bmWnoAPT3k5WfZpehkGXWcs08FFc+zrHotthUC29m
         A5ZTtbWgssfPw+C2jbJOwJX7+A7GQ360Oj2V/d98z4cZnQX9WvzEmFpK3v1fMsgwCpPT
         /FzM3YV55hQgMBH23bnSu4hPobgLb8GazIcLzahb3S1b+yqvoONWn0WzFb6HCwK/8Kf2
         qBDfKy3qJ5z0IBKHDEL/uf+yblelFqdn4IGRbKYC7eFLu+SSOko83P8IevP44xyaPKuu
         bSPg==
X-Forwarded-Encrypted: i=1; AJvYcCW21c0hhNq1TjXIxq+Op0vP1Dtxwc+SEjkJPgfssFWwVC/c9dTaNddSWRtzRQj8qK6oUZY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxV2u4f/SnNBM0WvPAIzjRxP9cH4SevCVr7neNgc+tYcHu36c+y
	FIhNc6FORR1YgaWJmOuVovlFKwJjocVM63OJqvqEHJAVkRRPOkSfmr+BeR8Pq3E=
X-Gm-Gg: ASbGncupMAvCS4h90c4fXfiogPFl8cuWi4r3BcczISY4x6Cr/Zh0usQefpi3vAsWN1+
	X3C9YYQR9kZn7rEjEcV8XXLOqApbzq83GwoP8ugb1yY0JIOOC4sgTuAf5RASjgTn4xId3nKMMbU
	X1opcqBsBdl5J42k6b8ZIp0q94NXxEj/V6XYBlZXOR9jsArAtbXeN+QokCsJlCx+Rwf0xx00ePa
	NCjddlcu8nc65Bbrq4s2m+wxFTqgUqgpxzp0uwXlFXR3iyM5g1umySb2uB9brJ1JZ+YCkFn3H8B
	fTT6b23tIPt59DuOEXDQZlQDt9/6uXh5AlY55xk+UaZZ
X-Google-Smtp-Source: AGHT+IFU8hm9zhcDunTQJAahNQInd7mdsTjIr3cotSxPYman6nDyWYKdsiEJQfH03ZjnJdvFUnFK2g==
X-Received: by 2002:adf:f64f:0:b0:388:da10:ea7e with SMTP id ffacd0b85a97d-38bf5674abcmr8385804f8f.24.1737353623326;
        Sun, 19 Jan 2025 22:13:43 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438a46b0497sm58187035e9.28.2025.01.19.22.13.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Jan 2025 22:13:42 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Kyle Evans <kevans@freebsd.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Warner Losh <imp@bsdimp.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <laurent@vivier.eu>
Subject: [PATCH 6/7] cpus: Constify cpu_work_list_empty() argument
Date: Mon, 20 Jan 2025 07:13:09 +0100
Message-ID: <20250120061310.81368-7-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250120061310.81368-1-philmd@linaro.org>
References: <20250120061310.81368-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

CPUState structure is not modified, make it const.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/cpus.h | 2 +-
 system/cpus.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/system/cpus.h b/include/system/cpus.h
index 3d8fd368f32..3a364fe61b4 100644
--- a/include/system/cpus.h
+++ b/include/system/cpus.h
@@ -20,7 +20,7 @@ void dummy_start_vcpu_thread(CPUState *);
 #define VCPU_THREAD_NAME_SIZE 16
 
 void cpus_kick_thread(CPUState *cpu);
-bool cpu_work_list_empty(CPUState *cpu);
+bool cpu_work_list_empty(const CPUState *cpu);
 bool cpu_thread_is_idle(CPUState *cpu);
 bool all_cpu_threads_idle(void);
 bool cpu_can_run(CPUState *cpu);
diff --git a/system/cpus.c b/system/cpus.c
index 5ea124aed0b..68add85bdc7 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -78,7 +78,7 @@ bool cpu_is_stopped(const CPUState *cpu)
     return cpu->stopped || !runstate_is_running();
 }
 
-bool cpu_work_list_empty(CPUState *cpu)
+bool cpu_work_list_empty(const CPUState *cpu)
 {
     return QSIMPLEQ_EMPTY_ATOMIC(&cpu->work_list);
 }
-- 
2.47.1


