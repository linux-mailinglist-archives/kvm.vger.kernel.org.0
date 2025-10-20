Return-Path: <kvm+bounces-60513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id F0402BF0DE3
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 13:36:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1BCA04F400E
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 11:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5FF62FBE02;
	Mon, 20 Oct 2025 11:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f554nIUl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4292FB963
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 11:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760960145; cv=none; b=PxIgntrG6HwJrOUGPXmxyILt1Dgs3KFtMQZHULFrw7ASdMJDvdF8fQqy4pFy4oHv1AvrM8ZM5qPwvwGpPzwhff7KOAbtGtqVaL9A0cMhPr6sIO1BtKs7r0+oezuahlsEDhN3wYDPgI/+yhZ4QS1DJxBSZpO3FW3cTnfY8brNIyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760960145; c=relaxed/simple;
	bh=eR6IR+0+HcZgX42GHDv5+gE9w7Xb33d3WVW7VKMOqDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VtG/nizoMXLjslSuP/8aAzxT4BUo+sRDbcpOXwx6fotAYqWeJU8kaewBZ2UoaYH/ZyJfrhimxfk9V5p+SiE4y/l1aol2SkoUan/M7qkDZ4vVxGEVHuGmn1gdUwruyn1hl5FuFhZcZy/3SEylbvSDoVVsdtIlEKs0cPZImXyuEGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f554nIUl; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4710665e7deso14252845e9.1
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 04:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760960142; x=1761564942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=71R8sAvBEiNvqEf9kiOYU72VRXxnt/PEhui8Mhvi1Og=;
        b=f554nIUl6xDKwbtbg8KePD1ja1/AQViYvJMgfs+BipCWWaSeQ7kNsLbrOzi9ipAioe
         yzDmlUuVDWy1jfVsnIVFD8Ma3eWBs7PyUhZbcZaRz0IHHkVIPGtgqSSmHPwCRtgBGTak
         C/AJ/Onjepu9xPoZeipfvee12PDTsiB2C+zQXctrJ8U9DS50R6TEkq4Zm3Dr1Fqo+MIv
         Vqq431h6i9efvFEW7o9QhIZsNHDDDufKnDSTtQncXozB1GyClwQ7tS7NtcCMreAiqp7n
         UzZJQ+YdEIG98TWeGxwJFmdlMxqvdNxQRTbN4sN/0pvt9PXWrBlcfsJ1f6fDIWtl4N5z
         LxOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760960142; x=1761564942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=71R8sAvBEiNvqEf9kiOYU72VRXxnt/PEhui8Mhvi1Og=;
        b=Q+mNSiILBlzY8q3yve3P7EkllQaELy5ZkArjUtNS23QwrOz9ITWagu0lIOVkfO9bg9
         cwma41FSKJP8v9CiDT16beA2gk2FxpKPQsUIL4X6zyNFpJOjgRKtG2jl5sGTV0tye5hp
         HQzHx7SvZt4ROg+wcVm4X3QwqaEU+WKy9MmZJ6wSwhodDhwu9RINej3pPP3lZSqugU3h
         7cYVEYaA/gOhDfWTrhEMHyemQOkClweFvPc5hinwNadxwQ66+Djh0T20///Mus49YLl3
         pKW+iuZayW4O85dushqE3yML2bAbsV3KCMWle667hyxL5etA1FVNlwq9iaIB+oCpou2Q
         mNWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXU5lnuZf+3su4LelqTLtH06bOPDKs+kBsrftNx0vn7tf6WfPTMgM+elrPnai2VmAka1io=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9G6PKyOpPOKSxJ35rSMd2rTdVqurRn0ooL0iNXkcDide8Xyvq
	GaWKjXAafY5l/6RG78/gnTKPxvxSjHPw5Ka/ZhWVX8x3BVYuP6RuCWnu+/OvYV64AZ4=
X-Gm-Gg: ASbGncur3rkZdMkTsm2SbccB8LjxWKCDvm/hzJIjkXcMSbNbflI8lvbrS2vXnIN96R5
	Fu7sJwRKCPgrdKoEcyeaE3cK8aYoZadzGC17nO/A+Gf42YGpsShx/K74swF20sW5XNeM6OdS5IS
	aPQ/eqHUNCOyvLV7Q3ISoxp/zqrofcLBOojFkNNi+5GbxgPnCfsAXjrm2D4SNMWM///RQwlZvcx
	N58YYDjtucUP+3wGcx1Qq3zZS1qpzlOD5boHl9/CneOK0xXUW4BLDUPWnHf7TVhZsBLbKjoqXuu
	2C9FYj4Ij0ncP/7V8x/mYvR9IxkRlqo1eWh17Uej9qHNoGvIAQyempQQZYSEjqmB/5ieV4EHXcl
	1DBiLFC+avVUSUv++XlKdAGWxEuRz/l1zCAAdrIKm3soaYXXY4SSmGHdm4/uwgRkcgAONqHIyAB
	c+2ieNb+VLxXwACm9ZQiuMkCQ3553+HIMXYDXM5bMZ3KhKQLI3lbqUzsTAGsL7
X-Google-Smtp-Source: AGHT+IEPx0SE5xUIDTfxvhDNmRz2LWgkyKXl8jschWeu+y/qt79zcqlwmwc9t+0lsEUm/8AyI37oAg==
X-Received: by 2002:a05:600c:3513:b0:46f:b340:75e7 with SMTP id 5b1f17b1804b1-471178748a9mr100220295e9.8.1760960142366;
        Mon, 20 Oct 2025 04:35:42 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ce178sm14714271f8f.46.2025.10.20.04.35.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 04:35:41 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 18/18] hw/ppc/spapr: Remove SpaprMachineClass::rma_limit field
Date: Mon, 20 Oct 2025 13:35:21 +0200
Message-ID: <20251020113521.81495-5-philmd@linaro.org>
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

The SpaprMachineClass::rma_limit field was only used by the
pseries-4.2 machine, which got removed. Remove it as now unused.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr.h |  1 -
 hw/ppc/spapr.c         | 10 ----------
 2 files changed, 11 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 60d9a8a0377..b9d884745fe 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -141,7 +141,6 @@ struct SpaprCapabilities {
 struct SpaprMachineClass {
     MachineClass parent_class;
 
-    hwaddr rma_limit;          /* clamp the RMA to this size */
     bool pre_5_1_assoc_refpoints;
     bool pre_5_2_numa_associativity;
     bool pre_6_2_numa_affinity;
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 97211bc2ddc..52333250c68 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -2728,7 +2728,6 @@ static PCIHostState *spapr_create_default_phb(void)
 static hwaddr spapr_rma_size(SpaprMachineState *spapr, Error **errp)
 {
     MachineState *machine = MACHINE(spapr);
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
     hwaddr rma_size = machine->ram_size;
     hwaddr node0_size = spapr_node0_size(machine);
 
@@ -2741,15 +2740,6 @@ static hwaddr spapr_rma_size(SpaprMachineState *spapr, Error **errp)
      */
     rma_size = MIN(rma_size, 1 * TiB);
 
-    /*
-     * Clamp the RMA size based on machine type.  This is for
-     * migration compatibility with older qemu versions, which limited
-     * the RMA size for complicated and mostly bad reasons.
-     */
-    if (smc->rma_limit) {
-        rma_size = MIN(rma_size, smc->rma_limit);
-    }
-
     if (rma_size < MIN_RMA_SLOF) {
         error_setg(errp,
                    "pSeries SLOF firmware requires >= %" HWADDR_PRIx
-- 
2.51.0


