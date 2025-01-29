Return-Path: <kvm+bounces-36851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BAE64A21E9F
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 15:09:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A15FD18892EC
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 14:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E4DD1E7C08;
	Wed, 29 Jan 2025 14:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ckZEglV4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2112F1DF251;
	Wed, 29 Jan 2025 14:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738159408; cv=none; b=uzAKm8Y0vJ2ugTDy1vbEkoTIvcIYLJDfuZcz0qGDaI3NT10NkyuVaFfzTzfSs/7msST/vM0s8OeA5McS9iqrh5DadU5CgZJHx/fGtes38bC54tprtm2uRCtK3voV14Uejcj9iM/3mn4pbSjh5eiFgytZlAR+Efh7AaEfdflLrK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738159408; c=relaxed/simple;
	bh=29j8ZbfZZys3Tq+aYvAEHgAt0+YHfEqx21MhQu6YHcM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=URumpokmtX0Ga0q4Dw4KI+Wjxqy8l2RaC6fSl8NNGdbiWMGaNfOSXpiJOWlbmVE/yzt2yl/pbo8xQUPtFlsqGH9QWCZUdDpZSfEYdKnWt8u/0874nxEBNMxR9s6sewEySnLzqUxqkc3OcvWYjvDVP6F/IsBUbMsdQMhFjauFqIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ckZEglV4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881B9C4CED1;
	Wed, 29 Jan 2025 14:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738159407;
	bh=29j8ZbfZZys3Tq+aYvAEHgAt0+YHfEqx21MhQu6YHcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckZEglV4MhARyUMzWQv2+QedwUsT5uM5A4Y7LEqHp17erMI+p6m5Ep7E+iS7pM328
	 NDbvMx1KO/xdkYg5W/kIJz8lRzFY6heg37mBkzAxLolik4f61lsmIuS5lcPwnGj5wK
	 9C58MJAJXNTM4PwR0YV4FwhZyX393LvN28bLP7plhpQwoAvfQrMIXBDiFpwrRiE5Rl
	 8rQD0gmb2uS7YZOCFOzpbzJq/JWCdPhSlOQps3xJthxqbXmYhn/Vet8VAwSDv+6N74
	 u0PWwVti8QoG8QR3w+JL3+PJrjiz0tjDtzNUv+cNwMCU3Vs2ZYbE6p9QFk0q5AajN0
	 AxNbqmCwspleA==
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
	ankita@nvidia.com,
	bpsegal@us.ibm.com,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 5/8] vfio/pci: Enable iowrite64 and ioread64 for vfio pci
Date: Wed, 29 Jan 2025 07:59:25 -0500
Message-Id: <20250129125930.1273051-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250129125930.1273051-1-sashal@kernel.org>
References: <20250129125930.1273051-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.11
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
index 66b72c2892841..a0595c745732a 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 
 #include "vfio_pci_priv.h"
 
-- 
2.39.5


