Return-Path: <kvm+bounces-41979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BE99A7060A
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 17:08:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05CF8168830
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 16:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3C7219D891;
	Tue, 25 Mar 2025 16:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DE66MLtp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B213215060
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 16:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918875; cv=none; b=lQH6J+bohdHrKRPu3WG8KnUGqVIynyacUjoy64OGQdNeKgLD+hTRRSw5X/pS3qYPfRHE4mgl0uY0XCoaVVleZVIsca81nYDSThB8N7qWha+EM1yHILFrNBJOe6pr/PYWlEQ81M0ent9Ddx/48OFZexeypeWF9oqyvOxIM7IrCWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918875; c=relaxed/simple;
	bh=DjE5lydHNpWSKlp2OS+ArgpAXc20b7JX+EYn2yeg0Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dugAEbspg1XpXYCreZ+eXaOZkKn9cWcTd+SGJ35WWiXHap8/PgHHAqTINolXEtIV5PeQ2TthfparrMsKU+7moWaF9C5fjdcknGIwPXh2ayJC9JVuE8dH18BPqT9HUddurPlh2C+I2ZR/NpXluv3OkMq41JcvAnvvRS3/81TA2Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DE66MLtp; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43d04ea9d9aso26859205e9.3
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 09:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742918871; x=1743523671; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vR6Kj/v7QUx4Q9A4sOPDY+B+4TbUf4f4gjMITODv1GI=;
        b=DE66MLtpxPZhe4qMmHQueCECTK/f9w9I7Y2TvRYif2qiqH74kkp2y4F6RDRFke55xy
         pwmSA/rQxUjbfSfBBDQM4l3ULWnPSnIMa9Ppqr6oxWSc2PC5cj4ztAR165Id4bZRwz5h
         e4bFi3SkCHO2OEdQRbccrY8TBjfN5WF3DHfkrymwypyFtvhggtWACcazRRJ6qRMuo4dS
         PA0TUETJRqc6UMvS9BblmAy0ZK9RZxkqzxFqTsCqqI3/1GeT8AoAaQSqERaLd4sCBEQi
         cePUwlMswtcZEVsThgZyvr3YBD7ef9Nm2jcjpdMwlt6/7jF5eoNQv5UfFiRZkZcEHCmG
         7cKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742918871; x=1743523671;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vR6Kj/v7QUx4Q9A4sOPDY+B+4TbUf4f4gjMITODv1GI=;
        b=Issag06t/Zm/RDukuzBbU08wDz57EMZN4Ky1qb/0u5Jhuki7xyv5FbyKrsN/25wnVF
         dg0q+70f3SZnRiOo5IMAhW4g5vMfzsm2nZpqBBb2uaecDrTXzovxBXHLC9z1sh1uW8yw
         vuMpIw3E/VQIftXkQrWxhPHrjSPa+1D6dq0l4RrXLptGuyYd9MTciW4PsdRWhQbohgsO
         FZseXeQ22yZkyQrH3irDuoCTiJ/XdYlfFlVYSbLaUa6x9M1UOLNyFdw1CvZNxOzW5dxN
         HEuz5ZsoT6XpH1mEnpIv8mugwNoh7tMcZBxMP0Gs0ONDWssK87Y7gJHa0s7edUCgKAA1
         7C+A==
X-Forwarded-Encrypted: i=1; AJvYcCXlZo3sJctp+5ljgYylCbNWGN3lIDCytV+MZHXxHpLQT/mz+W9qQjnwgEo4GtfmuYTnSzA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu6iLiG5DYkvSfvh7EAMjGhZeKohg1mnbkSBOkiTEuIStD6G7Q
	yxSKK6+ZrlDCDSPGjuB4yBsZNwP93kLHdWh7zU46j4ll8nwhedBjx/b9bHvp+m0=
X-Gm-Gg: ASbGncvEpjjri/4Ch9cfj81IWyp/jffvQzLcKicZUsIQQx2+XVDcVCLiorQcGV40lsk
	rricBDpy30j7drl3dAUqGCbT8a92kug8U6AwZObkax8fU2jvPHRa8+5IRlQsY42CuXARbERy/pa
	696o27H8HGwjfG7c1Fhh+2yr+jAqH+6AiDKP9pKMQepknFa22lu11tlEScUuUQtyyuNY60gg/I8
	+RWERn030Quo5pYw2Kqe6l0BncY55jCRRTJDbDUVbtc6q9BixG1jMPK3qntZRyQ4CWaMmZ5EopH
	+wo2rGYIJivB0t3IwBbMHQtE2iZMD9w+eFozELQyYnCo/ArTO4YxfGJLA7fLTSQ=
X-Google-Smtp-Source: AGHT+IFcVqxqtEj63q0t7fchOfzrlKAVFuDwmZJ4n8qfIqVbAeEYL3vXur/5eNhzGwJap/Peq1YHNA==
X-Received: by 2002:a05:600c:1e07:b0:43c:f61e:6ea8 with SMTP id 5b1f17b1804b1-43d509e3b14mr173288785e9.2.1742918871445;
        Tue, 25 Mar 2025 09:07:51 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43f43cbasm203972195e9.9.2025.03.25.09.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 09:07:51 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v3 3/5] arm64: Implement the ./configure --processor option
Date: Tue, 25 Mar 2025 16:00:31 +0000
Message-ID: <20250325160031.2390504-6-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325160031.2390504-3-jean-philippe@linaro.org>
References: <20250325160031.2390504-3-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandru Elisei <alexandru.elisei@arm.com>

The help text for the ./configure --processor option says:

    --processor=PROCESSOR  processor to compile for (cortex-a57)

but, unlike arm, the build system does not pass a -mcpu argument to the
compiler. Fix it, and bring arm64 at parity with arm.

Note that this introduces a regression, which is also present on arm: if
the --processor argument is something that the compiler doesn't understand,
but qemu does (like 'max'), then compilation fails. This will be fixed in a
following patch; another fix is to specify a CPU model that gcc implements
by using --cflags=-mcpu=<cpu>.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arm/Makefile.arm    | 1 -
 arm/Makefile.common | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index 7fd39f3a..d6250b7f 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -12,7 +12,6 @@ $(error Cannot build arm32 tests as EFI apps)
 endif
 
 CFLAGS += $(machine)
-CFLAGS += -mcpu=$(PROCESSOR)
 CFLAGS += -mno-unaligned-access
 
 ifeq ($(TARGET),qemu)
diff --git a/arm/Makefile.common b/arm/Makefile.common
index f828dbe0..a5d97bcf 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -25,6 +25,7 @@ AUXFLAGS ?= 0x0
 # stack.o relies on frame pointers.
 KEEP_FRAME_POINTER := y
 
+CFLAGS += -mcpu=$(PROCESSOR)
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
 CFLAGS += -O2
-- 
2.49.0


