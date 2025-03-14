Return-Path: <kvm+bounces-41077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF23FA61548
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 16:51:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41E353BBBCB
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7495B202C3D;
	Fri, 14 Mar 2025 15:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tQbD0SEH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CC71FDE2B
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 15:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967478; cv=none; b=kQZ/EF9zJjCvZjYtzDx7diYgz2payFFnxBLAN3fLMoist1wMDIHBDRskH9X+6t4wXlddga/TmItAOLzvmq1/PBeExgjgHKh9TiZSHgrjImLJqWdV6QqHocw8PFsmERN4jWg3pjH7kMob5UpWEUrqv1ZvwL3MvYFlVj1imx9cYTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967478; c=relaxed/simple;
	bh=WTX54HjQel6kBn7szTO3R4mdhkKKzPvKjY+5SxMqCKw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lhyNNVrwVmY/Q483eb3OfygVyl7/j3k4KutNpr5fpFGZ+8D4bS62O4bs6aUHvMBswXjU194FQ8Qz57qwZAP7i9UqIsXpdtYecJxChWDVfh2/Ra/P/jzfeGpFr+y0I/aO3hxjmXY3BbnV94C0cFuJ734Q80ICCNKkHjdLzngL6o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tQbD0SEH; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43cfdc2c8c9so15423455e9.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 08:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741967474; x=1742572274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BxWbhv91Bg9/1FyB7uOy2VxTZzLp0dnb4oXLuUhTuuc=;
        b=tQbD0SEHRbXYO4vaxdCvXsYd5ZH5Grx1PDv6iHYfOVm/EIY8kOhQwvdRadJaGrnwV4
         EjlRx0nJAoliv+FqyV/LPj4oZzEE7LZiQMlju8YihHvIObpylv1XZnRgbLlJGRIlfqze
         aVr+evqv2RNzHUXwMK6ECajPVAtneQSoJETuOUPiFKSmrQEnm/GZa1lttznCZSNRdwCg
         FTINYtCNchoAhb7e8A+bcSSeu4HcGI9Zkhr6mR2tjClzrPfZB9e4l/0r+UqRVukVSWt6
         R6AutFEIrOk/mKDgxO4dZa/+bKVIxyYVl+3xaTcRqFxI3/cb1nafm4KfG7h8Z7bD7gKx
         e/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741967474; x=1742572274;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BxWbhv91Bg9/1FyB7uOy2VxTZzLp0dnb4oXLuUhTuuc=;
        b=LARNS0IawDazhU9bQp6383sIdyTox5wzEfzGJW4MIVRv9JDOLoYLZt0ypST2NFPdDC
         dVFdw9mGl6sjkAEK7QY3pRD/luHsidsficpbWhd+6nWzM717p33kgHu89649XllAypPn
         IJhpTaWV4agQrTuzohFKEAz+mBBTSKmqlUOgGgVORHwb7uVWYlSa7CHZMYyRJ+BAQwS1
         zml+dBNQJ/2sGCS6R94w+VZMuyfehJhYY/lGAN2Y0DRe3jqLQ+/SbcERs4Y4fQIa2g6B
         f100PP+D+WoDLQ4jEyzxrqcTfEWkB7LUbqQKqQjN3wGu9ly/Xqpq65E4Xl9zQwQOv4kv
         M/fQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFmHG+DIjg8iBFVzQyz5KqWQqd4XuetwM8O+MHZfxy4e1I8pdh5dFu8wV87D7DG/18Ak0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzS6Sm553sCbFRgo2a/X+bmiedryVK4JvoCedMyjz6YLn91GmJ
	Sm3P4oL/hpCKWDa6PSZlxhL46ZnD3pNuhQxH7wyxX+nN6P5auaC64fWmAKskss0=
X-Gm-Gg: ASbGncuVEdWW1/RaSJVtr9ypi81yD4WgQvUAfNI1sDtVqWS941zd1OVFSrCQAiuhmSE
	YGzyYW1XJTtRyh5Q5Swvqa3w30a5a8DjVcj5uJKU1ewjkn8M72ywg9IshJaN/aAVisDLpl+8rLF
	CmPVFL3sXdFNY+rVEMuyU8BvDzHKMRvO6QHnLGU35igMvE3LkU5w2oLJDDYv1ie01I63ONwigIP
	10iLJZSKJoVqNC4UCHIq9dZ+dskbIRdNjbmhxaycOpM04um46u4vKQIiWPowMjUDUFiDv0m0UIS
	ULIbZ1AZ+7O318A2DTO7LVIQgrYqTcwIxIPptE3e8OFstB0pZwopdGG2hQut+1w=
X-Google-Smtp-Source: AGHT+IEokO+3Wk6AyeH4Dqm42uc1ybfhtzvrL/+C+eKBmDBhVkHi2YIMqZsjG3HR2Rb8VWwFY2Q8XQ==
X-Received: by 2002:a05:600c:46c4:b0:43d:24d:bbe2 with SMTP id 5b1f17b1804b1-43d1ecd10fbmr38111635e9.28.1741967474548;
        Fri, 14 Mar 2025 08:51:14 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d21d67819sm15249945e9.21.2025.03.14.08.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 08:51:14 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v2 0/5] arm64: Change the default QEMU CPU type to "max"
Date: Fri, 14 Mar 2025 15:49:00 +0000
Message-ID: <20250314154904.3946484-2-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v2 of the series that cleans up the configure flags and sets the
default CPU type to "max" on arm64. Since v1 [1] (sent by Alexandru) we
addressed the review comments and distinguished "--processor" from the new
"--qemu-cpu", to configure build and run flags respectively.

The default TCG CPU on arm64 was the ancient Cortex-A57. With this
change, we can test the latest features of arm64 QEMU, and for example
run Vladimir's MTE test [2].

[1] https://lore.kernel.org/all/20250110135848.35465-1-alexandru.elisei@arm.com/
[2] https://lore.kernel.org/all/20250227152240.118721-1-vladimir.murzin@arm.com/

Alexandru Elisei (3):
  configure: arm64: Don't display 'aarch64' as the default architecture
  configure: arm/arm64: Display the correct default processor
  arm64: Implement the ./configure --processor option

Jean-Philippe Brucker (2):
  configure: Add --qemu-cpu option
  arm64: Use -cpu max as the default for TCG

 scripts/mkstandalone.sh |  2 +-
 arm/run                 | 17 +++++++++++------
 riscv/run               |  8 ++++----
 configure               | 42 +++++++++++++++++++++++++++++++----------
 arm/Makefile.arm        |  1 -
 arm/Makefile.common     |  1 +
 6 files changed, 49 insertions(+), 22 deletions(-)


base-commit: 0cc3a351b925928827baa4b69cf0e46ff5837083
-- 
2.48.1

