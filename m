Return-Path: <kvm+bounces-42939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AECAA80C37
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 15:28:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 058B58C718B
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 13:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B05122A1A4;
	Tue,  8 Apr 2025 13:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zKmOm9op"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66902B2DA
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 13:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744118467; cv=none; b=gnHtfbsZMWR4XlC2ixDcLc+ZU1LGxgGzstrEEOpT+R14mtb2Cd9JQYTHIxzj53vAharW9Qry6614l3/ITfpLCN62OlpA47UOScRt1U2fcYpXOlo0+C5SUSWHnOdGHVC1L/pWoF0vMdkLE1SYdEGA7azfNf2qUR2FdsXP/amqkhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744118467; c=relaxed/simple;
	bh=DjE5lydHNpWSKlp2OS+ArgpAXc20b7JX+EYn2yeg0Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHk0mrPRJVCQz4M76f33O3RbqhL0HT/RlWMwKuzh5SFuiChYal375om8rkOlfLaah/YZgn7Q9UT+0scWh0Z2GQshTGzSCK6Q+QGDqnNR2/2QIqbFDsZYhMcbETYqsRpBM1jXyfunoI1QyoWIinGsk8/QSrVlVZRJiCddl9x/9Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zKmOm9op; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-39c1efbefc6so3254031f8f.1
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 06:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744118464; x=1744723264; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vR6Kj/v7QUx4Q9A4sOPDY+B+4TbUf4f4gjMITODv1GI=;
        b=zKmOm9opA87EGa4K08p7RLkmBhNI081/LGR/h7XyRtKp6ktyJRwJ2aS8WdkE0O9Ria
         vpoeQUS2ysE2t5NNUxrfTafwlil0IugPQcGJkqgp8kuyj3y/67s4l6hKZ0eWLIfgQ9lp
         NANSZEfjNj5ByLYuWkRsfzm/UMFhwyQtgSPYNfSZDsCClVn3lMkTydaLMLObY4VgjeaV
         ldh5BJuYMDd1eaFGHEAYY10KTEdVIlIXRMt4hIwTi4LpL5tOmLZrJ4DeOZB+ADBMvVg/
         gOKJr3eb1Ag9V6+z0Jl4Q0EXrtsqG45ao07jtDsqrN4VUGWO53hZ/ECBeJ2KWngamnEQ
         PokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744118464; x=1744723264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vR6Kj/v7QUx4Q9A4sOPDY+B+4TbUf4f4gjMITODv1GI=;
        b=DewEx2ADUkewSnnpceTMpERG6FIJvnyPuMemPkI3TZ5fK4N2tIiyiuWbqbWU2581Yb
         OiHrbMMF6mDl3v6/LMAVrjwxMuCftpPGWUNNv/fr2d7O87C+DzWtXlOoU49taXVgZoxB
         i1A8esngGTdDIgmjXIUK1QS8HhzqdhQ3MKHjH/guafqimFmnwDqYeBZfVb7J1gUDY1CT
         mC3/gLzJwyZX7FJw5wCgO6WBjwJZunVAIsIjkcBoRWhPGZzvEzUpPBtFiIW3quKYtlIp
         N9ZkBYnsEKjxvZMz1LptkFPdbJcBg8dM3ePlVjYDThXal//YUALscOvleXp693pb8fAd
         LvBw==
X-Forwarded-Encrypted: i=1; AJvYcCVQRb6zZD3ABUas7JPLVgyq5HgjZY1roGgXVCB3taikXmcKbIn24ypjKh9T2MT71UiFnPk=@vger.kernel.org
X-Gm-Message-State: AOJu0YymvJMI67AHo+A8ooN69Vqr6qb14tDeS1edAFtnQu0zL5KZxFIa
	TadxB9KfZcFYB7Iw1HTKfLjlEHDuMyrDG6Kg19HkKKDcVcxtGy8HCvjhcihO4Yk=
X-Gm-Gg: ASbGncscjoLBM25BaIx1leH+wpLNnLBw1qUA2B+5q3YE9q4r3wIzH+TRAPOOYNdjLGp
	s822CPbKiS2S0rFWy694k+w3H4aQG/fEcwXKYX+0+7of5Tvbsv+Gpumnr71kjGfSWje+wMHE5L2
	8JYxyWG0JAkWkKr3LquJLMMF3vROqy7o62NJaME4qm41+YEdY7NgudQejaXVINntCGGcGJSrT2Q
	xxN6++R2p/df8ACgGBUWXH2WCu3KlTv2T5KHQtDO3Y327wXcSZsXz1SmN4NBKnS5d85vA7g30CJ
	80u/GN9WtEkpiRqbg0rVzL/FOYvKKybuAMl851CsLhrYuF114zKcp+7LerxVNBw=
X-Google-Smtp-Source: AGHT+IGEYZcVHqPxh9b9iWTJrtArQr/utyYTQwlK58Bu3joqs748+JSADbxOpv7hF62mBqzNbjJDBA==
X-Received: by 2002:a05:6000:4212:b0:39a:c9d9:84d2 with SMTP id ffacd0b85a97d-39d6fce0eddmr10745293f8f.46.1744118464024;
        Tue, 08 Apr 2025 06:21:04 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec36699e0sm162159705e9.35.2025.04.08.06.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 06:21:03 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v4 3/5] arm64: Implement the ./configure --processor option
Date: Tue,  8 Apr 2025 14:20:52 +0100
Message-ID: <20250408132053.2397018-5-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408132053.2397018-2-jean-philippe@linaro.org>
References: <20250408132053.2397018-2-jean-philippe@linaro.org>
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


