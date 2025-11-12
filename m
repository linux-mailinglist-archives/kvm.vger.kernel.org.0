Return-Path: <kvm+bounces-62927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 288A1C54213
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 20:28:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B99383A7195
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA5234D913;
	Wed, 12 Nov 2025 19:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1+npGwQ3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477C1335091
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 19:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762975367; cv=none; b=fkVlwyf96y5doeaaAMGfuhtlehjNKCJwzzogURzPvj8Btzo7r6obdctdX8344qVooWB8tgRD8daYvxlZnovGn/7xPpZ3nMngrY/b6xqj/6GgIxZ4XKx8taChudclEr7r7dH8V/OgBhOM4gHikdqNWmO1jhlKlWEyiuyJIq1dOrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762975367; c=relaxed/simple;
	bh=kHKKv2ke2cj+MGan48Gu3BEFyapAdjSg49umcHRC9vA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EBbr8S8gJh7sdrUEqGm/IhVxEfDgVQviR6yAVlmt+FEh+SHyV3SwDBSEwlMy69cfn5fGpglhL0w8lGAdFsm4TU9qcnl9UCEU3Y6pCLWDay//TjjDUB4QoTk/b14jgH3gxAhOXrsXTfzKipsZh8N1aRnE/mypYLWEA4igJYfy1lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1+npGwQ3; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b6b194cf71so1302799b3a.3
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 11:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762975366; x=1763580166; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TielaAcMwqrNYs1v2uchxf5jnX6Kggt/DIe0BV32lMw=;
        b=1+npGwQ39fbkIxeyi70rwjdIW6YuVJ/TvnGB2ZvWcqDloF97am3ND3zhD6X4n846ts
         ES6MRkQ6f6cfRGjT9Wqxrv/LrzqonTqCDcvFIJsgjN29Ybj46+3lzOX4C96fcFjbSza7
         zZogztmU2ZiC+qbS/2LhNdOxqcio6Q0FX+F0oLaIKCQL83UO4IfoutkAV0A0mpHPl5N+
         cSviXL7PcbLY0A3LckD7UNul+lFiNha44Gw45LfhcC+jCcbIrlTmHQTz5vXVjArWk+r2
         4/K/v93juaGbhbWnABn32ftnRAFTEXLIZzg0bOECh13hvFiT9JVAuovufefQTBPvwbHx
         w05w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975366; x=1763580166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TielaAcMwqrNYs1v2uchxf5jnX6Kggt/DIe0BV32lMw=;
        b=Dew+Sdh74U1MMxVRvOq1SudqWc1D1KyYf0CBexwUk0kuLvwlq+5mSy6zrA/oug+BCt
         h6pPf4tITf4A5WBEqWOC69w1zMwxPkIcXhORK5tivZDTQTOzBE1UskszkITDHo2YhpN6
         o/LZAwSKD0L/eDsh43lBLtuf9fzAACKWFRqQqPoUPWdDp3wFdt6IoQEAb8m3WkEAI9pt
         Rr8W4RJV/mZ1E1RUyjGgpO8vh6lTs+g+SzBdO7FNmC+XcoSVfmKo0SnKlJ74T69DYPQG
         PNjjqerMOGxyhA5bfMkjNT5VEoxjnwt2Lm/zjzigwg+qCuPvJ0MVBAQNb+LoLt7HQukU
         IhFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaM4vrH95SYCi8NiYmwqBMbYg5+rqYV0u7IF38pAcR/oHzHn++JRVyy1q/UieuITLqvuk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZhqsPeuTATjik6PjFuPdE/R72txEFhyGB7b0PBxP+hfzS1rrX
	SU/j7YHVEWbtpjpzBOaHmvdnhHR2oTV8z1gSBsoB3yWJBEfcb3M3zbaKBzzECix8lnX9DeLhqoV
	J0WsSqr5JjtrcGQ==
X-Google-Smtp-Source: AGHT+IHuFbrloR0m5blvPVZxF8h+Pqt2VSx6nAyL8MWcwWU6Pe/6lCA8dytMd0H7li6ZJ6bRtnj5aFgRaaAlPQ==
X-Received: from pfbbx6.prod.google.com ([2002:a05:6a00:4286:b0:793:b157:af49])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:a109:b0:350:8dd9:7a90 with SMTP id adf61e73a8af0-3590ba1908cmr5304730637.43.1762975365575;
 Wed, 12 Nov 2025 11:22:45 -0800 (PST)
Date: Wed, 12 Nov 2025 19:22:15 +0000
In-Reply-To: <20251112192232.442761-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112192232.442761-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251112192232.442761-2-dmatlack@google.com>
Subject: [PATCH v2 01/18] vfio: selftests: Move run.sh into scripts directory
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alex Mastro <amastro@fb.com>, Alex Williamson <alex@shazbot.org>, 
	David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Move run.sh in a new sub-directory scripts/. This directory will be used
to house various helper scripts to be used by humans and automation for
running VFIO selftests.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/Makefile             | 2 +-
 tools/testing/selftests/vfio/{ => scripts}/run.sh | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename tools/testing/selftests/vfio/{ => scripts}/run.sh (100%)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 324ba0175a33..155b5ecca6a9 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -3,7 +3,7 @@ TEST_GEN_PROGS += vfio_dma_mapping_test
 TEST_GEN_PROGS += vfio_iommufd_setup_test
 TEST_GEN_PROGS += vfio_pci_device_test
 TEST_GEN_PROGS += vfio_pci_driver_test
-TEST_PROGS_EXTENDED := run.sh
+TEST_PROGS_EXTENDED := scripts/run.sh
 include ../lib.mk
 include lib/libvfio.mk
 
diff --git a/tools/testing/selftests/vfio/run.sh b/tools/testing/selftests/vfio/scripts/run.sh
similarity index 100%
rename from tools/testing/selftests/vfio/run.sh
rename to tools/testing/selftests/vfio/scripts/run.sh
-- 
2.52.0.rc1.455.g30608eb744-goog


