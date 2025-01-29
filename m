Return-Path: <kvm+bounces-36856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 029E1A21EAC
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 15:11:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 715F73A1763
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 14:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77CB91DF97B;
	Wed, 29 Jan 2025 14:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nLYZ+7H8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983A21DF974;
	Wed, 29 Jan 2025 14:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738159438; cv=none; b=hQPmkP5Y25CyYDQRCJx8ERw/C+AAZEi07blDlRIHnPLDUPjiNO+i5xTpQybvIsJFnPr0haJtfaYV0FwQ+QLvREptImelNRAUQnKjaGF/kjHzAcYpNjX824p3zcDAUR4nstkHCi2ckXPOc0LRQtLmtVjmHcDrSRdt0eaB/G0aOD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738159438; c=relaxed/simple;
	bh=+BbjqapLWgwNwtRu+pif92ucwcNIIB21ijmEwEHHLks=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D/LDK7RUYFoWe5hbmmxIpLd276dYHPjcvhDRcdmSEFN00bt6qNIv+xxzP8y8xI0VdMUgW0gLEgQthz3iui/lRJ12VMBNfmvWA/hpA8BeCu6NL67gp+gboWPRQo/9dJkfDVd3B2CKMi0fB7fGt1LYGq79jHdim8zBAQoolPCOjJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nLYZ+7H8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44282C4CED1;
	Wed, 29 Jan 2025 14:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738159438;
	bh=+BbjqapLWgwNwtRu+pif92ucwcNIIB21ijmEwEHHLks=;
	h=From:To:Cc:Subject:Date:From;
	b=nLYZ+7H8nn4WeVGhniA4lGk8B1nfWc3EAEIamTYS9vGwh3e6vIFsGgiq59WNvD9jr
	 ndoKi8Y0qcIac4Z1CtDs18HIv7ZVpHpWk/U1eDiBaQjMiw6ab07g/EzCui+KhuNuSt
	 O9XDn+NrvsDX7/do5LDMlSZPssGZs9liB4z+Zo3IGIkaKaC8yANf0nUH309KWZjORu
	 rPs+F+1qSXMUaPwDw+B3947oEjo53/5tgZs3u9P36szNvJM8qMiNsOz3W2u9Rqke1a
	 0CpeLHI53jrZoSa3i4k//SzTn+3h0MZrxcUlR6Ybbt3uiioC12rcY8X5VChOsdph2a
	 TMVQHX7Ehw0hQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ramesh Thomas <ramesh.thomas@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gbayer@linux.ibm.com,
	Yunxiang.Li@amd.com,
	jgg@ziepe.ca,
	ankita@nvidia.com,
	bpsegal@us.ibm.com,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15] vfio/pci: Enable iowrite64 and ioread64 for vfio pci
Date: Wed, 29 Jan 2025 08:00:13 -0500
Message-Id: <20250129130015.1273244-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.177
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
index 82ac1569deb05..e45c15e210ffd 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 
 #include <linux/vfio_pci_core.h>
 
-- 
2.39.5


