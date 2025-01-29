Return-Path: <kvm+bounces-36848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63966A21E7C
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 15:06:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF41A3A90BC
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 14:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8DE1E0E0D;
	Wed, 29 Jan 2025 14:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hOwT9Gmj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57AC1B4250;
	Wed, 29 Jan 2025 14:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738159380; cv=none; b=h2fMIEqANQITvCM+59LnWEpEpNXdqP3MFhXUNGG1FRrOinfY+A3YhlCMWh64230kNarT3WYw9WPCGoExfe2I1f8JP0S0pXi/IsJ+PrhmL4QhWlUukcTHzbH2RzDsZSrWr6QMzvYCWu4uApyDoe/cBo6JV0Aj7+n+0llkWhKYK38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738159380; c=relaxed/simple;
	bh=29j8ZbfZZys3Tq+aYvAEHgAt0+YHfEqx21MhQu6YHcM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kiovyup2yq5RCpUm4OziUeQrY4Y41dGDVCxyM08W51VP4sqRdln0qhkyyuuT/YMjYxdz/KqunlSHkjDrZ+GWMnGSVTwSZt+iOAJRvzwCDEcpLmLjU1/O4QdlXah0NsYGYGiNZ97cZ++tFw4W8LwT2m7HNn3MuG3/Sdj9c4RYsoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hOwT9Gmj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191A0C4CEDF;
	Wed, 29 Jan 2025 14:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738159379;
	bh=29j8ZbfZZys3Tq+aYvAEHgAt0+YHfEqx21MhQu6YHcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOwT9GmjcE/NiujkdpQDSVCD1mqQ8VZZ/2eyP7xPgPWVZX1lcBQtutz4GHLmUniVf
	 yMiUuB/2LqlgtNiO2+jA5XItqfcICGBicyy31tJBN3UwqkKq92ngMP1nBPhL8yFwFi
	 7yx/unwcKaKI66jr+lD+Me5XsvNqj2eZAYWN65+IIGi19+tNcTpvkvkLNyC7qfMKOi
	 5emC5vjpdFBrSK3sxAKrqi2b/tUYzOfcm/Hpb2m3l34xyyMjcYV/ttDeqfcafN76LB
	 kyo2LjW6F0dm/U3f261lWFXz0XnGCvOozm0QGwtXAKk7Pne8kRC20w9PF37OBlPbeq
	 Ms/PDBjJ91sLw==
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
	bpsegal@us.ibm.com,
	ankita@nvidia.com,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.13 5/8] vfio/pci: Enable iowrite64 and ioread64 for vfio pci
Date: Wed, 29 Jan 2025 07:58:58 -0500
Message-Id: <20250129125904.1272926-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250129125904.1272926-1-sashal@kernel.org>
References: <20250129125904.1272926-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13
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


