Return-Path: <kvm+bounces-50316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C24A2AE3FDD
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73852169CE4
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E1C1F4604;
	Mon, 23 Jun 2025 12:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jbnq3S+9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159BF1C5D62
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681156; cv=none; b=ZddkuWSt9P1CktRX1wddslmmJyxn3yXCTvQXJLoKDtVwu3AG7NMNS5z4MEuFdLYqfVkxcgPAqUKKjgcwlkN/F8p9c88Oo1HBvizKwu2Fowmv8Gcu56zS+N73xFqnxYzJbvGWWBlro9z3y+4nZw+HaRdmOZrpbNoNlkXfCurDXVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681156; c=relaxed/simple;
	bh=PZbL1xzCr7ASQ1pq5zWuY38koMk1pDr2cTIvzh/4/bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a7xEtvY5WMxQw4P3R6lvmmBm9noA6wgCVfOSBPXf1mzWM5e4CwAtOWCo5SQEF197GfD/ecPoTKp9ryoFqtloRMSCtNPx6UEzafLfwyU97cTnQV6MXEwx5H91IYbjxt52UCGRAXJmZpqqMWQLfjNnn23yxPPqjS4wsv6W+8uyT0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jbnq3S+9; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45310223677so31047765e9.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681153; x=1751285953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iPGemtR2ZdzEfUCvxZ4Y78uZrjiue5vwaeOrBHsS2Jw=;
        b=jbnq3S+9VPEiUGlcvnbLMmTLNDnih0uU8gO4glL2xPmboWueYvxyfKcW/lMXvluyCQ
         Y6D3cDq4R2ML549dUW6Tg93Z4K4gSpGfvsVCu/FEpujEJ91+CdbjprhQLwWdQiEEAjPN
         sC6aH1Og7fvKFGP7RXaNveCtmb/jzJclnxtPce/dUQpCQGZerrK2PaW8mJVSKsGmdoPH
         LFmVZvdohET4TKEmgfM74ZzzS9dBcd2dtpbulv2sg35GeiKzC7NBX0ZPrFrSYZrXkSsy
         4ZWQs6ijpHZxhz/yQXX+8eEa03DksMZRFsvM2o0RD2SKEr1VxLfSJaaDzngfPLU6zjoE
         C+zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681153; x=1751285953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iPGemtR2ZdzEfUCvxZ4Y78uZrjiue5vwaeOrBHsS2Jw=;
        b=CRED3ONw6XOh08xiNMjOQxQ+tQaLnxaDT9ZczaRThjq3UfLcVgvRux+m2lqKwUoyFH
         AbXRcAzQEdCIAdU1WlGk9mek2yGWXspFuB2IDTUFf+HayL3pitjLyHHO57dNhZsNqh6e
         Vk/3sPOu7oh+x89Wq9LOZv/XoV9DeRw8JOobEj1ZDijf84mM+9hcubuLRxObiyQf6wNQ
         5Qc9ERHkhdD7mP8nLOd8LXTPZv3AMgqCxPmntpX06Uvq4QkJXAIv6KP3HsxOwL0Is0sA
         hji6t7IliRShauxRzD3hiu7eMx9Re64VI0VadBYWAtf3ajh7CrLB25Sh5fMvUM7x3qRh
         nLWw==
X-Forwarded-Encrypted: i=1; AJvYcCXHLl07DWw8fY78GwA3TAd+m1Zc5M+Y7pUs584r1DNCTztvHvrPac1+UuUZBJHnAYzlw1g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOX/voU4gu9WskQDZ+vAncsT72CXe1ZZel/IQKlCHNS9u9tKzr
	emF2LxmagEELqG4fag2cfWgtCQix+DhCzq0HhHAb75qtnOKLdswM1qFdyp3jVCYDdRQ=
X-Gm-Gg: ASbGncsKwNZO03GR8e3VUGe9lJ9AxCiEH2P+j6bHeIAKGdOgwVDyq+XZGuFQtVmD4iS
	0WeROdDbNPpeKJ98f/z7QEzlKDFBaez9ezNk80tgByP2FwsH4CqW92xZK4XpCenXVyZR2ozmbSh
	6uhDZU4ky0BrUS3DVV702A6vD3DXM/721Nl8Htj/p8qq6SBqLwZsCZvvPjrBS3II5iogkIynKas
	t9vodAndt1BiNLeXeyyhsWUsTXdA2RVtJiFnITmEwC8bb/BPrUewOeP0w/rVFlHZQK/7TVHbL8G
	6hS/Va04tLUftf0XsxDzer+VEL5X9U4eRtbOnLtxhEwKW/63glaxFQUi+XChSDS7pp6hwqdlvp4
	ABGH3/zCCy65b2UymE8a9j3aI1Ym7UrpjgUNZ
X-Google-Smtp-Source: AGHT+IFc5MQF2NU8xSghyO4Yhud3yuPLg4Ae8wD9rvl4pDNx1QI2WiEDWAGMHEB+0CpNqwj6XAaSXQ==
X-Received: by 2002:a05:600c:34c4:b0:450:30e4:bdf6 with SMTP id 5b1f17b1804b1-453659dccb8mr105349215e9.19.1750681153473;
        Mon, 23 Jun 2025 05:19:13 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f1d87fsm9323283f8f.45.2025.06.23.05.19.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:19:13 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 05/26] target/arm/hvf: Directly re-lock BQL after hv_vcpu_run()
Date: Mon, 23 Jun 2025 14:18:24 +0200
Message-ID: <20250623121845.7214-6-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Keep bql_unlock() / bql_lock() close.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Acked-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/hvf/hvf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index c1ed8b510db..ef76dcd28de 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1914,7 +1914,9 @@ int hvf_vcpu_exec(CPUState *cpu)
     flush_cpu_state(cpu);
 
     bql_unlock();
-    assert_hvf_ok(hv_vcpu_run(cpu->accel->fd));
+    r = hv_vcpu_run(cpu->accel->fd);
+    bql_lock();
+    assert_hvf_ok(r);
 
     /* handle VMEXIT */
     uint64_t exit_reason = hvf_exit->reason;
@@ -1922,7 +1924,6 @@ int hvf_vcpu_exec(CPUState *cpu)
     uint32_t ec = syn_get_ec(syndrome);
 
     ret = 0;
-    bql_lock();
     switch (exit_reason) {
     case HV_EXIT_REASON_EXCEPTION:
         /* This is the main one, handle below. */
-- 
2.49.0


