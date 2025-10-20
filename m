Return-Path: <kvm+bounces-60500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 517D2BF0993
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D38B189181C
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0612F83DE;
	Mon, 20 Oct 2025 10:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yYg1jeTB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A40A2FD1D0
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 10:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956725; cv=none; b=MU3kDSPLHvWZgELBGGMEf1qUhejYGZ5Ai2Es0gfZKwvrntrilkTmr2YB5t+bkDGXjtMAfyPCiXEPM4bGS781zEoRQny4RBNQeKnLmqyGsyE5FanXSSTuaGf9xnz0GbUcAmLHz7sEzZDZXYHjm1p22IhllfWw0ggeH0yhcq3P87c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956725; c=relaxed/simple;
	bh=y61I6vIxCBtq5hpX+HaOyQV0uQHDdsz3IHJUqyZibWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mphhp4BRPBGlcOxUkBwjrB8UWBqe/7xNbzwI9XVa/2tZ2w6vwH9JxKZ4WoDIybklkKUKacxrT9X0/q5Mjl3IERmH0ljxDJkKZbhKHsWtnWTSYRO1cD8J3ayylPVHdqlysHXHLO9o52Nv5Nsaxz7g9Fzd6IgjtZ3BTD5Y097M6Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yYg1jeTB; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46fcf9f63b6so22075195e9.2
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 03:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760956722; x=1761561522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2QqASWvK1t899Gg+yC/9t/MGzsv3GeI3HMvGU+Y6Meg=;
        b=yYg1jeTBYkBtJiARo+BkY7JMaPVhtuMwzwoD6mrXpMAZjg1rWSIF5+ooTHDoZ5fi4t
         ldpAVeMZehamvAATkN/bLWk4oA5l/9aUKzfi0ewmLxPf9Weq051x7+PfixO1lldbXymD
         E/VmwVUDJ02/EMNFy6WR7GUerZG9Fil3jwg8BSrR1rx73bL1mJfbY/fKzUm5IXkF0pW7
         XlAOZbeY9h8TzhrtUw7tIcffESiSVtVOiXuFRVRhhjGPzzx+7P0gObGzlvQLekcOy3in
         iyqIO9inoqqQIeUtwJ2NY2UWMg4fekpi3tFjtytdE2jUXze0owBGoWbDP+mYCZtaPid5
         pZhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760956722; x=1761561522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2QqASWvK1t899Gg+yC/9t/MGzsv3GeI3HMvGU+Y6Meg=;
        b=bIT63k5RXAqrpyUX7FMy5JRqrATC7etotsrFI9/kM4ZAHMftMADQYsLCnmjQTls+oV
         mpmVXzjehkKlciRmzrUTb93VI7MnFXMSFZwuz8XTGcm4/bEIMkfuIHqNTlWBn6hpUkwl
         LEk5FuK/37xUgyg4DO5xkyNMLL3rxAr3Se5FkOn++wcVl9zrPr4WRfuPOSenQ6NdQxdp
         rTN6ivcCmJbgLoPVpATSCrTbWuVEy4i0QKIgT52SOudn0VEREynqX9EvNC6cp8slyHoZ
         ho7fiHTY5jmXN7UvWIyof3i635eGc/7CpKmimIOABqoKxcSRs3if4+JMN0Gprtz//yoT
         RhKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYdyNAgFof3P8BCDwQb5r4cQxVtrEhWvMo7rP856DATWkc4Z9EMKLDlxUcUrNjSeD9MPU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzn0eSyp7UFYXaQGN+RNjHWBZUyy4iOJnuEzV2PnGInhiffynk
	UgmfVLGS76DBrXjYrn6Q8SnCEBXAUqjRPw3RxRXyYR0xfXl9yrKLzvqW4kzAKbO2Y0E=
X-Gm-Gg: ASbGncvhdKOpC8JPsGGKgB8tCWpiDMP+eYgPAEpEpfO3mgBXRGVbqyHRtsXv2l88SMW
	oliuLsr444F91QjcKPjnpqF0OOtmsAn+PAVk5bYkuvZSjl0Y8M1zG9v3mLeA0zx4tjYYog5ROK0
	XkL7dLifyzIkdXorOe8eNMhFNAHs5T+g4sn7hMsRhGIppXyY+eAwAKibEBPoRYkSRC0oTIFiBc7
	+9oN9nsg0c2mjRuNxnjruMkeH1Opc01jf/akxm5b6vGRz62k0almnx7tjkPqoC6H+E4WkBCfZHf
	qTdfAReyscdw/wfCu4Bo+V5MvXeTvNJN5WVj6xRKdiHQeYNLFT9akE5EHHr4TqwdImsdP4A1/W6
	tYv8ac2qMU8b+cHNpvMsGFKb1dubCtn99xs6T7o0dfbPfKOASrgoBhHzT3uVCzqEET5ZXrEjWz6
	eH1CKc07FD9CcVmCxBEEwyeb7V9I6cfuOZu7zFs/5EBTnsbqI8xBP0fznzRGbm
X-Google-Smtp-Source: AGHT+IG+2OrotMm39mO/NMpFJE/4JTcqijQrOf5TAI7bKDmv2wXdxouIqwoMumQUqKhnsP0tNIQR8g==
X-Received: by 2002:a05:600c:3513:b0:471:1415:b545 with SMTP id 5b1f17b1804b1-4711786d625mr98567695e9.7.1760956722179;
        Mon, 20 Oct 2025 03:38:42 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710ca4931csm117818495e9.0.2025.10.20.03.38.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 03:38:41 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-ppc@nongnu.org,
	kvm@vger.kernel.org,
	Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 05/18] hw/ppc/spapr: Remove deprecated pseries-3.1 machine
Date: Mon, 20 Oct 2025 12:38:01 +0200
Message-ID: <20251020103815.78415-6-philmd@linaro.org>
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

This machine has been supported for a period of more than 6 years.
According to our versioned machine support policy (see commit
ce80c4fa6ff "docs: document special exception for machine type
deprecation & removal") it can now be removed.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/ppc/spapr.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index b5d20bc1756..2e07c5604aa 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -5032,28 +5032,6 @@ static void spapr_machine_4_0_class_options(MachineClass *mc)
 
 DEFINE_SPAPR_MACHINE(4, 0);
 
-/*
- * pseries-3.1
- */
-static void spapr_machine_3_1_class_options(MachineClass *mc)
-{
-    SpaprMachineClass *smc = SPAPR_MACHINE_CLASS(mc);
-
-    spapr_machine_4_0_class_options(mc);
-    compat_props_add(mc->compat_props, hw_compat_3_1, hw_compat_3_1_len);
-
-    mc->default_cpu_type = POWERPC_CPU_TYPE_NAME("power8_v2.0");
-    smc->update_dt_enabled = false;
-    smc->dr_phb_enabled = false;
-    smc->broken_host_serial_model = true;
-    smc->default_caps.caps[SPAPR_CAP_CFPC] = SPAPR_CAP_BROKEN;
-    smc->default_caps.caps[SPAPR_CAP_SBBC] = SPAPR_CAP_BROKEN;
-    smc->default_caps.caps[SPAPR_CAP_IBS] = SPAPR_CAP_BROKEN;
-    smc->default_caps.caps[SPAPR_CAP_LARGE_DECREMENTER] = SPAPR_CAP_OFF;
-}
-
-DEFINE_SPAPR_MACHINE(3, 1);
-
 static void spapr_machine_register_types(void)
 {
     type_register_static(&spapr_machine_info);
-- 
2.51.0


