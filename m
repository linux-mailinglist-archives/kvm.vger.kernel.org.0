Return-Path: <kvm+bounces-8872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9724F85816D
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 16:40:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52EED282E8D
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 15:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85864130AE2;
	Fri, 16 Feb 2024 15:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xLm/Hbfz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DFF130ADB
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 15:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097724; cv=none; b=mPOsdOFeurXVNHH7ngTmM06RkXiKnOEhwKfT4zu63WF1dpvr/g8sFkbcXZU2Rm7ayvBWiIy8frx9Cp1i2RUKORsE8Z8F7p6YFUk4uSEw84a0ygLL7RNVsT6p+Ee2YhwDnvplOXhw1mAsEqGNvVOCdG3Q5F6A8t3xbzx7sRGeV4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097724; c=relaxed/simple;
	bh=PcOyVFEf0gri4XIpAngb4HT6m4AtQ68QfmxDWpKq9f0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fGLQ8aLA7ZD3U0vDIxTUsiid+QSB0I8Qx2y0t1VnbhEN9FXBeKY0BaAbPNNWNbMD8O8ETF91SLv/nJe4/ytq5R4dE03Y65Ga2IHkuYNDzqPtgyH80ijVk868tYWeN2k41d0ov0Q8prZkB2a/A9pxgr6Vo5gN7D4RI4AY1MPKJgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xLm/Hbfz; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a3e05775ab9so17263366b.2
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 07:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708097721; x=1708702521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5HOBSsoYfdBIXejJenW3gKcLKAp6yUaDTVDJ5Gv25Ps=;
        b=xLm/Hbfzlu+JKKqlUgBqI+/B5FnyzZdWYWkSvd2BERvSXXMG3MeOLLyfevsG31lkuK
         J9Lm/pbWvu5kjWoHxpM0CKJTCkrrNjWe1wIMtBNoxg01ApJozLhQ+cWkRmH9XR8mSnck
         Z2QqKvREwaOoIcdCW4Phr59fvuPNkPIPvz6buR5IA0QyoJVN9hR7Fg1P/riHJs7f8HmR
         gSQdLMVNz5vudIFcGIwDiLvvm5NyXeQ2wXWw058pRJr9BSeEM1qBuJQW2iXFOd1Ybi14
         FFGlWHzCfMWYGVYwTLbCLwBm48Odny8srlabYDek8EcXNXBRYojaVXHCoo0rftvrVmJd
         clIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708097721; x=1708702521;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5HOBSsoYfdBIXejJenW3gKcLKAp6yUaDTVDJ5Gv25Ps=;
        b=GK23Jy2/eoErXpGAHOpocJva3vvr4OxEou/7sQiZhFWdfN09XsCvFUwZcQSB6EDPHk
         5VWG3wkCxILEF3asl3R/ZBHY769lwkJxC1L1bT1RsGYwNKgPX9kEXAqT7qS5b+z1d3dG
         5FAwoSZA0Yj2CUVBnAtcnaRz4TzLCCmK4cTRZw2ot5UYVb1BSA/vOLZ1CEUexzdxXfMZ
         yVfen+83W2sQ7tD6jh/SVZj+kXVvfICNJmMVVvQyzhgw6JBRDc33qCqvyXjw7mSW9Lh6
         cLekxH/82qglZ/V5Ik44yepbRf1mN/c4oZSDo7a1RPdwHZOt0NXzh1Eb5d1C7Imi8H0d
         lYVw==
X-Forwarded-Encrypted: i=1; AJvYcCV5CFyPW/ouCT8VfjHS4y/wxdp+mNMBDx7fd+EtW625mMZWqUgo6meTuo6X9tLSRXlARQeRxrDa+YB22ISLEJJkUtg3
X-Gm-Message-State: AOJu0YwbCVmDDANmGyRHQblkt6kNFhrs9N8SGHHMAB93rqaCvS/1byfy
	cjOWQFVLRuScdnBA+o7F9Do1436oi1HLHVRWaM88aoLxJ6lEVv5wGhQmFaUKVNM=
X-Google-Smtp-Source: AGHT+IGNmgGH50mBITVJX2YF+q7t94xFy9AFmwyf0NoIqAfPCc9XxsBjfL9Fg2OGn0M5lytBsv2j4A==
X-Received: by 2002:a17:906:8c6:b0:a3d:d9a1:e84e with SMTP id o6-20020a17090608c600b00a3dd9a1e84emr1587399eje.38.1708097720897;
        Fri, 16 Feb 2024 07:35:20 -0800 (PST)
Received: from m1x-phil.lan ([176.187.210.246])
        by smtp.gmail.com with ESMTPSA id lj8-20020a170907188800b00a3dd52e758bsm45098ejc.100.2024.02.16.07.35.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Feb 2024 07:35:19 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mitsyanko <i.mitsyanko@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 0/6] hw: Remove sysbus_address_space()
Date: Fri, 16 Feb 2024 16:35:11 +0100
Message-ID: <20240216153517.49422-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Pass address space as link property for devices where
it seems to matter, otherwise just use get_system_memory().

Philippe Mathieu-Daudé (6):
  hw/arm: Inline sysbus_create_simple(PL110 / PL111)
  hw/display/pl110: Pass frame buffer memory region as link property
  hw/arm/exynos4210: Inline sysbus_create_varargs(EXYNOS4210_FIMD)
  hw/display/exynos4210_fimd: Pass frame buffer memory region as link
  hw/i386/kvmvapic: Inline sysbus_address_space()
  hw/sysbus: Remove now unused sysbus_address_space()

 include/hw/sysbus.h          |  1 -
 hw/arm/exynos4210.c          | 12 +++++++-----
 hw/arm/realview.c            |  7 ++++++-
 hw/arm/versatilepb.c         |  8 +++++++-
 hw/arm/vexpress.c            | 15 +++++++++++++--
 hw/core/sysbus.c             |  5 -----
 hw/display/exynos4210_fimd.c | 19 ++++++++++++++++---
 hw/display/pl110.c           | 20 ++++++++++++++++----
 hw/i386/kvmvapic.c           | 12 ++++++------
 9 files changed, 71 insertions(+), 28 deletions(-)

-- 
2.41.0


