Return-Path: <kvm+bounces-36655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4699CA1D68E
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 14:25:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DC3D1886A67
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 13:25:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2CE91FFC42;
	Mon, 27 Jan 2025 13:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="TEzktzXU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1061FF7B7
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 13:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737984290; cv=none; b=PKKgPJCR6d9wmWb7GkMQfQOLBmrxeCY8vamEH7YNwImst+Z3z3zUWsJvBYCiesUNvrfYCzDBOJYnAHh/e3kodXiJI9ZTfcWShXkJgvRtUKPOuovTsTLNl0Rvy9pmcjcFzjgL22k8oFgKZsvT0UlWbI+PfHXjG0NVDR47aUIE+1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737984290; c=relaxed/simple;
	bh=o/ewUvj7RU/GZjGbzLQHQPJ/UU+05zxOVt/R9+IUHcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxSTftrUHOi2GqtHU5BMPwigwoCYCMhJ6EFI9ZDuxbVq6+Lcyh7K27Cq8T/pMkDSQoAWhhFY32MnL6LFownxE1pR6gskjNkcMn/Sj21eLSGSClqbGAtlzULNSE9lSZkiQnXiaSMu3EZb2OTJGVAHI84vE2bpKdPQpHn4gfepi8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=TEzktzXU; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ee86a1a92dso6030711a91.1
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 05:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1737984288; x=1738589088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5xtw5uZR6yestfXGBMo34I3qkb2MJ1etd1jvG4X45hA=;
        b=TEzktzXUBVgslHGxhM873RGlS1M7Dm8bZyEK1eREDN5rk7y4WCl3GCGSCgLAJBSHwd
         V2Uk5Lw7UUBH2oo8vy9UFlpATzZb6+RHewaXN7L0F+5uJjBOTDmBXycBRewMR2i3ocrS
         +aCFil5evleCbzI7IZZWCXrgqFyJR5+4aQ632ycVtnD4EeYAzPerawfWGmf4yjCXdQUj
         t9LUW737B3XRU62HusMbCUoj/skbl3Ysm8V1cZpZNme61dUXu04WTrE6XxoYO2LjMqjf
         eKS57ouovXUDsqd6g5K9IOzr8ARhQecEjwWWtXQDWJDMd0OKPYqgDBfEODytI4/GHJt+
         Q7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737984288; x=1738589088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5xtw5uZR6yestfXGBMo34I3qkb2MJ1etd1jvG4X45hA=;
        b=p+nPtNLuc8jCXWcTwc8Fdz3zzpEqB4K0MGHKogohxgbNxdIPMXiIPuJkyNq0V7Cyg0
         eeJ5Q5a0cTxOLsk5vUIWZOCRLK0f1iPYuJ4jui0xlyCRmsCG33Xc0x3cbxJvC7di3siI
         JPTXppEnwldKC19bfDBb8GB1/TNcmQkrWI7OnYqlA3rZub70gKFqk5bzpZiMv7aYY5Tm
         71qZTfaqr6cp9DUGaEJKNMuC3L6gRb87KAMZmRq+99UouPfKujtmkug4meklMh5IfdZC
         5u/8tCMv2YMqR4XVvpK4dvZ0Mh+PZxxVxz3JFZUQ74UT+3LRc6bOYpwyF0E1TjtiyQCk
         BOYQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8Gyr6B/NHiAuwtJhK7iFfwX1qS71MOeT1Xyigvi7emICBEAK3lzqDTj7iopWkEJtS3IQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOvNjTEplIHjMAScijys+x9ghOjxGeicATuuYnH6YjVTqQyJL/
	thILVA8ijQTePJrQWp5m/LvyuR0Btlkk5sifFJDjvukriWPNdhZiqyOr/qZtnBodhIDzljCjjD6
	aUH0=
X-Gm-Gg: ASbGncth5jonjVzlOgpjRc5T3t0vI6r5tAB+RBA3KZP1t4LlkgND3Jp2mUvBo+sTSzR
	wKzfwb+LpzLfBBR63vM+q1ohVg+wic1BGvU+ziNoGlomce+qgX0SNTyIK78WkHmvyOaQPDOAXg1
	YibB/2x0oKhM4aWnOlOPerAlF1IvuPHtIzyNl0MsNRqkdWkDHRgEkoBmOHLYx8qH5g+q+4HkcPe
	/9Wu4BWi8xs9yjpjdFeKNZhPWzftvsU4UT+3QHa+klG31B2SGpQkUSAQL2Qg7yF+mHPuiDSexvD
	Q1JbS87kmmwMw8BOFjiziROWuKpq3dt73mMYNsdXBp8B
X-Google-Smtp-Source: AGHT+IGLbe7E4P3Z6l8sjXpD25QC5kWy8u2IACPAdHUxgjERIJURZuTOxMhW2ArZVuocc/wEWDWWpw==
X-Received: by 2002:a05:6a00:3a28:b0:725:e405:6df7 with SMTP id d2e1a72fcca58-72daf94858dmr53566206b3a.10.1737984287885;
        Mon, 27 Jan 2025 05:24:47 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6b324bsm7268930b3a.62.2025.01.27.05.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 05:24:47 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 2/6] Add __KERNEL_DIV_ROUND_UP() macro
Date: Mon, 27 Jan 2025 18:54:20 +0530
Message-ID: <20250127132424.339957-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250127132424.339957-1-apatel@ventanamicro.com>
References: <20250127132424.339957-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The latest virtio_pci.h header from Linux-6.13 kernel requires
__KERNEL_DIV_ROUND_UP() macro so define it conditionally in
linux/kernel.h.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 include/linux/kernel.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 6c22f1c..df42d63 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -8,6 +8,9 @@
 #define round_down(x, y)	((x) & ~__round_mask(x, y))
 
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
+#ifndef __KERNEL_DIV_ROUND_UP
+#define __KERNEL_DIV_ROUND_UP(n,d)	DIV_ROUND_UP(n,d)
+#endif
 
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
-- 
2.43.0


