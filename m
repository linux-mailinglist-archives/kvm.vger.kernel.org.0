Return-Path: <kvm+bounces-60502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E4BBF09C9
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:41:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08550189A64D
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A5B3016F0;
	Mon, 20 Oct 2025 10:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WFrCQzGF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838542F9DBC
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 10:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956735; cv=none; b=b2bGtokWUrS1HO22hGMOTMEyZ8Na6xNOhms5RLGOOQFGfbRG6wukf/VQEEa1G5z2JxdZ5+FABaVBbmYsn/sMGsT4LFW8hNMS0On7eUEbMvyf+of5NzGA9i0/8oLAaEGjfsN9ftJRQ53IQ5rGhlv+wQznhSJHRUCJAIacs+VjyEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956735; c=relaxed/simple;
	bh=hhbHkSkaXQlG5YNuuZyfYPTMWszpLmqd0kgPeH2ksf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iPYobCnA6OjwhIOYp3vR+Ni7Yf9l2m2tNeEJ0Ezqj+50VlP7/BptVJPBNZfwrwRFdcOXvJIpuhYkALud7JugwRScMKSPELW3S1K96BlJdQXpaAEH9IGTrr7lPr1+8kOM2077xs2JK/MqcAgHFtz/oGT6nO5uBW+62KKf8nYORdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WFrCQzGF; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4711b95226dso28950715e9.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 03:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760956732; x=1761561532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EulFVp0cdEgXrWVzzt34/e5jn6jKRx8ym0Wu/90Pz4Y=;
        b=WFrCQzGF4g3wX/2dfFSdyqfxO5MJuyNYdosU9P/3i2H6pUPRjEUPT77hShYzLstPg3
         CDck+Zzb2BQzRGUG+WgsWKySZ5sx69deAAJJVLhSNp6d+Pkk1d/2EUhYOZzY7ZtG7Dvm
         Ubr4VlHM7tGpifhNu0+reLqvLHu8S3IMdG9eS+VHchycArg/fcbpE3cS/jLd3kvGF0M4
         TvcNPFLgXv8yi8QymQFzcJhmuUvJYPwUice1V02dyeAzC9qKi9T0leoLIQamjEPsKBdV
         GmPNeRhdtBtzSF1EMTyFKGvurY/jIvnGAvimNkegBW/zrII+guqMOFwonhRrNhGJvUU3
         17oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760956732; x=1761561532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EulFVp0cdEgXrWVzzt34/e5jn6jKRx8ym0Wu/90Pz4Y=;
        b=XzzdIeKCpqqTt5czXzmfvM00jDxRpOuEGk8gf/UboMPjOEMEn7f/ttGRp/DK0mdBJp
         IObJRg8kDZObIqnxb4QvYaje/YN0wA2yMPxIX8zotHiSbfVuc39YDTO5SOd1KgzjK9c/
         7eJKgf7PM1xRMHifq+ZgCYmjmlIx1JYHBWLAeIe6z6qSVbPwY3RkbTOP3/IrpiV/Oc1L
         Ys2e/O8UMy26jHPdl+O6pnPPjY4R8G+xflEsVEX+hX/PFbjC1h5dXHFdbXe2f4EdCODb
         /ZwvnYP2XB3whJ2K77BZNxJOoiF68aaJY6agzkrRM9cvfPVotwD5FUyDYNRV9e2mEFXR
         SJ0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXfVbJN19OqTvmwKUXzBoWioatiAyBMgg0nXA2FZOzZz2orePoayYu3sjGOX99Xgxz90BM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHV75FOH6d8wxDG4PceoyfOH2AT0v/H6OYlUgSKHQwlmCnPXhY
	jyJfqP0qmaRRniErTuI9vELNlg1NgvICmF8uJhIasaJIKzHFnbpkjjODXzOrtr/x9CY=
X-Gm-Gg: ASbGncsFt470LzyTA//e5RxNz5MiHUdrDSzov27Nq0btf5Xy9A4TXlQZlkZRMUy81j8
	QQTAzMDbRyn0R87LOqCGMbgZHjI6ywLabyY3PsyLYfo/g4wehv5EH36Ov2KPst3GkCQ9UtwgmJo
	LLEobNcNDl8KZlZwUvMd+nell4mKCB90uaJkBkbYIPaTL6JFcv4N1Tc7JwfUdtUHyxf9jzBwbwS
	G21+C3xjgBhTZoLzZQ8eZZ1My9Yjee5NKMMBzetbgz1Gee/9PlJA/G+esWUlwRckN1EBmenlmCg
	uHwo470f4VIcLcqWa4njiXXdCLv1VrSvsyx2Zez/ddpsSpU4jWflDKN5IFSatK5sioT6mImo6su
	3zQhTMCdt4gU4oTpwKQGIiN068Mh80lBpv2km7lNllR+TDZ9LPutXiaWoPvqmtU/QC2YJyHmdks
	Vxsr7k/TFMkAV4vL8g4ytA8sjYg1HpeEvIjJERN8/X6Mx5bOwxBg==
X-Google-Smtp-Source: AGHT+IHpRuvJt+vq6kMbYDeKVQiSVG3/mEBkDhXe9vJ1QjRj/WkWk4DI1OronxDF+lp7sfbpdSzGPw==
X-Received: by 2002:a05:600c:3e86:b0:46e:36f8:1eb7 with SMTP id 5b1f17b1804b1-471178a3a94mr89203075e9.10.1760956731887;
        Mon, 20 Oct 2025 03:38:51 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711442d3ddsm220057205e9.5.2025.10.20.03.38.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 03:38:51 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-ppc@nongnu.org,
	kvm@vger.kernel.org,
	Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 07/18] target/ppc/kvm: Remove kvmppc_get_host_serial() as unused
Date: Mon, 20 Oct 2025 12:38:03 +0200
Message-ID: <20251020103815.78415-8-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/kvm_ppc.h | 6 ------
 target/ppc/kvm.c     | 6 ------
 2 files changed, 12 deletions(-)

diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index a1d9ce9f9aa..f24cc4de3c2 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -22,7 +22,6 @@
 uint32_t kvmppc_get_tbfreq(void);
 uint64_t kvmppc_get_clockfreq(void);
 bool kvmppc_get_host_model(char **buf);
-bool kvmppc_get_host_serial(char **buf);
 int kvmppc_get_hasidle(CPUPPCState *env);
 int kvmppc_get_hypercall(CPUPPCState *env, uint8_t *buf, int buf_len);
 int kvmppc_set_interrupt(PowerPCCPU *cpu, int irq, int level);
@@ -134,11 +133,6 @@ static inline bool kvmppc_get_host_model(char **buf)
     return false;
 }
 
-static inline bool kvmppc_get_host_serial(char **buf)
-{
-    return false;
-}
-
 static inline uint64_t kvmppc_get_clockfreq(void)
 {
     return 0;
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index cd60893a17d..cb61e99f9d4 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -1864,12 +1864,6 @@ uint32_t kvmppc_get_tbfreq(void)
     return cached_tbfreq;
 }
 
-bool kvmppc_get_host_serial(char **value)
-{
-    return g_file_get_contents("/proc/device-tree/system-id", value, NULL,
-                               NULL);
-}
-
 bool kvmppc_get_host_model(char **value)
 {
     return g_file_get_contents("/proc/device-tree/model", value, NULL, NULL);
-- 
2.51.0


