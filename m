Return-Path: <kvm+bounces-25030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06EA295EA34
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 09:17:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6CBADB211D3
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 07:17:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A12812CD89;
	Mon, 26 Aug 2024 07:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p0OdKM84"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467E6376E6
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 07:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724656622; cv=none; b=Gte5B0fE6mwdCzAjmQTsoz8ow1tVddX1nFBAn/ml7FIuTnJCjeJcmp7CNkypNqE5c4SXsQDNiS3fR/ZzpSIGZiClTvlG+h9xj9BovDsCUPb3d0OD3BQu/NbMRnTC/tcJqTFX66fECxhIS7j/CAIJbnvF8SjzZfS//0ES7BgQThM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724656622; c=relaxed/simple;
	bh=nkaV0XfZaGR8p4drm8Z0uuSWaFZNEisvVSIAR+WDUHo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HVaiRIntJL3jlmPUH4RxwUANTBmS8ww3H+kKqIkWhOc0F3U9dqP+0zusgEbNbDmdov5xz936KgiWrdk1mfRlrPcrs5BZWObTxZM9fV/J4xg9xEClrNNscIg9G1l07HMG0PvnNraDHG8XrPGNaamSjUf/nBNpvvKLD5sjyYXDH0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--manojvishy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p0OdKM84; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--manojvishy.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6b46d8bc153so76180317b3.2
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 00:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724656620; x=1725261420; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BRShtYLZmJBPJSHqgx4PDt4rvJ58jLkk96vd1/jbIvg=;
        b=p0OdKM84gBXJQraTCLy+tSZWZKE2YyZmYtlJsAWjKLlagKalCjqqJQAuusiRpaDsor
         zfOA0vVU4rSNXLJ+tUmTm2wint3ktYkHWEZwW55ohL8Y9rctI8wAQ9YIuW6sbIYjPL08
         Re6ScDz5ZIIjo1Bpst30tI3JYc3wrCMQI/8/hpvwU0njyNl3ymyf5E4stUH22FI4FmVe
         uZ5CSzOd1Gt6O32FTMZ6TMLQIG4U7PzmLFT5UFvZSpunJuETvw14NyIvKu3ltHnL2XxM
         q3Fvtay8g4K3KYSqdwVqJ7e7PMCp6QSTfEfa2eNMwkNtcnC9BU4yxiXxhZ4gFTtzMfLd
         JIag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724656620; x=1725261420;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BRShtYLZmJBPJSHqgx4PDt4rvJ58jLkk96vd1/jbIvg=;
        b=gIFvSo5vXjyuyLiwiP2lxOBC4dPC+6M64sxRC90c8UBEYNz0u3vHdvw7yR/4v5Eqa3
         L6TYf4aI0elb2zdg66LMR7VhB8IethZPyL7VffwWie+4KBmd7BXTLZXMnQ6b7k4EW90J
         qXT0S9vTiqP3vsXdIIKHngFJq1HuY8mZfKvvYXgV5h5hh+NcspXr0NBHk5GE7/F4iS/u
         xkvI/kS8OdJgUzIfwaENjfPmEYJOQt8FWLsgSY98ocrXofirlDxIDeBepyKCb8i7Idd8
         ccJ48bcO7q4lWDgd1TM2eEouAzK+YqTPHPBzF/L3RWL8XO7AMn0vkAUeBoTaag+Uh2tb
         6RJg==
X-Gm-Message-State: AOJu0YyZaquehrD22sN+zRsSYrtZefoohcKXskMhEkfdsjJ3Gr0aVURj
	5W/QqGQYn0Q1hgt95EI8pLjePBjFY4DfIgfQsySg1JqhRZ5IUzIqIRJFrdVd5DYPvvmMjMB0WS3
	KBcWxbFpAPg/den/lwQ==
X-Google-Smtp-Source: AGHT+IFvc8OHSGEhjIEIYer2jfp9QrAbi6exBOTouXCSVWGbyUY3HkgdonvtEDMyxk52fnOPsWuReZ1tNXp20tcu
X-Received: from manojvishy.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:413f])
 (user=manojvishy job=sendgmr) by 2002:a05:690c:2b8c:b0:69a:536:afde with SMTP
 id 00721157ae682-6c627d07c73mr623137b3.5.1724656619604; Mon, 26 Aug 2024
 00:16:59 -0700 (PDT)
Date: Mon, 26 Aug 2024 07:16:39 +0000
In-Reply-To: <20240826071641.2691374-1-manojvishy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240826071641.2691374-1-manojvishy@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240826071641.2691374-3-manojvishy@google.com>
Subject: [PATCH v1 2/4] iommu/io-pgtable-arm: Force outer cache for page-level
 MAIR via user flag
From: Manoj Vishwanathan <manojvishy@google.com>
To: Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Joerg Roedel <joro@8bytes.org>, Alex Williamson <alex.williamson@redhat.com>, 
	linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	David Dillow <dillow@google.com>, Manoj Vishwanathan <manojvishy@google.com>
Content-Type: text/plain; charset="UTF-8"

This change introduces a user-accessible flag that allows controlling
the system-level outer cache behavior for mapped buffers.

By setting this flag, the page-level MAIR attribute will be forced to
use the outer cache, potentially improving performance for frequently
accessed data.

Signed-off-by: Manoj Vishwanathan <manojvishy@google.com>
---
 drivers/iommu/io-pgtable-arm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index f5d9fd1f45bf..31dd6203db96 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -471,6 +471,9 @@ static arm_lpae_iopte arm_lpae_prot_to_pte(struct arm_lpae_io_pgtable *data,
 		else if (prot & IOMMU_CACHE)
 			pte |= (ARM_LPAE_MAIR_ATTR_IDX_CACHE
 				<< ARM_LPAE_PTE_ATTRINDX_SHIFT);
+		else if (prot & IOMMU_SYS_CACHE)
+			pte |= (ARM_LPAE_MAIR_ATTR_IDX_INC_OCACHE
+				<< ARM_LPAE_PTE_ATTRINDX_SHIFT);
 	}
 
 	/*
-- 
2.46.0.295.g3b9ea8a38a-goog


