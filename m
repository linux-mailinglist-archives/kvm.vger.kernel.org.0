Return-Path: <kvm+bounces-60497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6705BBF098A
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:40:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AA8A3BAB42
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4DF2F7AA6;
	Mon, 20 Oct 2025 10:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IY+mpips"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348652EA146
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 10:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956711; cv=none; b=AdBRLSdQuggYBx23fDbiakCBek9mRKUsgBORwPKG3oEG6KQ0b2sWKhFm7rjlkel6EE3b45abIwxsgn5xtNqKLG7TldEy1cAi6gcQX0bscJpL6KD6zk/kjHhtQ74pOsA5RT9DCSn4ecbrr7Q4y+mDQcqfrgBpcHoYV2gxL/M/QrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956711; c=relaxed/simple;
	bh=xoKtoh7szdLpNmnwsWwik6qDwyILGXuewGlhFm2y7dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hh9tZmgI+4hAw1F1uN8BNU4uDnvAn7j99dDtqJg8DxCPx9RUfVCsUYtEbYcgkfPYDb2sEztwE4roW8Up6GuB9GAtAoyb88mu2Ro5vMTAFRZE+P0yuWV+D2NPDRrphleJj73euF9FC3UYyewHXRvINidIoI0OD83zSf69inQuQE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IY+mpips; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47112a73785so31361175e9.3
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 03:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760956707; x=1761561507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OH8+GFr3xguvK3YMgH40pVk9NXUnal96AS8GYRsqGP8=;
        b=IY+mpipsuZi6z0ww2adAIo6xuFE1SVeMDXsYmhPbvB83sXegpQ+fDjjBTChlisjprD
         5IHbf7F83fpTKNpfunIocWPAhFwPJrSsM3O8hUShZFMEHk52PxYUFGZBMXtMgW8oOFBe
         I2CTCohRXwn4G59BdPUnGoeNhFW3qZC3ufAjJfyzjlTTN4PWXUA1m6Z182Nz/tgyAKkI
         +H+Nu8xnIxx6D50goLfHZmwEVm7RPXYRabUCvvtUkXYZdID6k6eVGraj3jA2xWRS3a5B
         dtOwlNXjBtfdwfSQxCJXlaSL19CVrsjJB6S4iglH2wZijkSSytuWBIlFQxScnx1M6+UZ
         1C4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760956707; x=1761561507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OH8+GFr3xguvK3YMgH40pVk9NXUnal96AS8GYRsqGP8=;
        b=ew323VPpH26kZxo3cW1mtIZ9zxMHYvLLaiLqDCmC7MtRd9bZGMZtk93aRcY73bCuGm
         Ly/QMH+8w5f32mAIVt5kbcqPIVq0OLLcxSN/vjn3aM/II+OunhFnh/mTXWC0ZK3szVMx
         aybVyimlUHKv5vj6NeaIJKPMnD7RPn/sF2x2VM3leqB3CDX7UATeMs1X3cijKXmxzp+t
         uezaMwJo2ONAlDpsy5us0nzAHTTc9/FyJmVMDt+CmSdBc+/6IgeYenEa8AYOCXe5BWDJ
         PpU5OtU7X1q92AdiEo3oIGV1sM0xyZqoGlHgyqgDk+CawwgDlfCPg4brHNDJmKm9fPSi
         tjvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHawyFDLivpNUDEDE/6Drqx7lLKPmqgIXRllamFZOqoyR8DeLorCHDpjA1aq8ZZLaW/3s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhrPrCHNtOjVgLrqrq4Tdqttd1R/w6J7vWaYv67B1wGrfb17TF
	DnbkHes/3gVRDxckhHLrtgtZhU4FGLiE3D5q3EgniA1tfs7C2LzQyz+mFW41xI0VZNQ=
X-Gm-Gg: ASbGnctF/ycROH7zozPJWtCbhICBN1VnhJDdwESYjnWRYChf/7pjdhIxaSHyWr7aVKV
	ZsetEc0m1oqgC6Qwt3IVXBaWLDUVJChgUZAQ4Ab2LdhTvRPBSG6lAVR5l7EfzlysiV2cZEkSMY4
	+WdFTXCequ3MS7S/hjTl3sTGQQrLa65XgVyH691W9sD9kd/a4zqcBJXTBt/kO3w5UspHJF6AVY/
	BF3UszfWLppYnMJd5qnXVqsp55SJnersKkUNBBrTBk81HOGW/Q4CwzgXc5/GBU8CnSjWlfvHGeJ
	0m+uvv9IA/qjDZowedo3MW9WVz2RXS6gxqFRm1miBez/Ms2C40eixijHkc+gwE8DLW4wgupTLpx
	2XWzCAsAyngf6TJdjD5O0HBl/R2mg+0upXI02463/VYa+VudDfxb90saRFNo2d5rj69Z3wgl0Wf
	2+KUcdLWAt+h/q87M/ml3L8rVNzEHbwcom/p69CmHE++2S78Ket22NmpsYRjko
X-Google-Smtp-Source: AGHT+IGxUCtLJns8ADc+1HMMtvl5A82E5LNFCmXiuMTK9tNnjkSI5PY25xr23c0GX4D7JFfhVYLyNw==
X-Received: by 2002:a05:600c:8b0c:b0:471:1717:41c with SMTP id 5b1f17b1804b1-471179121f4mr77824755e9.24.1760956707510;
        Mon, 20 Oct 2025 03:38:27 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144c82c9sm224080315e9.14.2025.10.20.03.38.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 03:38:27 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-ppc@nongnu.org,
	kvm@vger.kernel.org,
	Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 02/18] hw/ppc/spapr: Remove SpaprMachineClass::spapr_irq_xics_legacy field
Date: Mon, 20 Oct 2025 12:37:58 +0200
Message-ID: <20251020103815.78415-3-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020103815.78415-1-philmd@linaro.org>
References: <20251020103815.78415-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The SpaprMachineClass::spapr_irq_xics_legacy field was only used by the
pseries-3.0 machine, which got removed. Remove it as now unused.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr_irq.h | 1 -
 hw/ppc/spapr.c             | 4 +---
 hw/ppc/spapr_irq.c         | 5 -----
 3 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/hw/ppc/spapr_irq.h b/include/hw/ppc/spapr_irq.h
index cb9a85f6575..5ddd1107c39 100644
--- a/include/hw/ppc/spapr_irq.h
+++ b/include/hw/ppc/spapr_irq.h
@@ -100,7 +100,6 @@ typedef struct SpaprIrq {
 } SpaprIrq;
 
 extern SpaprIrq spapr_irq_xics;
-extern SpaprIrq spapr_irq_xics_legacy;
 extern SpaprIrq spapr_irq_xive;
 extern SpaprIrq spapr_irq_dual;
 
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 85c27f36535..ebc8e84512a 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -3347,9 +3347,7 @@ static char *spapr_get_ic_mode(Object *obj, Error **errp)
 {
     SpaprMachineState *spapr = SPAPR_MACHINE(obj);
 
-    if (spapr->irq == &spapr_irq_xics_legacy) {
-        return g_strdup("legacy");
-    } else if (spapr->irq == &spapr_irq_xics) {
+    if (spapr->irq == &spapr_irq_xics) {
         return g_strdup("xics");
     } else if (spapr->irq == &spapr_irq_xive) {
         return g_strdup("xive");
diff --git a/hw/ppc/spapr_irq.c b/hw/ppc/spapr_irq.c
index d6d368dd08c..363bfc00db4 100644
--- a/hw/ppc/spapr_irq.c
+++ b/hw/ppc/spapr_irq.c
@@ -588,11 +588,6 @@ int spapr_irq_find(SpaprMachineState *spapr, int num, bool align, Error **errp)
     return first + ics->offset;
 }
 
-SpaprIrq spapr_irq_xics_legacy = {
-    .xics        = true,
-    .xive        = false,
-};
-
 static void spapr_irq_register_types(void)
 {
     type_register_static(&spapr_intc_info);
-- 
2.51.0


