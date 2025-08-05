Return-Path: <kvm+bounces-53968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 53C98B1B04B
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 10:40:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF2091893862
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 08:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19385256C9F;
	Tue,  5 Aug 2025 08:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IM+SVRXP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F00D21858A;
	Tue,  5 Aug 2025 08:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754383191; cv=none; b=NiiUmFQmar4ilWPyh7Zk58xnPThG/d89oSF+NHILvEO3huGAlKK/Mews/UBajOXSQHObw04xZLvp68tQXkzweQroZ0zVwf701TgJe3RLwGXdZo5qm7lFVnhtCNuTfqe5j00vv1EgWmJSzC1G5p/k/PLbnsSBWI7ZixAkBp56Qa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754383191; c=relaxed/simple;
	bh=8dCG009f28I/T5bh9HQ/pnDB0yMf2J3CDokXMRqyBlY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sMZhvliQqxImHPZuTPTRyrSthNnU3lo2RH/tVg1zL/2ywChOPi+BlN87yTSWKkAIyKzEcHtomN3fg3BAd1PmdxSoRrgaFxhwC2KxHx+ErMARStYJFMwhsLbONRiKgGic+/D+G9CsqWoBiyFcALKHuGIrhoqRasSAZDVPWikL9tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IM+SVRXP; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b7910123a0so5195483f8f.1;
        Tue, 05 Aug 2025 01:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754383187; x=1754987987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ckg82r4yV+jVyEN6/rbJQCfYznBxYrDG5d0BRS6lfPA=;
        b=IM+SVRXP8ZSLnb2XuwdPrp572BhQZ2smXtf35kH87yuMAXq26aga/4Te9d7Zj/9f6w
         q3kJ16R9ACEKWlU/rQ3JKrkwg5ZBblZBckaaV858u06HlzY3OQ5jom9IZ6z7JwZSqTVS
         HULnjMAZhmwOpQgEmRt2Ej+9kCb7qqXAvOBnLVi4qlFnvgiKZs/Q4srjNNw6znJPNkGd
         pxVpBofE80hTr0h005JREFIG0g3wJuinx/UiT6HaSHXx5YzYMs39+DS4SUJDUP7kTdfC
         2r5ptWwY0EEpFmVcwYKi2jgX3M7f4iQE8pFALKb+7XdVIwrDVSfkIdWCRyvJ3EORPe/c
         8Luw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754383187; x=1754987987;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ckg82r4yV+jVyEN6/rbJQCfYznBxYrDG5d0BRS6lfPA=;
        b=kmyozib2Fn9GheLd5IGsgMmk//+JJSg5dTQ6o9I/tchB/WVH+/2HCI2ZtQcV9gZzpb
         LBAR5BOyjIxjzleR7+k4f74ybLgG6JQqtxntq9tOFqq6ekPE8rWcjud259ng+qwxT8Tm
         HCa5N2cCJpbJT3C2v4B/K3UvAOSvltkjhQNf5ORmAF0aKbcyiW4vhtC2NzO6i2ToQ5tm
         c81z6QKWZMXacrb0xHVLiIk/G2DzmkLoaXXdq9Oi20Uj5d0uBG4heEOTzje2FIbrR6Fb
         HDGhlaFNobIpOZ3Ua+FW2KnGp4MJmog+RpCl817CSioHCaDigh/sgTPfYObr4dbqMMsq
         4ClA==
X-Forwarded-Encrypted: i=1; AJvYcCVRR8isWlVYt7QFKzz9DHFl+woKTH/X8uvlMdLPZHO3BCpJ1qf3x8oBn6fftjZnaKLxaZg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzESb/r2mNOb5Wy3h9sFhEu56zHaQGnCsl4rKXXt752qcWKFPU5
	G448gpP5pJ5ACZpLEj5XYWaayL77Z1ktz7TDqvjoR/yrCcGY5kD+0tfzLTVk4A==
X-Gm-Gg: ASbGncvKhT1/dS4GEWt6lTuEqDA6aaA6GIhTtAIkItpaIUW4YBdZPfTRiF+u8cpoOpG
	Y10frlphD8nsIfBi6u0/N6aEUyLMwEJ9yxsgtzJ63RWsktv8xliQLlXinuGoVv9tn5WK9sEGpN0
	QeuaD9rHKsQsy6/o0GBVhMxPVpH+2bNxi/vsAPb6wiZuq8v+MhOUUwdPp+lskox33z0PjZ9PdkI
	qMYeuV1J3jB0sWqYWKAPZGdGH3hTUSYttjoYueKsYnVtfsIKeNsgWJ1eNzwS0Gr74QpRuK/tXs3
	3WkUR2hI+01DvC0+TZEnWTgYr+QyznpZj9076ejqK1stNSA/hNOve0y4DfEEqhMus7cpCFkicdg
	hyrIEkNvGtpz6CQMrLG5aes4Dwpy/MV5p4w==
X-Google-Smtp-Source: AGHT+IGUQ1CC3wGSqX3n2PthCP5i+TNxzdsTjL4pSdzIgtsPUjcOZd6wwrDmOy2lPNXfqcrUwsVwCA==
X-Received: by 2002:a5d:5f4d:0:b0:3a5:2ef8:34f9 with SMTP id ffacd0b85a97d-3b8d94b9fb6mr8792134f8f.27.1754383186844;
        Tue, 05 Aug 2025 01:39:46 -0700 (PDT)
Received: from shameer-ubuntu ([195.11.233.227])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-459e00187f7sm39201055e9.15.2025.08.05.01.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 01:39:46 -0700 (PDT)
From: Shameer Kolothum <shameerkolothum@gmail.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: alex.williamson@redhat.com,
	wangzhou1@hisilicon.com,
	liulongfang@huawei.com,
	jonathan.cameron@huawei.com,
	linuxarm@huawei.com,
	shameerkolothum@gmail.com,
	shameerali.kolothum.thodi@huawei.com
Subject: [PATCH] MAINTAINERS: Update Shameer Kolothum's email address
Date: Tue,  5 Aug 2025 09:39:13 +0100
Message-ID: <20250805083913.55863-1-shameerkolothum@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

My Huawei email will soon bounce and hence change to my personal
email for now.

Also, since I no longer have access to HiSilicon hardware, remove
myself from HISILICON PCI DRIVER maintainer entry.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Shameer Kolothum <shameerkolothum@gmail.com>
---
 .mailmap    | 1 +
 MAINTAINERS | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/.mailmap b/.mailmap
index 4bb3a7f253b9..0d0f689e0912 100644
--- a/.mailmap
+++ b/.mailmap
@@ -700,6 +700,7 @@ Sergey Senozhatsky <senozhatsky@chromium.org> <sergey.senozhatsky@mail.by>
 Sergey Senozhatsky <senozhatsky@chromium.org> <senozhatsky@google.com>
 Seth Forshee <sforshee@kernel.org> <seth.forshee@canonical.com>
 Shakeel Butt <shakeel.butt@linux.dev> <shakeelb@google.com>
+Shameer Kolothum <shameerkolothum@gmail.com> <shameerali.kolothum.thodi@huawei.com>
 Shannon Nelson <sln@onemain.com> <shannon.nelson@amd.com>
 Shannon Nelson <sln@onemain.com> <snelson@pensando.io>
 Shannon Nelson <sln@onemain.com> <shannon.nelson@intel.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index c0b444e5fd5a..424cb734215b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26038,7 +26038,6 @@ F:	drivers/vfio/fsl-mc/
 
 VFIO HISILICON PCI DRIVER
 M:	Longfang Liu <liulongfang@huawei.com>
-M:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
 L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/pci/hisilicon/
@@ -26067,7 +26066,7 @@ F:	drivers/vfio/pci/nvgrace-gpu/
 VFIO PCI DEVICE SPECIFIC DRIVERS
 R:	Jason Gunthorpe <jgg@nvidia.com>
 R:	Yishai Hadas <yishaih@nvidia.com>
-R:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
+R:	Shameer Kolothum <shameerkolothum@gmail.com>
 R:	Kevin Tian <kevin.tian@intel.com>
 L:	kvm@vger.kernel.org
 S:	Maintained
-- 
2.50.1


