Return-Path: <kvm+bounces-51419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05597AF7120
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:57:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC4774E155D
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0DAE2E3360;
	Thu,  3 Jul 2025 10:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UbwZ/usC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D39A2E175F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540230; cv=none; b=tLE7Trj3Nt1bK64QdyeS91JC2D57mjoBlF58fH1Ms3nv2jS0oHmGxcoBL1Tijriw/4oE6jcW5HPobjnqNFl9Mcz17Hqs6hUEvgi1Y7hUIIb5uZoliF5AyMKqZKKQOVxRGQLdeIaezJFRj+LB7/APsrj1RFBFI4Td35OvRr6Nn4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540230; c=relaxed/simple;
	bh=T4V1gBHWOn/mxcIZc8juMChRNJ1If3dcwPMOF2L5g5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=um29k/YcG8Z9SufVEb+O1PqCBmV9nhZB+aNVF61rBYe8bnpN6Vwdo6Nt9wkkZotlJqNh26Tbxh8gJWgS9ipg/MTsF/JOG1KX0hVf7Mcgn0V5f6hhZXKzg6nFj81p2mWZK4Yc34aSvUC/TvJkfglnM+mL7SeLSgoz83u+2DslN00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UbwZ/usC; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4530921461aso52353375e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540227; x=1752145027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MnLLL7YQoCQGdWR3EVL4zcbePVJyUuDX4baxuyLLriU=;
        b=UbwZ/usChh0CgNxpKSGptGMY/NPMzuv3LUKdZYIaRm3GiqBDNYb7d+G1Nnnh9oPlZk
         ajJ7cTlXJ7iS0ARsd4sbDIlS/kBTlKKZNYREQB299wfQVXYnX7wSWe0oO2EA0QMuiwG0
         0BSgUl7NRXknudqRjTHd9DnAqCfSaNVxbXVYyHv8FsBOoCrWf9cQIHoU6SRPlIdZcv/B
         k+gIabmJX5VZ490HesF+mrKcqg+6yfFTPm1tDUQNmjEKTZPAoR7TsLx4jjXeOSwFm03r
         dB904niqwTLkaVeXWYuoLby2cKQuzXJaaT/WW0HBNj/lETx5TtEuqaMUd6n2tW7r3c+R
         nyCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540227; x=1752145027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MnLLL7YQoCQGdWR3EVL4zcbePVJyUuDX4baxuyLLriU=;
        b=PAsgkwVuPskcS7IFpMQ+0zIsPzTBO14gTZkNrgYuSDeeow3TV67NwuR4+wC9Ztd+cH
         yaaFhMBFJblpFrGSqFNUajBkgOUUfdx+us02LyHnJ201jtsMP9Hcwd1IGuLAZLRs9zJK
         vyNxHxPOQqW+klG0b6Bh9gFPx0qjt3fdt56jRHUBH6sMJQPARbZeu1+w+rEqVjipr19T
         /anbs9SbLqglVcHTuj49Izc3fjCNmdOcHrzbtvmeF4Cy2qS3JH+xP7xylZIIQFuHjt1E
         YTzHewfyuiGgTnv6usTWMzr5hNbRSFHTiROBSWIblQqD7idQI783QVUdFQWlGRN5ywam
         B4fQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5bPTXi9q7zOvKLajbfDtmIL1x9Zw1Oa3iHxRdOMitSyHW47PiSQpmQDsgpivaoSMLLIk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw++vROxzYl8JHe86HqYdXMYiqTksrgKc3/w0RgI+/4+me34Se/
	NIWppfOBcosQO9EHaqahivd6q7N+xogVSHdS9SWJzutrCXRofVmMZIdKmixidKACViAV8JPEg8u
	eFZ4yNWA=
X-Gm-Gg: ASbGncuTXY5t3OBmVnpUEudGac0C73flgdPIDja6JLTNE9nDbwFqYRM2/NNsI+qvJqP
	e2oC2qKzwFj5HniB4e+GI1Sr6tvlmAD1sT4nZyCLo8YV5X4yXnkRPoNg07WMtEy5UpsbASjE3lF
	klLjAQZy+QLjaSxw5Sg+tMqk2LFd0yXP1sPjZJOFzlwITW9D2tO0xouKtlk3qwcmbNTA5Sr80yt
	Fp0RJZjtRPyXqDlVRr9X1018/zLUD0WIdXWyqMw+oArtXqnsu6nUfNtJRgMnBAFqrYYoKFi7buH
	wRuRYU3dX+1omwsUEAW3orPZHPBMF6JGiQqhx2eOoXyO3wh6ElwgFNt3/V6d59GLtu8fHujgjUV
	BAyQoFyOZess=
X-Google-Smtp-Source: AGHT+IEYucf5bnqrTZ0PYjrv8kqSiGOKUc/yPkaJr/uv7wwktIzjqebLnUo5ht4si12JpTCvy+cETg==
X-Received: by 2002:a05:600c:820e:b0:43c:ec4c:25b4 with SMTP id 5b1f17b1804b1-454af1d8088mr13927765e9.10.1751540226727;
        Thu, 03 Jul 2025 03:57:06 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bde8c8sm23730205e9.31.2025.07.03.03.57.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:57:06 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v5 16/69] accel: Remove unused MachineState argument of AccelClass::setup_post()
Date: Thu,  3 Jul 2025 12:54:42 +0200
Message-ID: <20250703105540.67664-17-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This method only accesses xen_domid/xen_domid_restrict, which are both
related to the 'accelerator', not the machine. Besides, xen_domid aims
to be in Xen AccelState and xen_domid_restrict a xen_domid_restrict
QOM property.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/qemu/accel.h | 2 +-
 accel/accel-system.c | 2 +-
 accel/xen/xen-all.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index f327a71282c..a6a95ff0bcd 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -45,7 +45,7 @@ typedef struct AccelClass {
     void (*cpu_common_unrealize)(CPUState *cpu);
 
     /* system related hooks */
-    void (*setup_post)(MachineState *ms, AccelState *accel);
+    void (*setup_post)(AccelState *as);
     bool (*has_memory)(AccelState *accel, AddressSpace *as,
                        hwaddr start_addr, hwaddr size);
 
diff --git a/accel/accel-system.c b/accel/accel-system.c
index 913b7155d77..af713cc9024 100644
--- a/accel/accel-system.c
+++ b/accel/accel-system.c
@@ -58,7 +58,7 @@ void accel_setup_post(MachineState *ms)
     AccelState *accel = ms->accelerator;
     AccelClass *acc = ACCEL_GET_CLASS(accel);
     if (acc->setup_post) {
-        acc->setup_post(ms, accel);
+        acc->setup_post(accel);
     }
 }
 
diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
index 1117f52bef0..ba752bbe5de 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -63,7 +63,7 @@ static void xen_set_igd_gfx_passthru(Object *obj, bool value, Error **errp)
     xen_igd_gfx_pt_set(value, errp);
 }
 
-static void xen_setup_post(MachineState *ms, AccelState *accel)
+static void xen_setup_post(AccelState *as)
 {
     int rc;
 
-- 
2.49.0


