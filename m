Return-Path: <kvm+bounces-50330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EF8BAE3FFC
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:26:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11F1517722C
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D01D32459D4;
	Mon, 23 Jun 2025 12:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jbrOCLC9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B857244678
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681228; cv=none; b=M+un9pDaC8chcyIG1/nVJ3TRxkflZDgE0DNN2QvYiQdoq2Xt8o5GsOjSsAMbz34iQ5Pwf/31b4iSnHHvI4WrJKYK68FfkCOI1dwodQIGSN1Y2aclxoKaflXjx+kFefZohKuf3LgQR8dNusGHo6pQ4L4Pm1DtEIb0wnvFGsNh/g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681228; c=relaxed/simple;
	bh=azX8GAyIJEKy8HRPNAKoeinWDh25+oBDKSQcGmjkIi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jxnv8YAEs83oewHADDZ44pCK41ZV7qL+SmYaYGdjUra7YgPPtHnL9+bs2BSD+c32UQO7+vJIiDfD260akHoyhwi3mHUaAIlMF3eEc/lV+oxxBL8ZaLBshhASNZX9CFUMeNIJKak2vOuW6SKL0yLqS8autWjmV8t9/sk6mlpZXU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jbrOCLC9; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-453426170b6so30286975e9.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681225; x=1751286025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jKb7+45W8wr+DNWypSxWBKVEj0bAIAzVgg/1Er2vy8s=;
        b=jbrOCLC9F6e2NB6wBOSTfy5Oqawt5zQd1jHi2V86JpBk2RZOBkHEEE7xB+9S9Kf7PS
         QPS+5yKTJvWe87aEbCVdITWV0t7E2/E4KvOGpBpyU64t2zAO/nuSjkeKvJbN9WnG8+Qx
         K93VKEWP5rWjM6stLOpfx22mQrfRwxIQB3HV7he+YBPMiCkPsQ6CR/asy8bLZfq5Uf8x
         Z/N352oXitX/M1OhZyyucz9TyjDhL4GM26ZjNa0kjYUZBhSCRjU6spZ3u6bt8X26bqXl
         QdOVQ4DGGKQR6wE0IhwzKKBHWbNV7qEcbt9nkSuGf8Nd8e5+QD7dHGOEAQ1P+Wbd5tzF
         9MJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681225; x=1751286025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jKb7+45W8wr+DNWypSxWBKVEj0bAIAzVgg/1Er2vy8s=;
        b=nIiE920UDxwBFSE0TnsC0B+FxB+SHjUuXfC1xvsoMK9/Ag93R5MDS2FlNP5A1JRStT
         LKSBuaqbquWdYIgi5q1sc5SnlfP9D4DmdorSAak9x/Gyxg2MU83zQAKNtVhMiDtqCCzk
         eIEDptW7Mav0J7JCWxyqwCtDxweNZYTHdALNizR6UKd8r8llQW9TYEiIROZWLBiT+Q2Q
         AE0WIb9oTZnTRH64DBS6GfpQxPKOWqIzbrFKKUNuCFdjQBSlJ7NPddL9pNTU5i5E73yw
         1U8G+GNrFKLie7i+J1Ys719mE5OfCvTHcQwFK5k38fkCKVpJz5UMF7XhVW/4SKG1Q84L
         B7xg==
X-Forwarded-Encrypted: i=1; AJvYcCUEBt0fzD8HuPTR2h8zqoiLSiBxI7POsb1adJfWyALmhtynq0NMX2aKJDtoYiggQCvSd8s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX14e0uYcimfA1XfwrYAd/pe2LkhfExNXXXyNm/1M+wWX3P2R/
	aMjL/yIRNJj1TMdkLh4yRYnq+diF90o3noqzIl2cWXwsJXdy06R+DNbfEn0QToxjg7o=
X-Gm-Gg: ASbGncvw+n1K8adgcEu01AOGqHy07snkGEgPU5ax3mYMesIYvQYtd5Y2T5+O30CnnaC
	6HcGl/vvwzy7lDpY5IYBWQXUTtM7+m4fqjeCXrq/IkLQ32QX2lGZ2b3hWdY7RYILupIBoRTk2/D
	SBscTYEyzBS551X5nJ6xdGX6l6EmxSuwZnSVag2KyWkPBr+gTMmRAb++649rMAVs8ASstI+VkGj
	HFJI8Oo4Ej7apSvyE5eympWv1BNMFO9/0B/MNMngpLg5wwzL9y04O4Wfrk/VBqYt3M3Wd6MlO92
	yLznJvGNhA+3MajV34/sR2DG7kFKJg6SXJ+FCe9CUnqXcZG+ivPv3DU2Hdsqhc30NfYMmAO0gk7
	0xv0ifdJVnoFIK4Z5k63HkFv9U3eKDpmGcs/mtI1Z5rOHnZw=
X-Google-Smtp-Source: AGHT+IFKeCPKvJTY1oRMd774pzSdTPhl9ZbHhi8QfaLesPsg0MuI5svGt7VJgysSnyjP9cXdhnmSyw==
X-Received: by 2002:a05:600c:848e:b0:450:d79d:3b16 with SMTP id 5b1f17b1804b1-4537a7e5111mr3528625e9.14.1750681224860;
        Mon, 23 Jun 2025 05:20:24 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f189cdsm9446171f8f.35.2025.06.23.05.20.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:20:24 -0700 (PDT)
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
Subject: [PATCH v3 19/26] hw/arm/virt: Only require TCG || QTest to use virtualization extension
Date: Mon, 23 Jun 2025 14:18:38 +0200
Message-ID: <20250623121845.7214-20-philmd@linaro.org>
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

We can not start in EL2 / EL3 with anything but TCG (or QTest);
whether KVM or HVF are used is not relevant.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
---
 hw/arm/virt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index b49d8579161..a9099570faa 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2210,7 +2210,7 @@ static void machvirt_init(MachineState *machine)
         exit(1);
     }
 
-    if (vms->virt && (kvm_enabled() || hvf_enabled())) {
+    if (vms->virt && !tcg_enabled() && !qtest_enabled()) {
         error_report("mach-virt: %s does not support providing "
                      "Virtualization extensions to the guest CPU",
                      current_accel_name());
-- 
2.49.0


