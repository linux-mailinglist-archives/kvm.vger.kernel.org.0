Return-Path: <kvm+bounces-22011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7444938078
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 11:32:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E920F1C20B75
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 09:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A45584D0D;
	Sat, 20 Jul 2024 09:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="TTbgd7+1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D961347C2
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 09:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721467896; cv=none; b=W8IeMX8vZioNp2QpLPcVVjLRHMW/SxC0rewfCb7BdJEw56opSH9n4UO7BKcYVttnUcM82WXDjAg4ZE9Q2psHUCUGGJ9kRteRwfqoFdsagOrrkGBapyN8PLVBsxJE0yCD6ZjnA6E2x6OM3r25wZkvVzYSH8TJT84TsFJXxJOA6sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721467896; c=relaxed/simple;
	bh=DYnqaWjAQ5Swa7SOrX13jfrs0jdvTL9wDFwzo29zQ9U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MqINVxP3+VMDfcvKBs0aHOMEmSsg4Ze08pSv+yQNY6hXtV85e17DyvJoCQkU5d9tS8IhwbzBLFqLippLgQReayLfu+TiwIGT9wtAAcaT56KL2etYL7FaTQWEkM3kRPHk8an1hPM79ej7Rknpwm4AaIg1soeP4moB4BZaq1Jr6g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=TTbgd7+1; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-70d01e4f7fcso829442b3a.1
        for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 02:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721467894; x=1722072694; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wrhfxyQiCKIug187Kcca0q3LwAZ1kZXZGPDwQT1UwgA=;
        b=TTbgd7+1e9cfH7smSr5Qsu0a1xhcQcKYwvP8XwTyK4EaLHNi/G5K/V9UZIGj0WU8rg
         Kw6zyp2HXSj1+rUVMcE/NsqeOodlDmGe5A9EyfI2O7cNpXOdaRA7aQGT4c+Dj3Zkc5hj
         zYKbxP+WjhcN1OB6Mr2W7nGvTUSEHEfhcUOtrk1Sgm6NyrOC1dwnsZQXLSPMg0zoyYH5
         kuw+MFBIpdJnnuopQjF0c+7fAcJcfS4jhrVDmqSn/uxHfRLvBnfutieSg5IO5g10iPwz
         m3lq5HaKbJU1ZANUGfcnEPQux1WU57tUMWIHY0Z9pJUGFkoYxlwizkrpEsh5yAEftxjx
         G5ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721467894; x=1722072694;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wrhfxyQiCKIug187Kcca0q3LwAZ1kZXZGPDwQT1UwgA=;
        b=VLwcGhns+VplRfxML3pZ+GP+/ofRDZVTofmYMxmMRWMIaIzQ963EA6NS0YURpj0BPM
         rMxU4nAZ3Xdc2T79ekjVRWhV4LqvOv6cyIJVD4YiFFX9PP3TJxLwVk9inVgv8EsJj3Z4
         yHV0KepFDMC5OWuOueoFGxWYnW77NtfXUpARm0tVpqQaMZz0bFtZDgo+RIfWvspfo/CC
         EiTfTN9h+yq6c7g5rIDIpybckIBP08qioAw+Z+5IRcTlQt/rTPZ7IoKKFsBEOSukOK50
         +B+xQh3MnDpWpd6SJlYDXzQEadbfnbAGLhXA7B5RIwS6O6fmxB1lurPtVGQXsNj1yKdj
         gDpA==
X-Forwarded-Encrypted: i=1; AJvYcCVlVMPO6LSXiG2WdcjQDQSBpyiLY3t8FFZMmS5HVTBbq9c4MDRyEC2MqMXX95174gZaOCb0VwZ3xT0FFwJAr8VGVgGe
X-Gm-Message-State: AOJu0YwGRNcBFY+ort0qgfJUlnf1oZrxTsXLhd/CtbUqHCQ61vCSRj5Q
	BoYJcHWGYaBZZtwzXWhdP4HgV2jDRKU16in+s/LB3IlqV0E2Ronr/5TvfyoJpxM=
X-Google-Smtp-Source: AGHT+IEXOqSyEy2UA66P9jRHggHMp/WMJoRJ7yRzlzsXWfBfVUa9ITQgOCdoVMCmOnpVU5hdmZPN4A==
X-Received: by 2002:a05:6a00:1887:b0:70a:fa5d:ad97 with SMTP id d2e1a72fcca58-70d0ef82323mr719873b3a.1.1721467894392;
        Sat, 20 Jul 2024 02:31:34 -0700 (PDT)
Received: from localhost ([157.82.204.122])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-70cff552c39sm2341661b3a.136.2024.07.20.02.31.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jul 2024 02:31:34 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 20 Jul 2024 18:30:54 +0900
Subject: [PATCH v4 6/6] hvf: arm: Do not advance PC when raising an
 exception
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240720-pmu-v4-6-2a2b28f6b08f@daynix.com>
References: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
In-Reply-To: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

This is identical with commit 30a1690f2402 ("hvf: arm: Do not advance
PC when raising an exception") but for writes instead of reads.

Fixes: a2260983c655 ("hvf: arm: Add support for GICv3")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/hvf/hvf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index adcdfae0b17f..c1496ad5be9b 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1586,10 +1586,10 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
     case SYSREG_ICC_SGI1R_EL1:
     case SYSREG_ICC_SRE_EL1:
         /* Call the TCG sysreg handler. This is only safe for GICv3 regs. */
-        if (!hvf_sysreg_write_cp(cpu, reg, val)) {
-            hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized());
+        if (hvf_sysreg_write_cp(cpu, reg, val)) {
+            return 0;
         }
-        return 0;
+        break;
     case SYSREG_MDSCR_EL1:
         env->cp15.mdscr_el1 = val;
         return 0;

-- 
2.45.2


