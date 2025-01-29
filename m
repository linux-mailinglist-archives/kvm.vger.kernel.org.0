Return-Path: <kvm+bounces-36858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48C09A21EC0
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 15:12:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0906E162EEE
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 14:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55DA712E1CD;
	Wed, 29 Jan 2025 14:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBo8ZZeM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A03314AD0D;
	Wed, 29 Jan 2025 14:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738159454; cv=none; b=IXmfNoVEAGHSmc3v9b72SONXm7CJH2hxNjL7WLEBIuVcYlbiY0vKncQKxXT45oDqXdHze3+6K9E5k/9JWEzMyrTKGUOPQSPcjmxq0524aF6fYFxKyK8eSol9g7EIPRSX0kArosLOFFGrB/8VYUQ0oVz0vGqSeeKMDqvLde5GqiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738159454; c=relaxed/simple;
	bh=6uHuE31SFgCh8Tk5sWIhV+CwlgPPY3qcX2ZkNicPk1M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lQfnXB/U2I6yJR7DwpVCD3yeI4sli5Sl8DZKhbvLZLalJ4KRomNytn5i4UDY0Bak44OWsdfiE1uhDUurc3dIYy5ULcFGaddm2mBlchRMo25oP2FibROlbRrkIxTqFmzI61COIs+hlsW8VfxqgVB8GnekMlpr6XRU4YwaQsmwyKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBo8ZZeM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81EAC4CED1;
	Wed, 29 Jan 2025 14:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738159454;
	bh=6uHuE31SFgCh8Tk5sWIhV+CwlgPPY3qcX2ZkNicPk1M=;
	h=From:To:Cc:Subject:Date:From;
	b=NBo8ZZeMfKwapvBpHo2tLE1gbJv0qH4qVRcDb40Wyd8PbkNwiHSuoGt0T3rLX1v2c
	 cWANpPkFLKiZivazf9g6wvOJbY00ON0LOr9YBYVANVjkIuKBpNk5E7qWlSrk6FpjK+
	 HgKoJFHDtUeFrWjXtkYsytRBk09Qxz/+bYSV2dtl08rvnIT9oV9Vi7eBGuR4kAUF70
	 DeixB1QFgbM7AUF03Ew9dnPA/vH8sGy15VCutLPA2WSSD25/PPsDFlkkjc/qsINC+C
	 upBWYT+qCHqeSPOPduLUb3X3+PgjnmE3cr+FQAbtW3vKfe96YPUVBu7iRxlDxrsESY
	 vHZ8LD6uE2gnw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ramesh Thomas <ramesh.thomas@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jgg@ziepe.ca,
	Yunxiang.Li@amd.com,
	gbayer@linux.ibm.com,
	bpsegal@us.ibm.com,
	ankita@nvidia.com,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4] vfio/pci: Enable iowrite64 and ioread64 for vfio pci
Date: Wed, 29 Jan 2025 08:00:29 -0500
Message-Id: <20250129130031.1273301-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.289
Content-Transfer-Encoding: 8bit

From: Ramesh Thomas <ramesh.thomas@intel.com>

[ Upstream commit 2b938e3db335e3670475e31a722c2bee34748c5a ]

Definitions of ioread64 and iowrite64 macros in asm/io.h called by vfio
pci implementations are enclosed inside check for CONFIG_GENERIC_IOMAP.
They don't get defined if CONFIG_GENERIC_IOMAP is defined. Include
linux/io-64-nonatomic-lo-hi.h to define iowrite64 and ioread64 macros
when they are not defined. io-64-nonatomic-lo-hi.h maps the macros to
generic implementation in lib/iomap.c. The generic implementation does
64 bit rw if readq/writeq is defined for the architecture, otherwise it
would do 32 bit back to back rw.

Note that there are two versions of the generic implementation that
differs in the order the 32 bit words are written if 64 bit support is
not present. This is not the little/big endian ordering, which is
handled separately. This patch uses the lo followed by hi word ordering
which is consistent with current back to back implementation in the
vfio/pci code.

Signed-off-by: Ramesh Thomas <ramesh.thomas@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241210131938.303500-2-ramesh.thomas@intel.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 83f81d24df78e..94e3fb9f42243 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 
 #include "vfio_pci_private.h"
 
-- 
2.39.5


