Return-Path: <kvm+bounces-40665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E6F0A59968
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:14:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B19717A723E
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:13:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14C8F22F166;
	Mon, 10 Mar 2025 15:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="MSKud9qr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A7122F15F
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741619611; cv=none; b=seet0EsfsD3TyNZriBqVVyjiCGzTkya88LfeCQo2mHfp9a92K567kcGioXiEUDefHshjhSrGzs0S/N/g63Fwsu6KgYGQ3bFLfOIRabFhT0pq3gUGLTXUxHkA5kqEIJGH6bKYU9v2gpzSK0TYxyEcoyUTgl8amoxG8PVbOR6R6mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741619611; c=relaxed/simple;
	bh=hbQs6lvF8Q1JXm18X4XFdDLyvh0l97O6MMVXH1OHxSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SgF/APhr8YZsX9LgDgPsE2eEIFM1IMFDFRlki95MuFiBLM52bskNvWFXMySKRphnvNd+b3/rlZ178j1JqgbdOq49Jk0tQwZaaueUxiZXHu5gqXWBYuQcKMIY2hJq043TzKK2HNvg1sWSBffBNswwUz9jsyy8cfIT5ovBAa9W6gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=MSKud9qr; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2235189adaeso72912155ad.0
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741619609; x=1742224409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CP/QN2TKpQVKty1QPq9K94rdshw9XjhsCR/clUjZxuE=;
        b=MSKud9qr4rghMTkl7ONFOuPmZVSGFcwmpBqbG6/AO8W+r16T+gxgOr4/6U+7n8S061
         LzHrGVLgPbR6lFHntYfZQO8Oknt/KBTyV+ggmhLrjAQMUanCNdn+BBTScuP/DrjSqxr3
         ZH5MbVSKxFBNYc5Fu7+L8we2wehzRvgUMQD8geQJa6CeUmnUBxtCarPFdc5U1J+ZPxYq
         1A00PflLzuqrwxpiDhDxHb5pkv2Qf0v9aXNRNJ194PqYmWPRNqzGxT2+0rQW6iOD8BrQ
         WUiUuwXMw8KCI88ARhXH9hBc0YvKQw+Zv2wvBcBm/Gxc0Wke37KEVmGzyRHIScItE41y
         fpxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741619609; x=1742224409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CP/QN2TKpQVKty1QPq9K94rdshw9XjhsCR/clUjZxuE=;
        b=aZJoSOnQvTPP2t0BzpBYl9jOW5IQz2C9jGZI7gzCi3FlT9s7AeBecYoUMBCMww038P
         QrNF3IhJulmE2fOmQHbYUG5l1dJRYz6mC2n4ISe1trxfJ4blNTHv2HpzzaDuOQ1QKanx
         wxfuXMAP9vUiBmsaP7Njg2r8A6IQWoI9FkrY44wcisZYibwGsceb2KAsYMwi9+Uri7vC
         lEUUthLF8uVCaTX+vun/GXeVgwiKKfvOf40vVBDW5X3Ypt665Hqog7jTd2QoVtlPw9Wd
         Bi0WqGd7wJWwiGJEvvhLsy4/b6dp5TvsQ7xhRi7hqqDNTAPlTPNVT2SgkN7wpiXsRiPc
         n8QQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsWCc1ZvlXYHpHknIeK/S/FK7vPc3wkzbZzVYfNJIYBzV8x2Dtez0yyO8nvdBA+yCp310=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3j+IV1Ko6cfrN7zWfrnGIjbKGPmeSDm+clVbRJlHW8MKTGlmg
	++xYNvw3ptjsj3INN6K/tz2CG7hRdIHlDCttX/zX+RIuA0Bufv+wf6/q3jnQQbM=
X-Gm-Gg: ASbGncsNr/UhcnQwoIK3s6juC/ZdiK4K20agVgnrHV6RiGXFtIi2rTgihE5HLGR6in7
	8JwJY3ADdf3LC4Saf34X4m8ZFq3fyFFcrs78cZULSS+WcCtb4f8Axc9po8Rh3UgQYAE45MbSqec
	JotlbLFTicFVAwotHxfkk3Bri8cjRnrx4/PIUIOh6qRu5p5vq2C06eBtYSui8ku1nosV+CGkhCj
	2KBtuqRVMxGi+vrrZBGT0+jv+ZuteyJL74LpkkHn+8T/ekasoXxEyLkRv5/0+FqlqUu71TH2FXO
	ZXPXKWZ1wqdkmohusQJ1SvmBfxULbpujevEg54rlff6p3l7ec38NpYPF
X-Google-Smtp-Source: AGHT+IE/CwbxNhDp7rRzvfmLqzJMclwTPVUcQ5dvDrzAMSsXdg6waC3I4WKcj3iwXpglVe985eMicg==
X-Received: by 2002:a17:902:e84c:b0:21f:40de:ae4e with SMTP id d9443c01a7336-2245360f020mr151160385ad.9.1741619608740;
        Mon, 10 Mar 2025 08:13:28 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e99dfsm79230515ad.91.2025.03.10.08.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 08:13:28 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 05/17] riscv: misaligned: use on_each_cpu() for scalar misaligned access probing
Date: Mon, 10 Mar 2025 16:12:12 +0100
Message-ID: <20250310151229.2365992-6-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250310151229.2365992-1-cleger@rivosinc.com>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

schedule_on_each_cpu() was used without any good reason while documented
as very slow. This call was in the boot path, so better use
on_each_cpu() for scalar misaligned checking. Vector misaligned check
still needs to use schedule_on_each_cpu() since it requires irqs to be
enabled but that's less of a problem since this code is ran in a kthread.
Add a comment to explicit that.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/kernel/traps_misaligned.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 90ac74191357..ffac424faa88 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -616,6 +616,11 @@ bool check_vector_unaligned_access_emulated_all_cpus(void)
 		return false;
 	}
 
+	/*
+	 * While being documented as very slow, schedule_on_each_cpu() is used
+	 * since kernel_vector_begin() that is called inside the vector code
+	 * expects irqs to be enabled or it will panic().
+	 */
 	schedule_on_each_cpu(check_vector_unaligned_access_emulated);
 
 	for_each_online_cpu(cpu)
@@ -636,7 +641,7 @@ bool check_vector_unaligned_access_emulated_all_cpus(void)
 
 static bool unaligned_ctl __read_mostly;
 
-static void check_unaligned_access_emulated(struct work_struct *work __always_unused)
+static void check_unaligned_access_emulated(void *arg __always_unused)
 {
 	int cpu = smp_processor_id();
 	long *mas_ptr = per_cpu_ptr(&misaligned_access_speed, cpu);
@@ -677,7 +682,7 @@ bool check_unaligned_access_emulated_all_cpus(void)
 	 * accesses emulated since tasks requesting such control can run on any
 	 * CPU.
 	 */
-	schedule_on_each_cpu(check_unaligned_access_emulated);
+	on_each_cpu(check_unaligned_access_emulated, NULL, 1);
 
 	for_each_online_cpu(cpu)
 		if (per_cpu(misaligned_access_speed, cpu)
-- 
2.47.2


