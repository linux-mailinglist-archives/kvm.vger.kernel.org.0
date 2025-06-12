Return-Path: <kvm+bounces-49308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09DC1AD7BF5
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 22:10:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A8DA3B1072
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 20:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE1A02D8DDA;
	Thu, 12 Jun 2025 20:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="qEGx63M6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51D82D879B
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 20:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749758871; cv=none; b=AbfGVJKA/DEyTxgYuar+BdMRkLrxI3QIs1ATsTzHKM1ZGQXHiitshYgXYr6tDQsQh2xxfhljOXZDTBpS2ZLrjHyS2yjkpYqwhWthtxTJmLRZBssk+1mJ+xRKOKUfvwVIx3Yi8odGQDHTUo3wTT0UfjakHsYFf1eMdgkxA4+eMQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749758871; c=relaxed/simple;
	bh=iPEc9DkrZZuh714L6ptuO/yh0w91HvXRRS3jkxQRWVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C0AqjRvwqV9F07VZ7pXlI/RPVyEfoOr0r4X1JBz53VgdXYDQ34dv7JVcfP1tyXxWc8U1774zXw9Cd8qDaPqwJQKYD9dI336b+kMdZZBd3Kj9SlBwkkqLKMRfQSUFdRBtZV+hHUZFdmbnDCNo3mmGw/zZjk6pm8u5Ela7st8AkDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=qEGx63M6; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6fafaa60889so9771116d6.3
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 13:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1749758869; x=1750363669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IoCF2baTBMbN485tov+kTyy1ox66YTUHGdu6p7Q2Pjs=;
        b=qEGx63M6eKVYD7vdnPmhIM0dyB8Nqn0lOVJUbqvqkXNW1O7/Ionzv/XYElOTNqaxT/
         ++imTjmxiIm5lCiGGLjlkH+qg3PoXf8rwe4EJlAg5fOCdEWHxkXMRd9ynZpOfQqA0n9x
         bFjCF5NMWF6IbXHzef3v11MB+fQlzii2v4ZsTRBV8XYx9GIxC0AKmgPK+A+a6NdbuPcv
         WvFCZhpn7cMwTjoeXxdGr6KJubaZLWk4JlDs3x1nQjnErxgRTiPCcuH4aOHjPraUua7t
         OOC2eQq5MnYLQ0pbnULMnWEMnLDm8J/F2vB373m88EPkitvbl/q3mqe5oZPzY9DnmlOs
         vnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749758869; x=1750363669;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IoCF2baTBMbN485tov+kTyy1ox66YTUHGdu6p7Q2Pjs=;
        b=mfJb17sy41vPWyConquYx/QnxkCGvLZieteREQc5Sl7rrxCglMDs2GEGpLal0M7f/I
         XztGL5t8olsWA7ZyZRixmqRr96+mLmnqatz7Cq8h8mlg4kSooqA3Wc7YoZuqZi4YoQgV
         Meg9lfr50ttbREWMBAok7nSrIF3bdBGK+GlcvaPfJGOxG3KZZs74taUMp8UiUZJ7XG2d
         qyosqpGSItQ7We0NNkB+cARxmhG2ABYhMvFH7GYZR0rPhXSt0+1oVmYwCnJAgz6DEu4C
         GLsleJnwsSQyU4qJglnDywKx7seFWn1hoAC+d7xykO5d+exqK7iekPY5zM9fzCekDDCu
         ejtQ==
X-Gm-Message-State: AOJu0YxN5vAhCqSL0m7SZwoK8x9MGstRo0ySaISba/iPUHeaiaeBiJx7
	tBYCBMdDy5fXInKFkuR76WGN4CpNEvzIymke/l0GehQJI3vIgMZxEeDvkluEMgDr0UFOPyb8ba+
	bGoi6
X-Gm-Gg: ASbGncsmx1oAVUF4qFBwgp86tZi4m0j7BuxvUxAxVBMVg+qvjlCrqWW1kAlKCTa8Gsp
	yr97gxGdE2giKHePviARZ/CrhyJqfdgh2P1IG4Hi0nlE9aEMZb9Gt9nkCdOIBX1+LScnRx4vk1x
	k1voH6s4nKEfi+k79e3uOvpraogWxpZywRXUUJHwjDROl71SpMnA7OibVyVylzUoVzktRRmG7gs
	fR6EpvI4X7fFAzTjsor6fQVw/Ca/h3ViBziWEfJL5yRYCk8wkvnAsqGReELrUQA1RySwlOhhEhB
	bz0x9tOt9R3CxMgYhlU/ae49SMBgrPuguhiGvVRg6ykCFWQWsB7U/wsNgaND4cnyAhKxGC1x1l0
	ab7iZF0KueZljNXd9L/i9f+hkqcsWpWHARK1z9XmFfyE=
X-Google-Smtp-Source: AGHT+IF7ZOtN55FB9YsoHYExZAH41WMoG3UxkGYtgNp99PihSoVpgb/lhT7vGhmzKBFUsNoGNC5TcQ==
X-Received: by 2002:a05:6214:2a48:b0:6fa:ce87:230c with SMTP id 6a1803df08f44-6fb3e67aeffmr2776616d6.25.1749758868792;
        Thu, 12 Jun 2025 13:07:48 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-224-24.bstnma.fios.verizon.net. [108.26.224.24])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fb35c895f2sm13496096d6.116.2025.06.12.13.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 13:07:48 -0700 (PDT)
From: Jesse Taube <jesse@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: Atish Patra <atish.patra@linux.dev>,
	Anup Patel <anup@brainfault.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Himanshu Chauhan <hchauhan@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Jesse Taube <jesse@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH 1/2] riscv: Allow SBI_CONSOLE with no uart in device tree
Date: Thu, 12 Jun 2025 13:07:47 -0700
Message-ID: <20250612200747.683635-1-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When CONFIG_SBI_CONSOLE is enabled and there is no uart defined in the
device tree kvm-unit-tests fails to start.

Only check if uart exists in device tree if SBI_CONSOLE is false.

Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
 lib/riscv/io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/riscv/io.c b/lib/riscv/io.c
index fb40adb7..96a3c048 100644
--- a/lib/riscv/io.c
+++ b/lib/riscv/io.c
@@ -104,6 +104,7 @@ static void uart0_init_acpi(void)
 
 void io_init(void)
 {
+#ifndef CONFIG_SBI_CONSOLE
 	if (dt_available())
 		uart0_init_fdt();
 	else
@@ -114,6 +115,7 @@ void io_init(void)
 		       "Found uart at %p, but early base is %p.\n",
 		       uart0_base, UART_EARLY_BASE);
 	}
+#endif
 }
 
 #ifdef CONFIG_SBI_CONSOLE
-- 
2.43.0


