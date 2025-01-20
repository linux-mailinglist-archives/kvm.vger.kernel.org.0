Return-Path: <kvm+bounces-35943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C195A16693
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 07:13:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 147F67A41E7
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 06:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 729EA186615;
	Mon, 20 Jan 2025 06:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d4Hrz7NA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E69183CD1
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 06:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737353611; cv=none; b=iITkHTE+qjyKogoTYeKbzAhDQA2WjXS/+I4Rb59zlia/44CE18/kK/qbREojb9AoQlpv4tTQ8EHwT2mMdNFcdRT+aaW418vJ3zICs31WKaBOFyJSJrXdrQZOtKnh2IGaOA4FndqceNQJPXPLOQmmsJx1bu9vmtITF78OevjnCx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737353611; c=relaxed/simple;
	bh=K1Wcn8Ucet0XH8q61Ezq7T9/YZboaMm8yYJX3EBE8kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pyUmUIloISfhPpoiFjSi7yo6lKrU3n4jxyss/pc/eUrlAECSV8wncZBRsgZOAFu6RhvrVVxREDiPW0whUSB78u8hkBEEfiI75H+d/v66sAp/RwByh5N2bIO+HdEwyZHCchttiQ4dGq6IR0b3KFjAhKN1gIx+uDpJ4xDSgpRp0Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d4Hrz7NA; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4362f61757fso41739315e9.2
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2025 22:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737353608; x=1737958408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/LgmFzZPaYXd/oFrcsNkEtO3/uWCAUa12Q0VDnBXMJM=;
        b=d4Hrz7NANHWsPgWk0+4jCNWG2/t8QLP1rlXdFPf9MwuU3ux6AkVIfHCek4Mnz5xj0P
         QOr+knsDR4NjyZF23REkE7uyqo1LcLaS0a9L/KHc/8EWUjMbfh7Wrzp14B3XxBTtAgFx
         sRPhy8+VyoUfioFxn3OdfFGWiBXeR+splMiGEX0h4//woPgTy4g7ZEFq7sOdGn0bnBC9
         Kuyt41RFl8E+ULYy6y5XAdCyA+kpURQso1kLhw3+Zf6zcTzuWPOJ3a7HLhJXKq9Kx+pX
         YWo9lUd8awrL8kQYDbl2sAHXrKkH7fEXCzevFp6I3sa4pblK41AAPO+Q3NVMGiZu+NIn
         1vhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737353608; x=1737958408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/LgmFzZPaYXd/oFrcsNkEtO3/uWCAUa12Q0VDnBXMJM=;
        b=nfFZj88cVF5Umyo77l8KSf+Gp7UdNX0lSXVyZWs5nfwe3ImqfbftFwig//lPJL3D97
         puZ2/vV3Vfe9jNaHN+JGr0/vcRlQxklCvAdlSWEdwEhguLzLg2RsSGzQH5DUUiPKQzBx
         rWBPFO52cq9F133vhD2M69XaxT9l9u5KIV2Y6LjBg8lH+mlZLyWgc6VaAWey8+C7A5id
         UqaINZ6qv+CAEztGGhGSovo8MHYi+CnufOOavTnQ8QGLA/yF2Sv+ljmYFJRl267v8eGI
         YZ6pQL4obtmE/ABRapRqVxyUzyJfW6VOJ7R9oqjQ2+mMt77uge0JI65d2dKwgBDtpFf8
         wByA==
X-Forwarded-Encrypted: i=1; AJvYcCVdWGdYzs7eFJx0I/7RZ1JpwFiswe9uHXu4HV/biiT7Rjf2Mn0DuT9d0WfNrnALaHmNlK0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGdhV1C3LgdEqNTw1Q99qfUaDkkq+N2hq7kpypxmvldHCaQvF/
	K++omGcDbRG9lGJiuaL1Mx9dV8vANWweMLlH3zTG9HE3do3ldNm5HlIJonDVKYc=
X-Gm-Gg: ASbGncuh+KO43GKM8CnASoVMfqdqQrkrP+Tu/CqkochB41sQ2QwxZB2/jMYEVmymdL8
	bi3gKHGFJ5ILkI4wElgJ5pov6gIvgLv+hKiTUE870lablc8uUmoODOzC2lmvSIF1TP9bMAaXpaq
	jSReR95WKWBeUXMOec7bZ4VnzxTh2kh0k1g6PDO9DcUgZpzctPWgjZB4isxYqLz1a9y5CTjrVHZ
	dVB37NBtvA9crFUwScCyoNjLYctacQglJJHNxHuGs6bInE/j5tCxSeX/92d+jlePj4fNXetQl0t
	ZgyFTlM+Zbv2d2N9ihJfnX/zvz62yD4trtr4UJYxEBQW
X-Google-Smtp-Source: AGHT+IFQxWOYTXhmRmfNHYvquVRicISruZz1w3PMDmGF59CMccSZ+zar5LZzshebqb/yaVzBLo/diw==
X-Received: by 2002:a05:600c:19cc:b0:436:fb9e:26c with SMTP id 5b1f17b1804b1-438913de937mr105007685e9.17.1737353608127;
        Sun, 19 Jan 2025 22:13:28 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438904087cbsm127685485e9.3.2025.01.19.22.13.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Jan 2025 22:13:27 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Kyle Evans <kevans@freebsd.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Warner Losh <imp@bsdimp.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <laurent@vivier.eu>
Subject: [PATCH 3/7] cpus: Constify qemu_cpu_is_self() argument
Date: Mon, 20 Jan 2025 07:13:06 +0100
Message-ID: <20250120061310.81368-4-philmd@linaro.org>
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
 include/hw/core/cpu.h | 2 +-
 bsd-user/main.c       | 2 +-
 linux-user/main.c     | 2 +-
 system/cpus.c         | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index fb397cdfc53..782c43ac8b3 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -838,7 +838,7 @@ static inline bool cpu_has_work(CPUState *cpu)
  *
  * Returns: %true if called from @cpu's thread, %false otherwise.
  */
-bool qemu_cpu_is_self(CPUState *cpu);
+bool qemu_cpu_is_self(const CPUState *cpu);
 
 /**
  * qemu_cpu_kick:
diff --git a/bsd-user/main.c b/bsd-user/main.c
index b2f6a9be2f2..6dc4512cebf 100644
--- a/bsd-user/main.c
+++ b/bsd-user/main.c
@@ -205,7 +205,7 @@ void stop_all_tasks(void)
     start_exclusive();
 }
 
-bool qemu_cpu_is_self(CPUState *cpu)
+bool qemu_cpu_is_self(const CPUState *cpu)
 {
     return thread_cpu == cpu;
 }
diff --git a/linux-user/main.c b/linux-user/main.c
index 7198fa0986b..104704ace96 100644
--- a/linux-user/main.c
+++ b/linux-user/main.c
@@ -181,7 +181,7 @@ void fork_end(pid_t pid)
 
 __thread CPUState *thread_cpu;
 
-bool qemu_cpu_is_self(CPUState *cpu)
+bool qemu_cpu_is_self(const CPUState *cpu)
 {
     return thread_cpu == cpu;
 }
diff --git a/system/cpus.c b/system/cpus.c
index 37e5892c240..e4910d670cf 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -502,7 +502,7 @@ void qemu_cpu_kick_self(void)
     cpus_kick_thread(current_cpu);
 }
 
-bool qemu_cpu_is_self(CPUState *cpu)
+bool qemu_cpu_is_self(const CPUState *cpu)
 {
     return qemu_thread_is_self(cpu->thread);
 }
-- 
2.47.1


