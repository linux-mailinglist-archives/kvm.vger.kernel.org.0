Return-Path: <kvm+bounces-68086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 777A8D21498
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 22:14:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 006B33032113
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 21:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B90335EDA5;
	Wed, 14 Jan 2026 21:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sdsF1d6k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692BD35E552
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 21:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768425220; cv=none; b=FLXhGx1tW1aN45WmpNvlzHQCWECDtigEBaQ6ZQ9y0DNESzLEt+okIhnZJsfao/FjT8iD+OYQPQTFaK5wiLd5dgIouMdJLQp9CeBs9qvAAMW3tvzY5Mk4HTpTAkKYILcORwAsRMP7vL/oeQroUWr/VAxg7NnjPF3Cn6/gQbpZVOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768425220; c=relaxed/simple;
	bh=9jpWqsc8jBpbfaxxgNOKWHgIWX7+eHnVyX9ZaqegDoo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=EHV/oSJTS29UtlINFXVJt4+MuR9ylXzywCGRgpIgmgSVfCnn28q5qTwO/s2sxXozwXhi+ZzgkwuhMwxpOC0FoMXz/OIuG8z5mmseEIN+J5vjOXc5oaPxzgDZOei1PSnGfwuYRRuIFL+GrnawrD6+am2zi6AIom8cJFuhkfZbxrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sdsF1d6k; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81c43a20b32so142461b3a.0
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 13:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768425219; x=1769030019; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kRN9XFSrat55IClnp903+wyZKW1cV4xVvxk5Dw/CtqI=;
        b=sdsF1d6kRuaqJEEPkxI/TMVc+Z1+L1INjkrPLKBULvtUlVaXxB6C2+msS+NrBWCV7f
         puCYcyx2uwA3l75Xey9Pzvl3Wsh/hCzzQYYkUVM6oSPW8L/QkZ9o5R+GH7wCxkjyaeJ4
         rjG+H0rQav+BFEpbwyhhy4EHoIUWYe4GwtglaFACVlFJdpVtVnolPpeBE+KpqEuRK42H
         lwx2Y+SnQhmQFu1niydUqp+QfbYbUG1Xxe6iFdWx6uISyq5hRItTLiEyge9kDGESdjvV
         5zolocUmaV1Sj7xGfPnL18eQVCSGq3f3/Xh0dk/Sazww3y5BmsCcCCjixtfchkaIU3W+
         GfgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768425219; x=1769030019;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kRN9XFSrat55IClnp903+wyZKW1cV4xVvxk5Dw/CtqI=;
        b=jrYGOW9OY/uPTvXfZSzXuW1XK6NCB72UAObEqC9+9CoBX7EXHTYvhQxMzx5Q0ayHxn
         sK/jktz/a5quimegdKn8HTadOUrvpEOXHLdbW12ycKuMq3RoYP1tsHxfClNmtO6n0txN
         bT8bbn7tFyXHQElKUKHBSvJwrBjhbMJ+HJ4ypiNpAtx113LiTRWDZfNncthlPo4vgEaX
         jma1oh/o11LTAaQDaQG9wc7k1wuS9pqgf5vuVvTmOcIoCPfirATPqBI03zQDMe4RznQ8
         Vo4XV2/709ObAwSwdSql9w+JJ2XRLqauAUhcJlcU+mIDKymS5ePoGLMO3OrgA1zlm5Dl
         9g5w==
X-Forwarded-Encrypted: i=1; AJvYcCX1w+t+E1aqJMvpM9yr8B6FJ6dZxFGZ7dB4VYPP1D9TdRIpG8h23s2K5IWSgQAcDGEaPAo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxycRQLdMCVLgv2uscAzVw3OjQGFp8V1nqLGx62Q+BvHpJr+kj
	Ce8YOHMf/zBU352lbkQ4KEPvB7zQ/7z6ELbtBLchBB0HfORiz97uXPaYjvMutINFblCLmo5svIK
	uqiwFYNEHiaSfDQ==
X-Received: from pfhp36.prod.google.com ([2002:a05:6a00:a24:b0:7e5:3f05:3f6c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3695:b0:81d:a1b1:731b with SMTP id d2e1a72fcca58-81f81cee287mr3558018b3a.19.1768425218597;
 Wed, 14 Jan 2026 13:13:38 -0800 (PST)
Date: Wed, 14 Jan 2026 21:12:52 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260114211252.2581145-1-dmatlack@google.com>
Subject: [PATCH] vfio: selftests: Drop IOMMU mapping size assertions for VFIO_TYPE1_IOMMU
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Drop the assertions about IOMMU mappings sizes for VFIO_TYPE1_IOMMU
modes (both the VFIO mode and the iommufd compatibility mode). These
assertions fail when CONFIG_IOMMUFD_VFIO_CONTAINER is enabled, since
iommufd compatibility mode provides different huge page behavior than
VFIO for VFIO_TYPE1_IOMMU. VFIO_TYPE1_IOMMU is an old enough interface
that it's not worth changing the behavior of VFIO and iommufd to match
nor care about the IOMMU mapping sizes.

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Link: https://lore.kernel.org/kvm/20260109143830.176dc279@shazbot.org/
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/vfio_dma_mapping_test.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
index 5397822c3dd4..ecadd0e6b61b 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -162,12 +162,8 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 	if (rc == -EOPNOTSUPP)
 		goto unmap;
 
-	/*
-	 * IOMMUFD compatibility-mode does not support huge mappings when
-	 * using VFIO_TYPE1_IOMMU.
-	 */
-	if (!strcmp(variant->iommu_mode, "iommufd_compat_type1"))
-		mapping_size = SZ_4K;
+	if (self->iommu->mode->iommu_type == VFIO_TYPE1_IOMMU)
+		goto unmap;
 
 	ASSERT_EQ(0, rc);
 	printf("Found IOMMU mappings for IOVA 0x%lx:\n", region.iova);

base-commit: d721f52e31553a848e0e9947ca15a49c5674aef3
-- 
2.52.0.457.g6b5491de43-goog


