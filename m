Return-Path: <kvm+bounces-21689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 693039321C9
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 10:28:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A6AD1C219C7
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 08:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 369D855893;
	Tue, 16 Jul 2024 08:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="0DwFqljL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F276B3224
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 08:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721118508; cv=none; b=FiK2gOk/8ECH7n2hL/Ov3UFU6+BQmAPmFXYMjcYNNz5sZ4V827jsdxDg5UlYVGN/kUCQzWGPkl3GpYYAjP/RxgBomltUlwPlMVyxH2A3/xjTeBvlQ0PnLxslInLTVGVAFPqI+7RPKAOK2G1rLDqF7gR2F1M9f1HwOg7XmO/olIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721118508; c=relaxed/simple;
	bh=ANeRDeVKrn1slVo8/usBgQLuXAbDE+JjV0j595GRo9k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IEazoa9qQAPqAa8QSK3GA7vJR44OPNvSF6h7DcJoMyuhpi3zbRyGmVNI+LcQgshf+3qrqQztkLDJBBgw6TxVqMCrWrkipVRyWLZyCcwFU5g5FV3VLOLcns6ohwChtYkaCDc8SGsQmcSX46//ZyYnmsZE76HGnViG2n5ufNp54eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=0DwFqljL; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5caad707f74so2556059eaf.1
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 01:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721118506; x=1721723306; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RYXhIuhb5B0Jyjgf4vjtjqsff5UW6UTsThhjedH3LOU=;
        b=0DwFqljLFs1JFF8Kfa2K0fTO1OJ2w7m0y0fNyEAKXwnqP1FXE/GEnDvvCj949u2x7a
         uABQdEpRA5Y0FXQ/JwYap5OTARYVs4Dpha5P9WE6eTqXgJ2F+2ZYmvOKDSnI2XTyPsU2
         oGZSRqVrgzJL2YUEvmEeJd7/BQQdb7LjIPl9PkoGsbDIkLMdiG22t0vzyEsprRcObvWG
         NliEDeZrDYf8zUFjD+Onc3yGFqIcDQFfcdImREI0OOZayu+KHH8CRar7Pc0/1jDENvw2
         OrqQADGShJ4b4rV6rhrW/LgU6td9HBYsTip7G8dPy1RBxHZnqSxSl+EHxqB/m2abwXhl
         gtcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721118506; x=1721723306;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RYXhIuhb5B0Jyjgf4vjtjqsff5UW6UTsThhjedH3LOU=;
        b=s1qPqfBPJ1ZMviPfanIq0jNlmd72oV48TUqi4CFVE47uJY6YXvpLHxkCAQpn9VcHEg
         s24uPVyAvBNCF4AtieYwkH7v501d7UXtizshMzJIWQqyQAR9Pri/tvxsoYR8E7mG02Ja
         cDURMgNwYBCNESqwwpDEXYC4DkJEAV44sfy+3PALCgE3Up/yjGvuwZXU9pE94H5n0+PP
         ZkrGIzhCBFy14kFtvgUakkXN5QOwLxm7jAvK6MG2aPlcsEDAwFGpb6mcVlx1zOwqu2L6
         SAu2CywZvCtP1J4QzVd2CTkQepkN7BcHk+ceF6HAaW5P9ON9gW4bH7ksNS+Ev4G1M5ss
         vUKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlNdPzqO1/D/FOSrVWzL4l/yJSv1kDKIZDlWwwVwHGl8A4nvfd7WNi2UWjQGoPFY5VaTRsW+zno30uD89gQbP8GRyz
X-Gm-Message-State: AOJu0Yy4NQ0jY2im9AzGvG1/QWoZqOJvAFM3ZFwcZv735cBuDJeQLVi3
	v59bgVepRXNT+facwQCHpvWivV2HtECy6yz/b8naZOdcODsq0RWp4rGc9CXjDG4=
X-Google-Smtp-Source: AGHT+IEX8BPbI+Uspvd6hlS1L6kD1r/n31SaoBBK7fdOERooqOo9yLQcoozSvCe+X8hABG0SUUEteQ==
X-Received: by 2002:a05:6358:9486:b0:1a6:7af3:22ce with SMTP id e5c5f4694b2df-1ac901cd215mr127136755d.2.1721118505875;
        Tue, 16 Jul 2024 01:28:25 -0700 (PDT)
Received: from localhost ([157.82.128.7])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-7910f291ee4sm3222889a12.86.2024.07.16.01.28.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 01:28:25 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Tue, 16 Jul 2024 17:28:14 +0900
Subject: [PATCH v2 2/5] target/arm: Allow setting 'pmu' only for host and
 max
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240716-pmu-v2-2-f3e3e4b2d3d5@daynix.com>
References: <20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com>
In-Reply-To: <20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

Setting 'pmu' does not make sense for CPU types emulating physical
CPUs.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/cpu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 14d4eca12740..8c180c679ce2 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1594,6 +1594,13 @@ static bool arm_get_pmu(Object *obj, Error **errp)
 static void arm_set_pmu(Object *obj, bool value, Error **errp)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    const char *typename = object_get_typename(obj);
+
+    if (strcmp(typename, ARM_CPU_TYPE_NAME("host")) &&
+        strcmp(typename, ARM_CPU_TYPE_NAME("max"))) {
+        error_setg(errp, "Setting 'pmu' is only supported by host and max");
+        return;
+    }
 
     if (value) {
         if (kvm_enabled() && !kvm_arm_pmu_supported()) {

-- 
2.45.2


