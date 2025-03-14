Return-Path: <kvm+bounces-41080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 789CCA6154B
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 16:51:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9F321B63AA7
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 071B0202F83;
	Fri, 14 Mar 2025 15:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uU6pVras"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E63F202992
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 15:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967480; cv=none; b=avCAHq+2rZvXfc/GWg0RUy62bt7+KzWTBCXctTDmTkSiwfe3r/LIPvMO/l9QXWS60EwjOsNonZb61lL/LK/Rjo7o5qjxFjBijtj52BrS6JSpTStQERh6owTVOoR2KNJwWMvupJcjClRo/2wJBGZ16dRHdIHeelROiZf1qpe1HXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967480; c=relaxed/simple;
	bh=DtYKD0hNvoy2Uxc1fJMAJI5G7nMcQlm4w8CtL1HgE8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thDyRUp5ppf9P45nIJYWYmRs1FKgSHRcgp/tzJuDDk7VGXKVIydEaxBVOGM240BG2IQQ3jUCdoROGeq2r1h6E4+tAVMctJXqQ0Fl6HCsKzHlZWml5F98FivFLgWT48Lg8k/4z4K9RRuUdr0pp3cyboUm/5VRN2QeEbMFM/7jg0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uU6pVras; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4394036c0efso15274745e9.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 08:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741967476; x=1742572276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+fRHRzXgCjmP/bnGMZgkYHknTcPw+tYfWwUZWqv1wRU=;
        b=uU6pVraswOltdh919VSe+pATNOle8vzYDd+17hYTmkUhVK4oOAW71wjG8kr86uWh+M
         IpaPpAiJzXziwmO3SwgzR2/PQjmiNkbZ3tdOefDo00MuS+SCNmCrfRst+NWe3VNYLUHY
         wROIoyXlS/Kjx2kPQGcciT5FDNQJJ34d5asS+nx4gN212TzamcIhrGunM97Cd88YQM9N
         w+RGhqkVurtS77ZQD+k53AwndldbeEV0yWbUiLX++2IkQfdkFkZrDJBqoCEcbi2l3ZF6
         LQNmi/ChW3/m2b2zQQUMlMkWWf//jaXoYXrgddRD8MLN2xk3+wsS+AuQrFZUnlq5zRIR
         iMxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741967476; x=1742572276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+fRHRzXgCjmP/bnGMZgkYHknTcPw+tYfWwUZWqv1wRU=;
        b=OC7hLa/EueWoXr8p5hBZz/10fWalpUpiMh8Vs3Cmhp8uVBhz9Ve05Ts+3PvtPb0Jio
         xcW/03B3dc4Qey00tzDH4VDBUwgLIbDjZM6fKNVO5MrLRLhqCub+yT+SXVIdn7AzYazw
         bnlhoFE2kH3p4sv8ToqpteDM/E1bfq9Np1HzaR6FWnN+4rNXMpiJHWjn70DbQEIG61rP
         Dp7ktvyuhDaSq/HpZnngnwdOhjUe4l+8NHQ2FkL6Ht/6kjax+paRIcrP8VCQJZNYe5rt
         hJvJ2kRmSwHxaugrU+n3kUSLI+XbwnLa4LPtma2wB/d5ZqNBgXHGClvmNyjobRIBzNbk
         ZNeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrbA7pmPhd+BBQIxhi87zLmn7X1hqeTGPVnf+wOioBG6TCUiWV6+JZK9guMRnew1CZF6g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyV0yCzwDHvhMH14AP991dkQDicTVW5pfDbNd92bWp1QWOsxwYj
	CbadqxKSSQIhCn/s4YnxeZTCjqRwn5HaO5W7u5j8zafq+17a6p2ApJM/6FWaG9I=
X-Gm-Gg: ASbGncuJRnLCoV+gEGF/QxKFA1OPlm6TlqoRAVM1VpWBUIlu95qEiXzW0yl0itDacQ4
	TaMFV1d4ubI1W0r6C8jQgpR18+UGsXaPZWPGks24+SIdy7PlxKnekDisXslIUzAL5R6uGgLFe7H
	dxfGD5tNfgVHDIgcJXbfXwFadHNOoUsS+jvAbpPUcadK9fvyhXbCY5EeAepuey07xyCLqImztwO
	hpdRg5kmM8C0AnQ6t9VXlqdEIhbm8RVU1knKgFEQEN/v/E7Fz5Nweck3UAPDl5QYzMzirASTVoj
	1UI0eNYC+UBHFSk6tX5HOHxiMQq4bI6uJjzD/FUHS/Hbg0NiC7zXYRDp16FTrzg=
X-Google-Smtp-Source: AGHT+IF0xfqiSOAD/aXN3C4RaUAgjkDnEUSmI0lHDHuOw3S7x9Ps8i6yZGeRqXqx/ijFDdbau6zaiw==
X-Received: by 2002:a05:600c:350a:b0:43c:f70a:2af0 with SMTP id 5b1f17b1804b1-43d1ec8643amr43633015e9.16.1741967476398;
        Fri, 14 Mar 2025 08:51:16 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d21d67819sm15249945e9.21.2025.03.14.08.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 08:51:16 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com
Subject: [kvm-unit-tests PATCH v2 3/5] arm64: Implement the ./configure --processor option
Date: Fri, 14 Mar 2025 15:49:03 +0000
Message-ID: <20250314154904.3946484-5-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250314154904.3946484-2-jean-philippe@linaro.org>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
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
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
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
2.48.1


